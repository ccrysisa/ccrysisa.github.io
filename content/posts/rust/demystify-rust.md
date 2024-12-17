---
title: "Tutorial: Rust Language Demystified"
subtitle:
date: 2024-04-05T17:52:13+08:00
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
  - Rust
categories:
  - Rust
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

{{< image src="/images/rust/rust.png" caption="Crustacean" >}}

<!--more-->

## 基础入门

### 变量绑定与解构

使用变量绑定而不是变量赋值对于 Rust 所有权诠释的非常准确，下面这段话学完所有权后再看有不一样的体会:

{{< admonition quote >}}
为何不用赋值而用绑定呢（其实你也可以称之为赋值，但是绑定的含义更清晰准确）？这里就涉及 Rust 最核心的原则——所有权，简单来讲，任何内存对象都是有主人的，而且一般情况下完全属于它的主人，绑定就是把这个对象绑定给一个变量，让这个变量成为它的主人（聪明的读者应该能猜到，在这种情况下，该对象之前的主人就会丧失对该对象的所有权），像极了我们的现实世界，不是吗？
{{< /admonition >}}

变量作用域本质上是栈帧，所以可以实现类似函数调用的变量遮蔽。但与栈帧有一点不同，它可以访问作用域外面的数据，而栈帧则不行。这是因为每一次函数调用的上文可能不同（调用者不同导致上文不同），所以不能安全地访问栈帧外的数据，而变量作用域的上文是固定的（变量作用域常出现于函数内部，即作用域之前的语句都是固定的），所以可以安全地访问作用域外部数据（这一点倒是和全局变量类似，毕竟对于函数调用来说全局变量是可以确定的上文）。当然变量遮蔽会导致无法访问作用域外部的同名变量。

### 基本类型

在 Rust 使用浮点数 (f32, f64, Nan) 时，受制于浮点数的精度，应当避免对浮点数进行等价性比较。Rust 并没有像 C 语言一样，位运算的取反操作和逻辑运算的否操作采用不同的运算符，而是统一采用 `!` 运算符来表示。Rust 将 C 语言中返回类型为 `void` 的函数细化为两种，一种是返回值无意义的函数，返回类型（和值）为 `()`，并且不占用内存（这个类型在编译时期就处理完毕了，所以不涉及内存占用,它本质上就是个 0 长度的元组，根据排列组合也只有一个值）；另一种是永不返回的函数，称为发散函数，常用于函数体为无限循环的场景（例如嵌入式系统的主函数），返回类型为 `!`。发散函数不会返回任何值，可以用于替代需要任何返回任何值的地方，所以它的一大作用是在 `match` 表达式中用于替代任何类型的值，极大方便了 `panic` 宏的使用。

Rust 的语句 (statement) 和表达式 (expression) 与 Python 划分类似，毕竟都支持函数式编程风格。语句会执行一些操作但是不会返回一个值（但可能会有副作用），而表达式总是会在求值后返回一个值，同时表达式可以成为语句的一部分。Rust 的函数本质上也是表达式（与函数式编程风格兼容），准确来说是有参数签注的 `{}` 表达式（其它使用 `{}` 表达式的语句也是表达式，例如 `if` 表达式, `for` 表达式，这一点与 C 语言不同，C 语言对应的应该是 `()` 表达式），但可能会有副作用（与 C 语言风格兼容），相比于 C 语言，Rust 赋予 `()` 类型比 C 的 `void` 更强大的表达能力。**TLDR: 有分号可以认为是语句，其他都是表达式。**

```rs
x + y           // expression
let x = 1 + 2;  // statement
let a = x + y;          // compile pass
let a = let x = 1 + 2;; // compile error
```

{{< image src="https://pic2.zhimg.com/80/v2-54b3a6d435d2482243edc4be9ab98153_1440w.png" >}}

Rust 的函数名和变量名采用蛇形命名法 (snake case)，例如 `fn add_two(x: i32, y: i32) -> i32`。

## References

- [Rust 语言圣经 (Rust Course)](https://course.rs/)
- Cliffle: [Learn Rust the Dangerous Way](https://cliffle.com/p/dangerust/)
- [The Rustonomicon](https://doc.rust-lang.org/nomicon/)
- [CodeCrafters](https://app.codecrafters.io/)
