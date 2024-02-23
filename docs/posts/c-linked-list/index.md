# 你所不知道的 C 语言: linked list 和非连续内存


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
- [ ] [LeetCode 146. LRU Cache](https://leetcode.com/problems/lru-cache/)
- [金刀的算法小册子](https://github.com/glodknife/algorithm) Linked List 专题
    - [x] [LeetCode 206. Reverse Linked List](https://leetcode.com/problems/reverse-linked-list)

{{< admonition info >}}
- [ ] [探索 Floyd Cycle Detection Algorithm](https://medium.com/@orionssl/%E6%8E%A2%E7%B4%A2-floyd-cycle-detection-algorithm-934cdd05beb9)
{{< /admonition >}}

## Merge Sort

实现了 recursion, non-recursion 的 merge sort

{{< link href="https://github.com/ccrysisa/LKI/blob/main/c-linked-list" content=Source external-icon=true >}}

{{< admonition info >}}
- [ ] [Merge Sort 与它的变化](https://hackmd.io/@lambert-wu/list-merge-sort)
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

- [ ] [Linux 核心原始程式碼巨集: container_of](https://hackmd.io/@sysprog/linux-macro-containerof)

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


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-linked-list/  

