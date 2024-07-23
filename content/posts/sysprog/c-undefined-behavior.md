---
title: "你所不知道的 C 语言: 未定义/未指定行为篇"
subtitle:
date: 2024-04-24T21:09:40+08:00
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
categories:
  - C
  - C++
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

> C 語言最初為了開發 UNIX 和系統軟體而生，本質是低階的程式語言，在語言規範層級存在 undefined behavior，可允許編譯器引入更多最佳化

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-undefined-behavior" content="原文地址" external-icon=true >}}

## 从 C 语言试题谈起

```c
int i = 10;
i = i++ + ++i;
```

请问 `i` 的值在第 2 行执行完毕后为？

> C 語言沒規定 `i++` 或 `++i` 的「加 1」動作到底是在哪個敘述的哪個時刻執行，因此，不同 C 編譯器若在不同的位置 + 1，就可能導致截然不同的結果。

这一部分可以参考「并行程序设计: [执行顺序](https://hackmd.io/@sysprog/concurrency/%2F%40sysprog%2Fconcurrency-ordering)」中 Evaluation 和 Sequenced-before 的讲解。

与区分「并行」和「平行」类似，我们这里要区分「未定义行为」和「未指定行为」:

- 未定义行为 ([Undefined behavior](https://en.wikipedia.org/wiki/Undefined_behavior)): 程序行为并未在 **语言规范** (在 C 中，自然是 ISO/IEC 9899 一类的规格) 所明确定义规范。缩写为 "UB"。
> undefined behavior (UB) is the result of executing a program whose behavior is prescribed to be unpredictable, in the language specification to which the computer code adheres. 
- 未指定行为 ([Unspecified behavior](https://en.wikipedia.org/wiki/Unspecified_behavior)): 程序行为依赖 **编译器实作和平台特性** 而定。
> unspecified behavior is behavior that may vary on different implementations of a programming language.

## 程序语言不都该详细规范，怎么会有 UB 呢？

编译器最佳化建立在 UB 的基础上，即编译器进行最佳化会忽略 UB，因为 C 语言标准和编译器认为，***未定义行为不能出现在程序中***，并且将这个准则作为前提来实作编译器。所以 C 语言编译器对源代码进行翻译和优化，其输出的机器码的行为应该与 **标准定义的行为** 一致。也就是说编译出来的机器码只保证与标准的定义行为对应，对于未定义行为不保证有对应的机器码。

{{< admonition >}}
类似于 API 的使用，你必须在遵守 API 的限制的前提下使用 API，才能得到预期的结果，如果你不遵循 API 的限定，那么 API 返回的结果不保证符合你的预期 (但这不意味着你只能遵守 API 的限制，你当然可以不遵守，只是后果自负，UB 也类似，没说不行，但是后果自负 :rofl:)。例如一个 API 要求传入的参数必须是非负数，如果你传入了一个负数，那么 API 返回的结果不大可能符合你的预期，因为这个 API 的内部实现可能没考虑负数情形。

从这个角度看，UB 其实就是不遵守语言规范 (等价于 API 的限制) 的行为，编译器对于语言规范的实现一般来说是不考虑 UB 的 (等价于 API 的内部实现)，所以因为 UB 造成的结果需要程序员自行承担 (等价于不遵守限制乱用 API 需要自己承担责任)。所以单纯考虑 UB 是没啥意义的，因为它只是结果的具体表现，应该从语言规范和编译器的角度考虑。

除此之外，因为编译器作为语言规范的实作，它在最佳化时会一般 **只考虑符合语言规范** 的部分，简而言之，编译器可能会将 ***依赖于 UB 部分的代码*** 移除掉 (越激进的优化越有可能)。因为它认为源程序已经是符合语言规范的，所以会移除掉在符合规范情况下显得不必要的逻辑。
{{< /admonition >}}

```c
int func(unsigned char x)
{
    int value = 2147483600; /* assuming 32 bit int */
    value += x;
    if (value < 2147483600)
        bar();
    return value;
}
```

第 4 行可能会导致 signed integer overflow，而 signed integer overflow 在 C 语言是 UB，所以编译器优化时会认为不会发生 signed integer overflow (对应前文的 ***未定义行为不能出现在程序中***)，那么编译器就会第 5 行的条件判断是不可能成立的，进而将其优化掉:

```c
int foo(unsigned char x)
{
    int value = 2147483600;
    value += x;
    return value;
}
```

Java 这类强调安全的语言也会存在 UB (Java 安全的一个方面是它只使用 signed integer)，所以有时候你会在项目中看到类似如下的注释:

```java
/* Do not try to optimize this lines.
 * This is the only way you can do this
 * without undefined behavior
 */
```

## CppCon 2016: Undefined Behavior

- [x] CppCon 2016: Chandler Carruth [Garbage In, Garbage Out: Arguing about Undefined Behavior with Nasal Demons](https://www.youtube.com/watch?v=yG1OZ69H_-o)

```c
int *p = nullptr;
int x = *p;
```

Programming error, like using an API out of contract.

```c
/// \param p must not be null
void f(int *p);

void f(int *p) [[expects: p != nullptr]];
```

Programming errors result in *incorrect programs*. We cannot define the behavior of *incorrect programs*.

{{< center-quote >}}
**UB is a *symptom* of incorrect programs.**
{{< /center-quote >}}

The code used a feature *out of contract*. The feature has a *narrow contract*! It was a *latent* error all this time.

Can we make every language feature have a wide contract? 
- **No.** Instead, evaluate wide vs. narrow contracts case by case.

Ok, can we at least *constrain* UB?
- UB is inherently unconstrained... But this isn't about UB!

Can we define *some* behavior when out of contract?
- Yes.. But what do you define?
- Different users need differemt behaviors.

When is it appropriate to have a narrow contract?
- A narrow contract is a simpler semantic model.
- But this may not match expectations.

**Principles for narrow language contracts:**
1. Checkable (probabilisticallt) at runtime
2. Provide significant value: bug finding, simplification, and/or optimization
3. Easily explained and taught to programmers
4. Not widely violated by existing code that works correctly and as intended

### Examples

Let's examine interesting cases with this framework

```c++
#include <iostream>

int main() {
  volatile unsigned x = 1;
  volatile unsigned y = 33;
  volatile unsigned result = x << y;

  std::cout << "Bad shift: " << result << "\n";
}
```

左移操作 `x << y` 如果 `y >= <bits of x>` 那么这个行为是 UB

```c++
// Allocate a zeroed rtx vector of N elements
//
// sizeof(struct rtvec_def) == 16
// sizeof(rtunion) == 8
rtvec rtvec_alloc(int n) {
  rtvec rt;
  int i;
  rt = (rtvec)obstack_alloc(
      rtl_obstack,
      sizeof(struct rtvec_def) + (n - 1) + sizeof(rtvunion));
  // ...
  return rt;
}
```

这里需要对 API 加一个限制: `n >= 1`

```c++
bool mainGtu(uint32_t i1, uint32_t i2,    # BB#0:
             uint8_t *block) {                    movl %edi, %eax
  uint8_t c1, c2;                                 movb (%rdx,%rax), %al
                                                  movl %esi, %ebp
  /* 1 */                                         movb (%rdx,%rbp), %bl
  c1 = block[i1]; c2 = block[i2];                 cmpb %bl, %al
  if (c1 != c2) return (c1 > c2);                 jne .LBB27_1
  i1++; i2++;                             # BB#2:
                                                  leal 1(%rdi), %eax
  /* 2 */                                         leal 1(%rsi), %ebp
  c1 = block[i1]; c2 = block[i2];                 movb (%rdx,%rax), %al
  if (c1 != c2) return (c1 > c2);                 movb (%rdx,%rbp), %bl
  i1++; i2++;                                     cmpb %bl, %al
                                                  jne .LBB27_1
  ...                                     # ...
}
```

```c++
bool mainGtu(int32_t i1, int32_t i2,      # BB#0:
             uint8_t *block) {                    movzbl (%rdx, %rsi), %eax
  uint8_t c1, c2;                                 cmpb %al, (%rdx,%rdi)
                                                  jne .LBB27_1
  /* 1 */                                         
  c1 = block[i1]; c2 = block[i2];                 
  if (c1 != c2) return (c1 > c2);                 
  i1++; i2++;                             # BB#2:
                                                  movzbl 1(%rdx, %rsi), %eax
  /* 2 */                                         cmpb %al, 1(%rdx,%rdi)
  c1 = block[i1]; c2 = block[i2];                 jne .LBB27_1
  if (c1 != c2) return (c1 > c2);                 
  i1++; i2++;                                     
                                                  
  ...                                     # ...
}
```

这里的底层机制是: unsigned integer 的 overflow 不是 UB，而是等价于对 *UMax* of its size 取模，所以当使用 `uint32_t` 时，编译器需要生成特殊的指令用于保证 `i1` 和 `i2` 的值是这样的序列: $i$, $i+1$, ..., *UMax*, $0$, $1$, ... (这是 wide contract，即对任意的 unsigned integer 加法的行为都有规范并且编译器进行了相应实作)

但是当使用 signed integer 时，因为 signed integer overflow 是 UB，所以编译器只需生成指令用于保证 `i1` 和 `i2` 的值是这样的序列: $i$, $i+1$, $i+2$, ... 所以只需要生成单纯的 add 指令即可，甚至可以进行指针运算 `p + i`，然后递增这个指针值即可。(这是 narrow contract，即使用 signed integer 时编译器不需要关心是否会发生 overflow，因为这是程序员的责任，它对 signed integer 加法的实作不考虑 overflow 的情景)

{{< admonition tip >}}
这个例子再次说明，未定义行为存在的重要目的是，语言标准中的刻意留空，运行更激进最优化的存在。例如规范限制 signed integer 的使用不会出现 overflow，进而编译器以这个前提进行最优化 (类似于 API 的使用限制不能使用负数，那么 API 的实作也不会考虑负数的情形)。***不管是进行最优化还是不进行最优化的编译器，都是对语言规范的一种实现。***
{{< /admonition >}}

```c
#include <iostream>
#include <limits>
#include <stdint.h>

int main() {
  volatile int32_t x = std::numeric_limits<int32_t>::min();
  volatile int32_t y = 7;
  volatile int32_t result = (x >> y);
  std::cout << "Arithmetic shift: " << std::hex << result << "\n";
}
```
Arithmetic shift is **Implementation defined behavior**. (narrow contract)

```c
#include <string.h>

int main() {
  void *volatile src = nullptr;
  void *volatile dst = nullptr;
  volatile size_t size = 0;

  memcpy(dst, src, size);
}
```

The source and destination shall not be nullptr in memcpy. (narrow contract)

---

{{< admonition >}}
现在再回头看下开头的例子，如果我们将第 3 行的 `x` 改为 `unsigned int` 类型，那么编译器就不会将第 5 行的 if 语句优化掉 (因为 unsigned int 的使用是 wide contract 的):

```c
int func(unsigned char x)
{
    unsigned int value = 2147483600; /* assuming 32 bit */
    value += x;
    if (value < 2147483600)
        bar();
    return value;
}
```
{{< /admonition >}}

## Undefined Behavior and Compiler Optimizations

Kugan Vivekanandarajah 和 Yvan Roux 探讨 UB 和编译器最佳化的演讲:
- [x] [BKK16-503 Undefined Behavior and Compiler Optimizations – Why Your Program Stopped Working With A Newer Compiler](https://www.slideshare.net/linaroorg/bkk16503-undefined-behavior-and-compiler-optimizations-why-your-program-stopped-working-with-a-newer-compiler) / [演讲录影](https://youtu.be/wZT20kR2AzY)

{{< image src="https://image.slidesharecdn.com/bkk16503-160212222433/75/BKK16-503-Undefined-Behavior-and-Compiler-Optimizations-Why-Your-Program-Stopped-Working-With-A-Newer-Compiler-4-2048.jpg" >}}

{{< image src="https://image.slidesharecdn.com/bkk16503-160212222433/75/BKK16-503-Undefined-Behavior-and-Compiler-Optimizations-Why-Your-Program-Stopped-Working-With-A-Newer-Compiler-5-2048.jpg" >}}

- [gcc PR53073](https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53073)
> compiles 464.h264ref in SPEC CPU 2006 into infinite loop.

- C99 6.5.2.1 Array subscripting
> A postfix expression followed by an expression in square brackets `[]` is a subscripted designation of an element of an array object. The definition of the subscript operator `[]` is that `E1[E2]` is identical to `(*((E1)+(E2)))`. 

- C99 6.5.6 Additive operators (8) 
> If both the pointer operand and the result point to elements of the same array object, or one past the last element of the array object, the evaluation shall not produce an overflow; otherwise, the behavior is undefined. If the result points one past the last element of the array object, it shall not be used as the operand of a unary * operator that is evaluated.


{{< admonition >}}
这个投影片很厉害，原文后面介绍的 UB 的几种类型都是启发自这里。所以我打算将这个投影片的相关部分穿插在后面对应的部分。
{{< /admonition >}}

{{< image src="https://image.slidesharecdn.com/bkk16503-160212222433/75/BKK16-503-Undefined-Behavior-and-Compiler-Optimizations-Why-Your-Program-Stopped-Working-With-A-Newer-Compiler-10-2048.jpg" >}}

{{< image src="https://image.slidesharecdn.com/bkk16503-160212222433/75/BKK16-503-Undefined-Behavior-and-Compiler-Optimizations-Why-Your-Program-Stopped-Working-With-A-Newer-Compiler-27-2048.jpg" >}}

## 侦测 Undefined Behavior

{{< image src="https://image.slidesharecdn.com/bkk16503-160212222433/75/BKK16-503-Undefined-Behavior-and-Compiler-Optimizations-Why-Your-Program-Stopped-Working-With-A-Newer-Compiler-12-2048.jpg" >}}

- Clang: [UndefinedBehaviorSanitizer](https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html)
- Linux 核心也引入 [The Undefined Behavior Sanitizer - UBSAN](https://people.freedesktop.org/~narmstrong/meson_drm_doc/dev-tools/ubsan.html)

## Undefined Behavior 的几种类型

{{< image src="https://image.slidesharecdn.com/bkk16503-160212222433/75/BKK16-503-Undefined-Behavior-and-Compiler-Optimizations-Why-Your-Program-Stopped-Working-With-A-Newer-Compiler-11-2048.jpg" >}}

- [Aliased pointers](https://en.wikipedia.org/wiki/Aliasing_(computing)#Aliased_pointers)
> Another variety of aliasing can occur in any language that can refer to one location in memory with more than one name (for example, with pointers). 

### Signed integer overflow

{{< image src="https://image.slidesharecdn.com/bkk16503-160212222433/75/BKK16-503-Undefined-Behavior-and-Compiler-Optimizations-Why-Your-Program-Stopped-Working-With-A-Newer-Compiler-14-2048.jpg" >}}

{{< image src="https://image.slidesharecdn.com/bkk16503-160212222433/75/BKK16-503-Undefined-Behavior-and-Compiler-Optimizations-Why-Your-Program-Stopped-Working-With-A-Newer-Compiler-15-2048.jpg" >}}

gcc 使用编译选项 `-fno-strict-overflow` 和 `-fwrapv` 可以在最佳化时阻止这样的行为。

- [gcc PR34075](https://gcc.gnu.org/bugzilla/show_bug.cgi?id=30475)

{{< image src="https://image.slidesharecdn.com/bkk16503-160212222433/75/BKK16-503-Undefined-Behavior-and-Compiler-Optimizations-Why-Your-Program-Stopped-Working-With-A-Newer-Compiler-16-2048.jpg" >}}

- [x] LWN [GCC and pointer overflows](https://lwn.net/Articles/278137/)

> This behavior is allowed by the C standard, which states that, in a correct program, pointer addition will not yield a pointer value outside of the same object. 

> That kind of optimization often must assume that programs are written correctly; otherwise the compiler is unable to remove code which, in a correctly-written (standard-compliant) program, is unnecessary. 

### Shifting an n-bit integer by n or more bits

{{< image src="https://image.slidesharecdn.com/bkk16503-160212222433/75/BKK16-503-Undefined-Behavior-and-Compiler-Optimizations-Why-Your-Program-Stopped-Working-With-A-Newer-Compiler-18-2048.jpg" >}}

- gcc [PR48418](https://gcc.gnu.org/bugzilla/show_bug.cgi?id=48418)
> This invokes undefined behavior, any result is acceptable.

Note that what exactly is considered undefined differs slightly between C and C++, as well as between ISO C90 and C99. Generally, the right operand must not be negative and must not be greater than or equal to the width of the (promoted) left operand. An example of invalid shift operation is the following:

### Divide by zero

{{< image src="https://image.slidesharecdn.com/bkk16503-160212222433/75/BKK16-503-Undefined-Behavior-and-Compiler-Optimizations-Why-Your-Program-Stopped-Working-With-A-Newer-Compiler-21-2048.jpg" >}}

- gcc [PR29968](https://gcc.gnu.org/bugzilla/show_bug.cgi?id=29968)

### Dereferencing a NULL pointer

{{< image src="https://image.slidesharecdn.com/bkk16503-160212222433/75/BKK16-503-Undefined-Behavior-and-Compiler-Optimizations-Why-Your-Program-Stopped-Working-With-A-Newer-Compiler-24-2048.jpg" >}}

- [x] LWN [Fun with NULL pointers](https://lwn.net/Articles/342330/)

> There is one little problem with that reasoning, though: NULL (zero) can actually be a valid pointer address. By default, the very bottom of the virtual address space (the "zero page," along with a few pages above it) is set to disallow all access as a way of catching null-pointer bugs (like the one described above) in both user and kernel space. But it is possible, using the mmap() system call, to put real memory at the bottom of the virtual address space. 

> This is where the next interesting step in the chain of failures happens: the GCC compiler will, by default, optimize the NULL test out. The reasoning is that, since the pointer has already been dereferenced (and has not been changed), it cannot be NULL. So there is no point in checking it. Once again, this logic makes sense most of the time, but not in situations where NULL might actually be a valid pointer.

> A NULL pointer was dereferenced before being checked, the check was optimized out by the compiler

- gcc [PR68853](https://gcc.gnu.org/bugzilla/show_bug.cgi?id=68853)
- Wikidepia: [Linux kernel oops](https://en.wikipedia.org/wiki/Linux_kernel_oops) 
{{< image src="https://upload.wikimedia.org/wikipedia/commons/6/6a/Linux-2.6-oops-parisc.jpg" >}}

### Pointer arithmetic that wraps

{{< image src="https://image.slidesharecdn.com/bkk16503-160212222433/75/BKK16-503-Undefined-Behavior-and-Compiler-Optimizations-Why-Your-Program-Stopped-Working-With-A-Newer-Compiler-23-2048.jpg" >}}

- gcc [PR54365](https://gcc.gnu.org/bugzilla/show_bug.cgi?id=54365)

### Reading an uninitialized variable

{{< image src="https://image.slidesharecdn.com/bkk16503-160212222433/75/BKK16-503-Undefined-Behavior-and-Compiler-Optimizations-Why-Your-Program-Stopped-Working-With-A-Newer-Compiler-26-2048.jpg" >}}

```c
#include <stdio.h>

int main() {
    int x;
    int y = x + 10;
    printf("%d %d\n", x, y);

    return 0;
}
```

## 延伸阅读

LLVM 之父撰写的系列文章: **What Every C Programmer Should Know About Undefined Behavior**
- [ ] [Part 1](http://blog.llvm.org/2011/05/what-every-c-programmer-should-know.html)
- [ ] [Part 2](http://blog.llvm.org/2011/05/what-every-c-programmer-should-know_14.html)
- [ ] [Part 3](http://blog.llvm.org/2011/05/what-every-c-programmer-should-know_21.html)

{{< admonition info >}}
- [ ] [Undefined Behavior in 2017](https://blog.regehr.org/archives/1520)
- [ ] [Why undefined behavior may call a never-called function](https://kristerw.blogspot.com/2017/09/why-undefined-behavior-may-call-never.html)
{{< /admonition >}}
