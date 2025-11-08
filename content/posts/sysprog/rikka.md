---
title: Rikka
subtitle:
date: 2025-06-17T10:24:31+08:00
slug: 48afa80
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
  - Kernel
categories:
  - Projects
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

Rikka 是一个 x86 架构上的简易操作系统。

## 概述

初步目标:

- 系统引导
- 硬件驱动
  - CPU (计算)
  - 显示器 (输出)
  - 键盘 (输入)
  - 硬盘 (存储)
- 任务调度: 进程、线程
- 内存管理
- 文件系统
- 系统调用
- shell

## 开发环境

- 编程语言: C 语言、x86 汇编语言
- 编译器: nasm、
- 编辑器: VS Code
- 操作系统: deepin v23
- 模拟器: bochs、qemu

[bochs](https://github.com/bochs-emu/Bochs) 源码编译安装指南 [^Compiling Bochs] [^The Bochs debugger GUI] [^Bochs 相关] [^Use GDB tools with Bochs]:

```sh
# required by bochs gui debugger
$ sudo apt install libreadline-dev libgtk2.0-dev libgtk-3-dev
# Bochs Source URL: https://github.com/bochs-emu/Bochs
$ tar -zxvf bochs-<version>.tar.gz
$ cd bochs-<version>
$ ./configure --prefix=/<path>/bochs --enable-readline --enable-debugger --enable-debugger-gui --enable-iodebug --enable-x86-debugger --with-x --with-x11
$ make
$ make install
```

## 引导加载

通过 `bochs -q` 命令启动 bochs，选择 `4. Save options to...` 保存 bochs 的配置文件，根据 bximage 的输出信息更改 bochs 配置文件的对应项，其它需要修改的项如下:

```
boot: disk
```

实模式 [^Real Mode] 下的打印功能可以通过 BIOS 中断 [^BIOS Interrupts] 来实现。

x86 的主引导扇区 [^MBR (x86)] 大致结构如下:

- 代码区: 440 - 446 bytes
- 硬盘分区表: 64 bytes = 4 * 16 bytes
- 魔数: 2 bytes

在实模式下和主引导扇区中通过 ATA PIO Mode 进行硬盘读写 [^ATA PIO Mode] [^ATA read/write sectors] [^ATA Command Matrix]，将内核加载器读入内存指定位置处，并跳转至内核加载器的起始地址开始执行，内核加载器负责将操作系统内核加载至内存并跳转至内核执行。主引导程序和内核加载器共同完成加载并执行内核的功能，它们作为一个整体被称为 Bootloader [^Bootloader]。

加载内核加载器或加载操作系统内核到内存都需要将它们放置在内存的可用位置，可以参考 x86 的内存分布 [^Memory Map (x86)]。

## References

[^Compiling Bochs]: https://bochs.sourceforge.io/doc/docbook/user/compiling.html
[^The Bochs debugger GUI]: https://bochs.sourceforge.io/doc/docbook/user/debugger-gui.html
[^Bochs 相关]: https://note.lishouzhong.com/article/wiki/linux/Bochs%20%E7%9B%B8%E5%85%B3.html
[^Use GDB tools with Bochs]: https://people.engr.tamu.edu/bettati/Courses/OSProjects/to-use-gdb-tools.pdf
[^Real Mode]: https://wiki.osdev.org/Real_Mode
[^BIOS Interrupts]: https://grandidierite.github.io/bios-interrupts/
[^MBR (x86)]: https://wiki.osdev.org/MBR_(x86)
[^ATA PIO Mode]: https://wiki.osdev.org/ATA_PIO_Mode
[^ATA read/write sectors]: https://wiki.osdev.org/ATA_read/write_sectors
[^ATA Command Matrix]: https://wiki.osdev.org/ATA_Command_Matrix
[^Bootloader]: http://wiki.osdev.org/Bootloader
[^Memory Map (x86)]: https://wiki.osdev.org/Memory_Map_(x86)
