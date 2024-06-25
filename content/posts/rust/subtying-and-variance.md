---
title: "Crust of Rust: Subtying and Variance"
subtitle:
date: 2024-03-17T10:38:01+08:00
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
  - Subtying
  - Variance
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

> In this episode of Crust of Rust, we go over subtyping and variance — a niche part of Rust that most people don't have to think about, but which is deeply ingrained in some of Rust's borrow ergonomics, and occasionally manifests in confusing ways. In particular, we explore how trying to implement the relatively straightforward `strtok` function from C/C++ in Rust quickly lands us in a place where the function is more or less impossible to call due to variance!

<!--more-->

- 整理自 [John Gjengset 的影片](https://www.youtube.com/watch?v=iVYWDIW71jk)

## 影片注解

### strtok

> A sequence of calls to this function split str into tokens, which are sequences of contiguous characters separated by any of the characters that are part of delimiters.

- cplusplus: [strtok](https://cplusplus.com/reference/cstring/strtok/)
- cppreference: [strtok](https://en.cppreference.com/w/cpp/string/byte/strtok)

### shortening lifetimes

影片大概 19 分时给出了为何 cargo test 失败的推导，个人觉得非常巧妙

```rs
pub fn strtok<'a>(s: &'a mut &'a str, delimiter: char) { ... }

let mut x = "hello world";
strtok(&mut x, ' ');
```

为了更直观地表示和函数 `strtok` 的返回值 lifetime 无关，这里将返回值先去掉了。在调用 `strtok` 时，编译器对于参数 `s` 的 lifetime 推导如下:

```rs
parameter: &'a mut &'a str
argument:  &   mut x

parameter: &'a mut &'a str
argument:  &   mut &'static str

parameter: &'a mut &'static str
argument:  &   mut &'static str

parameter: &'static mut &'static str
argument:  &        mut &'static str

parameter: &'static mut &'static str
argument:  &'static mut &'static str
```

所以 `strtok` 在接收参数 `s` 后 (通过传入 `&mut x`)，会推导其 lifetime 为 static，这就会导致后面使用 `x` 的不可变引用 (`&x`) 时发生冲突。

### Subtypes

下面是 Covariance 的一个例子，生命周期长的引用是生命周期短的引用的 subtype

```rs
fn main() {
    let s = String::new();
    let x: &'static str = "hello, world";
    let mut y: &str = &s;
    y = x;
}
```

> Since `'static` is subtype of `'a`

```rs
T: U
T is at least as useful as U

// e.g.
'static: 'a
'static is at least as useful as 'a
```

### Variance

- Covariance

```rs
fn foo(&'a str) {}
let x = &'a str

foo(&'a str)      -> x = 'a str
foo(&'static str) -> x = &'static str
```

- Contravariance

| Type          | Variance in `T` |
| :-----------: | :-------------: |
| `fn(T) -> ()`	|	contravariant   |

The only contravariance in Rust now (2024/6/25).

```rs
/* covariance */
&'static str  // more useful
&'a str
// &'static str is subtype of &'a str
// since 'static str is at least as useful as 'a str
'static <: 'a
&'static T <: &'a T

/* contravariance */
Fn(&'static str)
Fn(&'a str)   // more useful
// Fn(&'a str) subtype  of Fn(&'static str)
// since Fn(&'a str) is at least as useful as Fn(&'static str)
'static <: 'a
Fn(&'a T) <: Fn(&'static T)
```

- Invariance

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

- method [str::find](https://doc.rust-lang.org/std/primitive.str.html#method.find)
- method [char::len_utf8](https://doc.rust-lang.org/std/primitive.char.html#method.len_utf8)

## References

- The Rust Reference: [Subtyping and Variance](https://doc.rust-lang.org/reference/subtyping.html)
- The Rustonomicon: [Subtyping and Variance](https://doc.rust-lang.org/nomicon/subtyping.html)
- [Lifetime variance in Rust](https://github.com/sunshowers-code/lifetime-variance)
