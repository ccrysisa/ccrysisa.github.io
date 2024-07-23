# Rust Lifetime: 由浅入深理解生命周期


&gt; 从基础到进阶讲解探讨 Rust 生命周期，不仅仅是 lifetime kata，还有更多的 lifetime 资料，都来讲解和探讨，从「入门 Rust」到「进阶 Rust」

&lt;!--more--&gt;

- 整理自 B 站 UP 主 [@这周你想干啥](https://space.bilibili.com/50713701) 的 {{&lt; link href=&#34;https://space.bilibili.com/50713701/channel/collectiondetail?sid=1453665&#34; content=&#34;教学影片合集&#34; external-icon=true &gt;}}

{{&lt; admonition &gt;}}
学习 John Gjengset 的教学影片 [Subtying and Variance](https://www.youtube.com/watch?v=iVYWDIW71jk) 时发现自己对 Rust 生命周期 (lifetime) 还是不太理解，于是便前来补课 :rofl: 
{{&lt; /admonition &gt;}}

## 引用 &amp; 生命周期

{{&lt; image src=&#34;/images/rust/rust-lifetime-01.png&#34; &gt;}}

## 生命周期标注

{{&lt; image src=&#34;/images/rust/rust-lifetime-02.png&#34; &gt;}}

在 **单线程** 的程序中，通过函数参数传入的引用，无论其生命周期标注，它的生命周期在该函数的函数体范围内都是有效的。因为从 **状态机** 模型来考虑，该函数没有传入的引用的所有权 (因为是通过参数传入的)，所以该函数不可能在其函数体范围内某一节点，就结束传入的引用的生命周期。但是在 **多线程** 的程序，上述规则就不一定成立了。

```rs
fn split&lt;&#39;a, &#39;b&gt;(text: &amp;&#39;a str, delimiter: &amp;&#39;b str) {...}
```

单线程情况下，参数 `text` 和 `delimiter` 在函数 `split` 范围内都是有效的。

也因为这个状态机模型，Rust 的生命周期对于参数在函数体内的使用的影响并不大，主要影响的是涉及生命周期的参数或返回值在 **函数调用后的生命周期使用约束**，下面给出一些技巧:

{{&lt; admonition tip &gt;}}
**最大共同生命周期**: 从引用的当前共同使用开始，直到任一引用对应的 object 消亡，即其生命周期结束。

当以相同的生命周期标注，来对函数参数的生命周期进行标注时，其表示参数的最大共同生命周期，例如:

```rs
fn f&lt;&#39;a&gt;(x: &amp;&#39;a i32, y: &amp;&#39;a i32, z: &amp;&#39;a i32) {...}
```

生命周期 `&#39;a` 表示参数 `x`, `y`, `z` 的最大共同生命周期，即 `x`, `y`, `z` 可以共同存活的最大生命周期。

当以相同的生命周期标注，来对函数参数和返回值的生命周期进行标注时，其表示返回值的生命周期必须在参数的生命周期内，例如:

```rs
fn f&lt;&#39;a&gt;(x: &amp;&#39;a i32) -&gt; &amp;&#39;a i32 {...}
```

生命周期 `&#39;a` 表示返回值的生命周期必须在参数 `x` 的生命周期内，即返回值的生命周期是参数和返回值的最大共同生命周期。所以在返回值可以使用的地方，参数都必须存活，这也是常出现问题的地方。

最后看一下将这两个技巧结合起来的一个例子:

```rs
fn f&lt;&#39;a&gt;(x: &amp;&#39;a i32, y: &amp;&#39;a i32) -&gt; &amp;&#39;a i32 {...}
```

参数取最大生命周期在容器情况下会被另一个技巧取代，即容器和容器内部元素都被标注为相同的生命周期，这种情况会让容器的生命周期和容器内的元素的生命周期保持一致。这是因为隐式规则: 容器的生命周期 $\leq$ 容器内元素的生命周期，这显然已经满足了最大生命周期的要求，而此时标注一样的生命周期，会被编译器推导为二者的生命周期相同，即 **容器的生命周期和容器内的元素的生命周期一致**:

```rs
fn strtok(x: &amp;&#39;a mut &amp;&#39;a str, y: char) {...}
```
{{&lt; /admonition &gt;}}

## 生命周期在函数上的省略规则

{{&lt; image src=&#34;/images/rust/rust-lifetime-03.png&#34; &gt;}}

The Rust Reference: [Lifetime elision](https://doc.rust-lang.org/reference/lifetime-elision.html)

- Each elided lifetime in the parameters becomes a distinct lifetime parameter.
- If there is exactly one lifetime used in the parameters (elided or not), that lifetime is assigned to all elided output lifetimes.
- If the receiver has type `&amp;Self` or `&amp;mut Self`, then the lifetime of that reference to Self is assigned to all elided output lifetime parameters.

正如投影片所说，虽然有生命周期的省略规则，但有时并不符合我们的预期，这时候需要我们手动标注。这种情况常出现于可变引用 `&amp;mut self` 的使用:

```rs
struct S {}

impl S {
    fn as_slice_mut&lt;&#39;a&gt;(&amp;&#39;a mut self) -&gt; &amp;&#39;a [u8] {...}
}

let s: S = S{};
let x: &amp;[u8] = s.as_slice_mut();    //---
...                                 // |
...                                 // | scope
...                                 // |
// end of s&#39;s lifetime              //---
```

在上面例子中，由于将方法 `as_slice_mut` 的可变引用参数和返回值的生命周期都标注为相同 `&#39;a`，所以在范围 scope 中，在编译器看来 `s` 的可变引用仍然有效 (回想一下之前的参数和返回值的生命周期推导技巧)，所以在这个范围内无法使用 `s` 的引用 (不管是可变还是不可变，回想一下 Rust 的引用规则)，这是一个很常见的可变引用引起非预期的生命周期的例子，下一节会进一步介绍。

## 关注可变引用

{{&lt; image src=&#34;/images/rust/rust-lifetime-04.png&#34; &gt;}}

```rs
fn insert_value&lt;&#39;a&gt;(my_vec: &amp;&#39;a mut Vec&lt;&amp;&#39;a i32&gt;, value: &amp;&#39;a i32) {...}
```

这个例子和之前的例子很类似，同样的，使用我们的参数生命周期推导技巧，调用函数 `insert_value` 后，当参数 `vec` 和 `value` 的最大共同生命周期的范围很广时，这时就需要注意，在这个范围内，我们无法使用 `my_vec` 对应的 object 的任何其它引用 (因为编译器会认为此时还存在可变引用 `my_vec`)，从而编译错误。这就是容器和引用使用相同生命周期标注，而导致的强约束。为避免这种非预期的生命周期，应当将函数原型改写如下:

```rs
fn insert_value&lt;&#39;a, &#39;b&gt;(my_vec: &amp;&#39;a mut Vec&lt;&amp;&#39;b i32&gt;, value: &amp;&#39;b i32) {...}
```

&gt; 这样改写会包含一个隐式的生命周期规则: `&#39;a` $\leq$ `&#39;b`，这很好理解，容器的生命周期应该比所引用的 object 短，这个隐式规则在下一节的 struct/enum 的生命周期标注非常重要。

{{&lt; admonition &gt;}}
从正确写法 (有两个生命周期标注) 出发，探讨只使用一个生命周期标注的情况比较符合人类的思维，这也是原文安排的顺序。

如果传入的参数的生命周期均为已知，则同一生命周期标注代表的生命周期长度为，已知生命周期的最小值。如果传入的参数的生命周期存在未知的，则同一生命周期标注的生命周期长度为已知的生命周期的最小值，并且要求未知生命周期长度的参数的生命周期不得少于该最小值。
{{&lt; /admonition &gt;}}

## struct / enum 生命周期标注

{{&lt; image src=&#34;/images/rust/rust-lifetime-05.png&#34; &gt;}}

struct / enum 的生命周期推导可以从 **构造函数** 来理解，本质上和之前所介绍的函数的生命周期标注一致。

struct / enum 的生命周期标注也可以通过之前所提的 **状态机** 模型来进行理解，因为 struct / enum 本身不具备引用对应的 object 的所有权，在进行方法 (method) 调用时并不能截断引用对应的 object 的生命周期。

struct / enum 生命周期标注主要需要特别注意一点，就是 struct / enum 本身的可变引用的生命周期标注，最好不要和为引用的成员的生命周期的标注，标注为相同，因为这极大可能会导致 **生命周期强约束**，例如:

```rs
fn strtok(x: &amp;mut &#39;a Vec&lt;&#39;a i32&gt;, y: &amp;&#39;a i32) {...}
```

如果参数 `Vec&lt;&#39;a i32&gt;` 的 vector 里的 `i32` 引用的生命周期是 `static` 的话，依据我们之前所提的技巧，会将可变引用 `&amp;&#39;a mut` 的生命周期也推导为 `static`，这就导致再也无法借用 `x` 对应的 object。

## `&#39;static` 和 `&#39;_`

{{&lt; image src=&#34;/images/rust/rust-lifetime-06.png&#34; &gt;}}

```rs
fn foo(_input: &amp;&#39;a str) -&gt; &#39;static str {
    &#34;abc&#34;
}
```

如果不进行 `static` 生命周期标注，依据省略规则，编译器会把返回值的生命周期推导为 `&#39;a`，即和输入参数一样，这就不符合我们预期使用了。

如果使用 `static` 标注 struct / enum 里的成员，则无需标注 struct / enum 的生命周期，因为 `static` 表示在整个程序运行起见都有效，没必要对容器进行生命周期标注。

```rs
struct UniqueWords {
    sentence: &amp;&#39;static str,
    unique_words: Vec&lt;&amp;&#39;static str&gt;,
}

impl UniqueWords {...}
```

在没有使用到 struct 的生命周期标注时，impl 可以不显式指明生命周期，而是通过 `&#39;_` 让编译器自行推导:

```rs
struct Counter&lt;&#39;a&gt; {
    inner: &amp;&#39;a mut i32,
}

impl Counter&lt;&#39;_&gt; {
  fn increment(&amp;mut self) {...}
}
// is the same as
impl&lt;&#39;a&gt; Counter&lt;&#39;a&gt; {
  fn increment(&amp;mut self) {...}
}
```

函数返回值不是引用，但是返回值类型里有成员是引用，依据省略规则，编译器无法自行推导该成员的生命周期，此时可以通过 `&#39;_` 来提示编译器依据省略规则，对返回值的成员的生命周期进行推导:

```rs
struct StrWrap&lt;&#39;a&gt;(&amp;&#39;a str);

fn make_wrapper(string: &amp;str) -&gt; StrWrap&lt;&#39;_&gt; {...}
// is the same as
fn make_wrapper&lt;&#39;a&gt;(string: &amp;&#39;a str) -&gt; StrWrap&lt;&#39;a&gt; {...}
```

## 生命周期型变和绑定

{{&lt; image src=&#34;/images/rust/rust-lifetime-07.png&#34; &gt;}}

因为 Rust 是没有继承的概念，所以下面以 scala 来对类型的型变举例子进行讲解 (但是不需要你对 Scala 有任何了解):

```scala
class A
class B extends A // B is subclass of A

private def f1(a: A): Unit = {
  println(&#34;f1 works!&#34;)
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
  println(&#34;f1 works!&#34;)
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
class Foo[&#43;T]      // covariant
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
 * `A =&gt; C` is subclass of `B =&gt; B` 
 */
```

为什么 `A =&gt; C` 是 `B =&gt; B` 的子类呢？其实也很好理解，`B =&gt; B` 的返回值是 `B`，这个返回值可以用 `C` 来代替，但不能用 `A` 来代替，这显然满足协变。`B =&gt; B` 的参数是 `B`，这个参数可以用 `A` 来代替而不能用 `C` 来代替 (因为有一部分 `B` 不一定是 `C`，而 `B` 则一定是 `A`)，这满足逆变。

{{&lt; image src=&#34;/images/rust/rust-lifetime-08.png&#34; &gt;}}

`T` 可以表示所有情况: ownership, immutable reference, mutable reference，例如 `T` 可以表示 `i32`, `&amp;i32`, `&amp;mut i32` (如果你使用过 `into_iterator` 的话应该不陌生)

`T: &#39;a` 是说：如果 `T` 里面含有引用，那么这个引用的生命周期必须是 `&#39;a` 的子类，即比 `&#39;a` 长或和 `&#39;a` 相等。`T: &#39;static` 也类似，表示 `T` 里面的引用 (如果有的话)，要么比 `&#39;static` 长或和 `&#39;static` 相等，因为不可能有比 `&#39;static` 更长的生命周期，所以这个标注有两种表示意义表: **要么 `T` 里面的引用和 `&#39;static` 一样长，要么 `T` 里面没有引用只有所有权 (owneship)**。

- The Rust Reference: [Subtyping and Variance](https://doc.rust-lang.org/reference/subtyping.html)

{{&lt; image src=&#34;/images/rust/rust-variance1.png&#34; &gt;}}

- The Rustonomicon: [Subtyping and Variance](https://doc.rust-lang.org/nomicon/subtyping.html)

{{&lt; image src=&#34;/images/rust/rust-variance2.png&#34; &gt;}}

基本和我们之前所说的一致，这里需要注意一点: 凡是涉及可变引用的 `T`，都是不变 (invariant)。这也很好理解，因为可变引用需要保证所引用的类型 `T` 是一致并且是唯一的，否则会扰乱 Rust 的引用模型。因为可变引用不仅可以改变所指向的 object 的内容，还可以改变自身，即改变指向的 object，如果此时 `T` 不是不变 (invariant) 的，那么可以将这个可变引用指向 `T` 的子类，这会导致该可变引用指向的 object 被可变借用一次后无法归还，从而导致后续再也无法引用该 object。此外还会导致原本没有生命周期约束的两个独立类型，被生命周期约束，具体见后面的例子。

```rs
struct Foo&lt;&#39;a&gt; {
    _phantom: PhantomData&lt;&amp;&#39;a i32&gt;,
}

fn foo&lt;&#39;short, &#39;long: &#39;short&gt;( // long is subclass of short
    mut short_foo: Foo&lt;&#39;short&gt;,
    mut long_foo:  Foo&lt;&#39;long&gt;,
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
struct Foo&lt;&#39;a&gt; {
    _phantom: PhantomData&lt;&amp;&#39;a i32&gt;,
}

fn foo&lt;&#39;short, &#39;long: &#39;short&gt;( // long is subclass of short
    mut short_foo: &amp;mut Foo&lt;&#39;short&gt;,
    mut long_foo:  &amp;mut Foo&lt;&#39;long&gt;,
) {
    short_foo = long_foo;   // error
    long_foo  = short_foo;  // error
}
```

## 生命周期 reborrow

{{&lt; image src=&#34;/images/rust/rust-lifetime-08.png&#34; &gt;}}

```rs
let mut i = 42;
let x = &amp;mut i; // x: &amp;mut i32
let y = x;      // y: &amp;mut i32

*y = 43;
println(&#34;{}&#34;, *y);

*x = 44;
println(&#34;{}&#34;, *x);
```

按照 Rust 的借用检查机制，第 3 行处会导致后续出现两个指向 `i` 的可变引用 `x` 和 `y`，编译会失败，但实际上编译是没问题的，这是因为重引用 reborrow 机制，其使得第 3 行实质上被编译器处理为:

```rs
let y = &amp;mut *x; // y: &amp;mut i32
```

所以 `y` 其实是对 `x` 的重引用，在 **重引用的使用范围** 内，只要不使用 **被重引用的引用** `x` 和 **对象本身** `i`，编译器会认为这是没问题的，个人感觉相当于比较高阶的变量遮蔽。需要注意的是 reborrow 机制只应用于 **可变引用**，因为不可变引用可以同时存在多个，无需担心重引用时不能使用的问题。下面是另一个例子，也是因为 reborrow 机制从而通过编译:

```rs
fn main() {
    let mut i = 42;
    let x = &amp;mut i; // x: &amp;mut i32

    change_it(x);
    println(&#34;{}&#34;, *y);

    *x = 44;
    println(&#34;{}&#34;, *x);
}

fn change_it(mut_i32: &amp;mut i32) {
    *mut_i32 = 43;
}
```

## Homework

{{&lt; admonition info &gt;}}
- [ ] 阅读博客 [Common Rust Lifetime Misconceptions](https://github.com/pretzelhammer/rust-blog/blob/master/posts/common-rust-lifetime-misconceptions.md) 以对 Rust 生命周期及常见的误区有充分认知
- [ ] 完成 [LifetimeKata](https://tfpk.github.io/lifetimekata/) 的相关练习
{{&lt; /admonition &gt;}}

### LifetimeKata 

- Chapter 1: Lifetimes Needed
&gt; Lifetime Annotations are used to help the compiler understand what\&#39;s going on when it can\&#39;t rely on scope brackets (i.e. across function boundaries; and within structs and enums).

- Chapter 3: Lifetime Elision
&gt; We saw that the compiler was unable to automatically tell how references in the arguments or return values might relate to each other. This is why we needed to tell the compiler that the references related to each other.

即 Rust 编译器可以通过作用范围来确定引用是否合法，进而防止 **悬垂引用**，但是对于函数调用或者是结构体的构造，Rust 编译器就无法通过上下文来进行检查了 (因为每次函数调用或结构体构造使用的引用都可能不同)，所以需要生命周期标注，它的作用是让编译器按照标注指定的关系对引用进行检查。

- Chapter 7: Special Lifetimes
&gt; Lifetime bounds can be applied to types or to other lifetimes. The bound `&#39;a: &#39;b` is usually read as `&#39;a` outlives `&#39;b`. `&#39;a: &#39;b` means that `&#39;a` lasts at least as long as `&#39;b`, so a reference `&amp;&#39;a ()` is valid whenever `&amp;&#39;b ()` is valid.

生命周期约束，实质上是用于规定 Variance 的关系

- Chapter 10: Footnote on Trait Lifetime Bounds
&gt; It&#39;s important to realise that since trait objects might or might not contain a reference (or any number of references), all trait objects have lifetimes. This is true, even if no implementors of the trait contain references.

Trait 对象的生命周期比较复杂，但一般不会太多涉及到，比较常见的例子是 `Box&lt;dyn Trait&gt;` 等价于 `Box&lt;dyn &#39;static Trait&gt;`

## Documentations

这里列举视频中一些概念相关的 documentation 

&gt; 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

&gt; 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

## References

- [Common Rust Lifetime Misconceptions](https://github.com/pretzelhammer/rust-blog/blob/master/posts/common-rust-lifetime-misconceptions.md)
- [The Rust Reference](https://doc.rust-lang.org/reference/)
- [泛型中的型变 (协变，逆变，不可变)](https://juejin.cn/post/6952434934589947912)
- [Variant Types and Polymorphism](https://www.cs.cornell.edu/courses/cs3110/2012sp/lectures/lec04-types/lec04.html)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/lifetime-in-rust/  

