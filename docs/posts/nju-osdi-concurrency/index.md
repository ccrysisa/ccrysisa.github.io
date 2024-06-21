# 南京大学 OSDI 并发 重点提示


<!--more-->

## 多处理器编程: 从入门到放弃

{{< admonition info "线程库；现代处理器和宽松内存模型" >}}
[直播录影](https://www.bilibili.com/video/BV13u411X72Q/)
/
[讲义页面](https://jyywiki.cn/OS/2022/slides/3.slides.html)
/
[阅读材料](https://jyywiki.cn/OS/2022/notes/2.html)
{{< /admonition >}}

- 程序 (源代码 S、二进制代码 C) = 状态机   
- 编译器 C = compile(S)

实际上源代码和二进制代码涉及状态转换的操作只有 **内存操作**，即只有内存操作才会改变状态，因为编译器的最佳化策略可能会对源代码对应的指令进行重排序，所以也可能对其中的内存操作指令 `load`, `store` 进行重排序，这就使得源代码状态机 $S$ 和二进制状态机 $C$ 并不完全等价，但只要保证二者的可观测行为是一致的即可，这也是编译器最佳化的理论基础。

函数调用相关的 `call` 和 `return` 语句分别对应状态机的进入新状态和返回原状态 (一般情况下，如果没有 side-affect 的话)，可以从上面所说的内存操作/内存状态变化的角度来思考。

- 应用视角的操作系统 = syscall 指令

应用程序对应的状态机自身可转换的状态有限，很多状态都无法仅通过自己达到，所以需要操作系统外加干涉转换成新的状态

{{< admonition >}}
单线程程序是 deterministic 状态机，而多线程程序则是 non-deterministic 状态机，这是因为某个时刻，选择哪一个线程执行是不确定的，而一个线程执行对应了一个状态转换 (因为内存状态发生了变化)，所以是 non-deterministic 状态机。
{{< /admonition >}}

{{< admonition tip >}}
对于新事物的学习，先在网上搜寻 Tutorial 教程阅读，再查阅 Manual 手册，这样效果比较好
{{< /admonition >}}

虽然 `printf` 有缓冲区，但它是多线程安全的:

- man 3 printf
```
|Interface               │ Attribute     |
|printf(), fprintf(),    │ Thread safety |
```

> 编译器对内存访问 “eventually consistent” 的处理导致共享内存作为线程同步工具的失效。

*编译器* 和 *处理器* 都可以进行 **指令重排序**，这导致了写并发程序的困难

延伸阅读:
- [ ] Intel 中国: [CPU架构全览: CPU微架构又是啥？](https://www.bilibili.com/video/BV1844y1z7Dx/)
- [並行程式設計: 執行順序](https://hackmd.io/@sysprog/concurrency/%2F%40sysprog%2Fconcurrency-ordering) 

## 理解并发程序执行 

{{< admonition info "Peterson算法、模型检验与软件自动化工具" >}}
[直播录影](https://www.bilibili.com/video/BV15T4y1Q76V/)
/
[讲义页面](https://jyywiki.cn/OS/2022/slides/4.slides.html)
/
[阅读材料](https://jyywiki.cn/OS/2022/notes/2.html)
{{< /admonition >}}

---

> 作者: [vanJker](https://github.com/vanJker)  
> URL: https://ccrysisa.github.io/posts/nju-osdi-concurrency/  

