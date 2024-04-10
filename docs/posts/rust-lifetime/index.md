# Rust Lifetime: 由浅入深理解生命周期


> 从基础到进阶讲解探讨 Rust 生命周期，不仅仅是 lifetime kata，还有更多的 lifetime 资料，都来讲解和探讨，从「入门 Rust」到「进阶 Rust」

<!--more-->

- 整理自 B 站 UP 主 [@这周你想干啥](https://space.bilibili.com/50713701) 的 [教学影片合集](https://space.bilibili.com/50713701/channel/collectiondetail?sid=1453665)

{{< admonition >}}
学习 John Gjengset 的教学影片 [Subtying and Variance](https://www.youtube.com/watch?v=iVYWDIW71jk) 时发现自己对 Rust 生命周期 (lifetime) 还是不太理解，于是便前来补课 :rofl: 
同时完成 [LifetimeKata](https://tfpk.github.io/lifetimekata/) 的练习。
{{< /admonition >}}

## 引用 & 生命周期

{{< image src="/images/rust/rust-lifetime-01.png" >}}

## 生命周期标注

{{< image src="/images/rust/rust-lifetime-02.png" >}}

在 **单线程** 的程序中，通过函数参数传入的引用，无论其生命周期标注，它的生命周期在该函数的函数体范围内都是有效的。因为从 **状态机** 模型来考虑，该函数没有传入的引用的所有权 (因为是通过参数传入的)，所以该函数不可能在其函数体范围内某一节点，就结束传入的引用的生命周期。但是在 **多线程** 的程序，上述规则就不一定成立了。

```rs
fn split<'a, 'b>(text: &'a str, delimiter: &'b str) {...}
```

单线程情况下，参数 `text` 和 `delimiter` 在函数 `split` 范围内都是有效的。

也因为这个状态机模型，Rust 的生命周期对于参数在函数体内的使用的影响并不大，主要影响的是涉及生命周期的参数或返回值在 **函数调用后的生命周期使用约束**，下面给出一些技巧:

{{< admonition tip >}}
**最大共同生命周期**: 从引用的当前共同使用开始，直到任一引用对应的 object 消亡，即其生命周期结束。

当以相同的生命周期标注，来对函数参数的生命周期进行标注时，其表示参数的最大共同生命周期，例如:

```rs
fn f<'a>(x: &'a i32, y: &'a i32, z: &'a i32) {...}
```

生命周期 `'a` 表示参数 `x`, `y`, `z` 的最大共同生命周期，即 `x`, `y`, `z` 可以共同存活的最大生命周期。

当以相同的生命周期标注，来对函数参数和返回值的生命周期进行标注时，其表示返回值的生命周期必须在参数的生命周期内，例如:

```rs
fn f<'a>(x: &'a i32) -> &'a i32 {...}
```

生命周期 `'a` 表示返回值的生命周期必须在参数 `x` 的生命周期内，即返回值的生命周期是参数和返回值的最大共同生命周期。所以在返回值可以使用的地方，参数都必须存活，这也是常出现问题的地方。

最后看一下将这两个技巧结合起来的一个例子:

```rs
fn f<'a>(x: &'a i32, y: &'a i32) -> &'a i32 {...}
```

参数取最大生命周期在容器情况下会被另一个技巧取代，即容器和容器内部元素都被标注为相同的生命周期，这种情况会让容器的生命周期和容器内的元素的生命周期保持一致。这是因为隐式规则: 容器的生命周期 $\leq$ 容器内元素的生命周期，这显然已经满足了最大生命周期的要求，而此时标注一样的生命周期，会被编译器推导为二者的生命周期相同，即 **容器的生命周期和容器内的元素的生命周期一致**:

```rs
fn strtok(x: &'a mut &'a str, y: char) {...}
```
{{< /admonition >}}

## 生命周期在函数上的省略规则

{{< image src="/images/rust/rust-lifetime-03.png" >}}

The Rust Reference: [Lifetime elision](https://doc.rust-lang.org/reference/lifetime-elision.html)

- Each elided lifetime in the parameters becomes a distinct lifetime parameter.
- If there is exactly one lifetime used in the parameters (elided or not), that lifetime is assigned to all elided output lifetimes.
- If the receiver has type `&Self` or `&mut Self`, then the lifetime of that reference to Self is assigned to all elided output lifetime parameters.

正如投影片所说，虽然有生命周期的省略规则，但有时并不符合我们的预期，这时候需要我们手动标注。这种情况常出现于可变引用 `&mut self` 的使用:

```rs
struct S {}

impl S {
    fn as_slice_mut<'a>(&'a mut self) -> &'a [u8] {...}
}

let s: S = S{};
let x: &[u8] = s.as_slice_mut();    //---
...                                 // |
...                                 // | scope
...                                 // |
// end of s's lifetime              //---
```

在上面例子中，由于将方法 `as_slice_mut` 的可变引用参数和返回值的生命周期都标注为相同 `'a`，所以在范围 scope 中，在编译器看来 `s` 的可变引用仍然有效 (回想一下之前的参数和返回值的生命周期推导技巧)，所以在这个范围内无法使用 `s` 的引用 (不管是可变还是不可变，回想一下 Rust 的引用规则)，这是一个很常见的可变引用引起非预期的生命周期的例子，下一节会进一步介绍。

## 关注可变引用

{{< image src="/images/rust/rust-lifetime-04.png" >}}

```rs
fn insert_value<'a>(my_vec: &'a mut Vec<&'a i32>, value: &'a i32) {...}
```

这个例子和之前的例子很类似，同样的，使用我们的参数生命周期推导技巧，调用函数 `insert_value` 后，当参数 `vec` 和 `value` 的最大共同生命周期的范围很广时，这时就需要注意，在这个范围内，我们无法使用 `my_vec` 对应的 object 的任何其它引用 (因为编译器会认为此时还存在可变引用 `my_vec`)，从而编译错误。这就是容器和引用使用相同生命周期标注，而导致的强约束。为避免这种非预期的生命周期，应当将函数原型改写如下:

```rs
fn insert_value<'a, 'b>(my_vec: &'a mut Vec<&'b i32>, value: &'b i32) {...}
```

> 这样改写会包含一个隐式的生命周期规则: `'a` $\leq$ `'b`，这很好理解，容器的生命周期应该比所引用的 object 短，这个隐式规则在下一节的 struct/enum 的生命周期标注非常重要。

## struct / enum 生命周期标注

{{< image src="/images/rust/rust-lifetime-05.png" >}}

struct / enum 的生命周期标注也可以通过之前所提的 **状态机** 模型来进行理解，因为 struct / enum 本身不具备引用对应的 object 的所有权，在进行方法 (method) 调用时并不能截断引用对应的 object 的生命周期。

struct / enum 生命周期标注主要需要特别注意一点，就是 struct / enum 本身的可变引用的生命周期标注，最好不要和为引用的成员的生命周期的标注，标注为相同，因为这极大可能会导致 **生命周期强约束**，例如:

```rs
fn strtok(x: &mut 'a Vec<'a i32>, y: &'a i32) {...}
```

如果参数 `Vec<'a i32>` 的 vector 里的 `i32` 引用的生命周期是 `static` 的话，依据我们之前所提的技巧，会将可变引用 `&'a mut` 的生命周期也推导为 `static`，这就导致再也无法借用 `x` 对应的 object。

## `'static` 和 `'_`

{{< image src="/images/rust/rust-lifetime-06.png" >}}

```rs
fn foo(_input: &'a str) -> 'static str {
    "abc"
}
```

如果不进行 `static` 生命周期标注，依据省略规则，编译器会把返回值的生命周期推导为 `'a`，即和输入参数一样，这就不符合我们预期使用了。

如果使用 `static` 标注 struct / enum 里的成员，则无需标注 struct / enum 的生命周期，因为 `static` 表示在整个程序运行起见都有效，没必要对容器进行生命周期标注。

```rs
struct UniqueWords {
    sentence: &'static str,
    unique_words: Vec<&'static str>,
}

impl UniqueWords {...}
```

在没有使用到 struct 的生命周期标注时，impl 可以不显式指明生命周期，而是通过 `'_` 让编译器自行推导:

```rs
struct Counter<'a> {
    inner: &'a mut i32,
}

impl Counter<'_> {
  fn increment(&mut self) {...}
}
// is the same as
impl<'a> Counter<'a> {
  fn increment(&mut self) {...}
}
```

函数返回值不是引用，但是返回值类型里有成员是引用，依据省略规则，编译器无法自行推导该成员的生命周期，此时可以通过 `'_` 来提示编译器依据省略规则，对返回值的成员的生命周期进行推导:

```rs
struct StrWrap<'a>(&'a str);

fn make_wrapper(string: &str) -> StrWrap<'_> {...}
// is the same as
fn make_wrapper<'a>(string: &'a str) -> StrWrap<'a> {...}
```

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

## References

- [LifetimeKata](https://tfpk.github.io/lifetimekata/)
- [The Rust Reference](https://doc.rust-lang.org/reference/)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/rust-lifetime/  

