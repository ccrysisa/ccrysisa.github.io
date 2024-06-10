---
title: "Rust 实作 eBPF"
subtitle:
date: 2024-06-10T23:38:10+08:00
# draft: true
# author:
#   name:
#   link:
#   email:
  # avatar:
description:
keywords:
license:
comment: false
weight: 0
tags:
  - Rust
  - Sysprog
  - eBPF
categories:
  - Rust
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

> Programming the Linux Kernel for Enhanced Observability, Networking, and Security

<!--more-->

## 实作案例: 通过 bpftrace 抓取 HTTPS 流量

[讲解视频](https://www.bilibili.com/video/BV1794y1L7as/) / [讲义](http://timd.cn/bpftrace-demo/)

- [Learning eBPF](https://cilium.isovalent.com/hubfs/Learning-eBPF%20-%20Full%20book.pdf) Chapter 10: eBPF Programming

> The bpftrace command-line tool converts programs written in this high-level lan‐
guage into eBPF kernel code and provides some output formatting for the results
within the terminal.

bpftrace 可以将我们编写的高级程序语言转换成对应的 BPF 字节码，用于后续给内核中的 BPF 虚拟机执行

```bash
bpftrace -e 'kprobe:do_execve { @[comm] = count(); }'
Attaching 1 probe...
^C

@[node]: 6
@[sh]: 6
@[cpuUsage.sh]: 18
```

其中 `{ @[comm] = count(); }` 表示同=统计每个命令触发 `do_execve` 这个探针点的次数，`comm` 表示 command，而 `count()` 顾名思义就是统计次数，所以通过 `Ctrl-C` 中断该 BPF 脚本执行后，输出的是各个命令触发 `do_execve` 这个探针点的次数。

> Scripts for bpftrace can coordinate multiple eBPF programs attached to different
events.

## Improving the eBPF Developer Experience with Rust

- Dave Tucker/Alessandro Decina: [直播录影](https://www.youtube.com/watch?v=yCf6AYpA8u0) / [投影片](https://lpc.events/event/11/contributions/936/attachments/812/1530/Improving%20the%20eBPF%20Developer%20experience%20with%20Rust%20(1).pdf)
