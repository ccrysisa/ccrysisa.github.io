---
title: "TP5A0: An Experimental 32-Bit Macrokernel"
subtitle:
date: 2024-11-10T18:58:28+08:00
slug: 5441bf2
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
  - draft
categories:
  - draft
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

## 前言

以吾爱破解论坛的系列博文「[从 0 到 -1 写一个操作系统](https://www.52pojie.cn/thread-1748588-1-1.html)」为主干，配合书籍《操作系统真象还原》来从零开始实现一个基于 x86 架构的 32 位操作系统。该系列博文可以视为书籍的提纲，省略了书籍中为趣味性而增加的形象表达和无关的背景故事，使得如何实现操作系统相关的表述更为精简干练，但是由于论坛的图床原因，博文有些图片已失效，需要搭配书籍来查看相应图片；另外博文中所贴代码可能在上传时被分割了，并不符合指定格式，需要搭配博文作者的源代码和书籍所提供的代码片段来验证，确保代码准确无误。

此外，原书和博文对于开发环境配置、模拟器 Bochs 的运用、x86 汇编并未做过多的介绍说明，这些内容可以参考 References 的相关资源进行针对性的学习，这里比较推荐稀风大神的 [KOS](https://gitee.com/thin-wind/KOS) 项目，里面资料非常详尽，有些原书未列入的问题这里面也有相应的解决方案。

### 开发环境

{{< admonition info >}}
- WSL2 Ubuntu 22.04
- Bochs 2.8
- NASM 2.15.05
- GNU Make 4.3
- VS Code
  - ASM Code Lens
  - clangd
  - Clang-Format
  - WSL
{{< /admonition >}}

```bash
OS: Ubuntu 22.04.5 LTS on Windows 10 x86_64
Kernel: 5.15.153.1-microsoft-standard-WSL2
Uptime: 3 mins
Packages: 924 (dpkg), 6 (snap)
Shell: bash 5.1.16
Theme: Adwaita [GTK3]
Icons: Adwaita [GTK3]
Terminal: Windows Terminal
CPU: Intel i7-1065G7 (8) @ 1.497GHz
GPU: b523:00:00.0 Microsoft Corporation Device 008e
Memory: 665MiB / 7840MiB
```

## Bootloader

两种 IO 接口访问方式的区别可以形象理解为：采用统一编址方式的外设需要连接在 **内存地址解码单元** 之后，这样才可以使用统一的地址来访问外设；而采用独立编址方式的外设则直接与 CPU 通过 **端口** 进行连接，CPU 通过特殊的指令访问这些外设的 IO 接口 (即通过端口实现与驱动互联)，而无需通过统一的内存地址进行访问 (但是只能使用 dx 和 ax 这两个寄存器)。

{{< image src="/images/tp5/x86-io.drawio.png" >}}

## Protected Mode

保护模式杂糅了很多历史兼容，在架构上很复杂，不需要研究太深，知道启用保护模式的大致流程即可。

## Memory

BIOS 中断 0x15 子功能0 xe820 会对所有可以寻址的内存区域进行检测，所以 ROM、显示内存这些被映射的内存区域也会被检测到，但它们的大小相对于物理内存来说比较小（这些映射内存量级一般为 KB，而物理内存量级一般为 MB），所以检测内存中容量最大的一般就是主板上的物理内存，除非你的物理内存只分配了 KB 级的大小，这就不一般了。

## References

- 吾爱破解: \[系统底层\] [从 0 到 -1 写一个操作系统](https://www.52pojie.cn/thread-1748588-1-1.html)
- 稀风: [如何从零实现一个操作系统 KOS](https://gitee.com/thin-wind/KOS)
- 看见南山: [用《操作系统真象还原》写一个操作系统](https://space.bilibili.com/8393171/channel/collectiondetail?sid=1394920)
- 豆瓣: [操作系统真象还原](https://book.douban.com/subject/26745156/)
- 豆瓣: [x86 汇编语言：从实模式到保护模式](https://book.douban.com/subject/20492528/)
