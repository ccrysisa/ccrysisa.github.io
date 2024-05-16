---
title: "Why Rust?"
subtitle:
date: 2023-12-28T20:18:03+08:00
draft: false
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
  - Sysprog
categories:
  - Linux Kernel Internals
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
math: false
lightgallery: false
password:
message:
repost:
  enable: true
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

## Rust in 100 Seconds

观看短片: [Rust in 100 Seconds][rust-in-100s] :white_check_mark:
- [x] 了解 Rust，初步了解其安全性原理
- [x] 所有权 (ownership)
- [x] 借用 (borrow) 

{{< admonition warning >}}
0:55 This is wrong, value mutability doesn't have anything to do with the value being stored on the stack or the heap (and the example `let mut hello = "hi mom"` will be stored on the stack since it's type is `&'static str`), it depends on the type of the value (if it's `Sized` or not).
{{< /admonition >}}

## The adoption of Rust in Business (2022)

阅读报告: [The adoption of Rust in Business (2022)][2022-review-the-adoption-of-rust-in-business] :white_check_mark:

Rust 目前蓬勃发展，预测未来是很难的，但是 Rust 已经是进行时的未来了 :rofl:

## The Rust Programming Language

### Getting Started

```bash
# 创建包
$ cargo new <package>
# 编译、构建、调试版本
$ cargo build
# 编译优化、发布版本
$ cargo build --release
# 编译、运行
$ cargo run
# 静态分析检查
$ cargo check
# 清除构建出来的目标文件
$ cargo clean
```

### Programming a Guessing Game

- Module std::[io](https://doc.rust-lang.org/std/io/index.html)
- Module std::[cmp](https://doc.rust-lang.org/std/cmp/index.html)
- Crate [rand](https://docs.rs/rand/latest/rand/)

### Common Programming Concepts

变量明确区分可变和不可变，好处在于对于明确不可变的变量，使用引用时编译器可以进行更为激进的最佳化。常量必须满足可以在编译期计算出结果。

shadow 可理解为变量名可以和储存数据的地址绑定、解绑，所以可以进行变量遮蔽。而 C 语言中的变量名一旦使用就和储存数据的地址绑死了，自然无法进行遮蔽。

- 3.2. Data Types
> When you’re compiling in release mode with the `--release` flag, Rust does not include checks for integer overflow that cause panics. Instead, if overflow occurs, Rust performs two’s complement wrapping. In short, values greater than the maximum value the type can hold “wrap around” to the minimum of the values the type can hold. In the case of a u8, the value 256 becomes 0, the value 257 becomes 1, and so on. The program won’t panic, but the variable will have a value that probably isn’t what you were expecting it to have. Relying on integer overflow’s wrapping behavior is considered an error.

即当使用 `--release` 编译参数时，编译器不会将 integer overflow 视为 UB

模式匹配的语法主要是为了方便编辑器的实现，因为 `(x, y, z) = tup` 这样的词法、语法分析显然比 Python 风格的 `x, y, z = tup` 分析难度低。

- 3.2. Data Types
> Let’s see what happens if you try to access an element of an array that is past the end of the array.
> This code compiles successfully. 
> The program resulted in a runtime error at the point of using an invalid value in the indexing operation. 

数组元素的非法访问并不会导致编译失败，而是编译时期会在访问元素的附近加上检查有效的语句，如果运行时访问了非法的元素范围，会触发这个检测从而导致 `panic`。

- 3.3. Functions
> Rust code uses snake case as the conventional style for function and variable names, in which all letters are lowercase and underscores separate words.

函数的参数类型必须指明，这可以方便编译器对根据函数定义对函数调用进行检查，是否符合要求，另一方面还可以让编译器生成恰当的指令用于跳转进函数执行 (编译器可能需要在栈上给函数传入的参数分配空间，例如 x86 架构的机器的 ABI 就是这么规定的)。

- 3.3. Functions
> **Statements** are instructions that perform some action and do not return a value.   
> **Expressions** evaluate to a resultant value. Let’s look at some examples.

> A new scope block created with curly brackets is an expression

从这个角度看，Rust 中的函数体也是表达式 (因为用 `{}` 包裹起来)，然后将函数的返回值视为表达式的结果值。好像也没毛病，毕竟 Rust 中所有函数都有返回值，没写返回值的默认为返回 `()`，表达式也类似，最后一条不是表达式的会补充一个 `()` 作为该表达式的结果。Rust 中很多语法都是表达式，例如 `if`, `match` 都是表达式，而在其他语言中一般是语句 (statement)，难怪有:
> Rust is an expression-based language

- 3.3. Functions
> You can return early from a function by using the `return` keyword and specifying a value, but most functions return the last expression implicitly. 

函数体的最后一个表达式视为返回值，这在编译器实作角度并不难，只需要在语法分析时加入这个逻辑即可，除此之外的返回语法，需要使用关键字 `return` 从编译器语法分析角度看来也很当然 (因为返回操作需要生成相对应的指令，所以需要指示当前是返回操作，通过最后一条表达式暗示或 `return` 关键字指示)。

- 3.5. Control Flow
> You might also need to pass the result of that operation out of the loop to the rest of your code. To do this, you can add the value you want returned after the `break` expression you use to stop the loop; that value will be returned out of the loop so you can use it

> `Range`, provided by the standard library, which generates all numbers in sequence starting from one number and ending before another number.
> `rev`, to reverse the range.

### Understanding Ownership

- 4.1. What is Ownership?
> Rust uses a third approach: memory is managed through a system of ownership with a set of rules that the **compiler checks**. If any of the rules are violated, the program won\'t **compile**. None of the features of ownership will slow down your program while it\'s running.

- 4.1. What is Ownership?
> By the same token, a processor can do its job better if it works on data that’s close to other data (as it is on the stack) rather than farther away (as it can be on the heap).

这主要是因为 cache 机制带来的效能提升

- 4.1. What is Ownership?
> Keeping track of what parts of code are using what data on the heap, minimizing the amount of duplicate data on the heap, and cleaning up unused data on the heap so you don’t run out of space are all problems that ownership addresses.

从上面的描述可以看出，所有权 (ownership) 机制主要针对的是 heap 空间的管理，所以下面的 3 条规则也是针对 heap 空间上的数据:

- Each value in Rust has an owner.
- There can only be one owner at a time.
- When the owner goes out of scope, the value will be dropped.

- 4.1. What is Ownership?
> Rust takes a different path: the memory is automatically returned once the variable that owns it goes out of scope. 

也就是说，Rust 使用类似与 stack 的方式来管理 heap 空间，因为 stack 上的数在超过作用于就会自动消亡 (通过 `sp` 寄存器进行出栈操作)。Rust 对于 heap 的管理也类似，在出栈同时还回收 heap 对应的空间。

## Visualizing memory layout of Rust\'s data types

YouTube: [Visualizing memory layout of Rust's data types](https://www.youtube.com/watch?v=7_o-YRxf_cc&t=0s) 

影片的中文翻译：

- [可视化 Rust 各数据结构的内存布局](https://www.bilibili.com/video/BV1KT4y167f1) [bilibili]

可搭配阅读相关的文档：

- [[2022-05-04] 可视化 Rust 各数据类型的内存布局](https://github.com/rustlang-cn/Rustt/blob/main/Articles/%5B2022-05-04%5D%20%E5%8F%AF%E8%A7%86%E5%8C%96%20Rust%20%E5%90%84%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B%E7%9A%84%E5%86%85%E5%AD%98%E5%B8%83%E5%B1%80.md)

[rust-in-100s]: https://youtu.be/5C_HPTJg5ek
[2022-review-the-adoption-of-rust-in-business]: https://rustmagazine.org/issue-1/2022-review-the-adoption-of-rust-in-business/