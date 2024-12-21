---
title: "你所不知道的 C 语言: 技巧篇"
subtitle:
date: 2024-04-10T16:06:08+08:00
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

> 本次講座將選定幾個案例，藉此解說 C 語言程式設計的技巧，像是對矩陣操作進行包裝、初始化特定結構的成員、追蹤物件配置的記憶體、Smart Pointer 等等。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-trick" content="原文地址" external-icon=true >}}

{{< image src="https://imgur-backup.hackmd.io/KC1dCXq.jpg" >}}

## 从矩阵操作谈起

C 语言也可作实现 [Object-oriented programming](https://en.wikipedia.org/wiki/Object-oriented_programming) (需要搭配前置处理器扩充语法)

- [ ] GNU Manual [6.29 Designated Initializers](https://gcc.gnu.org/onlinedocs/gcc/Designated-Inits.html)
- [ ] Stack Overflow: [Why does C++11 not support designated initializer lists as C99?](https://stackoverflow.com/questions/18731707/why-does-c11-not-support-designated-initializer-lists-as-c99)
- **从 C99 (含) 以后，C 和 C++ 就分道扬镳了**。相关差异可以参考: [Incompatibilities Between ISO C and ISO C++](http://david.tribble.com/text/cdiffs.htm)
- 结构体的成员函数实作时使用 `static`，并搭配 [API gateway](https://github.com/embedded2016/server-framework/blob/master/async.c#L258) 可以获得一部分 namespace 的功能
- [ ] [Fun with C99 Syntax](https://www.dribin.org/dave/blog/archives/2010/05/15/c99_syntax/)

## 明确初始化特定结构的成员

静态空间初始化配置:

动态空间初始化配置:

- [ ] [Initializing a heap-allocated structure in C](https://tia.mat.br/posts/2015/05/01/initializing_a_heap_allocated_structure_in_c.html)

## 追踪物件配置的记忆体

## Smart Pointer

## C99 Variable Length Arrays (VLA)

## 字符串和数值转换

- [ ] [Integer to string conversion](https://tia.mat.br/posts/2014/06/23/integer_to_string_conversion.html)

## GCC 支援 Plan 9 C Extension

- [ ] GCC [6.65 Unnamed Structure and Union Fields](https://gcc.gnu.org/onlinedocs/gcc/Unnamed-Fields.html)

## GCC transparent union

- [ ] GCC [6.35.1 Common Type Attributes](https://gcc.gnu.org/onlinedocs/gcc/Common-Type-Attributes.html#Common-Type-Attributes)

## 高阶的 C 语言的「开发框架」

[cello](https://libcello.org/) 是上面提到的技巧的集大成者，在 C 语言基础上，提供以下进阶特征:

## 善用 GNU extension 的 typeof

- [ ] GCC [6.7 Referring to a Type with typeof](https://gcc.gnu.org/onlinedocs/gcc/Typeof.html)

> `typeof` 在 C23 中已由 GNU extenison 转正为 C 语言标准
