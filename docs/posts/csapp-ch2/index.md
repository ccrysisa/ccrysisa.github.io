# CS:APP 第 2 章重点提示和练习


&gt; 千万不要小看数值系统，史上不少有名的 [软体缺失案例](https://hackmd.io/@sysprog/software-failure) 就因为开发者未能充分掌握相关议题，而导致莫大的伤害与损失。

&lt;!--more--&gt;

- {{&lt; link href=&#34;https://hackmd.io/@sysprog/CSAPP-ch2&#34; content=&#34;原文地址&#34; external-icon=true &gt;}}

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

&gt; 看了上面的第 3 个影片后，对 pac-man 256 莫名感兴趣 :rofl:

### Bits, Bytes &amp; Integers

{{&lt; admonition info &gt;}}
[第一部分录影](https://www.bilibili.com/video/BV1iW411d7hd?p=2) :white_check_mark:
/ 
[投影片](https://www.cs.cmu.edu/afs/cs/academic/class/15213-f15/www/lectures/02-03-bits-ints.pdf) :white_check_mark:
/ 
阅读章节: 2.1 :white_check_mark:
{{&lt; /admonition &gt;}}

{{&lt; admonition info &gt;}}
[第二部分录影](https://www.bilibili.com/video/BV1iW411d7hd?p=3) :white_check_mark:
/ 
[投影片](https://www.cs.cmu.edu/afs/cs/academic/class/15213-f15/www/lectures/02-03-bits-ints.pdf) :white_check_mark:
/ 
阅读章节: 2.2-2.3 
{{&lt; /admonition &gt;}}

{{&lt; image src=&#34;/images/c/02-03-bits-ints-41.png&#34; &gt;}}

计算乘法至多需要多少位可以从无符号数和二补数的编码方式来思考。无符号数乘法最大值为 $2^{2w}-2^{2&#43;1}&#43;1$ 不超过 $2^{2w}$，依据无符号数编码方式至多需要 $2w$ bits 表示；二补数乘法最小值为 $-2^{2w-2}&#43;2^{w-1}$，依据而二补数编码 MSB 表示值 $-2^{2w-2}$，所以 MSB 为第 $2w-2$ 位，至多需要 $2w-1$ bits 表示二补数乘法的最小值；二补数乘法最大值为 $2^{2w-2}$，因为 MSB 为符号位，所以 MSB 的右一位表示值 $2^{2w-2}$，即第 $2w-2$ 位，所以至多需要 $2w$ 位来表示该值 (因为还需要考虑一个符号位)。

- CS:APP 2.2.3 Two’s-Complement Encodings
&gt; Note the different position of apostrophes: two’s complement versus ones’ complement. The term “two’s complement” arises from the fact that for nonnegative x we compute a w-bit representation of −x as 2w − x (a single two.) The term “ones’ complement” comes from the property that we can compute −x in this notation as [111 . . . 1] − x (multiple ones).

- CS:APP 2.2.6 Expanding the Bit Representation of a Number
&gt; This shows that, when converting from short to unsigned, the program first changes the size and then the type. That is, (unsigned) sx is equivalent to (unsigned) (int) sx, evaluating to 4,294,954,951, not (unsigned) (unsigned short) sx, which evaluates to 53,191. Indeed, this convention is required by the C standards.

关于位扩展/裁剪与符号类型的关系这部分，可以参看我所写的笔记 [基于 C 语言标准研究与系统程序安全议题]({{&lt; relref &#34;./c-std-security.md&#34; &gt;}})，里面有根据规格书进行了探讨。

- CS:APP 2.3.1 Unsigned Addition
&gt; DERIVATION: Detecting overflow of unsigned addition
&gt; 
&gt; Observe that $x &#43; y \geq x$, and hence if $s$ did not overflow, we will surely have $s \geq x$. On the other hand, if $s$ did overflow, we have $s = x &#43; y − 2^w$. Given that $y &lt; 2^w$, we have $y − 2^w &lt; 0$, and hence $s = x &#43; (y − 2^w ) &lt; x$.

这个证明挺有趣的，对于加法 overflow 得出的结果 $s$ 的值必然比任意一个操作数 $x$ 和 $y$ 的值都小。

Practice Problem 2.31 利用了阿贝尔群的定义来说明二补数编码的可结合线，十分有趣。

Practice Problem 2.32 说明了二补数编码的一个需要特别注意的点：二补数编码构成的群是非对称的，$TMin$ 的加法逆元是其自身，其加法逆元后仍为 $TMin$。

- CS:APP 2.3.3 Two’s-Complement Negation
&gt; One technique for performing two’s-complement negation at the bit level is to complement the bits and then increment the result.

&gt; A second way to perform two’s-complement negation of a number $x$ is based on splitting the bit vector into two parts. Let $k$ be the position of the rightmost $1$, so the bit-level representation of $x$ has the form $[x_{w−1}, x_{w−2}, ..., x_{k&#43;1}, 1, 0, ..., 0]$. (This is possible as long as $x \neq 0$.) The negation is then written in binary form as $[~x_{w−1}, ~x_{w−2}, ..., ~x_{k&#43;1}, 1, 0, ..., 0]$. That is, we complement each bit to the left of bit position $k$.

第二种解释在某些情况下十分有效，但这两种计算二补数的加法逆元的方法本质都来自 [解读计算机编码]({{&lt; relref &#34;./binary-representation.md&#34; &gt;}}) 中的时钟模型。

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
&gt; principle: Unsigned multiplication by a power of 2   
&gt; principle: Two’s-complement multiplication by a power of 2

这两个性质 (以及该性质的证明) 说明，无论是无符号数还是二补数，使用左移运算都可以达到与 2 的次方进行乘法运算的效果，甚至在溢出的情况下位模式也匹配。虽然如此，C 语言的编译器的处理可能并不会符合这里说明的等价性，因为无符号数和二补数对于溢出是不一样的。无符号数溢出在 C 语言规范并不是 UB，但二补数或者说有符号数溢出在 C 语言中是 UB，所以有时候使用有符号数分别进行，理论上结果等价的左移运算和乘法运算，得到的结果可能并不相同，特别是在启用了编译器最佳化的情况下 (因为编译器将 UB 即溢出的有符号数乘法运算移除了 :rofl:)。相关的说明请参考阅读 [C 语言: 未定义/未指定行为篇]({{&lt; relref &#34;./c-undefined-behavior&#34; &gt;}})。

- CS:APP 2.3.7 Dividing by Powers of 2
&gt; principle: Unsigned division by a power of 2
&gt; 
&gt; For C variables $x$ and $k$ with unsigned values $x$ and $k$, such that $0 \leq k &lt; w$, the  C expression $x &gt;&gt; k$ yields the value $\lfloor x/2k \rfloor$

使用算术右移获得的结果是 $\lfloor x/2k \rfloor$，这与整数除法获得的满足 *向 0 取整* 性质的结果在负数的情况下显然不同，需要进行相应的调节:
```c
(x &lt; 0 ? x&#43;(1&lt;&lt;k)-1 : x) &gt;&gt; k
```

Practice Problem 2.42 挺有意思的，我扩展了一下思路，将其改编为支援任意 2 的次方的除法:
```c
// x / (2^k)
int div_2pK(int x, int k) {
    int s = (x &gt;&gt; 31);
    return (x &#43; ((-s) &lt;&lt; k) &#43; s) &gt;&gt; k;
}
```

## 浮点数

### 导读

### Floating Point

{{&lt; admonition info &gt;}}
[录影](https://www.bilibili.com/video/BV1iW411d7hd?p=4) :white_check_mark:
/ 
[投影片](https://www.cs.cmu.edu/afs/cs/academic/class/15213-f15/www/lectures/04-float.pdf) :white_check_mark:
/ 
阅读章节: 2.4 
{{&lt; /admonition &gt;}}


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/csapp-ch2/  

