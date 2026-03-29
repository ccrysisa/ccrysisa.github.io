---
title: "Rust Demystified"
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

**A language empowering everyone to build reliable and efficient software.**

<!--more-->

## 基础入门

### 变量绑定与解构

使用变量绑定而不是变量赋值对于 Rust 所有权诠释的非常准确，下面这段话学完所有权后再看有不一样的体会:

{{< admonition quote >}}
为何不用赋值而用绑定呢（其实你也可以称之为赋值，但是绑定的含义更清晰准确）？这里就涉及 Rust 最核心的原则——所有权，简单来讲，任何内存对象都是有主人的，而且一般情况下完全属于它的主人，绑定就是把这个对象绑定给一个变量，让这个变量成为它的主人（聪明的读者应该能猜到，在这种情况下，该对象之前的主人就会丧失对该对象的所有权），像极了我们的现实世界，不是吗？
{{< /admonition >}}

即将变量名与某块内存区域进行 **绑定**，这使得变量名不会与某一个内存区域绑定死。

变量作用域本质上是栈帧，所以可以实现类似函数调用的变量遮蔽。但与栈帧有一点不同，它可以访问作用域外面的数据，而栈帧则不行。这是因为每一次函数调用的上文可能不同（调用者不同导致上文不同），所以不能安全地访问栈帧外的数据，而变量作用域的上文是固定的（变量作用域常出现于函数内部，即作用域之前的语句都是固定的），所以可以安全地访问作用域外部数据（这一点倒是和全局变量类似，毕竟对于函数调用来说全局变量是可以确定的上文）。当然变量遮蔽会导致无法访问作用域外部的同名变量。

### 基本类型

在 Rust 使用浮点数 (f32, f64, Nan) 时，受制于浮点数的精度，应当避免对浮点数进行等价性比较。

Rust 并没有像 C 语言一样，位运算的取反操作和逻辑运算的否操作采用不同的运算符，而是统一采用 `!` 运算符来表示。Rust 将 C 语言中返回类型为 `void` 的函数细化为两种，一种是返回值无意义的函数，返回类型（和值）为 `()`，并且不占用内存（这个类型在编译时期就处理完毕了，所以不涉及内存占用,它本质上就是个 0 长度的元组，根据排列组合也只有一个值）；另一种是永不返回的函数，称为发散函数，常用于函数体为无限循环的场景（例如嵌入式系统的主函数），返回类型为 `!`。发散函数不会返回任何值，可以用于替代需要任何返回任何值的地方，所以它的一大作用是在 `match` 表达式中用于替代任何类型的值，极大方便了 `panic` 宏的使用。另外 `return` 也可以在 `match` 表达式中替代任意类型的值，原理类似。

Rust 的语句 (statement) 和表达式 (expression) 与 Python 划分类似，毕竟都支持函数式编程风格。语句会执行一些操作但是不会返回一个值（但可能会有副作用），而表达式总是会在求值后返回一个值，同时表达式可以成为语句的一部分。Rust 的函数本质上也是表达式（与函数式编程风格兼容），准确来说是有参数签注的 `{}` 表达式（其它使用 `{}` 表达式的语句也是表达式，例如 `if` 表达式, `for` 表达式，这一点与 C 语言不同，C 语言中这些语句对应的是 Rust 的 `()` 表达式），但可能会有副作用（与 C 语言风格兼容），相比于 C 语言，Rust 赋予 `()` 类型比 C 的 `void` 更强大的表达能力。**TLDR: 有分号可以认为是语句，其他都是表达式。**

```rs
x + y           // expression
let x = 1 + 2;  // statement
let a = x + y;          // compile pass
let a = let x = 1 + 2;; // compile error
```

{{< image src="https://pic2.zhimg.com/80/v2-54b3a6d435d2482243edc4be9ab98153_1440w.png" >}}

Rust 的函数名和变量名采用蛇形命名法 (snake case)，例如 `fn add_two(x: i32, y: i32) -> i32`。

