---
title: "你所不知道的 C 语言: bitwise 操作"
subtitle:
date: 2024-02-23T13:13:33+08:00
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
  - Binary
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

> Linux 核心原始程式码存在大量 bit(-wise) operations (简称 bitops)，颇多乍看像是魔法的 C 程式码就是 bitops 的组合。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-bitwise" content="原文地址" external-icon=true >}}

## 复习数值系统

- [x] YouTube: [十进制，十二进制，六十进制从何而来？阿拉伯人成就了文艺复兴？[数学大师]](https://www.youtube.com/watch?v=8J7sAYoG50A) 
- [x] [你所不知道的 C 语言: 数值系统](https://hackmd.io/@sysprog/c-numerics)
- [x] [解读计算机编码](https://hackmd.io/@sysprog/binary-representation)

### 位元组合

一些位元组合表示特定的意义，而不是表示数值，这些组合被称为 **trap representation**

- C11 6.2.6.2 Integer types
> For unsigned integer types other than unsigned char, the bits of the object representation shall be divided into two groups: value bits and padding bits (there need not be any of the latter). If there are N value bits, each bit shall represent a different power of 2 between 1 and 2N−1, so that objects of that type shall be capable of representing values from 0 to 2N−1 using a pure binary representation; this shall be known as the value representation. The values of any padding bits are unspecified.

`uintN_t` 和 `intN_t` 保证没有填充位元 (padding bits)，且 `intN_t` 是二补数编码，所以对这两种类型进行位操作是安全的。

- C99 7.18.1.1 Exact-width integer types
> The typedef name intN_t designates a signed integer type with width N, no padding bits, and a two’s complement representation.

{{< admonition info >}}
有符号整数上也有可能产生陷阱表示法 (trap representation)

补充资讯: [CS:APP Web Aside DATA:TMIN: Writing TMin in C](https://csapp.cs.cmu.edu/3e/waside/waside-tmin.pdf)
{{< /admonition >}}

### 位移运算

位移运算的未定义情况:

**C99 6.5.7 Bitwise shift operators**

- 左移超过变量长度，则运算结果未定义
> If the value of the right operand is negative or is greater than or equal to the width of the promoted left operand, the behavior is undefined.

- 对一个负数进行右移，C 语言规格未定义，作为 implementation-defined，GCC 实作为算术位移 (arithmetic shift)
> If E1 has a signed type and a negative value, the resulting value is implementation-defined.

### Signed & Unsigned

当 Unsigned 和 Signed 混合在同一表达式时，Signed 会被转换成 Unsigned，运算结果可能不符合我们的预期 (这里大赞 Rust，这种情况会编译失败:rofl:)。案例请参考原文，这里举一个比较常见的例子:

```c
int n = 10; 
for (int i = n - 1 ; i - sizeof(char) >= 0; i--)
    printf("i: 0x%x\n",i);
```

这段程式码会导致无限循环，因为条件判断语句 `i - sizeof(char) >= 0` 恒为真 (变量 i 被转换成 Unsigned 了)。

- 6.5.3.4 The sizeof operator
> The value of the result is implementation-defined, and its type (an unsigned integer type) is size_t, defined in <stddef.h> (and other headers).

- 7.17 Common definitions <stddef.h>
> `size_t` which is the unsigned integer type of the result of the sizeof operator

### Sign Extension

将 w bit signed integer 扩展为 w+k bit signed integer，只需将 sign bit 补充至扩展的 bits。

数值等价性推导:
- positive: 显然是正确的，sign bit 为 0，扩展后数值仍等于原数值
- negitive: 将 w bit 情形时的除开 sign bit 的数值设为 U，则原数值为 $2^{-(w-1)} + U$，则扩展为 w+k bit 后数值为 $2^{-(w+k-1)} + 2^{w+k-2} + ... + 2^{-(w-1)} + U$，因为 $2^{-(w+k-1)} + 2^{w+k-2} + ... + 2^{w-1} = 2^{-(w-1)}$，所以数值依然等价。

> $2^{-(w+k-1)} + 2^{w+k-2} + ... + 2^{w-1}$ 可以考虑从左往右的运算，每次都是将原先的数值减半，所以最后的数值为 $2^{-(w+k-1)}$

所以如果 n 是 signed 32-bit，则 `n >> 31` 等价于 `n == 0 ? 0 : -1`。在这个的基础上，请重新阅读 [解读计算机编码](https://hackmd.io/@sysprog/binary-representation) 中的 abs 和 min/max 的常数时间实作。

## Bitwise Operator

- [x] [Bitwise Operators Quiz Answers](http://doc.callmematthi.eu/C_Bitwise_Operators.html)
- [x] [Practice with bit operations](https://pconrad.github.io/old_pconrad_cs16/topics/bitOps/)
- [x] [Bitwise Practice](https://web.stanford.edu/class/archive/cs/cs107/cs107.1202/lab1/practice.html)

> Each lowercase letter is 32 + uppercase equivalent. This means simply flipping the bit at position 5 (counting from least significant bit at position 0) inverts the case of a letter.

> The gdb print command (shortened p) defaults to decimal format. Use `p/format` to instead select other formats such as `x` for hex, `t` for binary, and `c` for char.

```c
// unsigned integer `mine`, `yours`
remove yours from mine                            mine = mine & ~yours
test if mine has both of two lowest bits on       (mine & 0x3) == 0x3
n least significant bits on, all others off       (1 << n) - 1
k most significant bits on, all others off        (~0 << (32 - k)) or
                                                  ~(~0U >> k)

// unsigned integer `x`, `y` (right-shift: arithmetic shift)
x &= (x - 1)                                      clears lowest "on" bit in x
(x ^ y) < 0                                       true if x and y have opposite signs
```

程序语言只提供最小粒度为 Byte 的操作，但是不直接提供 Bit 粒度的操作，这与字节顺序相关。假设提供以 Bit 为粒度的操作，这就需要在编程时考虑 **大端/小端模式**，极其繁琐。

### bitwise & logical

位运算满足交换律，但逻辑运算并不满足交换律，因为短路机制。考虑 Linked list 中的情形:

```c
// list_head *head
if (!head || list_empty(head))
if (list_empty(head) || !head)
```

第二条语句在执行时会报错，因为 `list_empty` 要求传入的参数不为 NULL。

逻辑运算符 `!` 相当有效，C99 并没有完全支持 bool 类型，对于整数，它是将非零整数视为 true，零视为 false。所以如果你需要保证某一表达式的结果不仅是 true of false，还要求对应 0 or 1 时，可以使用 `!!(expr)` 来实现。

- C99 6.5.3.3 Unary arithmetic operators
> The result of the logical negation operator ! is 0 if the value of its operand compares unequal to 0, 1 if the value of its operand compares equal to 0. The result has type int. The expression !E is equivalent to (0==E).

所以 `!!(expr)` 的结果为 `int` 并且数值只有 0 或 1。

### Right Shifts

对于 Unsigned 或 positive sign integer 做右移运算时 `x >> n`，其最终结果值为 $\lfloor x / 2^n \rfloor$。

因为这种情况的右移操作相当于对每个 bit 表示的 power 加上 $-n$，再考虑有些 bit 表示的 power 加上 $-n$ 后会小于 0，此时直接将这些 bit 所表示的值去除即可 (因为在 integer 中 bit 的 power 最小为 0，如果 power 小于 0 表示的是小数值)，这个操作对应于向下取整。

```
    00010111 >> 2  (23 >> 4)
->  000101.11      (5.75)
->  000101         (5)
```

## bitwise 实作

- Vi/Vim 为什么使用 hjkl 作为移动字符?
> 當我們回顧 1967 年 ASCII 的編碼規範，可發現前 32 個字元都是控制碼，讓人們得以透過這些特別字元來控制畫面和相關 I/O，早期鍵盤的 "control" 按鍵就搭配這些特別字元使用。"control" 組合按鍵會將原本字元的第 1 個 bit 進行 XOR，於是 H 字元對應 ASCII 編碼為 100_1000 (過去僅用 7 bit 編碼)，組合 "control" 後 (即 Ctrl+H) 會得到 000_1000，也就是 backspace 的編碼，這也是為何在某些程式中按下 backspace 按鍵會得到 ^H 輸出的原因。相似地，當按下 Ctrl+J 時會得到 000_1010，即 linefeed

{{< admonition >}}
where n is the bit number, and 0 is the least significant bit
{{< /admonition >}}

{{< link href="https://github.com/ccrysisa/LKI/blob/main/c-bitwise" content=Source external-icon=true >}}

### Set a bit

```c
unsigned char a |= (1 << n);
```

### Clear a bit

```c
unsigned char a &= ~(1 << n);
```

### Toggle a bit

```c
unsigned char a ^= (1 << n);
```

### Test a bit

```c
bool a = (val & (1 << n)) > 0;
```

### The right/left most byte

```c
// assuming 16 bit, 2-byte short integer
unsigned short right = val & 0xff;        /* right most (least significant) byte */
unsigned short left  = (val >> 8) & 0xff; /* left  most (most  significant) byte */

// assuming 32 bit, 4-byte int integer
unsigned int right = val & 0xff;        /* right most (least significant) byte */
unsigned int left  = (val >> 24) & 0xff; /* left  most (most  significant) byte */
```

### Sign bit

```c
// assuming 16 bit, 2-byte short integer, two's complement
bool sign = val & 0x8000;

// assuming 32 bit, 4-byte int integer, two's complement
bool sign = val & 0x80000000;
```

### Uses of Bitwise Operations or Why to Study Bits

- Compression
- Set operations
- Encryption

> 最常见的就是位图 (bitmap)，常用于文件系统 (file system)，可以节省空间 (每个元素只用一个 bit 来表示)，可以很方便的进行集合操作 (通过 bitwise operator)。

```
x ^ y = (~x & y) | (x & ~y)
```

## 影像处理

- [x] Stack Overflow: [what (r+1 + (r >> 8)) >> 8 does?](https://stackoverflow.com/questions/30237567/what-r1-r-8-8-does)

在图形引擎中将除法运算 `x / 255` 用位运算 `(x+1 + (x >> 8)) >> 8` 来实作，可以大幅度提升计算效能。

### 案例分析

实作程式码: [RGBAtoBW](https://github.com/charles620016/embedded-summer2015/tree/master/RGBAtoBW)

给定每个 pixel 为 32-bit 的 RGBA 的 bitmap，提升效能的方案:

- 建立表格加速浮点运算
- 减少位运算: 可以使用 pointer 的 offset 取代原本复杂的 bitwise operation

```c
bwPixel = table[rgbPixel & 0x00ffffff] + rgbPixel & 0xff000000;
```

只需对 RGB 部分建立浮点数表，因为 `rgbPixel & 0xff00000` 获取的是 A，无需参与浮点运算。这样建立的表最大下标应为 0x00ffffff，所以这个表占用 $2^{24} Bytes = 16MB$，显然这个表太大了 **not cache friendly**

```c
bw = (uint32_t) mul_299[r] + (uint32_t) mul_587[g] + (uint32_t) mul_144[b];
bwPixel = (a << 24) + (bw << 16) + (bw << 8) + bw;
```

分别对 R, G, B 建立对应的浮点数表，则这三个表总共占用 $3 \times 2^8 Bytes < 32KB$ **cache friendly**

## 案例探讨

{{< admonition info >}}
- [位元旋转实作和 Linux 核心案例](https://hackmd.io/@sysprog/bitwise-rotation)
- [reverse bit 原理和案例分析](https://hackmd.io/@sysprog/bitwise-reverse)
{{< /admonition >}}

## 类神经网络的 ReLU 极其常数时间复杂度实作

{{< link href="https://hackmd.io/@sysprog/constant-time-relu" content="原文地址" external-icon=true >}}

ReLU 定义如下:
{{< raw >}}
$$
ReLU(x) = 
\begin{cases}
x & \text{if } x \geq 0 \newline
0 & \text{if } x \lt 0
\end{cases}
$$
{{< /raw >}}

显然如果 $x$ 是 32-bit 的二补数，可以使用上面提到的 `x >> 31` 的技巧来实作 constant-time function:

```c
int32_t ReLU(int32_t x) {
    return ~(x >> 31) & x;
}
```

但是在深度学习中，浮点数使用更加常见，对于浮点数进行位移运算是不允许的

- C99 6.5.7 Bitwise shift operators
> Each of the operands shall have integer type.

所以这里以 32-bit float 浮点数类型为例，利用 32-bit 二补数和 32-bit float 的 MSB 都是 sign bit，以及 C 语言类型 union 的特性

- C99 6.5.2.3 
> (82) If the member used to access the contents of a union object is not the same as the member last used to store a value in the object, the appropriate part of the object representation of the value is reinterpreted as an object representation in the new type as described in 6.2.6 (a process sometimes called "type punning"). This might be a trap representation.

即 union 所有成员是共用一块内存的，所以访问成员时会将这块内存存储的 object 按照成员的类型进行解释。利用 `int32_t` 和 `float` 的 MSB 都是 sign bit 的特性，可以巧妙绕开对浮点数进行位移运算的限制，并且因为 union 成员内存的共用性质，保证结果的数值符合预期。

```c
float ReLU(float x) {
    union {
        float f;
        int32_t i;
    } u = {.f = x};

    u.i &= ~(u.i >> 31);
    return u.f;
}
```

同理可以完成 64-bit 浮点数的 ReLU 常数时间实作。

```c
double ReLU(float x) {
    union {
        double f;
        int64_t i;
    } u = {.f = x};

    u.i &= ~(u.i >> 63);
    return u.f;
}
```

## 从 $\sqrt 2$ 的存在谈开平方根的快速运算

{{< link href="https://hackmd.io/@sysprog/sqrt" content="原文地址" external-icon=true >}}

{{< admonition >}}
这一部分需要学员对现代数学观点有一些了解，强烈推荐修台大齐震宇老师的「数学潜水艇/新生营演讲」，齐老师的这些讲座难度和广度大致相当于其它院校开设的「数学导论」一课。
{{< /admonition >}}

### $\sqrt 2$ 的缘起和计算

- [x] YouTube: [第一次数学危机，天才是怎么被扼杀的？](https://youtu.be/nAOVQEcqjSM)

可以通过「十分逼近法」来求得近似精确的 $\sqrt 2$ 的数值，这也是「数值计算/分析」领域的一个应用，除此之外还可以使用「二分逼近法」进行求值。十分逼近法和二分逼近法的主要区别在于：十分逼近法的收敛速度比二分逼近法快很多，即会更快求得理想范围精度对应的数值。

在数组方法的分析中，主要关心两件事:
- 收敛速度
- 误差分析

由逼近法的过程不难看出，它们非常适合使用递归来实作:
- [x] YouTube: [二分逼近法和十分逼近法求平方根](https://www.youtube.com/watch?v=PHPj0jLhcnM)

### 固定点和牛顿法

固定点定理相关的证明挺有意思的 (前提是你修过数学导论这类具备现代数学观点和思维的课 :rofl:):
- 存在性 (分类讨论)
- 唯一性 (反证法)
- 固定点定理 (逻辑推理)

可以将求方程的根转换成求固定点的问题，然后利用收敛数列进行求解:
- $f(x) = 0$
- $g(x) = p - f(x)$ and $g(p) = p$

牛顿法公式:
$$
p \approx p_0 -\dfrac{f(p_0)}{f'(p_0)}
$$

后面利用 $f(x) = x^2 - N = 0$ 求平方根的公式可以根据这个推导而来的，图形化解释 (切线) 也符合这个公式，自行推导:

{{< raw >}}
$$
\begin{split}
f(x) &= x^2-N = 0 \\
b &= a - \frac{f(a)}{f'(a)} = a - \frac{a^2 - N}{2a} \\
  &= \frac{a^2+N}{2a} = (a+\frac{N}{a}) \div 2
\end{split}
$$
{{< /raw >}}

```c
int mySqrt(int n)
{
    if (n == 0)
        return 0;
    if (n < 4)
        return 1;

    unsigned int ans = n / 2;
    if (ans > 65535)  // 65535 = 2^16 - 1
        ans = 65535;
    
    while (ans * ans > n  || (ans + 1) * (ans + 1) <= n)
        ans = (ans + n / ans) / 2;
    return ans;
}
```

这个方法的流程是，选定一个不小于目标值 $x$ 的初始值 $a$，这样依据牛顿法，$a_i,\ a_{i-1},\ ...$ 会递减逼近 $x$。因为是递减的，所以防止第 12 行的乘法溢出只需要考虑初始值 $a$ 即可，这也是第 9~10 行的逻辑。那么只剩下一个问题：如何保证初始值 $a$ 不小于目标值 $x$ 呢？其实很简单，只需要根据当 $n \geq 2$ 时满足 $n=x^2 \geq 2x$，即 $\frac{n}{2} \geq x$，便可推断出 $\frac{n}{2}$ 在 $n \geq 2$ 时必然是满足大等于目标值 $x$，所以可以使用其作为初始值 $a$，这也是第 8 行的逻辑。

因为求解的目标精度是整数，所以第 12 行的判断是否求得平方根的逻辑是合理的 (结合中间值 $a_i$ 递减的特性思考)。

- [x] LeetCode [69. Sqrt(x)](https://leetcode.com/problems/sqrtx/description/)

### 二进位的平方根

在使用位运算计算平方根的程式码中，我们又见到了的 `union` 和 `do {...} whil (0)` 的运用。位运算求解平方根的核心在于: $n$ 可以根据 IEEE 754 表示为 $S\times1.Frac\times2^{127+E}$，这种表示法下求解平方根只需计算 $\sqrt{1.Frac}$ 和 $\sqrt{2^{(127+E)}}$ 两部分 (只考虑非负数的平方根)。虽然描述起来简单，但由于 IEEE 754 编码的复杂性，需要考虑很多情况，例如 $E$ 全 0 或全 1，因为此时对应的数值就不是之前表示的那样了 (指 $S\times1.Frac\times2^{127+E}$)，需要额外考量。

{{< image src="https://hackmd.io/_uploads/Hymhown-9.png" >}}
- sign: 1 bit `0x80000000`
- exponent: 8 bits `0x7f800000`
- fraction: 23 bits `0x007fffff`

原文给出的程式码是用于计算 $n$ 在 IEEE 754 编码下的指数部分在平方根的结果，虽然看起来只需要除以 2 即右移 1 位即可，但其实不然，例如上面所说的考虑指数部分全为 0 的情况，所以这个程式码是精心设计用于通用计算的。

在原始程式码的基础上，加上对 `ix0` (对应 $1.Frac$) 使用牛顿法求平方根的逻辑，即可完成对 `n` 的平方根的求解。

当然这里要求和之前一样，平方根只需要整数精度即可，所以只需求出指数部分的平方根，然后通过二分法进行逼近即可满足要求 (因为剩余部分是 $1.Frac$ 并不影响平方根的整数精度，但是会导致一定误差，所以需要对指数部分进行二分逼近求值)。

> 先求出整數 `n` 開根號後結果的 $1.FRACTION \times 2^{EXPONENT}$ 的 $EXPONENT$ 部份，則我們知道 `n` 開根號後的結果 $k$ 應滿足 $2^{EXPONENT} \leq k < 2^{EXPONENT+1}$，因此後續可以用二分搜尋法找出結果。

{{< admonition >}}
这段程式码可以再一次看到 枚举 `union` 和 宏 `do {...} while (0)` 的应用之外，主要是根据 IEEE 754 编码规范进行求解，所以需要对浮点数的编码格式有一定认知，可以参考阅读: [你所不知道的 C 语言: 浮点数运算](https://hackmd.io/@sysprog/c-floating-point)。
{{< /admonition >}}

### Fast Inverse Square Root (平方根倒数)

下面的录影解说了程式码中的黑魔法 `0x5f3759df` 的原理，本质也是牛顿法，只不过是 **选择一个接近目标值的初始值**，从而只需要一次牛顿法即可求解出相对高精度的目标平方根 (例如将 $1.4$ 作为牛顿法求 $\sqrt 2$ 的初始值，只需一次迭代求解出的精度已经相当惊人了)，除此之外还运用到了对数求平方根倒数的技巧:

- [x] YouTube: [没有显卡的年代，这群程序员用4行代码优化游戏](https://www.youtube.com/watch?v=g1r3iLejTw0)

使用 IEEE 754 表示任意单精度浮点数为: $x = (1 + \frac{M}{2^{23}}) \times 2^{E-127}$，则该 $x$ 对应的对数为

{{< raw >}}
$$
\begin{split}
\log x &= \log{(1 + \frac{M}{2^{23}}) \times 2^{E-127}} \\
       &= \log{(1 + \frac{M}{2^{23}})} + \log{2^{E-127}} \\
       &= \frac{M}{2^{23}} + E - 127 \\
       & = \frac{1}{2^{23}}(2^{23} \times E + M) - 127 \\
       & = \frac{1}{2^{23}}X - 127
\end{split}
$$
{{< /raw >}}

注意上面处理 $\log{(1 + \frac{M}{2^{23}})}$ 部分时使用近似函数 $f(x) = x$ 代替了，当然会有一些误差，但由于我们后面计算的是平方根倒数的近似值，所以有一些误差没有关系。最后的 $2^{23} \times E + M$ 部分只和浮点数的表示域相关，并且 **这个运算的结果值和以二补数编码解释浮点数的数值相同** (参考上面的 IEEE 754 浮点数结构图，以及二补数的数值计算规则)，我们用一个大写标识 $X$ 来标记其只与浮点数编码相关，并且对应二补数编码下的数值。

推导出对数的通用公式后，接下来就可以推导 **平方根倒数的近似值** 了，即求得对应数值的 $-\frac{1}{2}$ 次方。假设 $a$ 是 $y$ 的平方根倒数，则有等式:

{{< raw >}}
$$
\begin{split}
\log a &= \log{y^{-\frac{1}{2}}} \\
\log a &= -\frac{1}{2} \log y \\
-\frac{1}{2^{23}}A - 127 &= -\frac{1}{2}(-\frac{1}{2^{23}} - 127) \\
A &= 381 \times 2^{22} - \frac{1}{2} Y
\end{split}
$$
{{< /raw >}}

中间将数值由浮点数转换成二补数编码表示，并求得最终的浮点数表示为 $381 \times 2^{22} - \frac{1}{2} Y$，其中的 $381 \times 2^{22}$ 对应的 16 进制恰好为 `0x5f400000`，这已经很接近我们看到的魔数了，但还有一点偏差。
这是因为在计算 $\log{(1 + \frac{M}{2^{23}})}$ 时直接使用 $f(x) = x$ 导致的总体误差还是较大，但是只需要将其稍微往 $y$ 轴正方向偏移一些就可以减少总体误差 (机器学习中常用的技巧 :rofl:)，所以使用 $\frac{M}{2^{23}} + \lambda$ 代替原先的 $\frac{M}{2^{23}}$ ($\lambda$ 为修正的误差且 $\lambda > 0$)，这会导致最终结果的 381 发生稍微一些变化 (因为二补数编码解释浮点数格式部分 $X$ 不能动，只能影响常数 $127$，而常数 $127$ 又直接影响最终结果的 $381$ 这类常数部分)，进而产生魔数 `0x5f3759df`。
 
```c
float InvSqrt(float x)
{  
    float xhalf = 0.5f * x;
    int i = *(int *) &x;
    i = 0x5f3759df - (i >> 1);
    x = *(float *) &i;
    x = x * (1.5f - xhalf * x * x); // only once newton iteration
    return x;
}
```

## C 语言的 bit-field

{{< link href="https://hackmd.io/@sysprog/c-bitfield" content="原文地址" external-icon=true >}}

```c
#include <stdbool.h>
#include <stdio.h>
bool is_one(int i) { return i == 1; }
int main() {
    struct { signed int a : 1; } obj = { .a = 1 };
    puts(is_one(obj.a) ? "one" : "not one");
    return 0;
}
```

- C99 6.7.2.1 Structure and union specifiers

> A bit-field shall have a type that is a qualified or unqualified version of `_Bool`, `signed int`, `unsigned int`, or some other implementation-defined type. 

> A bit-field is interpreted as a signed or unsigned integer type consisting of the specified number of bits.

将 `a` 这个 1-bit 的位域 (bit-field) 声明成 `signed int`，即将 `a` 视为一个 1-bit 的二补数，所以 `a` 的数值只有 0，-1。接下来将 1 赋值给 `a` 会使得 `a` 的数值为 -1，然后将 `a` 作为参数传入 `is_one` 时会进行符号扩展 (sign extension) 为 32-bit 的二补数 (假设编译器会将 `int` 视为 signed int)，所以数值仍然为 -1。因此最终会输出 "not one".

### Linux 核心: BUILD_BUG_ON_ZERO()

```c
/*
 * Force a compilation error if condition is true, but also produce a
 * result (of value 0 and type size_t), so the expression can be used
 * e.g. in a structure initializer (or where-ever else comma expressions
 * aren't permitted).
 */
#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
```

这个宏运用了上面所说的 `!!` 技巧将 `-!!(e)` 的数值限定在 0 和 -1。

这个宏的功能是:
- 当 `e` 为 true 时，`-!!(e)` 为 -1，即 bit-field 的 size 为负数
- 当 `e` 为 false 时，`-!!(e)` 为 0，即 bit-field 的 size 为 0

- C99 6.7.2.1 Structure and union specifiers

> The expression that specifies the width of a bit-field shall be an **integer constant expression with a nonnegative value** that does not exceed the width of an object of the type that would be specified were the colon and expression omitted. If the value is zero, the declaration shall have no declarator.

> A bit-field declaration with no declarator, but only a colon and a width, indicates an unnamed bit-field. As a special case, a bit-field structure member with a width of 0 indicates that no further bit-field is to be packed into the unit in which the previous bitfield, if any, was placed.

> (108) An unnamed bit-field structure member is useful for padding to conform to externally imposed layouts.

根据上面 C99 标准的说明，当 bit-feild 的 size 为负数时会编译失败 (只允许 integer constant expression with a nonnegative value)，当 bit-field 为 0 时，会进行 alignment (以之前的 bit-field 成员所在的 unit 为单位)。

```c
struct foo {
    int a : 3;
    int b : 2;
    int : 0; /* Force alignment to next boundary */
    int c : 4;
    int d : 3;
};

int main() {
    int i = 0xFFFF;
    struct foo *f = (struct foo *) &i;
    printf("a=%d\nb=%d\nc=%d\nd=%d\n", f->a, f->b, f->c, f->d);
    return 0;
}
```

这里使用了 size 为 0 的 bit-field，其内存布局如下:

```
i = 1111 1111 1111 1111
X stand for unknown value
assume little endian

padding & start from here
        ↓
        1111 1111 1111 1111XXXX XXXX XXXX XXXX
                     b baaa           ddd cccc

        |←  int 32 bits  →||←  int 32 bits  →|
```

zero size bit-field 使得这里在 `a`, `b` 和 `c`, `d` 之间进行 `sizeof(int)` 的 alignment，所以 `c`, `d` 位于 `i` 这个 object 范围之外，因此 `c`, `d` 每次执行时的数值是不确定的，当然这也依赖于编译器，可以使用 gcc 和 clang 进行测试 :rofl:

- C11 3.14 1 memory location
> (*NOTE 2*) A bit-field and an adjacent non-bit-field member are in separate memory locations. The same
> applies to two bit-fields, if one is declared inside a nested structure declaration and the other is not, or if the
> two are separated by a zero-length bit-field declaration, or if they are separated by a non-bit-field member
> declaration. It is not safe to concurrently update two non-atomic bit-fields in the same structure if all
> members declared between them are also (non-zero-length) bit-fields, no matter what the sizes of those
> intervening bit-fields happen to be.

所以 `BUILD_BUG_ON_ZERO` 宏相当于编译时期的 `assert`，因为 `assert` 是在执行时期才会触发的，对于 Linux 核心来说代价太大了 (想象一下核心运行着突然触发一个 `assert` 导致当掉 :rofl:)，所以采用了 `BUILD_BUG_ON_ZERO` 宏在编译时期就进行检查 (莫名有一种 Rust 的风格 :rofl:)

对于 `BUILD_BUG_ON_ZERO` 这个宏，C11 提供了 [_Static_assert](https://en.cppreference.com/w/c/language/_Static_assert) 语法达到相同效果，但是 Linux kernel 自己维护了一套编译工具链 (这个工具链 gcc 版本可能还没接纳 C11 :rofl:)，所以还是使用自己编写的 `BUILD_BUG_ON_ZERO` 宏。
 