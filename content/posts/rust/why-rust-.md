---
title: "Why Rust?"
subtitle:
date: 2023-12-28T20:18:03+08:00
draft: false
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
  - Sysprog
categories:
  - Linux Kernel Internals
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
math: false
lightgallery: false
password:
message:
repost:
  enable: true
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

## Rust in 100 Seconds

观看短片: [Rust in 100 Seconds][rust-in-100s] :white_check_mark:
- [x] 了解 Rust，初步了解其安全性原理
- [x] 所有权 (ownership)
- [x] 借用 (borrow) 

{{< admonition warning >}}
0:55 This is wrong, value mutability doesn't have anything to do with the value being stored on the stack or the heap (and the example `let mut hello = "hi mom"` will be stored on the stack since it's type is `&'static str`), it depends on the type of the value (if it's `Sized` or not).
{{< /admonition >}}

## The adoption of Rust in Business (2022)

阅读报告: [The adoption of Rust in Business (2022)][2022-review-the-adoption-of-rust-in-business] :white_check_mark:

Rust 目前蓬勃发展，预测未来是很难的，但是 Rust 已经是进行时的未来了 :rofl:

## Visualizing memory layout of Rust's data types

YouTube: [Visualizing memory layout of Rust's data types](https://www.youtube.com/watch?v=7_o-YRxf_cc&t=0s) 

影片的中文翻译：

- [可视化 Rust 各数据结构的内存布局](https://www.bilibili.com/video/BV1KT4y167f1) [bilibili]

可搭配阅读相关的文档：

- [[2022-05-04] 可视化 Rust 各数据类型的内存布局](https://github.com/rustlang-cn/Rustt/blob/main/Articles/%5B2022-05-04%5D%20%E5%8F%AF%E8%A7%86%E5%8C%96%20Rust%20%E5%90%84%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B%E7%9A%84%E5%86%85%E5%AD%98%E5%B8%83%E5%B1%80.md)


[rust-in-100s]: https://youtu.be/5C_HPTJg5ek
[2022-review-the-adoption-of-rust-in-business]: https://rustmagazine.org/issue-1/2022-review-the-adoption-of-rust-in-business/