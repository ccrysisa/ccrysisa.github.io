---
title: "并行程序设计: 概念"
subtitle:
date: 2024-03-08T17:29:25+08:00
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
  - Lock-Free
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
