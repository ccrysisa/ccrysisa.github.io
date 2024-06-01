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

- {{< link href="https://hackmd.io/@sysprog/c-compiler-optimization" content="原文地址" external-icon=true >}}

## From Source to Binary: How A Compiler Works: GNU Toolchain

- [ ] [投影片](http://www.slideshare.net/jserv/how-a-compiler-works-gnu-toolchain)
/ {{< link href="/archives/compiler-concepts-150301184123-conversion-gate02.pdf" content="PDF" >}}

{{< admonition >}}
这里的投影片比影片中老师讲解时使用的投影片少了一部分，而原文使用的页码是老师讲解时使用的投影片的页码，需要甄别。因为我只有当前版本的投影片，所以会以当前投影片的页码作为记录，同时会将原文标注的页码转换成当前投影片的页码。
{{< /admonition >}}

辅助材料:
- [ ] [Intro To Compiler Development](https://slide.logan.tw/compiler-intro/#/)
- [ ] [The C++ Build Process Explained](https://github.com/green7ea/blog)

{{< image src="/images/c/From-Source%20to%20-Binary-3.png" >}}

这个流程十分重要，不仅可以理解程序的执行流程，也可以作为理解语言设计的视角。

###### [Page 5]

原文这部分详细解释了 C Runtime (crt) 对于 `main` 函数的参数 `argc` 和 `argv`，以及返回值 `return 0` 的关系和作用。

###### [Page 8]

编译器分为软件编译器和硬件编译器两大类型，硬件编译器可能比较陌生，但如果你有修过 [nand2tetris](https://www.nand2tetris.org/) 应该不难理解。

###### [Page 9]

对于软件编译器，并不是所有的编译器都会集成有图示的 compile, assemble, link 这三种功能，例如 [AMaCC](https://github.com/jserv/amacc) 只是将 C 语言源程序编译成 ARM 汇编而已。这并不难理解，因为根据编译器的定义，这是毋庸置疑的编译器:

- Wikipedia: [Compiler](https://en.wikipedia.org/wiki/Compiler)
> A compiler is ä computer program (or set of programs) that transforms source code written in a programming language (the source language) into another computer language (the target language, often having a binary form known as object code)

之所以将编译器分为上面所提的 3 大部分，主要是为了开发时验证功能时的便利，分成模块对于调试除错比较友好。

###### [Page 16]

原文讲解了 [self-hosting](https://en.wikipedia.org/wiki/Self-hosting) 的定义极其重要性，并以微软的 C# 为例子进行说明:
- [ ] [How Microsoft rewrote its C# compiler in C# and made it open source](https://medium.com/microsoft-open-source-stories/how-microsoft-rewrote-its-c-compiler-in-c-and-made-it-open-source-4ebed5646f98)

###### [Page 18]

程序语言的本质是编译器，所以在程序语言的起始阶段，是先有编译器再有语言，但是之后就可以通过 self-hosting 实现自举了，即程序语言编译自己的编译器。

```
                 +----+            +---+
Source:   X      | C- |     C-     | C |     C 
Language: C-     | C- |     C      | C |     C+
Compiler: 1  --> | 2  | --> 3  --> | 4 | --> 5 
                 +----+            +---+
```

自举 (self-hosting) 是指用某一个语言 X 写的编译器，可以编译 X 语言写的程序
> In computer programming, self-hosting is the use of a program as part of the toolchain or operating system that produces new versions of that same program—for example, a compiler that can compile its own source code. 

###### [Page 32~33]

SSA (Static Single Assignment): 每次赋值都会对应到一个新的变量，使用记号 $\Phi$ 表示值的定义由程序流程来决定

可以使用 GCC 来输出包含 Basic Block 的 CFG，使用范例:
```bash
# <out> is the name of output file
$ gcc -c -fdump-tree-cfg=<out> test.c
```

###### [Page 39]

最佳化 CFG 部分，将 bb2 和 bb3 对调了，这样的好处是可以少一条指令，即原先 bb3 的 `goto bb2` 被消除掉了 (事实上是将该指令提到了 bb1 处，这样就只需执行一次该指令，与消除掉该指令差不多了，因为原先在 bb3 的话，这条指令每次都要执行)，这对于 for 循环是一个常见的最佳化技巧。

###### [Page 41~43]
Constant Propagation 部分可以看到，`a0`, `b0` 和 `c0` 都只出现了一次，后面没有再被使用过，此时就可以就进行 Constant Propagation，将常量值取代原先的 `a0`, `b0,` 和 `c0`，然后进行 Constant Folding 将常量值表达式计算转换成单一的常量值，接着因为 Constant Folding 产生了新的单一常量值，可以接着进行 Constant Propagation，以此反复，直到无法进行 Constant Propagation。

第 43 页的 `result2 = t1/61126` 疑似笔误，应该为 `result1 = t1/61126`

###### [Page 45]

Value Range Propagation 根据 **变量的形态 (例如数值范围)** 进行推断，从而产生新的常量值，这就是“变成 0 的魔法“的原理。接下来，正如你所想的，有了常量值，那就是进行 Constant Propagation :rofl:

使用 SSA 的一个原因就是可以让计算机按部就班的进行 Value Range Propagation 这类黑魔法

编译器最佳化总体流程大概是:

{{< image src="/images/c/ssa.drawio.png" >}}
