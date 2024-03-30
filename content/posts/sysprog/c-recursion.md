---
title: "你所不知道的 C 语言: 递归调用篇"
subtitle:
date: 2024-03-16T20:56:18+08:00
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
  - Recursion
categories:
  - C
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

> 在许多应用程序中，递归 (recursion) 可以简单又优雅地解决貌似繁琐的问题，也就是不断地拆解原有问题为相似的子问题，直到无法拆解为止，并且定义最简化状况的处理机制，一如数学思维。递归对 C 语言程序开发者来说，绝对不会陌生，但能掌握者却少，很多人甚至难以讲出汉诺塔之外的使用案例。
> 
> 究竟递归是如何优雅地解决真实世界的问题，又如何兼顾执行效率呢》我们从运作原理开始探讨，搭配若干 C 程序解说，并且我们将以简化过的 UNIX 工具为例，分析透过递归来大幅缩减程式码。
> 
> 或许跟你想象中不同，Linux 核心的原始程式码里头也用到递归函数呼叫，特别在较复杂的实作，例如文件系统，善用递归可大幅缩减程式码，但这也导致追踪程序运作的难度大增。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-recursion" content="原文地址" external-icon=true >}}

## Recursion

> To Iterate is Human, to Recurse, Divine.
- [x] http://coder.aqualuna.me/2011/07/to-iterate-is-human-to-recurse-divine.html

{{< admonition >}}
笔者的递归 (Recursion) 是通过 UC Berkeley 的 

