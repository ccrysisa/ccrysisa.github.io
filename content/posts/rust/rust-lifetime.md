---
title: "Rust Lifetime: 由浅入深理解生命周期"
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
  - Lifetime
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

> 从基础到进阶讲解探讨 Rust 生命周期，不仅仅是 lifetime kata，还有更多的 lifetime 资料，都来讲解和探讨，从「入门 Rust」到「进阶 Rust」

<!--more-->

- 整理自 [@这周你想干啥](https://space.bilibili.com/50713701) 的 [教学影片](https://space.bilibili.com/50713701/channel/collectiondetail?sid=1453665)

## 引用 & 生命周期

{{< image src="/images/rust/rust-lifetime-01.png" >}}

## 生命周期标注

{{< image src="/images/rust/rust-lifetime-02.png" >}}

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

## References

- [LifetimeKata](https://tfpk.github.io/lifetimekata/)
