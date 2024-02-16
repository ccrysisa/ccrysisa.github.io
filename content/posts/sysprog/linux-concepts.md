---
title: "Linux 核心设计: 操作系统术语及概念"
subtitle:
date: 2024-02-15T12:51:49+08:00
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

> 面對原始程式碼超越 3 千萬行規模的 Linux 核心 (2023 年)，最令人感到挫折的，絕非缺乏程式註解，而是就算見到滿滿的註解，自己卻有如文盲，全然無從理解起。為什麼呢？往往是因為對作業系統的認知太侷限。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/linux-concepts" content="原文地址" external-icon=true >}}

原文的直播录影地址尚未更新，但是 Jserv 已于 2024/2/5 对该文章进行了重新讲解，[这里](https://www.youtube.com/watch?v=iWvkoJawxQA) 看到最新的直播录影。

## Linux 核心发展

虚拟化 (Virtualization) 技术分为 CPU 层级的虚拟化技术，例如 [KVM](https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine) 和 [RVM](https://github.com/equation314/RVM-Tutorial)，也有操作系统层级的虚拟化技术，例如 [Docker](https://en.wikipedia.org/wiki/Docker_(software))。

- [ ] [Plan 9 from Bell Labs](https://en.wikipedia.org/wiki/Plan_9_from_Bell_Labs) [Wikipedia]
- [ ] [LXC](https://en.wikipedia.org/wiki/LXC) [Wikipedia]

{{< admonition info >}}
- [從 Revolution OS 看作業系統生態變化](https://hackmd.io/@sysprog/revolution-os-note)
- [Linux 核心設計: 透過 eBPF 觀察作業系統行為](https://hackmd.io/@sysprog/linux-ebpf)
{{< /admonition >}}

## 看漫画学 Linux

{{< link href="https://hackmd.io/@sysprog/linux-comic" content="原文地址" external-icon=true >}}

{{< image src="https://turnoff.us/image/en/inside-the-linux-kernel.png" caption="inside the linux kernel" >}}

整理上图，可以得到 **自底向上** 的 Linux 系统结构:

- 地下层: 
    - 文件系统 (File System)
- 中央大厅层: 
    - 进程表 (process table)
    - 内存管理 (memory management)
    - 信息安全 (security)
    - 看门狗 (watchdog)
    - httpd
    - cron
    - 管道 (pipe)
    - FTP
    - SSH
    - Wine
    - GNOME
- 最上层
    - tty / terminal

wiki:

- [ ] [Pipeline (Unix)](https://en.wikipedia.org/wiki/Pipeline_(Unix)) [Wikipedia]
- [x] [Process identifier](https://en.wikipedia.org/wiki/Process_identifier) [Wikipedia]
- [x] [watchdog](https://linux.die.net/man/8/watchdog) [Linux man page]
- [x] [init](https://en.wikipedia.org/wiki/Init) [Wikipedia]
- [x] [systemd](https://en.wikipedia.org/wiki/Systemd) [Wikipedia]
- [x] [fork](https://man7.org/linux/man-pages/man2/fork.2.html) [Linux man page]
- [x] [clone](https://man7.org/linux/man-pages/man2/clone.2.html) [Linux man page]
- [x] [Project Genie](https://en.wikipedia.org/wiki/Project_Genie) [Wikipedia]
- [x] [posix_spawn](https://man7.org/linux/man-pages/man3/posix_spawn.3.html) [Linux man page]
- [ ] [Native POSIX Thread Library](https://en.wikipedia.org/wiki/Native_POSIX_Thread_Library) [Wikipedia]
- [x] [极客漫画: 不要使用 SIGKILL 的原因](https://linux.cn/article-8771-1.html)
- [ ] [wait](https://man7.org/linux/man-pages/man2/wait.2.html) [Linux man page]
- [ ] [signal](https://man7.org/linux/man-pages/man7/signal.7.html) [Linux man page]
- [x] [TUX web server](https://en.wikipedia.org/wiki/TUX_web_server) [Wikipedia]
 -[x] [cron](https://en.wikipedia.org/wiki/Cron)

[Multics](https://en.wikipedia.org/wiki/Multics) 采用了当时背景下的几乎所有的先进技术，可以参考该系统获取系统领域的灵感。

虚拟内存管理与现代银行的运行逻辑类似，通过 `malloc` 分配的有效虚拟地址并不能保证真正可用，类似于支票得去银行兑现时才知道银行真正的现金储备。但是根据统计学公式，虚拟地址和银行现金可以保证在大部分情况下，都可以满足需求，当然突发的大规模虚拟内存使用、现金兑现时就无法保证了。这部分的原理推导需要学习概率论、统计学等数理课程。

{{< admonition info >}}
Linux 核心设计:

- [Linux 核心設計: 檔案系統概念及實作手法](https://hackmd.io/@sysprog/linux-file-system)
- [Linux 核心設計: 不僅是個執行單元的 Process](https://hackmd.io/@sysprog/linux-process)
- [Linux 核心設計: 不只挑選任務的排程器](https://hackmd.io/@sysprog/linux-scheduler)
- [UNIX 作業系統 fork/exec 系統呼叫的前世今生](https://hackmd.io/@sysprog/unix-fork-exec)
- [Linux 核心設計: 記憶體管理](https://hackmd.io/@sysprog/linux-memory)
- [Linux 核心設計: 發展動態回顧](https://hackmd.io/@sysprog/linux-dev-review)
- [Linux 核心設計: 針對事件驅動的 I/O 模型演化](https://hackmd.io/@sysprog/linux-io-model/)
- [Linux 核心設計: Scalability 議題](https://hackmd.io/@sysprog/linux-scalability)
- [Effective System Call Aggregation (ESCA)](https://eecheng87.github.io/ESCA/)
- [你所不知道的 C 語言: Stream I/O, EOF 和例外處理](https://hackmd.io/@sysprog/c-stream-io)

Unix-like 工具使用技巧:

- [Mastering UNIX pipes, Part 1](https://www.moritz.systems/blog/mastering-unix-pipes-part-1/)
- [Mastering UNIX pipes, Part 2](https://www.moritz.systems/blog/mastering-unix-pipes-part-2/)
{{< /admonition >}}

## 高阶观点

投影片: [Linux Kernel: Introduction](https://linux-kernel-labs.github.io/refs/heads/master/lectures/intro-slides.html)

- 对投影片的 [重点描述](https://linux-kernel-labs.github.io/refs/heads/master/lectures/intro.html)

一些概念理解:

- [ ] [1963 Timesharing: A Solution to Computer Bottlenecks](https://www.youtube.com/watch?v=Q07PhW5sCEk) [YouTube]
- [x] [Supervisory program](https://en.wikipedia.org/wiki/Supervisory_program) [Wikipedia]

MicroVM 和 Unikernel 都是使用 CPU 层级的虚拟化技术，在 Host OS 上面构建的 GuestOS:

- MicroVM 会减少硬件驱动方面的初始化，从而加快启动和服务速度 (在云服务器方面很常见，服务器端并不需要进行硬件驱动)。

- Unikernel 则更激进，将 programs 和 kernel 一起进行动态编译，并且限制只能运行一个 process (例如只运行一个数据库进程，这样云服务器很常见)，这样就减少了一些系统调用的呼叫，例如 fork (因为只能运行一个 process)，提升了安全性 (因为 fork 系统调用可能会造成一些漏洞)。Unikernel 又叫 [Library OS](https://en.wikipedia.org/wiki/Unikernel)，可以理解为分时多人多工操作系统的另一个对立面，拥有极高的运行速度 (因为只有一个 process)。
