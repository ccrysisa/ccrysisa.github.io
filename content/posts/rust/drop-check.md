---
title: "Crust of Rust: The Drop Check" 
subtitle:
date: 2024-07-08T11:21:32+08:00
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
  - Drop
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

> In this episode of Crust of Rust, we go over the \"drop check\" — another niche part of Rust that most people don\'t have to think about, but which rears its moderately attractive head occasionally when you use generic types in semi-weird ways. In particular, we explore how to implement a Norwegian version of `Box` (which is really just `Box` with a different name), and find that the straightforward implementation is not quite as flexible as the standard `Box` is due to the drop check. When we fix it, we then make it too flexible, and open ourselves the type up to undefined behavior. Which, in turn, we use the drop check to fix. Towards the end, we go through a particularly interesting example at the intersection of the drop check and variance in the form of (ab)using `std::iter::Empty`.

<!--more-->

- 整理自 [John Gjengset 的影片](https://www.youtube.com/watch?v=TJOFSMpJdzg)

## 影片注解

### where

drop check 和之前的 subtyping and variance 主题类似，是一个比较奇特的主题，但它比较少见，一般出现在 unsafe 的代码里

### from_raw vs. drop_in_place

```rs
impl<T> Drop for Boks<T> {
    fn drop(&mut self) {
        unsafe { Box::from_raw(self.p) };
        // vs.
        unsafe { std::ptr::drop_in_place(self.p) };
    }
}
```

直接使用 `drop_in_place` 只会 drop 被 `p` 指向的那部分数据 (位于 heap 中)，而不会 drop `Boks` 本身 (即成员 `p` 没被 drop)，而使用 `from_raw` 则两者都可以 drop 掉。

- Function [std::ptr::drop_in_place](https://doc.rust-lang.org/std/ptr/fn.drop_in_place.html)
> Executes the destructor (if any) of the pointed-to value.

- method [std::boxed::Box::from_raw](https://doc.rust-lang.org/std/boxed/struct.Box.html#method.from_raw)
> After calling this function, the raw pointer is owned by the resulting Box. Specifically, the Box destructor will call the destructor of T and free the allocated memory. 

### drop check and eyepatch

If you have a generic type over `T`, the **drop check** is going to assume that if this type implements `drop`, then the `drop` will access `T`.

And what the `dropck_eyepatch` does is it lets us sort of opt out of that part of the **drop check**， it lets us mask a given type parameter from the **drop check**.

```rs
#![feature(dropck_eyepatch)]

unsafe impl<#[may_dangle] T> Drop for Boks<T> {
    fn drop(&mut self) {
        // unsafe { Box::from_raw(self.p) };
        unsafe { std::ptr::drop_in_place(self.p) };
    }
}
```

And what this tells the compiler is that even though `Boks` holds a `T`, and then those generic over `T`, I promise since the `unsafe` keyword here that the code inside the `drop` does not access the `T`.

即在 `drop` 时结构体的泛型成员 `T` 是引用的情况下，可以允许 `T` 此时为悬垂引用 (dangle reference)

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

- Struct [std::boxed::Box](https://doc.rust-lang.org/std/boxed/struct.Box.html)
  - method [std::boxed::Box::into_raw](https://doc.rust-lang.org/std/boxed/struct.Box.html#method.into_raw)
  - method [std::boxed::Box::from_raw](https://doc.rust-lang.org/std/boxed/struct.Box.html#method.from_raw)

- Function [std::ptr::drop_in_place](https://doc.rust-lang.org/std/ptr/fn.drop_in_place.html)

- Trait [std::ops::Drop](https://doc.rust-lang.org/std/ops/trait.Drop.html)

- Trait [std::ops::Deref](https://doc.rust-lang.org/std/ops/trait.Deref.html)

- Trait [std::ops::DerefMut](https://doc.rust-lang.org/std/ops/trait.DerefMut.html)

## References

- The Rustonomicon: [Drop Check](https://doc.rust-lang.org/nomicon/dropck.html)
