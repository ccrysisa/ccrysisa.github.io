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

编译器最佳化建立在 UB 的基础上，即编译器进行最佳化会忽略 UB，因为 C 语言标准和编译器认为，***未定义行为不能出现在程序中***，并且将这个准则作为前提来实作编译器。所以 C 语言编译器对源代码进行翻译和优化，其输出的机器码的行为应该与 **标准定义的行为** 一致。也就是说编译出来的机器码只保证与标准的定义行为对应，对于未定义行为不保证有对应的机器码 (事实上大部分的 UB 都被编译器优化掉了)。

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

## CppCon 2016: Undefined Behavior

- [ ] CppCon 2016: Chandler Carruth [Garbage In, Garbage Out: Arguing about Undefined Behavior with Nasal Demons](https://www.youtube.com/watch?v=yG1OZ69H_-o)

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

**Let's examine interesting cases with this framework**

```c++
#include <iostream>

int main() {
  volatile unsigned x = 1;
  volatile unsigned y = 33;
  volatile unsigned result = x << y;

  std::cout << "Bad shift: " << result << "\n";
}
```

```c++
// Allocate a zeroed rtx vector of N elements
//
// sizeof(struct rtvec_def) == 16
// sizeof(rtunion) == 8
rtvec rtvec_alloc(int a) {
  rtvec rt;
  int i;
  rt = (rtvec)obstack_alloc(
      rtl_obstack,
      sizeof(struct rtvec_def) + (n - 1) + sizeof(rtvunion));
  // ...
  return rt;
}
```
