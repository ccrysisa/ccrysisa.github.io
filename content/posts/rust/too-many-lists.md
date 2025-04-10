---
title: "手把手带你使用 Rust 实现链表"
subtitle:
date: 2024-06-15T20:24:56+08:00
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
  - Sysprog
  - Linked List
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

{{< admonition abstract >}}
其它语言：兄弟，语言学了吗？来写一个链表证明你基本掌握了语法。

Rust 语言: 兄弟，语言精通了吗？来写一个链表证明你已经精通了 Rust！
{{< /admonition >}}

<!--more-->

{{< link href="https://www.bilibili.com/video/BV1eb4y1Q7FA/" content="教学录影" external-icon=true >}}
/
{{< link href="https://rust-unofficial.github.io/too-many-lists/" content="原文地址" external-icon=true >}}
/ 
{{< link href="https://course.rs/too-many-lists/intro.html" content="中文翻译" external-icon=true >}}

## 通过枚举实现 Lisp 风格的链表

```rs
#[derive(Debug)]
enum List<T> {
    Cons(T, Box<List<T>>),
    Nil,
}

fn main() {
    let list: List<i32> = List::Cons(1, Box::new(List::Cons(2, Box::new(List::Nil))));
    println!("{:?}", list);
}
```

{{< admonition >}}
该实作将 **链表节点整体** 视为 **枚举** 进行区分，导致空元素也会占据内存空间
{{< /admonition >}}

符号 `[]` 表示数据存放在 stack 上，`()` 则表示数据存放在 heap 上，上面例子的内存分布为:
```rs
[List 1, ptr] -> (List 2, ptr) -> (Nil)
```

存在的问题:
1. 元素 1 是分配在 stack 而不是 heap 上
2. 最后的空元素 `Nil` 也需要分配空间

而我们预期的内存分布为:
```rs
[ptr] -> (List 1, ptr) -> (List 2, ptr) -> (Nil)
```

这样的内存分布更加节省 stack 空间，并且将所有的链表节点都放置在 heap 上，这样在链表拆分和合并时就不需要对头结点进行额外考量和处理，下面是两种内存布局在链表拆分时的对比:
```rs
// first entry in stack
[List 1, ptr] -> (List 2, ptr) -> (List 3, ptr) -> (Nil)
split off 3:
[List 1, ptr] -> (List 2, ptr) -> (Nil)
[List 3, ptr] -> (Nil)

// first entry in heap
[ptr] -> (List 1, ptr) -> (List 2, ptr) -> (List 3, ptr) -> (Nil)
split off 3:
[ptr] -> (List 1, ptr) -> (List 2, ptr) -> (Nil)
[ptr] -> (List 3, ptr) -> (Nil)
```

显然第一种方式在链表拆分时涉及到链表元素在 stack 和 heap 之间的位置变换，链表合并也类似，请自行思考。

但是这个内存布局并不是最好的，我们想要达到类似 C/C++ 的链表的内存布局:
```rs
[ptr] -> (List 1, ptr) -> (List 2, ptr) -> (List 3, null)
```

## 实作 C/C++ 风格的链表

```rs
type Link<T> = Option<Box<Node<T>>>;

#[derive(Debug)]
pub struct List<T> {
    head: Link<T>,
}

#[derive(Debug)]
struct Node<T> {
    elem: T,
    next: Link<T>,
}
```

{{< admonition >}}
该实作将 链表节点的 **next 指针部分** 视为 **枚举** 进行区分，这样空元素不会占据内存空间
{{< /admonition >}}

### new

```rs
pub fn new() -> Self {
    Self { head: None }
}
```

### push

```rs
pub fn push(&mut self, elem: T) {
    let next = Box::new(Node {
        elem,
        next: self.head.take(),
    });
    self.head = Some(next);
}
```

### pop

```rs
pub fn pop(&mut self) -> Option<T> {
    self.head.take().map(|node| {
        self.head = node.next;
        node.elem
    })
}
```

注意这里的 `pop` 方法并没有对被弹出的节点 node 进行释放

### drop

