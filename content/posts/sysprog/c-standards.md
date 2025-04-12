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

{{< admonition type=abstract title="Abstract" >}}
If I had eight hours to chop down a tree, I\'d spend six hours sharpening my axe.

工欲善其事，必先利其器
{{< /admonition >}}

<!--more-->

## C 语言的演化

C 语言规格演化过程: C89/[C90](https://www.iso.org/standard/17782.html) -> [C99](https://www.iso.org/standard/29237.html) -> [C11](https://www.iso.org/standard/57853.html) -> C17/[C18](https://www.iso.org/standard/74528.html) -> C2x

YouTube: [Why C is so Influential](https://www.youtube.com/watch?v=ci1PJexnfNE)

C 语言圣经:

{{< image src="https://imgur-backup.hackmd.io/1gWHzfd.png" >}}

> In C, everything is a representation (unsigned char [sizeof(TYPE)]).

## Why not C++?

{{< admonition type=quote title="Linus Torvalds 在 [2010 年针对 c++ in linux kernel 的回答](http://www.realworldtech.com/forum/?threadid=104196&curpostid=104208)" >}}
And I really do dislike C++. It\'s a really bad language, in my opinion. It tries to solve all the wrong problems, and does not tackle the right ones. The things C++ \"solves\" are trivial things, almost purely syntactic extensions to C rather than fixing some true deep problem.

(The C++ objects, templates and function overloading are all just syntactic sugar. And generally bad syntax at that. And C++ actually makes the C type system actively worse.)
{{< /admonition >}}

相对于 C 语言，C++ 标准更新飞快，从 C++11 开始一大批新特性进入标准:

{{< image src="https://i.imgur.com/ITVm6gI.png" >}}

甚至 C++ 之父 Bjarne Stroustrup 开始倡导 [Learning Standard C++ as a New Language](http://www.stroustrup.com/new_learning.pdf)

并且从几乎同一时期发布的 C99、C++98 标准开始，C 语言和 C++ 分道扬镳，即再也没有 C++ 是 C 语言的超集说法了。举个例子，下面这个结构体成员赋值方法在 C++ 中是不支持的:

```c
struct Foo {
    char x;
    int y;
}

struct Foo foo = {
    .x = 'a',
    .y = 32,
};
```

## 标准 / 规格书

规格书 (PDF): [C99](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf) -> [C11](https://www.open-std.org/jtc1/sc22/WG14/www/docs/n1570.pdf)

阅读 C 语言规格书可以让你洞察本质，不在没意义的事情上浪费时间，例如在某乎大肆讨论的 [C 语言中 int main() 和 void main() 有何区别？](https://www.zhihu.com/question/60047465)

{{< admonition type=quote title="C99/C11 5.1.2.2.1 Program startup">}}
The function called at program startup is named `main`. The implementation declares no prototype for this function. It shall be defined with a return type of `int` and with no parameters:

```c
int main(void) { /* ... */ }
```

or with two parameters (referred to here as `argc` and `argv`, though any names may be used, as they are local to the function in which they are declared):

```c
int main(int argc, char *argv[]) { /* ... */ }
```

or equivalent; or in some other implementation-defined manner. Thus, int can be replaced by a typedef name defined as `int`, or the type of `argv` can be written as `char ** argv`, and so on.
{{< /admonition >}}

C 语言中的 pointer 很重要，但 object 也很重要，这两个概念是一体两面的。注意 object != object-oriented，前者的重点在于 **数据的表示方法**，而后者的重点在于 **everything is object**，是一种思维范式。

{{< admonition type=quote title="C99 3.14 - *object*" >}}
region of data storage in the execution environment, the contents of which can represent values
{{< /admonition >}}

即 C 语言的 object 是指在执行时期，数据存储的区域，其内容可以明确地表示为数值。了解这个概念之后，就可以清晰地认知到在 C 语言中 (int)7 和 (float)7.0 是不等价的，具体解释可以延伸阅读 CSAPP 的第二章。

## cdecl

英文很重要，因为 `cdecl` 可以通过英文来帮助产生 C语言的声明或者对声明进行解释:

```sh
$ sudo apt-get install cdecl
```

使用案例:

```sh
$ cdecl
cdecl> declare a as array of pointer to function returning pointer to function returning pointer to char
char *(*(*a[])())()
cdecl> explain char *(*fptab[])(int)
declare fptab as array of pointer to function (int) returning pointer to char
```

## GDB

- slideshare: [GDB Rocks!](http://www.slideshare.net/chenkaie/gdb-rocks-16951548)
- slideshare: [Introduction to gdb](https://www.slideshare.net/slideshow/introduction-to-gdb-3790833/3790833)
- IBM: [Kernel command using Linux system calls](http://www.staroceans.org/kernel-and-driver/%5BIBM%5D%20Kernel%20command%20using%20Linux%20system%20calls%20%5B2007%5D.pdf)

## C23

- [A cheatsheet of modern C language and library features.](https://github.com/AnthonyCalandra/modern-c-features)

## References

- 你所不知道的 C 語言: [開發工具和規格標準](https://hackmd.io/@sysprog/c-standards)
