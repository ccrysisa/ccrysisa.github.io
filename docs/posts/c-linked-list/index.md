# 你所不知道的 C 语言: linked list 和非连续内存


> 无论是操作系统核心、C 语言函数库内部、程序开发框架，到应用程序，都不难见到 linked list 的身影，包含多种针对性能和安全议题所做的 linked list 变形，又还要考虑应用程序的泛用性 (generic programming)，是很好的进阶题材。

- {{< link href="https://hackmd.io/@sysprog/c-linked-list" content="原文地址" external-icon=true >}}   
<!--more-->

## Linux 核心的艺术

[The mind behind Linux | Linus Torvalds | TED](https://youtu.be/o8NPllzkFhE) [YouTube]

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

- [ ] [探索 Floyd Cycle Detection Algorithm](https://medium.com/@orionssl/%E6%8E%A2%E7%B4%A2-floyd-cycle-detection-algorithm-934cdd05beb9)
- [x] [LeetCode 141. Linked List Cycle](https://leetcode.com/problems/linked-list-cycle/)
- [x] [LeetCode 142. Linked List Cycle II](https://leetcode.com/problems/linked-list-cycle-ii/)
- [ ] [LeetCode 146. LRU Cache](https://leetcode.com/problems/lru-cache/)
- [金刀的算法小册子](https://github.com/glodknife/algorithm) Linked List
    - [x] [LeetCode 206. Reverse Linked List](https://leetcode.com/problems/reverse-linked-list)

## Merge Sort

{{< link href="https://github.com/ccrysisa/LKI/blob/main/c-linked-list" content=Source external-icon=true >}}

- [ ] [Merge Sort 与它的变化](https://hackmd.io/@lambert-wu/list-merge-sort)

## Linux 核心的 linked list

Linux 核心使用的 linked list 是通过 Intrusive linked lists 搭配 contain_of 宏，来实现自定义的 linked list node，具有强大的灵活性。

- [ ] [Intrusive linked lists](https://www.data-structures-in-practice.com/intrusive-linked-lists/)
- [ ] [List, HList, and Hash Table](https://danielmaker.github.io/blog/linux/list_hlist_hashtable.html)
- [ ] [hash table](https://hackmd.io/@ChialiangKuo/quiz6B-hash-table)
- [ ] [Linux 核心原始程式碼巨集: container_of](https://hackmd.io/@sysprog/linux-macro-containerof)
- [ ] [sysprog21/linux-list](https://github.com/sysprog21/linux-list)
- [ ] [Optimized QuickSort: C Implementation (Non-Recursive)](https://alienryderflex.com/quicksort/)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-linked-list/  

