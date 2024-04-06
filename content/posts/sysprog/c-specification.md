---
title: "C 语言规格书 重点提示"
subtitle:
date: 2024-01-06T16:07:25+08:00
draft: false
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
  - C
  - Sysprog
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
math: false
lightgallery: false
password:
message:
repost:
  enable: true
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

C 语言规格书阅读学习记录。
规格书草案版本为 n1256，对应 C99 标准，对应的 [PDF 下载地址](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf)。
也配合 C11 标准来阅读，草案版本 n1570，对应的 [PDF 下载地址](http://www.open-std.org/jtc1/sc22/WG14/www/docs/n1570.pdf)。
阅读规格书需要一定的体系结构、编译原理的相关知识，但不需要很高的程度。请善用检索工具，在阅读规格书时遇到术语时，请先在规格书中进行检索，因为极大可能是规格书自己定义的术语。

<!--more-->

## 6. Language

## 6.2 Concepts

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

## 6.5 Expressions

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

## 7. Library

## 7.18 Integer types <stdint.h>

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

