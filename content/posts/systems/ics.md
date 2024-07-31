---
title: "计算机系统基础"
subtitle:
date: 2024-03-31T16:03:59+08:00
# draft: true
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
categories:
  - Systems
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

Introduction to Computer Systems (ICS)

<!--more-->

## Brown CSCI 0300

- https://cs.brown.edu/courses/csci0300/2024/

## NJU ICS

> 理解一个系统的最佳实践就是去实现它。因此在本课程的PA 部分，你将会在框架代码的基础上实现一个 RISC-V 全系统模拟器 NEMU，它不仅能运行各类测试程序，甚至还可以运行操作系统和 “仙剑奇侠传”。模拟过硬件的执行，自然就能深 (痛) 入 (苦) 理解计算机系统了。

[课程网页](http://why.ink:8080/ICS/2023/) 
| [直播录影](https://space.bilibili.com/49964811/channel/seriesdetail?sid=3843953)
| [实验讲义](https://nju-projectn.github.io/ics-pa-gitbook/ics2023/index.html)

{{< admonition info >}}
授课视频的直播录影与 PA/Lab 并没有先后次序的强关联性，授课主要是分享一些在 PA/Lab 时可派上用场的小工具，所以授课视频之间也没有先后次序，按需观看即可。
{{< /admonition >}}

### Programming Assignmets (PA)

#### PA0: 环境安装与配置

- [x] Installing GNU/Linux
- [x] First Exploration with GNU/Linux
- [x] Installing Tools
- [ ] Configuring vim
- [ ] More Exploration
- [ ] Getting Source Code for PAs

安装文档进行配置即可，我使用的 Linux 发行版是 deepin 20.9

```bash
$ neofetch --stdout
cai@cai-PC 
---------- 
OS: Deepin 20.9 x86_64 
Host: RedmiBook 14 II 
Kernel: 5.15.77-amd64-desktop 
Uptime: 45 mins 
Packages: 2146 (dpkg) 
Shell: bash 5.0.3 
Resolution: 1920x1080 
DE: Deepin 
WM: KWin 
Theme: deepin-dark [GTK2/3] 
Icons: bloom-classic-dark [GTK2/3] 
Terminal: deepin-terminal 
CPU: Intel i7-1065G7 (8) @ 3.900GHz 
GPU: NVIDIA GeForce MX350 
GPU: Intel Iris Plus Graphics G7 
Memory: 3967MiB / 15800MiB 
```

一些有意思的超链接:
- Wikipedia: [Unix philosophy](https://en.wikipedia.org/wiki/Unix_philosophy)
- [Command line vs. GUI](https://www.computerhope.com/issues/ch000619.htm)
