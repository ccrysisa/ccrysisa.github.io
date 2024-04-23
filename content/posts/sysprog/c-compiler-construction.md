---
title: "你所不知道的 C 语言: 编译器原理和案例分析"
subtitle:
date: 2024-04-23T15:17:38+08:00
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

> AMaCC 是由成功大學師生開發的 self-compiling 的 C 語言編譯器，可產生 Arm 架構的執行檔 (ELF 格式，運作在 GNU/Linux)、也支援 just-in-time (JIT) 編譯和執行，原始程式碼僅 1500 行，在這次講座中，我們就來揭開 AMaCC 背後的原理和實作議題。
> 
> 預期會接觸到 IR (Intermediate representation), dynamic linking, relocation, symbol table, parsing tree, language frontend, Arm 指令編碼和 ABI 等等。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-compiler-construction" content="原文地址" external-icon=true >}}

## 如何打造一个具体而微的 C 语言编译器

- [ ] [用1500 行建構可自我編譯的 C 編譯器](https://hackmd.io/coscup18-source-c-compiler)
  - [投影片](https://drive.google.com/file/d/1-0QGf2JSni-CwYigaEORW6JUehS8LS79/view)
- Wikipedia: [Executable and Linkable Format](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)

## 编译器和软件工业强度息息相关

- [ ] [形式化驗證 (Formal Verification)](https://hackmd.io/@sysprog/formal-verification)

## 背景知识

- [ ] 你所不知道的 C 语言: [编译器和最佳化原理篇](https://hackmd.io/s/Hy72937Me)
- [ ] 你所不知道的 C 语言: [函数呼叫篇](https://hackmd.io/s/SJ6hRj-zg)
- [ ] 你所不知道的 C 语言: [动态连链接器和执行时期篇](https://hackmd.io/s/HkK7Uf4Ml)
- [ ] [虚拟机器设计与实作](https://hackmd.io/s/SkBsZoReb)

## C 程序的解析和语意

- [手把手教你构建 C 语言编译器](https://lotabout.me/2015/write-a-C-interpreter-0/)