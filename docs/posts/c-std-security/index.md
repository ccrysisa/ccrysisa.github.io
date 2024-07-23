# 基于 C 语言标准研究与系统程序安全议题


&gt; 借由阅读 C 语言标准理解规范是研究系统安全最基础的步骤，但很多人都忽略阅读规范这点，而正因对于规范的不了解、撰写程序的不严谨，导致漏洞的产生的案例比比皆是，例如 2014 年的 OpenSSL Heartbleed Attack[^1] 便是便是因为使用 memcpy 之际缺乏对应内存范围检查，造成相当大的危害。本文重新梳理 C 语言程序设计的细节，并借由调试器帮助理解程序的运作。

&lt;!--more--&gt;

- {{&lt; link href=&#34;https://hackmd.io/@sysprog/c-std-security&#34; content=&#34;原文地址&#34; external-icon=true &gt;}}

## 目标

1. 借由研读漏洞程序及 C 语言标准，讨论系统程序的安全议题
2. 通过调试器追踪程序实际运行的状况，了解其运作原理
3. 取材自 [dangling pointer](https://en.wikipedia.org/wiki/Dangling_pointer), [CWE-416 Use After Free](https://cwe.mitre.org/data/definitions/416.html), [CVE-2017-16943](https://nvd.nist.gov/vuln/detail/CVE-2017-16943) 以及 [integer overflow](https://en.wikipedia.org/wiki/Integer_overflow) 的议题

## 实验环境

- 编译器版本: gcc 11
- 调试器: GDB
- 操作系统: Ubuntu Linux 22.04

## 主题 (一): Integer type 资料处理

### I. Integer Conversion &amp; Integer Promotion

```c
#include &lt;stdint.h&gt;
#include &lt;stdio.h&gt;
unsigned int ui = 0;
unsigned short us = 0;
signed int si = -1;
int main() {
    int64_t r1 = ui &#43; si;
    int64_t r2 = us &#43; si;
    printf(&#34;%lld %lld\n&#34;, r1, r2);
}
```

上述程式码执行结果为: `r1` 输出为十进制的 4294967295，`r2` 输出为十进制的 -1。这个结果和 C11 规格书中提到的 Integer 的两个特性有关: Integer Conversion 和 Integer Promotion。

#### (1) Integer Conversion

- C11 6.3.1.1 Boolean, characters, and integers
&gt; Every integer type has an integer conversion rank defined as follows:
&gt; 
&gt; - No two signed integer types shall have the same rank, even if they hav e the same
&gt; representation.
&gt; 
&gt; - The rank of a signed integer type shall be greater than the rank of any signed integer
&gt; type with less precision.
&gt; 
&gt; - The rank of long long int shall be greater than the rank of long int, which
&gt; shall be greater than the rank of int, which shall be greater than the rank of short
&gt; int, which shall be greater than the rank of signed char.
&gt; 
&gt; - The rank of any unsigned integer type shall equal the rank of the corresponding
&gt; signed integer type, if any.
&gt; 
&gt; - The rank of any standard integer type shall be greater than the rank of any extended
&gt; integer type with the same width.
&gt; 
&gt; - The rank of any extended signed integer type relative to another extended signed
&gt; integer type with the same precision is implementation-defined, but still subject to the
&gt; other rules for determining the integer conversion rank.

依据上述标准可排出 integer 的 rank:
- long long int &gt; long int &gt; int &gt; short int &gt; signed char
- unsigned int == signed int, if they are both in same precision and same size

#### (2) Integer Promotion

当 integer 进行通常的算数运算 (Usual arithmetic) 时，会先进行 integer promotions 转换成 `int` 或 `unsigned int` 或者保持不变 (转换后的运算子被称为 promoted operands)，然后 promoted operands 再根据自身类型以及对应的 rank 进行 arithmetic conversions，最终得到结果的类型。

- C11 6.3.1.1 Boolean, characters, and integers
&gt; If an int can represent all values of the original type (as restricted by the width, for a bit-field), the value is converted to an int; otherwise, it is converted to an unsigned int. These are called the integer promotions. All other types are unchanged by the integer promotions.

- C11 6.3.1.8 Usual arithmetic conversions
&gt; Otherwise, the integer promotions are performed on both operands. Then the following rules are applied to the promoted operands:
&gt; 
&gt; - If both operands have the same type, then no further conversion is needed.
&gt; 
&gt; - Otherwise, if both operands have signed integer types or both have unsigned
&gt; integer types, the operand with the type of lesser integer conversion rank is
&gt; converted to the type of the operand with greater rank.
&gt; 
&gt; - Otherwise, if the operand that has unsigned integer type has rank greater or
&gt; equal to the rank of the type of the other operand, then the operand with
&gt; signed integer type is converted to the type of the operand with unsigned
&gt; integer type.
&gt; 
&gt; - Otherwise, if the type of the operand with signed integer type can represent
&gt; all of the values of the type of the operand with unsigned integer type, then
&gt; the operand with unsigned integer type is converted to the type of the
&gt; operand with signed integer type.
&gt; 
&gt; - Otherwise, both operands are converted to the unsigned integer type
&gt; corresponding to the type of the operand with signed integer type.

```c
/* In the case that the rank is smaller than int */
char c1, c2;  // Both of them are char
c1 = c1 &#43; c2; // Both are promoted to int, thus result of c1 becomes to integer

/* In the case that the rank is same as int */
signed int si = -1;
/* si &amp; ui are at the same rank
   both are unchanged by the integer promotions */
unsigned int ui = 0;
int result = si &#43; ui; // si is converted to unsigned int, result is unsigned
```

### II. 衍生的安全议题: Integer Overflow

- Stack Overflow: [What is an integer overflow error?](https://stackoverflow.com/questions/2641285/what-is-an-integer-overflow-error)

## 主题 (二): Object 的生命周期

### I. Dangling Pointer

- C11 6.2.4 Storage durations of objects (2)
&gt; The lifetime of an object is the portion of program execution during which storage is
&gt; guaranteed to be reserved for it. An object exists, has a constant address, and retains
&gt; its last-stored value throughout its lifetime. If an object is referred to outside of its
&gt; lifetime, the behavior is undefined. The value of a pointer becomes indeterminate when
&gt; the object it points to (or just past) reaches the end of its lifetime.

- Stack Overflow: [What is a dangling pointer?](https://stackoverflow.com/questions/17997228/what-is-a-dangling-pointer)
&gt; When a pointer is pointing at the memory address of a variable but after some time that variable is deleted from that memory location while the pointer is still pointing to it, then such a pointer is known as a dangling pointer and this problem is known as the dangling pointer problem.

所以在 object 的生命周期结束后，应将指向 object 原本处于的内存空间的指针置为 NULL，避免 dangling pointer。

### II. CWE-416 Use After Free

- [x] OWASP: [Using freed memory](https://owasp.org/www-community/vulnerabilities/Using_freed_memory#)
&gt; Referencing memory after it has been freed can cause a program to crash.
&gt; 
&gt; The use of heap allocated memory after it has been freed or deleted leads to undefined system behavior and, in many cases, to a write-what-where condition.

### III. 案例探讨: CVE-2017-16943 Abusing UAF leads to Exim RCE

- [Road to Exim RCE - Abusing Unsafe Memory Allocator in the Most Popular MTA](https://devco.re/blog/2017/12/11/Exim-RCE-advisory-CVE-2017-16943-en/)

## 实验结果与验证

{{&lt; link href=&#34;https://github.com/ccrysisa/LKI/blob/main/c-std-security&#34; content=&#34;Source&#34; external-icon=true &gt;}}

### (ㄧ) Integer Promotion 验证

测试程式码:
```c { title=&#34;integer-promotion.c&#34; }
#include &lt;stdint.h&gt;
#include &lt;stdio.h&gt;
unsigned int ui = 0;
unsigned short us = 0;
signed int si = -1;
int main() {
    int64_t r1 = ui &#43; si;
    int64_t r2 = us &#43; si;
    printf(&#34;%lld %lld\n&#34;, r1, r2);
}
```

验证结果:
```bash
$ gcc -g -o integer-promotion.o integer-promotion.c 
$ ./integer-promotion.o 
4294967295 -1
```

### (二) Object 生命周期

测试程式码:
```c  { title=&#34;uaf.c&#34; }
#include &lt;inttypes.h&gt;
#include &lt;stdint.h&gt;
#include &lt;stdio.h&gt;
#include &lt;stdlib.h&gt;
int main(int argc, char *argv[]) {
    char *p, *q;
    uintptr_t pv, qv;
    {
        char a = 3;
        p = &amp;a;
        pv = (uintptr_t) p;
    }
    {
        char b = 4;
        q = &amp;b;
        qv = (uintptr_t) q;
    }
    if (p != q) {
        printf(&#34;%p is different from %p\n&#34;, (void *) p, (void *) q);
        printf(&#34;%&#34; PRIxPTR &#34; is not the same as %&#34; PRIxPTR &#34;\n&#34;, pv, qv);
    } else {
        printf(&#34;Surprise!\n&#34;);
    }
    return 0;
}
```

验证结果:
```bash
$ gcc -g -o uaf.o uaf.c 
$ ./uaf.o 
Surprise!

$ gcc -g -o uaf.o uaf.c -fsanitize-address-use-after-scope
$ ./uaf.o 
0x7ffca405c596 is different from 0x7ffca405c597
7ffca405c596 is not the same as 7ffca405c597

$ clang -g -o uaf.o uaf.c 
$ ./uaf.o 
0x7fff86b298ff is different from 0x7fff86b298fe
7fff86b298ff is not the same as 7fff86b298fe
```

gcc 可以通过显式指定参数 `-fsanitize-address-use-after-scope` 来避免 Use-After-Scope 的问题，否则在 scope 结束后，接下来的其他 scope 会使用之前已结束的 scope 的内存空间，从而造成 Use-After-Scope 问题 (使用 GDB 在上面两种不同的情况下，查看变量 `a`, `b` 所在的地址)，而 clang 则是默认开启相关保护。


[^1]: [&#34;OpenSSL Heartbleed&#34;, Synopsys](http://heartbleed.com/)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-std-security/  

