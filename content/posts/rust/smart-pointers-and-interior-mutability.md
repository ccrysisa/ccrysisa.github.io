---
title: "Crust of Rust: Smart Pointers and Interior Mutability"
subtitle:
date: 2024-02-20T17:33:06+08:00
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
  - Smart pointer
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

> In this fourth Crust of Rust video, we cover smart pointers and interior mutability, by re-implementing the Cell, RefCell, and Rc types from the standard library. As part of that, we cover when those types are useful, how they work, and what the equivalent thread-safe versions of these types are. In the process, we go over some of the finer details of Rust's ownership model, and the UnsafeCell type. We also dive briefly into the Drop Check rabbit hole (https://doc.rust-lang.org/nightly/nomicon/dropck.html) before coming back up for air.

<!--more-->

- 整理自 [John Gjengset 的影片](https://www.youtube.com/watch?v=8O0Nt9qY_vo)

## 影片注解

### Interior Mutability

Module [std::cell](https://doc.rust-lang.org/std/cell/index.html)

> Rust memory safety is based on this rule: Given an object T, it is only possible to have one of the following:
> 
> - Having several immutable references (&T) to the object (also known as aliasing).
> - Having one mutable reference (&mut T) to the object (also known as mutability).

> Values of the Cell<T>, RefCell<T>, and OnceCell<T> types may be mutated through shared references (i.e. the common &T type), whereas most Rust types can only be mutated through unique (&mut T) references. We say these cell types provide ‘interior mutability’ (mutable via &T), in contrast with typical Rust types that exhibit ‘inherited mutability’ (mutable only via &mut T).

- We can use (several) immutable references of a cell to mutate the thing inside of the cell.
- There is (virtually) no way for you to get a reference to the thing inside of a cell. 
- Because if no one else has a pointer to it (the thing inside of a cell), the changing it is fine. 

Struct [std::cell::UnsafeCell](https://doc.rust-lang.org/std/cell/struct.UnsafeCell.html)

> If you have a reference &T, then normally in Rust the compiler performs optimizations based on the knowledge that &T points to immutable data. Mutating that data, for example through an alias or by transmuting an &T into an &mut T, is considered undefined behavior. UnsafeCell<T> opts-out of the immutability guarantee for &T: a shared reference &UnsafeCell<T> may point to data that is being mutated. This is called “interior mutability”.

> The UnsafeCell API itself is technically very simple: .get() gives you a raw pointer *mut T to its contents. It is up to you as the abstraction designer to use that raw pointer correctly.

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

- Module [std::cell](https://doc.rust-lang.org/std/cell/index.html)
  - Struct [std::cell::UnsafeCell](https://doc.rust-lang.org/std/cell/struct.UnsafeCell.html)
  - Struct [std::cell::Cell](https://doc.rust-lang.org/std/cell/struct.Cell.html)
  - Struct [std::cell::RefCell](https://doc.rust-lang.org/std/cell/struct.RefCell.html)

- Module [std::rc](https://doc.rust-lang.org/std/rc/index.html)

- Module [std::sync](https://doc.rust-lang.org/std/sync/index.html)
  - Struct [std::sync::Arc](https://doc.rust-lang.org/std/sync/struct.Arc.html)

- function [std::thread::spawn](https://doc.rust-lang.org/std/thread/fn.spawn.html)
