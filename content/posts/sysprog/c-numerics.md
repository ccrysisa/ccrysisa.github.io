---
title: "你所不知道的 C 语言: 数值系统"
subtitle:
date: 2024-02-20T11:13:57+08:00
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

> 尽管数值系统并非 C 语言所持有，但在 Linux 核心大量存在 u8/u16/u32/u64 这样通过 typedef 所定义的类型，伴随着各种 alignment 存取，如果对数值系统的认知不够充分，可能立即就被阻拦在探索 Linux 核心之外--毕竟你完全搞不清楚，为何 Linux 核心存取特定资料需要绕一大圈。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-numerics" content="原文地址" external-icon=true >}}   

## Balanced ternary

balanced ternary 三进制中 -, 0, + 在数学上具备对称性质。它相对于二进制编码的优势在于，其本身就可以表示正负数 (通过 +-, 0, +)，而二进制需要考虑 unsigned 和 signed 的情况，从而决定最高位所表示的数值。

相关的运算规则:

- $+\ (add)\ - = 0$
- $0\ (add)\ + = +$
- $0\ (add)\ - = -$

以上运算规则都比较直观，这也决定了 balanced ternary 在编码上的对称性 (减法等价于加上逆元，逆元非常容易获得)。但是需要注意，上面的运算规则并没有涉及到相同位运算的规则，例如 $+\ (add)\ +$，这种运算也是 balanced ternary 相对于二进制编码的劣势，可以自行推导一下这种运算的规则。

- [ ] [The Balanced Ternary Machines of Soviet Russia](https://dev.to/buntine/the-balanced-ternary-machines-of-soviet-russia)

## 数值编码与阿贝尔群

阿贝尔群也用于指示为什么使用二补数编码来表示整数:

- 存在唯一的单位元 (二补数中单位元 0 的编码是唯一的)
- 每个元素都有逆元 (在二补数中几乎每个数都有逆元)

浮点数 IEEE 754:

- [ ] [Conversión de un número binario a formato IEEE 754](https://www.youtube.com/watch?v=VlX4OlKvzAk)

单精度浮点数相对于整数 **不满足交换律**，所以不构成群，在编写程序时需要注意这一点。即使编写程序时谨慎处理了单精度浮点数运算，但是编译器优化可能会将我们的处理破划掉。所以涉及到单精度浮点数，都需要注意其运算。

{{< admonition info >}}
- [你所不知道的 C 语言: 编译器和最佳化原理篇](https://hackmd.io/@sysprog/c-compiler-optimization)
{{< /admonition >}}

## Integer Overflow

## Bitwise

- [x] 3Blue1Brown: [How to count to 1000 on two hands](https://www.youtube.com/watch?v=1SMmc9gQmHQ) [YouTube]

> 本质上是使用无符号数的二进制编码来进行计数，将手指/脚趾视为数值的 bit

{{< admonition info >}}
- [解读计算机编码](https://hackmd.io/@sysprog/binary-representation)
{{< /admonition >}}
