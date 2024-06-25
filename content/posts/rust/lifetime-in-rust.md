---
title: "Rust Lifetime: 由浅入深理解生命周期"
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
  - Lifetime
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

> 从基础到进阶讲解探讨 Rust 生命周期，不仅仅是 lifetime kata，还有更多的 lifetime 资料，都来讲解和探讨，从「入门 Rust」到「进阶 Rust」

<!--more-->

- 整理自 B 站 UP 主 [@这周你想干啥](https://space.bilibili.com/50713701) 的 {{< link href="https://space.bilibili.com/50713701/channel/collectiondetail?sid=1453665" content="教学影片合集" external-icon=true >}}

{{< admonition >}}
学习 John Gjengset 的教学影片 [Subtying and Variance](https://www.youtube.com/watch?v=iVYWDIW71jk) 时发现自己对 Rust 生命周期 (lifetime) 还是不太理解，于是便前来补课 :rofl: 
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

{{< admonition >}}
从正确写法 (有两个生命周期标注) 出发，探讨只使用一个生命周期标注的情况比较符合人类的思维，这也是原文安排的顺序。

如果传入的参数的生命周期均为已知，则同一生命周期标注代表的生命周期长度为，已知生命周期的最小值。如果传入的参数的生命周期存在未知的，则同一生命周期标注的生命周期长度为已知的生命周期的最小值，并且要求未知生命周期长度的参数的生命周期不得少于该最小值。
{{< /admonition >}}

## struct / enum 生命周期标注

{{< image src="/images/rust/rust-lifetime-05.png" >}}

struct / enum 的生命周期推导可以从 **构造函数** 来理解，本质上和之前所介绍的函数的生命周期标注一致。

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

## 生命周期型变和绑定

{{< image src="/images/rust/rust-lifetime-07.png" >}}

因为 Rust 是没有继承的概念，所以下面以 scala 来对类型的型变举例子进行讲解 (但是不需要你对 Scala 有任何了解):

```scala
class A
class B extends A // B is subclass of A

private def f1(a: A): Unit = {
  println("f1 works!")
}

def main(args: Array[STring]): Unit = {
  val a = new A
  val b = new B

  f1(a) // succeed
  f1(b) // succeed
}
```

这个例子很好理解，因为 `B` 是 `A` 的子类，所以作为参数传入函数 `f1` 显然是可以接受的。但是当泛型 (generic) 和子类 (subclass) 结合起来时，就变得复杂了:

```scala
class A
class B extends A // B is subclass of A
class Foo[T]      // generic

private def f1(a: Foo[A]): Unit = {
  println("f1 works!")
}

def main(args: Array[STring]): Unit = {
  val foo_a = new Foo[A]
  val foo_b = new Foo[B]

  f1(a) // succeed
  f1(b) // error
}
```

在编译器看来，虽然 `B` 是 `A` 的子类，但是编译器认为 `Foo[A]` 和 `Foo[B]` 是两个独立的类型，这个被称为 **不变 (invariant)**。而我们的直觉是，这种情况 `Foo[B]` 应该是 `Foo[A]` 的子类，这就引出了 **协变 (covariant)**。将上面例子的第 3 行的 `Foo` 定义修改如下:

```scala
class Foo[+T]      // covariant
```

就可以让编译器推导出 `Foo[B]` 是 `Foo[A]` 的子类，进而让第 14 行编译通过。

除此之外，还有 **逆变 (contra-variant)**，它会将子类关系反转。将上面例子的第 3 行的 `Foo` 定义修改如下:

```scala
class Foo[-T]      // contra-variant
```

编译器就会推导出关系: `Foo[A]` 是 `Foo[B]` 的子类，这个关系刚好是 `A` 和 `B` 的反转。

在 Scala 中，函数之间的关系也体现了协变和逆变，即 **参数是逆变的，返回值是协变的**:

```scala
class A
class B extends A // B is subclass of A
class C extends B // C is subclass of B
/* 
 * `A => C` is subclass of `B => B` 
 */
```

为什么 `A => C` 是 `B => B` 的子类呢？其实也很好理解，`B => B` 的返回值是 `B`，这个返回值可以用 `C` 来代替，但不能用 `A` 来代替，这显然满足协变。`B => B` 的参数是 `B`，这个参数可以用 `A` 来代替而不能用 `C` 来代替 (因为有一部分 `B` 不一定是 `C`，而 `B` 则一定是 `A`)，这满足逆变。

{{< image src="/images/rust/rust-lifetime-08.png" >}}

`T` 可以表示所有情况: ownership, immutable reference, mutable reference，例如 `T` 可以表示 `i32`, `&i32`, `&mut i32` (如果你使用过 `into_iterator` 的话应该不陌生)

`T: 'a` 是说：如果 `T` 里面含有引用，那么这个引用的生命周期必须是 `'a` 的子类，即比 `'a` 长或和 `'a` 相等。`T: 'static` 也类似，表示 `T` 里面的引用 (如果有的话)，要么比 `'static` 长或和 `'static` 相等，因为不可能有比 `'static` 更长的生命周期，所以这个标注有两种表示意义表: **要么 `T` 里面的引用和 `'static` 一样长，要么 `T` 里面没有引用只有所有权 (owneship)**。

- The Rust Reference: [Subtyping and Variance](https://doc.rust-lang.org/reference/subtyping.html)

{{< image src="/images/rust/rust-variance1.png" >}}

- The Rustonomicon: [Subtyping and Variance](https://doc.rust-lang.org/nomicon/subtyping.html)

{{< image src="/images/rust/rust-variance2.png" >}}

基本和我们之前所说的一致，这里需要注意一点: 凡是涉及可变引用的 `T`，都是不变 (invariant)。这也很好理解，因为可变引用需要保证所引用的类型 `T` 是一致并且是唯一的，否则会扰乱 Rust 的引用模型。因为可变引用不仅可以改变所指向的 object 的内容，还可以改变自身，即改变指向的 object，如果此时 `T` 不是不变 (invariant) 的，那么可以将这个可变引用指向 `T` 的子类，这会导致该可变引用指向的 object 被可变借用一次后无法归还，从而导致后续再也无法引用该 object。此外还会导致原本没有生命周期约束的两个独立类型，被生命周期约束，具体见后面的例子。

```rs
struct Foo<'a> {
    _phantom: PhantomData<&'a i32>,
}

fn foo<'short, 'long: 'short>( // long is subclass of short
    mut short_foo: Foo<'short>,
    mut long_foo:  Foo<'long>,
) {
    short_foo = long_foo;   // succeed
    long_foo  = short_foo;  // error
}
```

下面是一个可变引用的例子。参数 `short_foo` 和 `long_foo` 没有关系，是两个独立的类型，所以无法相互赋值，这保证了可变引用的模型约束。除此之外，如果可变引用的型变规则不是不变 (inariant) 则会导致 `short_foo` 和 `long_foo` 在函数 `foo` 调用后的生命周期约束为:   

- `short_foo` $\leq$ `long_foo` (协变) 
- `long_foo` $\leq$ `short_foo` (逆变)   

而它们本身可能并没有这种约束，生命周期是互相独立的。

```rs
struct Foo<'a> {
    _phantom: PhantomData<&'a i32>,
}

fn foo<'short, 'long: 'short>( // long is subclass of short
    mut short_foo: &mut Foo<'short>,
    mut long_foo:  &mut Foo<'long>,
) {
    short_foo = long_foo;   // error
    long_foo  = short_foo;  // error
}
```

## Homework

{{< admonition info >}}
- [ ] 阅读博客 [Common Rust Lifetime Misconceptions](https://github.com/pretzelhammer/rust-blog/blob/master/posts/common-rust-lifetime-misconceptions.md) 以对 Rust 生命周期及常见的误区有充分认知
- [ ] 完成 [LifetimeKata](https://tfpk.github.io/lifetimekata/) 的相关练习
{{< /admonition >}}

### LifetimeKata 

- Chapter 1: Lifetimes Needed
> Lifetime Annotations are used to help the compiler understand what\'s going on when it can\'t rely on scope brackets (i.e. across function boundaries; and within structs and enums).

- Chapter 3: Lifetime Elision
> We saw that the compiler was unable to automatically tell how references in the arguments or return values might relate to each other. This is why we needed to tell the compiler that the references related to each other.

即 Rust 编译器可以通过作用范围来确定引用是否合法，进而防止 **悬垂引用**，但是对于函数调用或者是结构体的构造，Rust 编译器就无法通过上下文来进行检查了 (因为每次函数调用或结构体构造使用的引用都可能不同)，所以需要生命周期标注，它的作用是让编译器按照标注指定的关系对引用进行检查。

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

## References

- [Common Rust Lifetime Misconceptions](https://github.com/pretzelhammer/rust-blog/blob/master/posts/common-rust-lifetime-misconceptions.md)
- [The Rust Reference](https://doc.rust-lang.org/reference/)
- [泛型中的型变 (协变，逆变，不可变)](https://juejin.cn/post/6952434934589947912)
- [Variant Types and Polymorphism](https://www.cs.cornell.edu/courses/cs3110/2012sp/lectures/lec04-types/lec04.html)
