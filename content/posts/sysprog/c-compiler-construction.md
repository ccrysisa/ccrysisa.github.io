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

## 手把手教你构建 C 语言编译器

{{< link href="https://github.com/lotabout/write-a-C-interpreter" content="原文地址" external-icon=true >}}

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

### 设计

一般而言，编译器的编写分为 3 个步骤：
1. 词法分析器，用于将字符串转化成内部的表示结构。
2. 语法分析器，将词法分析得到的标记流（token）生成一棵语法树。
3. 目标代码的生成，将语法树转化成目标代码。

### 虚拟机

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

### 词法分析器

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

### 递归下降

这一节是以四则运算表达式的语法分析为例，介绍递归下降的相关实作，并不是编译器实作的一部分 :rofl: 但也用到了前一节所提的词法分析，虽然简单很多 (因为四则运算只需考虑标识符为数字的情况)。

语法分析的关键点在于: 它是根据词法分析获得的 token 流进行分析的，其中的 `match` 方法是用于判断当前获得的 token 是否符合语法分析的预期以及基于 token 进行向前看 (对比一下词法分析是基于字符的向前看)。

- [What is Left Recursion and how it is eliminated?](https://www.tutorialspoint.com/what-is-left-recursion-and-how-it-is-eliminated)

### 变量定义

{{< admonition question "current_id[Value] and address" false >}}
```c
current_id[Value] = (int)(text + 1); // the memory address of function
current_id[Value] = (int)data; // assign memory address
```

这两个涉及 `current_id[Value]` 字段的处理暂时没弄明白，可能需要到后面代码生成阶段配合虚拟机设计才能理解。

全局变量 `text` 指向代码段当前已生成指令的位置，所以 `text + 1` 才是下一条指令的位置，`data` 表示数据段当前生成的位置。
{{< /admonition >}}

### 函数定义

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

### 语句

这一节对于 Return 语句处理是会生成 `LEV` 指令，这与上一节函数定义部分生成的 `LEV` 指令并不冲突，因为函数定义生成的 `LEV` 指令对于函数末尾，而本节 Return 语句生成的 `LEV` 语句可以对应函数体内的其他 `return` 返回语句 (毕竟一个函数内可以存在多个返回语句)。

```c
int func(int x) {
    if (x > 0) {
        return x;
    }
    return -x;
}
```

### 表达式

#### 一元运算符

根据词法分析器 `next()` 字符串部分的逻辑，扫描到字符串时对应的 token 是 `"`。

{{< admonition question "pointer type" false >}}
```c
data = (char *)(((int)data + sizeof(int)) & (-sizeof(int)));
```

这段代码的含义是，递增数据段指针 `data` 并将该指针进行 `sizeof(int)` 粒度的 data alignment，至于为什么这么处理，个人暂时猜测是和 pinter type 的类型有关，可能 c4 编译器的 pointer type 都是 `int *`，需要进行相关的 data alignment，否则虚拟机取字符串时会触发 exception。

确实如此，后面自增自减时对于指针的处理是 `*++text = (expr_type > PTR) ? sizeof(int) : sizeof(char);` 显然指针被认为是 `int *` 类型。
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

`void expression(int level)` 的参数 `level` 表示上一个运算符的优先级，这样可以利用程序自身的栈进行表达式优先级入栈出栈进行运算，而不需要额外实现栈来进行模拟，表达式优先级和栈的运算可以参考本节开头的例子。

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

#### 二元运算符

一篇关于表达式优先级爬山的博文:
- [Parsing expressions by precedence climbing](https://eli.thegreenplace.net/2012/08/02/parsing-expressions-by-precedence-climbing/)

## IR (Intermediate representation)

- [ ] [Interpreter, Compiler, JIT from scratch](https://www.slideshare.net/jserv/jit-compiler)
- [ ] [How to JIT - an introduction](https://eli.thegreenplace.net/2013/11/05/how-to-jit-an-introduction)
- [ ] [How to write a very simple JIT compiler](https://github.com/spencertipping/jit-tutorial)
- [x] [How to write a UNIX shell, with a lot of background](https://github.com/spencertipping/shell-tutorial)

{{< admonition >}}
JIT (Just in time) 表示“即时”，形象描述就是“及时雨” :rofl: 原理是将解释执行的“热点“编译成位于一个内存区域的 machine code，从而减轻内存的压力。因为解释执行时会在内存中跳来跳去，而一个区域的 machine code 是连续执行，内存压力没这么大并且可以充分利用 cache 从而提高效能。另一个因素可以参考 [你所不知道的 C 語言: goto 和流程控制篇](https://hackmd.io/@sysprog/c-control-flow)，从 VM 的 `swith-case` 和 `computed goto` 在效能差异的主要因素「分支预测」进行思考。

最后两个链接对于提高系统编程 (System programming) 能力非常有益，Just do it!
{{< /admonition >}}

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