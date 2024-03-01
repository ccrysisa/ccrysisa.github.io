# Crust of Rust: Smart Pointers and Interior Mutability


> In this fourth Crust of Rust video, we cover smart pointers and interior mutability, by re-implementing the Cell, RefCell, and Rc types from the standard library. As part of that, we cover when those types are useful, how they work, and what the equivalent thread-safe versions of these types are. In the process, we go over some of the finer details of Rust\'s ownership model, and the UnsafeCell type. We also dive briefly into the Drop Check rabbit hole (https://doc.rust-lang.org/nightly/nomicon/dropck.html) before coming back up for air.

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

{{< image src="/images/rust/cell.drawio.svg" caption="Cell" >}}

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
> `RefCell<T>` uses Rust\’s lifetimes to implement "dynamic borrowing", a process whereby one can claim temporary, exclusive, mutable access to the inner value. Borrows for `RefCell<T>\`s are tracked at runtime, unlike Rust’s native reference types which are entirely tracked statically, at compile time.

- **Runtime Borrow Check**

{{< image src="/images/rust/refcell.drawio.svg" caption="RefCell" >}}

`RefCell` 也提供了之前所提的“内部可变性”机制，但是是通过提供 ***引用*** 而不是转移所有权来实现。所以它常用于 Tree, Graph 这类数据结构，因为这些数据结构的节点 "很大"，不大可能实现 Copy 的 Trait (因为开销太大了)，所以一般使用 `RefCell` 来实现节点的相互引用关系。

### Rc

method [std::boxed::Box::into_raw](https://doc.rust-lang.org/std/boxed/struct.Box.html#method.into_raw)
> After calling this function, the caller is responsible for the memory previously managed by the Box. In particular, the caller should properly destroy T and release the memory, taking into account the memory layout used by Box. The easiest way to do this is to convert the raw pointer back into a Box with the Box::from_raw function, allowing the Box destructor to perform the cleanup.

{{< image src="/images/rust/rc.drawio.svg" caption="Rc" >}}

### Raw pointers vs references

`* mut` and `* const` are not references, they are raw pointers. In Rust, there are a bunch of semantics you have to follow when you using references. 

Like if you use `&` symbol, an `&` alone means a shared reference, and you have to guarantee that there are no exclusive references to that thing. And similarly, if you have a `&mut`, a exclusive reference, you know that there are not shared references.

The `*` version of these, like `* mut` and `* const`, do not have these guarantees. If you have a `* mut`, there may be other `* mut`s to the same thing. There might be `* const` to the same thing.

You have no guarantee, but you also cann\'t do much with a `*`. If you have a raw pointer, the only thing you can really do to it is use an **unsafe** block to dereference it and turn it into reference. But that is unsafe, *you need to document wht it is safe.* 

You\'re not able to go from a const pointer to an exclusive reference. But you can go from a mutable pointer to an exclusive reference.

> To guarantee that you have to follow **onwership** semantics in Rust.

### PhantomData & Drop check

- The Rustonomicon: [Drop Check](https://doc.rust-lang.org/nomicon/dropck.html)
- Medium: [Rust Notes: PhantomData](https://medium.com/@0xor0ne/rust-notes-phantomdata-505757bf56a7)

```rs
struct Foo<'a, T: Default> {
    v: &'a mut T,
}

impl<T> Drop for Foo<'_, T: Default> {
    fn drop(&mut self) {
        let _ = std::mem::replace(self.v, T::default());
    }
}

