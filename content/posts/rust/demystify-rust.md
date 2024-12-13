---
title: "Tutorial: Rust Language Demystified"
subtitle:
date: 2024-04-05T17:52:13+08:00
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

{{< image src="/images/rust/rust.png" caption="Crustacean" >}}

<!--more-->

## 基础入门

### 变量绑定与解构

使用变量绑定而不是变量赋值对于 Rust 所有权诠释的非常准确，下面这段话学完所有权后再看有不一样的体会:

{{< admonition quote >}}
为何不用赋值而用绑定呢（其实你也可以称之为赋值，但是绑定的含义更清晰准确）？这里就涉及 Rust 最核心的原则——所有权，简单来讲，任何内存对象都是有主人的，而且一般情况下完全属于它的主人，绑定就是把这个对象绑定给一个变量，让这个变量成为它的主人（聪明的读者应该能猜到，在这种情况下，该对象之前的主人就会丧失对该对象的所有权），像极了我们的现实世界，不是吗？
{{< /admonition >}}

变量作用域本质上是栈帧，所以可以实现类似函数调用的变量遮蔽。但与栈帧有一点不同，它可以访问作用域外面的数据，而栈帧则不行。这是因为每一次函数调用的上文可能不同（调用者不同导致上文不同），所以不能安全地访问栈帧外的数据，而变量作用域的上文是固定的（变量作用域常出现于函数内部，即作用域之前的语句都是固定的），所以可以安全地访问作用域外部数据。当然因为变量遮蔽无法访问作用域外部的同名变量。

## References

- [Rust 语言圣经 (Rust Course)](https://course.rs/)
- [Rust By Practice (Rust 练习实践)](https://practice-zh.course.rs/)
- [CodeCrafters](https://app.codecrafters.io/)
