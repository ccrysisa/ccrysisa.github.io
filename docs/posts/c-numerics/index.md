# 你所不知道的 C 语言: 数值系统


> 尽管数值系统并非 C 语言所持有，但在 Linux 核心大量存在 u8/u16/u32/u64 这样通过 typedef 所定义的类型，伴随着各种 alignment 存取，如果对数值系统的认知不够充分，可能立即就被阻拦在探索 Linux 核心之外——毕竟你完全搞不清楚，为何 Linux 核心存取特定资料需要绕一大圈。

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

单精度浮点数相对于整数 **在某些情況下不满足結合律和交换律**，所以不构成 **阿贝尔群**，在编写程序时需要注意这一点。即使编写程序时谨慎处理了单精度浮点数运算，但是编译器优化可能会将我们的处理破划掉。所以涉及到单精度浮点数，都需要注意其运算。

{{< admonition info >}}
- [你所不知道的 C 语言: 编译器和最佳化原理篇](https://hackmd.io/@sysprog/c-compiler-optimization)
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

通过值为 1 的最低位来进行归纳法证明，例如，对 `0b00000001`, `0b00000010`, `0b00000100`, ... 来进行归纳证明 (还需要证明 x 中只能有一个 bit 为值 1，不过这个比较简单)。

### ASCII table

通过 [ASCII table](https://www.asciitable.com/) 中对 ASCII 编码的分布规律，可以实现大小写转换的 constant-time function

```c
// 字符转小写
(x | ' ')
// 字符转大写
(x & ' ')
// 大小写互转
(x ^ ' ')
```

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
= (x & y) << 1 >> 1 + (x ^ y) >> 1
= (x & y) + (x ^ y) >> 1
```

> 整数满足交换律和结合律

### macro DIRECT


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-numerics/  

