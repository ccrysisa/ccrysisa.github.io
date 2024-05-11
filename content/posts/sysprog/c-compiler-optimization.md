---
title: "你所不知道的 C 语言: 编译器和最佳化原理篇"
subtitle:
date: 2024-04-24T21:09:59+08:00
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
  - C
  - Compiler
  - Optimization
categories:
  - C
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

> 編譯器最佳化篇將以 gcc / llvm 為探討對象，簡述編譯器如何運作，以及如何實現最佳化，佐以探究 C 編譯器原理和案例分析，相信可以釐清許多人對 C 編譯器的誤解，從而開發出更可靠、更高效的程式。

<!--more-->

## From Source to Binary: How A Compiler Works: GNU Toolchain

###### [Page 8]

编译器分为软件编译器和硬件编译器两大类型，硬件编译器可能比较陌生，但如果你有修过 [nand2tetris](https://www.nand2tetris.org/) 应该不难理解。

###### [Page 9]

对于软件编译器，并不是所有的编译器都会集成有图示的 compile, assemble, link 这三种功能，例如 [AMaCC](https://github.com/jserv/amacc) 只是将 C 语言源程序编译成 ARM 汇编而已。这并不难理解，因为根据编译器的定义，这是毋庸置疑的编译器:

- Wikipedia: [Compiler](https://en.wikipedia.org/wiki/Compiler)
> A compiler is ä computer program (or set of programs) that transforms source code written in a programming language (the source language) into another computer language (the target language, often having a binary form known as object code)

之所以将编译器分为上面所提的 3 大部分，主要是为了开发时验证功能时的便利，分成模块对于调试除错比较友好。
