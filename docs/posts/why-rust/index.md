# Rust 语言程序设计


&gt; The year 2022 marks seven years since the stable version of the Rust language was officially released. Since its release, Rust has been popular among developers. In a Stack Overflow poll of over 73,000 developers from 180 countries, Rust was voted the most popular programming language for the seventh consecutive year, with 87% of developers expressing a desire to use it.

&lt;!--more--&gt;

## Rust in 100 Seconds

观看短片: [Rust in 100 Seconds](https://youtu.be/5C_HPTJg5ek) :white_check_mark:
- [x] 了解 Rust，初步了解其安全性原理
- [x] 所有权 (ownership)
- [x] 借用 (borrow) 

{{&lt; admonition warning &gt;}}
0:55 This is wrong, value mutability doesn&#39;t have anything to do with the value being stored on the stack or the heap (and the example `let mut hello = &#34;hi mom&#34;` will be stored on the stack since it&#39;s type is `&amp;&#39;static str`), it depends on the type of the value (if it&#39;s `Sized` or not).
{{&lt; /admonition &gt;}}

## The adoption of Rust in Business (2022)

阅读报告: [The adoption of Rust in Business (2022)](https://rustmagazine.org/issue-1/2022-review-the-adoption-of-rust-in-business/) :white_check_mark:

Rust 目前蓬勃发展，预测未来是很难的，但是 Rust 已经是进行时的未来了 :rofl:

## The Rust Programming Language

| Book | Video | Documentation | Examples |
| :--: | :---: | :-----------: | :------: |
| [The Book](https://doc.rust-lang.org/book/) | [教学录影](https://www.bilibili.com/video/BV1hp4y1k7SV/) | [The Standard Library](https://doc.rust-lang.org/std/index.html) | [Rust by Example](https://doc.rust-lang.org/rust-by-example/) |

### Getting Started

```bash
$ cargo new &lt;package&gt;     # 创建项目
$ cargo build             # 编译、构建、调试版本
$ cargo build --release   # 编译优化、发布版本
$ cargo run               # 编译、运行
$ cargo check             # 静态分析检查
$ cargo clean             # 清除构建出来的目标文件
$ cargo test              # 运行测试
```

### Programming a Game

- Module std::[io](https://doc.rust-lang.org/std/io/index.html)
- Module std::[cmp](https://doc.rust-lang.org/std/cmp/index.html)
- Crate [rand](https://docs.rs/rand/latest/rand/)

### Common Concepts

变量明确区分可变和不可变，好处在于对于明确不可变的变量，使用引用时编译器可以进行更为激进的最佳化。常量必须满足可以在编译期计算出结果。

shadow 可理解为变量名可以和储存数据的地址绑定、解绑，所以可以进行变量遮蔽。而 C 语言中的变量名一旦使用就和储存数据的地址绑死了，自然无法进行遮蔽。

- 3.2. Data Types
&gt; When you’re compiling in release mode with the `--release` flag, Rust does not include checks for integer overflow that cause panics. Instead, if overflow occurs, Rust performs two’s complement wrapping. In short, values greater than the maximum value the type can hold “wrap around” to the minimum of the values the type can hold. In the case of a u8, the value 256 becomes 0, the value 257 becomes 1, and so on. The program won’t panic, but the variable will have a value that probably isn’t what you were expecting it to have. Relying on integer overflow’s wrapping behavior is considered an error.

即当使用 `--release` 编译参数时，编译器不会将 integer overflow 视为 UB

模式匹配的语法主要是为了方便编辑器的实现，因为 `(x, y, z) = tup` 这样的词法、语法分析显然比 Python 风格的 `x, y, z = tup` 分析难度低。

- 3.2. Data Types
&gt; Let’s see what happens if you try to access an element of an array that is past the end of the array.
&gt; This code compiles successfully. 
&gt; The program resulted in a runtime error at the point of using an invalid value in the indexing operation. 

数组元素的非法访问并不会导致编译失败，而是编译时期会在访问元素的附近加上检查有效的语句，如果运行时访问了非法的元素范围，会触发这个检测从而导致 `panic`。

- 3.3. Functions
&gt; Rust code uses snake case as the conventional style for function and variable names, in which all letters are lowercase and underscores separate words.

函数的参数类型必须指明，这可以方便编译器对根据函数定义对函数调用进行检查，是否符合要求，另一方面还可以让编译器生成恰当的指令用于跳转进函数执行 (编译器可能需要在栈上给函数传入的参数分配空间，例如 x86 架构的机器的 ABI 就是这么规定的)。

- 3.3. Functions
&gt; **Statements** are instructions that perform some action and do not return a value.   
&gt; **Expressions** evaluate to a resultant value. Let’s look at some examples.

&gt; A new scope block created with curly brackets is an expression

从这个角度看，Rust 中的函数体也是表达式 (因为用 `{}` 包裹起来)，然后将函数的返回值视为表达式的结果值。好像也没毛病，毕竟 Rust 中所有函数都有返回值，没写返回值的默认为返回 `()`，表达式也类似，最后一条不是表达式的会补充一个 `()` 作为该表达式的结果。Rust 中很多语法都是表达式，例如 `if`, `match` 以及 `{}` 都是表达式，而在其他语言中一般是语句 (statement)，难怪有:

{{&lt; center-quote &gt;}}
***Rust is an expression-based language***
{{&lt; /center-quote &gt;}}

- 3.3. Functions
&gt; You can return early from a function by using the `return` keyword and specifying a value, but most functions return the last expression implicitly. 

函数体的最后一个表达式视为返回值，这在编译器实作角度并不难，只需要在语法分析时加入这个逻辑即可，除此之外的返回语法，需要使用关键字 `return` 从编译器语法分析角度看来也很当然 (因为返回操作需要生成相对应的指令，所以需要指示当前是返回操作，通过最后一条表达式暗示或 `return` 关键字指示)。

- 3.5. Control Flow
&gt; You might also need to pass the result of that operation out of the loop to the rest of your code. To do this, you can add the value you want returned after the `break` expression you use to stop the loop; that value will be returned out of the loop so you can use it

&gt; `Range`, provided by the standard library, which generates all numbers in sequence starting from one number and ending before another number.
&gt; `rev`, to reverse the range.

### Ownership

#### What is Ownership?

&gt; Rust uses a third approach: memory is managed through a system of ownership with a set of rules that the **compiler checks**. If any of the rules are violated, the program won\&#39;t **compile**. None of the features of ownership will slow down your program while it\&#39;s running.

&gt; By the same token, a processor can do its job better if it works on data that’s close to other data (as it is on the stack) rather than farther away (as it can be on the heap).

这主要是因为 cache 机制带来的效能提升

&gt; Keeping track of what parts of code are using what data on the heap, minimizing the amount of duplicate data on the heap, and cleaning up unused data on the heap so you don’t run out of space are all problems that ownership addresses.

从上面的描述可以看出，所有权 (ownership) 机制主要针对的是 heap 空间的管理，所以下面的 3 条规则也是针对 heap 空间上的数据:

- Each value in Rust has an owner.
- There can only be one owner at a time.
- When the owner goes out of scope, the value will be dropped.

&gt; Rust takes a different path: the memory is automatically returned once the variable that owns it goes out of scope. 

也就是说，Rust 使用类似与 stack 的方式来管理 heap 空间，因为 stack 上的数在超过作用于就会自动消亡 (通过 `sp` 寄存器进行出栈操作)。Rust 对于 heap 的管理也类似，在出栈同时还回收 heap 对应的空间，这是合理的，因为 heap 上的数据都会直接/简接地被 stack 上的数据所引用，例如指针。

函数参数也类似，因为从函数调用 ABI 角度来看，赋值和函数调用时参数、返回的处理都是相同的，即在 stack 空间进行入栈操作。

&gt; We do not copy the data on the heap that the pointer refers to.

也就是说通常情况下 移动 (Move) 只对 heap 上的数据起作用，对于 stack 上的数据，体现的是 拷贝 (Copy) 操作，当然这也不绝对，可以通过实现 `Copy` 这个 trait 来对 heap 的数据也进行拷贝操作。Rust 对于 stack 和 heap 上都有数据的 object (例如 String) 的赋值处理默认是: 拷贝 stack 上的数据，新的 stack 数据仍然指向同一个 heap 的数据，同时将原先 stack 数据所在的内存无效化。

&gt;  This is known as a double free error and is one of the memory safety bugs we mentioned previously. Freeing memory twice can lead to memory corruption, which can potentially lead to security vulnerabilities.

&gt; To ensure memory safety, after the line `let s2 = s1;`, Rust considers `s1` as no longer valid. Therefore, Rust doesn’t need to free anything when `s1` goes out of scope.

&gt; In addition, there’s a design choice that’s implied by this: Rust will never automatically create “deep” copies of your data. Therefore, any automatic copying can be assumed to be inexpensive in terms of runtime performance.

移动 (Move) 操作解决了 double free 这个安全隐患，让 Rust 在内存安全的领域占据了一席之地。除此之外，Move 操作使得自动赋值的开销变得低廉，因为使用的是 Move 移动操作，而不是 Copy 拷贝操作。

&gt; Rust won’t let us annotate a type with Copy if the type, or any of its parts, has implemented the Drop trait. If the type needs something special to happen when the value goes out of scope and we add the Copy annotation to that type, we’ll get a compile-time error. 

#### References and Borrowing

从内存角度来看，reference 常用的场景为:
```
Reference            Owner
&#43;-------&#43;      &#43;----------------&#43;
| stack |  --&gt; | stack --&gt; Heap |
&#43;-------&#43;      &#43;----------------&#43;
```

&gt; Mutable references have one big restriction: if you have a mutable reference to a value, you can have no other references to that value.

&gt;  The benefit of having this restriction is that Rust can prevent data races at compile time. A data race is similar to a race condition and happens when these three behaviors occur:
&gt; - Two or more pointers access the same data at the same time.
&gt; - At least one of the pointers is being used to write to the data.
&gt; - There’s no mechanism being used to synchronize access to the data.

&gt; We also cannot have a mutable reference while we have an immutable one to the same value.

编译时期即可防止数据竞争，同时允许了编译器进行激进的最佳化策略 (因为保证没有非预期的数据竞争发生)。

&gt; In Rust, by contrast, the compiler guarantees that references will never be dangling references: if you have a reference to some data, the compiler will ensure that the data will not go out of scope before the reference to the data does.

编译器保证了我们使用引用时的正确性，同时这也是后面标注生命周期 (lifetime) 的机制基础。

- At any given time, you can have either one mutable reference or any number of immutable references.
- References must always be valid.

#### The Slice Type

&gt; Slices let you reference a contiguous sequence of elements in a collection rather than the whole collection. **A slice is a kind of reference, so it does not have ownership.**

切片 (slice) 也是一种引用 (references) 类型，所以它也遵守上一节提到的规则:
&gt; if you have a reference to some data, the compiler will ensure that the data will not go out of scope before the reference to the data does.

对于类型为 `String` 的变量 `s`，它的一些 slice 需要注意，`&amp;s[..]` 和 `&amp;s[0..s.len()]` 是等价的，但是这两个和 `&amp;s` 是不一样的，我们可以从内存角度获得启发:
```
&amp;s -&gt; s -&gt; str
&amp;s[..] -&gt; str
```

&gt; String slice range indices must occur at valid UTF-8 character boundaries. If you attempt to create a string slice in the middle of a multibyte character, your program will exit with an error.

&gt; If we have a string slice, we can pass that directly. If we have a String, we can pass a slice of the String or a reference to the String. This flexibility takes advantage of deref coercions

&gt; Defining a function to take a string slice instead of a reference to a String makes our API more general and useful without losing any functionality

{{&lt; admonition &gt;}}
将 `&amp;String` 类型的参数转换成 `&amp;str` 类型从实作的角度来看，应该是由编译器负责的，原理大致是语法分析时，依据函数调用时传入的参数是 `&amp;String` 还是 `&amp;str` 类型，为了让代码生成器生成一样的指令对参数进行入栈操作 (本质都是将 `&amp;str` 类型入栈)，所以语法分析器需要对 `&amp;String` 进行一些额外的操作，让其转换成 `&amp;str` 类型 (这部分由编译器帮我们做了，无需程序员进行手工转换)，当然程序员也可以手工进行转换成切片 `&amp;s[..]` (编译器也是在做这件事情罢了)。
{{&lt; /admonition &gt;}}

Documentation:
- method std::string::String::[as_bytes](https://doc.rust-lang.org/std/string/struct.String.html#method.as_bytes)
- method std::iter::Iterator::[enumerate](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.enumerate)
- Module std::[iter](https://doc.rust-lang.org/std/iter/index.html)

### Structs

Rust 不允许结构体初始化时只指定一部分字段的值，这防止了 UB 相关问题的触发。

- 5.1. Defining and Instantiating Structs

&gt; Note that the entire instance must be mutable; Rust doesn’t allow us to mark only certain fields as mutable.

&gt;  Tuple structs are useful when you want to give the whole tuple a name and make the tuple a different type from other tuples, and when naming each field as in a regular struct would be verbose or redundant.

&gt; Unit-like structs can be useful when you need to implement a trait on some type but don’t have any data that you want to store in the type itself.

{{&lt; admonition &gt;}}
Rust 中 struct 默认是进行移动 (Move) 操作，而 tuple 默认是进行拷贝 (Copy) 操作。这是因为 struct 一般使用时都会引用 heap 中的数据 (例如 `String`)，而依据移动 (Move) 操作的语义，进行自动赋值时会拷贝 stack 上的数据并且执行同一 heap 的数据，但是原先 stack 的数据会无效化防止发生 double free。依据这个语义，就不难理解为何 Rust 中的结构体位于 stack 时也不会进行拷贝 (Copy) 操作而是进行移动 (Move) 操作了，因为需要根据常用场景对语义进行 trade-off，即使 struct 没有引用 heap 的数据，为了保障常用场景的效能，还是将这类结构体设计成 Move 操作，即会导致原先的结构体无效化。tuple 也同理，其常用场景为 stack 上的复合数据，所以默认为 Copy 操作。
{{&lt; /admonition &gt;}}

- 5.2. An Example Program Using Structs
&gt; It’s not the prettiest output, but it shows the values of all the fields for this instance, which would definitely help during debugging. When we have larger structs, it’s useful to have output that’s a bit easier to read; in those cases, we can use `{:#?}` instead of `{:?}` in the println! string.

调试时常使用 `#[derive(Debug)]` 搭配 `{:?}` 或 `{:#？}` 打印相关的数据信息进行除错。

- 5.3. Method Syntax
&gt; Rust doesn’t have an equivalent to the `-&gt;` operator; instead, Rust has a feature called automatic referencing and dereferencing. Calling methods is one of the few places in Rust that has this behavior.

这也是为什么方法 (Method) 的第一个参数是 `self` 并且根据使用的引用类型和所有权有不同的签名，这正是为了方便编译器进行自动推断 (个人估计是语法分析时进行的)。

- 5.3. Method Syntax
&gt; The `Self` keywords in the return type and in the body of the function are aliases for the type that appears after the impl keyword

这个 `Self` 关键字语法在后面“附魔”上泛型和生命周期时就十分有用了 :rofl:

### Enums and Pattern Matching

这部分内容因为是从函数式编程演化而来的，可能会比较难理解。

{{&lt; admonition &gt;}}
Rust 中的枚举 (Enum) 实现了某种意义上的「大小类型」，即一个大类型涵盖有很多小类型，然后不同的小类型可以有不同的数据构成，然后最具表达力的一点是：这个大小类型关系可以不断递归下去。枚举附带的数据类型支持：结构体、匿名结构体、元组，这些通过编译器的语法分析都不难实现。
{{&lt; /admonition &gt;}}

- 6.1. Defining an Enum

&gt; However, representing the same concept using just an enum is more concise: rather than an enum inside a struct, we can put data directly into each enum variant. 

因为枚举附带的数据在大部分场景都是引用 heap 数据的 object，所以对枚举的自动赋值操作和结构体一样，默认都是移动 (Move) 操作，即自动赋值后原先数据位于 stack 的那部分内存会失效。

{{&lt; admonition &gt;}}
Rust 的 `Option&lt;T&gt;` 的设计避免了其它语言中可能会出现的 UB，例如假设一个值存在，但实际上这个值并不存在，这允许编译器进行更激进的最佳化。在 Rust 中只要一个值不是 `Option&lt;T&gt;`，那它必然存在，并且在 Rust 中不能对 `Option&lt;T&gt;` 进行 `T` 的操作，而是需要先获取里面 `T` 的值才能进行操作，即 `Option&lt;T&gt;` 并没有继承 `T` 的行为。
{{&lt; /admonition &gt;}}

- 6.1. Defining an Enum
&gt; Rust does not have nulls, but it does have an enum that can encode the concept of a value being present or absent.

&gt; the compiler can’t infer the type that the corresponding Some variant will hold by looking only at a `None` value. 

`None` 不是一种类型，而是一个大类型 `Option&lt;T&gt;` 下的一个小类型，所以会有各种各样的 `None` 类型，而不存在一个独一无二的 `None` 类型。

- 6.2. The match Control Flow Construct
&gt; Another useful feature of match arms is that they can bind to the parts of the values that match the pattern. This is how we can extract values out of enum variants.

模式匹配的机制是对 **枚举的类型** (包括大小类型) 进行匹配，像剥洋葱一样，最后将枚举类型附带的 **数据** 绑定到我们想要的变量上。只需要理解一点: ***只能对值进行绑定，类型是用来匹配的***。当然模式匹配也可以精确匹配到值，但这样没啥意义，因为你都知道值了，还进行模式匹配穷举干啥？:rofl: 这种精确到值的模式匹配一般出现在下面的 `if let` 表达式中，`match` 表达式一般不会这样用。

- 6.2. The match Control Flow Construct
&gt; Rust also has a pattern we can use when we want a catch-all but don’t want to use the value in the catch-all pattern: `_` is a special pattern that matches any value and does not bind to that value. 

- 6.3. Concise Control Flow with if let
&gt; The if let syntax lets you combine if and let into a less verbose way to handle values that match one pattern while ignoring the rest.

`if let` 表达式本质上是执行模式匹配的 `if` 表达式

&gt; In other words, you can think of `if let` as syntax sugar for a `match` that runs code when the value matches one pattern and then ignores all other values.

&gt; We can include an `else` with an `if let`. The block of code that goes with the `else` is the same as the block of code that would go with the `_` case in the `match` expression that is equivalent to the `if let` and `else`.

### Packages, Crates, and Modules

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

{{&lt; admonition &gt;}}
每个 module 包括与 crate 同名的 root module，该 module 范围下的「一等公民」(无论是是不是公开的，因为公开权限只针对外部) 之间可以互相访问，但无法访问这些一等公民的私有下属，例如一等公民是 module，那么就无法访问这个 module 内部的私有下属。

{{&lt; center-quote &gt;}}
*我同级的下级不是我的下级*
{{&lt; /center-quote &gt;}}

在 Rust 模块管理中，上级是外部，所以上级无法访问下级的私有成员，但是下级的任意成员都可以访问上级的任意成员。从树的角度比较好理解，因为从枝叶节点可以向上溯源到祖先节点，而在 Rust 模块管理的准则是: ***可以被搜寻到 (即存在一条路径) 的节点都可以被访问***。向下搜寻需要考虑公开权限，向上搜寻则不需要(这里的向上向下是指绝对的发向，因为可能会出现先向上再向下的场景，这时需要地这两阶段分开考虑)，而上面的规则也可以归纳为: 访问兄弟节点无需考虑权限。
{{&lt; /admonition &gt;}}

- 7.1. Packages and Crates
&gt; If a package contains src/main.rs and src/lib.rs, it has two crates: a binary and a library, both with the same name as the package. A package can have multiple binary crates by placing files in the src/bin directory: each file will be a separate binary crate.

- 7.3. Paths for Referring to an Item in the Module Tree
&gt; We can construct relative paths that begin in the parent module, rather than the current module or the crate root, by using `super` at the start of the path. This is like starting a filesystem path with the `..` syntax. 

- Rust By Example [10.2. Struct visibility](https://doc.rust-lang.org/rust-by-example/mod/struct_visibility.html)
&gt; Structs have an extra level of visibility with their fields. The visibility defaults to private, and can be overridden with the `pub` modifier. This visibility only matters when a struct is accessed from outside the module where it is defined, and has the goal of hiding information (encapsulation).

注意这句话 *This visibility only matters when a struct is accessed from outside the module where it is defined* 这是一个比较任意混淆的点，这句话说明只有从 **外部访问** 时这个规则才生效，**同级访问** 时 struct 的权限就类似与 C 语言，成员是公开的。这很合理，要不然结构体对应 `impl` 部分也无法访问私有字段吗？那这样怎么进行初始化构造？是不是就豁然开朗了。

- 7.3. Paths for Referring to an Item in the Module Tree
&gt; In contrast, if we make an enum public, all of its variants are then public. We only need the pub before the enum keyword

- 7.4. Bringing Paths Into Scope with the use Keyword

&gt; Adding use and a path in a scope is similar to creating a **symbolic link** in the filesystem.

使用 `use` 就类似与 Linux 文件系统中的「符号链接」，当然使用这种语法需要遵守一定的风格，方便多工合作:

&gt; Specifying the **parent module** when calling the **function** makes it clear that the function isn\&#39;t locally defined while still minimizing repetition of the full path. 

&gt; On the other hand, when bringing in **structs, enums, and other items** with `use`, it\&#39;s idiomatic to specify the **full path**. 

&gt; The exception to this idiom is if we\&#39;re bringing two **items with the same name** into scope with `use` statements, because Rust doesn’t allow that. As you can see, using the **parent modules** distinguishes the two Result types. 

Rust 中也有类似于 Linux 系统的别名技巧，那就是使用 `as` 关键字来搭配 `use` 语法:

&gt; There\&#39;s another solution to the problem of bringing two types of the same name into the same scope with `use`: after the path, we can specify `as` and a new local name, or **alias**, for the type.

&gt; When we bring a name into scope with the `use` keyword, the name available in the new scope is private. To enable the code that calls our code to refer to that name as if it had been defined in that code\&#39;s scope, we can combine `pub` and `use`. This technique is called *re-exporting* because we\&#39;re bringing an item into scope but also making that item available for others to bring into their scope.

使用 `use` 语法引入的别名在当前作用域名 (scope) 是私有的 (private)，如果想让这个别名在当前作用域重新导出为公开权限，可以使用 `pub use` 语法。

&gt; The common part of these two paths is `std::io`, and that\&#39;s the complete first path. To merge these two paths into one `use` statement, we can use `self` in the nested path,

`self` 关键字除了在对象的 `impl` 部分表示实例自身之外，在模块 (Module) 管理上也可以用于表示模块自身 (这个语法不常用，因为一般情况下 [LSP](https://en.wikipedia.org/wiki/Language_Server_Protocol) 会帮程序员自动处理好)。

{{&lt; admonition &gt;}}
Rust 对于模块的分离语法的文件管理也类似于文件系统树。可以将 `src/` 目录视为 crate (root module)，然后举个例子，对于 crate 下的模块 `horse`，如果采用分离文件写法，这个模块的内容就是 `src/horse.rs` 文件的内容；对于 `horse` 模块下的 `small_horse` 模块，该模块的内容就是 `src/horse/small_horse.rs` 文件的内容。显然这些源目录、文件之间的关系，与模块之间的父子关系相符合。
{{&lt; /admonition &gt;}}

### Common Collections

{{&lt; admonition info &#34;Documentation&#34; &gt;}}
- Struct std::vec::[Vec](https://doc.rust-lang.org/std/vec/struct.Vec.html)
- Struct std::string::[String](https://doc.rust-lang.org/std/string/struct.String.html)
- Struct std::collections::[HashMap](https://doc.rust-lang.org/std/collections/struct.HashMap.html)
{{&lt; /admonition &gt;}}

#### Vector

&gt; Like any other struct, a vector is freed when it goes out of scope

&gt; When the vector gets dropped, all of its contents are also dropped, meaning the integers it holds will be cleaned up. The borrow checker ensures that any references to contents of a vector are only used while the vector itself is valid.

引用搭配 vector 在 drop 场景比较复杂，涉及到生命周期以及借用检查机制。

&gt; Using `&amp;` and `[]` gives us a reference to the element at the index value. When we use the `get` method with the index passed as an argument, we get an `Option&lt;&amp;T&gt;` that we can use with `match`.

使用 `[]` 运算符获得的是元素本身，无论容器是引用的还是拥有所有权的。但读取 vector 的元素获得的应该是该元素的引用，因为读取一个元素大部分情况下不需要该元素的所有权，除此之外，如果获取了元素的所有权，那么对于 vector 的使用会有一些安全限制。

```rs
let mut v = vec![1, 2, 3, 4, 5];
let first = &amp;v[0];
v.push(6);
println!(&#34;The first element is: {first}&#34;);
```

&gt; why should a reference to the first element care about changes at the end of the vector? This error is due to the way vectors work: because vectors put the values next to each other in memory, adding a new element onto the end of the vector might require allocating new memory and copying the old elements to the new space, if there isn’t enough room to put all the elements next to each other where the vector is currently stored. In that case, the reference to the first element would be pointing to deallocated memory. The borrowing rules prevent programs from ending up in that situation.

借用规则在 vector 仍然成立，并且对 vector 一些看似不相关实则相关的事例的原理进行了解释。

```rs
let mut v = vec![100, 32, 57];
for i in &amp;mut v {
    *i &#43;= 50;
}
```

&gt; To change the value that the mutable reference refers to, we have to use the `*` dereference operator to get to the value in `i` before we can use the `&#43;=` operator. 

一般来说，只有可变引用 `&amp;mut` 才需要关心解引用 `*` 运算符，因为不可变引用只能表达所引用的数据本身，并不能修改，而可变引用既能表达所引用的数据本身，还能对这个数据进行修改，需要一个机制将这两个表达能力区分开 (方便编译器在语法分析上的实作)，Rust 采用的策略是针对修改数据这个能力需要使用 `*` 运算符。

除了区分表达行为之外，这个观点也可以帮助我们理解一些 Rust 哲学，例如查询数据的函数 / 方法一般只需要不可变引用 `&amp;` 作为参数，按照上面的解释，不可变引用 `&amp;` 只能表示所引用的数据本身，所以作为参数对于函数内部实作并无影响 (因为只需要查看数据本身而不需要对其修改)，同时避免了所有权带来的高昂成本。

&gt; Vectors can only store values that are the same type. 

&gt; Fortunately, the variants of an enum are defined under the same enum type, so when we need one type to represent elements of different types, we can define and use an enum!

运用枚举 (enum) 搭配 vector 可以实作出比泛型更具表达力的 vector，即 vector 中的每个元素的类型可以不相同 (通过 enum 的大小类型机制即可实作)。

#### String

&gt; Rust has only one string type in the core language, which is the string slice `str` that is usually seen in its borrowed form `&amp;str`. 

&gt; The `String` type, which is provided by Rust’s standard library rather than coded into the core language, is a growable, mutable, owned, UTF-8 encoded string type.

&gt; Although this section is largely about `String`, both types are used heavily in Rust’s standard library, and both `String` and string slices are UTF-8 encoded.

Rust 中的字符串是 UTF-8 编码，注意与之前所提的 `char` 类型使用的 Unicode 编码不同。这一点很重要，因为 `String` 的 [len()](https://doc.rust-lang.org/std/string/struct.String.html#method.len) 方法是计算 byte 的数量 (UTF-8 编码只占据一个 byte)。

&gt; The `push_str` method takes a string slice because we don’t necessarily want to take ownership of the parameter. 

参数是字符串的引用而不是 `String` 的原因是，如果传入的是 `String` 会转移所有权，进而导致原先的 `String` 所在的 stack 内存失效，又因为字符串的字符拷贝操作是比较容易实现的，所以通过字符串引用也可以对字符串内容的字符进行拷贝，而不会对 `String` 的所有权造成影响。**引用未必不可拷贝，拷贝不是所有权的专属** (只要引用的对象的元素实现了 Copy，那就可以通过引用来进行拷贝，例如 `&amp;str` 及其元素——字符)。

&gt; The version of the code using `format!` is much easier to read, and the code generated by the `format!` macro uses references so that this call doesn’t take ownership of any of its parameters.

`format!` 和 `print!` 宏的关系就和 C 语言中的 `sprintf` 和 `printf` 的关系类似。

&gt; Rust strings don’t support indexing.   

&gt; A `String` is a wrapper over a `Vec&lt;u8&gt;`.

&gt; A final reason Rust doesn’t allow us to index into a `String` to get a character is that indexing operations are expected to always take constant time $O(1)$. But it isn’t possible to guarantee that performance with a `String`, because Rust would have to walk through the contents from the beginning to the index to determine how many valid characters there were.

字符串底层实作是使用 UTF-8 编码的，但是为了兼容，字符串也可以表示其他字符编码，但底层还是使用 UTF-8 编码构成，例如阿拉伯语的一个字符需要两个 bytes，那么底层就是要两个 UTF-8 编码的字符表示。这样就出现问题了，如果使用下标索引，该依据上面编码进行索引？如果使用 UTF-8 编码索引，那么索引获得的字符编码可能是非法的 (例如是阿拉伯字符的一半)，而采用正确的字符编码索引，在实作层面则过于低效，干脆就禁止了索引操作。

Rust 对于字符串处理的哲学 (我个人认为这样处理并不是特别好，因为 `char` 和 `str` 底层编码不一致，但 `str` 底层编码是和 `u8` 匹配的，算是一种 trade-off 吧):

&gt; Rust has chosen to make the correct handling of `String` data the default behavior for all Rust programs, which means programmers have to put more thought into handling UTF-8 data upfront. This trade-off exposes more of the complexity of strings than is apparent in other programming languages, but it prevents you from having to handle errors involving non-ASCII characters later in your development life cycle.

#### Hash Map

&gt; Note that we need to first `use` the `HashMap` from the collections portion of the standard library. Of our three common collections, this one is the least often used, so it’s not included in the features brought into scope automatically in the prelude. Hash maps also have less support from the standard library; there’s no built-in macro to construct them, for example.

与之前的 `Vec` 和 `String` 不同，`HashMap` 使用场景比较少 (因为使用场景大部分是性能要求高的，这种情况一般会选择自己开发高性能的 hash map 而不是使用标准库的)，所以需要通过 `use` 进行引入:

```rs
use std::collections::HashMap;
```

&gt; Just like vectors, hash maps store their data on the heap.

&gt; Like vectors, hash maps are homogeneous: all of the keys must have the same type as each other, and all of the values must have the same type.

Hash map 和 vecto 类似，数据存放在 heap 并且和是同构的，当然类似的，表达力也可以通过搭配枚举来增强。

&gt; For types that implement the `Copy` trait, like `i32`, the values are copied into the hash map. For owned values like `String`, the values will be moved and the hash map will be the owner of those values

构造器本质也是一个函数 (关联函数)，而方法本质也是函数 (第一个参数为当前实例的特殊函数)，所以这里对于 hash map 元素所有权的处理与之前所提的准则一致 (主要是函数涉及的所有权处理部分)，并无冲突。

- Updating a Hash Map

&gt; If we insert a key and a value into a hash map and then insert that same key with a different value, the value associated with that key will be replaced.

```rs
let mut scores = HashMap::new();

scores.insert(String::from(&#34;Blue&#34;), 10);
scores.insert(String::from(&#34;Blue&#34;), 25);
```

&gt; if the key does exist in the hash map, the existing value should remain the way it is. If the key doesn’t exist, insert it and a value for it.

```rs
let mut scores = HashMap::new();
scores.insert(String::from(&#34;Blue&#34;), 10);

scores.entry(String::from(&#34;Yellow&#34;)).or_insert(50);
scores.entry(String::from(&#34;Blue&#34;)).or_insert(50);
```

{{&lt; admonition quote &gt;}}
The `or_insert` method on `Entry` is defined to return a mutable reference to the value for the corresponding `Entry` key if that key exists, and if not, inserts the parameter as the new value for this key and returns a mutable reference to the new value. 
{{&lt; /admonition &gt;}}

&gt; Another common use case for hash maps is to look up a key’s value and then update it based on the old value. 

```rs
let mut map = HashMap::new();

for word in text.split_whitespace() {
    let count = map.entry(word).or_insert(0);
    *count &#43;= 1;
}
```

### Error Handling

&gt; Rust groups errors into two major categories: *recoverable* and *unrecoverable* errors. For a recoverable error, such as a file not found error, we most likely just want to report the problem to the user and retry the operation. Unrecoverable errors are always symptoms of bugs, like trying to access a location beyond the end of an array, and so we want to immediately stop the program.

&gt; Rust doesn’t have exceptions. Instead, it has the type `Result&lt;T, E&gt;` for recoverable errors and the `panic!` macro that stops execution when the program encounters an unrecoverable error.

Rust 并没有异常机制，而是使用 `Result&lt;T, E&gt;` 和 `panic!` 分别来处理可恢复 (recoverable) 和不可恢复 (unrecoverable) 的错误。可恢复错误的处理策略比较特别，因为它使用了 Rust 独有的枚举类型，而对于不可恢复错误的处理就比较常规了，本质上和 C 语言的 `exit` 处理相同。

- 9.1. Unrecoverable Errors with panic!

&gt; By default, when a panic occurs, the program starts *unwinding*, which means Rust walks back up the stack and cleans up the data from each function it encounters. However, this walking back and cleanup is a lot of work. Rust, therefore, allows you to choose the alternative of immediately aborting, which ends the program without cleaning up.

```toml
# abort on panic in release mode
[profile.release]
panic = &#39;abort&#39;
```

&gt; A *backtrace* is a list of all the functions that have been called to get to this point. Backtraces in Rust work as they do in other languages: the key to reading the backtrace is to start from the top and read until you see files you wrote. That’s the spot where the problem originated.

```bash
$ RUST_BACKTRACE=1 cargo run
$ RUST_BACKTRACE=full cargo run
```

- 9.2. Recoverable Errors with Result

&gt; If the `Result` value is the `Ok` variant, `unwrap` will return the value inside the `Ok`. If the `Result` is the `Err` variant, unwrap will call the `panic!` macro for us.

&gt; Similarly, the `expect` method lets us also choose the `panic!` error message. Using expect instead of `unwrap` and providing good error messages can convey your intent and make tracking down the source of a panic easier. 

对于 `Result&lt;T, E&gt;` 一般是通过 `match` 模式匹配进行处理，而 `unwrap` 和 `expect` 本质都是对 `Result&lt;T, E&gt;` 的常见的 `match` 处理模式的缩写，值得一提的是，它们对于 `Option&lt;T&gt;` 也有类似的效果。

&gt; The `?` placed after a `Result` value is defined to work in almost the same way as the match expressions we defined to handle the `Result` values in Listing 9-6. If the value of the `Result` is an `Ok`, the value inside the `Ok` will get returned from this expression, and the program will continue. If the value is an `Err`, the `Err` will be returned from the whole function as if we had used the `return` keyword so the error value gets propagated to the calling code.

&gt; When the `?` operator calls the `from` function, the error type received is converted into the error type defined in the return type of the current function. 

`?` 运算符是常用的传播错误的 `match` 模式匹配的缩写，另外相对于直接使用 `match` 模式匹配，`?` 运算符会将接收的错误类型转换成返回类型的错误类型，以匹配函数签名。类似的，`?` 对于 `Option&lt;T&gt;` 也有类似的效果。

- 9.3. To panic! or Not to panic!
&gt; Therefore, returning `Result` is a good default choice when you’re defining a function that might fail.

定义一个可能会失败的函数时 (即预期计划处理错误)，应该使用 `Result` 进行错误处理，其它时候一般使用 `panic!` 处理即可 (因为预期就没打算处理错误)。

### Generic, Traits, and Lifetimes

{{&lt; admonition quote &gt;}}
Removing Duplication by Extracting a Function:
1. Identify duplicate code.
2. Extract the duplicate code into the body of the function and specify the inputs and return values of that code in the function signature.
3. Update the two instances of duplicated code to call the function instead.
{{&lt; /admonition &gt;}}

#### Generic Data Types

{{&lt; admonition &gt;}}
泛型 (generic) 和函数消除重复代码的逻辑类似，区别在于函数是在 **运行时期** 调用时才针对传入参数的 **数值** 进行实例化，而泛型是在 **编译时期** 针对涉及的调用的 **类型** (调用时涉及的类型是参数的类型，返回类型暂时无法使用泛型) 进行实例化。
{{&lt; /admonition &gt;}}

&gt; Note that we have to declare `T` just after `impl` so we can use `T` to specify that we’re implementing methods on the type `Point&lt;T&gt;`. By declaring `T` as a generic type after `impl`, Rust can identify that the type in the angle brackets in `Point` is a generic type rather than a concrete type.

从编译器词法分析和语法分析角度来理解该语法

&gt; The good news is that using generic types won&#39;t make your program run any slower than it would with concrete types.

&gt; Rust accomplishes this by performing monomorphization of the code using generics at compile time. Monomorphization is the process of turning generic code into specific code by filling in the concrete types that are used when compiled. 

泛型在编译时期而不是运行时期进行单例化，并不影响效能

#### Traits: Defining Shared Behavior

&gt; A type’s behavior consists of the methods we can call on that type. Different types share the same behavior if we can call the same methods on all of those types. Trait definitions are a way to group method signatures together to define a set of behaviors necessary to accomplish some purpose.

Trait 实现的是 **行为** 的共享，而没有实现数据的共享，即它只实现了行为接口的共享。

&gt; Note that it isn’t possible to call the default implementation from an overriding implementation of that same method.

```rs
pub fn notify&lt;T: Summary&gt;(item: &amp;T) {
    println!(&#34;Breaking news! {}&#34;, item.summarize());
}

pub fn notify&lt;T: Summary &#43; Display&gt;(item: &amp;T) {}
```

&gt; The `impl Trait` syntax is convenient and makes for more concise code in simple cases, while the fuller trait bound syntax can express more complexity in other cases. 

*Trait Bound* 本质也是泛型，只不过它限制了泛型在编译时期可以进行实例化的具体类型，例如该具体类型必须实现某个或某些 Trait。而 `impl Trait` 是它的语法糖，我个人倾向于使用 Trait Bound，因为可读性更好。除此之外，`impl Trait` 应用在返回类型时有一些限制 (Trait Bound 也暂时无法解决该问题，所以我们暂时只能将 Trait Bound 应用于函数参数):

&gt; However, you can only use `impl Trait` if you’re returning a single type. 

{{&lt; admonition &gt;}}
Rust 是一门注重 **编译时期** 的语言，所以它使用 Trait 不可能像 Java 使用 Inteface 那么灵活。因为 Rust 处理 Trait 也是在编译时期进行处理的，需要在编译时期将 Trait 转换成具体类型，所以其底层本质和泛型相同，都是编译时期实例化，只不过加上了实例化的具体类型的限制 (如果没满足限制就会编译错误)。
{{&lt; /admonition &gt;}}

```rs
fn some_function&lt;T: Display &#43; Clone, U: Clone &#43; Debug&gt;(t: &amp;T, u: &amp;U) -&gt; i32 {}

fn some_function&lt;T, U&gt;(t: &amp;T, u: &amp;U) -&gt; i32
where
    T: Display &#43; Clone,
    U: Clone &#43; Debug,
{}
```

&gt; Rust has alternate syntax for specifying trait bounds inside a `where` clause after the function signature.

`where` 语法使得使用 Trait Bound 语法的函数签名变得简洁，增强了可读性，特别是在 Trait Bound 比较复杂的情况下。

&gt; By using a trait bound with an `impl` block that uses generic type parameters, we can implement methods conditionally for types that implement the specified traits. 

```rs
impl&lt;T: Display &#43; PartialOrd&gt; Pair&lt;T&gt; {}
```

&gt; We can also conditionally implement a trait for any type that implements another trait. Implementations of a trait on any type that satisfies the trait bounds are called *blanket implementations* and are extensively used in the Rust standard library.

```rs
impl&lt;T: Display&gt; ToString for T {}
```

一样的还是 Trait Bound 的 **泛型搭配具体类型限制** 的思想

#### Validating References with Lifetimes

&gt; The main aim of lifetimes is to prevent *dangling references*, which cause a program to reference data other than the data it’s intended to reference.

主要目的就是防止 ***dangling reference*** 这个 UB

&gt; Lifetime annotations don’t change how long any of the references live. Rather, they describe the relationships of the lifetimes of multiple references to each other without affecting the lifetimes. 

进行标注并不会影响对象本身真正的生命周期，只是 **帮助编译器进行推导**，同时这个标注与函数内部逻辑也无关，主要作用是帮助编译器通过 *函数签名* 和 *函数调用* 对涉及的生命周期进行检查 (有些情况需要对函数体内的返回逻辑进行检查)，防止出现 dangling reference 这个 UB。

&gt; Just as functions can accept any type when the signature specifies a generic type parameter, functions can accept references with any lifetime by specifying a generic lifetime parameter.

{{&lt; admonition &gt;}}
生命周期也可以从 **实例化** 的角度进行思考，因为每次 **调用** 传入的参数的生命周期可能都不相同。当然无论是 The Book 还是教学录影在生命周期标注这里进度显得非常匆忙，建议搭配阅读下面文章:

- [如何理解 Rust 的生命周期标注](https://www.zhihu.com/question/435470652/answer/1653231267)

这篇文章非常好，从 **子类型** 的角度对生命周期标注进行了说明，举个例子:

```rs
&#39;l: &#39;s      // &#39;l 是 &#39;s 的子类型，即 &#39;l 表示的生命周期不小于 &#39;s 不表示的生命周期
x: &amp;&#39;l str  // x 是 &amp;&#39;l str 的子类型，即 x 表示生命周期不小于 &#39;l 的 str 的引用
```

对于函数参数，也可以通过上面说明的子类型进行对生命周期标注理解:

```rs
fn longest&lt;&#39;a&gt;(x: &amp;&#39;a str, y: &amp;&#39;a str) -&gt; &amp;&#39;a str {}
```

参数 `x`, `y` 都是 `&amp;&#39;a str` 的子类型，即参数实例的生命周期不小于 `&#39;a`，而返回类型 `&amp;&#39;a str` 则是任意返回值实例的子类型，即其不小于任意返回值实例的生命周期。对于函数签名中的相同生命周期标注 `&#39;a`，使用不等式表示如下:

{{&lt; raw &gt;}}
$$
传入参数的生命周期 \ge\ &#39;a\ \ge 返回值的生命周期
$$
{{&lt; /raw &gt;}}

对于结构体的生命周期标注，可以从构造器这个关联函数进行思考，因为构造器必须初始化所有的成员，而结构体的生命周期标注与引用类型的成员息息相关。
{{&lt; /admonition &gt;}}

&gt; The patterns programmed into Rust’s analysis of references are called the *lifetime elision rules*.

&gt; Lifetimes on function or method parameters are called *input lifetimes*, and lifetimes on return values are called *output lifetimes*.

&gt; The first rule is that the compiler assigns a lifetime parameter to each parameter that’s a reference.

&gt; The second rule is that, if there is exactly one input lifetime parameter, that lifetime is assigned to all output lifetime parameters

&gt; The third rule is that, if there are multiple input lifetime parameters, but one of them is `&amp;self` or `&amp;mut self` because this is a method, the lifetime of `self` is assigned to all output lifetime parameters.

这三条生命周期消除规则都是针对比较常见的生命周期标注的场景，为了节省程序员的精力，由编译器对这些简单的场景进行推断即可。当然依赖于编译器推断有时并不能达到我们的预期，特别是编译器只能推断简单常见的生命周期标注，思考下面的例子:

```rs
// wrong
fn fun(s: &amp;str) -&gt; &amp;str {
    &#34;hello&#34;
}
// the same as: fn fun(s: &amp;&#39;a str) -&gt; &amp;&#39;a str

// right
fn fun(s: &amp;&#39;a str) -&gt; &amp;&#39;b str {
    &#34;hello&#34;
}
```

输入参数的生命周期和返回值的生命周期之间并无关系 (不存在子类型的关系)，所以应该使用不同的生命周期标注

{{&lt; admonition tip &gt;}}
涉及到生命周期的程序，编写代码时先不需要考虑生命周期，先将代码逻辑写好，然后从防止 ***dangling reference*** 这个 UB 以及 **子类型** 的角度对生命周期进行标注。
{{&lt; /admonition &gt;}}

### Automated Tests

- 11.1. How to Write Tests
&gt; Tests are Rust functions that verify that the non-test code is functioning in the expected manner. The bodies of test functions typically perform these three actions:
&gt; 
&gt; 1. Set up any needed data or state.
&gt; 2. Run the code you want to test.
&gt; 3. Assert the results are what you expect.

&gt; Each test is run in a new thread, and when the main thread sees that a test thread has died, the test is marked as failed.

自动测试模板:
```rs
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn larger_can_hold_smaller() {}
}
```

自动测试常用宏:
- Macro std::[assert](https://doc.rust-lang.org/std/macro.assert.html)
- Macro std::[assert_eq](https://doc.rust-lang.org/std/macro.assert_eq.html)
- Macro std::[assert_ne](https://doc.rust-lang.org/std/macro.assert_ne.html)

&gt; You can also add a custom message to be printed with the failure message as optional arguments to the `assert!`, `assert_eq!`, and `assert_ne!` macros. Any arguments specified after the required arguments are passed along to the `format!` macro 

上面涉及的宏都是用来对返回值进行测试的 (也可以附加错误信息)，有时我们需要测试代码在某些情况下，是否按照预期发生恐慌，这时我们就可以使用 `should_panic` 属性:

&gt; In addition to checking return values, it’s important to check that our code handles error conditions as we expect. 

&gt; We do this by adding the attribute `should_panic` to our test function. The test passes if the code inside the function panics; the test fails if the code inside the function doesn’t panic.

```rs
#[test]
#[should_panic]
fn greater_than_100() {
    ...
}
```

&gt; Tests that use `should_panic` can be imprecise. A `should_panic` test would pass even if the test panics for a different reason from the one we were expecting. To make `should_panic` tests more precise, we can add an optional expected parameter to the `should_panic` attribute. The test harness will make sure that the failure message contains the provided text. 

```rs
#[test]
#[should_panic(expected = &#34;less than or equal to 100&#34;)]
fn greater_than_100() {
    ...
}
```

`should_panic` 属性可附带 expected 文本，这样自动测试时，不仅会检测是否发生 panic 还会检测 panic 信息是否包含 expect 文本，这样使得 `should_panic` 对于发生 panic 的原因掌握的更加精准 (因为不同原因导致的 panic 的信息一般不相同)。

除了使用 `panic` 方法来编写自动测试 (上面所提的方法本质都是测试失败时触发 `panic`)，我们还可以通过 `Result&lt;T, E&gt;` 来编写测试，返回 `Ok` 表示测试成功，返回 `Err` 则表示测试失败。

&gt; rather than calling the `assert_eq!` macro, we return `Ok(())` when the test passes and an `Err` with a `String` inside when the test fails.

```rs
#[test]
fn it_works() -&gt; Result&lt;(), String&gt; {
    if 2 &#43; 2 == 4 {
        Ok(())
    } else {
        Err(String::from(&#34;two plus two does not equal four&#34;))
    }
}
```

&gt; You can’t use the `#[should_panic]` annotation on tests that use `Result&lt;T, E&gt;`.

- 11.2. Controlling How Tests Are Run

&gt; The default behavior of the binary produced by `cargo test` is to run all the tests in parallel and capture output generated during test runs, preventing the output from being displayed and making it easier to read the output related to the test results. You can, however, specify command line options to change this default behavior.

&gt; separate these two types of arguments, you list the arguments that go to cargo test followed by the separator `--` and then the ones that go to the test binary.

```bash
$ cargo test &lt;args1&gt; -- &lt;args2&gt;
# args1: cargo test 的参数
# args2: cargo test 生成的二进制文件的参数
```

&gt; When you run multiple tests, by default they run in parallel using threads, meaning they finish running faster and you get feedback quicker. Because the tests are running at the same time, you must make sure your tests don’t depend on each other or on any shared state, including a shared environment, such as the current working directory or environment variables.

自动测试默认行为是并行的，所以我们在编写测试代码时，需要安装并行设计的思维进行编写，保证不会出现因为并行而导致的 UB。当然你也可以指定自动测试时使用的线程数量，甚至可以将线程数设置为 1 这样就不需要以并行设计测试代码了。

&gt; If you don’t want to run the tests in parallel or if you want more fine-grained control over the number of threads used, you can send the --test-threads flag and the number of threads you want to use to the test binary. 

```bash
$ cargo test -- --test-threads=1
```

&gt; By default, if a test passes, Rust’s test library captures anything printed to standard output. For example, if we call println! in a test and the test passes, we won’t see the println! output in the terminal; we’ll see only the line that indicates the test passed. If a test fails, we’ll see whatever was printed to standard output with the rest of the failure message.

当测试用例成功时，Rust 会捕获该成功用例中的输出，只打印测试成功这一个信息，用例代码逻辑中的打印输出均被捕获了。当用例失败时，则不会对输出进行捕获，而是将它们和测试失败信息一起打印出来。当然我们也可以设置用例成功时不捕获输出:

&gt; If we want to see printed values for passing tests as well, we can tell Rust to also show the output of successful tests with `--show-output`.

```bash
$ cargo test -- --show-output
```

&gt; You can choose which tests to run by passing `cargo test` the name or names of the test(s) you want to run as an argument.

可以指定运行某些测试，而不是运行全部测试:

&gt; We can pass the name of any test function to `cargo test` to run only that test

&gt; We can specify part of a test name, and any test whose name matches that value will be run. 

&gt; Also note that the module in which a test appears becomes part of the test’s name, so we can run all the tests in a module by filtering on the module’s name.

Ignoring Some Tests Unless Specifically Requested

&gt; Sometimes a few specific tests can be very time-consuming to execute, so you might want to exclude them during most runs of `cargo test`. Rather than listing as arguments all tests you do want to run, you can instead annotate the time-consuming tests using the `ignore` attribute to exclude them

```rs
#[test]
#[ignore]
fn expensive_test() {
    ...
}
```

&gt; If we want to run only the ignored tests, we can use:

```bash
$ cargo test -- --ignored
```

- 11.3. Test Organization

&gt; Unit tests are small and more focused, testing one module in isolation at a time, and can test private interfaces. Integration tests are entirely external to your library and use your code in the same way any other external code would, using only the public interface and potentially exercising multiple modules per test.

Rust 有单元测试和集成测试两大类别，可以近似理解为白盒测试和黑盒测试。

单元测试 (Unit Tests)

&gt; The convention is to create a module named `tests` in each file to contain the test functions and to annotate the module with `cfg(test)`.

&gt; The `#[cfg(test)]` annotation on the tests module tells Rust to compile and run the test code only when you run `cargo test,` not when you run `cargo build`.

&gt; The attribute `cfg` stands for configuration and tells Rust that the following item should only be included given a certain configuration option. In this case, the configuration option is `test`, which is provided by Rust for compiling and running tests. 

对于测试模块，Rust 会进行选择编译，作用类似于 C 语言的 `#if` 宏。

&gt; Rust’s privacy rules do allow you to test private functions.

单元测试可以对模块的私有成员进行测试，类似于白盒测试。

集成测试 (Integration Tests)

&gt; To create integration tests, you first need a tests directory.

&gt; We create a tests directory at the top level of our project directory, next to src. Cargo knows to look for integration test files in this directory.

&gt; Each file in the tests directory is a separate crate, so we need to bring our library into each test crate’s scope. 

集成测试位于 `tests/` 目录下，并且该目录下的每个测试文件都是单独的 crate，即每个测试文件都需要对要测试的库、模块进行引入。

&gt; We don’t need to annotate any code in `tests/integration_test.rs` with `#[cfg(test)]`. Cargo treats the tests directory specially and compiles files in this directory only when we run `cargo test`.

因为已经通过 `tests/` 文件夹与其他的库文件区分开了了，所以集成测试不需要通过标注 `#[cfg(test)]` 来进行选择编译。

&gt; As you add more integration tests, you might want to make more files in the tests directory to help organize them

&gt; As mentioned earlier, each file in the tests directory is compiled as its own separate crate

&gt; However, this means files in the tests directory don’t share the same behavior as files in src do, as you learned in Chapter 7 regarding how to separate code into modules and files.

Files in subdirectories of the tests directory don’t get compiled as separate crates or have sections in the test output.

如果需要对集成测试添加一些辅助函数，我们需要在 `tests/` 目录下创建子目录以及模块，将辅助函数放置在这个目录和模块内，这样就不会被编译器视为集成测试的测试文件了。

&gt; Only library crates expose functions that other crates can use; binary crates are meant to be run on their own.

### An I/O Project: minigrep

- 12.3. Refactoring to Improve Modularity and Error Handling

&gt; As a result, the Rust community has developed guidelines for splitting the separate concerns of a binary program when main starts getting large. This process has the following steps:

- Split your program into a main.rs and a lib.rs and move your program’s logic to lib.rs.
- As long as your command line parsing logic is small, it can remain in main.rs.
- When the command line parsing logic starts getting complicated, extract it from main.rs and move it to lib.rs.

&gt; The responsibilities that remain in the `main` function after this process should be limited to the following:

- Calling the command line parsing logic with the argument values
- Setting up any other configuration
- Calling a `run` function in lib.rs
- Handling the error if `run` returns an error

这样处理使得我们可以测试该程序的几乎全部内容，因为我们将大部分逻辑都移动到了 lib.rs 文件里面，而 lib.rs 文件的内容是可以被测试的。

Documentation:
- method std::iter::Iterator::[collect](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.collect)
- method std::result::Result::[unwrap_or_else](https://doc.rust-lang.org/std/result/enum.Result.html#method.unwrap_or_else)
- Function std::process::[exit](https://doc.rust-lang.org/std/process/fn.exit.html)
- method str::[lines](https://doc.rust-lang.org/std/primitive.str.html#method.lines)
- method str::[contains](https://doc.rust-lang.org/std/primitive.str.html#method.contains)
- method str::[to_lowercase](https://doc.rust-lang.org/std/primitive.str.html#method.to_lowercase)
- method std::result::Result::[is_err](https://doc.rust-lang.org/std/result/enum.Result.html#method.is_err)

### Iterators and Closures

&gt; Rust’s design has taken inspiration from many existing languages and techniques, and one significant influence is functional programming. 

{{&lt; admonition success &gt;}}
这一章是关于函数式编程的，Rust 吸收了很多编程范式的精华，所以也可以使用函数式编程风格。关于函数式编程的资料，可以参考康奈尔大学的 [OCaml Programming: Correct &#43; Efficient &#43; Beautiful](https://www.youtube.com/playlist?list=PLre5AT9JnKShBOPeuiD9b-I4XROIJhkIU) 和斯坦福大学的编程范式 [CS107](https://www.bilibili.com/video/BV1Cx411S7HJ/)，以及最出名的麻省理工学院的 [SICP](https://www.bilibili.com/video/BV1Xx41117tr/) (这个版本是给 IBM 工程师培训的，MIT 还有一个 [2004 年的版本](https://www.youtube.com/playlist?list=PL7BcsI5ueSNFPCEisbaoQ0kXIDX9rR5FF) 是给学生上课的)。
{{&lt; /admonition &gt;}}

#### Closures: Anonymous Functions that Capture Their Environment

&gt; Rust’s closures are anonymous functions you can save in a variable or pass as arguments to other functions. 
&gt; You can create the closure in one place and then call the closure elsewhere to evaluate it in a different context. 
&gt; Unlike functions, closures can capture values from the scope in which they’re defined.

严格上来讲，函数也可以捕获其定义的作用域的变量，例如 C 语言的函数就可以访问全局变量，因为全局变量和函数都是定义最顶层，作为 first-class。担任闭包的灵活性更强，例如可以将闭包定义在结构体里面，作为结构体的成员，从而可以实现懒计算的功能。

&gt; Closures don’t usually require you to annotate the types of the parameters or the return value like `fn` functions do. Type annotations are required on functions because the types are part of an explicit interface exposed to your users.

&gt; Closures, on the other hand, aren’t used in an exposed interface like this: they’re stored in variables and used without naming them and exposing them to users of our library.

&gt; Closures are typically short and relevant only within a narrow context rather than in any arbitrary scenario. Within these limited contexts, the compiler can infer the types of the parameters and the return type

&gt; As with variables, we can add type annotations if we want to increase explicitness and clarity at the cost of being more verbose than is strictly necessary.

因为闭包不暴露给外部使用者，并且闭包逻辑一般比较简单，所以闭包的参数和返回值的类型由程序员自己保证即可，编译器一般可以推断出来 (类似于编译器可以推断出变量的类型)。当然也可以给闭包的参数和返回值加上类型标注 (类似于可以给变量加上类型标注)，这也是合法的。

```rs
fn  add_one_v1   (x: u32) -&gt; u32 { x &#43; 1 }
let add_one_v2 = |x: u32| -&gt; u32 { x &#43; 1 };
let add_one_v3 = |x|             { x &#43; 1 };
let add_one_v4 = |x|               x &#43; 1  ;
```

闭包的内部逻辑必须是一个 **表达式**，使得闭包拥有返回值，例如上面的中间两行的闭包逻辑都是 `{}` 表达式，最后一行的是 `x &#43; 1` 这个加法表达式 (函数和我们之前提到的一样，函数体必须是一个表达式，通常是 `{}` 表达式，例如第一行)。

&gt; For closure definitions, the compiler will infer one concrete type for each of their parameters and for their return value.

如果依赖编译器推断闭包的相关类型，那么编译器只会推断出一个具体的类型，类似于编译器对于变量的类型也只能推断出一个，所以下面的例子会报错:

```rs
let example_closure = |x| x;

let s = example_closure(String::from(&#34;hello&#34;)); // |x: String|
let n = example_closure(5);                     // |x: i32|
```

{{&lt; admonition quote &gt;}}
1. `FnOnce` applies to closures that can be called once. All closures implement at least this trait, because all closures can be called. A closure that moves captured values out of its body will only implement `FnOnce` and none of the other `Fn` traits, because it can only be called once.

2. `FnMut` applies to closures that don’t move captured values out of their body, but that might mutate the captured values. These closures can be called more than once.

3. `Fn` applies to closures that don’t move captured values out of their body and that don’t mutate captured values, as well as closures that capture nothing from their environment. These closures can be called more than once without mutating their environment, which is important in cases such as calling a closure multiple times concurrently.
{{&lt; /admonition &gt;}}

```rs
impl&lt;T&gt; Option&lt;T&gt; {
    pub fn unwrap_or_else&lt;F&gt;(self, f: F) -&gt; T
    where
        F: FnOnce() -&gt; T
    {
        match self {
            Some(x) =&gt; x,
            None =&gt; f(),
        }
    }
}
```

因为闭包是 Trait，所以闭包作为参数进行传递时，需要使用 **泛型约束** 来指定对应的 Trait

&gt; If you want to force the closure to take ownership of the values it uses in the environment even though the body of the closure doesn’t strictly need ownership, you can use the `move` keyword before the parameter list.

&gt; This technique is mostly useful when passing a closure to a new thread to move the data so that it’s owned by the new thread.

多线程编程时使用 `move` 关键字可以强制将一个变量的所有权交给另一个线程。

#### Processing a Series of Items with Iterators

{{&lt; admonition &gt;}}
这一节简单介绍了下迭代器是什么以及迭代器的功能，如果想更进一步地了解迭代器的实作，建议观看 John Gjengset 的影片 [Crust of Rust: Iterators](https://www.youtube.com/watch?v=yozQ9C69pNs)，本人也有写相关的 [笔记]({{&lt; relref &#34;./Iterators.md&#34; &gt;}}) 来对影片内容进行解释和扩展。
{{&lt; /admonition &gt;}}

The Iterator Trait and the next Method

&gt; An iterator is responsible for the logic of iterating over each item and determining when the sequence has finished. 

&gt; In Rust, iterators are lazy, meaning they have no effect until you call methods that consume the iterator to use it up. 

&gt; All iterators implement a trait named `Iterator` that is defined in the standard library. The definition of the trait looks like this:

```rs
pub trait Iterator {
    type Item;

    fn next(&amp;mut self) -&gt; Option&lt;Self::Item&gt;;

    // methods with default implementations elided
}
```

&gt; The `Iterator` trait only requires implementors to define one method: the `next` method

&gt; The `iter` method produces an iterator over immutable references. If we want to create an iterator that takes ownership of `v1` and returns owned values, we can call `into_iter` instead of `iter`. Similarly, if we want to iterate over mutable references, we can call `iter_mut` instead of `iter`.

Methods that Consume the Iterator

&gt; Some of these methods call the `next` method in their definition, which is why you’re required to implement the `next` method when implementing the `Iterator` trait.

&gt; Methods that call `next` are called consuming adaptors, because calling them uses up the iterator.

&gt; One example is the `sum` method, which takes ownership of the iterator and iterates through the items by repeatedly calling `next`, thus consuming the iterator.

Methods that Produce Other Iterators

&gt; Iterator adaptors are methods defined on the Iterator trait that don’t consume the iterator. Instead, they produce different iterators by changing some aspect of the original iterator.

&gt; iterator adaptor method `map`, which takes a closure to call on each item as the items are iterated through. The `map` method returns a new iterator that produces the modified items. 

Using Closures that Capture Their Environment

&gt; the `filter` method that takes a closure. The closure gets an item from the iterator and returns a `bool`. If the closure returns `true`, the value will be included in the iteration produced by `filter`. If the closure returns `false`, the value won’t be included.

#### Comparing Performance: Loops vs. Iterators

&gt; The point is this: iterators, although a high-level abstraction, get compiled down to roughly the same code as if you’d written the lower-level code yourself. Iterators are one of Rust’s zero-cost abstractions, by which we mean using the abstraction imposes no additional runtime overhead.

零开销抽象 (Zero-Aost Abstractions): 使用抽象时不会引入额外的运行时开销，所以尽量使用 Rust 提供的抽象语法，因为其底层实现大概率进行了相应的优化，比自己手写的底层代码高效不少。

### Cargo and Crates.io

- 14.1. Customizing Builds with Release Profiles

&gt; Cargo has two main profiles: the `dev` profile Cargo uses when you run `cargo build` and the `release` profile Cargo uses when you run `cargo build --release`.

&gt; Cargo has default settings for each of the profiles that apply when you haven&#39;t explicitly added any `[profile.*]` sections in the project’s Cargo.toml file. By adding `[profile.*]` sections for any profile you want to customize, you override any subset of the default settings.

```toml {title=&#34;Cargo.toml&#34;}
[profile.dev]
opt-level = 0

[profile.release]
opt-level = 3
```

- 14.2. Publishing a Crate to Crates.io

&gt; Rust also has a particular kind of comment for documentation, known conveniently as a documentation comment, that will generate HTML documentation.

&gt; Documentation comments use three slashes, `///`, instead of two and support Markdown notation for formatting the text. Place documentation comments just before the item they’re documenting.

&gt; We can generate the HTML documentation from this documentation comment by running `cargo doc`.

&gt; For convenience, running `cargo doc --open` will build the HTML for your current crate’s documentation (as well as the documentation for all of your crate’s dependencies) and open the result in a web browser.

Documentation Comments as Tests
&gt; running `cargo test` will run the code examples in your documentation as tests!

Commenting Contained Items
&gt; The style of doc comment `//!` adds documentation to the item that contains the comments rather than to the items following the comments.

Exporting a Convenient Public API with pub use
&gt; The good news is that if the structure isn’t convenient for others to use from another library, you don’t have to rearrange your internal organization: instead, you can re-export items to make a public structure that’s different from your private structure by using `pub use`. 

- 14.3. Cargo Workspaces

```toml {title=&#34;Cargo.toml&#34;}
[workspace]

members = [
    &#34;adder&#34;,
]
```

```bash
$ cargo new adder
     Created binary (application) `adder` package

├── Cargo.lock
├── Cargo.toml
├── adder
│   ├── Cargo.toml
│   └── src
│       └── main.rs
└── target
```

```toml {title=&#34;Cargo.toml&#34;}
[dependencies]
add_one = { path = &#34;../add_one&#34; }
```

### Smart Pointers

### Fearless Concurrency

### Object-Oriented Programming

- 17.1. Characteristics of Object-Oriented Languages

&gt; Object-oriented programs are made up of objects. An object packages both data and the procedures that operate on that data. The procedures are typically called methods or operations.

&gt; Using this definition, Rust is object-oriented: structs and enums have data, and `impl` blocks provide methods on structs and enums. 

Rust 中使用结构体、枚举和 `impl` 块来实现了 OOP 范式的对象、数据和行为三大要素。

&gt; Another aspect commonly associated with OOP is the idea of encapsulation, which means that the implementation details of an object aren’t accessible to code using that object.

&gt; we can use the `pub` keyword to decide which modules, types, functions, and methods in our code should be public, and by default everything else is private.

Rust 使用 `pub` 关键字来控制可见性，实现了 OOP 范式的封装要求。

&gt; Inheritance is a mechanism whereby an object can inherit elements from another object’s definition, thus gaining the parent object’s data and behavior without you having to define them again.

&gt; You can do this in a limited way in Rust code using default trait method implementations

&gt; We can also override the default implementation

Rust 通过使用 Trait 可以“继承”某些共有的行为，也可以覆盖实现这些默认行为。

&gt; This is also called polymorphism, which means that you can substitute multiple objects for each other at runtime if they share certain characteristics.

&gt; Rust instead uses generics to abstract over different possible types and trait bounds to impose constraints on what those types must provide. This is sometimes called bounded parametric polymorphism.

Rust 通过泛型和 Trait 来实现多态

- 17.2. Using Trait Objects That Allow for Values of Different Types

&gt; However, trait objects are more like objects in other languages in the sense that they combine data and behavior. But trait objects differ from traditional objects in that we can’t add data to a trait object. Trait objects aren’t as generally useful as objects in other languages: their specific purpose is to allow abstraction across common behavior.

Trait 只是对行为的抽象，它并没有持有数据。这里需要注意 Trait 对象和之前所提的 Trait 约束是不同的，Trait 对象类似于 `Box&lt;dyn Trait&gt;`。

```rs
Vec&lt;Box&lt;dyn Trait&gt;&gt;
Vec&lt;T&gt; where T: Trait
```

使用 Trait 对象可以实现某种意义上的多态，而使用泛型 (以及 Trait 约束) 则无法做到，因为泛型 (以及 Trait 约束) 在编译器就会被编译成具体类型，显然无法多态。可以结合上面的例子进行思考。

&gt; when we use trait bounds on generics: the compiler generates nongeneric implementations of functions and methods for each concrete type that we use in place of a generic type parameter. The code that results from monomorphization is doing static dispatch, which is when the compiler knows what method you’re calling at compile time.

&gt; This is opposed to dynamic dispatch, which is when the compiler can’t tell at compile time which method you’re calling. In dynamic dispatch cases, the compiler emits code that at runtime will figure out which method to call.

&gt; When we use trait objects, Rust must use dynamic dispatch. The compiler doesn’t know all the types that might be used with the code that’s using trait objects, so it doesn’t know which method implemented on which type to call.

### Patterns and Matching

{{&lt; admonition &gt;}}
这一章建议搭配之前的 [6. Enums and Pattern Matching](https://doc.rust-lang.org/book/ch06-00-enums.html) 来阅读，本章是对其的扩展。
{{&lt; /admonition &gt;}}

- 18.1. All the Places Patterns Can Be Used

match Arms

```rs
match VALUE {
    PATTERN =&gt; EXPRESSION,
    PATTERN =&gt; EXPRESSION,
    PATTERN =&gt; EXPRESSION,
}
```

&gt; The particular pattern `_` will match anything, but it never binds to a variable, so it’s often used in the last match arm. 

`_` 在模式匹配中相当于一个占位符，常用于 `match` 匹配的最后一个，作为类似于 C/C&#43;&#43; `swicth-case` 的 `default` 分支。

&gt; `if let` can have a corresponding `else` containing code to run if the pattern in the `if let` doesn’t match.

&gt; Also, Rust doesn&#39;t require that the conditions in a series of `if let`, `else if`, `else if let` arms relate to each other.

Rust 还可以混用 `if let` 和 `if-else` 语句，即可以将模式匹配和条件判断结合起来，十分灵活

```rs
    if let Some(color) = favorite_color {
        println!(&#34;Using your favorite color, {color}, as the background&#34;);
    } else if is_tuesday {
        println!(&#34;Tuesday is green day!&#34;);
    } else if let Ok(age) = age {
        if age &gt; 30 {
            println!(&#34;Using purple as the background color&#34;);
        } else {
            println!(&#34;Using orange as the background color&#34;);
        }
    } else {
        println!(&#34;Using blue as the background color&#34;);
    }
```

&gt; The downside of using `if let` expressions is that the compiler doesn’t check for exhaustiveness, whereas with `match` expressions it does.

但是 `if-let` 表达式并不会检查模式匹配的全部情况，而 `match` 会强制要求检查模式匹配的所有情况

&gt; Similar in construction to `if let`, the `while let` conditional loop allows a `while` loop to run for as long as a pattern continues to match. I

```rs
    while let Some(top) = stack.pop() {
        println!(&#34;{}&#34;, top);
    }
```

&gt; In a `for` loop, the value that directly follows the keyword `for` is a pattern. For example, in `for x in y` the `x` is the pattern. 

```rs
    let v = vec![&#39;a&#39;, &#39;b&#39;, &#39;c&#39;];

    for (index, value) in v.iter().enumerate() {
        println!(&#34;{} is at index {}&#34;, value, index);
    }
```

模式匹配无处不在，`for` 循环中 `for` 关键字后面的 token 在语法分析时是按模式匹配进行分析的

&gt; Every time you&#39;ve used a `let` statement like this you&#39;ve been using patterns, although you might not have realized it! 

```rs
let PATTERN = EXPRESSION;
```

`let` 语句也是模式匹配，但是它的使用和先前的那些模式匹配相比起来不是特别灵活，这一部分在后面会进行解释

&gt; Function parameters can also be patterns. 

```rs
fn foo(x: i32) {...}
```

函数参数也是模式匹配，毕竟它本质也是一种 `let` 语句，相应的，它的灵活性也不是特别好

- 18.2. Refutability: Whether a Pattern Might Fail to Match

引入两个概念用于解释之前所提的，不同模式匹配语句的灵活性不同的问题

&gt; Patterns come in two forms: **refutable** and **irrefutable**.

&gt; Patterns that will match for any possible value passed are **irrefutable**. An example would be `x` in the statement `let x = 5;` because `x` matches anything and therefore cannot fail to match. 

&gt; Patterns that can fail to match for some possible value are **refutable**. An example would be `Some(x)` in the expression `if let Some(x) = a_value` because if the value in the `a_value` variable is `None` rather than `Some`, the `Some(x)` pattern will not match.

简单来说，就一种模式可以对任何值无条件接受，而另一种模式对一些可能的值并不接受，这两种模式的差异导致了不同模式匹配语句的灵活性不同 (因为对于任何值都可以无条件接受的话，需要对传入的值进行一定的限制，进而导致接收值的灵活性不同)。

&gt; Function parameters, `let` statements, and `for` loops can only accept **irrefutable** patterns, because the program cannot do anything meaningful when values don’t match. 

&gt; The `if let` and `while let` expressions accept refutable and irrefutable patterns

- 18.3. Pattern Syntax

&gt; Named variables are irrefutable patterns that match any value, and we’ve used them many times in the book. 

在模式匹配中使用命名变量会匹配任意值，但这也会导致在模式匹配的 Block 对该变量名称进行变量遮蔽

&gt; Because match starts a new scope, variables declared as part of a pattern inside the match expression will shadow those with the same name outside the match construct, as is the case with all variables.

```rs
    let x = Some(5);
    let y = 10;

    match x {
        Some(50) =&gt; println!(&#34;Got 50&#34;),
        Some(y) =&gt; println!(&#34;Matched, y = {y}&#34;),
        _ =&gt; println!(&#34;Default case, x = {:?}&#34;, x),
    }

    println!(&#34;at the end: x = {:?}, y = {y}&#34;, x);
```

&gt; In match expressions, you can match multiple patterns using the `|` syntax, which is the pattern or operator.

```rs
    match x {
        1 | 2 =&gt; println!(&#34;one or two&#34;),
        3 =&gt; println!(&#34;three&#34;),
        _ =&gt; println!(&#34;anything&#34;),
    }
```

&gt; The `..=` syntax allows us to match to an inclusive range of values. 

```rs
    match x {
        &#39;a&#39;..=&#39;j&#39; =&gt; println!(&#34;early ASCII letter&#34;),
        &#39;k&#39;..=&#39;z&#39; =&gt; println!(&#34;late ASCII letter&#34;),
        _ =&gt; println!(&#34;something else&#34;),
    }
```

`a..=b` 表示闭区间 $[a,b]$，而 `..` 表示开区间 $[a, b)$

&gt; We can also use patterns to destructure structs, enums, and tuples to use different parts of these values.

```rs
// struct
let p = Point { x: 0, y: 7 };
let Point { x: a, y: b } = p;
let Point { x, y } = p;
```

&gt; Rust has a shorthand for patterns that match struct fields: you only need to list the name of the struct field, and the variables created from the pattern will have the same names.

```rs
// enum
match msg {
    Message::Quit =&gt; ...
    Message::Move { x, y } =&gt; ...
    Message::Write(text) =&gt; ...
    Message::ChangeColor(r, g, b) =&gt; ...
}
```

```rs
// tuple
let ((feet, inches), Point { x, y }) = ((3, 10), Point { x: 3, y: -10 });
```

### Advanced Features

#### Unsafe Rust

&gt; Unsafe Rust exists because, by nature, static analysis is conservative. When the compiler tries to determine whether or not code upholds the guarantees, it’s better for it to reject some valid programs than to accept some invalid programs. 

&gt; if you use unsafe code incorrectly, problems can occur due to memory unsafety, such as null pointer dereferencing.

&gt; Another reason Rust has an unsafe alter ego is that the underlying computer hardware is inherently unsafe.

静态分析的保守以及系统编程的需求使得 Unsafe Rust 的出现变得合理

***unsafe superpowers***: 
- Dereference a raw pointer
- Call an unsafe function or method
- Access or modify a mutable static variable
- Implement an unsafe trait
- Access fields of `union`s

&gt; It’s important to understand that `unsafe` doesn’t turn off the borrow checker or disable any other of Rust’s safety checks: if you use a reference in `unsafe` code, it will still be checked.

`unsafe` 有一定的特权，但是即使使用 `unsafe`，Rust 的借用检查机制仍然存在，并且起作用

解引用 **裸指针** 操作只能在 `unsafe` 中使用，注意这里说的是 **解引用**，如果不涉及对裸指针的解引用操作，裸指针还是可以在 `safe` 内使用的，例如:

```rs
let mut num = 5;
let r1 = &amp;num as *const i32;
let r2 = &amp;mut num as *mut i32;

unsafe {
    println!(&#34;r1: {}&#34;, *r1);
    println!(&#34;r2: {}&#34;, *r2);
}

let address = 0x012345usize;
let r = address as *const i32;
```

&gt; Unsafe Rust has two new types called raw pointers that are similar to references. As with references, raw pointers can be immutable or mutable and are written as `*const T` and `*mut T`, respectively.

&gt; In the context of raw pointers, immutable means that the pointer can’t be directly assigned to after being dereferenced.

Different from references and smart pointers, raw pointers:

- Are allowed to ignore the borrowing rules by having both immutable and mutable pointers or multiple mutable pointers to the same location
- Aren’t guaranteed to point to valid memory
- Are allowed to be null
- Don’t implement any automatic cleanup

Rust 中的裸指针和 C/C&#43;&#43; 中的原始指针类型比较相似。而 Rust 的裸指针和引用、智能指针最大的区别在于: 裸指针不需要遵循借用规则，以及引用、智能指针必定不为空并且引用的是有效的物件 (因为是对物件的引用，所以物件必须先于引用而存在，故引用的地址也是有效的)，而裸指针可以为空 (类似于 C/C&#43;&#43; 的 NULL)，也可以指向无效的地址。因为可以为空或指向无效区域，所以裸指针不能像智能指针那样，超出作用域就自动清理指向的内容。

&gt; With all of these dangers, why would you ever use raw pointers? One major use case is when interfacing with C code

&gt; Another case is when building up safe abstractions that the borrow checker doesn’t understand.

与底层 C 代码进行交互，以及借用检查机制无法涵盖现实世界的所有关系，是 Unsafe Rust 使用的理由

&gt; Just because a function contains unsafe code doesn’t mean we need to mark the entire function as unsafe. In fact, wrapping unsafe code in a safe function is a common abstraction

将不安全的代码块封装为安全的函数，这样调用该函数时就不需要特别考虑 unsafe 部分了 (unsafe 部分由函数实现方进行考虑、封装)

&gt; Sometimes, your Rust code might need to interact with code written in another language. For this, Rust has the keyword `extern` that facilitates the creation and use of a Foreign Function Interface (FFI). An FFI is a way for a programming language to define functions and enable a different (foreign) programming language to call those functions.

&gt; The `&#34;C&#34;` ABI is the most common and follows the C programming language’s ABI.

通过 `extern` 关键字指定汇编层面使用的 ABI，可以使 Rust 程序和其他语言编写的程序进行通讯，这部分在 Rust 中叫 FFI

#### Advanced Traits

&gt; ***Associated types*** connect a type placeholder with a trait such that the trait method definitions can use these placeholder types in their signatures. 

关联类型相当于类型的占位符，常用于迭代器相关的 Trait 的定义中:

```rs
pub trait Iterator {
    type Item;

    fn next(&amp;mut self) -&gt; Option&lt;Self::Item&gt;;
}
```

结合下面的例子，并与上面的例子进行对比，思考泛型参数的 Trait 和关联类型的 Trait 的区别:

```rs
pub trait Iterator&lt;T&gt; {
    fn next(&amp;mut self) -&gt; Option&lt;T&gt;;
}
```

&gt; In other words, when a trait has a generic parameter, it can be implemented for a type multiple times, changing the concrete types of the generic type parameters each time. 

&gt; With associated types, we don’t need to annotate types because we can’t implement a trait on a type multiple times. 

默认泛型参数可以在未标注具体类型时，使用默认的具体类型

&gt; When we use generic type parameters, we can specify a default concrete type for the generic type. This eliminates the need for implementors of the trait to specify a concrete type if the default type works. You specify a default type when declaring a generic type with the `&lt;PlaceholderType=ConcreteType&gt;` syntax.

```rs
trait Add&lt;Rhs=Self&gt; {
    type Output;

    fn add(self, rhs: Rhs) -&gt; Self::Output;
}
```

当类型的方法和实现的 Trait 的方法重名时，直接通过方法名字调用的话，调用的是类型本身实现的方法而不是 Trait 的方法，要想调用 Trait 的同名方法，需要在前面指定 Trait 名字

&gt; Nothing in Rust prevents a trait from having a method with the same name as another trait’s method, nor does Rust prevent you from implementing both traits on one type. It’s also possible to implement a method directly on the type with the same name as methods from traits.

&gt; When calling methods with the same name, you’ll need to tell Rust which one you want to use.

&gt;Specifying the trait name before the method name clarifies to Rust which implementation of `fly` we want to call. 

```rs
trait Pilot {...}
trait Wizard {...}
struct Human;

impl Pilot for Human {
    fn fly(&amp;self) {...}
}

impl Wizard for Human {
    fn fly(&amp;self) {...}
}

impl Human {
    fn fly(&amp;self) {...}
}

fn main() {
    let person = Human;
    Pilot::fly(&amp;person);    // trait Pilot&#39;s fly method
    Wizard::fly(&amp;person);   // trait Wizard&#39;s fly method
    person.fly();           // type Human&#39;s fly method
}
```

&gt;  You only need to use this more verbose syntax in cases where there are multiple implementations that use the same name and Rust needs help to identify which implementation you want to call.

Rust 的 Trait 可以实现 **行为** 的继承关系 (通过继承方法的行为)

&gt; Sometimes, you might write a trait definition that depends on another trait: for a type to implement the first trait, you want to require that type to also implement the second trait. You would do this so that your trait definition can make use of the associated items of the second trait. The trait your trait definition is relying on is called a supertrait of your trait.

```rs
trait OutlinePrint: std::fmt::Display {...}

struct Point {...}

impl OutlinePrint for Point {}
```

&gt; the orphan rule that states we’re only allowed to implement a trait on a type if either the trait or the type are local to our crate. 

&gt; ***newtype pattern***, which involves creating a new type in a tuple struct.

&gt; The tuple struct will have one field and be a thin wrapper around the type we want to implement a trait for. Then the wrapper type is local to our crate, and we can implement the trait on the wrapper. 

```rs
struct Wrapper(Vec&lt;String&gt;);

impl std::fmt::Display for Wrapper {
    fn fmt(&amp;self, f: &amp;mut fmt::Formatter) -&gt; fmt::Result {
        write!(f, &#34;[{}]&#34;, self.0.join(&#34;, &#34;))
    }
}
```

#### Advanced Types

&gt; Rust provides the ability to declare a type alias to give an existing type another name. 

```rs
type Kilometers = i32;
```

作用类似于 C/C&#43;&#43; 的 `typedef` 关键字

&gt; Rust has a special type named `!` that’s known in type theory lingo as the ***empty type*** because it has no values. We prefer to call it the never type because it stands in the place of the return type when a function will never return. 

&gt;This code is read as “the function bar returns never.” Functions that return never are called diverging functions.

常用于永远不会返回的函数，这个场景在系统领域还是蛮常见的，例如系统启动后的进入的函数 `kernel_main`，它就是不可能返回的 (轮询直到关机)，或者是捕获 `panic` 后的处理函数，它也是不会返回的 (直接终止程序)

&gt; The formal way of describing this behavior is that expressions of type `!` can be coerced into any other type. 

```rs
fn bar() -&gt; ! {
    ...
}
```

Dynamically Sized Types and the Sized Trait

&gt; Rust needs to know certain details about its types, such as how much space to allocate for a value of a particular type. This leaves one corner of its type system a little confusing at first: the concept of dynamically sized types. Sometimes referred to as DSTs or unsized types, these types let us write code using values whose size we can know only at runtime.

&gt; To work with DSTs, Rust provides the `Sized` trait to determine whether or not a type’s size is known at compile time. This trait is automatically implemented for everything whose size is known at compile time. In addition, Rust implicitly adds a bound on `Sized` to every generic function. 

```rs
fn generic&lt;T&gt;(t: T) {...}
// is actually treated as though we had written this
fn generic&lt;T: Sized&gt;(t: T) {...}
```

&gt; By default, generic functions will work only on types that have a known size at compile time. However, you can use the following special syntax to relax this restriction:

```rs
fn generic&lt;T: ?Sized&gt;(t: &amp;T) {...}
```

也就是说，我们需要手动标注的只有 `?Sized` 这个 Trait (用于标识该类型不是编译时期可以确定的，而是动态类型)，`Sized` 这个 Trait 编译器会帮我们自动默认加上标注，一般不需要特别关心

#### Advanced Functions and Closures

&gt; The `fn` type is called a function pointer. Passing functions with function pointers will allow you to use functions as arguments to other functions.

&gt; Unlike closures, `fn` is a type rather than a trait, so we specify `fn` as the parameter type directly rather than declaring a generic type parameter with one of the `Fn` traits as a trait bound.

```rs
fn do_twice(f: fn(i32) -&gt; i32, arg: i32) -&gt; i32 {
    f(arg) &#43; f(arg)
}
```

&gt; Function pointers implement all three of the closure traits (`Fn`, `FnMut`, and `FnOnce`), meaning you can always pass a function pointer as an argument for a function that expects a closure. It’s best to write functions using a generic type and one of the closure traits so your functions can accept either functions or closures.

因为函数指针类型 `fn` 实现了闭包的全部三种 Trait，所以还是推荐使用 **泛型约束** 的写法来传递参数，这样既可以接收函数指针也可以接收闭包。但是当需要与其他语言交互时，其他语言可能不支持闭包，这时就只能使用函数指针 `fn` 作为参数传递了:

&gt; That said, one example of where you would want to only accept `fn` and not closures is when interfacing with external code that doesn’t have closures: C functions can accept functions as arguments, but C doesn’t have closures.

&gt; Closures are represented by traits, which means you can’t return closures directly. 

所以使用类似的技巧来返回闭包，即通过 `Box` 来包装返回的闭包

#### Macros

&gt; Fundamentally, macros are a way of writing code that writes other code, which is known as metaprogramming.

宏是关于编程本质是 ***字符串处理*** 的最好阐释

&gt; The most widely used form of macros in Rust is the declarative macro. These are also sometimes referred to as “macros by example,” “`macro_rules!` macros,” or just plain “macros.” At their core, declarative macros allow you to write something similar to a Rust `match` expression. 

```rs
#[macro_export]
macro_rules! vec {
    ( $( $x:expr ),* ) =&gt; {
        {
            let mut temp_vec = Vec::new();
            $(
                temp_vec.push($x);
            )*
            temp_vec
        }
    };
}
```

{{&lt; admonition &gt;}}
延伸阅读: [Crust of Rust: Declarative Macros]({{&lt; relref &#34;./declarative-macros.md&#34; &gt;}})
{{&lt; /admonition &gt;}}

&gt; The second form of macros is the procedural macro, which acts more like a function (and is a type of procedure). Procedural macros accept some code as an input, operate on that code, and produce some code as an output rather than matching against patterns and replacing the code with other code as declarative macros do.

```rs
use proc_macro;

#[some_attribute]
pub fn some_name(input: TokenStream) -&gt; TokenStream {
}
```

{{&lt; admonition &gt;}}
延伸阅读: [Procedural Macros](https://www.youtube.com/playlist?list=PLqbS7AVVErFgwC_HByFYblghsDsD5wZDv)
{{&lt; /admonition &gt;}}

### Final Project: Web Server

Documentation:


## References

- [The Rust Programming Language - Brown University](https://rust-book.cs.brown.edu/)
- Visualizing memory layout of Rust\&#39;s data types: [录影](https://www.youtube.com/watch?v=7_o-YRxf_cc&amp;t=0s) / [中文翻译](https://www.bilibili.com/video/BV1KT4y167f1)
- [Rust 语言圣经 (Rust Course)](https://course.rs/about-book.html)
- [Learn Rust the Dangerous Way](https://cliffle.com/p/dangerust/)
- [pretzelhammer\&#39;s Rust blog](https://github.com/pretzelhammer/rust-blog)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/why-rust/  

