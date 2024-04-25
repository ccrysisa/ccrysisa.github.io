# 并行程序设计: POSIX Threads


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

## POSIX Threads



---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/posix-threads/  

