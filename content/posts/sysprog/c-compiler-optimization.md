---
title: "你所不知道的 C 语言: 编译器和最佳化原理篇"
subtitle:
date: 2024-04-24T21:09:59+08:00
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
  - C
  - Compiler
  - Optimization
categories:
  - C
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

> 編譯器最佳化篇將以 gcc / llvm 為探討對象，簡述編譯器如何運作，以及如何實現最佳化，佐以探究 C 編譯器原理和案例分析，相信可以釐清許多人對 C 編譯器的誤解，從而開發出更可靠、更高效的程式。

<!--more-->
