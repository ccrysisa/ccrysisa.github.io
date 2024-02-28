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
  - Standard
categories:
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

<!--more-->

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

{{< image src="https://imgur-backup.hackmd.io/ITVm6gI.png" >}}

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
