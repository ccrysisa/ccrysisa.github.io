---
title: "你所不知道的 C 语言: 指针篇"
subtitle:
date: 2024-01-14T22:41:38+08:00
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

{{< admonition quote >}}
*「指针」 扮演 「记忆体」 和 「物件」 之间的桥梁*
{{< /admonition >}}

<!--more-->

> {{< link href="https://hackmd.io/@sysprog/c-pointer" content="原文地址" external-icon=true >}}   
> {{< link href="https://youtu.be/G7vERppua9o" content="直播录影(上)" external-icon=true >}}   
> {{< link href="https://youtu.be/Owxols1RTAg" content="直播录影(下)" external-icon=true >}}   

## 前言杂谈

[Let’s learn programming by inventing it](https://www.youtube.com/watch?v=l5Mp_DEn4bs) [CppCon 2018] :white_check_mark:

{{< admonition open=false >}}
在 K&R 一书中，直到 93 页才开始谈论 pointer，而全书总计 185 页，所以大概是在全书 $50.27\\%$ 的位置才开始讲 pointer。所以即使不学 pointer，你还是能够掌握 $~50\\%$ 的 C 语言的内容，但是 C 语言的核心正是 pointer，所以 Good Luck :rofl:
{{< /admonition >}}

[godbolt](http://gcc.godbolt.org/) 可以直接在网页上看到，源代码由各类 compiler 生成的 Assembly Code


[How to read this prototype?]() [Stack Overflow] :white_check_mark:

{{< admonition open=false >}}
这个问题是关于 `signal` 系统调用的函数原型解读，里面的回答页给出了很多对于指针，特别是 *函数指针* 的说明，下面节选一些特别有意思的回答：

> The whole thing declares a function called `signal`:
>
> - `signal` takes an int and a function pointer
>   - this function pointer takes an `int` and returns `void`
> - `signal` returns a function pointer
>   - `this function pointer takes an `int` and returns a `void`
>
> That's where the last int comes in.
>
> ---
>
> You can use [the spiral rule](https://c-faq.com/decl/spiral.anderson.html) to make sense of such declarations, or the program `cdecl(1)`.

这里面提到了 [the spiral rule](https://c-faq.com/decl/spiral.anderson.html) 这是一个用于解析 C 语言中声明 (declaration) 的方法；另外还提到了 `cdecl` 这一程序，它也有类似的作用，可以使用英文进行声明或者解释。

---

> Find the leftmost identifier and work your way out, remembering that `[]` and `()` bind before `*`; IOW, `*a[]` is an array of pointers, `(*a)[]` is a pointer to an array, `*f()` is a function returning a pointer, and `(*f)()` is a pointer to a function. Thus,
> 
> ```c
> void ( *signal(int sig, void (*handler)(int)) ) (int);
> ```
> 
> breaks down as
> 
> ```c
>         signal                                          -- signal
>         signal(                               )         -- is a function
>         signal(    sig                        )         -- with a parameter named sig
>         signal(int sig,                       )         --   of type int
>         signal(int sig,        handler        )         -- and a parameter named handler
>         signal(int sig,       *handler        )         --   which is a pointer
>         signal(int sig,      (*handler)(   )) )         --   to a function
>         signal(int sig,      (*handler)(int)) )         --   taking an int parameter
>         signal(int sig, void (*handler)(int)) )         --   and returning void
>        *signal(int sig, void (*handler)(int)) )         -- returning a pointer
>      ( *signal(int sig, void (*handler)(int)) )(   )    -- to a function
>      ( *signal(int sig, void (*handler)(int)) )(int)    --   taking an int parameter
> void ( *signal(int sig, void (*handler)(int)) )(int);   --   and returning void
> ```

这一回答强调了 `*` 和 `[]`、`()` 优先级的关系，这在判断数组指针、函数指针时是个非常好用的技巧。

{{< /admonition >}}

Rob Pike 于 2009/10/30 的 [Golang Talk](https://talks.golang.org/2009/go_talk-20091030.pdf) [PDF]

David Brailsford 教授解说影片 [Essentials: Pointer Power! - Computerphile](https://www.youtube.com/watch?v=t5NszbIerYc) [YouTube]

## 阅读 C 语言规格书

一手资料的重要性毋庸置疑，对于 C 语言中的核心概念 ***指针***，借助官方规格书清晰概念是非常重要的。

C99 [6.2.5] ***Types***

> Array, function, and pointer types are collectively called derived declarator types. A declarator type derivation from a type T is the construction of a derived declarator type from T by the application of an array-type, a function-type, or a pointer-type derivation to T.

*derived declarator types*  表示衍生的声明类型，因为 array, function, pointer 本质都是地址，所以可以使用这些所谓的 *derived declarator types* 来提前声明 object，表示在某个地址会存储一个 object，这也是为什么这些类型被规格书定义为 *derived declarator types*。

- **lvalue**: Location value
- **rvalue**: Read value

{{< admonition danger >}}
C 语言里只有 ***call by value***
{{< /admonition >}}

## void & void *

C89 之前，函数如果没有标注返回类型，则默认返回类型 `int`，返回值 0。但由于这样既可以表示返回值不重要，也可以表示返回值为 0，这会造成歧义，所以引进了 `void`。

`void *` 只能表示地址，而不能对所指向的地址区域的内容进行操作。因为通过 `void *` 无法知道所指向区域的 size，所以无法对区域的内容进行操作，必须对 `void *` 进行 ***显示转换*** 才能操作指向的内容。（除此之外，对于指针本身的操作，`void *` 与 `char *` 是等价的）

**Alignment** 原文描述不是很清晰，`2-byte aligned` 图示如下：

![](/images/c/2-byte-aligned.svg)

如果是 2-byte aligned 且是 little-endian 的处理器，对于左边，可以直接使用 `*(uint16_t *) ptr`，但对于右边就无法这样（不符合 alignment）：

```c
/* may receive wrong value if ptr is not 2-byte aligned */
uint16_t value = *(uint16_t *) ptr;
/* portable way of reading a little-endian value */
uint16_t value = *(uint8_t *) ptr | ((*(uint8_t *) (ptr + 1)) << 8);
```

因为内存寻址的最小粒度是 Byte，所以使用 `(uint_8 *)` 不需要担心 alignment 的问题。原文并没有给出 32-bit aligned 的 portable way，我们来写一下：

```c
/* may receive wrong value if ptr is not 2-byte aligned */
uint32_t value = *(uint32_t *) ptr;
/* portable way of reading a little-endian value */
uint32_t value = *(uint8_t *) ptr 
                 | ((*(uint8_t *) (ptr + 1)) << 8) 
                 | ((*(uint8_t *) (ptr + 2)) << 16) 
                 | ((*(uint8_t *) (ptr + 3)) << 24);
```

{{< admonition info >}}
- [ ] [The Lost Art of Structure Packing](http://www.catb.org/esr/structure-packing/)
{{< /admonition >}}
