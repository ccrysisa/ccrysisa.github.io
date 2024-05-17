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

#### What is Ownership?

> Rust uses a third approach: memory is managed through a system of ownership with a set of rules that the **compiler checks**. If any of the rules are violated, the program won\'t **compile**. None of the features of ownership will slow down your program while it\'s running.

> By the same token, a processor can do its job better if it works on data that’s close to other data (as it is on the stack) rather than farther away (as it can be on the heap).

这主要是因为 cache 机制带来的效能提升

> Keeping track of what parts of code are using what data on the heap, minimizing the amount of duplicate data on the heap, and cleaning up unused data on the heap so you don’t run out of space are all problems that ownership addresses.

从上面的描述可以看出，所有权 (ownership) 机制主要针对的是 heap 空间的管理，所以下面的 3 条规则也是针对 heap 空间上的数据:

- Each value in Rust has an owner.
- There can only be one owner at a time.
- When the owner goes out of scope, the value will be dropped.

> Rust takes a different path: the memory is automatically returned once the variable that owns it goes out of scope. 

也就是说，Rust 使用类似与 stack 的方式来管理 heap 空间，因为 stack 上的数在超过作用于就会自动消亡 (通过 `sp` 寄存器进行出栈操作)。Rust 对于 heap 的管理也类似，在出栈同时还回收 heap 对应的空间，这是合理的，因为 heap 上的数据都会直接/简接地被 stack 上的数据所引用，例如指针。

函数参数也类似，因为从函数调用 ABI 角度来看，赋值和函数调用时参数、返回的处理都是相同的，即在 stack 空间进行入栈操作。

> We do not copy the data on the heap that the pointer refers to.

也就是说通常情况下 移动 (Move) 只对 heap 上的数据起作用，对于 stack 上的数据，体现的是 拷贝 (Copy) 操作，当然这也不绝对，可以通过实现 `Copy` 这个 trait 来对 heap 的数据也进行拷贝操作。Rust 对于 stack 和 heap 上都有数据的 object (例如 String) 的赋值处理默认是: 拷贝 stack 上的数据，新的 stack 数据仍然指向同一个 heap 的数据，同时将原先 stack 数据所在的内存无效化。

>  This is known as a double free error and is one of the memory safety bugs we mentioned previously. Freeing memory twice can lead to memory corruption, which can potentially lead to security vulnerabilities.

> To ensure memory safety, after the line `let s2 = s1;`, Rust considers `s1` as no longer valid. Therefore, Rust doesn’t need to free anything when `s1` goes out of scope.

> In addition, there’s a design choice that’s implied by this: Rust will never automatically create “deep” copies of your data. Therefore, any automatic copying can be assumed to be inexpensive in terms of runtime performance.

移动 (Move) 操作解决了 double free 这个安全隐患，让 Rust 在内存安全的领域占据了一席之地。除此之外，Move 操作使得自动赋值的开销变得低廉，因为使用的是 Move 移动操作，而不是 Copy 拷贝操作。

> Rust won’t let us annotate a type with Copy if the type, or any of its parts, has implemented the Drop trait. If the type needs something special to happen when the value goes out of scope and we add the Copy annotation to that type, we’ll get a compile-time error. 

#### References and Borrowing

从内存角度来看，reference 常用的场景为:
```
Reference            Owner
+-------+      +----------------+
| stack |  --> | stack --> Heap |
+-------+      +----------------+
```

> Mutable references have one big restriction: if you have a mutable reference to a value, you can have no other references to that value.

>  The benefit of having this restriction is that Rust can prevent data races at compile time. A data race is similar to a race condition and happens when these three behaviors occur:
> - Two or more pointers access the same data at the same time.
> - At least one of the pointers is being used to write to the data.
> - There’s no mechanism being used to synchronize access to the data.

> We also cannot have a mutable reference while we have an immutable one to the same value.

编译时期即可防止数据竞争，同时允许了编译器进行激进的最佳化策略 (因为保证没有非预期的数据竞争发生)。

> In Rust, by contrast, the compiler guarantees that references will never be dangling references: if you have a reference to some data, the compiler will ensure that the data will not go out of scope before the reference to the data does.

编译器保证了我们使用引用时的正确性，同时这也是后面标注生命周期 (lifetime) 的机制基础。

- At any given time, you can have either one mutable reference or any number of immutable references.
- References must always be valid.

#### The Slice Type

> Slices let you reference a contiguous sequence of elements in a collection rather than the whole collection. **A slice is a kind of reference, so it does not have ownership.**

切片 (slice) 也是一种引用 (references) 类型，所以它也遵守上一节提到的规则:
> if you have a reference to some data, the compiler will ensure that the data will not go out of scope before the reference to the data does.

对于类型为 `String` 的变量 `s`，它的一些 slice 需要注意，`&s[..]` 和 `&s[0..s.len()]` 是等价的，但是这两个和 `&s` 是不一样的，我们可以从内存角度获得启发:
```
&s -> s -> str
&s[..] -> str
```

> String slice range indices must occur at valid UTF-8 character boundaries. If you attempt to create a string slice in the middle of a multibyte character, your program will exit with an error.

> If we have a string slice, we can pass that directly. If we have a String, we can pass a slice of the String or a reference to the String. This flexibility takes advantage of deref coercions

> Defining a function to take a string slice instead of a reference to a String makes our API more general and useful without losing any functionality

{{< admonition >}}
将 `&String` 类型的参数转换成 `&str` 类型从实作的角度来看，应该是由编译器负责的，原理大致是语法分析时，依据函数调用时传入的参数是 `&String` 还是 `&str` 类型，为了让代码生成器生成一样的指令对参数进行入栈操作 (本质都是将 `&str` 类型入栈)，所以语法分析器需要对 `&String` 进行一些额外的操作，让其转换成 `&str` 类型 (这部分由编译器帮我们做了，无需程序员进行手工转换)，当然程序员也可以手工进行转换成切片 `&s[..]` (编译器也是在做这件事情罢了)。
{{< /admonition >}}

Documentation:
- method std::string::String::[as_bytes](https://doc.rust-lang.org/std/string/struct.String.html#method.as_bytes)
- method std::iter::Iterator::[enumerate](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.enumerate)
- Module std::[iter](https://doc.rust-lang.org/std/iter/index.html)

### Using Structs to Structure Related Data

Rust 不允许结构体初始化时只指定一部分字段的值，这防止了 UB 相关问题的触发。

- 5.1. Defining and Instantiating Structs

> Note that the entire instance must be mutable; Rust doesn’t allow us to mark only certain fields as mutable.

>  Tuple structs are useful when you want to give the whole tuple a name and make the tuple a different type from other tuples, and when naming each field as in a regular struct would be verbose or redundant.

> Unit-like structs can be useful when you need to implement a trait on some type but don’t have any data that you want to store in the type itself.

{{< admonition >}}
Rust 中 struct 默认是进行移动 (Move) 操作，而 tuple 默认是进行拷贝 (Copy) 操作。这是因为 struct 一般使用时都会引用 heap 中的数据 (例如 `String`)，而依据移动 (Move) 操作的语义，进行自动赋值时会拷贝 stack 上的数据并且执行同一 heap 的数据，但是原先 stack 的数据会无效化防止发生 double free。依据这个语义，就不难理解为何 Rust 中的结构体位于 stack 时也不会进行拷贝 (Copy) 操作而是进行移动 (Move) 操作了，因为需要根据常用场景对语义进行 trade-off，即使 struct 没有引用 heap 的数据，为了保障常用场景的效能，还是将这类结构体设计成 Move 操作，即会导致原先的结构体无效化。tuple 也同理，其常用场景为 stack 上的复合数据，所以默认为 Copy 操作。
{{< /admonition >}}

## Visualizing memory layout of Rust\'s data types

YouTube: [Visualizing memory layout of Rust\'s data types](https://www.youtube.com/watch?v=7_o-YRxf_cc&t=0s) 

影片的中文翻译：

- [可视化 Rust 各数据结构的内存布局](https://www.bilibili.com/video/BV1KT4y167f1) [bilibili]

可搭配阅读相关的文档：

- [[2022-05-04] 可视化 Rust 各数据类型的内存布局](https://github.com/rustlang-cn/Rustt/blob/main/Articles/%5B2022-05-04%5D%20%E5%8F%AF%E8%A7%86%E5%8C%96%20Rust%20%E5%90%84%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B%E7%9A%84%E5%86%85%E5%AD%98%E5%B8%83%E5%B1%80.md)

[rust-in-100s]: https://youtu.be/5C_HPTJg5ek
[2022-review-the-adoption-of-rust-in-business]: https://rustmagazine.org/issue-1/2022-review-the-adoption-of-rust-in-business/