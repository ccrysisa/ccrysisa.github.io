---
title: C Pointer
subtitle:
date: 2024-01-14T22:41:38+08:00
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
  - draft
categories:
  - draft
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

C99 [6.2.5] ***Types***

> Array, function, and pointer types are collectively called derived declarator types. A declarator type derivation from a type T is the construction of a derived declarator type from T by the application of an array-type, a function-type, or a pointer-type derivation to T.

*derived declarator types*  表示衍生的声明类型，因为 array, function, pointer 本质都是地址，所以可以使用这些所谓的 *derived declarator types* 来提前声明 object，表示在某个地址会存储一个 object，这也是为什么这些类型被规格书定义为 *derived declarator types*。

- **lvalue**: location value
- **rvalue**: Read value
