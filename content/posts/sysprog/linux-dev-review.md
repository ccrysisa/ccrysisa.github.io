---
title: "Linux 核心设计: 发展动态回顾"
subtitle:
date: 2024-03-03T16:07:14+08:00
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

> 本講座將以 Thorsten Leemhuis 在 FOSDEM 2020 開場演說 "Linux kernel – Solving big problems in small steps for more than 20 years" (slides) 為主軸，嘗試歸納自 21 世紀第一年開始的 Linux 核心 2.4 版到如今的 5.x 版，中間核心開發者如何克服 SMP (Symmetric multiprocessing), scalability, 及各式硬體架構和周邊裝置支援等難題，過程中提出全面移除 BKL (Big kernel lock)、實作虛擬化技術 (如 Xen 和 KVM)、提出 namespace 和 cgroups 從而確立容器化 (container) 的能力，再來是核心發展的明星技術 eBPF 會在既有的基礎之上，帶來 XDP 和哪些令人驚豔的機制呢？又，Linux 核心終於正式納入發展十餘年的 PREEMPT_RT，使得 Linux 核心得以成為硬即時的作業系統，對內部設計有哪些衝擊？AIO 後繼的 io_uring 讓 Linux 有更優雅且高效的非同步 I/O 存取，我們該如何看待？

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/linux-dev-review" content="原文地址" external-icon=true >}}

## 开篇点题

> 前置知识: [Linux 核心设计: 操作系统术语及概念](https://hackmd.io/@sysprog/linux-concepts)

YouTube: [Linux kernel – Solving big problems in small steps for more than 20 years (FOSDEM 2020, T. Leemhuis)](https://www.youtube.com/watch?v=WsktXXMOg1k)

以上面的讲座为主轴，回顾 Linux 的发展动态，由此展望 Linux 未来的发展方向。
- SMP (Symmetric multiprocessing)
- scalability
- BKL (Big kernel lock)
- Xen, KVM
- namespace, cgroups, container
- eBPF
- XDP
- PREEMPT_RT
- io_uring

## Linux 2.4

- [ ] [Version 2.4 of the LINUX KERNEL--Why Should a System Administrator Upgrade?](https://www.informit.com/articles/article.aspx?p=20667)

LInux 核心的道路: **只提供机制不提供策略**。例如 khttp (in-kernel httpd) 的弃用。

## SMP 支援

相关故事: Digital Domain and TITANIC (泰坦尼克号)
- [Linux Helps Bring Titanic to Life](https://www.linuxjournal.com/article/2494)
- [Digital Domain: TITANIC](https://www.digitaldomain.com/work/titanic/)
- [Red Hat Sinks Titanic](https://www.redhat.com/en/about/press-releases/press-titanic)
- [Industrial Light and Magic](https://www.linuxjournal.com/article/6011)
- [MaterialX Joins the Academy Software Foundation as a Hosted Project](https://www.aswf.io/blog/materialx-joins-the-academy-software-foundation-as-a-hosted-project/)

制作《泰坦尼克号》的特效时，使用了安装 Linux 操作系统的 Alpha 处理器，而 Alpha 是多核处理器，所以当年将 Linux 安装到 Alpha 上需要支援 SMP，由此延伸出了 BLK (Big kernel lock)。

Linux 2.4 在 SMP 的效率问题也正是 BLK 所引起的:
- BLK 用于锁定整个 Linux kernel，而整个 Linux kernel 只有一个 BLK
- 实作机制: 在执行 `schedule` 时当前持有 BLK 的 process 需要释放 BLK 以让其他 process 可以获得 BLK，当轮到该 process 执行时，可以重新获得 BLK
- 从上面的实作机制可以看出，这样的机制效率是很低的，虽然有多核 (core)，但是当一个 process 获得 BLK 时，只有该 process 所在的 core 可以执行，其他 core 只能等待
- BLK 已于 v.6.39 版本中被彻底去除

[Linux 5.5's Scheduler Sees A Load Balancing Rework For Better Perf But Risks Regressions](https://www.phoronix.com/scan.php?page=news_item&px=Linux-5.5-Scheduler)
