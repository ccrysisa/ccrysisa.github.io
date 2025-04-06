---
title: "Crust of Rust: Lifetime Annotations"
subtitle:
date: 2024-01-25T18:40:45+08:00
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
  - Crust of Rust
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

{{< admonition type=abstract title="Abstract" >}}
We\'re going to investigate a case where you need multiple explicit lifetime annotations. We explore why they are needed, and why we need more than one in this particular case. We also talk about some of the differences between the string types and introduce generics over a self-defined trait in the process.
{{< /admonition >}}

<!--more-->


## C 语言中的 lifetime

Rust 中的 lifetime 一向是一个难点，为了更好地理解这一难点的本质，建议阅读 C 语言规格书关于 lifetime 的部分，相信你会对 Rust 的 lifetime 有不同的看法。

{{< admonition type=quote title="C11 6.2.4 Storage durations of objects" >}}
An object has a storage duration that determines its lifetime. There are four storage durations: static, thread, automatic, and allocated.
{{< /admonition >}}

## Rust 中的 lifetime

推荐观看 YouTube 上的视频 [but what is 'a lifetime?](https://www.youtube.com/watch?v=gRAVZv7V91Q) 从不同的视角来重新认识 Rust 中的生命周期。

## 影片注解

### comparsion

迭代器 (iterators) 如果类型相同 (指实现的 `type Item` 相同)，可以进行比较而无需将迭代器 collect 为指定的相同容器。但这要求迭代器实现了 `==` 运算符，所以更通用的方法是使用迭代器的 [eq](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.eq) 方法。

```rs
let haystack = "a b c d e";
let letters = StrSplit::new(haystack, " ");
assert!(letters, vec!["a", "b", "c", "d", "e"].into_iter());
```

### cargo check

cargo check 可以给出更简洁的提示，例如相对于编译器给出的错误信息，它会整合相同的错误信息，从而提供简洁切要的提示信息。而且它是一个静态分析工具，不需要进行编译即可给出提示，所以速度会比编译快很多，在大型项目上尤为明显。

### _

`_` 即占位符，仅当编译器拥有唯一的推断时，用于让编译器使用推断结果进行替换，用于类型和生命周期的推断。

```rs
struct Foo<'a> {
    s: &'a str,
}

impl Foo<'_> {
    ...
}

let xs: Vec<_> = [7u8; 5];
```

### impl

在 impl 后需要进行生命周期标注的理由与泛型相同，因为生命周期也是一种类型系统。

```rs
// generic
struct Foo<T> {...}
impl<T> Foo<T> {...}

// lifetime
struct Foo<'a> {...}
impl<'a> Foo<'a> {...}
```

### ref

影片大概 49 分时提到了

```rs
if let Some(ref mut remainder) = self.remainder {...} 
```

`ref` 的作用配合 `if let` 语句体的逻辑可以体会到 pointer of pointer 的美妙之处。

因为在 pattern match 中形如 `&mut` 这种类型是用于 pattern match 的 (在模式匹配中只有值才能被绑定)，不能用于获取 reference，这也是为什么需要使用 `ref mut` 这类语法来获取模式中值的引用 (reference)。

```rs
struct Foo<'a> {
    s: &'a str
}
```

值得注意的是 mutable references 作用范围只有一层深度。以上述程序片段的结构体举例，传入 `&mut self` 只允许修改 `self` 的任何成员，但成员所指向的值，例如上述结构体中的成员 `s`，其指向的是 immutable 字符串，所以其指向的值是无法被修改的，但可以被改为指向其它的 immutable 字符串 (类似于 C 语言的 `const char *` 类型)。

### operator ?

影片大概 56 分时提到了

```rs
let remainder = self.remainder.as_mut()?;
```

为什么使用之前所提的 `let remainder = &mut self.remainder?;` 不起作用？这是因为使用 `?` 运算符返回的是内部值的 copy，所以这种情况 `remainder` 里是 `self.remainder?` 返回的值 (是原有 `self.remainder` 内部值的 copy) 的 reference，所以后续修改 `remainder` 只是修改了 `self.remainder` 所返回的副本。

### &str vs String

影片大概 1:03 时提到了 `str` 与 `String` 的区别，个人觉得讲的很好：

```rs
str -> [char]
&str -> &[char] // fat pointer (address and size)
String -> Vec<char>

String -> &str (cheap -- AsRef)
&str -> String (expensive -- memcpy)
```

对于 `String` 使用 `&*` 可以保证将其转换成 `&str`，因为 `*` 会先将 `String` 转换成 `str`。当然对于函数参数的 `&str`，只需传入 `&String` 即可自动转换类型 (因为实现类 `AsRef` trait)。

### multiple lifetimes

很少会遇到使用 multiple lifetimes 的情况，但是遇到使用生命周期标注的第二性——代表内存区域，即可理解为何要使用 multiple lifetimes。

当在实现结构体的方法或 Trait 时，如果在实现方法时无需使用 lifetime 的名称，则可以使用匿名 lifetime `'_`，或者在编译器可以推推导出 lifetime 时也可以使用匿名 lifetime `'_`。


```rs
// lifetime and generic
struct Apple<'a, T> {
    owner: &'a T,
}

impl<T> Apple<'_, T> {
    // compiler can know lifetime
    pun fn func(&self) -> Apple<'_, T> {
        ...
    }
}
```

### len_utf8

因为 `char` 类型在 Rust 中是以 Unicode 编码的，而 Rust 中的字符串是以 UTF-8 编码的，所以在 Rust 字符串内表示相同内容的字符，其长度可能与 `char` 类型不同，需要使用 `len_utf8` 方法来获取 UTF-8 编码下 (即字符串内) 该字符的长度。

### standard library split

扩展阅读: 标准库中的 [split](https://doc.rust-lang.org/std/primitive.str.html#method.split)

## References

- YouTube: [Crust of Rust: Lifetime Annotations](https://www.youtube.com/watch?v=rAl-9HwD858)
- HackMD: [Crust of Rust: 筆記說明](https://hackmd.io/T6jGyghMS-Wq6F3ymCFJMg) / [Crust of Rust: Lifetime Annotations](https://hackmd.io/F8zEmei9Q6KmwOnQ5H1Vug)
- bilibili: [Rust 生命周期专题 由浅入深理解 Rust lifetime](https://space.bilibili.com/50713701/lists/1453665)

## Appendix

这里列举视频中一些概念相关的 documentation 

**学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料**

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

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
