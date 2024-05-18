---
title: "Rust 语言程序设计"
subtitle: Why Rust?
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

| Book | Video |
| :--: | :---: |
| https://doc.rust-lang.org/book/ | https://www.bilibili.com/video/BV1hp4y1k7SV/ |

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

从这个角度看，Rust 中的函数体也是表达式 (因为用 `{}` 包裹起来)，然后将函数的返回值视为表达式的结果值。好像也没毛病，毕竟 Rust 中所有函数都有返回值，没写返回值的默认为返回 `()`，表达式也类似，最后一条不是表达式的会补充一个 `()` 作为该表达式的结果。Rust 中很多语法都是表达式，例如 `if`, `match` 以及 `{}` 都是表达式，而在其他语言中一般是语句 (statement)，难怪有:
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

- 5.2. An Example Program Using Structs
> It’s not the prettiest output, but it shows the values of all the fields for this instance, which would definitely help during debugging. When we have larger structs, it’s useful to have output that’s a bit easier to read; in those cases, we can use `{:#?}` instead of `{:?}` in the println! string.

调试时常使用 `#[derive(Debug)]` 搭配 `{:?}` 或 `{:#？}` 打印相关的数据信息进行除错。

- 5.3. Method Syntax
> Rust doesn’t have an equivalent to the `->` operator; instead, Rust has a feature called automatic referencing and dereferencing. Calling methods is one of the few places in Rust that has this behavior.

这也是为什么方法 (Method) 的第一个参数是 `self` 并且根据使用的引用类型和所有权有不同的签名，这正是为了方便编译器进行自动推断 (个人估计是语法分析时进行的)。

- 5.3. Method Syntax
> The `Self` keywords in the return type and in the body of the function are aliases for the type that appears after the impl keyword

这个 `Self` 关键字语法在后面“附魔”上泛型和生命周期时就十分有用了 :rofl:

### Enums and Pattern Matching

这部分内容因为是从函数式编程演化而来的，可能会比较难理解。

{{< admonition >}}
Rust 中的枚举 (Enum) 实现了某种意义上的「大小类型」，即一个大类型涵盖有很多小类型，然后不同的小类型可以有不同的数据构成，然后最具表达力的一点是：这个大小类型关系可以不断递归下去。枚举附带的数据类型支持：结构体、匿名结构体、元组，这些通过编译器的语法分析都不难实现。
{{< /admonition >}}

- 6.1. Defining an Enum

> However, representing the same concept using just an enum is more concise: rather than an enum inside a struct, we can put data directly into each enum variant. 

因为枚举附带的数据在大部分场景都是引用 heap 数据的 object，所以对枚举的自动赋值操作和结构体一样，默认都是移动 (Move) 操作，即自动赋值后原先数据位于 stack 的那部分内存会失效。

{{< admonition >}}
Rust 的 `Option<T>` 的设计避免了其它语言中可能会出现的 UB，例如假设一个值存在，但实际上这个值并不存在，这允许编译器进行更激进的最佳化。在 Rust 中只要一个值不是 `Option<T>`，那它必然存在，并且在 Rust 中不能对 `Option<T>` 进行 `T` 的操作，而是需要先获取里面 `T` 的值才能进行操作，即 `Option<T>` 并没有继承 `T` 的行为。
{{< /admonition >}}

- 6.1. Defining an Enum
> Rust does not have nulls, but it does have an enum that can encode the concept of a value being present or absent.

> the compiler can’t infer the type that the corresponding Some variant will hold by looking only at a `None` value. 

`None` 不是一种类型，而是一个大类型 `Option<T>` 下的一个小类型，所以会有各种各样的 `None` 类型，而不存在一个独一无二的 `None` 类型。

- 6.2. The match Control Flow Construct
> Another useful feature of match arms is that they can bind to the parts of the values that match the pattern. This is how we can extract values out of enum variants.

模式匹配的机制是对 **枚举的类型** (包括大小类型) 进行匹配，像剥洋葱一样，最后将枚举类型附带的 **数据** 绑定到我们想要的变量上。只需要理解一点: ***只能对值进行绑定，类型是用来匹配的***。当然模式匹配也可以精确匹配到值，但这样没啥意义，因为你都知道值了，还进行模式匹配穷举干啥？:rofl: 这种精确到值的模式匹配一般出现在下面的 `if let` 表达式中，`match` 表达式一般不会这样用。

- 6.2. The match Control Flow Construct
> Rust also has a pattern we can use when we want a catch-all but don’t want to use the value in the catch-all pattern: `_` is a special pattern that matches any value and does not bind to that value. 

- 6.3. Concise Control Flow with if let
> The if let syntax lets you combine if and let into a less verbose way to handle values that match one pattern while ignoring the rest.

`if let` 表达式本质上是执行模式匹配的 `if` 表达式

> In other words, you can think of `if let` as syntax sugar for a `match` that runs code when the value matches one pattern and then ignores all other values.

> We can include an `else` with an `if let`. The block of code that goes with the `else` is the same as the block of code that would go with the `_` case in the `match` expression that is equivalent to the `if let` and `else`.

### Managing Growing Projects with Packages, Crates, and Modules

