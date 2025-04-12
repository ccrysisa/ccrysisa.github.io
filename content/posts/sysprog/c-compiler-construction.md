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
  - 你所不知道的 C 语言
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

- [x] [用十分鐘 向 jserv 學習作業系統設計](https://www.slideshare.net/ccckmit/jserv#22)
- [x] [用1500 行建構可自我編譯的 C 編譯器](https://hackmd.io/coscup18-source-c-compiler)
/ [投影片](https://drive.google.com/file/d/1-0QGf2JSni-CwYigaEORW6JUehS8LS79/view)

[AMaCC](https://github.com/jserv/amacc) 是由成功大學師生開發的 self-compiling 的 C 語言編譯器，可產生 Arm 架構的執行檔 (ELF 格式，運作在 GNU/Linux)、也支援 just-in-time (JIT) 編譯和執行，原始程式碼僅 1500 行，在這次講座中，我們就來揭開 AMaCC 背後的原理和實作議題。

預期會接觸到 IR (Intermediate representation), dynamic linking, relocation, symbol table, parsing tree, language frontend, Arm 指令編碼和 ABI 等等。

- Wikipedia: [Executable and Linkable Format](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)
- GitHub: [mini-riscv-os](https://github.com/cccriscv/mini-riscv-os)

这个专案是对 Jserv 的 700 行系列的致敬，启发自 [mini-arm-os](https://github.com/jserv/mini-arm-os) 专案:
> Build a minimal multi-tasking OS kernel for RISC-V from scratch. Mini-riscv-os was inspired by jserv's mini-arm-os project. However, ccckmit rewrite the project for RISC-V, and run on Win10 instead of Linux.

## 编译器和软件工业强度息息相关

- [ ] [形式化驗證 (Formal Verification)](https://hackmd.io/@sysprog/formal-verification)

## 背景知识

- [ ] 你所不知道的 C 语言: [编译器和最佳化原理篇](https://hackmd.io/s/Hy72937Me)
- [ ] 你所不知道的 C 语言: [函数呼叫篇](https://hackmd.io/s/SJ6hRj-zg)
- [ ] 你所不知道的 C 语言: [动态连链接器和执行时期篇](https://hackmd.io/s/HkK7Uf4Ml)
- [ ] [虚拟机器设计与实作](https://hackmd.io/s/SkBsZoReb)

## C 程序的解析和语意

- [x] [手把手教你构建 C 语言编译器](https://lotabout.me/2015/write-a-C-interpreter-0/)
- [北大编译实践在线文档](https://pku-minic.github.io/online-doc/#/)
- [Crafting Interpreters](https://craftinginterpreters.com/)
- [descent 點評幾本編譯器設計書籍](http://descent-incoming.blogspot.com/2017/01/blog-post.html)
- [desent 教你逐步開發編譯器](http://descent-incoming.blogspot.com/2018/01/44.html)
- [c4](https://github.com/rswier/c4) 是很好的切入點，原作者 Robert Swierczek 還又另一個 [更完整的 C 編譯器實作](https://github.com/rswier/swieros/blob/master/root/bin/c.c)，这个实作支持 preprocessor
- AMaCC 在 Robert Swierczek 的基礎上，額外實作 C 語言的 struct, switch-case, for, C-style comment 支援，並且重寫了 IR 執行程式碼，得以輸出合法 GNU/Linux ELF 執行檔 (支援 [armhf](https://wiki.debian.org/ArmHardFloatPort) ABI) 和 JIT 編譯
- [徒手写一个 RISC-V 编译器！初学者友好的实战课程](https://space.bilibili.com/296494084/channel/collectiondetail?sid=571708)
- [Write your Own Virtual Machine](https://www.jmeiners.com/lc3-vm/) / [中文翻译](https://arthurchiao.art/blog/write-your-own-virtual-machine-zh/)

{{< admonition >}}
上面的第一个链接是关于 c4 的教程，非常值得一看和一做 (*Make your hands dirty!*)，同时它也是 AMaCC 的基础 (AMaCC 在这个基础上进行了重写和扩展)。

最后一个关于虚拟机器的讲座也不错，对于各类虚拟机器都进行了介绍和说明，并搭配了相关实作 [RTMux](https://github.com/rtmux/rtmux) 进行了讲解。
{{< /admonition >}}

{{< image src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEifha5yJnrvK51Mpal4CZX5hkw3F1LAQO5XCUEBhyphenhyphenvDfGYEFH2x5XBIVGps49SszNN5QoP1BBbtiAYdKvVQtLvsfoCNvtPtwc9czkkRc8Iz2Q2uG1n_G_xZZs4XTdKO4lK_LUaGVNkAF3NU/s1600/compiler.jpg" >}}

## IR (Intermediate representation)

- Wikipedia: []()

> An intermediate representation (IR) is the data structure or code used internally by a compiler or virtual machine to represent source code. 

> An intermediate language is the language of an abstract machine designed to aid in the analysis of computer programs.

> A popular format for intermediate languages is three-address code.

> Though not explicitly designed as an intermediate language, C's nature as an abstraction of assembly and its ubiquity as the de facto system language in Unix-like and other operating systems has made it a popular intermediate language

所以一般的 IR 长得和汇编语言比较像，但是比汇编高阶，因为 IR 是建立在这样的虚拟机器 (abstract machine designed to aid in the analysis of computer programs) 之上的。

- [x] [Interpreter, Compiler, JIT from scratch](https://www.slideshare.net/jserv/jit-compiler)
- [ ] [How to JIT - an introduction](https://eli.thegreenplace.net/2013/11/05/how-to-jit-an-introduction)
- [ ] [How to write a very simple JIT compiler](https://github.com/spencertipping/jit-tutorial)
- [x] [How to write a UNIX shell, with a lot of background](https://github.com/spencertipping/shell-tutorial)

{{< admonition >}}
JIT (Just in time) 表示“即时”，形象描述就是“及时雨” :rofl: 原理是将解释执行的“热点“编译成位于一个内存区域的 machine code，从而减轻内存的压力。因为解释执行时会在内存中跳来跳去，而一个区域的 machine code 是连续执行，内存压力没这么大并且可以充分利用 cache 从而提高效能。另一个因素可以参考 [你所不知道的 C 語言: goto 和流程控制篇](https://hackmd.io/@sysprog/c-control-flow)，从 VM 的 `swith-case` 和 `computed goto` 在效能差异的主要因素「分支预测」进行思考。

最后两个链接对于提高系统编程 (System programming) 能力非常有益，Just do it!
{{< /admonition >}}

### Interpreter, Compiler, JIT from scratch

{{< link href="https://www.slideshare.net/jserv/jit-compiler" content="原文地址" external-icon=true >}}

{{< image src="/images/c/jit-compiler-151016000038-lva1-app6892-05.png">}}
{{< image src="/images/c/jit-compiler-151016000038-lva1-app6892-26.png">}}
{{< image src="/images/c/jit-compiler-151016000038-lva1-app6892-27.png">}}
{{< image src="/images/c/jit-compiler-151016000038-lva1-app6892-28.png">}}
{{< image src="/images/c/jit-compiler-151016000038-lva1-app6892-29.png">}}
{{< image src="/images/c/jit-compiler-151016000038-lva1-app6892-30.png">}}
{{< image src="/images/c/jit-compiler-151016000038-lva1-app6892-31.png">}}

### How to write a UNIX shell

{{< image src="/images/c/shell.drawio.svg" >}}

系统编程 (System Programming) 的入门项目，阅读过程需要查询搭配 man 手册，以熟悉库函数和系统调用的原型和作用。

Linux manual page: 
[fflush](https://man7.org/linux/man-pages/man3/fflush.3.html)
/ [elf](https://man7.org/linux/man-pages/man5/elf.5.html)
/ [exec](https://man7.org/linux/man-pages/man3/exec.3.html)
/ [perror](https://man7.org/linux/man-pages/man3/perror.3.html)
/ [getline](https://man7.org/linux/man-pages/man3/getline.3.html)
/ [strchr](https://www.man7.org/linux/man-pages/man3/strchr.3.html)
/ [waitpid](https://man7.org/linux/man-pages/man3/waitpid.3p.html)
/ [fprintf](https://man7.org/linux/man-pages/man3/fprintf.3p.html)
/ [pipe](https://man7.org/linux/man-pages/man2/pipe.2.html)
/ [dup](https://man7.org/linux/man-pages/man2/dup.2.html)
/ [close](https://man7.org/linux/man-pages/man2/close.2.html)

### 延伸阅读

- Linux manual page: [bsearch](https://man7.org/linux/man-pages/man3/bsearch.3.html)

## 程序语言设计和编译器考量

- [ ] YouTube: [Brian Kernighan on successful language design](https://www.youtube.com/watch?v=Sg4U4r_AgJU)


## 实作案例: 手把手教你构建 C 语言编译器

lotabout 所写的 {{< link href="https://github.com/lotabout/write-a-C-interpreter" content="系列博文" external-icon=true >}}

编译原理课程教导的是如何完成一个「编译器的编译器」，即 [Compiler-compiler](https://en.wikipedia.org/wiki/Compiler-compiler)，这个难度比较大，因为需要考虑通用性，但是实作一个简单的编译器并没有这么难。

- Wikipedia: [Compiler-compiler](https://en.wikipedia.org/wiki/Compiler-compiler)

{{< admonition >}}
这篇教程里面会有一些比较奇怪古板的写法，例如:
```c
int i; i = 0; // instead of `int i = 0;`
a = a + 1;    // instead of `a += 1;`
```
这都是为了实现这个编译器的自举 (self-host)，所以在语法上没有太大的灵活性 (因为这个编译器不支持这么灵活的语法 :rofl:)
{{< /admonition >}}

#### 设计

一般而言，编译器的编写分为 3 个步骤：
1. 词法分析器，用于将字符串转化成内部的表示结构。
2. 语法分析器，将词法分析得到的标记流（token）生成一棵语法树。
3. 目标代码的生成，将语法树转化成目标代码。

{{< admonition question "argc & argv" false >}}
```c
argc--;
argv++;
```

`main` 函数这部分的处理是将该进程 `argc` 和 `argv` 设定为解释执行的源程序对应的值，以让虚拟机正确地解释执行源程序 (需要看完「虚拟机」和「表达式」部分才能理解这部分处理的意义)。
{{< /admonition >}}

#### 虚拟机

在该项目的虚拟机设计中，函数调用时 callee 的参数位于 caller 的栈帧 (frame) 内，并且函数调用需要使用到 4 条指令:

1. `CALL` 指令将 callee 的返回地址压入栈，然后跳转到 callee 的入口处
2. `ENT` 指令保存 ebp 寄存器的值并为 callee 的栈帧设置 esp 和 ebp 寄存器，在栈中给 callee 的局部变量分配空间
3. `ADJ` 指令在 callee 逻辑执行完毕后，释放之前分配给局部变量的栈空间
4. `LEV` 指令将 ebp 和 esp 寄存器恢复为对应 caller 栈帧，并跳转到之前保存的 callee 的返回地址处

除此之外，在 callee 执行期间，可能需要通过 `LEA` 指令来访问函数参数和局部变量。

```
sub_function(arg1, arg2, arg3);

|    ....       | high address
+---------------+
| arg: 1        |    new_bp + 4
+---------------+
| arg: 2        |    new_bp + 3
+---------------+
| arg: 3        |    new_bp + 2
+---------------+
|return address |    new_bp + 1
+---------------+
| old BP        | <- new BP
+---------------+
| local var 1   |    new_bp - 1
+---------------+
| local var 2   |    new_bp - 2
+---------------+
|    ....       |  low address
```

- Wikipedia: [Stack machine](https://en.wikipedia.org/wiki/Stack_machine)
- Wikipedia: [x86 calling conventions](https://en.wikipedia.org/wiki/X86_calling_conventions)

{{< admonition question "PRTF" false >}}
```c
else if (op == PRTF) { 
  tmp = sp + pc[1]; 
  ax = printf((char *)tmp[-1], tmp[-2], tmp[-3], tmp[-4], tmp[-5], tmp[-6]); 
}
```

这里 [c4](https://github.com/rswier/c4) 对于 `PRTF` 指令的处理暂时没看明白...

完成「表达式」一节的阅读后，可以得知函数的指令生成顺序是: 参数入栈 -> 函数调用 -> 释放参数空间，在 `expression()` 中有相应的逻辑:

```c
// pass in arguments
tmp = 0; // number of arguments
while (token != ')') {
    expression(Assign);
    *++text = PUSH;
    tmp ++;
    ...
}
...
// function call
if (id[Class] == Sys) { // system functions
    *++text = id[Value];
}
else if (id[Class] == Fun) { // function call
    *++text = CALL;
    *++text = id[Value];
}
...
// clean the stack for arguments
if (tmp > 0) {
    *++text = ADJ;
    *++text = tmp;
}
```

所以 `PRTF` 指令处理中的 `pc[1]` 表示的恰好是释放参数空间的 `ADJ` 指定参数，都是表示参数的个数。可以根据这个参数数量来在栈中定位函数参数，当然这里为了简化，将 `PRTF` 对应的 `printf` 参数固定为了 6 个 (这可能会有一些漏洞)。

除此之外，还要注意，根据「词法分析器」章节的处理，字符串的值 (token_val) 是它的地址:

```c
if (token == '"') {
    token_val = (int)last_pos;
}
```

所以虚拟机在执行 `PRTF` 指令时将第一个参数解释为 `char *` 类型。
{{< /admonition >}}

{{< admonition question "gcc -m32 error" false >}}
gcc 通过 `-m32` 参数编译本节代码时可能会遇到以下报错:

```bash
fatal error: bits/wordsize.h: No such file or directory
```

这是因为当前安装的 gcc 只有 64 位的库而没有 32 位的库，通过以下命令安装 32 位库解决问题:

```bash
$ sudo apt install gcc-multilib
```

Stack Overflow: 
- ["fatal error: bits/libc-header-start.h: No such file or directory" while compiling HTK](https://stackoverflow.com/questions/54082459/fatal-error-bits-libc-header-start-h-no-such-file-or-directory-while-compili)
{{< /admonition >}}

#### 词法分析器

我们并不会一次性地将所有源码全部转换成标记流，原因有二：
1. 字符串转换成标记流有时是有状态的，即与代码的上下文是有关系的。
2. 保存所有的标记流没有意义且浪费空间。

在处理数字时使用到了一些「数值系统篇」时提到的技巧，例如利用 ASCII Table 的特性。假设 `token` 存储当前字符，如果是 `0-9` 这类数字字符，使用 `token & 15` 可以获得该数字字符对应的数值；如果是 `a-f` 或 `A-F` 这类字符，`token & 15` 会取得相对于 9 的偏移值，例如 `A & 15` 和 `a & 15` 返回的都是 1。

上面这一技巧依赖于这一事实：字符 `0-9` 对应的十六进制为 `0x30 - 0x39`，字符 `A-F` 对应的十六进制为 `0x41 - 0x46`，字符 `a-f` 对应的十六进制为 `0x61 - 0x66`。

对于「关键字与内置函数」的处理:
- **关键字**: 首先使用词法分析器将其识别为 identifier，然后将 symbol table 中的 token 类型改为对应的关键字
- **内置函数**: 类似的先进行词法分析识别为 identifier，然后在 symbol table 中修改其 Class, Type, Value 字段的值

{{< admonition question "current_id[Value] and system functions" false >}}
暂时没搞懂为什么要将内置函数在 symbol table 中的 `Value` 字段修改为对应的指令 (例如 `EXIT`)

阅读完「表达式」一节后已理解，这样内置函数可以直接通过 symbol table 的 `Value` 字段来生成对应的指令，而不像普通函数一样搭配地址生成相关的跳转指令。

```c
if (id[Class] == Sys) {
    // system functions
    *++text = id[Value];
}
```
{{< /admonition >}}

{{< admonition danger >}}
对于关键字和内置函数的处理部分:
```c
src = "char else enum if int return sizeof while "
      "open read close printf malloc memset memcmp exit void main";
```
一定要注意第一行最后的 `while` 后面有一个 **空格**，这是保证字符串拼接后可以被词法分析器识别为两个 token。如果不加空格，字符串会把这一部分拼接成 `... whileopen ...`，这样就不符合我们的预期了，进而导致程序出错。
{{< /admonition >}}

#### 递归下降

这一节是以四则运算表达式的语法分析为例，介绍递归下降的相关实作，并不是编译器实作的一部分 :rofl: 但也用到了前一节所提的词法分析，虽然简单很多 (因为四则运算只需考虑标识符为数字的情况)。

语法分析的关键点在于: 它是根据词法分析获得的 token 流进行分析的，其中的 `match` 方法是用于判断当前获得的 token 是否符合语法分析的预期以及基于 token 进行向前看 (对比一下词法分析是基于字符的向前看)。

- [What is Left Recursion and how it is eliminated?](https://www.tutorialspoint.com/what-is-left-recursion-and-how-it-is-eliminated)

#### 变量定义

{{< admonition question "current_id[Value] and address" false >}}
```c
current_id[Value] = (int)(text + 1); // the memory address of function
current_id[Value] = (int)data; // assign memory address
```

这两个涉及 `current_id[Value]` 字段的处理暂时没弄明白，可能需要到后面代码生成阶段配合虚拟机设计才能理解。

全局变量 `text` 指向代码段当前已生成指令的位置，所以 `text + 1` 才是下一条指令的位置，`data` 表示数据段当前生成的位置。
{{< /admonition >}}

#### 函数定义

代码段全局变量 `text` 表示的是当前生成的指令，所以下一条指令 (即将要生成的指令) 的地址为 `text + 1`。

{{< admonition question "function_declaration" false >}}
`function_declaration` 中的这一部分处理，虽然逻辑是在 symbol table 中将局部变量恢复成全局变量的属性，但感觉这样会导致多出一些未定义的全局变量 (由局部变量转换时多出来):

```c
current_id[Class] = current_id[BClass];
current_id[Type]  = current_id[BType];
current_id[Value] = current_id[BValue];
```

「表达式」一节中对于没有设置 `Class` 字段的标识符会判定为未定义变量:

```c
if (id[Class] == Loc) {
    ...
} else if (id[Class] == Glo) {
    ...
} else {
    printf("%d: undefined variable\n", line);
    exit(-1);
}
```
{{< /admonition >}}

#### 语句

这一节对于 Return 语句处理是会生成 `LEV` 指令，这与上一节函数定义部分生成的 `LEV` 指令并不冲突，因为函数定义生成的 `LEV` 指令对于函数末尾，而本节 Return 语句生成的 `LEV` 语句可以对应函数体内的其他 `return` 返回语句 (毕竟一个函数内可以存在多个返回语句)。

```c
int func(int x) {
    if (x > 0) {
        return x;
    }
    return -x;
}
```

#### 表达式

`void expression(int level)` 的参数 `level` 表示上一个运算符的优先级，这样可以利用程序自身的栈进行表达式优先级入栈出栈进行运算，而不需要额外实现栈来进行模拟，表达式优先级和栈的运算可以参考本节开头的例子。

> 我们需要不断地向右扫描，直到遇到优先级 **小于** 当前优先级的运算符。

> 当我们调用 `expression(level)` 进行解析的时候，我们其实通过了参数 `level` 指定了当前的优先级。

当碰到优先级小于 `Assign` 的标识符时，会结束 `expression()` 的执行并返回。对于未摘录在枚举中的符号，例如 `:`，其 ASCII 值都小于 `Assign` 的值，所以碰到时也会从 `expression()` 返回。其它符号同理，自行查阅 ASCII 表对比即可 (这也是为什么枚举时设定 `Num` 等于 128)。

一元运算符和二元运算符的处理不是泾渭分明的，例如对于 `a = 10` 这个表达式，它的处理流程是这样的:

```c
expression()  // 一元运算符: Id
              // 二元运算符: =
expression()  // 一元运算符: Num
```

一个涉及两次函数调用，第一次调用处理了标识符 `a` 和运算符 `=`，第二次调用处理了数字 `10`，可以自行走访一下流程进行体会 (learn anything by tracing)，即一次 `expression()` 最多可以处理一个一元运算符和一个二元运算符。

除此之外，`expression()` 执行完成之后，生成的指令流会将结果放置在寄存器 `ax` 中，可以以这个为前提进行后续的指令生成。

##### 一元运算符

根据词法分析器 `next()` 字符串部分的逻辑，扫描到字符串时对应的 token 是 `"`。

{{< admonition question "pointer type" false >}}
```c
data = (char *)(((int)data + sizeof(int)) & (-sizeof(int)));
```

这段代码的含义是，递增数据段指针 `data` 并将该指针进行 `sizeof(int)` 粒度的 data alignment，至于为什么这么处理，个人暂时猜测是和 pinter type 的类型有关，可能 c4 编译器的 pointer type 都是 `int *`，需要进行相关的 data alignment，否则虚拟机取字符串时会触发 exception。

确实如此，后面自增自减时对于指针的处理是 `*++text = (expr_type > PTR) ? sizeof(int) : sizeof(char);` ~~显然指针被认为是 int * 类型~~。

上面说的有误，`(expr_type > PTR)` 表示的是除 `char *` 之外的指针类型 (因为 `CHAR` 值为 0)。
{{< /admonition >}}

解析 `sizeof` 时对任意的 pinter type 都认为它的 size 等价于 `sizeof(int)`，这不奇怪，在 32 位的机器上，pointer 和 int 都是 32 位的 (感谢 CSAPP :rofl:)。

处理局部变量时的代码生成，需要和之前函数定义的参数解析部分搭配阅读:

```c
// codegen
*++text = index_of_bp - id[Value];
// function parameter
current_id[Value]  = params++;
index_of_bp = params+1;
```

无论是局部变量还是全局变量，symbol table 中的 `Value` 字段存放的是与该变量相关的地址信息 (偏移量或绝对地址)。除此之外，还需要理解局部变量和 `index_of_bp` 之间的偏移关系 (这样才能明白如何保持了参数顺序入栈的关系并进行正确存取)。

指针取值部分如果考虑 pointer of pointer 情形会比较绕，多思考并把握关键: 指针取值运算符 `*` 是从右向左结合的，即 `***p = (*(*(*p)))`

处理正负号时原文是这样描述“我们没有取负的操作，用 `0 - x` 来实现 `-x`”，但代码逻辑实质上是用「`-1 * x` 来实现 `-x`」，也比较合理，放置处理负号 / 减号时陷入无限递归。

```c
*++text = IMM;
*++text = -1;
*++text = PUSH;
expression(Inc);
*++text = MUL;
```

「自增自减」例如 `++p` 需要需要使用变量 `p` 的地址两次：一次用于读取 `p` 的数值，一次用于将自增后的数值存储回 `p` 处，并且自增自减实质上是通过 `p +/- 1` 来实现的 。

##### 二元运算符

处理 `||` 和 `&&` 时，对于右边的 operand 的处理分别是 `expression(Lan)` 和 `expression(Or)`，限制的优先级刚好比当前的运算符高一级，使得遇到同级运算符时会返回，从而让外部的 `while` 循环来处理，这样可以保证生成正确的指令序列。

一篇关于表达式优先级爬山的博文:
- [Parsing expressions by precedence climbing](https://eli.thegreenplace.net/2012/08/02/parsing-expressions-by-precedence-climbing/)

##### 初始化栈

```c
// setup stack
sp = (int *)((int)stack + poolsize);
*--sp = EXIT; // call exit if main returns
*--sp = PUSH; tmp = sp;
*--sp = argc;
*--sp = (int)argv;
*--sp = (int)tmp;
```

这段代码原文没有过多描述，但其实挺难懂的，其本质是根据函数调用的 ABI 来配置栈空间以对应函数调用 `main(argc, argv)`。所以第 5~6 行的作用现在明白了，就是配置 `main` 函数的参数顺序入栈，但这里需要注意 `argv` 参数对应的字符串并不在我们虚拟机设定的 `data` 段，而是在我们这个程序“自己的空间”内 (程序“自己的空间”是指属于 c4 这个程序的空间，但不属于虚拟机设定的空间)，除此之外的字符串大都同时存在于虚拟机的 `data` 段和 c4 这个程序“自己的空间”内 (词法分析器处理字符串时进行了拷贝到虚拟机的 `data` 段)。

第 4 行和第 7 行设定 `main` 函数的返回地址，这也符合栈的布局: 参数 -> 返回地址，使得 `main` 函数对应的指令可以通过 `LEV` 指令进行函数返回。现在就到好玩的地方了，注意到 `tmp` 在第 4 行设定的地址是位于栈中的，所以当 `main` 函数返回时它会跳转到我们在第 4 行设定的 `PUSH` 指令处 (即将 `pc` 的值设定为该处)。这是没问题的，因为我们的虚拟机也可以执行位于栈中的指令 (虽然这有很大的风险，例如 ROP 攻击，但是这只是个小 demo 管它呢 :rofl:)。

当 `main` 函数返回后，根据上面的叙述，它会先执行第 4 行的 `PUSH` 指令，这个指令的作用是将 `main` 函数的返回值压入栈中 (因为 Return 语句生成的指令序列会将返回值放置在 `ax` 寄存器)。不用担心当且指令被覆盖的问题，因为这段代码配置的栈，并没有包括清除参数空间的逻辑，所以在 `main` 函数返回后，`sp` 指向的是第 6 行配置的 `argv` 参数处。

执行完第 4 行的 `PUSH` 指令后，会接着执行第 3 行的 `EXIT` 指令，因为 (`pc` 寄存器在虚拟机运行时是递增的)，此时虚拟机将 `main` 函数的返回值作为本进程的返回值进行返回，并结束进程。

## 实作案例: Virtual Machine in C

Tsoding 上传的 [Virtual Machine in C](https://www.youtube.com/playlist?list=PLpM-Dvs8t0VY73ytTCQqgvgCWttV3m8LM) 系列视频:

{{< timeline placement=top >}}
events:
  - timestamp: Day 1
    content: 实现一个基本的 [Stack-based Virtual Machine](https://en.wikipedia.org/wiki/Stack_machine) 支持汇编和解释执行程序
  - timestamp: Day 2
    content: 实现反汇编器、支持符号跳转以及 [NaN-boxing](https://en.wikipedia.org/wiki/NaN#Canonical_NaN) 以便后续支持动态类型
  - timestamp: Day 3
    content: 使用 `union` 支持浮点数存放、支持解析汇编的浮点数以及使用汇编计算 [Euler\'s Number](https://en.wikipedia.org/wiki/E_(mathematical_constant)) 的近似值
  - timestamp: Day 4
    content: TODO
{{< /timeline >}}

### Day 1

> Using LLVM for developing a programming language is like using react.js for developing a website!

C 语言没有编译时期计算常数函数值的机制，但是可以使用宏来实现。

通过 gcc 的参数，可以实现类似 Rust 的强大编译时期检查: [GCC switch on enum, retain missing warning but use default](https://stackoverflow.com/questions/5402745/gcc-switch-on-enum-retain-missing-warning-but-use-default)

原视频在大概 2:35 时左右实现了使用 VM 来计算斐波那契数列，原理是在栈中不断累积斐波那契数，并通过复制指令来进行叠加，这导致了计算第 $N$ 个斐波那契数需要栈空间至少为 $N+1$。

C 语言 I/O 相关操作需要熟读标准库手册 (man 手册)，当然也可以配合其他资料来理解。

Vim 可以通过 xxd 来将二进制文件转换为十六进制查看，但是需要系统内置有 xxd 工具 (如果没有可以通过包管理进行安装):

```sh
$ vim -b xxx.bin
# in vim type follow command
:%!xxd
```

C 语言的字符串打印表达能力也挺强大的: [What is the meaning of "%-*.*s" in a printf format string?](https://stackoverflow.com/questions/23776824/what-is-the-meaning-of-s-in-a-printf-format-string)

让 NOP 指令的枚举值为 0，可以让初始化为 0 的 VM 加载的程序全为 NOP 指令而不会导致其他问题出现。让 TRAP 的 OK 类型为 0 则是与 Linux 兼容 (返回 0 表示正常或成功)。

连续多次使用三目运算符时必须注意判断条件是否发生来变化，事实上任意条件判断都应该注意这一点，C 语言专家应该将这个意识内化为自己的本能。

Makefile 并不推荐让 `make run` 接受参数:

Stack Overflow:

- [Passing arguments to "make run"](https://stackoverflow.com/questions/2214575/passing-arguments-to-make-run)
- [No GCC warning for function with declaration different from definition](https://stackoverflow.com/questions/49624771/no-gcc-warning-for-function-with-declaration-different-from-definition)

clangd 要跳转到函数定义处需要 compile_commands.json 文件，CMake 可以直接生成这个文件，Makefile 的话可以通过 bear 这个工具来生成，操作方法如下:

```sh
# install bear
$ sudo apt install bear
# in you project directory
$ bear -- make
```

目前 clangd 对于头文件经常会报 false positive，参考 clangd 的这篇 [issue](https://github.com/clangd/clangd/issues/1913) 进行解决。加一个如下内容的 clangd 文件即可解决:

```
Diagnostics:
  MissingIncludes: None
  UnusedIncludes: None
```

### Day 2

Wikipedia: [Cohesion (computer science)](https://en.wikipedia.org/wiki/Cohesion_(computer_science))

实现符号跳转，必须要使用 Two pass，因为符号的声明也有可能在跳转指令之后。同时支持符号跳转和地址跳转，可以通过判断跳转指令的操作数是否为数字来区分。

Rust 的借用检查 (Borrow Check) 机制不会允许形如以下的未定义行为 (Undefined Behavior, a.k.a. UB) 出现:

```c
Inst lim_translate_line(const Lim *lim, String_View line)
{
    ...
}

size_t lim_translate_source(Lim *lim, String_View source)
{
    ...
    lim->program[lim->program_size++] = lim_translate_line(lim, line);
    ...
}
```

因为不能同时存在可变引用和不可变引用。

因为浮点数的 NaN 的形式如下:

```
s111 1111 1xxx xxxx xxxx xxxx xxxx xxxx
```

即 fraction 部分不重要 / 无关，所以可以将一些信息例如类型存储在这一部分，这就是所谓的 **NaN Boxing** 技术。动态语言经常使用这个技术，例如 Python、JavaScript，将类型信息存储在 NaN 的 fraction 部分以此来表示动态类型。例如在 64 位浮点数 `double` 中，fraction 部分共有 52 位，使用其中的 4 位来表示类型，剩下的 48 位可以存储一个指针，这样就实现了动态类型。使用 48 位表示指针利用了 x86_64 下虚拟地址空间的一个技巧:

Wikipedia: [x86-64](https://en.wikipedia.org/wiki/X86-64)

> The AMD64 architecture defines a 64-bit virtual address format, of which the low-order 48 bits are used in current implementations.

JavaScript V8 也使用到了这个技巧，非常的实用。

C 语言的 `inline` 关键字的作用是由编译器 implementation define 的: [https://stackoverflow.com/questions/31108159/what-is-the-use-of-the-inline-keyword-in-c](https://stackoverflow.com/questions/31108159/what-is-the-use-of-the-inline-keyword-in-c)

### Day 3

不需要 NaN boxing 这么麻烦的做法，在 C 语言直接使用 `union` 即可实现同一字段不同解释来 XD

但如果要了解 NaN boxing 的细节，推荐看一下 [NaN boxing or how to make the world dynamic](https://piotrduperas.com/posts/nan-boxing/) 这篇文章

编译时期的 assert 检查: [Static assert in C](https://stackoverflow.com/questions/3385515/static-assert-in-c). C11 standard adds the `_Static_assert` keyword and `static_assert` in `assert.h`

```c
# define static_assert _Static_assert
```

因为 `strtol` 这类函数不会解析与整数格式相关之外的字符，例如浮点 `.` 和次方标识 `E`，所以可以根据是否对字符串的字符完全解析完成来判断是否应该对字符串进行浮点数解析。

```c
char *endptr = NULL;
long x = strtol(cstr, &endptr);
if (endptr - cstr != strlen(cstr)) {
    double y = strtod(cstr, &endptr);
}
```

单纯的 stack-based 架构会导致只能使用存放在栈顶的那个变量，如果增加寄存器或类似作用的 `swap` 指令，则可以使用更多的变量。使用 `swap` 指令虽然可以使用更多变量，但是计算的主要变量还是存放在栈顶的那个变量。

Wikipedia: [e (mathematical constant)](https://en.wikipedia.org/wiki/E_(mathematical_constant))

Stack Overflow:

- [What is a flexible array member in a struct?](https://stackoverflow.com/questions/68769314/what-is-a-flexible-array-member-in-a-struct)
- [How to produce an approximation for "e" of user-defined decimal places](https://stackoverflow.com/questions/52725111/how-to-produce-an-approximation-for-e-of-user-defined-decimal-places)
- [Approximate pi using series](https://stackoverflow.com/questions/59903586/approximate-pi-using-series)

Linux manual page:

- [strchr](https://man7.org/linux/man-pages/man3/strchr.3.html)
- [strtod](https://man7.org/linux/man-pages/man3/strtod.3.html)
- [strtol](https://man7.org/linux/man-pages/man3/strtol.3.html)

### Day 4

## 实作案例: Creating a Compiler

Pixeled 上传的 [Creating a Compiler](https://www.youtube.com/playlist?list=PLUDlas_Zy_qC7c5tCgTMYq2idyyT241qs) 系列视频。

{{< image src="/images/c/compiler.drawio.png" >}}

### References

- [Why would I use NASM over GNU Assembler (GAS)?](https://stackoverflow.com/questions/65436403/why-would-i-use-nasm-over-gnu-assembler-gas)
- [Linux System Call Table](https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md)
