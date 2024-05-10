---
title: "CS:APP 第 2 章重点提示和练习"
subtitle: "Representing and Manipulating Information"
date: 2024-04-19T15:33:40+08:00
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
  - CSAPP
categories:
  - CSAPP
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

> 千万不要小看数值系统，史上不少有名的 [软体缺失案例](https://hackmd.io/@sysprog/software-failure) 就因为开发者未能充分掌握相关议题，而导致莫大的伤害与损失。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/CSAPP-ch2" content="原文地址" external-icon=true >}}

搭配 CMU: 15-213: Intro to Computer Systems: Schedule for Fall 2015
- 可以在 [这里](https://www.cs.cmu.edu/afs/cs/academic/class/15213-f15/www/schedule.html) 找到相关的投影片和录影
- B 站上有一个汉化版本的 [录影](https://www.bilibili.com/video/BV1iW411d7hd/)

## 数值系统

### 导读

- [x] YouTube: [十进制，十二进制，六十进制从何而来？](https://www.youtube.com/watch?v=8J7sAYoG50A)
- [x] YouTube: [老鼠和毒药问题怎么解？二进制和易经八卦有啥关系？](https://www.youtube.com/watch?v=jYQEkkwUBxQ)
- [x] YouTube: [小精靈遊戲中的幽靈是怎麼追蹤人的? 鮮為人知的 bug](https://www.youtube.com/watch?v=jYQEkkwUBxQ)
- [X] [解读计算机编码](https://hackmd.io/@sysprog/binary-representation)
- [ ] [你所不知道的 C 语言: 未定义/未指定行为篇](https://hackmd.io/@sysprog/c-undefined-behavior)
- [x] [你所不知道的 C 语言: 数值系统篇](https://hackmd.io/@sysprog/c-numerics)
- [x] [基于 C 语言标准研究与系统程式安全议题](https://hackmd.io/@sysprog/c-std-security)
- 熟悉浮点数每个位的表示可以获得更大的最佳化空间
  - [ ] [Faster arithmetic by flipping signs](https://nfrechette.github.io/2019/05/08/sign_flip_optimization/)
  - [ ] [Faster floating point arithmetic with Exclusive OR](https://nfrechette.github.io/2019/10/22/float_xor_optimization/)

> 看了上面的第 3 个影片后，对 pac-man 256 莫名感兴趣 :rofl:

### Bits, Bytes & Integers

{{< admonition info >}}
[第一部分录影](https://www.bilibili.com/video/BV1iW411d7hd?p=2) :white_check_mark:
/ 
[投影片](https://www.cs.cmu.edu/afs/cs/academic/class/15213-f15/www/lectures/02-03-bits-ints.pdf) :white_check_mark:
/ 
阅读章节: 2.1 :white_check_mark:
{{< /admonition >}}

{{< admonition info >}}
[第二部分录影](https://www.bilibili.com/video/BV1iW411d7hd?p=3) :white_check_mark:
/ 
[投影片](https://www.cs.cmu.edu/afs/cs/academic/class/15213-f15/www/lectures/02-03-bits-ints.pdf) :white_check_mark:
/ 
阅读章节: 2.2-2.3 
{{< /admonition >}}

{{< image src="/images/c/02-03-bits-ints-41.png" >}}

计算乘法至多需要多少位可以从无符号数和二补数的编码方式来思考。无符号数乘法最大值为 $2^{2w}-2^{2+1}+1$ 不超过 $2^{2w}$，依据无符号数编码方式至多需要 $2w$ bits 表示；二补数乘法最小值为 $-2^{2w-2}+2^{w-1}$，依据而二补数编码 MSB 表示值 $-2^{2w-2}$，所以 MSB 为第 $2w-2$ 位，至多需要 $2w-1$ bits 表示二补数乘法的最小值；二补数乘法最大值为 $2^{2w-2}$，因为 MSB 为符号位，所以 MSB 的右一位表示值 $2^{2w-2}$，即第 $2w-2$ 位，所以至多需要 $2w$ 位来表示该值 (因为还需要考虑一个符号位)。

- CS:APP 2.2.3 Two’s-Complement Encodings
> Note the different position of apostrophes: two’s complement versus ones’ complement. The term “two’s complement” arises from the fact that for nonnegative x we compute a w-bit representation of −x as 2w − x (a single two.) The term “ones’ complement” comes from the property that we can compute −x in this notation as [111 . . . 1] − x (multiple ones).

- CS:APP 2.2.6 Expanding the Bit Representation of a Number
> This shows that, when converting from short to unsigned, the program first changes the size and then the type. That is, (unsigned) sx is equivalent to (unsigned) (int) sx, evaluating to 4,294,954,951, not (unsigned) (unsigned short) sx, which evaluates to 53,191. Indeed, this convention is required by the C standards.

关于位扩展/裁剪与符号类型的关系这部分，可以参看我所写的笔记 [基于 C 语言标准研究与系统程序安全议题]({{< relref "./c-std-security.md" >}})，里面有根据规格书进行了探讨。

- CS:APP
> DERIVATION: Detecting overflow of unsigned addition
> 
> Observe that $x + y \geq x$, and hence if $s$ did not overflow, we will surely have $s \geq x$. On the other hand, if $s$ did overflow, we have $s = x + y − 2^w$. Given that $y < 2^w$, we have $y − 2^w < 0$, and hence $s = x + (y − 2^w ) < x$.

这个证明挺有趣的，对于加法 overflow 得出的结果 $s$ 的值必然比任意一个操作数 $x$ 和 $y$ 的值都小。