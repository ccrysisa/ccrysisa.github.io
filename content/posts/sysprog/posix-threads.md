---
title: "并行程序设计: POSIX Threads"
subtitle:
date: 2024-04-10T16:09:35+08:00
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
  - Linux
  - Concurrency
categories:
  - Concurrency
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

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/concurrency/%2F%40sysprog%2Fposix-threads" content="原文地址" external-icon=true >}}

## Process vs. Thread vs. Coroutines

> - With threads, the operating system switches running tasks preemptively according to its scheduling algorithm.
> 
> - With coroutines, the programmer chooses, meaning tasks are cooperatively multitasked by pausing and resuming functions at set points.
>   - coroutine switches are cooperative, meaning the programmer controls when a switch will happen.
>   - The kernel is not involved in coroutine switches.

一图胜千语:

{{< image src="https://hackpad-attachments.s3.amazonaws.com/embedded2016.hackpad.com_K6DJ0ZtiecH_p.537916_1460615185290_undefined" >}}

具体一点，从函数执行流程来看:

{{< image src="https://hackpad-attachments.s3.amazonaws.com/embedded2016.hackpad.com_K6DJ0ZtiecH_p.537916_1460615014454_undefined" >}}
$\rightarrow$ 在使用 coroutinues 后执行流程变成 $\rightarrow$
{{< image src="https://hackpad-attachments.s3.amazonaws.com/embedded2016.hackpad.com_K6DJ0ZtiecH_p.537916_1460615044111_undefined" >}}

