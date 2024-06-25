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
- [x] [你所不知道的 C 语言: 未定义/未指定行为篇](https://hackmd.io/@sysprog/c-undefined-behavior)
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
阅读章节: 2.2-2.3 :white_check_mark:
{{< /admonition >}}

{{< image src="/images/c/02-03-bits-ints-41.png" >}}

计算乘法至多需要多少位可以从无符号数和二补数的编码方式来思考。无符号数乘法最大值为 $2^{2w}-2^{2+1}+1$ 不超过 $2^{2w}$，依据无符号数编码方式至多需要 $2w$ bits 表示；二补数乘法最小值为 $-2^{2w-2}+2^{w-1}$，依据而二补数编码 MSB 表示值 $-2^{2w-2}$，所以 MSB 为第 $2w-2$ 位，至多需要 $2w-1$ bits 表示二补数乘法的最小值；二补数乘法最大值为 $2^{2w-2}$，因为 MSB 为符号位，所以 MSB 的右一位表示值 $2^{2w-2}$，即第 $2w-2$ 位，所以至多需要 $2w$ 位来表示该值 (因为还需要考虑一个符号位)。

- CS:APP 2.2.3 Two’s-Complement Encodings
> Note the different position of apostrophes: two’s complement versus ones’ complement. The term “two’s complement” arises from the fact that for nonnegative x we compute a w-bit representation of −x as 2w − x (a single two.) The term “ones’ complement” comes from the property that we can compute −x in this notation as [111 . . . 1] − x (multiple ones).

- CS:APP 2.2.6 Expanding the Bit Representation of a Number
> This shows that, when converting from short to unsigned, the program first changes the size and then the type. That is, (unsigned) sx is equivalent to (unsigned) (int) sx, evaluating to 4,294,954,951, not (unsigned) (unsigned short) sx, which evaluates to 53,191. Indeed, this convention is required by the C standards.

关于位扩展/裁剪与符号类型的关系这部分，可以参看我所写的笔记 [基于 C 语言标准研究与系统程序安全议题]({{< relref "./c-std-security.md" >}})，里面有根据规格书进行了探讨。

- CS:APP 2.3.1 Unsigned Addition
> DERIVATION: Detecting overflow of unsigned addition
> 
> Observe that $x + y \geq x$, and hence if $s$ did not overflow, we will surely have $s \geq x$. On the other hand, if $s$ did overflow, we have $s = x + y − 2^w$. Given that $y < 2^w$, we have $y − 2^w < 0$, and hence $s = x + (y − 2^w ) < x$.

这个证明挺有趣的，对于加法 overflow 得出的结果 $s$ 的值必然比任意一个操作数 $x$ 和 $y$ 的值都小。

Practice Problem 2.31 利用了阿贝尔群的定义来说明二补数编码的可结合线，十分有趣。

Practice Problem 2.32 说明了二补数编码的一个需要特别注意的点：二补数编码构成的群是非对称的，$TMin$ 的加法逆元是其自身，其加法逆元后仍为 $TMin$。

- CS:APP 2.3.3 Two’s-Complement Negation
> One technique for performing two’s-complement negation at the bit level is to complement the bits and then increment the result.

> A second way to perform two’s-complement negation of a number $x$ is based on splitting the bit vector into two parts. Let $k$ be the position of the rightmost $1$, so the bit-level representation of $x$ has the form $[x_{w−1}, x_{w−2}, ..., x_{k+1}, 1, 0, ..., 0]$. (This is possible as long as $x \neq 0$.) The negation is then written in binary form as $[~x_{w−1}, ~x_{w−2}, ..., ~x_{k+1}, 1, 0, ..., 0]$. That is, we complement each bit to the left of bit position $k$.

第二种解释在某些情况下十分有效，但这两种计算二补数的加法逆元的方法本质都来自 [解读计算机编码]({{< relref "./binary-representation.md" >}}) 中的时钟模型。

- CSAPP: 2.3.5 Two’s-Complement Multiplication

Practice Problem 2.35 使用了除法的定义证明了，使用除法来检测二补数乘法溢出的正确性 (如果不知道什么是除法的定义，可以看台湾大学齐震宇老师的数学新生营演讲录影，非常棒)。

与加法溢出的检测不太相同，乘法溢出的检测，不论无符号数还是二补数，都可以使用下面这种方法来检测:
```c
// x and y is N-bit wide
int2N_t s = x * y;
return s == (intN_t) s;
```
如果是无符号数则使用相应的 `uint2N_t` 类型。Practice Problem 2.36 和 2.37 都使用到了这个技巧。

- CS:APP 2.3.6 Multiplying by Constants
> principle: Unsigned multiplication by a power of 2   
> principle: Two’s-complement multiplication by a power of 2

这两个性质 (以及该性质的证明) 说明，无论是无符号数还是二补数，使用左移运算都可以达到与 2 的次方进行乘法运算的效果，甚至在溢出的情况下位模式也匹配。虽然如此，C 语言的编译器的处理可能并不会符合这里说明的等价性，因为无符号数和二补数对于溢出是不一样的。无符号数溢出在 C 语言规范并不是 UB，但二补数或者说有符号数溢出在 C 语言中是 UB，所以有时候使用有符号数分别进行，理论上结果等价的左移运算和乘法运算，得到的结果可能并不相同，特别是在启用了编译器最佳化的情况下 (因为编译器将依赖 UB 即溢出的有符号数乘法运算的行为移除了 :rofl:)。相关的说明请参考阅读 [C 语言: 未定义/未指定行为篇]({{< relref "./c-undefined-behavior" >}})。

- CS:APP 2.3.7 Dividing by Powers of 2
> principle: Unsigned division by a power of 2
> 
> For C variables $x$ and $k$ with unsigned values $x$ and $k$, such that $0 \leq k < w$, the  C expression $x >> k$ yields the value $\lfloor x/2k \rfloor$

使用算术右移获得的结果是 $\lfloor x/2k \rfloor$，这与整数除法获得的满足 *向 0 取整* 性质的结果在负数的情况下显然不同，需要进行相应的调节:
```c
(x < 0 ? x+(1<<k)-1 : x) >> k
```

Practice Problem 2.42 挺有意思的，我扩展了一下思路，将其改编为支援任意 2 的次方的除法:
```c
// x / (2^k)
int div_2pK(int x, int k) {
    int s = (x >> 31);
    return (x + ((-s) << k) + s) >> k;
}
```

## 浮点数

### 导读

### Floating Point

{{< admonition info >}}
[录影](https://www.bilibili.com/video/BV1iW411d7hd?p=4) :white_check_mark:
/ 
[投影片](https://www.cs.cmu.edu/afs/cs/academic/class/15213-f15/www/lectures/04-float.pdf) :white_check_mark:
/ 
阅读章节: 2.4 
{{< /admonition >}}

浮点数名字的来源是指数部分 $E$ 可以进行调节进而影响小数点的位置，使得小数点在各种数字的表示时在浮动一般。

{{< image src="/images/c/04-float-13.png" >}}

此时让 Exponent value: E = 1 – Bias (instead of E = 0 – Bias) 可以使得这时的 Exponent value 和 exp 为 1 时 (其 Exponent value 也为 E = 1 – Bias) 相同，让浮点数可以在解决 0 的部分均分表示: $1.xxxx... \times 2^{1 - Bias}$, $0.xxxx... \times 2^{1 - Bias}$

{{< image src="/images/c/04-float-15.png" >}}

Normalized Encoding 时，指数每次 $+ 1$，就会使得可表示的浮点数之间数值的差距 $\times 2$ (因为正如前面所说的，浮点数浮动了小数点，使得用于表示小数位的编码位变少了)。注意下面的 $(n)$ 和 $(1)$ 只是表示 Significand 部分的编码，不代表数值 (因为这部分的数值是小数...)
$$
1.(n+1) \times 2^{K} - 1.(n) \times 2^{K} = (1) \times 2^{K} \\\\
1.(n+1) \times 2^{K + 1} - 1.(n) \times 2^{K + 1} = (1) \times 2^{K + 1} \\\\
(1) \times 2^{K + 1} = 2 \times ((1) \times 2^{K})
$$
显然两个浮点数之间的差距变为了原先的 2 倍了。

{{< image src="/images/c/04-float-24.png" >}}

Nearest Even 是用于决定，当前数值是舍入的两个数值的中间值时，向哪个数值进行舍入的策略。假设当前数值为 $1.2xxxx...$ (十进制)，需要舍入到 $0.1$ 的精度:
- 当 $xxxx... > 5000..0$ 时，即当前数值 $> 1.25$，根据精度向上取整舍入到 $1.3$
- 当 $xxxx... < 5000..0$ 时，即当前数值 $< 1.25$，根据精度向下取整舍入到 $1.2$
- 当 $xxxx... = 5000..0$ 时，即当前数值 $= 1.25$，根据精度舍入到最近偶数 $1.2$

类似的，假设当前数值为 $1.3xxxx...$，情况如下:
- 当 $xxxx... > 5000..0$ 时，即当前数值 $> 1.35$，根据精度向上取整舍入到 $1.4$
- 当 $xxxx... < 5000..0$ 时，即当前数值 $< 1.35$，根据精度向下取整舍入到 $1.3$
- 当 $xxxx... = 5000..0$ 时，即当前数值 $= 1.35$，根据精度舍入到最近偶数 $1.4$

---

- CSAPP 2.4.1 Fractional Binary Numbers
> Note that numbers of the form $0.11...1_2$ represent numbers just below 1.

- CSAPP 2.4.2 IEEE Floating-Point Representation
> Having the exponent value be $1 − Bias$ rather than simply $−Bias$ might seem counterintuitive. We will see shortly that it provides for smooth transition from denormalized to normalized values.

除了让浮点数在靠近 0 的部分平滑均分表示之外，使用 biased form 还可以让浮点数的大小比较变得简单，只需使用 **无符号编码** 表示 exponent field 然后进行比较即可 (如果采取二补数编码，那么编码大的可能表示负数，大小比较起来更麻烦)。

> Denormalized numbers serve two purposes. First, they provide a way to represent numeric value 0

> A second function of denormalized numbers is to represent numbers that are very close to 0.0.

Denormalized 的作用一是表示 0，二是配合 Normalized 在靠近 0 的部分进行平滑均分表示

- CSAPP 2.4.3 Example Numbers

> This is no accident—the IEEE format was designed so that floating-point numbers could be sorted using an integer sorting routine. A minor difficulty occurs when dealing with negative numbers, since they have a leading 1 and occur in descending order, but this can be overcome without requiring floating-point operations to perform comparisons

可以直接使用整数排序来对浮点数进行排序，而无需使用浮点数操作来进行比较，这是 IEEE 754 精心设计的

> We can now see that the region of correlation corresponds to the low-order bits of the integer, stopping just before the most significant bit equal to 1 (this bit forms the implied leading 1), matching the high-order bits in the fraction part of the floating-point representation.

浮点数和无符号数的编码之间的关系，其中无符号数的 MSB equal 1 被忽略，因为浮点数在 Normalized 时会有一个隐含的 1

- CSAPP 2.4.4 Rounding

> Rounding toward even numbers avoids this statistical bias in most real-life
> situations. It will round upward about 50% of the time and round downward about
> 50% of the time.

Round-to-even 可以让 round 后的数据在统计上的均值与原先数据的均值误差比较小
