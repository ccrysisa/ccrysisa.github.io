# 并行程序设计: 概念


> 透过建立 Concurrency 和 Parallelism、Mutex 与 Semaphore 的基本概念，本讲座将透过 POSIX Tread 探讨 thread pool, Lock-Free Programming, lock-free 使用的 atomic 操作, memory ordering, M:N threading model 等进阶议题。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/concurrency/%2F%40sysprog%2Fconcurrency-concepts" content="原文地址" external-icon=true >}}

## Mutex 与 Semaphore

Mutex 和 Semaphore 在实作上可能是没有差异的 (例如早期的 Linux)，但是 Mutex 与 Semaphore 在使用上是有显著差异的:

- process 使用 Mutex 就像使用一把锁，谁先跑得快就能先获得锁，释放锁 "解铃还须系铃人"，并且释放锁后不一定能立即调度到等待锁的 process (如果想立即调度到等待锁的 process 需要进行显式调度)
- process 使用 Semaphore 就如同它的名字类似 "信号枪"，process 要么是等待信号的选手，要么是发出信号的裁判，并且裁判在发出信号后，选手可以立即收到信号并调度 (无需显式调度)。并不是你跑得快就可以先获得，如果你是选手，跑得快你也得停下来等裁判到场发出信号 :rofl:

{{< admonition >}}
关于 Mutex 与 Semphore 在使用手法上的差异，可以参考我使用 Rust 实现的 [Channel](https://github.com/ccrysisa/rusty/tree/main/mpsc)，里面的 `Share<T>` 结构体包含了 Mutex 和 Semphore，查看相关方法 (`send` 和 `recv`) 来研究它们在使用手法的差异。

除此之外，Semaphore 的选手和裁判的数量比例不一定是 $1:1$，可以是 $m:n$
{{< /admonition >}}

## CTSS

- [ ] Fernando J. Corbato: [1963 Timesharing: A Solution to Computer Bottlenecks](https://www.youtube.com/watch?v=Q07PhW5sCEk)

## 可重入性 (Reentrancy)

> 一個可再進入 (reentrancy) 的函式是可被多個工作同時呼叫，而不會有資料不一致的問題。簡單來說，一個可再進入的函式，會避免在函式中使用任何共享記憶區 (global memory)，所有的變數與資料均存在呼叫者的資料區或函式本身的堆疊區 (stack memory)。

## 经典的 Fork-join 模型

{{< image src="https://hackmd.io/_uploads/S1wxT_y6a.png" >}}
$\rightarrow$
{{< image src="https://hackmd.io/_uploads/SkF-6_16p.png" >}}
$\rightarrow$
{{< image src="https://hackmd.io/_uploads/SkF-6_16p.png" >}}
$\rightarrow$
{{< image src="https://hackmd.io/_uploads/BkvMpukTa.png" >}}

---

{{< image src="https://hackmd.io/_uploads/SJtQpdyT6.png" caption="Fork-join Parallelism" >}}

{{< image src="https://hackmd.io/_uploads/S1lQ6_1pa.png" caption="Fork/join model" >}}

从图也可以看出，设定一个 join 点是非常必要的 (通常是由主执行绪对 join 点进行设置)，因为 fork 之后新增的执行绪有可能立刻就执行完毕了，然后当主执行绪到达 join 点时，即可 join 操作进行下一步，也有可能 fork 之后新增的执行绪是惰性的，它们只有当主执行绪到达 join 点时，才会开始执行直到完毕，即主执行绪先抵达 join 点等待其它执行绪完成执行，从而完成 join 操作接着进行下一步。

因为 fork 操作时分叉处的执行绪的执行流程，对于主执行绪是无法预测的 (立刻执行、惰性执行、...)，所以设定一个 join 点可以保证在这个 join 点时主执行绪和其它分叉的执行绪的执行预期行为一致，即在这个 join 点，不管是主执行绪还是分叉执行绪都完成了相应的执行流程。

## Concurrency 和 Parallelism

- [ ] Rob Pike: [Concurrency Is Not Parallelism](https://www.youtube.com/watch?v=qmg1CF3gZQ0) / [slides](https://go.dev/talks/2012/waza.slide#1)
  - [Stack Overflow 上的相关讨论](https://stackoverflow.com/questions/11700953/concurrency-is-not-parallelism)

> **Concurrency** 是指程式架構，將程式拆開成多個可獨立運作的工作。案例: 裝置驅動程式，可獨立運作，但不需要平行化。

> **Parallelism** 是指程式執行，同時執行多個程式。Concurrency 可能會用到 parallelism，但不一定要用 parallelism 才能實現 concurrency。案例: 向量內積計算

{{< image src="/images/c/cnp.png" caption="Concurrent, non-parallel execution" >}}
{{< image src="/images/c/cp.png" caption="Concurrent, parallel execution" >}}

- Tim Mattson (Intel): [Introduction to OpenMP](https://www.youtube.com/playlist?list=PLLX-Q6B8xqZ8n8bwjGdzBJ25X2utwnoEG) [YouTube]

---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/concurrency-concepts/  