- [CS61A: Structure and Interpretation of Computer Programs](https://cs61a.org/)
- [CS70: Discrete Mathematics and Probability Theory](https://www.eecs70.org/) 

学习的，这个搭配式的学习模式使得我在实作——递归 (cs61a) 和理论——归纳法 (cs70) 上相互配合理解，从而对递归在实作和理论上都有了充分认知。
{{< /admonition >}}

## 递归并没有想象的那么慢

以最大公因数 (Greatest Common Divisor, GCD) 为例，分别以循环和递归进行实作:

```c
unsigned gcd_rec(unsigned a, unsigned b) {
    if (!b) return a;
    return gcd_rec(b, a % b);
}

unsigned gcd_itr(unsigned a, unsigned b) {
    while (b) {
        unsigned t = b;
        b = a % b;
        a = t;
    }
    return a;
}
```

这两个函数在 clang/llvm 优化后的编译输出 (`clang -S -O2 gcd.c`) 的汇编是一样的:

```
.LBB0_2:
	movl	%edx, %ecx
	xorl	%edx, %edx
	divl	%ecx
	movl	%ecx, %eax
	testl	%edx, %edx
	jne	.LBB1_2
```

{{< admonition tip >}}
- [x] [遞迴 (Recursion)](https://notfalse.net/9/recursion)

Tail recursion 可以被编译器进行k空间利用最优化，从而达到和循环一样节省空间，但这需要编译器支持，有些编译器并不支持 tail recursion 优化 :rofl:

虽然如此，将一般的递归改写为 tail recursion 还是可以获得极大的效能提升。
{{< /admonition >}}

{{< link href="https://github.com/ccrysisa/LKI/blob/main/c-recursion" content=Source external-icon=true >}}

## 案例分析: 等效电阻

```
                        r
              ----------###-------------  A          -------- A
             |                  |                    |
             #                  #                    #
R(r, n - 1)  #                r #             ==>    #  R(r, n)
             #                  #                    #
             |                  |                    |
             ---------------------------  B          -------- B
```

{{< raw >}}
$$
R(r,n)=
\begin{cases}
r & \text{if n = 1}\\
1 / (\frac1r + \frac1{R(r, n - 1) + r}) & \text{if n > 1}
\end{cases}
$$
{{< /raw >}}

```py
def circuit(n, r):
    if n == 1:
        return r
    else:
        return 1 / (1 / r + 1 / (circuit(n - 1, r) + r))
```

## 案例分析: 数列输出

- man 3 printf
```
RETURN VALUE
      Upon successful return, these functions return the number of characters
      printed (excluding the null byte used to end output to strings).
```

可以通过 `ulimit -s` 来改 stack size，预设为 8MB

- ulimit
```
User limits - limit the use of system-wide resources.
   -s   The maximum stack size.
```

现代编译器的最优化可能会造成递归实作的非预期改变，因为编译器可能会对递归实作在编译时期进行一些优化，从而提高效能和降低内存使用。

## 递归程序设计

- [Recursive Programming](https://web.archive.org/web/20191228141133/http://www.cs.cmu.edu:80/~adamchik/15-121/lectures/Recursions/recursions.html)
 
## Fibonacci sequence

使用矩阵配合快速幂算法，可以将时间复杂度从 $O(n)$ 降低到 $O(\\log n)$

| 方法 | 时间复杂度 | 空间复杂度 |
| -------------- | ------------ | ------------ |
| Rcursive       | $O(2^n)$     | $O(n)$       |
| Iterative      | $O(n)$       | $O(1)$       |
| Tail recursion | $O(n)$       | $O(1)$       |
| Q-Matrix       | $O(\\log n)$ | $O(n)$       |
| Fast doubling  | $O(\\log n)$ | $O(1)$       |

原文的 Q-Matrix 实作挺多漏洞的，下面为修正后的实作 (注意矩阵乘法的 `memset` 是必须的，否则会使用到栈上超出生命周期的 obeject):

```c
void matrix_multiply(int a[2][2], int b[2][2], int t[2][2])
{
    memset(t, 0, sizeof(int) * 2 * 2);
    for (int i = 0; i < 2; i++)
        for (int j = 0; j < 2; j++)
            for (int k = 0; k < 2; k++)
                t[i][j] += a[i][k] * b[k][j];
}

void matrix_pow(int a[2][2], int n, int t[2][2])
{
    if (n == 1) {
        t[0][0] = a[0][0];
        t[0][1] = a[0][1];
        t[1][0] = a[1][0];
        t[1][1] = a[1][1];
        return;
    }
    if (n % 2 == 0) {
        int t1[2][2];
        matrix_pow(a, n >> 1, t1);
        matrix_multiply(t1, t1, t);
        return;
    } else {
        int t1[2][2], t2[2][2];
        matrix_pow(a, n >> 1, t1);
        matrix_pow(a, (n >> 1) + 1, t2);
        matrix_multiply(t1, t2, t);
        return;
    }
}

int fib(int n)
{
    if (n <= 0)
        return 0;
    int A1[2][2] = {{1, 1}, {1, 0}};

    int result[2][2];
    matrix_pow(A1, n, result);
    return result[0][1];
}
```

Fast doubling 公式:
{{< raw >}}
$$
\begin{split}
F(2k) &= F(k)[2F(k+1) - F(k)] \\
F(2k+1) &= F(k+1)^2+F(k)^2
\end{split}
$$
{{< /raw >}}

具体推导:

{{< raw >}}
$$
\begin{split}
\begin{bmatrix}
 F(2n+1) \\
 F(2n)  
\end{bmatrix} &=
\begin{bmatrix}
 1 & 1 \\
 1 & 0  
\end{bmatrix}^{2n}
\begin{bmatrix}
 F(1) \\
 F(0) 
\end{bmatrix}\\ \\ &=
\begin{bmatrix}
 1 & 1 \\
 1 & 0  
\end{bmatrix}^n
\begin{bmatrix}
 1 & 1 \\
 1 & 0  
\end{bmatrix}^n
\begin{bmatrix}
 F(1) \\
 F(0) 
\end{bmatrix}\\ \\ &=
\begin{bmatrix}
F(n+1) & F(n) \\
F(n) & F(n-1)  
\end{bmatrix}
\begin{bmatrix}
F(n+1) & F(n) \\
F(n) & F(n-1)  
\end{bmatrix}
\begin{bmatrix}
 1 \\
 0 
\end{bmatrix}\\ \\ &=
\begin{bmatrix}
 F(n+1)^2 + F(n)^2\\
 F(n)F(n+1) + F(n-1)F(n) 
\end{bmatrix}
\end{split}
$$
{{< /raw >}}

然后根据 $F(k + 1) = F(k) + F(k - 1)$ 可得 $F(2k)$ 情况的公式。

原文中非递增情形比较晦涩，但其本质是通过累加来逼近目标值:

```c
else {
    t0 = t3;       // F(n-2);
    t3 = t4;       // F(n-1);
    t4 = t0 + t4;  // F(n)
    i++;
}
```

## 案例分析: 字符串反转

原文对于时间复杂度的分析貌似有些问题，下面给出本人的见解。第一种方法的时间复杂度为: 
$$
T(n) = 2T(n-1) + T(n-2)
$$
所以第一种方法的时间复杂度为 $O(2^n)$。

第二种方法只是列出了程式码，而没有说明递归函数的作用，在本人看来，递归函数一定要明确说明其目的，才能比较好理解递归的作用，所以下面给出递归函数 `rev_core` 的功能说明:

```c
// 返回字符串 head 的最大下标 (下标相对于 idx 偏移)，并且将字符串 head 相对于
// 整条字符串的中间对称点进行反转
int rev_core(char *head, int idx) {
    if (head[idx] != '\0') {
        int end = rev_core(head, idx + 1);
        if (idx > end / 2)
            swap(head + idx, head + end - idx);
        return end;
    }
    return idx - 1;
}

char *reverse(char *s) {
    rev_core(s, 0);
    return s;
}
```

时间复杂度显然为 $O(n)$

## 案例分析: 建立目录

[mkdir](https://man7.org/linux/man-pages/man2/mkdir.2.html) [Linux manual page (2)]
```
DESCRIPTION         
       Create the DIRECTORY(ies), if they do not already exist.
```

补充一下递归函数 `mkdir_r` 的功能描述:

```c
// 从路径 `path` 的第 `level` 层开始创建目录
int mkdir_r(const char *path, int level);
```

## 案例分析: 类似 find 的程序

[opendir](https://man7.org/linux/man-pages/man3/opendir.3.html) [Linux manual page (3)]
```
RETURN VALUE         
       The opendir() and fdopendir() functions return a pointer to the
       directory stream.  On error, NULL is returned, and errno is set
       to indicate the error.
```

[readdir](https://man7.org/linux/man-pages/man3/readdir.3.html) [Linux manual page (3)]
```
RETURN VALUE         
       On success, readdir() returns a pointer to a dirent structure.
       (This structure may be statically allocated; do not attempt to
       free(3) it.)

       If the end of the directory stream is reached, NULL is returned
       and errno is not changed.  If an error occurs, NULL is returned
       and errno is set to indicate the error.  To distinguish end of
       stream from an error, set errno to zero before calling readdir()
       and then check the value of errno if NULL is returned.
```

- [x] 练习: 连同文件一起输出
- [x] 练习: 将输出的 `.` 和 `..` 过滤掉

## 案例分析: Merge Sort

- [x] [Program for Merge Sort in C](https://www.thecrazyprogrammer.com/2014/03/c-program-for-implementation-of-merge-sort.html)
- [MapReduce with POSIX Thread](https://hackmd.io/@top30339/Hkb-lXkyg)

## 函数式程序开发

- [Toward Concurrency](https://hackmd.io/@jserv/H10MXXoT)
- [Functional programming in C](https://lucabolognese.wordpress.com/2013/01/04/functional-programming-in-c/)
- [Functional Programming 风格的 C 语言实作](https://hackmd.io/@sysprog/c-functional-programming)

## 递归背后的理论

- [x] YouTube: [Lambda Calculus - Computerphile](https://youtu.be/eis11j_iGMs)
- YouTube: [Essentials: Functional Programming's Y Combinator - Computerphile](https://youtu.be/9T8A89jgeTI)

第一个影片相对还蛮好懂，第二个影片对于非 PL 背景的人来说完全是看不懂，所以暂时先放弃了

第一个影片主要介绍函数式编程的核心概念: 函数可以像其它 object 一样被传递使用，没有额外的限制，并且 object 是可以由函数来定义、构建的，例如我们可以定义 true 和 false:

TRUE:  $\lambda x.\ \lambda y.\ x$   
FALSE: $\lambda x.\ \lambda y.\ y$   

因为 true 和 false 就是用来控制流程的，为 true 时我们 do somthing，为 false 我们 do other，所以上面这种定义是有意义的，当然你也可以定义为其它，毕竟函数式编程让我们可以定义任意我们想定义的东西 :rofl:

接下来我们就可以通过先前定义的 TRUE 和 FALSE 来实现 NOT, AND, OR 这类操作了:

NOT: $\lambda b.\ b.$ FALSE TRUE   
AND: $\lambda x.\ \lambda y.\ x.\ y.\$ FALSE   
OR:  $\lambda x.\ \lambda y.\ x$ TRUE $y.$   

乍一看这个挺抽象的，其实上面的实现正体现了函数式编程的威力，我们以 NOT TRUE 的推导带大家体会一下:

NOT TRUE   
$\ \ \ \ $ $b.$ FALSE TRUE   
$\ \ \ \ $ TRUE FALSE TRUE   
$\ \ \ \ $ TRUE (FALSE TRUE)   
$\ \ \ \ $ FALSE  

其余推导同理
