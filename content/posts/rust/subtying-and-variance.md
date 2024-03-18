---
title: "Crust of Rust: Subtying and Variance"
subtitle:
date: 2024-03-17T10:38:01+08:00
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
  - Subtying
  - Variance
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

> In this episode of Crust of Rust, we go over subtyping and variance — a niche part of Rust that most people don't have to think about, but which is deeply ingrained in some of Rust's borrow ergonomics, and occasionally manifests in confusing ways. In particular, we explore how trying to implement the relatively straightforward `strtok` function from C/C++ in Rust quickly lands us in a place where the function is more or less impossible to call due to variance!

<!--more-->

- 整理自 [John Gjengset 的影片](https://www.youtube.com/watch?v=iVYWDIW71jk)

## 影片注解

### strtok

> A sequence of calls to this function split str into tokens, which are sequences of contiguous characters separated by any of the characters that are part of delimiters.

- cplusplus: [strtok](https://cplusplus.com/reference/cstring/strtok/)
- cppreference: [strtok](https://en.cppreference.com/w/cpp/string/byte/strtok)

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

- method [str::find](https://doc.rust-lang.org/std/primitive.str.html#method.find)

## References

- The Rust Reference: [Subtyping and Variance](https://doc.rust-lang.org/reference/subtyping.html)
- The Rustonomicon: [Subtyping and Variance](https://doc.rust-lang.org/nomicon/subtyping.html)