```rs
impl<T> Drop for List<T> {
    fn drop(&mut self) {
        let mut link = self.head.take();
        while let Some(mut node) = link {
            link = node.next.take();
        }
    }
}
```

将每个节点 node 被指向的指针 (`Box` 指针) 都清除掉，这样 Rust 的所有权机制就会将这些节点 node 占据的内存空间进行清理，这样空间复杂度为 $O(1)$。

通过循环手动实现 `drop` 的意义在于，如果依赖自动清理的话，`drop` 机制会不断进行递归，进而可能导致栈溢出 (因为没有尾递归优化)，所以空间复杂度为 $O(N)$ ($N$ 为链表节点个数)。例如对于链表 `[a, b, c]` 的自动 `drop`，其调用栈为:

```
stack
  | | drop(a) |
  |     | drop(b) |
  v         | drop(c) |
```

而我们通过循环来手动实现的 `drop` 则不会导致栈溢出，因为空间复杂度为 $O(1)$。

- Trait [std::ops::Drop](https://doc.rust-lang.org/std/ops/trait.Drop.html)

### peek

```rs
pub fn peek(&self) -> Option<&T> {
    self.head.as_ref().map(|node| &node.elem)
}

pub fn peek_mut(&mut self) -> Option<&mut T> {
    self.head.as_mut().map(|node| &mut node.elem)
}
```

### into_iter

```rs
impl<T> IntoIterator for List<T> {
    type Item = T;
    type IntoIter = IntoIter<T>;

    fn into_iter(self) -> Self::IntoIter {
        IntoIter(self)
    }
}

pub struct IntoIter<T>(List<T>);

impl<T> Iterator for IntoIter<T> {
    type Item = T;
    fn next(&mut self) -> Option<Self::Item> {
        self.0.pop()
    }
}
```

- Trait [std::iter::IntoIterator](https://doc.rust-lang.org/std/iter/trait.IntoIterator.html)
- Trait [std::iter::Iterator](https://doc.rust-lang.org/std/iter/trait.Iterator.html)

### iter

```rs
impl<'a, T> IntoIterator for &'a List<T> {
    type Item = &'a T;
    type IntoIter = Iter<'a, T>;

    fn into_iter(self) -> Self::IntoIter {
        Iter(self.head.as_deref())
    }
}

pub struct Iter<'a, T>(Option<&'a Node<T>>);

impl<'a, T> Iterator for Iter<'a, T> {
    type Item = &'a T;
    fn next(&mut self) -> Option<Self::Item> {
        self.0.take().map(|node| {
            self.0 = node.next.as_deref();
            &node.elem
        })
    }
}

impl<T> List<T> {
    pub fn iter(&self) -> Iter<T> {
        self.into_iter()
    }
}
```

- method [std::option::Option::as_deref](https://doc.rust-lang.org/std/option/enum.Option.html#method.as_deref)
> Leaves the original Option in-place, creating a new one with a reference to the original one, additionally coercing the contents via `Deref`.

在这里可以一窥 `as_deref` 的作用，例如下面两条语句的作用是相同的:

```rs
self.0 = node.next.as_ref().map(|next| next.as_ref());
self.0 = node.next.as_deref();
```

所以 `as_deref` 是在 `as_ref` 作用的基础上添加了 **自动类型转换 (Deref)** 功能

### iter_mut

```rs
impl<'a, T> IntoIterator for &'a mut List<T> {
    type Item = &'a mut T;
    type IntoIter = IterMut<'a, T>;

    fn into_iter(self) -> Self::IntoIter {
        IterMut(self.head.as_deref_mut())
    }
}

pub struct IterMut<'a, T>(Option<&'a mut Node<T>>);

impl<'a, T> Iterator for IterMut<'a, T> {
    type Item = &'a mut T;

    fn next(&mut self) -> Option<Self::Item> {
        self.0.take().map(|node| {
            self.0 = node.next.as_deref_mut();
            &mut node.elem
        })
    }
}

impl<T> List<T> {
    pub fn iter_mut(&mut self) -> IterMut<T> {
        self.into_iter()
    }
}
```

- method [std::option::Option::as_deref_mut](https://doc.rust-lang.org/std/option/enum.Option.html#method.as_deref_mut)
> Leaves the original Option in-place, creating a new one containing a mutable reference to the inner type’s `Deref::Target` type.

## 持久化共享节点的链表

到目前为止，我们已经通过 `Box` 指针实现了一个简单的单链表，但由于 Rust 的所有权机制，导致这个单链表的节点 `Node` 只能被一个 `Box` 指针指向，接下来我们通过智能指针来解除这个限制，实作 *持久化的共享链表*。

```rs
// current
list -> A -> B -> C

// expect
list 1 -> A ---+
               |
               v
list 2 -> B -> C -> D
               ^
               |
list 3 -> X ---+

list 1: [A, C, D]
list 2: [B, C, D]
list 3: [X, C, D]
```

上图的节点 `B` 的被多个节点 (节点 `A` 和节点 `X`) 所指向，设定其所有权是共享的比较好处理，因为使用引用的话，会被借用检查机制限制，修改时比较麻烦 (只能被一个可变引用所借用)

- **持久化**: 节点如果被至少一个指针指向，则不会释放；如果没有被指向，则进行释放
- **共享**: 节点可以被多个指针所指向

根据这里这两种功能需求，使用共享所有权并进行计数的智能指针 [std::rc::Rc](https://doc.rust-lang.org/std/rc/struct.Rc.html) 比较适合。

```rs
use std::rc::Rc;

type Link<T> = Option<Rc<Node<T>>>;

#[derive(Debug)]
pub struct List<T> {
    head: Link<T>,
}

#[derive(Debug)]
struct Node<T> {
    elem: T,
    next: Link<T>,
}

impl<T> List<T> {
    pub fn new() -> Self {
        Self { head: None }
    }
}
```

### prepend

```rs
// It takes a list and an element, and returns a List.
pub fn prepend(&mut self, elem: T) -> Self {
    Self {
        head: Some(Rc::new(Node {
            elem,
            next: self.head.clone(),
        })),
    }
}
```

### tail

```rs
// It takes a list and returns the whole list with the first element removed.
pub fn tail(&mut self) -> Self {
    Self {
        head: self.head.as_ref().and_then(|node| node.next.clone()),
    }
}
```

这里可以体验 [map](https://doc.rust-lang.org/std/option/enum.Option.html#method.map) 和 [and_then](https://doc.rust-lang.org/std/option/enum.Option.html#method.and_then) 的区别，在于其接受的闭包的不同，`map` 闭包的返回值会被自动的用 `Option` 包装起来，而 `and_then` 则需要自己在闭包中手动包装:

```rs
pub fn map<U, F>(self, f: F) -> Option<U>
where
    F: FnOnce(T) -> U,
```

```rs
pub fn and_then<U, F>(self, f: F) -> Option<U>
where
    F: FnOnce(T) -> Option<U>,
```

### head

```rs
// returns a reference to the first element.
pub fn head(&self) -> Option<&T> {
    self.head.as_ref().map(|node| &node.elem)
}
```

### iter

我们只实现 `iter` 而不是实现 `into_iter` 和 `iter_mut` 这两个方法，因为持久化共享节点的链表的某一些节点是被共享的，所以 `into_iter` 吸显然就不能被实现，假设一个链表使用了 `into_iter` 那么其他共享其节点的链表就会有一部分凭空消失了，这违反了所有权机制，而 `iter_mut` 也类似，两个链表都是使用 `iter_mut`，如果它们有共享节点，那么在共享节点上有一个迭代器就不能正常工作 (根据借用检查机制，同一时间只能存在一个可变引用)。

```rs
impl<'a, T> IntoIterator for &'a List<T> {
    type Item = &'a T;
    type IntoIter = Iter<'a, T>;

    fn into_iter(self) -> Self::IntoIter {
        Iter(self.head.as_deref())
    }
}

pub struct Iter<'a, T>(Option<&'a Node<T>>);

impl<'a, T> Iterator for Iter<'a, T> {
    type Item = &'a T;
    fn next(&mut self) -> Option<Self::Item> {
        self.0.take().map(|node| {
            self.0 = node.next.as_deref();
            &node.elem
        })
    }
}

impl<T> List<T> {
    pub fn iter(&self) -> Iter<T> {
        self.into_iter()
    }
}
```

### drop

`drop` 方法将一个链表中只被该链表拥有的节点 `Node` 进行释放，对于共享的节点则不做处理。

```rs
impl<T> Drop for List<T> {
    fn drop(&mut self) {
        let mut link = self.head.take();
        while let Some(node) = link {
            if let Ok(ref mut node) = Rc::try_unwrap(node) {
                link = node.next.take();
            } else {
                break;
            }
        }
    }
}
```

- method [std::rc::Rc::try_unwrap](https://doc.rust-lang.org/std/rc/struct.Rc.html#method.try_unwrap)
> Returns the inner value, if the `Rc` has exactly one strong reference.
> 
> Otherwise, an `Err` is returned with the same `Rc` that was passed in.

### 多线程安全

`Rc` 不是多线程安全的，如果要让我们这个持久化链表在多线程情景下安全使用，则需要使用 `Arc` 智能指针。

```rs
use std::sync::Arc;

type Link<T> = Option<Arc<Node<T>>>;

impl<T> Drop for List<T> {
    fn drop(&mut self) {
        ...
            if let Ok(ref mut node) = Arc::try_unwrap(node) {...}
        ...
    }
}
```

- method [std::sync::Arc::try_unwrap](https://doc.rust-lang.org/std/sync/struct.Arc.html#method.try_unwrap)

{{< admonition info "延伸阅读" >}}
理解多线程安全的内部机制需要了解内存模型，下面这个讲座解释得很棒！
- Herb Sutter: [atomic Weapons: The C++ Memory Model and Modern Hardware](https://herbsutter.com/2013/02/11/atomic-weapons-the-c-memory-model-and-modern-hardware/)
{{< /admonition >}}

## 双端链表

在前面持久化链表的基础上，使用智能指针 [RefCell](https://doc.rust-lang.org/std/cell/struct.RefCell.html) 来实现节点 `Node` 的内部可变性，并搭配 `Rc` 来进行引用计数:

```rs
use std::{cell::RefCell, rc::Rc};

type Link<T> = Option<Rc<RefCell<Node<T>>>;
```

延伸阅读:
- [Crust of Rust: Smart Pointers and Interior Mutability]({{< relref "./smart-pointers-and-interior-mutability.md" >}})

```rs
#[derive(Debug)]
pub struct List<T> {
    head: Link<T>,
    tail: Link<T>,
}

#[derive(Debug)]
struct Node<T> {
    elem: T,
    next: Link<T>,
    prev: Link<T>,
}

impl<T> Node<T> {
    pub fn new(elem: T) -> Self {
        Self {
            elem,
            next: None,
            prev: None,
        }
    }
}

impl<T> List<T> {
    pub fn new() -> Self {
        Self {
            head: None,
            tail: None,
        }
    }
}
```

### push

```rs
pub fn push_front(&mut self, elem: T) {
    let node = Rc::new(RefCell::new(Node::new(elem)));
    match self.head.take() {
        Some(head) => {
            node.borrow_mut().next = Some(head.clone());
            head.borrow_mut().prev = Some(node.clone());
            self.head = Some(node.clone());
        }
        None => {
            self.head = Some(node.clone());
            self.tail = Some(node.clone());
        }
    }
}

pub fn push_back(&mut self, elem: T) {
    let node = Rc::new(RefCell::new(Node::new(elem)));
    match self.tail.take() {
        Some(tail) => {
            node.borrow_mut().prev = Some(tail.clone());
            tail.borrow_mut().next = Some(node.clone());
            self.tail = Some(node.clone());
        }
        None => {
            self.head = Some(node.clone());
            self.tail = Some(node.clone());
        }
    }
}
```

- method [std::cell::RefCell::borrow_mut](https://doc.rust-lang.org/std/cell/struct.RefCell.html#method.borrow_mut)

### pop

```rs
pub fn pop_front(&mut self) -> Option<T> {
    self.head.take().map(|node| {
        match node.borrow_mut().next.take() {
            Some(next) => {
                next.borrow_mut().prev.take();
                self.head = Some(next.clone());
            }
            None => {
                self.tail.take();
            }
        }
        Rc::try_unwrap(node).ok().unwrap().into_inner().elem
    })
}

pub fn pop_back(&mut self) -> Option<T> {
    self.tail.take().map(|node| {
        match node.borrow_mut().prev.take() {
            Some(prev) => {
                prev.borrow_mut().next.take();
                self.tail = Some(prev.clone());
            }
            None => {
                self.head.take();
            }
        }
        Rc::try_unwrap(node).ok().unwrap().into_inner().elem
    })
}
```

> Since we don't care about the case where it fails (if we wrote our program correctly, it has to succeed), we just call `unwrap` on it.

正常情况下，我们不会对共享节点进行 `pop` 操作，防止出现数据不一致的情况，所以这里可以直接使用 `unwrap` 来获取内部数据 (因为我们通过 ***contract*** 来保住不会出现 `None` 的情况)。

- method [std::rc::Rc::try_unwrap](https://doc.rust-lang.org/std/rc/struct.Rc.html#method.try_unwrap)
- method [std::cell::RefCell::into_inner](https://doc.rust-lang.org/std/cell/struct.RefCell.html#method.into_inner)

### peek

```rs
pub fn peek_front(&self) -> Option<Ref<T>> {
    self.head
        .as_ref()
        .map(|node| Ref::map(node.borrow(), |node| &node.elem))
}

pub fn peek_back(&self) -> Option<Ref<T>> {
    self.tail
        .as_ref()
        .map(|node| Ref::map(node.borrow(), |node| &node.elem))
}
```

- method [std::cell::RefCell::borrow](https://doc.rust-lang.org/std/cell/struct.RefCell.html#method.borrow)
- method [std::cell::Ref::map](https://doc.rust-lang.org/std/cell/struct.Ref.html#method.map)

```rs
pub fn peek_mut_front(&mut self) -> Option<RefMut<T>> {
    self.head
        .as_ref()
        .map(|node| RefMut::map(node.borrow_mut(), |node| &mut node.elem))
}

pub fn peek_mut_back(&mut self) -> Option<RefMut<T>> {
    self.tail
        .as_ref()
        .map(|node| RefMut::map(node.borrow_mut(), |node| &mut node.elem))
}
```

- method [std::cell::RefCell::borrow_mut](https://doc.rust-lang.org/std/cell/struct.RefCell.html#method.borrow_mut)
- method [std::cell::RefMut::map](https://doc.rust-lang.org/std/cell/struct.RefMut.html#method.map)

### iter

```rs
impl<T> IntoIterator for List<T> {
    type Item = T;
    type IntoIter = IntoIter<T>;

    fn into_iter(self) -> Self::IntoIter {
        IntoIter(self)
    }
}

pub struct IntoIter<T>(List<T>);

impl<T> Iterator for IntoIter<T> {
    type Item = T;
    fn next(&mut self) -> Option<Self::Item> {
        self.0.pop_front()
    }
}

impl<T> DoubleEndedIterator for IntoIter<T> {
    fn next_back(&mut self) -> Option<Self::Item> {
        self.0.pop_back()
    }
}

impl<T> List<T> {
    pub fn into_iter(self) -> IntoIter<T> {
        IntoIterator::into_iter(self)
    }
}
```

- Trait [std::iter::Iterator](https://doc.rust-lang.org/std/iter/trait.Iterator.html)
- Trait [std::iter::DoubleEndedIterator](https://doc.rust-lang.org/std/iter/trait.DoubleEndedIterator.html)

## Unsafe Rust 实作单链表

我们对之前实现的 C/C++ 风格的单链表进行改进，使其为满足 **先进先出** 性质的单链表。但是如果不使用 Unsafe Rust 来实作的话，很容易就会违反 Rust 的借用规则 (因为我们需要一个 `tail` 成员来指向尾节点)，例如我们将 `List` 的 `tail` 用可变引用来表示:

```rs
pub struct List<T> {
    head: Link<T>,
    tail: Option<&mut Node<T>>,
}
```

那么对于 `List` 那些使用可变应用 `&mut self` 的方法，调用这些方法时对这个链表会存在两个可变引用，一个是 `tail` 表示可变引用，另一个则是 `&mut self` 表示的可变引用，这显然违反了 Rust 的借用检查机制，因此编译不通过。所以我们需要使用 Unsafe Rust 的裸指针 raw pointer 来实现，以避开 Rust 的借用检查机制。

{{< admonition >}}
之所以不使用 `Link<T>` 来表示 `tail`，是因为 `Box` 指针和 `Rc` 指针不一样，它只允许一个指针指向对于的数据，所以当链表只有一个节点时，`head` 和 `tail` 都指向同一个 `Node`，但这种情况 `Box` 指针无法做到。
{{< /admonition >}}

```rs
use std::ptr;

type Link<T> = Option<Box<Node<T>>>;

#[derive(Debug)]
pub struct List<T> {
    head: Link<T>,
    tail: *mut Node<T>,
}

#[derive(Debug)]
struct Node<T> {
    elem: T,
    next: Link<T>,
}

impl<T> List<T> {
    pub fn new() -> Self {
        Self {
            head: None,
            tail: ptr::null_mut(),
        }
    }
}
```

### push

```rs
pub fn push(&mut self, elem: T) {
    let mut node = Box::new(Node { elem, next: None });
    let raw_tail: *mut _ = &mut *node;
    if self.tail.is_null() {
        self.head = Some(node);
    } else {
        unsafe {
            (*self.tail).next = Some(node);
        }
    }
    self.tail = raw_tail;
}
```

### pop

```rs
pub fn pop(&mut self) -> Option<T> {
    self.head.take().map(|head| {
        let next = head.next;
        if next.is_none() {
            self.tail = ptr::null_mut();
        }
        self.head = next;
        head.elem
    })
}
```

### drop

```rs
impl<T> Drop for List<T> {
    fn drop(&mut self) {
        let mut link = self.head.take();
        while let Some(mut node) = link {
            link = node.next.take();
        }
    }
}
```

### iter

- into_iter

```rs
impl<T> IntoIterator for List<T> {
    type Item = T;
    type IntoIter = IntoIter<T>;

    fn into_iter(self) -> Self::IntoIter {
        IntoIter(self)
    }
}

pub struct IntoIter<T>(List<T>);

impl<T> Iterator for IntoIter<T> {
    type Item = T;
    fn next(&mut self) -> Option<Self::Item> {
        self.0.pop()
    }
}
```

- iter

```rs
impl<T> List<T> {
    pub fn iter(&self) -> Iter<T> {
        self.into_iter()
    }
}

impl<'a, T> IntoIterator for &'a List<T> {
    type Item = &'a T;
    type IntoIter = Iter<'a, T>;

    fn into_iter(self) -> Self::IntoIter {
        Iter(self.head.as_deref())
    }
}

pub struct Iter<'a, T>(Option<&'a Node<T>>);

impl<'a, T> Iterator for Iter<'a, T> {
    type Item = &'a T;
    fn next(&mut self) -> Option<Self::Item> {
        self.0.take().map(|node| {
            self.0 = node.next.as_deref();
            &node.elem
        })
    }
}
```

- iter_mut

```rs
impl<T> List<T> {
    pub fn iter_mut(&mut self) -> IterMut<T> {
        self.into_iter()
    }
}

impl<'a, T> IntoIterator for &'a mut List<T> {
    type Item = &'a mut T;
    type IntoIter = IterMut<'a, T>;

    fn into_iter(self) -> Self::IntoIter {
        IterMut(self.head.as_deref_mut())
    }
}

pub struct IterMut<'a, T>(Option<&'a mut Node<T>>);

impl<'a, T> Iterator for IterMut<'a, T> {
    type Item = &'a mut T;

    fn next(&mut self) -> Option<Self::Item> {
        self.0.take().map(|node| {
            self.0 = node.next.as_deref_mut();
            &mut node.elem
        })
    }
}
```

## 其他案例实作

### Stack

- Wikipedia: [Stack (abstract data type)](https://en.wikipedia.org/wiki/Stack_(abstract_data_type))

实作和之前的 C/C++ 风格的单链表类似，这里仅列出不同的函数:

```rs
fn push_node(&mut self, mut node: Box<Node<T>>) {
    node.next = self.head.take();
    self.head = Some(node);
}

fn pop_node(&mut self) -> Option<Box<Node<T>>> {
    self.head.take().map(|mut node| {
        self.head = node.next.take();
        node
    })
}

fn peek_node(&self) -> Option<&Node<T>> {
    self.head.as_deref()
}

fn peek_mut_node(&mut self) -> Option<&mut Node<T>> {
    self.head.as_deref_mut()
}
```

主要是一些辅助函数，用于帮助实现 `push`, `pop`, `peek`, `peek_mut` 等等核心功能函数

### Deque

- Wikipedia: [Double-ended queue](https://en.wikipedia.org/wiki/Double-ended_queue)

可以使用两个 `Stack` 来实作双端队列，当然这个 `Deque` 使用起来十分不便，这里仅作为展示用途:

```rs
pub struct Deque<T> {
    left: Stack<T>,
    right: Stack<T>,
}

impl<T> Deque<T> {
    pub fn go_left(&mut self) -> bool {
        self.left
            .pop_node()
            .map(|node| self.right.push_node(node))
            .is_some()
    }

    pub fn go_right(&mut self) -> bool {
        self.right
            .pop_node()
            .map(|node| self.left.push_node(node))
            .is_some()
    }
}
```

## Homework

{{< admonition info >}}
- [ ] 教学录影中没有对 [Chapter 7](https://rust-unofficial.github.io/too-many-lists/sixth.html) 进行讲解，自行阅读并实作里面相应的内容。
- [ ] 阅读原书 [8.2. The Stack-Allocated Linked List](https://rust-unofficial.github.io/too-many-lists/infinity-stack-allocated.html) 小节，并完成相应实作。
{{< /admonition >}}

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

- Function [std::mem::replace](https://doc.rust-lang.org/std/mem/fn.replace.html)

- Enum [std::option::Option](https://doc.rust-lang.org/std/option/enum.Option.html)
    - method [std::option::Option::take](https://doc.rust-lang.org/std/option/enum.Option.html#method.take)
    - method [std::option::Option::map](https://doc.rust-lang.org/std/option/enum.Option.html#method.map)
    - method [std::option::Option::and_then](https://doc.rust-lang.org/std/option/enum.Option.html#method.and_then)
    - method [std::option::Option::as_ref](https://doc.rust-lang.org/std/option/enum.Option.html#method.as_ref)
    - method [std::option::Option::as_mut](https://doc.rust-lang.org/std/option/enum.Option.html#method.as_mut)
    - method [std::option::Option::as_deref](https://doc.rust-lang.org/std/option/enum.Option.html#method.as_deref)
    - method [std::option::Option::as_deref_mut](https://doc.rust-lang.org/std/option/enum.Option.html#method.as_deref_mut)
    - method [std::option::Option::is_none](https://doc.rust-lang.org/std/option/enum.Option.html#method.is_none)
    - method [std::option::Option::is_some](https://doc.rust-lang.org/std/option/enum.Option.html#method.is_some)

- trait method [std::convert::AsRef::as_ref](https://doc.rust-lang.org/std/convert/trait.AsRef.html#tymethod.as_ref)
    - method [std::boxed::Box::as_ref](https://doc.rust-lang.org/std/boxed/struct.Box.html#method.as_ref)
    - method [std::rc::Rc::as_ref](https://doc.rust-lang.org/std/rc/struct.Rc.html#method.as_ref)
    - method [std::sync::Arc::as_ref](https://doc.rust-lang.org/std/sync/struct.Arc.html#method.as_ref)

- method [std::result::Result::ok](https://doc.rust-lang.org/std/result/enum.Result.html#method.ok)

- method [pointer::is_null](https://doc.rust-lang.org/std/primitive.pointer.html#method.is_null)

- Function [std::ptr::null_mut](https://doc.rust-lang.org/std/ptr/fn.null_mut.html)