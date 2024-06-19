---
title: "Atomic Weapons: The C++ Memory Model and Modern Hardware"
subtitle:
date: 2024-06-19T09:43:11+08:00
slug: f56f311
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
  - Concurrency
  - C++
categories:
  - Concurrency
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRss: false
hiddenFromRelated: false
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

> This is a two-part talk that covers the C++ memory model, how locks and atomics and fences interact and map to hardware, and more. Even though we’re talking about C++, much of this is also applicable to Java and .NET which have similar memory models, but not all the features of C++ (such as relaxed atomics).

<!--more-->

- {{< link href="https://herbsutter.com/2013/02/11/atomic-weapons-the-c-memory-model-and-modern-hardware/" content="原文地址" external-icon=true >}} (里面有解说影片链接)

## 前置知识

至少把 Jserv 的 {{< link href="https://hackmd.io/@sysprog/concurrency/%2F%40sysprog%2Fconcurrency-ordering" content="并行程序设计: 执行顺序" external-icon=true >}} 的前半段 (即内存模型前面的那一部分) 掌握，特别是重要的概念 happens-before

## Part 1

### Optimizations, races, and the memory model  

3-1

3-2

5-2

7-2

8-2 
在没有编译器和处理器进行指令重排序的情况下，执行结果也可能不如你预期那样，因为 Store Buffer 和 Memmory 的内容可能不是一致的，这样造成的结果是:

> It's exactly as if you had reordered them and done the read before the write

Damn! 去除编译器和处理器的指令重排序后，居然还会出现和重排序一样的结果！！(这是 Cache 带来的挑战: 数据不一致) 虽然 Write 操作发生在 Read 之前 (Write **happeding-before** Read)，但是 Write 的效果在 Read 之后才可见 (Read **happens-before** Write)。所以编译器、处理器和 Cache 都可以做到指令重排序的效果。

BTW 这段程序里每个 thread 对 flag 的 Read 和 Write 在编译器 / 处理器看来是独立的 (independent)，它们没法推断出这两个操作之间的顺序 (ordering) 关系，所以极大可能会进行重排序，当然结果不会符合你的预期。

10-1

10-2 SC-DRF 提高了程序执行的效能

11-1

11-2
{{< admonition info "pink elephants" >}}
no sequential jump, for example, you hit step next and you go up, or you hit step next and your current line disappears and you\'re nowhere.
{{< /admonition >}}

### acquire and release ordering

### mutexes vs. atomics vs. fences

## Part 2

### Restrictions on compilers and hardware (incl. common bugs)

### code generation and performance on x86/x64, IA64, POWER, ARM, and more

### relaxed atomics; volatile

## 加餐

- bilibili: [「C++11」内存序究竟是什么，彻底参悟 C++ 内存模型 (附多线程安全测试通用框架)](https://www.bilibili.com/video/BV1Qy411q7Xq/)

