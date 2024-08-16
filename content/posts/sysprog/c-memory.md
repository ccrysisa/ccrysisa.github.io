---
title: "你所不知道的 C 语言: 记忆体管理、对齐及硬体特性"
subtitle:
date: 2024-02-27T22:44:38+08:00
# draft: true
# author:
#   name:
#   link:
#   email:
#   avatar:
description:
keywords:
license:
comment: false
weight: 0
tags:
  - Sysprog
  - C
  - Memory
categories:
  - C
  - Linux Kernel Internals
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRss: false
summary:
resources:
  - name: featured-image
    src: featured-image.jpg
  - name: featured-image-preview
    src: featured-image-preview.jpg
toc: true
math: true
lightgallery: true
password:
message:
repost:
  enable: true
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

> 不少 C/C++ 开发者听过 "内存对齐" (memory alignment)，但不易掌握概念及规则，遑论其在执行时期的冲击。内存管理像是 malloc/free 函数的使用，是每个 C 语言程序设计开发者都会接触到，但却难保充分排除错误的难题。本讲座尝试从硬体的行为开始探讨，希望消除观众对于 alignment, padding, memory allocator 的误解，并且探讨高效能 memory pool 的设计，如何改善整体程序的效能和可靠度。也会探讨 C11 标准的 aligned_alloc。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-memory" content="原文地址" external-icon=true >}}

## 背景知识

###### 你所不知道的 C 语言: [指针篇](https://hackmd.io/s/HyBPr9WGl)

- C99/C11 6.2.5 Types (28)
> A pointer to void shall have the same representation and alignment requirements as a pointer to a character type.

- C99/C11 6.3.2.3 Pointers (1)
> A pointer to void may be converted to or from a pointer to any object type. A pointer to any object type may be converted to a pointer to void and back again; the result shall compare equal to the original pointer.

使用 `void *` 必须通过 explict (显式) 或强制转型，才能存取最终的 object，因为 `void` 无法判断 object 的大小信息。

###### 你所不知道的 C 语言: [函数呼叫篇](https://hackmd.io/s/SJ6hRj-zg)

glibc 提供了 `malloc_stats()` 和 `malloc_info()` 这两个函数，可以查询 process 的 heap 空间使用情况信息。

## Memory 金字塔

{{< image src="https://hackmd.io/_uploads/ryo9Y1NAj.png" >}}

这个金字塔的层级图提示我们，善用 Cache locality 可以有效提高程式效能。

