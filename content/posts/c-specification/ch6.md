---
title: C99 Standard 6. Language 阅读记录
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
  - C/C++
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
math: true
lightgallery: false
password:
message:
repost:
  enable: true
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

C 语言规格书 Chapter 6 - Language 阅读记录。

<!--more-->

## 6.5 Expressions

### 6.5.7 Bitwise shift operators

位运算的操作数都必须为整数类型。

在进行位运算之前会先对操作数进行整数提升 (integer promotion)，位运算结果类型与整数提升后的左操作数一致。如果右运算数是负数，或者大于等于整数提升后的左运算数的类型的宽度，那么这个位运算行为是未定义的。

> 假设运算结果的类型为 **T**

{{< raw >}}$E1 << E2${{< /raw >}}

- 如果 **E1** 是无符号，则结果为 $E1 \times 2^{E2} \bmod (\max[T] + 1)$。
- 如果 **E1** 是有符号，**E1** 不是负数，并且 **T** 可以表示 $E1 \times 2^{E2}$，则结果为 $E1 \times 2^{E2}$。

除了以上两种行为外，其他均是未定义行为。

---

{{< raw >}}$E1 >> E2${{< /raw >}}

- 如果 **E1** 是无符号，或者 **E1** 是有符号并且是非负数，则结果为 $E1 / 2^{E2}$。
- 如果 **E1** 是有符号并且是负数，则结果由具体实现决定 (implementation-defined)。

