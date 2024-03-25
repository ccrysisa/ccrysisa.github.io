---
title: "你所不知道的 C 语言: 前置处理器应用篇"
subtitle:
date: 2024-03-25T22:55:44+08:00
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
  - Preprocessor
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

> 相較於頻繁納入新語法的程式語言 (如 C++ 和 Java)，C 語言顯得很保守，但總是能藉由前置處理器 (preprocessor) 對語法進行擴充，甚至搭配工具鏈 (toolchain) 的若干進階機制，做到大大超出程式語言規範的複雜機制。例如主要以 C 語言開發的 Linux 核心就搭配前置處理器和連結器 (linker) 的特徵，實作出 Linux 核心模組，允許開發者動態掛載/卸載，因巨集包裝得好，多數 Linux 核心核心模組的開發者只要專注在與 Linux 核心互動的部分。

> 本議程回顧 C99/C11 的巨集 (macro) 特徵，探討 C11 新的關鍵字 _Generic 搭配 macro 來達到 C++ template 的作用。探討 C 語言程式的物件導向程式設計、抽象資料型態 (ADT) / 泛型程式設計 (Generics)、程式碼產生器、模仿其他程式語言，以及用前置處理器搭配多種工具程式的技巧，還探討 Linux 核心原始程式碼善用巨集來擴充程式開發的豐富度，例如: BUILD_BUG_ON_ZERO,max, min, 和 container_of 等巨集。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-preprocessor" content="原文地址" external-icon=true >}}

## 不要小看 preprocessor

早期的 C++ 是和 C 语言兼容的，那时候的 C++ 相当于 C 语言的一种 preprocessor，将 C++ 代码预编译为对应的 C 语言代码，具体可以参考 [C with Classes](http://janvitek.org/events/NEU/4500/s20/cwc.html)。事实上现在的 C++ 和 C 语言早已分道扬镳，形同陌路，虽然语法上有相似的地方，但请把这两个语言当成不同的语言看待 :rofl:

> 体验一下 C++ 模版 (template) 的威力 :x: 丑陋 :heavy_check_mark: :

{{< image src="https://i.imgur.com/MVZVuDt.png" >}}

> C 语言: 大道至简 :white_check_mark:
