---
title: "Crust of Rust: Channels"
subtitle:
date: 2024-02-29T20:30:30+08:00
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
  - Rust
  - Channel
categories:
  - Rust
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

- Trait [std::marker::Send](https://doc.rust-lang.org/std/marker/trait.Send.html)

