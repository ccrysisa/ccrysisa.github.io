---
title: "Linux 核心设计: 透过 BPF 观察操作系统"
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

## The Beginner\'s Guide to eBPF

[BCC](https://github.com/iovisor/bcc/tree/master) 要求的内核编译参数 Ubuntu 24.04 全部满足，根据安装说明进行手动编译安装，仓库的 [doc](https://github.com/iovisor/bcc/blob/master/docs) 目录下有相关教程和手册供参阅。

Kernel 中的 verifier 主要是负责检查 eBPF program 的非法行为，例如 dereference null pointer，从而阻止这些不合法行为。

### The Beginners Guide to eBPF Programming in Go

[bpftrace](https://github.com/bpftrace/bpftrace) is a high-level tracing language for Linux. 主要用于让 bpf scripts 快速便捷地执行。

## eunomia eBPF 开发实践教程

### Install

安装好 ecc 之后，还需要设置环境变量 `EUNOMIA_HOME` 才可以正常工作，以下为源代码中的处理逻辑:

- [src/config/mod.rs](https://github.com/eunomia-bpf/eunomia-bpf/blob/master/compiler/cmd/src/config/mod.rs#L100)

```rs
#[arg(long, default_value_t = format!("{}/btfhub-archive", get_eunomia_data_dir().unwrap().to_string_lossy()), help = "directory to save btfhub archive file")]
```

- [src/helpers](https://github.com/eunomia-bpf/eunomia-bpf/blob/master/compiler/cmd/src/helper.rs#L12)

```rs
pub fn get_eunomia_data_dir() -> Result<PathBuf> {
    if let Ok(e) = var(EUNOMIA_HOME_ENV) {
        return Ok(e.into());
    };
```

建议将环境变量 `EUNOMIA_HOME` 设置为 `$HOME/.eunomia`:

```sh
$ mkdir ~/.eunomia
# in ~/.bashrc
$ export EUNOMIA_HOME=~/.eunomia
```

{{< admonition tip >}}
个人配置是将 `ecc` 和 `ecli` 放置在某一目录，并通过脚本来加载相关环境变量:

```sh
$ tree Packages/eunomia/
Packages/eunomia/
├── build/
│   ├── ecc
│   └── ecli
├── data/
└── env

2 directories, 3 files
```

env 内容如下:

```sh
#!/bin/sh
export PATH=$PATH:$HOME/Packages/eunomia/build
export EUNOMIA_HOME=$HOME/Packages/eunomia/data
```

最后在 `~/.bashrc` 末尾处加入执行上面 `env` 脚本的逻辑:

```sh
. "$HOME/Packages/eunomia/env"
```
{{< /admonition >}}

### tracepoint, kprobe and fentry

跟踪点 (tracepoints) 是内核静态插桩技术，在技术上只是放置在内核源代码中的跟踪函数，实际上就是在源码中插入的一些带有控制条件的探测点，这些探测点允许事后再添加处理函数。

kprobes:

- kprobe: 最基本的探测方式，是实现后两种的基础，它可以在任意的位置放置探测点（就连函数内部的某条指令处也可以）
  - pre_handler: 探测点的调用前的回调方式
  - post_handler: 探测点的调用后的回调方式
  - fault_handler: 内存访问出错时的回调方式
- jprobe: 获取被探测函数的入参值
- kretprobe: 获取被探测函数的返回值

{{< admonition quote >}}

kprobes 的技术原理并不仅仅包含纯软件的实现方案，它也需要硬件架构提供支持。其中涉及硬件架构相关的是 CPU 的异常处理和单步调试技术，前者用于让程序的执行流程陷入到用户注册的回调函数中去，而后者则用于单步执行被探测点指令，因此并不是所有的架构均支持 kprobes。

一个探测点的回调函数可能会修改被探测函数的运行上下文，例如通过修改内核的数据结构或者保存与 `struct pt_regs` 结构体中的触发探测器之前寄存器信息。因此 kprobes 可以被用来安装 bug 修复代码或者注入故障测试代码；

如果一个函数的调用次数和返回次数不相等，则在类似这样的函数上注册 kretprobe 将可能不会达到预期的效果，例如 `do_exit()` 函数会存在问题，而 `do_execve()` 函数和 `do_fork()` 函数不会；

当在进入和退出一个函数时，如果 CPU 运行在非当前任务所有的栈上，那么往该函数上注册 kretprobe 可能会导致不可预料的后果，因此，kprobes 不支持在 X86_64 的结构下为 `__switch_to()` 函数注册 kretprobe，将直接返回 `-EINVAL`。

{{< /admonition >}}

fentry (function entry) 和 fexit (function exit) 用于在 Linux 内核函数的入口和退出处进行跟踪，与 kprobes 相比，fentry 和 fexit 程序有更高的性能和可用性，例如可以直接访问函数的指针参数，就像在普通的 C 代码中一样，而不需要使用各种读取帮助程序 (例如不需要 `BPF_CORE_READ` 宏来读取函数参数的字段)。

### uprobe

uprobe 是一种用户空间探针，它允许在用户空间程序中动态插桩，插桩位置包括：函数入口、特定偏移处，以及函数返回处。定义 uprobe 时，内核会在附加的指令上创建快速断点指令（x86 机器上为 int3 指令），当程序执行到该指令时，内核将触发事件，程序陷入到内核态，并以回调函数的方式调用探针函数，执行完探针函数再返回到用户态继续执行后序的指令。所以 uprobe 是基于文件的，即当一个二进制文件中的一个函数被跟踪时，所有使用到或将会使用到这个文件的进程都会被插桩，从而在全系统范围内跟踪该函数调用。

### types

全局变量在 eBPF 程序中充当一种数据共享机制，它们允许用户态程序与 eBPF 程序之间进行数据交互，这在过滤特定条件或修改 eBPF 程序行为时非常有用 (与 map 作用类似)。

eBPF 提供了两种环形缓冲区，可以用来将信息从 eBPF 程序传输到用户空间。第一个是 perf 环形缓冲区 (perf event array)，它至少从内核 4.15 开始就存在了；第二个是后来引入的 eBPF 环形缓冲区 (eBPF ring buffer)，它在兼容的同时解决了 BPF perf buffer 内存效率和事件重排问题，建议作为 BPF 程序向用户空间发送数据的默认选择。

## BTF

eBPF 程序依赖于 `vmlinux.h` 头文件，但是有些发行版的内核编译时并没有设定相应选项来生成该头文件，会导致在运行 eBPF 程序时遭遇错误: [[BUG]使用ecli运行时提示找不到 vmlinux BTF](https://github.com/eunomia-bpf/bpf-developer-tutorial/issues/118)

此时需要参考文章 [Building the Linux kernel with BTF](https://medium.com/@suruti94/building-the-linux-kernel-with-btf-1a617cfb4a24) 和 [编译 deepin 主线内核](https://bbs.deepin.org/en/post/262451) 来重新编译 Linux 内核，使其支持 BTF 来运行 eBPF 程序。

## References

- Linux 核心設計: [透過 eBPF 觀察作業系統行為](https://hackmd.io/@sysprog/linux-ebpf?type=view)
- Liz Rice: [ebpf-beginners](https://github.com/lizrice/ebpf-beginners)
- Eunomia eBPF: [基于 CO-RE，通过小工具快速上手 eBPF 开发](https://eunomia.dev/zh/tutorials/)
- [eBPF Docs](https://docs.ebpf.io/)
