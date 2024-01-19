---
title: C 规格第 7 章阅读记录
subtitle:
date: 2024-01-11T23:23:48+08:00
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

C 语言规格书 Chapter 7 - Library 阅读记录。

<!--more-->

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
