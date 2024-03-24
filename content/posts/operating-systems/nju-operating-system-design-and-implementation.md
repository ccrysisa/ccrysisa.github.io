---
title: "南京大学 操作系统: 设计与实现 重点提示"
subtitle:
date: 2024-03-24T10:01:43+08:00
draft: true
author:
  name: vanJker
  link: https://github.com/vanJker
  email: cjshine@foxmail.com
  avatar: https://avatars.githubusercontent.com/u/88960102?s=96&v=4
description:
keywords:
license:
comment: false
weight: 0
tags:
  - Linux
  - QEMU
  - RISC-V
categories:
  - Operating Systems
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

操作系统使用正确的抽象使构造庞大的计算机软件/硬件生态从不可能变为可能。这门课围绕操作系统是 **如何设计** (应用程序视角)、**怎样实现** (硬件视角) 两个角度展开，分为两个主要部分：

原理课 (并发/虚拟化/持久化)：以教科书内容为主，介绍操作系统的原理性内容。课程同时注重讲解操作系统相关的代码实现和编程技巧，包括操作系统中常用的命令行/代码工具、教学操作系统 xv6 的代码讲解等

理解操作系统最重要的实验部分:
- Mini labs (应用程序视角；设计)：通过实现一系列有趣的 (黑科技) 代码理解操作系统中对象存在的意义和操作系统 API 的使用方法、设计理念
- OS labs (计算机硬件视角；实现)：基于一个简化的硬件抽象层实现多处理器操作系统内核，向应用程序提供一些基础操作系统 API

<!--more-->

以 [2022 年的 OS 课程](https://jyywiki.cn/OS/2022/index.html) 作为主线学习，辅以 [2023 年课程](https://jyywiki.cn/OS/2023/index.html) 和 [2024 年课程](https://jyywiki.cn/OS/2024/index.html) 的内容加以补充、扩展。

## 操作系统概述 (为什么要学操作系统) 

一个 Talk 的经典三段式结构: Why? What? How? (这个真是汇报的大杀器 :rofl:)

### 1950s 的计算机

I/O 设备的速度已经严重低于处理器的速度，中断机制出现 (1953)

希望使用计算机的人越来越多；希望调用 API 而不是直接访问设备

“批处理系统” = 程序的自动切换 (换卡) + 库函数 API

操作系统中开始出现 “设备”、“文件”、“任务” 等对象和 API

### 1960s 的计算机

可以同时载入多个程序而不用 “换卡” 了

能载入多个程序到内存且灵活调度它们的管理程序，包括程序可以调用的 API

既然操作系统已经可以在程序之间切换，为什么不让它们定时切换呢？