- **Packages**: A Cargo feature that lets you build, test, and share crates
- **Crates**: A tree of modules that produces a library or executable
- **Modules** and **use**: Let you control the organization, scope, and privacy of paths
- **Paths**: A way of naming an item, such as a struct, function, or module

```
Package |__ Crate (Root Module) |__ Module
                                ...
                                |__ Module
         
        |__ Crate (Root Module) |__ Module
                                ...
                                |__ Module
        ...
        |__ Crate (Root Module) |__ Module
                                ...
                                |__ Module
```

上面就是三者的关系图，注意 Package 和 crate 是从工程管理角度而衍生来的概念，而 Module 则是从代码管理角度的概念 (文件系统树)，将这两种视角结合在一起的中间层则是: ***crate 的名字被视为该 crate 的 root module***。

{{< admonition >}}
每个 module 包括与 crate 同名的 root module，该 module 范围下的「一等公民」(无论是是不是公开的，因为公开权限只针对外部) 之间可以互相访问，但无法访问这些一等公民的私有下属，例如一等公民是 module，那么就无法访问这个 module 内部的私有下属。

{{< center-quote >}}
*我同级的下级不是我的下级*
{{< /center-quote >}}

在 Rust 模块管理中，上级是外部，所以上级无法访问下级的私有成员，但是下级的任意成员都可以访问上级的任意成员。从树的角度比较好理解，因为从枝叶节点可以向上溯源到祖先节点，而在 Rust 模块管理的准则是: ***可以被搜寻到 (即存在一条路径) 的节点都可以被访问***。向下搜寻需要考虑公开权限，向上搜寻则不需要(这里的向上向下是指绝对的发向，因为可能会出现先向上再向下的场景，这时需要地这两阶段分开考虑)，而上面的规则也可以归纳为: 访问兄弟节点无需考虑权限。
{{< /admonition >}}

- 7.1. Packages and Crates
> If a package contains src/main.rs and src/lib.rs, it has two crates: a binary and a library, both with the same name as the package. A package can have multiple binary crates by placing files in the src/bin directory: each file will be a separate binary crate.

- 7.3. Paths for Referring to an Item in the Module Tree
> We can construct relative paths that begin in the parent module, rather than the current module or the crate root, by using `super` at the start of the path. This is like starting a filesystem path with the `..` syntax. 

- Rust By Example [10.2. Struct visibility](https://doc.rust-lang.org/rust-by-example/mod/struct_visibility.html)
> Structs have an extra level of visibility with their fields. The visibility defaults to private, and can be overridden with the `pub` modifier. This visibility only matters when a struct is accessed from outside the module where it is defined, and has the goal of hiding information (encapsulation).

注意这句话 *This visibility only matters when a struct is accessed from outside the module where it is defined* 这是一个比较任意混淆的点，这句话说明只有从 **外部访问** 时这个规则才生效，**同级访问** 时 struct 的权限就类似与 C 语言，成员是公开的。这很合理，要不然结构体对应 `impl` 部分也无法访问私有字段吗？那这样怎么进行初始化构造？是不是就豁然开朗了。

- 7.3. Paths for Referring to an Item in the Module Tree
> In contrast, if we make an enum public, all of its variants are then public. We only need the pub before the enum keyword

- 7.4. Bringing Paths Into Scope with the use Keyword

> Adding use and a path in a scope is similar to creating a symbolic link in the filesystem.

> Specifying the **parent module** when calling the **function** makes it clear that the function isn\'t locally defined while still minimizing repetition of the full path. 

> On the other hand, when bringing in **structs, enums, and other items** with `use`, it\'s idiomatic to specify the **full path**. 

> The exception to this idiom is if we\'re bringing two **items with the same name** into scope with `use` statements, because Rust doesn’t allow that. As you can see, using the **parent modules** distinguishes the two Result types. 

> There\'s another solution to the problem of bringing two types of the same name into the same scope with `use`: after the path, we can specify `as` and a new local name, or **alias**, for the type.

> When we bring a name into scope with the `use` keyword, the name available in the new scope is private. To enable the code that calls our code to refer to that name as if it had been defined in that code\'s scope, we can combine `pub` and `use`. This technique is called *re-exporting* because we\'re bringing an item into scope but also making that item available for others to bring into their scope.

> The common part of these two paths is `std::io`, and that’s the complete first path. To merge these two paths into one `use` statement, we can use `self` in the nested path,

## Visualizing memory layout of Rust\'s data types

YouTube: [Visualizing memory layout of Rust\'s data types](https://www.youtube.com/watch?v=7_o-YRxf_cc&t=0s) 

影片的中文翻译：

- [可视化 Rust 各数据结构的内存布局](https://www.bilibili.com/video/BV1KT4y167f1) [bilibili]

可搭配阅读相关的文档：

- [[2022-05-04] 可视化 Rust 各数据类型的内存布局](https://github.com/rustlang-cn/Rustt/blob/main/Articles/%5B2022-05-04%5D%20%E5%8F%AF%E8%A7%86%E5%8C%96%20Rust%20%E5%90%84%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B%E7%9A%84%E5%86%85%E5%AD%98%E5%B8%83%E5%B1%80.md)

[rust-in-100s]: https://youtu.be/5C_HPTJg5ek
[2022-review-the-adoption-of-rust-in-business]: https://rustmagazine.org/issue-1/2022-review-the-adoption-of-rust-in-business/