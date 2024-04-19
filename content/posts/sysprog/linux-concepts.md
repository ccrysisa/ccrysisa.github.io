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
  - Linux
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

## Linux 核心发展

虚拟化 (Virtualization) 技术分为 CPU 层级的虚拟化技术，例如 [KVM](https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine) 和 [RVM](https://github.com/equation314/RVM-Tutorial)，也有操作系统层级的虚拟化技术，例如 [Docker](https://en.wikipedia.org/wiki/Docker_(software))。

- [x] [Plan 9 from Bell Labs](https://en.wikipedia.org/wiki/Plan_9_from_Bell_Labs) [Wikipedia]
- [x] [LXC](https://en.wikipedia.org/wiki/LXC) [Wikipedia]

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

- [x] [Pipeline (Unix)](https://en.wikipedia.org/wiki/Pipeline_(Unix)) [Wikipedia]
- [x] [Process identifier](https://en.wikipedia.org/wiki/Process_identifier) [Wikipedia]
- [x] [watchdog](https://linux.die.net/man/8/watchdog) [Linux man page]
- [x] [init](https://en.wikipedia.org/wiki/Init) [Wikipedia]
- [x] [systemd](https://en.wikipedia.org/wiki/Systemd) [Wikipedia]
- [x] [fork](https://man7.org/linux/man-pages/man2/fork.2.html) [Linux man page]
- [x] [clone](https://man7.org/linux/man-pages/man2/clone.2.html) [Linux man page]
- [x] [Project Genie](https://en.wikipedia.org/wiki/Project_Genie) [Wikipedia]
- [x] [posix_spawn](https://man7.org/linux/man-pages/man3/posix_spawn.3.html) [Linux man page]
- [x] [Native POSIX Thread Library](https://en.wikipedia.org/wiki/Native_POSIX_Thread_Library) [Wikipedia]
- [x] [极客漫画: 不要使用 SIGKILL 的原因](https://linux.cn/article-8771-1.html)
- [x] [wait](https://man7.org/linux/man-pages/man2/wait.2.html) [Linux man page]
- [x] [signal](https://man7.org/linux/man-pages/man7/signal.7.html) [Linux man page]
- [x] [TUX web server](https://en.wikipedia.org/wiki/TUX_web_server) [Wikipedia]
 -[x] [cron](https://en.wikipedia.org/wiki/Cron)

{{< admonition tip >}}
[Multics](https://en.wikipedia.org/wiki/Multics) 采用了当时背景下的几乎所有的先进技术，可以参考该系统获取系统领域的灵感。
{{< /admonition >}}

虚拟内存管理与现代银行的运行逻辑类似，通过 `malloc` 分配的有效虚拟地址并不能保证真正可用，类似于支票得去银行兑现时才知道银行真正的现金储备。但是根据统计学公式，虚拟地址和银行现金可以保证在大部分情况下，都可以满足需求，当然突发的大规模虚拟内存使用、现金兑现时就无法保证了。这部分的原理推导需要学习概率论、统计学等数理课程。

{{< admonition type=info open=false >}}
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

投影片: [Linux Kernel: Introduction](https://linux-kernel-labs.github.io/refs/heads/master/lectures/intro-slides.html) :white_check_mark:

- 对投影片的 [重点描述](https://linux-kernel-labs.github.io/refs/heads/master/lectures/intro.html)

一些概念理解:

- [ ] [1963 Timesharing: A Solution to Computer Bottlenecks](https://www.youtube.com/watch?v=Q07PhW5sCEk) [YouTube]
- [x] [Supervisory program](https://en.wikipedia.org/wiki/Supervisory_program) [Wikipedia]

### Monolithic kernel vs Microkernel

- [淺談 Microkernel 設計和真實世界中的應用](https://hackmd.io/@sysprog/microkernel-design)
- [Hybrid kernel](https://en.wikipedia.org/wiki/Hybrid_kernel) [wikipedia]

> "As to the whole 'hybrid kernel' thing - it's just marketing. It's 'oh, those microkernels had good PR, how can we try to get good PR for our working kernel? Oh, I know, let's use a cool name and try to imply that it has all the PR advantages that that other system has'."   
> —— Linus Torvalds

### 虚拟化

MicroVM 和 Unikernel 都是使用 CPU 层级的虚拟化技术，在 Host OS 上面构建的 GuestOS:

- MicroVM 会减少硬件驱动方面的初始化，从而加快启动和服务速度 (在云服务器方面很常见，服务器端并不需要进行硬件驱动)。

- Unikernel 则更激进，将 programs 和 kernel 一起进行动态编译，并且限制只能运行一个 process (例如只运行一个数据库进程，这样云服务器很常见)，这样就减少了一些系统调用的呼叫，例如 fork (因为只能运行一个 process)，提升了安全性 (因为 fork 系统调用可能会造成一些漏洞)。Unikernel 又叫 [Library OS](https://en.wikipedia.org/wiki/Unikernel)，可以理解为分时多人多工操作系统的另一个对立面，拥有极高的运行速度 (因为只有一个 process)。

Container Sandbox 使用的是 OS 层级的虚拟化技术，即它是将一组进程隔离起来构建为容器，这样可能会导致这一组进程就耗尽了系统的资源，其他进程无法使用系统的资源。同时因为是进程级的隔离，所以安全性不及 CPU 层级的 MicroVM 和 Unikernel。

{{< admonition info >}}
相关演讲、录影:
- YouTube: [Inside the Mac OS X Kernel](https://youtu.be/-7GMHB3Plc8)
- YouTube: [What Are MicroVMs? And Why Should I Care?](https://youtu.be/4d0NIfuFLXc)
- YouTube: [From the Ground Up: How We Built the Nanos Unikernel](https://youtu.be/0v21hGvCDPY)

相关论文阅读:
{{< /admonition >}}

### Scalability

Wikipedia: [scalability](https://en.wikipedia.org/wiki/Scalability) 
> A system whose performance improves after adding hardware, proportionally to the capacity added, is said to be a scalable system.

- lock-free
- sequence lock
- RCU
- algorithm complexity

### eBPF

透过 eBPF 可将 Monolithic kernel 的 Linux 取得 microkernel 的特性

- [The Beginners Guide to eBPF Programming](https://github.com/lizrice/ebpf-beginners), Liza RIce (live programming + source code)
- [A thorough introduction to eBPF](https://lwn.net/Articles/740157/) (four articles in lwn.net), Matt FLeming, December 2017

## 细节切入点

CPU 和 OS 的基本概念科普网站: [Putting the “You” in CPU](https://cpu.land/)
> 相当于科普版 CSAPP

{{< admonition info >}}
UNSW COMP9242: [Advanced Operating Systems](https://www.cse.unsw.edu.au/~cs9242/23/lectures.shtml) (2023/T3)
- YouTube: [2022: UNSW's COMP9242 Advanced Operating Systems](https://www.youtube.com/playlist?list=PLtoQeavghzr3nlXyJEXaTLU9Ca0DXWMnt)
- 这门课可以作为辅助材料，讲得深入浅出，可以作为进阶材料阅读。

Georgia Tech **Advanced Operating Systems**:
- [Part 1](https://www.youtube.com/playlist?list=PLAwxTw4SYaPkKfusBLVfklgfdcB3BNpwX)
- [Part 2](https://www.youtube.com/playlist?list=PLAwxTw4SYaPm4vV1XbFV93ZuT2saSq1hO)
- [Part 3](https://www.youtube.com/playlist?list=PLAwxTw4SYaPk5-YaXFkWY4UXdv6pVdiYg)
- [Part 4](https://www.youtube.com/playlist?list=PLAwxTw4SYaPmfaiuzJcK3tNoeKlvRR990)

Reddit: [Best book to learn in-depth knowledge about the Linux Kernel?](https://www.reddit.com/r/linux/comments/z26h5h/best_book_to_learn_indepth_knowledge_about_the/)
- [Linux From Scratch](https://www.linuxfromscratch.org/)
- Amazon: [Linux Kernel Development](https://www.amazon.com/Linux-Kernel-Development-Robert-Love/dp/0672329468)
- YouTube: [Steven Rostedt - Learning the Linux Kernel with tracing](https://www.youtube.com/watch?v=JRyrhsx-L5Y)
{{< /admonition >}}

## 系统软件开发思维

### Maslow's pyramid of code review

{{< image src="https://imgur-backup.hackmd.io/DBMmMNi.png" caption="Maslow's pyramid of code review" >}}

### Benchmark / Profiling

{{< image src="https://hackpad-attachments.s3.amazonaws.com/embedded2015.hackpad.com_xDmCCv0k00K_p.299401_1446124062219_truth.jpg" caption="Benchmark / Profiling" >}}