### 所有权和借用

Rust 的所有权系统为其提供了高性能的内存安全方案，而不是垃圾回收机制 (GC) 这种性能稍有欠缺的内存安全方案。这是因为所有权机制检查只发生在编译期，因此对于程序运行期，不会有任何性能上的损失。

栈 (stack) 与堆 (heap) 灵活性的差异在与：栈的操作方式过于单一，只能后进先出，不能灵活使用空闲空间；而堆支持任意访问 (random access)，所以可以灵活使用空闲空间，但也导致堆是缺乏组织的结构，而 Rust 的所有权机制就是对这一缺乏组织的结构采用类似栈的方式（作用域判定）进行检查管理。但堆的数据需要被栈上数据所引用才能被程序所使用（需要先索引才能使用），因而让栈上的数据都被所有权系统认为是堆的索引，导致了性能问题，从而引出了 `Copy` 这个 Trait。另外，程序员只能直接操作栈上的内存，对于堆上的内存是通过栈上变量来间接操作的。

```rs
struct StringView {
    data: String,
};
let x: StringView = {
    data: String::from("Hello"),
};
let y = x; // move ownership from x to y, x cann't be accessed!


struct StringView {
    data: i32,
};
let x: StringView = {
    data: 32,
};
let y = x; // also move ownership from x to y, x cann't be accessed!


#[derive(Copy)]
struct StringView {
    data: i32,
};
let x: StringView = {
    data: 32,
};
let y = x; // copy x to y, both x and y can be accessed!
```

不可变引用 (Immutable Reference) 类型 `&T` 都实现了 `Copy` Trait，这符合实际，因为引用并没有拥有所有权，并且允许同时存在多个不可变引用（以优化为并行处理）。注意当所有权转移时，可变性也可以随之改变，毕竟有所有权可以想怎么变就怎么变。当变量中一部分的所有权被转移给其它变量时，部分 move 就会发生。在这种情况下，原变量将无法再被使用（因为它不再拥有对整体的所有权），但是它没有转移所有权的那一部分依然可以使用（因为它还拥有这一部分的所有权）。

{{< admonition >}}
个人观点：Rust 拥有三大类型

1. 有索引其它数据，绑定会移动所有权的类型 (e.g. `String`, `Vector` 等集合类型)
2. 没有索引其它数据，绑定执行拷贝语义的类型 (e.g. `i32`, `f64` 等基本类型)
3. 有索引其它数据，但绑定执行拷贝语义的类型 (e.g. `&T` 这类不可变引用类型)

自定义的结构体类型默认是上面的第一种类型（无论你的成员是否有引用其它数据），可以使用 `Copy` Trait 来将其行为变为第二种类型。元组 (tuple) 类型则默认是上面的第二种类型，除非元组成员有包含第一种类型，此时则会转变为第一种类型的行为。可变引用虽然没有所有权，但因为同时只能存在一个，所以行为与第一种类型一致。

***Rust 的默认行为是 Move，而 C++ 默认行为则是 Copy。***
{{< /admonition >}}

