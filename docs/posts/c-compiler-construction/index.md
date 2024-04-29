# 你所不知道的 C 语言: 编译器原理和案例分析


> AMaCC 是由成功大學師生開發的 self-compiling 的 C 語言編譯器，可產生 Arm 架構的執行檔 (ELF 格式，運作在 GNU/Linux)、也支援 just-in-time (JIT) 編譯和執行，原始程式碼僅 1500 行，在這次講座中，我們就來揭開 AMaCC 背後的原理和實作議題。
> 
> 預期會接觸到 IR (Intermediate representation), dynamic linking, relocation, symbol table, parsing tree, language frontend, Arm 指令編碼和 ABI 等等。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-compiler-construction" content="原文地址" external-icon=true >}}

## 如何打造一个具体而微的 C 语言编译器

- [ ] [用十分鐘 向 jserv 學習作業系統設計](https://www.slideshare.net/ccckmit/jserv#22)
- [x] [用1500 行建構可自我編譯的 C 編譯器](https://hackmd.io/coscup18-source-c-compiler)
/ [投影片](https://drive.google.com/file/d/1-0QGf2JSni-CwYigaEORW6JUehS8LS79/view)
- Wikipedia: [Executable and Linkable Format](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)

## 编译器和软件工业强度息息相关

- [ ] [形式化驗證 (Formal Verification)](https://hackmd.io/@sysprog/formal-verification)

## 背景知识

- [ ] 你所不知道的 C 语言: [编译器和最佳化原理篇](https://hackmd.io/s/Hy72937Me)
- [ ] 你所不知道的 C 语言: [函数呼叫篇](https://hackmd.io/s/SJ6hRj-zg)
- [ ] 你所不知道的 C 语言: [动态连链接器和执行时期篇](https://hackmd.io/s/HkK7Uf4Ml)
- [ ] [虚拟机器设计与实作](https://hackmd.io/s/SkBsZoReb)

## C 程序的解析和语意

- [ ] [手把手教你构建 C 语言编译器](https://lotabout.me/2015/write-a-C-interpreter-0/)
- [descent 點評幾本編譯器設計書籍](http://descent-incoming.blogspot.com/2017/01/blog-post.html)
- [desent 教你逐步開發編譯器](http://descent-incoming.blogspot.com/2018/01/44.html)
- [c4](https://github.com/rswier/c4) 是很好的切入點，原作者 Robert Swierczek 還又另一個 [更完整的 C 編譯器實作](https://github.com/rswier/swieros/blob/master/root/bin/c.c)，这个实作支持 preprocessor
- AMaCC 在 Robert Swierczek 的基礎上，額外實作 C 語言的 struct, switch-case, for, C-style comment 支援，並且重寫了 IR 執行程式碼，得以輸出合法 GNU/Linux ELF 執行檔 (支援 [armhf](https://wiki.debian.org/ArmHardFloatPort) ABI) 和 JIT 編譯
- [徒手写一个 RISC-V 编译器！初学者友好的实战课程](https://space.bilibili.com/296494084/channel/collectiondetail?sid=571708)

{{< admonition >}}
上面的第一个链接是关于 c4 的教程，非常值得一看和一做 (*Make your hands dirty!*)，同时它也是 AMaCC 的基础 (AMaCC 在这个基础上进行了重写和扩展)。

最后一个关于虚拟机器的讲座也不错，对于各类虚拟机器都进行了介绍和说明，并搭配了相关实作 [RTMux](https://github.com/rtmux/rtmux) 进行了讲解。
{{< /admonition >}}

{{< image src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEifha5yJnrvK51Mpal4CZX5hkw3F1LAQO5XCUEBhyphenhyphenvDfGYEFH2x5XBIVGps49SszNN5QoP1BBbtiAYdKvVQtLvsfoCNvtPtwc9czkkRc8Iz2Q2uG1n_G_xZZs4XTdKO4lK_LUaGVNkAF3NU/s1600/compiler.jpg" >}}

### 手把手教你构建 C 语言编译器

[原文地址](https://github.com/lotabout/write-a-C-interpreter)

### 延伸阅读

- Wikipedia: [Stack machine](https://en.wikipedia.org/wiki/Stack_machine)
- Wikipedia: [Compiler-compiler](https://en.wikipedia.org/wiki/Compiler-compiler)

## IR (Intermediate representation)

- [ ] [Interpreter, Compiler, JIT from scratch](https://www.slideshare.net/jserv/jit-compiler)
- [ ] [How to JIT - an introduction](https://eli.thegreenplace.net/2013/11/05/how-to-jit-an-introduction)
- [ ] [How to write a very simple JIT compiler](https://github.com/spencertipping/jit-tutorial)
- [ ] [How to write a UNIX shell, with a lot of background](https://github.com/spencertipping/shell-tutorial)

{{< admonition >}}
JIT (Just in time) 表示“即时”，形象描述就是“及时雨” :rofl: 原理是将解释执行的“热点“编译成位于一个内存区域的 machine code，从而减轻内存的压力 (解释执行时会在内存中跳来跳去，而一个区域的 machine code 是连续执行，内存压力没这么大并且可以充分利用 cache 从而提高效能)。

最后两个链接对于提高系统编程 (System programming) 能力非常有益，Just do it!
{{< /admonition >}}

### 延伸阅读

- Linux manual page: [bsearch](https://man7.org/linux/man-pages/man3/bsearch.3.html)

## 程序语言设计和编译器考量

- [ ] YouTube: [Brian Kernighan on successful language design](https://www.youtube.com/watch?v=Sg4U4r_AgJU)

---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-compiler-construction/  