{{< admonition tip >}}
- [ ] [What a C programmer should know about memory](https://marek.vavrusa.com/memory/) 
([简记](https://wen00072.github.io/blog/2015/08/08/notes-what-a-c-programmer-should-know-about-memory/))
{{< /admonition >}}

### Understanding virtual memory - the plot thickens

> The virtual memory allocator (VMA) may give you a memory it doesn’t have, all in a vain hope that you’re not going to use it. Just like banks today

虚拟内存的管理类似于银行，返回的分配空间未必可以立即使用。memory allocator 和银行类似，可用空间就类似于银行的现金储备金，银行可以开很多支票，但是这些支票可以兑现的前提是这些支票不会在同一时间来兑现，虚拟内存管理也类似，分配空间也期望用户不会立即全部使用。

### Understanding stack allocation

> This is how variable-length arrays (VLA), and also [alloca()](https://linux.die.net/man/3/alloca) work, with one difference - VLA validity is limited by the scope, alloca’d memory persists until the current function returns (or unwinds if you’re feeling sophisticated).

VLA 和 alloca 分配的都是栈 (stack) 空间，只需将栈指针 (sp) 按需求加减一下即可实现空间分配。因为 stack 空间是有限的，所以 Linux 核心中禁止使用 VLA，防止 Stack Overflow :rofl:

### Slab allocator
> The principle of slab allocation was described by Bonwick for a kernel object cache, but it applies for the user-space as well. Oh-kay, we’re not interested in pinning slabs to CPUs, but back to the gist — you ask the allocator for a slab of memory, let’s say a whole page, and you cut it into many fixed-size pieces. Presuming each piece can hold at least a pointer or an integer, you can link them into a list, where the list head points to the first free element.

在使用 alloc 的内存空间时，这些空间很有可能是不连续的。所以此时对于系统就会存在一些问题，一个是内存空间碎片 fragment，因为分配的空间未必会全部使用到，另一个是因为不连续，所以无法利用 Cache locality 来提升效能。

### Demand paging explained

Linux 系统会提供一些内存管理的 API 和机制:
- mlock() - lock/unlock memory 禁止某个区域的内存被 swapped out 到磁盘 (只是向 OS 建议，OS 可能不会理会)
- madvise() - give advice about use of memory (同样只是向 OS 建议，OS 可能不会理会)
- lazy loading - 利用缺页异常 ([page-fault](https://en.wikipedia.org/wiki/Page_fault)) 来实现
- copy on write 

{{< admonition info >}}
- [現代處理器設計: Cache 原理和實際影響](https://hackmd.io/@sysprog/HkW3Dr1Rb)
- [Cache 原理和實際影響](https://hackmd.io/s/HkyscQn2z): 進行 [CPU caches](https://lwn.net/Articles/252125/) 中文重點提示並且重現對應的實驗
- [針對多執行緒環境設計的 Memory allocator](https://hackmd.io/s/HkICAjeJg#)
- [rpmalloc 探討](https://hackmd.io/s/H1TP6FV6z)
{{< /admonition >}}

## 堆 Heap

- [x] Stack Overflow: [Why are two different concepts both called "heap"?](https://stackoverflow.com/questions/1699057/why-are-two-different-concepts-both-called-heap)
> Several authors began about 1975 to call the pool of available memory a "heap."

## Data alignment

一个 data object 具有两个特性:
- value
- storage location (address)

### alignment vs unalignment

假设硬体要求 4 Bytes alignment，CPU 存取数据时的操作如下:

{{< image src="https://imgur-backup.hackmd.io/aDCYyWc.png" caption="alignment" >}}
{{< image src="https://imgur-backup.hackmd.io/wIfEVy9.png" caption="unalignment" >}}

{{< link href="https://github.com/ccrysisa/LKI/blob/main/c-memory" content=Source external-icon=true >}}

除此之外，unalignment 也可能会无法充分利用 cache 效能，即存取的数据一部分 cache hit，另一部分 cache miss。当然对于这种情况，cache 也是采用类似上面的 merge 机制来进行存取，只是效能低下。

- GCC: [6.60.8 Structure-Packing Pragmas](https://gcc.gnu.org/onlinedocs/gcc-5.4.0/gcc/Structure-Packing-Pragmas.html)

> The *n* value below always is required to be a small power of two and specifies the new alignment in bytes.
> 
> 3. `#pragma pack(push[,n])` pushes the current alignment setting on an internal stack and then optionally sets the new alignment.    
> 4. `#pragma pack(pop)` restores the alignment setting to the one saved at the top of the internal stack (and removes that stack entry). Note that `#pragma pack([n])` does not influence this internal stack; thus it is possible to have `#pragma pack(push)` followed by multiple `#pragma pack(n)` instances and finalized by a single `#pragma pack(pop)`.

alignment 与 unalignment 的效能分布:

{{< image src="https://i.imgur.com/yUS7zcw.png" >}}

### malloc

malloc 分配的空间是 alignment 的:

- man malloc
> The malloc() and calloc() functions return a pointer to the allocated memory, which is suitably aligned for any built-in type.

- [The GNU C Library - Malloc Example](https://www.gnu.org/software/libc/manual/html_node/Malloc-Examples.html)
>The block that malloc gives you is guaranteed to be aligned so that it can hold any type of data. On GNU systems, the address is always a multiple of eight on 32-bit systems, and a multiple of 16 on 64-bit systems. 

使用 GDB 进行测试，确定在 Linux x86_64 上 malloc 分配的内存以 16 Bytes 对齐，即地址以 16 进制显示时最后一个数为 0。

### unalignment get & set

如上面所述，在 32-bit 架构上进行 8 bytes 对齐的存取效能比较高 (远比单纯访问一个 byte 高)，所以原文利用这一特性实作了 `unaligned_get8` 这一函数。
- `csrc & 0xfffffffc` 
  - 向下取整到最近的 8 bytes alignment 的地址
- `v >> (((uint32_t) csrc & 0x3) * 8)` 
  - 将获取的 alignment 的 32-bit 进行位移以获取我们想要的那个字节

{{< image src="https://advoop.sdds.ca/assets/images/type_int-b04deb28b0b45490fcb1e70f8466d8ad.png" >}}

而在 [你所不知道的 C 语言: 指针篇](https://hackmd.io/@sysprog/c-pointer) 中实作的 16-bit integer 在 unalignment 情况下的存取，并没有考虑到上面利用 alignment 来提升效能。

原文 32 位架构的 unalignment 存取有些问题，修正并补充注释如下:
```c
uint8_t unaligned_get8(void *src) {
    uintptr_t csrc = (uintptr_t) src;
    uint32_t v = *(uint32_t *) (csrc & 0xfffffffc);  // align 4-bytes
    v = (v >> (((uint32_t) csrc & 0x3) * 8)) & 0x000000ff;  // get byte
    return v;
}

void unaligned_set8(void *dest, uint8_t value) {
    uintptr_t cdest = (uintptr_t) dest;
    uintptr_t ptr = cdest & 0xfffffffc;  // align 4-bytes
    for (int n = 0; n < 4; n++) {
        uint32_t v;
        if (n == (cdest & 0x3))
            v = value;
        else
            v = unaligned_get8((void *) ptr);
        v = v << (n * 8);
        d = d | v;
        ptr++;
    }
    *(uint32_t *) (cdest & 0xfffffffc) = v;
}
```

实作 64-bit integer (64 位架构) 的 get & set:
```c
uint8_t unaligned_get8(void *src) {
    uintptr_t csrc = (uintptr_t) src;
    uint32_t v = *(uint32_t *) (csrc & 0xfffffff0);  // align 4-bytes
    v = (v >> (((uint32_t) csrc & 0x3) * 8)) & 0x000000ff;  // get byte
    return v;
}

void unaligned_set8(void *dest, uint8_t value) {
    uintptr_t cdest = (uintptr_t) dest;
    uintptr_t ptr = cdest & 0xfffffff0;  // align 4-bytes
    for (int n = 0; n < 8; n++) {
        uint32_t v;
        if (n == (cdest & 0x3))
            v = value;
        else
            v = unaligned_get8((void *) ptr);
        v = v << (n * 8);
        d = d | v;
        ptr++;
    }
    *(uint32_t *) (cdest & 0xfffffff0) = v;
}
```

其它逻辑和 32 位机器上类似

- [Data Alignment](http://www.songho.ca/misc/alignment/dataalign.html)
- Linux kernel: [Unaligned Memory Accesses](https://www.kernel.org/doc/Documentation/unaligned-memory-access.txt)

## concurrent-II

{{< admonition info >}}
- 源码: [concurrent-ll](https://github.com/jserv/concurrent-ll/tree/master/src/lockfree)
- 论文: [A Pragmatic Implementation of Non-Blocking Linked Lists](https://www.cl.cam.ac.uk/research/srg/netos/papers/2001-caslists.pdf)
{{< /admonition >}}

使用 [CAS](https://en.wikipedia.org/wiki/Compare-and-swap) 无法确保链表插入和删除同时发生时的正确性，因为 CAS 虽然保证了原子操作，但是在进行原子操作之前，需要在链表中锚定节点以进行后续的插入、删除 (这里是通过 CAS 操作)。如果先发生插入，那么并不会影响后面的操作 (插入或删除)，因为插入的节点并不会影响后面操作锚定的节点。但如果先发生删除，那么这个删除操作很有可能就把后面操作 (插入或删除) 已经锚定的节点从链表中删掉了，这就导致了后续操作的不正确结果。***所以需要一个方法来标识「不需要的节点」，然后再进行原子操作。***

{{< admonition question >}}
只使用位运算即可实现逻辑上删除节点 (即通过位运算标记节点)？
{{< /admonition >}}

- C99 6.7.2.1 Structure and union specifiers
> Each non-bit-field member of a structure or union object is aligned in an implementation defined manner appropriate to its type.

> Within a structure object, the non-bit-field members and the units in which bit-fields reside have addresses that increase in the order in which they are declared. A pointer to a structure object, suitably converted, points to its initial member (or if that member is a bit-field, then to the unit in which it resides), and vice versa. There may be unnamed padding within a structure object, but not at its beginning.

所以 C 语言中结构体的 padding 是 implementation defined 的，但是保证这些 padding 不会出现在结构体的起始处。

- GCC [4.9 Structures, Unions, Enumerations, and Bit-Fields](https://gcc.gnu.org/onlinedocs/gcc/Structures-unions-enumerations-and-bit-fields-implementation.html)
> The alignment of non-bit-field members of structures (C90 6.5.2.1, C99 and C11 6.7.2.1).
> 
> Determined by ABI.

- C99 7.18.1.4 Integer types capable of holding object pointers
> The following type designates a signed integer type with the property that any valid pointer to void can be converted to this type, then converted back to pointer to void, and the result will compare equal to the original pointer: intptr_t

- [x86_64 ABI](https://www.uclibc.org/docs/psABI-x86_64.pdf)

{{< image src="https://imgur-backup.hackmd.io/XER1MC6.png" >}}

- Aggregates and Unions
> Structures and unions assume the alignment of their most strictly aligned compo-
> nent. Each member is assigned to the lowest available offset with the appropriate
> alignment. The size of any object is always a multiple of the object‘s alignment.
> An array uses the same alignment as its elements, except that a local or global
> array variable of length at least 16 bytes or a C99 variable-length array variable
> always has alignment of at least 16 bytes. 4
> Structure and union objects can require padding to meet size and alignment
> constraints. The contents of any padding is undefined.

所以对于链表节点对应的结构体:

```c
typedef intptr_t val_t;

typedef struct node {
    val_t data;
    struct node *next;
} node_t;
```

因为 data alignment 的缘故，它的地址的最后一个 bit 必然是 0 (成员都是 4-bytes 的倍数以及必须对齐)，同理其成员 `next` 也满足这个性质 (因为这个成员表示下一个节点的地址)。所以删除节点时，可以将 `next` 的最后一个 bit 设置为 1，表示当前节点的下一个节点已经被“逻辑上”删除了。

最后当没有插入或删除操作是，链表再对标识为“删除”的节点进行移除，这个机制有点类似于 GC

## glibc 的 malloc/free 实作

背景考量: [Deterministic Memory Allocation for Mission-Critical Linux](https://hackmd.io/@sysprog/c-memory#data-alignment)

*Main arena vs Thread arena* :

{{< image src="https://hackpad-attachments.s3.amazonaws.com/embedded2016.hackpad.com_kS5wHum1S54_p.606235_1462612773104_undefined" >}}

*multiple heap Thread arena* :

{{< image src="https://docs.google.com/drawings/d/150bTi0uScQlnABDImLYS8rWyL82mmfpMxzRbx-45UKw/pub?w=960&h=720" >}}

## 实作案例: GC in C

YouTube: [GC in C](https://www.youtube.com/playlist?list=PLpM-Dvs8t0VYuYxRxjfnkdHvosHH8faqc)
- [Writing My Own Malloc in C](https://www.youtube.com/watch?v=sZ8GJ1TiMdk)
- [Writing Garbage Collector in C](https://www.youtube.com/watch?v=2JgEKEd3tw8)

### 内存布局

{{< image src="/images/c/heap.drawio.png" >}}

### alloc & free

如果允许分配 0 字节的内存空间，那么会造成分配的不同内存块的起始地址一样的情形，实作时应当避免这种情形:

```bash
Allocated Chunks (100):
  start: 0x648cadc3c040, size: 0
  start: 0x648cadc3c040, size: 1
  ...
```

- man 3 malloc

> If size is 0, then malloc() returns either NULL, or a unique pointer value that can  later be successfully passed to free().

### function name

- C99/C11 6.4.2.2

> The identifier `__func__` shall be implicitly declared by the translator as if, immediately following the opening brace of each function definition

### pointer substraction

影片最后 `chunk_list_find` 没有起到预期的作用，但这个和 `bsearch` 无关，原因为影片博主未掌握指针减法的定义，在最后进行了错误的运算

- C11 6.5.6

> When two pointers are subtracted, both shall point to elements of the same array object, or one past the last element of the array object; the result is the difference of the subscripts of the two array elements. 

所以只需要计算 `result - list->chunks` 即可，无需再除以 `list->chunks[0]`

### References

- Wikipedia: [XOR linked list](https://en.wikipedia.org/wiki/XOR_linked_list)
- Wikipedia: [Binary search](https://en.wikipedia.org/wiki/Binary_search)
- Linux manual page: [memmove(3)](https://man7.org/linux/man-pages/man3/memmove.3.html)
- Linux manual page: [bsearch(3)](https://www.man7.org/linux/man-pages/man3/bsearch.3.html)
- GitHub: [nothings/stb](https://github.com/nothings/stb)
- GitHub: [gcc-mirror/gcc](https://github.com/gcc-mirror/gcc)
