---
title: "你所不知道的 C 语言: 数值系统篇"
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
  - Numerics
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

> 尽管数值系统并非 C 语言所持有，但在 Linux 核心大量存在 u8/u16/u32/u64 这样通过 typedef 所定义的类型，伴随着各种 alignment 存取，如果对数值系统的认知不够充分，可能立即就被阻拦在探索 Linux 核心之外——毕竟你完全搞不清楚，为何 Linux 核心存取特定资料需要绕一大圈。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-numerics" content="原文地址" external-icon=true >}}

## Balanced ternary

balanced ternary 三进制中 -, 0, + 在数学上具备对称性质。它相对于二进制编码的优势在于，其本身就可以表示正负数 (通过 +-, 0, +)，而二进制需要考虑 unsigned 和 signed 的情况，从而决定最高位所表示的数值。

相关的运算规则:

```
+ add - = 0
0 add + = +
0 add - = -
```

以上运算规则都比较直观，这也决定了 balanced ternary 在编码上的对称性 (减法等价于加上逆元，逆元非常容易获得)。但是需要注意，上面的运算规则并没有涉及到相同位运算的规则，例如 $+\ (add)\ +$，这种运算也是 balanced ternary 相对于二进制编码的劣势，可以自行推导一下这种运算的规则。

- [The Balanced Ternary Machines of Soviet Russia](https://dev.to/buntine/the-balanced-ternary-machines-of-soviet-russia)

## 数值编码与阿贝尔群

阿贝尔群也用于指示为什么使用二补数编码来表示整数:

- 存在唯一的单位元 (二补数中单位元 0 的编码是唯一的)
- 每个元素都有逆元 (在二补数中几乎每个数都有逆元)

浮点数 IEEE 754:

An example of a layout for 32-bit floating point is

{{< image src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Float_example.svg/885px-Float_example.svg.png" >}}

- [x] [Conversión de un número binario a formato IEEE 754](https://www.youtube.com/watch?v=VlX4OlKvzAk)

单精度浮点数相对于整数 **在某些情況下不满足結合律和交换律**，所以不构成 **阿贝尔群**，在编写程序时需要注意这一点。即使编写程序时谨慎处理了单精度浮点数运算，但是编译器优化可能会将我们的处理破划掉。所以涉及到单精度浮点数，都需要注意其运算。

{{< admonition info >}}
- 你所不知道的 C 语言: [浮点数运算](https://hackmd.io/@sysprog/c-floating-point)
- 你所不知道的 C 语言: [编译器和最佳化原理篇](https://hackmd.io/@sysprog/c-compiler-optimization)
{{< /admonition >}}

## Integer Overflow

### 2002 年 FreeBSD [53]

```c
#define KSIZE 1024
char kbuf[KSIZE];
int copy_from_kernel(void *user_dest, int maxlen) {
    int len = KSIZE < maxlen ? KSIZE : maxlen;
    memcpy(user_dest, kbuf, len);
    return len;
}
```

假设将“负”的数值带入 `maxlen`，那么在上述的程式码第 4 行时 `len` 会被赋值为 `maxlen`，在第 5 行中，根据 

- `memcpy` 的原型声明

```c
void *memcpy(void *dest, const void *src, size_t n);
```

会将 `len (=maxlen)` 解释为 `size_t` 类型，关于 `size_t` 类型

- C99 [7.17 Common definitions <stddef.h>]
> **size_t** which is the unsigned integer type of the result of the sizeof operator;

所以在 5 行中 `memcpy` 会将 `len` 这个“负“的数值按照无符号数的编码进行解释，这会导致将 `len` 解释为一个超级大的无符号数，可能远比 `KSIZE` 这个限制大。`copy_from_kernel` 这个函数是运行在 kernel 中的，这样可能会造成潜在的 kernel 信息数据泄露问题。

### 2002 年 External data representation (XDR) [62]

```c
void *copy_elements(void *ele_src[], int ele_cnt, int ele_size) {
    void *result = malloc(ele_cnt * ele_size);
    if (result==NULL) return NULL;
    void *next = result;
    for (int i = 0; i < ele_cnt; i++) {
        memcpy(next, ele_src[i], ele_size);
        next += ele_size;
    }
    return result;
}
```

假设将 ele_cnt = $2^{20}+1$, ele_size=$2^{12}$ 代入，显然在第 2 行的 `ele_cnt * ele_size` 会超出 32 位整数表示的最大值，导致 overflow。又因为

- `malloc` 的原型声明

```c
void *malloc(size_t size);
```

`malloc` 会将 `ele_cnt * ele_size` 溢出后保留的值解释为 `size_t`，这会导致 `malloc` 分配的内存空间远小于 `ele_cnt * ele_size` Bytes (这是 `malloc` 成功的情况，`malloc` 也有可能会失败，返回 NULL)。

因为 `malloc` 成功分配空间，所以会通过第 3 行的测试。在第 5~8 行的 for 循环，根据 `ele_cnt` 和 `ele_size` 的值进行 `memcpy`，但是因为分配的空间远远小于 `ele_cnt * ele_size`，所以这样会覆写被分配空间外的内存区域，可能会造成 kernel 的信息数据被覆盖。

## Bitwise

- [x] 3Blue1Brown: [How to count to 1000 on two hands](https://www.youtube.com/watch?v=1SMmc9gQmHQ) [YouTube]

> 本质上是使用无符号数的二进制编码来进行计数，将手指/脚趾视为数值的 bit

{{< admonition info >}}
- [解读计算机编码](https://hackmd.io/@sysprog/binary-representation)
{{< /admonition >}}

### Power of two

通过以下程式码可以判断 x 是否为 2 的次方

```c
x & (x - 1) == 0
```

通过值为 1 的最低位来进行归纳法证明，例如，对 `0b00000001`, `0b00000010`, `0b00000100`, ... 来进行归纳证明 (还需要证明 x 中只能有一个 bit 为值 1，不过这个比较简单)。另一种思路，通过 LSBO 以及 $X$ 和 $-X$ 的特性来证明。

- LSBO: Least Significant bit of value One
- $-X = ~(X - 1)$
- $-X$ 的编码等价于 $X$ 的编码中比 LSBO 更高的 bits 进行反转，LSBO 及更低的 bits 保持不变

### ASCII table

通过 [ASCII table](https://www.asciitable.com/) 中对 ASCII 编码的分布规律，可以实现大小写转换的 constant-time function

> 也可以通过命令 `man ascii` 来输出精美的 ASCII table

```c
// 字符转小写
(x | ' ')
// 字符转大写
(x & ' ')
// 大小写互转
(x ^ ' ')
```

> Each lowercase letter is 32 + uppercase equivalent. This means simply flipping the bit at position 5 (counting from least significant bit at position 0) inverts the case of a letter.

### XOR swap

通过 xor 运算符可以实现无需临时变量的，交换两个数值的程式码

```c
void xorSwap(int *x, int *y) {
    *x ^= *y;
    *y ^= *x;
    *x ^= *y;
}
```

- 第 3 行的 `*y ^= *x` 的结果等价于 `*y ^ *x ^ *y`，整数满足交换律和结合律，所以结果为 `*x`
- 第 4 行的 `*x ^= *y` 的结果等价于 `*x ^ *y ^ *x`，整数满足交换律和结合律，所以结果为 `*y`

这个实作方法常用于没有额外空间的情形，例如 [Bootloader](https://en.wikipedia.org/wiki/Bootloader#:~:text=A%20bootloader%2C%20also%20spelled%20as,open%20source%20bootloader%20Windows%20bootloader)

### 避免 overflow

整数运算 `(x + y) / 2` 可能会导致 overflow (如果 x, y 数值都接近 UINT32_MAX)，可以改写为以下不会导致 overflow 的程式码

```c
(x & y) + (x ^ y) >> 1
```

使用加法器来思考: 对于 `x + y`，`x & y` 表示进位，`x ^ y` 表示位元和，所以 `x + y` 等价于 

```c
(x & y) << 1 + (x ^ y)
```

这个运算不会导致 overflow (因为使用了 bitwise 运算)。因此 `(x + y) / 2` 等价于

```c
  ((x & y) << 1 + (x ^ y)) >> 1
= ((x & y) << 1) >> 1 + (x ^ y) >> 1
= (x & y) + (x ^ y) >> 1
```

> 整数满足交换律和结合律

### macro DIRECT

```c
#if LONG_MAX == 2147483647L
#define DETECT(X) \
    (((X) - 0x01010101) & ~(X) & 0x80808080)
#else
#if LONG_MAX == 9223372036854775807L
#define DETECT(X) \
    (((X) - 0x0101010101010101) & ~(X) & 0x8080808080808080)
#else
#error long int is not a 32bit or 64bit type.
#endif
#endif
```

DIRECT 宏的作用是侦测 32bit/64bit 中是否存在一个 Byte 为 NULL。我们以最简单的情况 1 个 Byte 时来思考这个实作的本质：

```c
  ((X) - 0x01) & ~(X) & 0x80
= ~(~((X) - 0x01) | X) & 0x80
```

`~((X) - 0x01)` 是 `X` 的取负值编码，即 `-X`，根据二补数编码中 `-X` 和 `X` 的特性，可得 `(~((X) - 0x01) | X)` 为: `X` 二补数编码中值为 1 的最低位 (后续称之为 LSBO) 及更低位保持不变，LSBO 更高位均为 1。则 `~(~((X) - 0x01) | X)` 为: `X` 二补数编码中值为 1 的最低位 (后续称之为 LSBO) 的更低位翻转，LSBO 及更高位均为 0。

> LSBO: Least Significant Bit with value of One

```c
X             = 0x0080
(X) - 0x01    = 0xff80
~((X) - 0x01) = 0x007f
~(~((X) - 0x01) | X) & 0x80 = 0
```

可以自行归纳推导出: 对于任意不为 0 的数值，上述流程推导的最终值都为 0，但对于值为 0 的数值，最终值为 0x80。由此可以推导出最开始的实作 `DIRECT` 宏。

这个 `DIRECT` 宏相当实用，常用于加速字符串操作，将原先的以 1-byte 为单元的操作加速为以 32bit/64bit 为单位的操作。可以阅读相关实作并寻找其中的逻辑:

- [x] [newlib 的 strlen](https://github.com/eblot/newlib/blob/master/newlib/libc/string/strlen.c)
- [x] [newlib 的 strcpy](https://github.com/eblot/newlib/blob/master/newlib/libc/string/strcpy.c)

## Count Leading Zero

计算 $\log_2N$ 可以通过计算数值对应的编码，高位有多少连续的 0'bits，再用 31 减去即可。可以通过 0x0001, 0x0010, 0x0002, ... 等编码来进行归纳推导出该结论。

- iteration version

```c
int clz(uint32_t x) {
    int n = 32, c = 16;
    do {
        uint32_t y = x >> c;
        if (y) { n -= c; x = y; }
        c >>= 1;
    } while (c);
    return (n - x);
}
```

- binary search technique

```c
int clz(uint32_t x) {
    if (x == 0) return 32;
    int n = 0;
    if (x <= 0x0000FFFF) { n += 16; x <<= 16; }
    if (x <= 0x00FFFFFF) { n += 8; x <<= 8; }
    if (x <= 0x0FFFFFFF) { n += 4; x <<= 4; }
    if (x <= 0x3FFFFFFF) { n += 2; x <<= 2; }
    if (x <= 0x7FFFFFFF) { n += 1; x <<= 1; }
    return n;
}
```

- byte-shift version

```c
int clz(uint32_t x) {
    if (x == 0) return 32;
    int n = 1;
    if ((x >> 16) == 0) { n += 16; x <<= 16; }
    if ((x >> 24) == 0) { n += 8; x <<= 8; }
    if ((x >> 28) == 0) { n += 4; x <<= 4; }
    if ((x >> 30) == 0) { n += 2; x <<= 2; }
    n = n - (x >> 31);
    return n;
}
```

在这些实作中，循环是比较直观的，但是比较低效；可以利用编码的特性，使用二分法或位运算来加速实作。

## 避免循环

```c
int func(unsigned int x) {
    int val = 0; int i = 0;
    for (i = 0; i < 32; i++) {
        val = (val << 1) | (x & 0x1);
        x >>= 1;
    }
    return val;
}
```

这段程式码的作用是，对一个 32bit 的数值进行逐位元反转。这个逐位元反转功能非常实用，常实作于加密算法，例如 [DES](https://en.wikipedia.org/wiki/Data_Encryption_Standard)、[AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)。

但是与上面的 Count Leading Zero 类似，上面程式码使用了循环，非常低效，可以通过位运算来加速。

```c
int func(unsigned int x) {
    int val = 0;
    val = num;
    val = ((val & 0xffff0000) >> 16) | ((val & 0x0000ffff) << 16);
    val = ((val & 0xff00ff00) >> 8)  | ((val & 0x00ff00ff) << 8);
    val = ((val & 0xf0f0f0f0) >> 4)  | ((val & 0x0f0f0f0f) << 4);
    val = ((val & 0xcccccccc) >> 2)  | ((val & 0x33333333) << 2);
    val = ((val & 0xaaaaaaaa) >> 1)  | ((val & 0x55555555) << 1);
    return val;
}
```

- [Reverse integer bitwise without using loop](https://stackoverflow.com/questions/21511533/reverse-integer-bitwise-without-using-loop) [Stack Overflow]

{{< admonition tip >}}
Bits Twiddling Hacks 解析: [(一)](https://hackmd.io/@0xff07/ORAORAORAORA), [(二)](https://hackmd.io/@0xff07/MUDAMUDAMUDA), [(三)](https://hackmd.io/@0xff07/WRYYYYYYYYYY)
{{< /admonition >}}

## 加解密的应用

> 假設有一張黑白的相片是由很多個0 ~255 的 pixel 組成 (0 是黑色，255 是白色)，這時候可以用任意的 KEY (000000002 - 111111112) 跟原本的每個 pixel 做運算，如果使用 AND (每個 bit 有 75% 機率會變成 0)，所以圖會變暗。如果使用 OR (每個 bit 有 75% 機率會變 1)，圖就會變亮。這兩種幾乎都還是看的出原本的圖片，但若是用 XOR 的話，每個 bit 變成 0 或 1 的機率都是 50%，所以圖片就會變成看不出東西的雜訊。

{{< image src="https://hackpad-attachments.s3.amazonaws.com/embedded2016.hackpad.com_Sc7AmIvN7EN_p.578574_1463033229650_13199369_1147773728576962_1986608170_o.jpg" >}}

> 上圖左 1 是原圖，左 2 是用 AND 做運算之後，右 2 是用 OR 做運算之後，右 1 是用 XOR，可見使用 XOR 的加密效果最好。

这就是在密码学领域偏爱 XOR 的原因之一。除此之外，XOR 在概率统计上的优异特性也是另一个原因，具体证明推导请查看原文的说明。
