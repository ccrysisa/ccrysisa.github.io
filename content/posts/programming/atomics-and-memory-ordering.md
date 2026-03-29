---
title: "Crust of Rust: Atomics and Memory Ordering"
subtitle:
date: 2025-04-08T11:31:33+08:00
slug: fb82af6
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
  - Atomic
  - Memory Order
categories:
  - Crust of Rust
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRelated: false
hiddenFromFeed: false
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

{{< admonition type=abstract title="Abstract" >}}
In this episode of Crust of Rust, we go over Rust\'s atomic types, including the mysterious Ordering enum. In particular, we explore the std::sync::atomic module, and look at how its components can be used to implement concurrency primitives like mutexes. We also investigate some of the gotchas and sometimes counter-intuitive behaviors of the atomic primitives with different memory orderings, as well as strategies for testing for and debugging errors in concurrent code.
{{< /admonition >}}

<!--more-->

## 计算模型

因为通用计算机是 **存取——计算** 模型，即存指令 (store) 和取指令 (load) 是两个单独的、不可分割的指令，所以在多线程模型中，对某一共享内存区域的存取，会导致线程可能无法获取该区域的最新值，导致未定义行为 (UB)。而 Atomic 指令则是将存和取这两个动作整合为不可分割的指令，以此保证在多线程模型中，通过 Atomic 指令使得线程读取的是该共享内存的最新值。

例如对于某一块共享内存区域 `M`，对它的预期操作是:

```
Thread A load
Thread A store
Thread B load
Thread B store
```

但是可能的操作顺序是下面这样，这会导致未定义行为 (UB):

```
Thread A load
Thread B load
Thread A store
Thread B store
```

通过 Atomic 指令可以保证操作按照预期进行:

```
       +----------------+
Atomic | Thread A load  |
       | Thread A store |
       +----------------+
Atomic | Thread B load  |
       | Thread B store |
       +----------------+
```

## 影片注解

### The Momory Model

{{< admonition type=quote title="The Rust Reference: [Memory model](https://doc.rust-lang.org/nightly/reference/memory-model.html)" >}}
The memory model of Rust is incomplete and not fully decided.
{{< /admonition >}}

虽然 Rust 的内存模型还未完成相关的标准或规格制定，但由于 Rust 的编译器是运用 LLVM 来编写的，所以一般来说 Rust 也遵守 C 语言特别是 C11 的内存模型。

某些架构例如 Intel x64 保证 64-bit 的 `usize` 的操作是原子的，但是这只是某种特殊架构的特色，并不是语言的标准或规格，如果需要保证程序的可移植性，必须采用 Atomic 指令来保障。

Atomic 同时限制了 CPU 和编译器的行为 (主要是它们的优化行为)，因为这两者都拥有重排序机制，而该机制在多线程模型下可能会导致未定义行为 (UB)，Atomic 的一个功能是防止未定义行为，所以使用 Atomic 操作会改变 CPU 和编译器的行为。

### Atomic vs. Mutex

Atomic 和 Mutex 的区别在于 Atomic 没有 lock 的概念，它仅仅是保证在相同时间内只有一个明确的操作，而 Mutex 可以对某块区域进行上锁，其他线程在该区域 locked 的时间内只能等待。所有 atomic operation 都是 lock-free，但它们不一定是 wait-free，因为在没有 fetch_and_add 的某些架构上，它们是通过 compare_and_swap 来实现的，所以在执行这些操作时可能需要线程进行等待，所以在某些架构上就不是 wait-free，而只是 lock-free。

### UnsafeCell

[UnsafeCell](https://doc.rust-lang.org/std/cell/struct.UnsafeCell.html) is the only way of fundamental level to get mutable access through a shared reference or shared references.

因此 Rust 的 Atomic 类型的底层也是由 `UnsafeCell` 构成的 (因为允许多个线程持有同一 Atomic 变量的引用，这只有不可变引用才能做到):

```rs
pub struct $atomic_type {
    v: UnsafeCell<$int_type>,
}
```

## References

- Jon Gjengset: [Crust of Rust: Atomics and Memory Ordering](https://www.youtube.com/watch?v=rMGWeSjctlY)
- The Rust Reference: [Memory model](https://doc.rust-lang.org/nightly/reference/memory-model.html)
- The Rust Standard Library: [Module atomic](https://doc.rust-lang.org/std/sync/atomic/index.html)
- cppreference: [std::memory_order](https://en.cppreference.com/w/cpp/atomic/memory_order)
- HackMD: [Crust of Rust: 筆記說明](https://hackmd.io/T6jGyghMS-Wq6F3ymCFJMg) / [Crust of Rust: Atomics and Memory Ordering](https://hackmd.io/2HDiZxKQQU-J3Cq7AMVIhw)
- matklad: [Spinlocks Considered Harmful](https://matklad.github.io/2020/01/02/spinlocks-considered-harmful.html)

## Appendix

这里列举视频中一些概念相关的 documentation 

**学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料**

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

- Module [std::sync::atomic](https://doc.rust-lang.org/std/sync/atomic/index.html)
  - Struct [std::sync::atomic::AtomicUsize](https://doc.rust-lang.org/std/sync/atomic/struct.AtomicUsize.html)
  - Enum [std::sync::atomic::Ordering](https://doc.rust-lang.org/std/sync/atomic/enum.Ordering.html)

- Struct [std::sync::Mutex](https://doc.rust-lang.org/std/sync/struct.Mutex.html)

- Struct [std::cell::UnsafeCell](https://doc.rust-lang.org/std/cell/struct.UnsafeCell.html)

- Struct [std::boxed::Box](https://doc.rust-lang.org/std/boxed/struct.Box.html)


- Trait [std::marker::Send](https://doc.rust-lang.org/std/marker/trait.Send.html)

- Trait [std::marker::Sync](https://doc.rust-lang.org/std/marker/trait.Sync.html)
