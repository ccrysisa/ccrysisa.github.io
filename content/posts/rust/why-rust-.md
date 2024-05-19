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
math: true
lightgallery: true
password:
message:
repost:
  enable: true
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

## Rust in 100 Seconds

观看短片: [Rust in 100 Seconds](https://youtu.be/5C_HPTJg5ek) :white_check_mark:
- [x] 了解 Rust，初步了解其安全性原理
- [x] 所有权 (ownership)
- [x] 借用 (borrow) 

{{< admonition warning >}}
0:55 This is wrong, value mutability doesn't have anything to do with the value being stored on the stack or the heap (and the example `let mut hello = "hi mom"` will be stored on the stack since it's type is `&'static str`), it depends on the type of the value (if it's `Sized` or not).
{{< /admonition >}}

## The adoption of Rust in Business (2022)

阅读报告: [The adoption of Rust in Business (2022)](https://rustmagazine.org/issue-1/2022-review-the-adoption-of-rust-in-business/) :white_check_mark:

Rust 目前蓬勃发展，预测未来是很难的，但是 Rust 已经是进行时的未来了 :rofl:

## The Rust Programming Language

| Book | Video | Documentation |
| :--: | :---: | :-----------: |
| [The Book](https://doc.rust-lang.org/book/) | [录影](https://www.bilibili.com/video/BV1hp4y1k7SV/) | [The Standard Library](https://doc.rust-lang.org/std/index.html) |

### Getting Started

```bash
$ cargo new <package>     # 创建项目
$ cargo build             # 编译、构建、调试版本
$ cargo build --release   # 编译优化、发布版本
$ cargo run               # 编译、运行
$ cargo check             # 静态分析检查
$ cargo clean             # 清除构建出来的目标文件
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

{{< center-quote >}}
***Rust is an expression-based language***
{{< /center-quote >}}

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
> Adding use and a path in a scope is similar to creating a **symbolic link** in the filesystem.

使用 `use` 就类似与 Linux 文件系统中的「符号链接」，当然使用这种语法需要遵守一定的风格，方便多工合作:

> Specifying the **parent module** when calling the **function** makes it clear that the function isn\'t locally defined while still minimizing repetition of the full path. 

> On the other hand, when bringing in **structs, enums, and other items** with `use`, it\'s idiomatic to specify the **full path**. 

> The exception to this idiom is if we\'re bringing two **items with the same name** into scope with `use` statements, because Rust doesn’t allow that. As you can see, using the **parent modules** distinguishes the two Result types. 

Rust 中也有类似于 Linux 系统的别名技巧，那就是使用 `as` 关键字来搭配 `use` 语法:

> There\'s another solution to the problem of bringing two types of the same name into the same scope with `use`: after the path, we can specify `as` and a new local name, or **alias**, for the type.

- 7.4. Bringing Paths Into Scope with the use Keyword
> When we bring a name into scope with the `use` keyword, the name available in the new scope is private. To enable the code that calls our code to refer to that name as if it had been defined in that code\'s scope, we can combine `pub` and `use`. This technique is called *re-exporting* because we\'re bringing an item into scope but also making that item available for others to bring into their scope.

使用 `use` 语法引入的别名在当前作用域名 (scope) 是私有的 (private)，如果想让这个别名在当前作用域重新导出为公开权限，可以使用 `pub use` 语法。

- 7.4. Bringing Paths Into Scope with the use Keyword
> The common part of these two paths is `std::io`, and that\'s the complete first path. To merge these two paths into one `use` statement, we can use `self` in the nested path,

`self` 关键字除了在对象的 `impl` 部分表示实例自身之外，在模块 (Module) 管理上也可以用于表示模块自身 (这个语法不常用，因为一般情况下 [LSP](https://en.wikipedia.org/wiki/Language_Server_Protocol) 会帮程序员自动处理好)。

{{< admonition >}}
Rust 对于模块的分离语法的文件管理也类似于文件系统树。可以将 `src/` 目录视为 crate (root module)，然后举个例子，对于 crate 下的模块 `horse`，如果采用分离文件写法，这个模块的内容就是 `src/horse.rs` 文件的内容；对于 `horse` 模块下的 `small_horse` 模块，该模块的内容就是 `src/horse/small_horse.rs` 文件的内容。显然这些源目录、文件之间的关系，与模块之间的父子关系相符合。
{{< /admonition >}}

### Common Collections

{{< admonition info "Documentation" >}}
- Struct std::vec::[Vec](https://doc.rust-lang.org/std/vec/struct.Vec.html)
- Struct std::string::[String](https://doc.rust-lang.org/std/string/struct.String.html)
- Struct std::collections::[HashMap](https://doc.rust-lang.org/std/collections/struct.HashMap.html)
{{< /admonition >}}

#### Storing Lists of Values with Vectors

> Like any other struct, a vector is freed when it goes out of scope

> When the vector gets dropped, all of its contents are also dropped, meaning the integers it holds will be cleaned up. The borrow checker ensures that any references to contents of a vector are only used while the vector itself is valid.

引用搭配 vector 在 drop 场景比较复杂，涉及到生命周期以及借用检查机制。

> Using `&` and `[]` gives us a reference to the element at the index value. When we use the `get` method with the index passed as an argument, we get an `Option<&T>` that we can use with `match`.

读取 vector 的元素获得的应该是该元素的引用，因为读取一个元素大部分情况下不需要该元素的所有权，除此之外，如果获取了元素的所有权，那么对于 vector 的使用会有一些安全限制。

```rs
let mut v = vec![1, 2, 3, 4, 5];
let first = &v[0];
v.push(6);
println!("The first element is: {first}");
```

> why should a reference to the first element care about changes at the end of the vector? This error is due to the way vectors work: because vectors put the values next to each other in memory, adding a new element onto the end of the vector might require allocating new memory and copying the old elements to the new space, if there isn’t enough room to put all the elements next to each other where the vector is currently stored. In that case, the reference to the first element would be pointing to deallocated memory. The borrowing rules prevent programs from ending up in that situation.

借用规则在 vector 仍然成立，并且对 vector 一些看似不相关实则相关的事例的原理进行了解释。

```rs
let mut v = vec![100, 32, 57];
for i in &mut v {
    *i += 50;
}
```

> To change the value that the mutable reference refers to, we have to use the `*` dereference operator to get to the value in `i` before we can use the `+=` operator. 

一般来说，只有可变引用 `&mut` 才需要关心解引用 `*` 运算符，因为不可变引用只能表达所引用的数据本身，并不能修改，而可变引用既能表达所引用的数据本身，还能对这个数据进行修改，需要一个机制将这两个表达能力区分开 (方便编译器在语法分析上的实作)，Rust 采用的策略是针对修改数据这个能力需要使用 `*` 运算符。

除了区分表达行为之外，这个观点也可以帮助我们理解一些 Rust 哲学，例如查询数据的函数 / 方法一般只需要不可变引用 `&` 作为参数，按照上面的解释，不可变引用 `&` 只能表示所引用的数据本身，所以作为参数对于函数内部实作并无影响 (因为只需要查看数据本身而不需要对其修改)，同时避免了所有权带来的高昂成本。

> Vectors can only store values that are the same type. 

> Fortunately, the variants of an enum are defined under the same enum type, so when we need one type to represent elements of different types, we can define and use an enum!

运用枚举 (enum) 搭配 vector 可以实作出比泛型更具表达力的 vector，即 vector 中的每个元素的类型可以不相同 (通过 enum 的大小类型机制即可实作)。

#### Storing UTF-8 Encoded Text with Strings

> Rust has only one string type in the core language, which is the string slice `str` that is usually seen in its borrowed form `&str`. 

> The `String` type, which is provided by Rust’s standard library rather than coded into the core language, is a growable, mutable, owned, UTF-8 encoded string type.

> Although this section is largely about `String`, both types are used heavily in Rust’s standard library, and both `String` and string slices are UTF-8 encoded.

Rust 中的字符串是 UTF-8 编码，注意与之前所提的 `char` 类型使用的 Unicode 编码不同。这一点很重要，因为 `String` 的 [len()](https://doc.rust-lang.org/std/string/struct.String.html#method.len) 方法是计算 byte 的数量 (URF-8 编码只占据一个 byte)。

> The `push_str` method takes a string slice because we don’t necessarily want to take ownership of the parameter. 

参数是字符串的引用而不是 `String` 的原因是，如果传入的是 `String` 会转移所有权，进而导致原先的 `String` 所在的 stack 内存失效，又因为字符串的字符拷贝操作是比较容易实现的，所以通过字符串引用也可以对字符串内容的字符进行拷贝，而不会对 `String` 的所有权造成影响。**引用未必不可拷贝，拷贝不是所有权的专属**。

> The version of the code using `format!` is much easier to read, and the code generated by the `format!` macro uses references so that this call doesn’t take ownership of any of its parameters.

`format!` 和 `print!` 宏的关系就和 C 语言中的 `sprintf` 和 `printf` 的关系类似。

> Rust strings don’t support indexing.   

> A `String` is a wrapper over a `Vec<u8>`.

> A final reason Rust doesn’t allow us to index into a `String` to get a character is that indexing operations are expected to always take constant time $O(1)$. But it isn’t possible to guarantee that performance with a `String`, because Rust would have to walk through the contents from the beginning to the index to determine how many valid characters there were.

字符串底层实作是使用 UTF-8 编码的，但是为了兼容，字符串也可以表示其他字符编码，但底层还是使用 UTF-8 编码构成，例如阿拉伯语的一个字符需要两个 bytes，那么底层就是要两个 UTF-8 编码的字符表示。这样就出现问题了，如果使用下标索引，该依据上面编码进行索引？如果使用 UTF-8 编码索引，那么索引获得的字符编码可能是非法的 (例如是阿拉伯字符的一半)，而采用正确的字符编码索引，在实作层面则过于低效，干脆就禁止了索引操作。

Rust 对于字符串处理的哲学 (我个人认为这样处理并不是特别好，因为 `char` 和 `str` 底层编码不一致，但 `str` 底层编码是和 `u8` 匹配的，算是一种 trade-off 吧):

> Rust has chosen to make the correct handling of `String` data the default behavior for all Rust programs, which means programmers have to put more thought into handling UTF-8 data upfront. This trade-off exposes more of the complexity of strings than is apparent in other programming languages, but it prevents you from having to handle errors involving non-ASCII characters later in your development life cycle.

#### Storing Keys with Associated Values in Hash Maps

> Note that we need to first `use` the `HashMap` from the collections portion of the standard library. Of our three common collections, this one is the least often used, so it’s not included in the features brought into scope automatically in the prelude. Hash maps also have less support from the standard library; there’s no built-in macro to construct them, for example.

与之前的 `Vec` 和 `String` 不同，`HashMap` 使用场景比较少 (因为使用场景大部分是性能要求高的，这种情况一般会选择自己开发高性能的 hash map 而不是使用标准库的)，所以需要通过 `use` 进行引入:

```rs
use std::collections::HashMap;
```

> Just like vectors, hash maps store their data on the heap.

> Like vectors, hash maps are homogeneous: all of the keys must have the same type as each other, and all of the values must have the same type.

Hash map 和 vecto 类似，数据存放在 heap 并且和是同构的，当然类似的，表达力也可以通过搭配枚举来增强。

> For types that implement the `Copy` trait, like `i32`, the values are copied into the hash map. For owned values like `String`, the values will be moved and the hash map will be the owner of those values

构造器本质也是一个函数 (关联函数)，而方法本质也是函数 (第一个参数为当前实例的特殊函数)，所以这里对于 hash map 元素所有权的处理与之前所提的准则一致 (主要是函数涉及的所有权处理部分)，并无冲突。

- Updating a Hash Map

> If we insert a key and a value into a hash map and then insert that same key with a different value, the value associated with that key will be replaced.

```rs
let mut scores = HashMap::new();

scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Blue"), 25);
```

> if the key does exist in the hash map, the existing value should remain the way it is. If the key doesn’t exist, insert it and a value for it.

```rs
let mut scores = HashMap::new();
scores.insert(String::from("Blue"), 10);

scores.entry(String::from("Yellow")).or_insert(50);
scores.entry(String::from("Blue")).or_insert(50);
```

{{< admonition quote >}}
The `or_insert` method on `Entry` is defined to return a mutable reference to the value for the corresponding `Entry` key if that key exists, and if not, inserts the parameter as the new value for this key and returns a mutable reference to the new value. 
{{< /admonition >}}

> Another common use case for hash maps is to look up a key’s value and then update it based on the old value. 

```rs
let mut map = HashMap::new();

for word in text.split_whitespace() {
    let count = map.entry(word).or_insert(0);
    *count += 1;
}
```

### Error Handling

> Rust groups errors into two major categories: *recoverable* and *unrecoverable* errors. For a recoverable error, such as a file not found error, we most likely just want to report the problem to the user and retry the operation. Unrecoverable errors are always symptoms of bugs, like trying to access a location beyond the end of an array, and so we want to immediately stop the program.

> Rust doesn’t have exceptions. Instead, it has the type `Result<T, E>` for recoverable errors and the `panic!` macro that stops execution when the program encounters an unrecoverable error.

Rust 并没有异常机制，而是使用 `Result<T, E>` 和 `panic!` 分别来处理可恢复 (recoverable) 和不可恢复 (unrecoverable) 的错误。可恢复错误的处理策略比较特别，因为它使用了 Rust 独有的枚举类型，而对于不可恢复错误的处理就比较常规了，本质上和 C 语言的 `exit` 处理相同。

> By default, when a panic occurs, the program starts *unwinding*, which means Rust walks back up the stack and cleans up the data from each function it encounters. However, this walking back and cleanup is a lot of work. Rust, therefore, allows you to choose the alternative of immediately aborting, which ends the program without cleaning up.

```toml
# abort on panic in release mode
[profile.release]
panic = 'abort'
```

> A *backtrace* is a list of all the functions that have been called to get to this point. Backtraces in Rust work as they do in other languages: the key to reading the backtrace is to start from the top and read until you see files you wrote. That’s the spot where the problem originated.

```bash
$ RUST_BACKTRACE=1 cargo run
$ RUST_BACKTRACE=full cargo run
```

> If the `Result` value is the `Ok` variant, `unwrap` will return the value inside the `Ok`. If the `Result` is the `Err` variant, unwrap will call the `panic!` macro for us.

> Similarly, the `expect` method lets us also choose the `panic!` error message. Using expect instead of `unwrap` and providing good error messages can convey your intent and make tracking down the source of a panic easier. 

对于 `Result<T, E>` 一般是通过 `match` 模式匹配进行处理，而 `unwrap` 和 `expect` 本质都是对 `Result<T, E>` 的常见的 `match` 处理模式的缩写，值得一提的是，它们对于 `Option<T>` 也有类似的效果。

## Visualizing memory layout of Rust\'s data types

录影: [YouTube](https://www.youtube.com/watch?v=7_o-YRxf_cc&t=0s) / [中文翻译](https://www.bilibili.com/video/BV1KT4y167f1)

搭配阅读: [[2022-05-04] 可视化 Rust 各数据类型的内存布局](https://github.com/rustlang-cn/Rustt/blob/main/Articles/%5B2022-05-04%5D%20%E5%8F%AF%E8%A7%86%E5%8C%96%20Rust%20%E5%90%84%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B%E7%9A%84%E5%86%85%E5%AD%98%E5%B8%83%E5%B1%80.md)
