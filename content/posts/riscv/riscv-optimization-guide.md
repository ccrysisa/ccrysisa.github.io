---
title: RISC-V Optimization Guide
subtitle:
date: 2024-02-29T23:44:29+08:00
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
  - RISC-V
  - Optimization
  - Architecture
categories:
  - RISC-V
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

> The intention is to give specific actionable optimization recommendations for software developers writing code for RISC-V application processors.
> 
> 近日 RISE 基金会发布了一版 《RISC-V Optimization Guide》，其目的是为给 RISC-V 应用处理器编写代码的软件开发人员提供具体可行的优化建议。本次活动的主要内容是解读和讨论该文档内容。

<!--more-->

- {{< link href="https://riscv-optimization-guide-riseproject-c94355ae3e6872252baa952524.gitlab.io/riscv-optimization-guide.html" content="原文地址" external-icon=true >}}
- {{< link href="https://riscv-optimization-guide-riseproject-c94355ae3e6872252baa952524.gitlab.io/riscv-optimization-guide.pdf" content="原文 PDF" external-icon=true >}}
- {{< link href="https://www.bilibili.com/video/BV1Ft421t7PS" content="解说录影" external-icon=true >}}

## 相关知识

RISC-V ISA 规格书: https://riscv.org/technical/specifications/

推荐参考 [体系结构如何作用于编译器后端-邱吉](https://www.bilibili.com/video/BV1a84y1S7J7) [bilibili] 
- 这个讲座是关于微架构、指令集是怎样和编译器、软件相互协作、相互影响的 Overview
- 这个讲座介绍的是通用 CPU 并不仅限于 RISC-V 上

## Detecting RISC-V Extensions on Linux

### Multi-versioning


- 最新进展: https://reviews.llvm.org/D151730
- 相关介绍: https://maskray.me/blog/2023-02-05-function-multi-versioning

## Optimizing Scalar Integer

- [RV32G 下 lui/auipc 和 addi 结合加载立即数时的补值问题](https://zhuanlan.zhihu.com/p/374235855)

有关 RISC-V 的 imm 优化:
- Craig Topper: [2022 LLVM Dev Mtg: RISC-V Sign Extension Optimizations](https://www.youtube.com/watch?v=TmWs3QsSuUg)
- [改进RISC-V的代码生成-廖春玉](https://www.bilibili.com/video/BV1pN411H7Y3)

## Optimizing Scalar Floating Point

## Optimizing Vector

- What about vector instructions? YouTube: [Introduction to SIMD](https://www.youtube.com/watch?v=o_n4AKwdfiA)


