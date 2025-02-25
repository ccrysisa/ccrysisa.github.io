---
title: "Linux 核心设计: 透过 eBPF 观察操作系统"
subtitle:
date: 2025-02-18T17:01:30+08:00
slug: b8b13cc
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
  - Linux
categories:
  - Linux Kernel Internals
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRelated: false
hiddenFromFeed: false
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

## The Beginner's Guide to eBPF

[BCC](https://github.com/iovisor/bcc/tree/master) 要求的内核编译参数 Ubuntu 24.04 全部满足，根据安装说明进行手动编译安装，仓库的 [doc](https://github.com/iovisor/bcc/blob/master/docs) 目录下有相关教程和手册供参阅。

Kernel 中的 verifier 主要是负责检查 eBPF program 的非法行为，例如 dereference null pointer，从而阻止这些不合法行为。

## References

- Linux 核心設計: [透過 eBPF 觀察作業系統行為](https://hackmd.io/@sysprog/linux-ebpf?type=view)
- Liz Rice: [ebpf-beginners](https://github.com/lizrice/ebpf-beginners)
