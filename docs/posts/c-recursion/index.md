# 你所不知道的 C 语言: 递归呼叫篇


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

- [ ] [遞迴 (Recursion)](https://notfalse.net/9/recursion)

Tail recursion 可以被编译器进行最优化，从而达到和循环一样节省空间，但这需要编译器支持，有些编译器并不支持 tail recursion 优化 :rofl:


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-recursion/  

