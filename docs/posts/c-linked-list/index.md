# 你所不知道的 C 语言: linked list 和非连续内存


> 无论是操作系统核心、C 语言函数库内部、程序开发框架，到应用程序，都不难见到 linked list 的身影，包含多种针对性能和安全议题所做的 linked list 变形，又还要考虑应用程序的泛用性 (generic programming)，是很好的进阶题材。

- {{< link href="https://hackmd.io/@sysprog/c-linked-list" content="原文地址" external-icon=true >}}   
<!--more-->
- {{< link href="https://youtu.be/pTcRq__iKzI" content="直播录影" external-icon=true >}}   

## Linux 核心的艺术

[The mind behind Linux | Linus Torvalds | TED](https://youtu.be/o8NPllzkFhE) [YouTube]

> 事实上 special case 和 indirect pointer 这两种写法在 clang 的最佳优化下效能并没有什么区别，我们可以不使用 indirect pointer 来写程序，但是我们需要学习 indirect pointer 这种思维方式，即 good taste。

在 Unix-like 的操作系统中，类型名带有后缀 `_t` 表示这个类型是由 `typedef` 定义的，而不是语言原生的类型名，e.g.

```c
typedef struct list_entry {
    int value;
    struct list_entry *next;
} list_entry_t;
```

### linked list append & remove

{{< link href="https://github.com/ccrysisa/LKI/blob/main/c-linked-list" content=Source external-icon=true >}}

{{< admonition tip >}}
- [ ] [The mind behind Linux](https://hackmd.io/@Mes/The_mind_behind_Linux)
- [ ] [Linus on Understanding Pointers](https://grisha.org/blog/2013/04/02/linus-on-understanding-pointers/)
{{< /admonition >}}


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-linked-list/  