借用和引用（包括不可变引用和可变引用）针对的是上面的第一种类型，因为其他两种类型默认行的是拷贝而不是转移所有权，转移所有权的代价太大了需要一种轻量级的替代方案。Rust 的内存安全的一个方面体现在，它不会编译通过存在数据竞争的代码，即一个作用域存在多个可变引用或同时存在可变引用和不可变引用的代码，这种代码是不符合 Rust 的语法规范的（因为这种代码没有同步机制来防止未定义行为）。Rust 的编译器优化后 ([Non-Lexical Lifetimes (NLL)](https://blog.rust-lang.org/2022/08/05/nll-by-default.html))，引用作用域的结束位置从花括号（与变量相同）变成引用最后一次被使用的位置，这极大便利了引用在程序中的使用。引用与指针不同，它没有空的状态，必须总是有效的（毕竟索引了某个东西才能叫引用嘛）。

`ref` 与 `&` 类似，可以用来获取一个值的引用，但是它们的用法有所不同，e.g. `let ref r = x;` 等价于 `let r = &x`，可变引用的话加一个 `mut` 修饰即可。`ref` 常用于模式匹配中获取结构体的特定成员的引用。

### 复合类型

编程语言只使用基本类型的局限性：无法从更高的抽象层次去简化代码，但引入复合类型加重的只是编译器的负担（和方便人类程序员在抽象层次组织代码），即在编译时期处理复合类型及其相关操作，而在执行时期的处理器看来，只使用基本类型的程序和使用复合类型的程序，二者编译后的二进制代码并无明显差异。

下图的 `world` 表示的即为切片的内存结构（拥有地址和长度两个字段，比 `Vector` 和 `String` 这种容器少一个 `capacity` 字段）:

{{< image src="https://pic1.zhimg.com/80/v2-69da917741b2c610732d8526a9cc86f5_1440w.jpg" >}}

个人认为切片 (slice) 相当于编译时期检查更加宽松的数组 (array)，例如切片类型不包括长度，允许接受任意长度的切片，但数组的类型包括长度，这使得其在编译时期检查更加严格，因此切片更加通用。

Rust 中的字符是 Unicode 类型，因此每个字符占据 4 个字节内存空间，但是在字符串（Rust 的字符串类型主要指 `&str` 和 `String`）中不一样，字符串是 UTF-8 编码，也就是字符串中的字符所占的字节数是变化的(1 - 4)，但无论字符串中的字符占字节数多少，字符串的底层的数据存储格式实际上都是 `[u8]`，即字节数组 (Byte array)。这个特性也导致了 Rust 不允许去索引字符串：因为索引操作，我们总是期望它的性能表现是 $\Omicron(1)$，然而对于字符串类型来说，无法保证这一点，因为 Rust 可能需要从 0 开始去遍历字符串来定位合法的字符。

如果字符串包含双引号，可以使用 raw string (该字符串默认不开启转义功能) 并在开头和结尾加 `#`；如果字符串中包含 # 号，可以在开头和结尾加多个 # 号，最多加255个，只需保证与字符串中连续 # 号的个数不超过开头和结尾的 # 号的个数即可。

```rs
let quotes = r#"And then I said: "There is no escape!""#;
let longer_delimiter = r###"A string with "# in it. And even "##!"###;
```

元组 (Tuple) 中是多个不同类型的元素的组合，数组 (Array) 是多个相同类型元素的组合，这两复合类型的抽象层次都比较低，因为不具备自定义名称的能力，所以基本不会给它们定义并实现方法，而结构体 (Struct) 因为具备自定义名称的能力，它的抽象层次就相对比较高了。使用元组声明形如 `let (x, y, z);` 这种语句 (statemen) 会被编译器特殊对待，会绑定 `x`, `y`, `z` 这三个变量而不是绑定一个元组变量，虽然编译器看来都一样，因为这三个变量的内存区域在哪种情况下都是相邻的。

Rust 不支持将某个结构体某个字段标记为可变，因为这样会导致编译器优化策略失效，试想一下一个结构体实例是不可变的但其某一个成员是可变的，那么对这个实例可以拥有多个不可变引用吗？编译器优化时利用不可变引用的特点会如预期吗？

枚举类型的值需要在定义类型时手动标注出，即枚举类型的值范围是有限的，而其他类型的值范围相对来说是“无限”的，Rust 枚举类型中值的关联数据信息则弥补了枚举类型的值范围是有限的这一缺陷，使得 Rust 可以运用枚举来表示大小类型之间的关系。Rust 的枚举类型在内存布局上，与 C 语言的 union 类型相似，但因为可以区分大小类型，所以表达能力更强。

Rust 也支持 C 语言风格的指定枚举成员值:

```rs
enum Number {
    Zero = 0,
    One,
    Two,
}
```

***模式 (pattern) 在匹配值和类型时有区别，其仅在与值匹配时进行绑定，而与类型只进行匹配而不进行绑定。***

数组的长度必须在编译期就已知:

```rs
// Compile ERROR since `n` is unknown at compile time
fn create_arr(n: i32) {
    let arr = [1; n];
}
```

如果采用索引遍历数组，Rust 会在运行时额外检查指定的索引是否小于数组长度，而采用迭代器遍历数组则没有这些额外的检查，所以使用迭代器遍历数组的效率更高。

数组的 `[<value>: <len>]` 初始化语法采用的行为是 Copy，所以对于未实现 Copy 语义的类型，需要采用 [std::array::from_fn()](https://doc.rust-lang.org/std/array/fn.from_fn.html) 函数来赋值。

### 流程控制

在 for、while、loop 三种循环中，只有 loop 循环是表达式。属于表达式的流程控制语法可以使用 `break` 返回表达式的值，所以 if 表达式也可以使用 `break` 返回表达式的值。

## Tips

stdout 中的非换行输出会被暂时存放于缓冲区（例如 `print!`），这样处理一般没有问题，但如果采用这种缓冲策略的输出语句后，接的是等待用户输入，然后输出用户输入内容并换行（此时会将输出缓冲区的内容全部打印出来，例如 `println!`），会导致输出与与其不符。尝试下面两段代码:

```rs
print!("> ");
for line in io::stdin().lock().lines() {
    println!("{}", line.unwrap());
    print!("> ");
}
```

```rs
print!("> ");
let _ = io::stdout().flush();
for line in io::stdin().lock().lines() {
    println!("{}", line.unwrap());
    print!("> ");
    let _ = io::stdout().flush();
}
```

可见性是针对外部的模块访问而言的，对于同一模块不需要过多考虑可见性。

`#![allow(unused_variables)]` 属性标记会告诉编译器忽略未使用的变量，不要抛出 warning 警告。

`dbg!` 宏会拿走所传入表达式的所有权，但是与函数调用不同，函数调用是在调用前计算参数值时转移了参数的所有权，而 `dbg!` 宏则是展开后计算时转移了传入的参数的所有权，虽然结果都是转移了所有权。

## References

- [Rust 语言圣经 (Rust Course)](https://course.rs/)
- bilibili: [The Golden Rust](https://space.bilibili.com/504069720/channel/collectiondetail?sid=3642485)
- [Programming Rust, 2nd Edition](https://www.oreilly.com/library/view/programming-rust-2nd/9781492052586/)
- [pretzelhammer\'s Rust blog](https://github.com/pretzelhammer/rust-blog)
- [Learn Rust the Dangerous Way](https://cliffle.com/p/dangerust/)
- [The Rustonomicon](https://doc.rust-lang.org/nomicon/)
- [CodeCrafters](https://app.codecrafters.io/)
- [Command line apps in Rust](https://rust-cli.github.io/book/index.html)
- [Achieving warp speed with Rust](https://gist.github.com/jFransham/369a86eff00e5f280ed25121454acec1)
- [The Rust Performance Book](https://nnethercote.github.io/perf-book/introduction.html)

---

{{< details "待整理" >}}

## CLI in Rust

C 语言的 CLI 程序处理参数的逻辑是过程式的，即每次执行都会通过 `argv` 来获取本次执行的参数并进行相应的处理 (Rust 的 `std::env::args()` 处理 CLI 程序的参数方式也类似，都是对每次执行实例进行过程式的处理)，而 [Clap](https://docs.rs/clap/latest/clap/) 不同，它类似于面向对象的思想，通过定义一个结构体 (object)，每次运行时通过 `clap::Parser::parse` 获取并处理本次运行的参数 (即实例化 object)，这样开发的 CLI 程序扩展性会更好。

{{< /details >}}
