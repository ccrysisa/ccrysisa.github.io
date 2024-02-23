---
title: "Crust of Rust: Smart Pointers and Interior Mutability"
subtitle:
date: 2024-02-20T17:33:06+08:00
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
  - Smart pointer
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

> In this fourth Crust of Rust video, we cover smart pointers and interior mutability, by re-implementing the Cell, RefCell, and Rc types from the standard library. As part of that, we cover when those types are useful, how they work, and what the equivalent thread-safe versions of these types are. In the process, we go over some of the finer details of Rust's ownership model, and the UnsafeCell type. We also dive briefly into the Drop Check rabbit hole (https://doc.rust-lang.org/nightly/nomicon/dropck.html) before coming back up for air.

<!--more-->

- 整理自 [John Gjengset 的影片](https://www.youtube.com/watch?v=8O0Nt9qY_vo)

## 影片注解

### Interior Mutability

Module [std::cell](https://doc.rust-lang.org/std/cell/index.html)

> Rust memory safety is based on this rule: Given an object T, it is only possible to have one of the following:
> 
> - Having several immutable references (&T) to the object (also known as aliasing).
> - Having one mutable reference (&mut T) to the object (also known as mutability).

> Values of the `Cell<T>`, `RefCell<T>`, and `OnceCell<T>` types may be mutated through shared references (i.e. the common &T type), whereas most Rust types can only be mutated through unique (&mut T) references. We say these cell types provide ‘interior mutability’ (mutable via &T), in contrast with typical Rust types that exhibit ‘inherited mutability’ (mutable only via &mut T).

- We can use (several) immutable references of a cell to mutate the thing inside of the cell.
- There is (virtually) no way for you to get a reference to the thing inside of a cell. 
- **Because if no one else has a pointer to it (the thing inside of a cell), the changing it is fine.**

Struct [std::cell::UnsafeCell](https://doc.rust-lang.org/std/cell/struct.UnsafeCell.html)

> If you have a reference &T, then normally in Rust the compiler performs optimizations based on the knowledge that &T points to immutable data. Mutating that data, for example through an alias or by transmuting an &T into an &mut T, is considered undefined behavior. `UnsafeCell<T>` opts-out of the immutability guarantee for &T: a shared reference &`UnsafeCell<T>` may point to data that is being mutated. This is called “interior mutability”.

> The UnsafeCell API itself is technically very simple: .get() gives you a raw pointer *mut T to its contents. It is up to you as the abstraction designer to use that raw pointer correctly.

### Cell

Module [std::cell Cell\<T\>](https://doc.rust-lang.org/std/cell/index.html#cellt) 
> `Cell<T>` implements interior mutability by moving values in and out of the cell. That is, an &mut T to the inner value can never be obtained, and the value itself cannot be directly obtained without replacing it with something else. Both of these rules ensure that there is never more than one reference pointing to the inner value. This type provides the following methods:

在 Rust 中对一个变量 (T)，在已存在其 immutable references (&T) 时使用 mutable reference (&mut T) 是禁止的，因为这样会因为编译器优化而导致程序的行为不一定符合我们的预期。考虑以下的代码:

```rs
let x = 3;
let r1 = &x, r2 = &x;
let r3 = &mut x;
println!("{}", r1);
r3 = 5;
println!("{}", r2);
```

假设以上的代码可以通过编译，那么程序执行到第 6 行打印出来的可能是 3 而不是我们预期的 5，这是因为编译器会对 immtuable references 进行激进的优化，例如进行预取，所以在第 6 行时对于 r2 使用的还是先前预取的值 3 而不是内存中最新的值 5。这也是 Rust 制定对 immutable reference 和 mutable reference 的规则的原因之一。

为了达到我们的预期行为，可以使用 UnsafeCell 来实现:

```rs
let x = 3;
let uc = UnsafeCell::new(x);
let r1 = &uc, r2 = &uc， r3 = &uc;
unsafe { println!("{}", *uc.get()); }
unsafe { *uc.get() = 5; }
unsafe { println!("{}", *uc.get()); }
```

上面的代码可以通过编译，并且在第 6 行时打印出来的是预期的 5。这是因为编译器会对 UnsafeCell 进行特判，而避免进行一些激进的优化 (例如预取)，从而使程序行为符合我们的预期。并且 UnsafeCell 的 get() 方法只需要接受 &self 参数，所以可以对 UnsafeCell 进行多个 immutable references，这并不违反 Rust 的内存安全准则。同时每个对于 UnsafeCel 的 immutable references 都可以通过所引用的 UnsafeCell 来实现内部可变性 (interior mutability)。

上述代码片段存在大量的 unsafe 片段 (因为 UnsafeCell)，将这些 unsafe 操作封装一下就实现了 Cell。但是因为 Cell 的方法 get() 和 set() 都需要转移所有权，所以 Cell 只能用于实现了 Copy trait 的类型的内部可变性。但是对于 concurrent 情形，UnsafeCell 就是一个临界区，无法保证内部修改是同步的，所以 Cell 不是 thread safe 的。

> Cell<T> is typically used for more simple types where copying or moving values isn’t too resource intensive (e.g. numbers)

{{< admonition >}}
`Cell` 提供了这样一个“内部可变性”机制: **在拥有对一个 object 多个引用时，可以通过任意一个引用对 object 进行内部可变，并保证在此之后其他引用对于该 object 的信息是最新的。**
{{< /admonition >}}

### RefCell

Module [std::cell RefCell\<T\>](https://doc.rust-lang.org/std/cell/index.html#refcellt) 
> `RefCell<T>` uses Rust’s lifetimes to implement “dynamic borrowing”, a process whereby one can claim temporary, exclusive, mutable access to the inner value. Borrows for `RefCell<T>`s are tracked at runtime, unlike Rust’s native reference types which are entirely tracked statically, at compile time.

`RefCell` 也提供了之前所提的“内部可变性”机制，但是是通过提供 ***引用*** 而不是转移所有权来实现。

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

- Module [std::cell](https://doc.rust-lang.org/std/cell/index.html)
  - Struct [std::cell::UnsafeCell](https://doc.rust-lang.org/std/cell/struct.UnsafeCell.html)
  - Struct [std::cell::Cell](https://doc.rust-lang.org/std/cell/struct.Cell.html)
  - Struct [std::cell::RefCell](https://doc.rust-lang.org/std/cell/struct.RefCell.html)

- Module [std::rc](https://doc.rust-lang.org/std/rc/index.html)

- Module [std::sync](https://doc.rust-lang.org/std/sync/index.html)
  - Struct [std::sync::Arc](https://doc.rust-lang.org/std/sync/struct.Arc.html)

- Trait [std::ops::Drop](https://doc.rust-lang.org/std/ops/trait.Drop.html)

- Trait [std::ops::Deref](https://doc.rust-lang.org/std/ops/trait.Deref.html)

- Trait [std::ops::DerefMut](https://doc.rust-lang.org/std/ops/trait.DerefMut.html)

- function [std:\:thread\::spawn](https://doc.rust-lang.org/std/thread/fn.spawn.html)
