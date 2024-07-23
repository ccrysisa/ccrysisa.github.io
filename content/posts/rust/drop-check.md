---
title: "Crust of Rust: The Drop Check" 
subtitle:
date: 2024-07-08T11:21:32+08:00
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
  - Drop
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

> In this episode of Crust of Rust, we go over the \"drop check\" — another niche part of Rust that most people don\'t have to think about, but which rears its moderately attractive head occasionally when you use generic types in semi-weird ways. In particular, we explore how to implement a Norwegian version of `Box` (which is really just `Box` with a different name), and find that the straightforward implementation is not quite as flexible as the standard `Box` is due to the drop check. When we fix it, we then make it too flexible, and open ourselves the type up to undefined behavior. Which, in turn, we use the drop check to fix. Towards the end, we go through a particularly interesting example at the intersection of the drop check and variance in the form of (ab)using `std::iter::Empty`.

<!--more-->

- 整理自 [John Gjengset 的影片](https://www.youtube.com/watch?v=TJOFSMpJdzg)

## 影片注解

### from_raw vs. drop_in_place

```rs
```

直接使用 `drop_in_place` 只会 drop 被 `p` 指向的那部分数据 (位于 heap 中)，而不会 drop `Boks` 本身，而使用 `from_raw` 则两者都可以 drop 掉。

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

- Struct [std::boxed::Box](https://doc.rust-lang.org/std/boxed/struct.Box.html)
  - method [std::boxed::Box::into_raw](https://doc.rust-lang.org/std/boxed/struct.Box.html#method.into_raw)
  - method [std::boxed::Box::from_raw](https://doc.rust-lang.org/std/boxed/struct.Box.html#method.from_raw)

- Function [std::ptr::drop_in_place](https://doc.rust-lang.org/std/ptr/fn.drop_in_place.html)

## References

- The Rustonomicon: [Drop Check](https://doc.rust-lang.org/nomicon/dropck.html)
