# Crust of Rust: Declarative Macros


整理自 [John Gjengset 的影片]()

<!--more-->

## 影片注解

### regex

macro 可以使用以下 3 种分隔符来传入参数 (注意花括号 `{}` 的需要与 macro 名之间进行空格，末尾不需要分号，这是因为 `{}` 会被编译器视为一个 statement，无需使用 `;` 来进行分隔):

```rs
macro_rules! avec {
  () => {};
  ...
}

avec!();
avec![];
avec! {}
```

> macro 定义内的 `()` 和 `{}` 也都可以使用 `()`, `[]`, `{}` 之间的任意一种，并不影响调研 macro 的分隔符的使用（都是 3 任选 1 即可），不过推荐在 macro 定义内使用 `()` 和 `{}` 搭配。

如果需要在 macro 传入的 synatx 中使用正则表达式 (regex)，则需要在外面使用 `$()` 进行包装: 

```rs
($($elem:expr),* $(,)?) => {{
    let mut v = Vec::new();
    $(v.push($elem);)*
    v
}};
```

同样的，可以在 macro 体内使用 regex 对参数进行解包装，语法是相同的：

```rs
$(...)[delimiter](+|*|?)
```

其中分隔符 (delimiter) 是可选的。它会根据内部所包含的参数 `$(...)` (本例中是 `$(elem)`) 来进行自动解包装，生成对应次数的 statement，如果有分隔符 (delimiter) 也会生成对应的符号。

### cargo expand

cargo-expand 可以将宏展开，对于宏的除错非常方便，可以以下命令来安装:

```rs
$ cargo install cargo-expand
```

然后可以通过以下命令对 macro 进行展开:

```rs
$ cargo expand
```

使用以下命令可以将 unit tests 与 cargo expand 结合起来，即展开的是 unit tests 之后的完整代码:

```rs
$ cargo expand --lib tests
```

### scope

由于 Rust 中 macro 和 normal code 的作用域不一致，所以像 C 语言那种在 macro 中定义变量或在 macro 中直接修改已有变量是不可行的，操作这种 lvalue 的情况需要使用 macro 参数进行传入，否则无法通过编译。

```rs
// cannot compile
macro_rules! avec {
    () => {
        let x = 1;
    }
}

// cannot compile
macro_rules! avec {
    () => {
      x = 42;
    }
}

// can compile
macro_rules! avec {
    ($x: ident) => {
        $x += 1;
    }
}
```

### statements

在 Rust macro 中，如果需要将传入的 syntax 转换成多个 statements，需要使用 `{}` 进行包装:

```rs
() => {{
    ...
}}
```

其中第一对 `{}` 是 macro 语法所要求的的，第二对 `{}` 则是用于包装 statements 的 `{}`，使用 cargo expand 进行查看会更直观。

### delimiter

注意 macro 中传入的 syntax，其使用的类似于 `=>` 的分隔符是有限的，例如不能使用 `->` 作为分隔符，具体可以查阅手册。

```rs
($arg1:ty => $arg2:ident) => {
    type $arg2 = $arg1;
};
```

{{< admonition tip >}}
当 declarative macros 变得复杂时，它的可读性会变得很差，这时候需要使用 procedural macros。但是 procedural macros 需要多花费一些编译周期 (compilition cycle)，因为需要先对 procedural macros 进行编译，再编译 lib/bin 对应的源文件。
{{< /admonition >}}

### calculating

编写 macro 时传入的参数如果是 expression，需要先对其进行计算，然后使用 `clone` 方法来对该计算结果进行拷贝，这样能最大限度的避免打破 Rust 所有权制度的限制。

```rs
($elem:expr; $count:expr) => {{
    let mut v = Vec::new();
    let x = $elem;
    for _ in 0..$count {
        v.push(x.clone());
    }
    v
}};
```

这样传入 `y.take().unwrap()` 作为宏的 `elem` 参数就不会产生 panic。

{{< admonition tip >}}
对于会导致 compile fail 的 unit test，无法使用通常的 unit test 来测试，但是有一个技巧：可以使用 Doc-tests 的方式来构建（需要标记 `compile_fail`，如果不标记则默认该测试需要 compile success）

```rs
/// ```compile_fail
/// let v: Vec<u32> = vecmac::avec![42; "foo"];
/// ```
#[allow(dead_code)]
struct CompileFailTest;
```
{{< /admonition >}}

### trait

Rust 中的 macro 无法限制传入参数的 Trait，例如不能限制参数必须实现 Clone 这个 Trait。

`::std::iter` 带有前置双冒号 `::` 的语法，是在没有显式引入 `use std::iter` 模块的情况下访问该模块的方式。在这种情况下，`::std::iter` 表示全局命名空间 (global namespace) 中的 std::iter 模块，即标准库中的 iter 模块。由于 macro 需要进行 export 建议编写 macro 时尽量使用 `::` 这类语法。

{{< admonition tip >}}
计算 vector 的元素个数时使用 `()` 引用 `[()]` 进行计数是一个常见技巧，因为 `()` 是 zero size 的，所以并不会占用栈空间。其他的元素计数方法可以参考 [The Little Book of Rust Macros](https://veykril.github.io/tlborm/) 的 2.5.2 Counting 一节。
{{< /admonition >}}

{{< admonition info >}}
- [ ] 尝试使用 declarative macro 来实现 HashMap 的初始化语法
- [x] 尝试阅读 `vec` macro 在 std 库的实现
{{< /admonition >}}

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

> Crate [std](https://doc.rust-lang.org/std/index.html) 
> ---
> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

- Macro [std::vec](https://doc.rust-lang.org/std/macro.vec.html)

- Struct [std::vec::Vec](https://doc.rust-lang.org/std/vec/struct.Vec.html)
    - Method [std::vec::Vec::with_capacity](https://doc.rust-lang.org/std/vec/struct.Vec.html#method.with_capacity)
    - method [std::vec::Vec::extend](https://doc.rust-lang.org/std/vec/struct.Vec.html#method.extend)
    - method [std::vec::Vec::resize](https://doc.rust-lang.org/std/vec/struct.Vec.html#method.resize)

- Module [std::iter](https://doc.rust-lang.org/std/iter/index.html)
    - Function [std::iter::repeat](https://doc.rust-lang.org/std/iter/fn.repeat.html)
    - method [std::iter::Iterator::take](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.take)

- method [std::option::Option::take](https://doc.rust-lang.org/std/option/enum.Option.html#method.take)

## References

原版的 **The Little Book of Rust Macros** 在 Rust 更新新版本后没有持续更新，另一位大牛对这本小册子进行了相应的更新:

- [The Little Book of Rust Macros](https://veykril.github.io/tlborm/)

Rust语言中文社区也翻译了该小册子:

- [Rust 宏小册](https://zjp-cn.github.io/tlborm/)

---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/declarative-macros/  

