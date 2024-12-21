---
title: "你所不知道的 C 语言: linked list 和非连续记忆体"
subtitle:
date: 2024-02-03T10:44:56+08:00
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
  - Linked List
categories:
  - 你所不知道的 C 语言
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

> 无论是操作系统核心、C 语言函数库内部、程序开发框架，到应用程序，都不难见到 linked list 的身影，包含多种针对性能和安全议题所做的 linked list 变形，又还要考虑应用程序的泛用性 (generic programming)，是很好的进阶题材。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-linked-list" content="原文地址" external-icon=true >}}   

## Linux 核心的艺术

- [ ] YouTube: [The mind behind Linux | Linus Torvalds | TED](https://youtu.be/o8NPllzkFhE)

> 事实上 special case 和 indirect pointer 这两种写法在 clang 的最佳优化下效能并没有什么区别，我们可以不使用 indirect pointer 来写程序，但是我们需要学习 indirect pointer 这种思维方式，即 good taste。
> 
> *把握程序的本质，即本质上是修改指针的值，所以可以使用指针的指针来实现，无需进行特判。*

在 Unix-like 的操作系统中，类型名带有后缀 `_t` 表示这个类型是由 `typedef` 定义的，而不是语言原生的类型名，e.g.

```c
typedef struct list_entry {
    int value;
    struct list_entry *next;
} list_entry_t;
```

### linked list append & remove

{{< link href="https://github.com/ccrysisa/LKI/blob/main/c-linked-list" content=Source external-icon=true >}}

{{< admonition info >}}
- [ ] [The mind behind Linux](https://hackmd.io/@Mes/The_mind_behind_Linux)
- [ ] [Linus on Understanding Pointers](https://grisha.org/blog/2013/04/02/linus-on-understanding-pointers/)
{{< /admonition >}}

### LeetCode

{{< link href="https://github.com/ccrysisa/LKI/blob/main/c-linked-list" content=Source external-icon=true >}}

- [x] [LeetCode 21. Merge Two Sorted Lists](https://leetcode.com/problems/merge-two-sorted-lists/)
- [x] [LeetCode 23. Merge k Sorted Lists](https://leetcode.com/problems/merge-k-sorted-lists/)
- [x] [Leetcode 2095. Delete the Middle Node of a Linked List](https://leetcode.com/problems/delete-the-middle-node-of-a-linked-list/)
- [x] [LeetCode 86. Partition List](https://leetcode.com/problems/partition-list/)

{{< admonition >}}
原文对于 [LeetCode 23. Merge k Sorted Lists](https://leetcode.com/problems/merge-k-sorted-lists/) 给出了 3 种解法，其时间复杂度分别为：

1. $O(m \cdot n)$
2. $O(m \cdot n)$
3. $O(m \cdot logn)$

$n$ 为 `listsSize`，$m$ 为 merge linked list 过程中产生的 linked list 的最大长度。

如果你对第 3 种解法的时间复杂度感到疑惑，请参考 Josh Hug 在 CS61B 的 [Merge Sort 复杂度讲解](https://joshhug.gitbooks.io/hug61b/content/chap8/chap83.html)。
{{< /admonition >}}

## Circular linked list

单向 linked list 相对于双向 linked list 的优势在于，一个 cache line 可以容纳更多的 list node，而且很容易进行反向查询，这弥补了反向查询时的效能差距。例如在 64 位处理器上，地址为 64 Bit 即 8 Byte，如果 list node 的数据域存放一个 2 Byte 的整数，那么一个单向的 list node 大小为 10 Byte，双向的则为 18 Byte，又因为一般的 cache line 的大小为 64 Byte，则对于单向的 node 来说，cache line 可以存放 $64 / 10 = 6$ 个 list node，但是仅能存放 $64 / 18 = 3$ 个 list node，cache 效率明显降低。

> 这部分内容可以参考 jserv 的讲座 [<現代處理器設計: Cache 原理和實際影響>](https://hackmd.io/@sysprog/HkW3Dr1Rb)

### Floyd's Cycle detection

这个“龟兔赛跑”算法保证兔子在跑两次循环圈后，一定会和刚完成一次循环圈的乌龟相遇。因为已知乌龟每次移动一步，兔子每次移动两步，可以假设在相遇点处乌龟移动的 $X$ 步，则兔子移动了 $2X$ 步，$2X$ 必为偶数，所以兔子必能在移动了 $2X$ 步后与乌龟相遇，不会出现兔子因为每次移动两步而刚好越过乌龟一步的情况。

> $\lambda$ is the length of the loop to be found, $\mu$ is the index of the first element of the cycle.

{{< link href="https://github.com/ccrysisa/LKI/blob/main/c-linked-list" content=Source external-icon=true >}}


- [x] [LeetCode 141. Linked List Cycle](https://leetcode.com/problems/linked-list-cycle/)
- [x] [LeetCode 142. Linked List Cycle II](https://leetcode.com/problems/linked-list-cycle-ii/)
- [x] [LeetCode 146. LRU Cache](https://leetcode.com/problems/lru-cache/)
- [金刀的算法小册子](https://github.com/glodknife/algorithm) Linked List 专题
    - [x] [LeetCode 206. Reverse Linked List](https://leetcode.com/problems/reverse-linked-list)

{{< admonition info >}}
- [ ] [探索 Floyd Cycle Detection Algorithm](https://medium.com/@orionssl/%E6%8E%A2%E7%B4%A2-floyd-cycle-detection-algorithm-934cdd05beb9)
{{< /admonition >}}

## Merge Sort

实现了 recursion, non-recursion 的 merge sort

{{< link href="https://github.com/ccrysisa/LKI/blob/main/c-linked-list" content=Source external-icon=true >}}

{{< admonition tip >}}
- [ ] [Merge Sort 与它的变化](https://hackmd.io/@lambert-wu/list-merge-sort)

不论是这里的 non-recursion 版本的 merge sort，还是后面的 non-recursion 版本的 quick sort，本质上都是通过模拟栈 (stack) 操作来实现的，关于这个模拟 stack 方法，可以参考蒋炎岩老师的录影 [应用视角的操作系统 (程序的状态机模型；编译优化)](https://www.bilibili.com/video/BV1Ks4y1Y7Rw/)。
{{< /admonition >}}

## Linux 核心的 linked list

Linux 核心使用的 linked list 是通过 Intrusive linked lists 搭配 contain_of 宏，来实现自定义的 linked list node。

- [x] [sysprog21/linux-list](https://github.com/sysprog21/linux-list)
> 这个仓库将 Linux kernel 中 linked list 部分抽离出来，并改写为 user mode 的实作。本人对该仓库进行了一些改写，对 insert sort 和 quick sort 增加了 makefile 支持。

上面的仓库与 Linux kernel 的实作差异主要在于 `WRITE_ONCE` 宏。`WRITE_ONCE` 的原理简单来说是，通过 `union` 产生两个引用同一地址的引用 (即 `__val` 和 `__c`)，然后因为对同一地址有多个引用，所以编译器进行最佳化时不会过于激进的重排序，从而达到顺序执行效果。

{{< link href="https://github.com/ccrysisa/linux-list" content=Source external-icon=true >}}

### Intrusive linked lists

- [x] [Intrusive linked lists](https://www.data-structures-in-practice.com/intrusive-linked-lists/)

这篇文章对于 Intrusive linked list 说明的非常好，解释了其在 memory allocations 和 cache thrashing 的优势，还搭配 Linux kernel 讲解了场景应用。

### container_of

{{< admonition success >}}
container_of 巨集在 Linux 核心原始程式碼出現將近 7 千次 (v5.13)，不僅在 linked list 和 hash table 一類通用資料結構中可簡化程式設計，甚至是 Linux 核心達成物件導向程式設計的關鍵機制之一。

若要征服 Linux 核心原始程式碼，對 container_of 巨集的掌握度絕對要充分。
{{< /admonition >}}

- [x] [Linux 核心原始程式碼巨集: container_of](https://hackmd.io/@sysprog/linux-macro-containerof)

#### 跟你想象不同的 struct

```c
struct data {
    short a;
    char b;
    double c;
};
```

对于上面的结构体，下面的内存分布图示是错误的:

{{< image src="https://imgur-backup.hackmd.io/NihOvLg.png" >}}

原因是这样的内存分布忽略了编译器为了满足 alignment 需求，进行的 [structure padding](http://www.catb.org/esr/structure-packing/#_padding)

- [6.37.1 Common Type Attributes](https://gcc.gnu.org/onlinedocs/gcc/Common-Type-Attributes.html) - packed
> This attribute, attached to a struct, union, or C++ class type definition, specifies that each of its members (other than zero-width bit-fields) is placed to minimize the memory required. This is equivalent to specifying the packed attribute on each of the members.

加上 `packed` 属性后结构体成员的内存分布就和一开始的相同，但这是 C 语言的一个陷阱，`packed` 的结构体可能会牺牲资料存取的效率，具体可以参考 [你所不知道的 C 语言: 记忆体管理、对齐及硬体特性](https://hackmd.io/@sysprog/c-memory)。

C89/C99 提供 [offset](https://man7.org/linux/man-pages/man3/offsetof.3.html) 宏来提升可移植性 (portablity)，其功能为接收结构体的型态和成员的名称，返回 **成员的地址减去 struct 的起始地址得到的偏移量**:

```c
#include <stddef.h>

size_t offsetof(type, member);
```

> The macro `offsetof()` returns the offset of the field *member* from the start of the structure *type*.

{{< image src="https://imgur-backup.hackmd.io/DYiZ1sd.jpg" >}}

[typeof](https://gcc.gnu.org/onlinedocs/gcc/Typeof.html) 也是 GNU extension，它可以在编译时期得到 object 的型态名称，例如 `x` 是 `struct data`，那么通过 `typeof(x)` 即可得到 `struct data`，这样就联通了 object 和型态的关系。

> Another way to refer to the type of an expression is with typeof. The syntax of using of this keyword looks like sizeof, but the construct acts semantically like a type name defined with typedef.

#### container_of 宏作为资料封装的基础

`container_of` 宏在 `offsetof` 的基础上，扩充为 **给定成员的地址、struct 的型态，以及成员的名称，传回此 struct 物件的地址**:

{{< image src="https://imgur-backup.hackmd.io/IgayoN9.jpg" >}}

> 請不要小看這巨集，畢竟大量在 Linux 核心原始程式碼採用的巨集，應有其獨到之處。在 `container_of` 巨集出現前，程式設計的思維往往是:
> 
> 1. 給定結構體起始地址
> 2. 求出結構體特定成員的記憶體內容
> 3. 傳回結構體成員的地址，作日後存取使用
> 
> `container_of` 巨集則逆轉上述流程，特別在 C 語言程式設計中，我們通常會定義一系列公開介面 (interface)，從而區隔各式實作 (implementation)。

- [你所不知道的 C 语言: 物件导向程序设计篇](https://hackmd.io/@sysprog/c-oop)

例如对于下面的程式码，可以通过 `container_of` 搭配 `base` 成员来获得具体的类型，实现某种意义上的 **封装** (encapsulation)，**继承** (inheritance) 和 **多态** (polymorphism)

```c
typedef struct { int ref; } Object;
typedef struct { Object base; /* Vehicle-specific members */ } Vehicle;
typedef struct { Vehicle base; /* Car-specific members */ } Car;

void vehicleStart(Vehicle *obj) {
    if (obj) printf("%x derived from %x\n", obj, obj->base);
}

int main(void) {
    Car c;
    vehicleStart((Vehicle *) &c);
}
```

在 Linux 核心的装置驱动程式里也常用到 `container_of` 进行物件导向设计，并通过搭配指针操作，用于 **清晰地界定接口和实作本体**，这是 Linux 核心开发者追求的优雅。

- [drivers/media/i2c/imx214.c](https://github.com/torvalds/linux/blob/master/drivers/media/i2c/imx214.c)

#### container_of 实作手法

{{< image src="https://imgur-backup.hackmd.io/6h0Bgax.jpg" >}}

对应的程式码:

```c
/* container_of() - Calculate address of object that contains address ptr
 * @ptr: pointer to member variable
 * @type: type of the structure containing ptr
 * @member: name of the member variable in struct @type
 *
 * Return: @type pointer of object containing ptr
 */
#define container_of(ptr, type, member)                            \
    __extension__({                                                \
        const __typeof__(((type *) 0)->member) *(__pmember) = (ptr); \
        (type *) ((char *) __pmember - offsetof(type, member));    \
    })
```

这里面涉及到了 `__extension__`，参考 [6.51 Alternate Keywords](https://gcc.gnu.org/onlinedocs/gcc/Alternate-Keywords.html):

> -pedantic and other options cause warnings for many GNU C extensions. You can suppress such warnings using the keyword `__extension__`.    
> Writing `__extension__` before an expression prevents warnings about extensions within that expression.

因为用到了 `typeof` 这个 GNU extension，所以需要使用 `__extension__` 来设置编译时不抛出警告

{{< admonition quote >}}
上述程式碼是從 struct 中的 member 推算出原本 struct 的位址。解析:

- 先透過 `__typeof__` 得到 `type` 中的成員 `member` 的型別，並宣告一個指向該型別的指標 `__pmember`
- 將 `ptr` 指派到 `__pmember`
- `__pmember` 目前指向的是 `member` 的位址
- `offsetof(type, member)` 可得知 `member` 在 `type` 這個結構體位移量，即 offset
- 將絕對位址 `(char *) __pmember` 減去 `offsetof(type, member)`，可得到結構體的起始位址。計算 offset 時要轉成 `char *`，以確保 address 的計算符合預期 (可參考 [The (char *) casting in container_of() macro in linux kernel](https://stackoverflow.com/questions/20421910/the-char-casting-in-container-of-macro-in-linux-kernel) 的說明)
- 最後 `(type *)` 再將起始位置轉型為指向 `type` 的指標
{{< /admonition >}}

需要注意的是，程式码的第一行乍一看感觉没什么用，此时请从 robust 的角度看待，毕竟一个有强度的系统都是 robust 的。实际上第一行是用于编译时期类型检查的，检查传入的地址 `ptr` 是否对应 `member` 的类型，这个类型检查时通过不同 object 的 data alignment 来实现的 (data alignment 会反映在地址上，进而反映到指针的值上面)。

事实上，Linux 核心的 `container_of` 宏则更加复杂:

```c
#define container_of(ptr, type, member) ({				\
    void *__mptr = (void *)(ptr);					\
    BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&	\
                     !__same_type(*(ptr), void),			\
                     "pointer type mismatch in container_of()");	\
    ((type *)(__mptr - offsetof(type, member))); })
```

复杂增加的地方仍然是我们所提的 robust 保证，用于在 **编译时期** 进行更加严格的 **类型检查**，这里使用了 `BUILD_BUG_ON_MSA` 宏，该宏的实作与 `BUILD_BUG_ON_ZERO` 宏类似，而 `BUILD_BUG_ON_ZERO` 的功能和 `static assert` 相似，**接收的表达式为 true 时会编译失败**，即其接收的是不满足编译通过条件的表达式。具体的解释说明可以参考 [Linux 核心巨集: BUILD_BUG_ON_ZERO](https://hackmd.io/@sysprog/c-bitfield)，笔者也有相关的 [博文]({{< relref "./c-bitwise/#linux-%E6%A0%B8%E5%BF%83-build_bug_on_zero" >}}) 进行解说。

除此之外还使用了 `__same_type` 宏:

- [include/linux/compiler_types.h](https://github.com/torvalds/linux/blob/master/include/linux/compiler_types.h#L427)

```c
/* Are two types/vars the same type (ignoring qualifiers)? */
#define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
```

使用 GNU extension `__builtin_types_compatible_p` 对 `a` 和 `b` 的类型进行比较判断:

- [6.63 Other Built-in Functions Provided by GCC](https://gcc.gnu.org/onlinedocs/gcc/Other-Builtins.html)

> You can use the built-in function `__builtin_types_compatible_p` to determine whether two types are the same.
> 
> This built-in function returns 1 if the unqualified versions of the types *type1* and *type2* (which are types, not expressions) are compatible, 0 otherwise. The result of this built-in function can be used in integer constant expressions.
> 
> This built-in function ignores top level qualifiers (e.g., `const`, `volatile`). For example, `int` is equivalent to `const int`.

#### 应用案例: 双向环状链接串列

- [sysprog21/linux-list](https://github.com/sysprog21/linux-list)

{{< image src="https://imgur-backup.hackmd.io/kOvwKZw.png" >}}

> 自 `Head` 開始，鏈結 list 各節點，個別節點皆嵌入 `list_head` 結構體，不過 `Head` 是個特例，無法藉由 `container_of` 巨集來找到對應的節點，因為後者並未嵌入到任何結構體之中，其存在是為了找到 list 整體。

> 上方程式碼的好處在於，只要 `list_head` 納入新的結構體的一個成員，即可操作，且不用自行維護一套 doubly-linked list 。

{{< image src="https://imgur-backup.hackmd.io/d3bG8t6.png" >}}

> 注意到 `list_entry` 利用 `container_of` 巨集，藉由 `struct list_head` 這個 **公開介面**，「反向」去存取到 **自行定義的結構體** 開頭地址。

### Optimized QuickSort

- [x] [Optimized QuickSort: C Implementation (Non-Recursive)](https://alienryderflex.com/quicksort/)

这篇文章介绍了 non-recursion 的 quick sort 在 array 上的实作，参考该文章完成 linked list 上的 non-recursion 版本的 quick sort 实作。

非递归的快速排序中 `if (L != R && &begin[i]->list != head) {` 其中的 `&begin[i]->list != head` 条件判断用于空链表情况，数组版本中使用的是下标比较 `L < R` 来判断，但是链表中使用 `L != R` 不足以完全表示 `L < R` 这个条件，还需要 `&begin[i]->list != head` 来判断链表是否为空。

### Linux 核心的 list_sort 实作 

[linux/list_sort.c](https://github.com/torvalds/linux/blob/master/lib/list_sort.c)

先将双向循环链表转换成单向链表，然后利用链表节点的 `prev` 来挂载 pending list (因为单向链表中 `prev` 没有作用，但是链表节点仍然存在 `prev` 字段，所以进行充分利用)。

- 假设 `count` 对应的 `bits` 第 k 个 bit 值为 0 且 $> k$ 的 bits 都为 0，$< k$ 的 bits 都为 1，则 $< k $ 的这些 1 可以表示 pending list 中分别有 $2^{k-1}, 2^{k-2}, ..., 2^0$ 大小的 list 各一个。

- 如果第 k 个 bit 值为 0 且 $> k$ 的 bits 中存在值为 1 的 bit，$< k$ 的 bits 均为 1，则只有 $< k$ 的 bits 可以表示 pending list 中分别有 $2^{k-1}, 2^{k-2}, ..., 2^0$ 大小的 list 各一个，`> k` 的 1 表示需要进行 merge 以获得对应大小的 list。

这样也刚好能使得 merge 时是 $2: 1$ 的长度比例，因为 2 的指数之间的比例是 $2: 1$。

{{< admonition tip >}}
这部分内容在 [Lab0: Linux 核心的链表排序](https://hackmd.io/@sysprog/linux2023-lab0/%2F%40sysprog%2Flinux2023-lab0-e) 中有更详细的解释和讨论。
{{< /admonition >}}

{{< admonition info >}}
- [List, HList, and Hash Table](https://danielmaker.github.io/blog/linux/list_hlist_hashtable.html)
- [hash table](https://hackmd.io/@ChialiangKuo/quiz6B-hash-table)
- [What is the strict aliasing rule?](https://stackoverflow.com/questions/98650/what-is-the-strict-aliasing-rule) [Stack Overflow]
- [Unions and type-punning](https://stackoverflow.com/questions/25664848/unions-and-type-punning) [Stack Overflow]
- [Nine ways to break your systems code using volatile](https://blog.regehr.org/archives/28) [Stack Overflow]
- [WRITE_ONCE in linux kernel lists](https://stackoverflow.com/questions/34988277/write-once-in-linux-kernel-lists) [Stack Overflow]
- [lib/list_sort: Optimize number of calls to comparison function](https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1957556.html)
{{< /admonition >}}

## Fisher–Yates shuffle

- Wikipedia [Fisher–Yates shuffle](https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle)
> The Fisher–Yates shuffle is an algorithm for shuffling a finite sequence.

原文所说的事件复杂度，是考虑关于构造结果链表时的复杂度，并不考虑寻找指定节点的复杂度，所以对于原始方法复杂度为 $1 + 2 + ... + n = O(n^2)$，对于 modern method 复杂度为 $1 + 1 + ... + 1 = O(n)$

原文实作虽然使用了 pointer to pointer，但是使用上并没有体现 linus 所说的 good taste，重新实作如下:

```c
void shuffle(node_t **head)
{
    srand(time(NULL));

    // First, we have to know how long is the linked list
    int len = 0;
    node_t **indirect = head;
    while (*indirect) {
        len++;
        indirect = &(*indirect)->next;
    }

    // Append shuffling result to another linked list
    node_t *new = NULL;
    node_t **new_tail = &new;

    while (len) {
        int random = rand() % len;
        indirect = head;

        while (random--)
            indirect = &(*indirect)->next;

        node_t *tmp = *indirect;
        *indirect = (*indirect)->next;
        tmp->next = NULL;

        *new_tail = tmp;
        new_tail = &(*new_tail)->next;

        len--;
    }

    *head = new;
}
```

主要是修改了新链表 `new` 那一部分，只需要一个 pointer to pinter `new_tail` 就可以避免条件判断。
