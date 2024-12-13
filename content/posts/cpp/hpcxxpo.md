---
title: "高性能并行编程与优化"
subtitle:
date: 2024-12-08T12:16:15+08:00
slug: 2801980
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
  - C++
  - CMake
categories:
  - C++
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRelated: false
hiddenFromFeed: false
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

## 学 C++ 从 CMake 学起

C++ 头文件 `stdio.h` 和 `cstdio` 的区别仅在于 `cstdio` 在 `stdio.h` 基础上又封装了 namespace `std`，所以引入头文件 `cstdio` 既可以使用 `printf` 也可以使用 `std::printf`，其它与 C 语言标准库同名的头文件和函数功能同理。

CMake 语法中全大写的修饰符是类似于关键字的存在，用于放置与程序员的文件名重复。

C++ 比 C 语言更加强烈依赖上下文信息（主要是泛型、模板、运算符重载这些东西需要上下文才能自动推导），所以多文件编译中声明是非常必要的（这个必要的等级比 C 语言高得多），否则极大可能会出现编译器乱瞎猜然后导致“沉默的错误”。

`<header>` 这种形式表示不要在当前目录下搜索，只在系统目录（一般指 `PATH` 定义的路径）里搜索，`"header"` 这种形式则优先搜索当前目录下有没有这个文件，找不到再搜索系统目录。所以使用 `<header>` 的地方可以使用 `“header"` 来替代，但反之则不行。当然 `<header>` 这种格式并不是毫无用处，它可以确保引入的是系统目录下的而不是当前目录下的文件，这很有用，假设你在当前目录下随便乱写了一共名为 `cstdio` 的文件，思考并尝试一下分别使用 `<>` 和 `""` 引入 `cstdio` 会有什么不同。

暴论：C++/CXX 需要搭配 CMake (的子模块功能) 才能实现类似 Rust 级别的模块管理功能。

菱形依赖是依赖管理中最常见的问题。

{{< admonition tip >}}
投影片配合 CMake 的 [官方文档](https://cmake.org/cmake/help/latest/) 多看多练。
{{< /admonition >}}
