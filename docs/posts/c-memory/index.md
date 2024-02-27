# 你所不知道的 C 语言: 内存管理、对齐及硬体特性


> 不少 C/C++ 开发者听过 "内存对齐" (memory alignment)，但不易掌握概念及规则，遑论其在执行时期的冲击。内存管理像是 malloc/free 函数的使用，是每个 C 语言程序设计开发者都会接触到，但却难保充分排除错误的难题。本讲座尝试从硬体的行为开始探讨，希望消除观众对于 alignment, padding, memory allocator 的误解，并且探讨高效能 memory pool 的设计，如何改善整体程序的效能和可靠度。也会探讨 C11 标准的 aligned_alloc。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-memory" content="原文地址" external-icon=true >}}

## 背景知识

### 你所不知道的 C 语言: [指针篇](https://hackmd.io/s/HyBPr9WGl)

- C99/C11 6.2.5 (28)
> A pointer to void shall have the same representation and alignment requirements as a pointer to a character type.

- C99/C11 6.3.2.3 (1)
> A pointer to void may be converted to or from a pointer to any object type. A pointer to any object type may be converted to a pointer to void and back again; the result shall compare equal to the original pointer.

使用 `void *` 必须通过 explict (显式) 或强制转型，才能存取最终的 object，因为 `void` 无法判断 object 的大小信息。

### 你所不知道的 C 语言: [函数呼叫篇](https://hackmd.io/s/SJ6hRj-zg)

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
- madvise() - give advice about use of memory
- lazy loading 利用 page-fault 来实现
- copy on write 

{{< admonition info >}}
- [現代處理器設計: Cache 原理和實際影響](https://hackmd.io/@sysprog/HkW3Dr1Rb)
- [Cache 原理和實際影響](https://hackmd.io/s/HkyscQn2z): 進行 [CPU caches](https://lwn.net/Articles/252125/) 中文重點提示並且重現對應的實驗
- [針對多執行緒環境設計的 Memory allocator](https://hackmd.io/s/HkICAjeJg#)
- [rpmalloc 探討](https://hackmd.io/s/H1TP6FV6z)
{{< /admonition >}}

## 堆 Heap

- [x] Stack Overflow: [Why are two different concepts both called "heap"?](https://stackoverflow.com/questions/1699057/why-are-two-different-concepts-both-called-heap)

## Data alignment


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-memory/  

