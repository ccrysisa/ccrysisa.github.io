---
title: Atomics and Memory Ordering
subtitle:
date: 2025-04-08T11:31:33+08:00
slug: fb82af6
draft: true
author:
  name:
  link:
  email:
  avatar:
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

## 影片注解

## References

- The Rust Reference: [Memory model](https://doc.rust-lang.org/nightly/reference/memory-model.html)
- cppreference: [std::memory_order](https://en.cppreference.com/w/cpp/atomic/memory_order)

## Appendix

这里列举视频中一些概念相关的 documentation 

**学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料**

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)
