# Crust of Rust: Channels


> In this (fifth) Crust of Rust video, we cover multi-produce/single-consumer (mpsc) channels, by re-implementing some of the std::sync::mpsc types from the standard library. As part of that, we cover what channels are used for, how they work at a high level, different common channel variants, and common channel implementations. In the process, we go over some common Rust concurrency primitives like Mutex and Condvar.

<!--more-->

- 整理自 [John Gjengset 的影片](https://www.youtube.com/watch?v=b4mS5UPHh20)

## Channel

- Wikipedia: [Channel](https://en.wikipedia.org/wiki/Channel_(programming))

{{< admonition quote >}}
In computing, a **channel** is a model for [interprocess communication](https://en.wikipedia.org/wiki/Interprocess_communication) and [synchronization](https://en.wikipedia.org/wiki/Synchronization) via [message passing](https://en.wikipedia.org/wiki/Message_passing). A message may be sent over a channel, and another process or thread is able to receive messages sent over a channel it has a [reference](https://en.wikipedia.org/wiki/Reference_(computer_science)) to, as a [stream](https://en.wikipedia.org/wiki/Stream_(computing)). 
{{< /admonition >}}

- YouTube: [Channels in Rust](https://www.youtube.com/watch?v=vFCTpxuGwpw)

{{< image src="https://marketsplash.com/content/images/2023/09/rust-channels.png" >}}
> [Source](https://marketsplash.com/tutorials/rust/rust-channels/)

### Concurrency vs Parallelism

- [What is the difference between concurrency and parallelism?](https://stackoverflow.com/questions/1050222/what-is-the-difference-between-concurrency-and-parallelism)
- [Concurrency vs. Parallelism — A brief view](https://medium.com/@itIsMadhavan/concurrency-vs-parallelism-a-brief-review-b337c8dac350)

## 影片注解

### Sender & Receiver

{{< image src="/images/rust/mpsc.drawio.svg" caption="multi-produce/single-consumer (mpsc)" >}}

- Why does the recevier type need to have an arc protected by mutex if the channel may only have a single consumer thread?
> Because a send and a recevie might happen at the same time, and they need to be mutually exclusive to each other as well.

- Why not use a boolean semaphore over the implementation in mutex?
> A boolean semaphore is basically a boolean flag that you check and atomically update. 
> The problem there is if the flag is currently set (someone else is in the critical section), with a boolean semaphore, you have to spin, you have to repeatedly check it. 
> Whereas with a mutex, the operating system can put the thread to sleep and wake it back up when the mutex is available, which is generally more efficient although adds a little bit of latency.

### Condition Variable

- method [std::sync::Condvar::wait](https://doc.rust-lang.org/std/sync/struct.Condvar.html#method.wait)
> This function will atomically unlock the mutex specified (represented by guard) and block the current thread. This means that any calls to notify_one or notify_all which happen logically after the mutex is unlocked are candidates to wake this thread up. When this function call returns, the lock specified will have been re-acquired.

- method [std::sync::Condvar::notify_one](https://doc.rust-lang.org/std/sync/struct.Condvar.html#method.notify_one)
> If there is a blocked thread on this condition variable, then it will be woken up from its call to wait or wait_timeout. Calls to notify_one are not buffered in any way.

{{< image src="/images/rust/send_recv.drawio.svg" caption="wait & notify" >}}

### Clone

对 `struct Sender<T>` 标注属性宏 `#[derive(clone)]` 会实现以下的 triat:

```rs
impl<T: Clone> Clone for Sender<T> { ... }
```

但是对于 `Sender<T>` 的成员 `Arc<Inner<T>>` 来说，`Arc` 可以 clone 无论内部类型 `T` 是否实现了 Clone 这个 trait，所以我们需要手动实现 Clone 这个 trait。这也是 `#[derive(clone)]` 和手动实现 `impl Clone` 的一个细小差别。

```rs
impl<T> Clone for Sender<T> { ... }
```

为了防止调用 clone 产生的二义性 (因为编译器会自动解引用)，建议使用 explict 方式来调用 `Arc::clone()`，这样编译器就会知道调用的是 Arc 的 clone 方法，而不是 Arc 内部 object 的 clone 方法。

```rs
let inner = Arc<Inner<T>>;
inner.clone();      // Inner<T>'s clone method? or Arc::clone method?
Arc::clone(&inner); // explict Arc::clone !
```

### dbg

- Macro [std::dbg](https://doc.rust-lang.org/std/macro.dbg.html)

{{< admonition quote >}}
Prints and returns the value of a given expression for quick and dirty debugging.

```rs
let a = 2;
let b = dbg!(a * 2) + 1;
//      ^-- prints: [src/main.rs:2] a * 2 = 4
assert_eq!(b, 5);
```

The macro works by using the Debug implementation of the type of the given expression to print the value to stderr along with the source location of the macro invocation as well as the source code of the expression.
{{< /admonition >}}

调试的大杀器，作用类似于 kernel 中的 debugk 宏 :rofl: 常用于检测程序运行时是否执行了某些语句，以及这些语句的值如何。

### Performance optimization

> Every operation takes the lock and that\'s fine if you have a channel that is not very high performance, but if you wanted like super high performance, like you have a lot of sends that compete with each other, then you might not want the sends to contend with one another.
> 
> Image that you have 10 threads are trying to send at the same time, you could perhaps write an implementation that allows them to do that. The only thing that really needs to be synchronized is the senders with the receivers, as opposed to the senders with one another, whereas we\'re actually locking all of them.

使用 `VecDeque` 作为缓冲区，会导致 send 时的效能问题。因为 send 是使用 `push_back` 方法来将 object 加入到 `VecDeque` 中，这个过程 `VecDeque` 可能会发生 resize 操作，这会花费较长时间并且在这个过程时 sender 仍然持有 Mutex，所以导致其他 sender 和 recevier 并不能使用 `VecDeque`，所以在实作中并不使用 `VecDeque` 以避免相应的效能损失。

因为只有一个 receiver，所以可以通过缓冲区来提高效能，一次性接受大批数据并进行缓存，而不是每次只接收一个数据就放弃 Mutex (Batch recv optimization)。当然这个如果使用 `VecDeque` 依然会在 recv 时出现上面的 resize 效能问题。

### Synchronous channels

- Module [std::sync::mpsc](https://doc.rust-lang.org/std/sync/mpsc/index.html)
> These channels come in two flavors:
> 
> 1. An asynchronous, infinitely buffered channel. The `channel` function will return a `(Sender, Receiver)` tuple where all sends will be **asynchronous** (they never block). The channel conceptually has an infinite buffer.
> 
> 2. A synchronous, bounded channel. The `sync_channel` function will return a (SyncSender, Receiver) tuple where the storage for pending messages is a pre-allocated buffer of a fixed size. All sends will be **synchronous** by blocking until there is buffer space available. Note that a bound of 0 is allowed, causing the channel to become a "rendezvous" channel where each sender atomically hands off a message to a receiver.

### Channel flavors

- **Synchronous channels**: Channel where send() can block. Limited capacity.
  - Mutex + Condvar + VecDeque
  - Atomic VecDeque (atomic queue) + thread::park + thread::Thread::notify
- **Asynchronous channels**: Channel where send() cannot block. Unbounded.
  - Mutex + Condvar + VecDeque
  - Mutex + Condvar + LinkedList
  - Atomic linked list, linked list of T
  - Atomic block linked list, linked list of atomic VecDeque<T>
- **Rendezvous channels**: Synchronous with capacity = 0. Used for thread synchronization.
- **Oneshot channels**: Any capacity. In practice, only one call to send().

### async/await

- Module [std::future](https://doc.rust-lang.org/std/future/index.html)
- Keyword [async](https://doc.rust-lang.org/std/keyword.async.html)
- Keyword [await](https://doc.rust-lang.org/std/keyword.await.html)

## Homework

{{< admonition info >}}
实作说明:
- [ ] 尝试实现 Synchronous channels 
  - 使用 Atomic 存储 senders 以提高效能
  - 使用两个 ConVar 来指示 sender 和 receiver 进行 block 和 wake up
  - receiver 被 drop 时需要通知所有 senders 以释放资源
  - 使用 linked list 来取代 VecDeque 以避免 resize 的效能损失
- 尝试阅读 std 中 mpsc 的实现 [Module std::sync::mpsc](https://doc.rust-lang.org/src/std/sync/mpsc/mod.rs.html#1-1246https://doc.rust-lang.org/src/std/sync/mpsc/mod.rs.html#1-1246)
  - 对比阅读其他库关于 channel 的实现: [crossbeam](https://github.com/crossbeam-rs/crossbeam), [flume](https://github.com/zesterer/flume)

参考资料:
- Module [std::sync::atomic](https://doc.rust-lang.org/std/sync/atomic/index.html)
- Module [std::sync::mpsc](https://doc.rust-lang.org/src/std/sync/mpsc/mod.rs.html#1-1246https://doc.rust-lang.org/src/std/sync/mpsc/mod.rs.html#1-1246)
- Crate [crossbeam](https://docs.rs/crossbeam/latest/crossbeam/)
- Crate [flume](https://docs.rs/flume/latest/flume/)
{{< /admonition >}}

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

- Module [std::sync::mpsc](https://doc.rust-lang.org/std/sync/mpsc/index.html)
  - Function [std::sync::mpsc::channel](https://doc.rust-lang.org/std/sync/mpsc/fn.channel.html)
  - Struct [std::sync::mpsc::Sender](https://doc.rust-lang.org/std/sync/mpsc/struct.Sender.html)
  - Struct [std::sync::mpsc::Receiver](https://doc.rust-lang.org/std/sync/mpsc/struct.Receiver.html)

- Module [std::sync](https://doc.rust-lang.org/std/sync/index.html)
  - Struct [std::sync::Arc](https://doc.rust-lang.org/std/sync/struct.Arc.html)
  - Struct [std::sync::Mutex](https://doc.rust-lang.org/std/sync/struct.Mutex.html)
  - Struct [std::sync::Condvar](https://doc.rust-lang.org/std/sync/struct.Condvar.html)
    - method [std::sync::Condvar::wait](https://doc.rust-lang.org/std/sync/struct.Condvar.html#method.wait)
    - method [std::sync::Condvar::notify_one](https://doc.rust-lang.org/std/sync/struct.Condvar.html#method.notify_one)

- Module [std::sync::atomic](https://doc.rust-lang.org/std/sync/atomic/index.html)

- Trait [std::marker::Send](https://doc.rust-lang.org/std/marker/trait.Send.html)

- Struct [std::collections::VecDeque](https://doc.rust-lang.org/std/collections/struct.VecDeque.html)

- Function [std::mem::take](https://doc.rust-lang.org/std/mem/fn.take.html)

- Function [std::mem::swap](https://doc.rust-lang.org/std/mem/fn.swap.html)

- Macro [std::dbg](https://doc.rust-lang.org/std/macro.dbg.html)

## Further readings

- Go 语言也有 channel: [解说 Go channel 底层原理](https://www.bilibili.com/video/BV1uv4y187p6)
- [x] [可能不是你看过最无聊的 Rust 入门喜剧 102 (3) 多线程并发](https://www.bilibili.com/video/BV1DK42147jb)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/channels/  