C 语言程序中实作 coroutinue 的方法很多，例如「[C 语言: goto 和流程控制篇](https://hackmd.io/@sysprog/c-control-flow)」中提到的使用 `switch-case` 技巧进行实作。

### Thread & Process

{{< image src="https://imgur-backup.hackmd.io/QW1YWsC.png" >}}
{{< image src="https://imgur-backup.hackmd.io/gUF3Vz9.png" >}}

- Wikipedia: [Light-weight process](https://en.wikipedia.org/wiki/Light-weight_process)
> On Linux, user threads are implemented by allowing certain processes to share resources, which sometimes leads to these processes to be called "light weight processes".

- Wikipedia: [Thread-local storage](https://en.wikipedia.org/wiki/Thread-local_storage)
> On a modern machine, where multiple threads may be modifying the errno variable, a call of a system function on one thread may overwrite the value previously set by a call of a system function on a different thread, possibly before following code on that different thread could check for the error condition. The solution is to have errno be a variable that looks as if it is global, but is physically stored in a per-thread memory pool, the thread-local storage.

### PThread (POSIX threads)

{{< image src="https://imgur-backup.hackmd.io/0yeKpoT.png" >}}

POSIX 的全称是 Portable Operating System Interfaces，结合上图，所以你明白 pthread 的 P 代表的意义了吗？   
{{< details "Answer">}}
从 CPU 厂商群魔乱舞中诞生的标准，自然是要保证可移植 Portable 的啦 :rofl:
{{< /details >}}

下面的这个由 Lawrence Livermore National Laboratory 撰写的教程文档写的非常棒，值得一读 (他们还有关于 HPC 高性能计算的相关教程文档):
- [POSIX Threads Programming](https://hpc-tutorials.llnl.gov/posix/)

### Synchronizing Threads

3 basic synchronization primitives (为什么是这 3 个？请从 synchronized-with 关系进行思考)

- mutex locks
- condition variables
- semaphores

取材自 Ching-Kuang Shene 教授的讲义:

- [x] [Part IV Other Systems: IIIPthreads: A Brief Review](http://pages.mtu.edu/~shene/FORUM/Taiwan-Forum/ComputerScience/004-Concurrency/WWW/SLIDES/15-Pthreads.pdf)

> Conditions in Pthreads are usually used with a mutex to enforce mutual exclusion.

#### mutex locks

```c
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
int pthread_mutex_init(pthread_mutex_t *mutex, pthread_mutexattr_t *attr);
int pthread_mutex_destroy(pthread_mutex_t *mutex);

int pthread_mutex_lock(pthread_mutex_t *mutex);
int pthread_mutex_unlock(pthread_mutex_t *mutex);
int pthread_mutex_trylock(pthread_mutex_t *mutex);
```

{{< image src="https://imgur-backup.hackmd.io/mE4l7n1.png" >}}

- Only the {{< style "background-color:green" "strong" >}}owner{{< /style >}} can unlock a mutex. Since mutexes cannot be copied, use pointers.
- If `pthread_mutex_trylock()` returns `EBUSY`, the lock is already locked. Otherwise, the calling thread becomes the owner of this lock.
- With `pthread_mutexattr_settype()`, the type of a mutex can be set to allow recursive locking or report deadlock if the owner locks again

{{< admonition >}}
单纯的 Mutex 无法应对复杂情形的「生产者-消费者」问题，例如单生产者单消费者、多生产者单消费者、单生产者多消费者，甚至是多生产者多消费者 :dizzy_face: 需要配合 condition variables

我有用 Rust 写过一个「多生产者单消费者」的程序，相关的博客解说在 [这里]({{< relref "../rust/channels" >}})
{{< /admonition >}}

#### condition variables

```c
int pthread_cond_init(pthread_cond_t *cond, const pthread_condattr_t  *attr);
int pthread_cond_destroy(pthread_cond_t *cond);

int pthread_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex);
int pthread_cond_signal(pthread_cond_t *cond);
int pthread_cond_broadcast(pthread_cond_t *cond); // all threads waiting on a condition need to be woken up
```

- Condition variables allow a thread to block until a specific condition becomes true
  - blocked thread goes to wait queue for condition
- When the condition becomes true, some other thread signals the blocked thread(s)
- Conditions in Pthreads are usually used with a mutex to enforce mutual exclusion.
  - the wait call should occur under the protection of a mutex

{{< image src="https://imgur-backup.hackmd.io/9gRzRDG.png" >}}

使用 condition variables 改写之前 mutex 部分的 producer 实作 (实作是单生产者单消费者模型，且缓冲区有 `MAX_SIZE` 个元素):

```c
void producer(char *buf) {
    for (;;) {
        pthread_mutex_lock(lock);
        while (count == MAX_SIZE)
            pthread_cond_wait(notFull, lock);
        buf[count] = getChar();
        count++;
        pthread_cond_signal(notEmpty);
        pthread_mutex_unlock(lock);
    }
}
```

#### semaphores

semaphores 是站在「资源的数量」的角度来看待问题，这与 condition variables 是不同的

```c
sem_t semaphore;
int sem_init(sem_t *sem, int pshared, unsigned int value);
int sem_wait(sem_t *sem);
int sem_post(sem_t *sem);
```

- Can do increments and decrements of semaphore value
- Semaphore can be initialized to any value
- Thread blocks if semaphore value is less than or equal to zero when a decrement is attempted
- As soon as semaphore value is greater than zero, one of the blocked threads wakes up and continues
  - no guarantees as to which thread this might be

{{< admonition >}}
总结一下，`mutex` 在意的是 **持有者**，`semaphore` 在意的是 **资源的总量**，而 `condition variables` 在意的是 **持有的条件**。
{{< /admonition >}}

## POSIX Threads

{{< image src="https://hackpad-attachments.s3.amazonaws.com/embedded2016.hackpad.com_xBRCF9BsC50_p.537916_1457976043696_fork-join.jpg" >}}

### 实例: 光线追踪

光线追踪 (Ray tracing) 相关:
- [2016q1 Homework #2](http://wiki.csie.ncku.edu.tw/embedded/2016q1h2)
- [UCLA Computer Science 35L, Winter 2016. Software Construction Laboratory](https://web.cs.ucla.edu/classes/winter16/cs35L/)
- [CS35L_Assign8_Multithreading](https://github.com/maxwyb/CS35L_Assign8_Multithreading)

光线追踪需要很大的运算量，所以我们可以自然地想到，能不能使用 pthreads 对运算进行加速，上面的最后一个链接就是对这种思路的实作。

编译与测试:

```bash
$ git clone https://github.com/maxwyb/CS35L_Assign8_Multithreading.git raytracing-threads
$ cd raytracing-threads
$ make clean all
$ ./srt 4 > out.ppm
$ diff -u out.ppm baseline.ppm
$ open out.ppm
```

预期得到下面的图：

{{< image src="https://hackpad-attachments.s3.amazonaws.com/embedded2016.hackpad.com_xBRCF9BsC50_p.537916_1457975632540_out.png" >}}

可以将上面的 `./srt` 命令后面的数字改为 1, 2, 8 之类的进行尝试，这个数字代表使用的执行绪的数量。另外，在 `./srt` 命令之前使用 `time` 命令可以计算本次进行光线追踪所使用的时间，由此可以对比不同数量执行绪下的效能差异。

可以看下相关的程式码 [main.c]():
```c
#include <pthread.h>
pthread_t* threadID = malloc(nthreads * sizeof(pthread_t));
int res = pthread_create(&threadID[t], 0, pixelProcessing, (void *)&intervals[t]);
int res = pthread_join(threadID[t], &retVal);
```
显然是经典的 **fork-join** 模型 (`pthread_create` 进行 "fork"，`pthread_join` 进行 "join")，注意这里并没有使用到 mutex 之类的互斥量，这是可以做到的，只要你事先区分开不相关的区域分别进行计算即可，即不会发生数据竞争，那么久没必要使用 mutex 了。

### POSIX Thread

- [POSIX Threads Programming](https://hpc-tutorials.llnl.gov/posix/)
> Condition variables provide yet another way for threads to synchronize. While mutexes implement synchronization by controlling thread access to data, {{< style "background-color:green" "strong" >}}condition variables allow threads to synchronize based upon the actual value of data.{{< /style >}}

condition variables 由两种不同的初始化方式:
- 静态初始化 (static): `PTHREAD_COND_INITIALIZER`
- 动态初始化 (dynamic): `pthread_cond_init()`

## Synchronization

CMU 15-213: Intro to Computer Systems

- $23^{rd}$ Lecture [Concurrent	Programming](https://www.cs.cmu.edu/afs/cs/academic/class/15213-f15/www/lectures/23-concprog.pdf)

{{< image src="/images/c/23-concprog-24.png" >}}

- $24^{rd}$ Lecture [Synchroniza+on:	Basics](https://www.cs.cmu.edu/afs/cs/academic/class/15213-f15/www/lectures/24-sync-basic.pdf)

{{< image src="/images/c/24-sync-basic-17.png" >}}

```
    # 以下四句為 Head 部分，記為 H
    movq    (%rdi), %rcx
    testq   %rcx, %rcx
    jle     .L2
    movl    $0, %eax

.L3:
    movq    cnt(%rip), %rdx # 讀取 cnt，記為 L
    addq    $1, %rdx        # 更新 cnt，記為 U
    movq    %rdx, cnt(%rip) # 寫入 cnt，記為 S
    # 以下為 Tail 部分，記為 T
    addq    $1, %rax
    cmpq    %rcx, %rax
    jne     .L3
.L2:
```

> cnt 使用 volatile 關鍵字聲明，意思是避免編譯器產生的程式碼中，透過暫存器來保存數值，無論是讀取還是寫入，都在主記憶體操作。

> 細部的步驟分成 5 步：H -> L -> U -> S -> T，尤其要注意 LUS 這三個操作，這三個操作必須在一次執行中完成，一旦次序打亂，就會出現問題，不同執行緒拿到的值就不一定是最新的。也就是說該函式的正確執行和指令的執行順序有關

> mutual exclusion (互斥) 手段的選擇，不是根據 CS 的大小，而是根據 CS 的性質，以及有哪些部分的程式碼，也就是，仰賴於核心內部的執行路徑。

> semaphore 和 spinlock 屬於不同層次的互斥手段，前者的實現仰賴於後者，可類比於 HTTP 和 TCP/IP 的關係，儘管都算是網路通訊協定，但層次截然不同

### Angrave's Crowd-Sourced System Programming Book used at UIUC

- [x] [Synchronization, Part 1: Mutex Locks](https://github.com/angrave/SystemProgramming/wiki/Synchronization%2C-Part-1%3A-Mutex-Locks)

> You can use the macro `PTHREAD_MUTEX_INITIALIZER` only for global ('static') variables. `m = PTHREAD_MUTEX_INITIALIZER` is equivalent to the more general purpose `pthread_mutex_init(&m,NULL)`. The init version includes options to trade performance for additional error-checking and advanced sharing options.

> Basically try to keep to the pattern of one thread initializing a mutex and one and only one thread destroying a mutex.

> This process runs slower because we lock and unlock the mutex a million times, which is expensive - at least compared with incrementing a variable. (And in this simple example we didn't really need threads - we could have added up twice!) A faster multi-thread example would be to add one million using an automatic(local) variable and only then adding it to a shared total after the calculation loop has finished

- [ ] [Synchronization, Part 2: Counting Semaphores](https://github.com/angrave/SystemProgramming/wiki/Synchronization%2C-Part-2%3A-Counting-Semaphores)
