---
title: 解读计算机编码
subtitle:
date: 2023-12-31T15:43:50+08:00
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
  - Sysprog
  - Numerics
  - Bitwise
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

> 人们对数学的加减运算可轻易在脑中辨识符号并理解其结果，但电脑做任何事都受限于实体资料储存及操作方式，换言之，电脑硬体实际只认得 0 和 1，却不知道符号 + 和 - 在数学及应用场域的意义，於是工程人员引入「补数」以便在二进位系统中，表达人们认知上的正负数。但您有没有想过，为何「二补数」(2’s complement) 被电脑广泛采用呢？背後的设计考量又是什麽？本文尝试从数学观点去解读编码背後的原理，并佐以资讯安全及程式码最佳化的考量，探讨二补数这样的编码对于程式设计有何关键影响。
<!--more-->

- 原文地址：[解讀計算機編碼](https://hackmd.io/@sysprog/binary-representation)

{{< admonition tip >}}
为了更好的理解本文的一些数学概念，例如群，以及后续其他关于数值系统、浮点数的讲座，Jserv 强烈建议我们去修读数学系的 ***数学导论***。笔者在这里分享一下台大齐震宇老师的 2015 年的新生营讲座，这个讲座覆盖了数学导论的内容。

- YouTube: [臺大 2015 數學系新生營](https://www.youtube.com/playlist?list=PLI1jQCS-KE4zommAEqi47yVzEn552BXz8)
{{< /admonition >}}

## 一补数 (Ones’ complement)

### 9 的补数

- [x] 科普短片: [Not just counting, but saving lives: Curta][not-just-counting-but-saving-lives-curta]

### 运算原理

{{< admonition note >}}
以一补数编码形式表示的运算子，在参与运算后，运算结果符合一补数的编码：

{{< raw >}}
$$
[X]_{一补数} + [Y]_{一补数} = [X+Y]_{一补数}
$$
{{< /raw >}}
{{< /admonition >}}

接下来进行分类讨论，以 32-bit 正数 $X$, $Y$ 为例：

- $X + Y = X + Y$ 显然运算子和运算结果都满足一补数编码。

- $X - Y = X + (2^{32} - 1 - Y)$

  - 如果 $X > Y$，则运算结果应为 $X - Y$ 且为正数，其一补数编码为 $X - Y$。而此时 
  $$
  2^{32} - 1 + X - Y
  $$ 
  显然会溢出，为了使运算结果对应一补数编码，所以此时循环进位对应 $+\ (1 - 2_{32})$。

  - 如果 $X < Y$，则运算结果应为 $X - Y$ 且为负数，其一补数编码为 
  $$
  2^{32} - 1 - （Y - X） = 2_{32} - 1 - X - Y
  $$
  而此时 $2^{32} - 1 + X - Y$ 并不会溢出，并且满足运算结果的一补数编码，所以无需进行循环进位。

  - 如果 $X = Y$，显然 
  $$
  X - Y = X + 2^{32} - 1 - Y = 2^{32} - 1
  $$
  为 0 成立。

- $-X - Y = (2^{32} - 1 - X) + (2^{32} - 1 - Y)$，显然会导致溢出。而 $-X - Y$ 的一补数编码为 
$$
2^{32} - 1 - (X + Y) = 2^{32} - 1 - X - Y
$$
所以需要在溢出时循环进位 $+\ (1 - 2^{32})$ 来消除运算结果中的一个 $2^{32} - 1$。

## 二补数 (Two's complement)

### 正负数编码表示

假设有 n-bit 的二补数编码 $A$，$-A$ 的推导如下：

- 格式一：

{{< raw >}}
$$
\begin{align*}
A + \neg A &= 2^n - 1 \\
A + \neg A + 1 &\equiv 0 \equiv 2^n \ (\bmod 2^n) \\
-A &= \neg A + 1 \\ 
\end{align*}
$$
{{< /raw >}}

- 格式二：

{{< raw >}}
$$
\begin{align*}
A + \neg A &= 2^n - 1 \\
A + \neg A - 1 &= 2^n - 2 \\
A - 1 &= 2^n - 1 - (\neg A + 1) \\ 
\neg (A - 1) &= \neg A + 1 \\
\neg (A - 1) &= -A \\
\end{align*}
$$
{{< /raw >}}

也可以通过一补数和二补数，在时钟表上的对称轴偏差，来理解上述两种方式是等价的。

{{< image src="/images/git/twos_complement.png" caption="Twos' complement" >}}

{{< admonition >}}
在二补数编码中，将一个整数转换成其逆元，也可以依据以下的方法：

以 LSB 到 MSB 的顺序，寻找第一个值为 1 的 bit，将这个 bit 以及比其更低的 bits (包含该 bit) 都保持不变，将比该 bit 更高的 bits (不包括该 bit) 进行取反操作。下面是一些例子 (以 32-bit 为例)：

```
0x0080 <-> 0xff80
0x0001 <-> 0xffff
0x0002 <-> 0xfffe
```
{{< /admonition >}}

### 加 / 减法器设计

科普短片: [See How Computers Add Numbers In One Lesson][see-how-computers-add-numbers-in-one-lesson] :white_check_mark: 

- 了解晶体管的原理
- 了解基本逻辑门元件，例如 OR, AND 逻辑门的设计
- 了解加法器的原理和工作流程。

## 阿贝尔群及对称性

{{< admonition tip >}}
群论的最大用途是关于「对称性」的研究；所有具有对称性质，群论都可派上用场。只要发生变换后仍有什么东西还维持不变，那符合对称的性质。

- 一个圆左右翻转后还是圆，它在这种变换下是对称的，而这刚好与群的 **封闭性 (Closure)** 对应。
- 一个时钟的时刻，从 0 时刻开始，两边的时刻相加模 12 的结果均为 0，这与群的 **单位元 (Identity element)** 和 **逆元 (Inverse element)** 对应。

上述两个例子反映了群论的性质，对于对称性研究的重要性和原理依据。
{{< /admonition >}}

科普影片: [从五次方程到伽罗瓦理论](https://www.youtube.com/playlist?list=PLYtoePJQbGmiq3lqkJcxSKW0eW5objmjQ)

## 旁路攻击

观看科普视频: [我听得到你打了什么字][2xCICHh4Pas] :white_check_mark: 
- [ ] 阅读相关论文 [Keyboard Acoustic Emanations][kbdacoustic]
- [ ] 体验使用相关工具 [kbd-audio][kbd-audio]

借由 Wikipedia 了解旁路攻击 ([Side-channel attack][side-channel-attack]) 和时序攻击 ([Timing attack][timing-attack]) 的基本概念 :white_check_mark: 
- [x] [Black-box testing](https://en.wikipedia.org/wiki/Black-box_testing)
- [x] [Row hammer](https://en.wikipedia.org/wiki/Row_hammer)
- [ ] [Cold boot attack](https://en.wikipedia.org/wiki/Cold_boot_attack)
- [ ] [Rubber-hose cryptanalysis](https://en.wikipedia.org/wiki/Rubber-hose_cryptanalysis)

{{< admonition info "延伸阅读" >}}
- [ ] [The password guessing bug in Tenex](https://www.sjoerdlangkemper.nl/2016/11/01/tenex-password-bug/)
- [ ] [Side Channel Attack By Using Hidden Markov Model](https://www.cs.ox.ac.uk/files/271/NuffieldReport.pdf)
- [ ] [One&Done: A Single-Decryption EM-Based Attack on OpenSSL’s Constant-Time Blinded RSA](https://www.sjoerdlangkemper.nl/2016/11/01/tenex-password-bug/)
{{< /admonition >}}

### Constant-Time Functions

比较常见的常数时间实作方法是，**消除分支**。因为不同分支的执行时间可能会不同，这会被利用进行时序攻击。这个方法需要对 C 语言中的编码和位运算有一定的了解。

- [C99 STandard - 7.18.1.1 Exact-width integer types 阅读记录]({{< relref "../c-pl/c-spec-ch7.md#71811-exact-width-integer-types" >}})
- [C99 Standard - 6.5.7.5 Bitwise shift operators 阅读记录]({{< relref "../c-pl/c-spec-ch6.md#657-bitwise-shift-operators" >}})

{{< link href="https://github.com/ccrysisa/LKI/tree/main/constant-time" content="Source" external-icon=true >}}

#### Branchless abs

> 如果 n 是 signed 32-bit，则 `n >> 31` 等价于 `n == 0 ? 0 : -1`

方法一，原理为 $-A = \neg (A - 1)$:

```c
#include <stdint.h>
int32_t abs(int32_t x) {
    int32_t mask = (x >> 31);
    return (x + mask) ^ mask;
}
```

方法二，原理为 $-A = \neg A + 1$:

```c
#include <stdint.h>
int32_t abs(int32_t x) {
    int32_t mask = (x >> 31);
    return (x ^ mask) - mask;
}
```

#### Branchless min/max

Min:

```c
#include <stdint.h>
int32_t min(int32_t a, int32_t b) {
    int32_t diff = (a - b);
    return b + (diff & (diff >> 31));
}
```
- 如果 `diff > 0` 即 b 小，那么 `(diff >> 31) == 0`，则 `b + (diff & (diff >> 31)) == b`
- 如果 `diff < 0` 即 a 小，那么 `(diff >> 31) == -1`，则 `b + (diff & (diff >> 31)) == b + (a - b) == a`

Max:

```c
#include <stdint.h>
int32_t max(int32_t a, int32_t b) {
    int32_t diff = (b - a);
    return b - (diff & (diff >> 31));
}
```
- 如果 `diff > 0` 即 b 大, 那么 `(diff >> 31) == 0`，则 `b - (diff & (diff >> 31)) == b`
- 如果 `diff < 0` 即 a 大，那么 `(diff >> 31) == -1`，则 `b - (diff & (diff >> 31)) == b - (b - a) == a`

---

{{< admonition info >}}
- [基于 C 语言标准研究与系统程序安全议题](https://hackmd.io/@sysprog/c-std-security)
{{< /admonition >}}

<!-- URL -->
[not-just-counting-but-saving-lives-curta]: https://www.youtube.com/watch?v=kRmExkQoOPY
[see-how-computers-add-numbers-in-one-lesson]: https://www.youtube.com/watch?v=VBDoT8o4q00
[2xCICHh4Pas]: https://www.youtube.com/watch?v=2xCICHh4Pas
[kbd-audio]: https://github.com/ggerganov/kbd-audio
[kbdacoustic]: https://web.eecs.umich.edu/~genkin/teaching/fall2019/EECS598-12_files/kbdacoustic.pdf
[side-channel-attack]: https://en.wikipedia.org/wiki/Side-channel_attack
[timing-attack]: https://en.wikipedia.org/wiki/Timing_attack
