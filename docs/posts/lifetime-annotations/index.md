# Crust of Rust: Lifetime Annotations


&gt; We&#39;re going to investigate a case where you need multiple explicit lifetime annotations. We explore why they are needed, and why we need more than one in this particular case. We also talk about some of the differences between the string types and introduce generics over a self-defined trait in the process.

&lt;!--more--&gt;

- 整理自 [John Gjengset 的影片](https://www.youtube.com/watch?v=rAl-9HwD858)

## C 语言中的 lifetime

Rust 中的 lifetime 一向是一个难点，为了更好地理解这一难点的本质，建议阅读 C 语言规格书关于 lifetime 的部分，相信你会对 Rust 的 lifetime 有不同的看法。

C11 [6.2.4] **Storage durations of objects**

&gt; An object has a storage duration that determines its lifetime. There are four storage
durations: static, thread, automatic, and allocated.

## 影片注解

### cargo check

cargo check 可以给出更简洁的提示，例如相对于编译器给出的错误信息，它会整合相同的错误信息，从而提供简洁切要的提示信息。而且它是一个静态分析工具，不需要进行编译即可给出提示，所以速度会比编译快很多，在大型项目上尤为明显。

### ref

影片大概 49 分时提到了

```rs
if let Some(ref mut remainder) = self.remainder {...} 
```

`ref` 的作用配合 `if let` 语句体的逻辑可以体会到 pointer of pointer 的美妙之处。

因为在 pattern match 中形如 `&amp;mut` 这类也是用于 pattern match 的，不能用于获取 reference，这也是为什么需要使用 `ref mut` 这类语法来获取 reference 的原因。

### operator ?

影片大概 56 分时提到了

```rs
let remainder = self.remainder.as_mut()?;
```

为什么使用之前所提的 `let remainder = &amp;mut self.remainder?;` 这是因为使用 `?` 运算符返回的是内部值的 copy，所以这种情况 `remainder` 里是 `self.remainder?` 返回的值 (是原有 `self.remainder` 内部值的 copy) 的 reference

### &amp;str vs String

影片大概 1:03 时提到了 `str` 与 `String` 的区别，个人觉得讲的很好：

```rs
str -&gt; [char]
&amp;str -&gt; &amp;[char] // fat pointer (address and size)
String -&gt; Vec&lt;char&gt;

String -&gt; &amp;str (cheap -- AsRef)
&amp;str -&gt; String (expensive -- memcpy)
```

对于 `String` 使用 `&amp;*` 可以保证将其转换成 `&amp;str`，因为 `*` 会先将 `String` 转换成 `str`。当然对于函数参数的 `&amp;str`，只需传入 `&amp;String` 即可自动转换类型。

### lifetime

可以将结构体的 lifetime 的第一个 (一般为 `&#39;a`) 视为实例的 lifetime，其它的可以表示与实例 lifetime 无关的 lifetime。由于 compiler 不够智能，所以它会将实例化时传入参数的 lifetime 中相关联的最小 lifetime 视为实例的 lifetime 约束 (即实例的 lifetime 包含于该 lifetime 内)。

当在实现结构体的方法或 Trait 时，如果在实现方法时无需使用 lifetime 的名称，则可以使用匿名 lifetime `&#39;_`，或者在编译器可以推推导出 lifetime 时也可以使用匿名 lifetime `&#39;_`。

- only lifetime

```rs
struct Apple&lt;&#39;a&gt; {
    owner: &amp;&#39;a Human,
}

impl Apple&lt;&#39;_&gt; {
    ...
}
```

- lifetime and generic

```rs
struct Apple&lt;&#39;a, T&gt; {
    owner: &amp;&#39;a T,
}

impl&lt;T&gt; Apple&lt;&#39;_, T&gt; {
    ...
}
```

- compiler can know lifetime

```rs
pun fn func(&amp;self) -&gt; Apple&lt;&#39;_, T&gt; {
    ...
}
```

## Documentations

这里列举视频中一些概念相关的 documentation 

&gt; 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

&gt; 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

- [Keywords](https://doc.rust-lang.org/std/index.html#keywords)
  - Keyword [SelfTy](https://doc.rust-lang.org/std/keyword.SelfTy.html)
  - Keyword [ref](https://doc.rust-lang.org/std/keyword.ref.html)

- Trait [std::iter::Iterator](https://doc.rust-lang.org/std/iter/trait.Iterator.html)
  - method [std::iter::Iterator::eq](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.eq)
  - method [std::iter::Iterator::collect](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.collect)
  - method [std::iter::Iterator::position](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.position)
  - method [std::iter::Iterator::find](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.find)

- Enum [std::option::Option](https://doc.rust-lang.org/std/option/enum.Option.html#)
  - method [std::option::Option::take](https://doc.rust-lang.org/std/option/enum.Option.html#method.take)
  - method [std::option::Option::as_mut](https://doc.rust-lang.org/std/option/enum.Option.html#method.as_mut)
  - method [std::option::Option::expect](https://doc.rust-lang.org/std/option/enum.Option.html#method.expect)

- Primitive Type [str](https://doc.rust-lang.org/std/primitive.str.html#)
  - method [str::find](https://doc.rust-lang.org/std/primitive.str.html#method.find)
  - method [str::char_indices](https://doc.rust-lang.org/std/primitive.str.html#method.char_indices)

- Trait [std::ops::Try](https://doc.rust-lang.org/std/ops/trait.Try.html)
- Macro [std::try](https://doc.rust-lang.org/std/macro.try.html)
- method [char::len_utf8](https://doc.rust-lang.org/std/primitive.char.html#method.len_utf8)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/lifetime-annotations/  

