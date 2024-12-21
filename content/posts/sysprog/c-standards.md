---
title: "你所不知道的 C 语言: 开发工具和规格标准"
subtitle:
date: 2024-02-28T11:11:47+08:00
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

> Linux 核心作为世界上最成功的开放原始码计划，也是 C 语言在工程领域的瑰宝，里头充斥则各种“艺术”，往往会吓到初次接触的人们，但总是能够使用 C 语言标准和开发工具提供的扩展 (主要是来自 gcc 的 GNU extensions) 来解释。
> > **工欲善其事，必先利其器**

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-standards" content="原文地址" external-icon=true >}}

---

{{< center-quote >}}
**If I had eight hours to chop down a tree, I’d spend six hours sharpening my axe.**

—— Abraham Lincoln   
{{< /center-quote >}}

语言规格: C89/C90 -> C99 -> C11 -> C17/C18 -> C2x

## C vs C++

> C is quirky, flawed, and an enormous success. Although accidents of history surely helped, it evidently satisfied a need for a system implementation language efficient enough to displace assembly language, yet sufficiently abstract and fluent to describe algorithms and interactions in a wide variety of environments. —— Dennis M. Ritchie

{{< image src="https://imgur-backup.hackmd.io/1gWHzfd.png" >}}

- David Brailsford: [Why C is so Influential - Computerphile](https://www.youtube.com/watch?v=ci1PJexnfNE)

- [x] Linus Torvalds: [c++ in linux kernel](https://www.realworldtech.com/forum/?threadid=104196&curpostid=104208)
> And I really do dislike C++. It's a really bad language, in
> my opinion. It tries to solve all the wrong problems, and
> does not tackle the right ones. The things C++ "solves"
> are trivial things, almost purely syntactic extensions to
> C rather than fixing some true deep problem.

- Bjarne Stroustrup: [Learning Standard C++ as a New Language](http://www.stroustrup.com/new_learning.pdf) [PDF]

- C++ 标准更新飞快: C++11, C++14, C++17, ...

{{< image src="https://i.imgur.com/ITVm6gI.png" >}}

> 从 C99, C++98 开始，C 语言和 C++ 分道扬镳

> **in C, everything is a representation (unsigned char [sizeof(TYPE)]).** —— Rich Rogers

- [x] [第一個 C 語言編譯器是怎樣編寫的？](https://kknews.cc/zh-tw/tech/bx2r3j.html)
> 介绍了自举 (sel-hosting/compiling) 以及 C0, C1, C2, C3, ... 等的演化过程

## C 语言规格书

### main

阅读 C 语言规格书可以让你洞察本质，不在没意义的事情上浪费时间，例如在某乎大肆讨论的 `void main()` 和 `int main()` [问题](https://www.zhihu.com/question/60047465) :rofl:

- C99/C11 5.1.2.2.1 Program startup

The function called at program startup is named `main`. The implementation declares no
prototype for this function. It shall be defined with a return type of `int` and with no
parameters:

```c
int main(void) { /* ... */ }
```

or with two parameters (referred to here as `argc` and `argv`, though any names may be
used, as they are local to the function in which they are declared):

```c
int main(int argc, char *argv[]) { /* ... */ }
```

or equivalent; or in some other implementation-defined manner.

> Thus, int can be replaced by a typedef name defined as `int`, or the type of `argv` can be written as `char ** argv`, and so on.

### incomplete type

- C99 6.2.5 Types
> *incomplete types* (types that describe objects but lack information needed to determine their sizes).

例如指针类型暗示的就是 incomplete type，通过 `struct data *` 这个指针类型无法得知 `struct data` 这个型态所需要占用的空间大小。

### 规格不仅要看最新的，过往的也要熟悉

因为很多 (嵌入式) 设备上运行的 Linux 可能是很旧的版本，那时 Linux 使用的是更旧的 C 语言规格。例如空中巴士 330 客机的娱乐系统里执行的是十几年前的 Red Hat Linux，总有人要为这些“古董”负责 :rofl:

## GDB

使用 GDB 这类调试工具可以大幅度提升我们编写代码、除错的能力 :dog:

- video: [Linux basic anti-debug](https://www.youtube.com/watch?v=UTVp4jpJoyc)
- video: [C Programming, Disassembly, Debugging, Linux, GDB](https://www.youtube.com/watch?v=twxEVeDceGw)
- [rr](http://rr-project.org/) (Record and Replay Framework)
  - video: [Quick demo](https://www.youtube.com/watch?v=hYsLBcTX00I)
  - video: [Record and replay debugging with "rr"](https://www.youtube.com/watch?v=ytNlefY8PIE)

## C23

上一个 C 语言标准是 C17，正式名称为 ISO/IEC 9899:2018，是 2017 年准备，2018年正式发布的标准规范。C23 则是目前正在开发的规格，其预计新增特性如下:

- `typeof`: 由 GNU extension 转正，用于实作 `container_of` 宏
- `call_once`: 保证在 concurrent 环境中，某段程式码只会执行 1 次
- `char8_t`: Unicode friendly `u8"💣"[0]`
- `unreachable()`: 由 GNU extension 转正，提示允许编译器对某段程式码进行更激进的最佳化
- `= {}`: 取代 `memset` 函数调用
- ISO/IEC 60559:2020: 最新的 IEEE 754 浮点数运算标准
- `_Static_assert`: 扩充 C11 允许单一参数
- 吸收 C++11 风格的 attribute 语法，例如 `nodiscard`, `maybe_unused`, `deprecated`, `fallthrough`
- 新的函数: `memccpy()`, `strdup()`, `strndup()` ——— 类似于 POSIX、SVID中 C 函数库的扩充
- 强制规范使用二补数表示整数
- 不支援 [K&R 风格的函数定义](https://stackoverflow.com/questions/3092006/function-declaration-kr-vs-ansi)
- 二进制表示法: `0b10101010` 以及对应 printf() 的 `%b` (在此之前 C 语言是不支援二进制表示法的 :rofl:)
- Type generic functions for performing checked integer arithmetic (Integer overflow)
- `_BitInt(N)` and `UnsignedBitInt(N)` types for bit-precise integers
- `#elifdef` and `#elifndef`
- 支持在数值中间加入分隔符，易于阅读，例如 `0xFFFF'FFFF`

{{< admonition info >}}
- [Ever Closer - C23 Draws Nearer](https://thephd.dev/ever-closer-c23-improvements)
- [C23 is Finished: Here is What is on the Menu](https://thephd.dev/c23-is-coming-here-is-what-is-on-the-menu)
{{< /admonition >}}

## C 语言规格书阅读学习记录

规格书草案版本为 n1256，对应 C99 标准，对应的 [PDF 下载地址](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf)。
也配合 C11 标准来阅读，草案版本 n1570，对应的 [PDF 下载地址](http://www.open-std.org/jtc1/sc22/WG14/www/docs/n1570.pdf)。
阅读规格书需要一定的体系结构、编译原理的相关知识，但不需要很高的程度。请善用检索工具，在阅读规格书时遇到术语时，请先在规格书中进行检索，因为极大可能是规格书自己定义的术语。

### 6.2.2 Linkages of identifiers

linkage:
- external
- internal
- none

一个拥有 file scope 并且关于 object 或 function 的 identifier 声明，如果使用 `static` 修饰，则该 identifer 有 internal linkage，e.g.

```c
// file scope
static int a;
static void f();

int main() {}
```

一个 scope 内使用 `static` 修饰的 identifier 声明，如果在同一 scope 内已存在该 identifier 声明，则该 identifier 的 linkage 取决于先前的 identifier 声明。如果该 identifier 不存在先前声明或者先前声明 no linkage，则该 identifier 是 external linkage，e.g.

```c
// Example 1
static int a; // a is internal linkage
extern int a; // linkage is the same as prior

// Example 2
extern int b; // no prior, a is external linkage
extern int b; // linkage is the same as prior
```

如果一个 function identifier 声明没有 storage-class 修饰符，则其 linkage 等价于加上 `extern` 修饰的声明的 linkage，e.g.

```c
int func(int a, int b);
// equal to `extern int func(int a. int b);`
// and then no prior, it is external linkage
```

如果一个 object identifier 声明没有 storage-class 修饰符，且拥有 file scope，则其拥有 external linkage，e.g.

```c
// file scope
int a; // external linkage
int main() {}
```

### 6.5.3 Unary operators

{{< admonition open=false >}}
C99 [6.2.5] ***Types***

- There are three *real floating types*, designated as `float`, `double`, and `long double`.

- The real floating and complex types are collectively called the *floating types*.

- The integer and real floating types are collectively called *real types*.

- Integer and floating types are collectively called *arithmetic types*.

- A *function type* describes a function with specified return type. A function type is
characterized by its return type and the number and types of its parameters. A
function type is said to be derived from its return type, and if its return type is T, the
function type is sometimes called ''function returning T''. The construction of a
function type from a return type is called ‘‘function type derivation’’.

- Arithmetic types and pointer types are collectively called *scalar types*.

C99 [6.3.2.1] ***Lvalues, arrays, and function designators***

- A *function designator* is an expression that has function type. Except when it is the
operand of the `sizeof` operator or the unary `&` operator, a function designator with
type ‘‘function returning type’’ is converted to an expression that has type ‘‘pointer to
function returning type’’.
{{< /admonition >}}

#### 6.5.3.1 Prefix increment and decrement operators

{{< details "Constraints">}}
前缀自增或自减运算符的操作数，必须为实数 (real types) 类型（即不能是复数）或者是指针类型，并且其值是可变的。
{{< /details >}}

{{< details "Semantics" >}}
- `++E` 等价于 `(E+=1)`
- `--E` 等价于 `(E-=1)`
{{< /details >}}

#### 6.5.3.2 Address and indirection operators

{{< details "Constraints">}}
`&` 运算符的操作数必须为 function designator，`[]` 或 `*` 的运算结果，或者是一个不是 bit-field 和 `register` 修饰的左值。

`*` 运算符的操作数必须为指针类型。
{{< /details >}}

{{< details "Semantics" >}}
`&*E` 等价于 `E`，即 `&` 和 `*` 被直接忽略，但是它们的 constraints 仍然起作用。所以 `(&*(void *)0)` 并不会报错。
`&a[i]` 等价于 `a + i`，即忽略了 `&` 以及 `*` (由 `[]` 隐式指代)。
其它情况 `&` 运算的结果为一个指向 object 或 function 的指针。

如果 `*` 运算符的操作数是一个指向 function 的指针，则结果为对应的 function designator。
如果 `*` 运算符的操作数是一个指向 object 的指针，则结果为指示该 obejct 的左值。
如果 `*` 运算符的操作数为非法值的指针，则对该指针进行 `*` 运算的行为三未定义的。
{{< /details >}}

#### 6.5.3.3 Unary arithmetic operators

{{< details "Constraints" >}}
单目 `+` 或 `-` 运算符的操作数必须为算数类型 (arithmetic type)，`~` 运算符的操作数必须为整数类型 (integer type)，`!` 运算符的操作数必须为常数类型 (scalar type)。
{{< /details >}}


{{< details "Semantics" >}}
在进行单目 `+`、`-`、`~` 运算之前，会对操作数进行整数提升 (integer promotions)，结果的类型与操作数进行整数提升后的类型一致。

`!E` 等价于 `(E==0)`，结果为 `int` 类型。
{{< /details >}}


### 6.5.6 Additive operators

介绍加减法运算，其中包括了指针的运算，务必阅读这部分关于指针运算的标准说明。

### 6.5.7 Bitwise shift operators

{{< details" Constraints" >}}
位运算的操作数都必须为整数类型。
{{< /details >}}

{{< details "Semantics" >}}

在进行位运算之前会先对操作数进行整数提升 (integer promotion)，位运算结果类型与整数提升后的左操作数一致。如果右运算数是负数，或者大于等于整数提升后的左运算数的类型的宽度，那么这个位运算行为是未定义的。

> 假设运算结果的类型为 **T**

{{< raw >}}$E1 << E2${{< /raw >}}

- 如果 **E1** 是无符号，则结果为 $E1 \times 2^{E2} \bmod (\max[T] + 1)$。
- 如果 **E1** 是有符号，**E1** 不是负数，并且 **T** 可以表示 $E1 \times 2^{E2}$，则结果为 $E1 \times 2^{E2}$。

除了以上两种行为外，其他均是未定义行为。

{{< raw >}}$E1 >> E2${{< /raw >}}

- 如果 **E1** 是无符号，或者 **E1** 是有符号并且是非负数，则结果为 $E1 / 2^{E2}$。
- 如果 **E1** 是有符号并且是负数，则结果由具体实现决定 (implementation-defined)。

{{< /details >}}

描述了头文件 `stdint.h` 必须定义和实现的整数类型，以及相应的宏。

### 7.18.1 Integer types

#### 7.18.1.1 Exact-width integer types

二补数编码，固定长度 N 的整数类型：

- 有符号数：`intN_t`
- 无符号数：`uintN_t`

#### 7.18.1.2 Minimum-width integer types

至少拥有长度 N 的整数类型：

- 有符号数：`int_leastN_t`
- 无符号数：`uint_leastN_t`

#### 7.18.1.3 Fastest minimum-width integer types

至少拥有长度 N，且操作速度最快的整数类型：

- 有符号数：`int_fastN_t`
- 无符号数：`uint_fastN_t`

#### 7.18.1.4 Integer types capable of holding object pointers

可以将指向 `void` 的有效指针转换成该整数类型，也可以将该整数类型转换回指向 `void` 的指针类型，并且转换结果与之前的指针值保持一致：

- 有符号数：`intptr_t`
- 无符号数：`uintptr_t`

#### 7.18.1.5 Greatest-width integer types

可以表示任意整数类型所表示的值的整数类型，即具有最大长度的整数类型：

- 有符号数：`intmax_t`
- 无符号数：`uintmax_t`
