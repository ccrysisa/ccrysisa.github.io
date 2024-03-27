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

- man gcc

```
-D name
    Predefine name as a macro, with definition 1.

-D name=definition
    The contents of definition are tokenized and processed as if they
    appeared during translation phase three in a #define directive.  In
    particular, the definition is truncated by embedded newline
    characters.
```

在 Makefile 中往 CFLAGS 加入 ``-D’;’=’;’` 这类搞怪信息，会导致编译时出现一些不明所以的编译错误 (恶搞专用 :rofl:)

早期的 C++ 是和 C 语言兼容的，那时候的 C++ 相当于 C 语言的一种 preprocessor，将 C++ 代码预编译为对应的 C 语言代码，具体可以参考 [C with Classes](http://janvitek.org/events/NEU/4500/s20/cwc.html)。事实上现在的 C++ 和 C 语言早已分道扬镳，形同陌路，虽然语法上有相似的地方，但请把这两个语言当成不同的语言看待 :rofl:

> 体验一下 C++ 模版 (template) 的威力 :x: 丑陋 :heavy_check_mark: :

{{< image src="https://i.imgur.com/MVZVuDt.png" >}}

> C 语言: 大道至简 :white_check_mark:

## 面向对象编程时，善用前置处理器可大幅简化和开发

- [ ] `#`: [Stringizing](https://gcc.gnu.org/onlinedocs/cpp/Stringizing.html)
- [ ] `##`: [Concatenation](https://gcc.gnu.org/onlinedocs/cpp/Concatenation.html)

**宏的实际作用: generate (产生/生成) 程式码**

> Rust 的过程宏 (procedural macros) 进一步强化了这一目的，可以自定义语法树进行代码生成。

可以 `gcc -E -P` 来观察预处理后的输出
- man gcc
```
-E  Stop after the preprocessing stage; do not run the compiler proper.
    The output is in the form of preprocessed source code, which is
    sent to the standard output.

    Input files that don't require preprocessing are ignored.

-P  Inhibit generation of linemarkers in the output from the
    preprocessor.  This might be useful when running the preprocessor
    on something that is not C code, and will be sent to a program
    which might be confused by the linemarkers.
```

可以依据不同时期的标准来对 C 源程序编译生成目标文件。
- [x] [Feature Test Macros](https://www.gnu.org/software/libc/manual/html_node/Feature-Test-Macros.html)
> The exact set of features available when you compile a source file is controlled by which feature test macros you define.
