# Linux 核心设计: 2023q2 第二周测验题


{{&lt; admonition abstract &gt;}}
目的: 检验学员对 bitwise 的认知
{{&lt; /admonition &gt;}}

&lt;!--more--&gt;

- {{&lt; link href=&#34;https://hackmd.io/@sysprog/linux2023-quiz2&#34; content=&#34;原文地址&#34; external-icon=true &gt;}}

## 测验 1

原文对于本题的目的说明有一点小错误，原文声称函数 `next_pow2(x)` 的功能为「找出最接近且 **大于等于** 2 的幂的值」，但实际应为「找出最接近且 **大于** 2 的幂的值」

定义 MSB1(x) 为 `x` 的二进制表示法的值为 1 的最高位元，例如对于 8-bit 的二进制数 `00001000`，其 MSB1(x) 为 3 (从右往左并且从 0 开始计数)。

因为在二进制编码表示中，任意一个位元表示的值都是 2 的幂。以 8-bit 无符号数为例，对于 `x` (二进制表示为 `00001xxx`)，其最接近且大于 2 的幂的值的二进制表示为 `00010000`，即 MSB1(x) 向左前进了一位，`MSB1(next_pow2(x))` = `MSB1(x)` &#43; 1，并且将 $[MSB1(x)...0]$ 这个区间的位元全部置为 0 即可。从这个角度出发，只需要将参数 `x` 从第 MSB(x) bit 开始从左往右全部置为 1，即$[MSB1(x)...0]$ 这个区间的位元全部置为 1，然后对该值加 1 即可得到 `next_pow2(x)`，因为此时$[MSB1(x)...0]$ 这个区间的位元全部为 0，并且第 MSB1(x) &#43; 1 bit 的值为 1。

```c
uint64_t next_pow2(uint64_t x)
{
    x |= x &gt;&gt; 1;
    x |= x &gt;&gt; 1;
    x |= x &gt;&gt; 1;
    x |= x &gt;&gt; 1;
    x |= x &gt;&gt; 1;
    x |= x &gt;&gt; 1;
    x |= x &gt;&gt; 1;
    // x |= x &gt;&gt; AAAA;
    x |= x &gt;&gt; 8;
    x |= x &gt;&gt; 16;
    // x |= x &gt;&gt; BBBB;
    x |= x &gt;&gt; 32;
    // return CCCC;
    return x &#43; 1;
}
```

这个做法是先使用 MSB1(x) 填充 $[MSB1(x)...(MSB1(x)-7)]$ 这个区间的 8 个位元全部为 1，因为 MSB1(x) 本身值就为 1，所以只需要使用 7 次右移运算 &#43; 或运算即可。然后使用该位元全为 1 的这 8-bit 继续填充后面的 8 个位元得到 16 个连续且值为 1 的位元，然后是使用 16-bit 填充，最后是 32-bit，因为 `x` 是 64-bit 的无符号数，所以使用 32-bit 进行填充操作时已经覆盖了最极端的情况 (MSB1(x) = 63)。最后加一即可得到预期结果。

{{&lt; admonition question &#34;延伸问题&#34; &gt;}}
1. [x] 解释上述程式码原理，并用 [__builtin_clzl](https://gcc.gnu.org/onlinedocs/gcc/Other-Builtins.html) 改写
&gt; `int __builtin_clz (unsigned int x)`   
&gt; Returns the number of leading 0-bits in x, starting at the most significant bit position. If x is 0, the result is undefined.   
&gt; `int __builtin_clzl (unsigned long)`   
&gt; Similar to __builtin_clz, except the argument type is unsigned long.
{{&lt; /admonition &gt;}}

使用 `__builtin_clzl` 来改写:

```c
uint64_t next_pow2(uint64_t x)
{
    return (1 &lt;&lt; (64 - __builtin_clzl(x)));
}
```

使用 `__builtin_clzl` 配合位移运算，可以直接构造出满足预期结果 (MSB1(x) &#43; 1) 的结果。

## 测验 2

```c
int concatenatedBinary(int n)
{
    const int M = 1e9 &#43; 7;
    int len = 0; /* the bit length to be shifted */
    /* use long here as it potentially could overflow for int */
    long ans = 0;
    for (int i = 1; i &lt;= n; i&#43;&#43;) {
        /* removing the rightmost set bit
         * e.g. 100100 -&gt; 100000
         *      000001 -&gt; 000000
         *      000000 -&gt; 000000
         * after removal, if it is 0, then it means it is power of 2
         * as all power of 2 only contains 1 set bit
         * if it is power of 2, we increase the bit length
         */
        // if (!(DDDD))
        if (!(i &amp; (i - 1)))
            len&#43;&#43;;
        // ans = (i | (EEEE)) % M;
        ans = (i | (ans &lt;&lt; len)) % M;
    }
    return ans;
}
```

通过判断 `i &amp; (i - 1)` 是否为 0 可以判断二进制数 `i` 的值是否为 2 的幂，如果是，则适当扩大表示该二进制数所需要的长度 (因为这对应于二进制的进位概念)，例如 `11` 只需要长度 2，而 `100` 则需要长度 3 来表示该值。

然后可以通过左移来讲对应的数值补充至 `ans` 二进制表示的末尾 `i | (ans &lt;&lt; len)`，最后借助同余的概念来进行取模。

{{&lt; admonition question &#34;延伸问题&#34; &gt;}}
1. [x] 解释上述程式码运作原理
2. [x] 尝试使用 [__builtin_clzl](https://gcc.gnu.org/onlinedocs/gcc/Other-Builtins.html) 改写，并改进 mod $10^9 &#43; 7$ 的运算
{{&lt; /admonition &gt;}}

使用 `__builtin_clzl` 来改写:

```c
int concatenatedBinary(int n)
{
    const int M = 1e9 &#43; 7;
    int len = 0;
    long ans = 0;
    for (int i = 1; i &lt;= n; i&#43;&#43;) {
         if (i == (1 &lt;&lt; (31 - __builtin_clz(i))))
            len&#43;&#43;;
        ans = (i % M | (ans &lt;&lt; len) % M) % M;
    }
    return ans;
}
```

通过 `__builtin_clz` 可以更加直观的判断 `i` 的值是否为 2 的幂次方，除此之外运用同余的性质改进取模运算。


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/linux2023-quiz2/  

