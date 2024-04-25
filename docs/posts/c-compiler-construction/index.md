# 你所不知道的 C 语言: 编译器原理和案例分析


> AMaCC 是由成功大學師生開發的 self-compiling 的 C 語言編譯器，可產生 Arm 架構的執行檔 (ELF 格式，運作在 GNU/Linux)、也支援 just-in-time (JIT) 編譯和執行，原始程式碼僅 1500 行，在這次講座中，我們就來揭開 AMaCC 背後的原理和實作議題。
> 
> 預期會接觸到 IR (Intermediate representation), dynamic linking, relocation, symbol table, parsing tree, language frontend, Arm 指令編碼和 ABI 等等。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-compiler-construction" content="原文地址" external-icon=true >}}

## 如何打造一个具体而微的 C 语言编译器

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

- [手把手教你构建 C 语言编译器](https://lotabout.me/2015/write-a-C-interpreter-0/)
- [descent 點評幾本編譯器設計書籍](http://descent-incoming.blogspot.com/2017/01/blog-post.html)
- [desent 教你逐步開發編譯器](http://descent-incoming.blogspot.com/2018/01/44.html)
- [c4](https://github.com/rswier/c4) 是很好的切入點，原作者 Robert Swierczek 還又另一個 [更完整的 C 編譯器實作](https://github.com/rswier/swieros/blob/master/root/bin/c.c)
- AMaCC 在 Robert Swierczek 的基礎上，額外實作 C 語言的 struct, switch-case, for, C-style comment 支援，並且重寫了 IR 執行程式碼，得以輸出合法 GNU/Linux ELF 執行檔 (支援 [armhf](https://wiki.debian.org/ArmHardFloatPort) ABI) 和 JIT 編譯

{{< admonition >}}
上面的第一个链接是关于 c4 的教程，非常值得一看和一做 (动手实践是 CSer 必备能力 :rofl:)
{{< /admonition >}}

## IR (Intermediate representation)

- [ ] [Interpreter, Compiler, JIT from scratch](https://www.slideshare.net/jserv/jit-compiler)
- [ ] [How to JIT - an introduction](https://eli.thegreenplace.net/2013/11/05/how-to-jit-an-introduction)
- [ ] [How to write a very simple JIT compiler](https://github.com/spencertipping/jit-tutorial)
- [ ] [How to write a UNIX shell, with a lot of background](https://github.com/spencertipping/shell-tutorial)

{{< admonition >}}
最后两个链接对于提高系统编程 (System programming) 能力非常有益，Just do it!
{{< /admonition >}}

## 程序语言设计和编译器考量

- [ ] YouTube: [Brian Kernighan on successful language design](https://www.youtube.com/watch?v=Sg4U4r_AgJU)

---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-compiler-construction/  