fn main() {
    let mut t = String::from("hello");
    let foo = Foo { v: &mut t };
    drop(t);
    drop(foo);
}
```

最后的 2 行 drop 语句会导致编译失败，因为编译器知道 foo 引用了 t，所以会进行 drop check，保证 t 的 lifetime 至少和 foo 一样长，因为 drop 时会按照从内到外的顺序对结构体的成员及其本身进行 drop。但是对于我们实现的 Rc 使用的是 raw pointer，如果不加 PhantomData，那么在对 Rc 进行 drop 时并不会检查 raw pointer 所指向的 RcInner 的 lifetime 是否满足要求，即在 drop Rc 之前 drop RcInner 并不会导致编译失败。简单来说，PhantomData 就是让编译器以为 Rc 拥有 RcInner 的所有权或引用，由此进行期望的 drop check 行为。

### Thread Safety

- Cell
> Because even though you\'re not giving out references to things, having two threads modify the same value at the same time is just not okay. There actually is o thread-safe version of `Cell`. (*Think it as pointer in C* :rofl:)

- RefCell
> You could totally implement a thread-safe version of RefCell, one that uses an atomic counter instead of `Cell` for these numbers. So it turns out that the CPU has built-in instructions that can, in a thread-safe way, increment and decrement counters.

- Rc
> The thread-safe version of `Rc` is `Arc`, or Atomic Reference Count.

### Copy-on-Write (COW)

Struct [std::borrow::Cow](https://doc.rust-lang.org/std/borrow/enum.Cow.html#)
> The type `Cow` is a smart pointer providing clone-on-write functionality: it can enclose and provide immutable access to borrowed data, and clone the data lazily when mutation or ownership is required. The type is designed to work with general borrowed data via the `Borrow` trait.

## Homework

{{< admonition info >}}
实作说明:
- [ ] 尝试使用 RefCell 来实现 Linux kernel 风格的 linked list
  - 数据结构为 circular doubly linked list
  - 实现 insert_head, remove_head 方法
  - 实现 insert_tail, remove_tail 方法
  - 实现 list_size, list_empty, list_is_singular 方法
  - 实现迭代器 (Iterator)，支持双向迭代 (DoubleEndedIterator)

参考资料:
- [sysprog21/linux-list](https://github.com/sysprog21/linux-list/blob/master/include/list.h#L94)
- [linux/list.h](https://github.com/torvalds/linux/blob/master/include/linux/list.h#L84)
{{< /admonition >}}

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
  - Struct [std::sync::Mutex](https://doc.rust-lang.org/std/sync/struct.Mutex.html)
  - Struct [std::sync::RwLock](https://doc.rust-lang.org/std/sync/struct.RwLock.html)
  - Struct [std::sync::Arc](https://doc.rust-lang.org/std/sync/struct.Arc.html)

- Struct [std::boxed::Box](https://doc.rust-lang.org/std/boxed/struct.Box.html)
  - method [std::boxed::Box::into_raw](https://doc.rust-lang.org/std/boxed/struct.Box.html#method.into_raw)
  - method [std::boxed::Box::from_raw](https://doc.rust-lang.org/std/boxed/struct.Box.html#method.from_raw)

- Struct [std::ptr::NonNull](https://doc.rust-lang.org/std/ptr/struct.NonNull.html)
  - method [std::ptr::NonNull::new_unchecked](https://doc.rust-lang.org/std/ptr/struct.NonNull.html#method.new_unchecked)
  - method [std::ptr::NonNull::as_ref](https://doc.rust-lang.org/std/ptr/struct.NonNull.html#method.as_ref)
  - method [std::ptr::NonNull::as_ptr](https://doc.rust-lang.org/std/ptr/struct.NonNull.html#method.as_ptr)

- Struct [std::marker::PhantomData](https://doc.rust-lang.org/std/marker/struct.PhantomData.html)

- Struct [std::borrow::Cow](https://doc.rust-lang.org/std/borrow/enum.Cow.html#)

- Trait [std::ops::Drop](https://doc.rust-lang.org/std/ops/trait.Drop.html)

- Trait [std::ops::Deref](https://doc.rust-lang.org/std/ops/trait.Deref.html)

- Trait [std::ops::DerefMut](https://doc.rust-lang.org/std/ops/trait.DerefMut.html)

- Trait [std::marker::Sized](https://doc.rust-lang.org/std/marker/trait.Sized.html)

- Function [std:\:thread\::spawn](https://doc.rust-lang.org/std/thread/fn.spawn.html)

- Function [std::mem::replace](https://doc.rust-lang.org/std/mem/fn.replace.html)

- Function [std::mem::drop](https://doc.rust-lang.org/std/mem/fn.drop.html)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/smart-pointers-and-interior-mutability/  

