---
title: "不基础的 Python 基础"
subtitle:
date: 2024-06-04T16:29:40+08:00
draft: true
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
  - Python
categories:
  - Toolkit
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

<!--more-->

- 整理自 [@码农高天](https://space.bilibili.com/245645656) 的 [视频合集](https://space.bilibili.com/245645656/channel/collectiondetail?sid=346060)

## 字节码和虚拟机

每一个 function call 都会对应到建立一个 frame，而 bytecode 则是对应 frame 里的内容 (最开始的部分也会建立一个 frame，可以理解为一个 function call，类似于 C 语言的运行时环境)，Python 运行时一条一条的往 frame 里填充 Python 语句对应的 bytecode，而每一条 bytecode 则执行相应的 (虚拟机的) C 语言代码 (s)，并且因为 Python 虚拟机是 Stack-Based 的，所以每一条 bytecode 都可能与栈进行交互。使用 frame 这样的机制方便使用 JIT 对虚拟机的性能进行增强。




