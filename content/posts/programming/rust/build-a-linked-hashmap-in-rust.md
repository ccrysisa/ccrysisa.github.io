---
title: "Build a linked hash map in Rust"
subtitle:
date: 2024-06-28T11:16:51+08:00
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
  - Hash Map
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

> We\'re writing it end-to-end in one sitting, with the hope of ending up with a decent understanding of how hash map works, and how you\'d make the interface idiomatic Rust. I have tried to make sure I introduce new concepts we come across, so it should be possible to follow whether you\'re a newcomer to the language or not.

<!--more-->

- 整理自 [John Gjengset 的影片](https://www.youtube.com/watch?v=k6xR2kf9hlA)

## 影片注解

### Data structure and API

> Usually it is nicer tosepecify the bounds only on the places where you need them (e.g. methods) rather than on the data structure.

- Struct [std::collections::HashMap](https://doc.rust-lang.org/std/collections/struct.HashMap.html)
```rs
pub struct HashMap<K, V, S = RandomState> { /* private fields */ }

impl<K, V, S> HashMap<K, V, S>
where
    K: Eq + Hash,
    S: BuildHasher,
```

### Hash and Eq

- Trait [std::hash\::Hash](https://doc.rust-lang.org/std/hash/trait.Hash.html)

{{< admonition quote >}}
When implementing both `Hash` and `Eq`, it is important that the following property holds:

```
k1 == k2 -> hash(k1) == hash(k2)
```

In other words, if two keys are equal, their hashes must also be equal. `HashMap` and `HashSet` both rely on this behavior.
{{< /admonition >}}

### usize vs. u64

```rs
let bucket = (hasher.finish() % self.buckets.len() as u64) as usize;
let bucket = &mut self.buckets[bucket];
```

因为取模 `%` 运算后的数值不大于 `buckets.len()`，并且 `buckets.len()` 的类型是 `usize`，所以可以将取模运算的结果安全第转换成 `usize`，当然进行取模运算时需要将 `buckets.len()` 转换成和 `finish()` 的返回值类型 `u64` 再进行运算。

### swap_remove

对于普通的 vector 的 `remove` 方法来说，处理过程如下:

```rs
vec![a, b, c, d, e, f]
remove(b)
vec![a, _, c, d, e, f]
vec![a, c, d, e, f]
```

即需要被删除元素后面的元素依次进行移位，这样的时间复杂度很高 $O(n)$。但对于 `swap_remove` 来说，其处理过程如下:

```rs
vec![a, b, c, d, e, f]
remove(b)
vec![a, f, c, d, e, b]
vec![a, f, c, d, e]
```

先将被删除元素和最后一个元素交换位置，然后再丢弃最后一个元素 (此时该位置上为被删除元素)，这样的时间复杂度仅为 $O(1)$

### tail recursion

因为 Rust 编译器并没有针对尾递归的最优化，所以尽量不要使用尾递归的逻辑，使用循环改写比较好，这样可以将空间复杂度从 $O(n)$ 降到 $O(1)$。在 `drop` 方法的实现中特别明显，手动实现 `drop` 方法时，应尽量使用循环而不是递归逻辑。

### tuple references

```rs
(&'a K, &'a V)
&'a (K, V)
```

这两种表示方式是不完全相同的，对于第二种方式，隐含了一个前提: `K, V` 是在同一个 tuple 里面，即它们在内存的位置是相邻的，这种方式表示引用的是一个 tuple。而第一种仅表示两个引用组成了一个 tuple，而对于 `K, V` 这两个数据在内存的位置关系并无限制，`K, V` 本身是否组成 tuple 也不在乎。

### borrow

- Trait [std::borrow::Borrow](https://doc.rust-lang.org/std/borrow/trait.Borrow.html)

> Types express that they can be borrowed as some type `T` by implementing `Borrow<T>`, providing a reference to a `T` in the trait’s borrow method. A type is free to borrow as several different types. If it wishes to mutably borrow as the type, allowing the underlying data to be modified, it can additionally implement `BorrowMut<T>`.

> In particular  `Eq`, `Ord` and `Hash` must be equivalent for borrowed and owned values: `x.borrow() == y.borrow()` should give the same result as `x == y`.

> If generic code merely needs to work for all types that can provide a reference to related type `T`, it is often better to use `AsRef<T>` as more types can safely implement it.

> By additionally requiring `Q: Hash + Eq`, it signals the requirement that `K` and `Q` have implementations of the `Hash` and `Eq` traits that produce identical results.

- [Borrow and AsRef](https://web.mit.edu/rust-lang_v1.25/arch/amd64_ubuntu1404/share/doc/rust/html/book/first-edition/borrow-and-asref.html)

{{< admonition quote >}}
We can see how they’re kind of the same: they both deal with owned and borrowed versions of some type. However, they’re a bit different.

Choose `Borrow` when you want to abstract over different kinds of borrowing, or when you’re building a data structure that treats owned and borrowed values in equivalent ways, such as hashing and comparison.

Choose `AsRef` when you want to convert something to a reference directly, and you’re writing generic code.
{{< /admonition >}}

### entry

- Enum [std::collections::hash_map::Entry](https://doc.rust-lang.org/std/collections/hash_map/enum.Entry.html)

```rs
pub enum Entry<'a, K: 'a, V: 'a> {
    Occupied(OccupiedEntry<'a, K, V>),
    Vacant(VacantEntry<'a, K, V>),
}
```

A view into a single entry in a map, which may either be vacant or occupied.

`or_insert` 和 `or_insert_with` 的可以从下面的例子一窥区别:

```rs
x.or_insert(vec::new())
x.or_insert_with(vec::new)
```

`or_insert` 会在调用前对参数进行计算，所以不管 `x` 是哪个枚举子类型，`vec::new()` 都会被调用，而 `or_insert_with` 的参数是一个闭包，仅当 `x` 是 `Vacant` 时才会对参数进行调用操作，即 `vec::new()` 操作。

```rs
pub fn or_insert(self, value: V) -> &'a mut V {
    match self {
        Entry::Occupied(e) => &mut e.entry.1,
        Entry::Vacant(e) => e.insert(value),
    }
}

pub fn or_insert_with<F>(self, maker: F) -> &'a mut V
where
    F: FnOnce() -> V,
{
    match self {
        Entry::Occupied(e) => &mut e.entry.1,
        Entry::Vacant(e) => e.insert(maker()),
    }
}
```

### reborrow 

```rs
pub fn entry(&mut self, key: K) -> Entry<'_, K, V> {
    let bucket = self.bucket(&key);

    match self.buckets[bucket]
        .items
        .iter_mut()
        .find(|&& mut (ref ekey, _)| ekey == &key)
    {
        Some(index) => Entry::Occupied(OccupiedEntry { entry }),
        None => Entry::Vacant(VacantEntry {
            key,
            map: self,
            bucket,
        }),
    }
}
```

这个实作乍一看好像没有问题，但是注意 `match` 表达式让 `iter_mut()` 获得的可变引用的存活域为其接下来的 `{}` 内。但是需要注意的是，这个 `iter_mut()` 获得的可变引用是对该方法的 `&mut self` 进行 reborrow 得来的，依据 reborrow 的规则，在 reborrow 得到的可变引用的使用范围内，不能使用被 reborrow 的可变引用 (这是为了向编译器保证同一时刻只会存在一个可变引用)。但是我们看到 `match` 表达式的 `None` 分支里，使用了被 reborrow 的可变引用 `self`，这违反了 reborrow 的规则，故而编译不通过。

正确实作如下，仅在 `Some` 和 `None` 分支才使用 reborrow，这样就不会违反 reborrow 的规则机制:

```rs
pub fn entry(&mut self, key: K) -> Entry<'_, K, V> {
    let bucket = self.bucket(&key);

    match self.buckets[bucket]
        .items
        .iter()
        .position(|&(ref ekey, _)| ekey == &key)
    {
        Some(index) => Entry::Occupied(OccupiedEntry {
            entry: &mut self.buckets[bucket].items[index],
        }),
        None => Entry::Vacant(VacantEntry {
            key,
            map: self,
            bucket,
        }),
    }
}
```

### sorted list

可以给 hash map 的 linked 部分进行排序，这样查找的效能会比较高 (使用二分查找，时间复杂度由原先的 $O(n)$ 降低为 $O(log n)$)，但是这样会降低插入的效能 (时间复杂度由原先的 $O(1)$ 提高至 $O(n)$)。所以需要根据应用场景进行 trade-off，如果是应用场景是查询操作比较多的，就将 linked 部分设置为有序。

## Homework

{{< admonition info >}}

- [x] 为 `HashMap` 实现 Trait [std::ops::Index](https://doc.rust-lang.org/std/ops/trait.Index.html)，使得下面这条语句编译通过:

```rs {title="examples/std-1.rs"}
println!("Review for Jane: {}", book_reviews["Pride and Prejudice"]);
```

- [x] 为 `HashMap` 实现 method [and_modify](https://doc.rust-lang.org/std/collections/hash_map/enum.Entry.html#method.and_modify)，使得下面这条语句编译通过:

```rs {title="examples/std-2.rs"}
player_stats
    .entry("mana")
    .and_modify(|mana| *mana += 200)
    .or_insert(100);
```

- [x] 为 `HashMap` 实现 Trait [std::convert::From](https://doc.rust-lang.org/std/convert/trait.From.html)，根据手册，只需要实现对数组类型 `[(K, V); N]`，使得下面的代码可以通过编译:

```rs {title="examples/std-3.rs"}
let vikings = HashMap::from([
    (Viking::new("Einar", "Norway"), 25),
    (Viking::new("Olaf", "Denmark"), 24),
    (Viking::new("Harald", "Iceland"), 12),
]);
```

```rs {title="examples/std-4.rs"}
let solar_distance = HashMap::from([
    ("Mercury", 0.4),
    ("Venus", 0.7),
    ("Earth", 1.0),
    ("Mars", 1.5),
]);
```

- [x] 修正 `bucket` 方法，使得其对于空的 `HashMap` 也可以正常工作

- [x] 在方法 [from_iter](https://doc.rust-lang.org/std/iter/trait.FromIterator.html#tymethod.from_iter) 的实作中采用对 `HashMap` 进行预分配的策略，增强该方法的效能 
    + Hint: [std::iter::Iterator::size_hint](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.size_hint)
    + Hint: [std::vec::Vec::with_capacity](https://doc.rust-lang.org/std/vec/struct.Vec.html#method.with_capacity)

- [x] 为 `HashMap` 实现 [drain](https://doc.rust-lang.org/std/collections/hash_map/struct.HashMap.html#method.drain) 方法

- [x] 为 `HashMap` 实现 [remove_entry](https://doc.rust-lang.org/std/collections/hash_map/struct.HashMap.html#method.remove_entry) 方法

- [x] 为 `HashMap` 实现 [get_mut](https://doc.rust-lang.org/std/collections/struct.HashMap.html#method.get_mut) 方法

- [x] 为 `HashMap` 实现 [clear](https://doc.rust-lang.org/std/collections/hash_map/struct.HashMap.html#method.clear) 方法

- [ ] 为 `HashMap` 实现 `&mut` 的迭代器 ***这个很难，因为涉及到可变引用的生命周期***

{{< /admonition >}}

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

- Struct [std::collections::HashMap](https://doc.rust-lang.org/std/collections/struct.HashMap.html)
- Struct [std::collections::hash_map::DefaultHasher](https://doc.rust-lang.org/std/collections/hash_map/struct.DefaultHasher.html)

- Trait [std::hash\::Hasher](https://doc.rust-lang.org/std/hash/trait.Hasher.html)
- Trait [std::hash\::Hash](https://doc.rust-lang.org/std/hash/trait.Hash.html)
- Enum [std::collections::hash_map::Entry](https://doc.rust-lang.org/std/collections/hash_map/enum.Entry.html)

- Trait [std::borrow::Borrow](https://doc.rust-lang.org/std/borrow/trait.Borrow.html)
- Trait [std::borrow::BorrowMut](https://doc.rust-lang.org/std/borrow/trait.BorrowMut.html)

- Function [std::mem::replace](https://doc.rust-lang.org/std/mem/fn.replace.html)

- Struct [std::vec::Vec](https://doc.rust-lang.org/std/vec/struct.Vec.html)
  - method [std::vec::Vec::with_capacity](https://doc.rust-lang.org/std/vec/struct.Vec.html#method.with_capacity)
  - method [std::vec::Vec::drain](https://doc.rust-lang.org/std/vec/struct.Vec.html#method.drain)
  - method [std::vec::Vec::is_empty](https://doc.rust-lang.org/std/vec/struct.Vec.html#method.is_empty)
  - method [std::vec::Vec::retain](https://doc.rust-lang.org/std/vec/struct.Vec.html#method.retain)
  - method [std::vec::Vec::swap_remove](https://doc.rust-lang.org/std/vec/struct.Vec.html#method.swap_remove)
  - method [std::vec::Vec::clear](https://doc.rust-lang.org/std/vec/struct.Vec.html#method.clear)

- Trait [std::iter::Iterator](https://doc.rust-lang.org/std/iter/trait.Iterator.html)
  - method [std::iter::Iterator::find](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.find)
  - method [std::iter::Iterator::map](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.map)
  - method [std::iter::Iterator::flat_map](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.flat_map)
  - method [std::iter::Iterator::position](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.position)
  - method [std::iter::Iterator::collect](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.collect)
  - method [std::iter::Iterator::size_hint](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.size_hint)

- Trait [std::iter::FromIterator](https://doc.rust-lang.org/std/iter/trait.FromIterator.html)

- Trait [std::ops::Drop](https://doc.rust-lang.org/std/ops/trait.Drop.html)

- trait method [std::iter::Extend::extend](https://doc.rust-lang.org/std/iter/trait.Extend.html#tymethod.extend)
- method [std::option::Option::is_some](https://doc.rust-lang.org/std/option/enum.Option.html#method.is_some)
- method [slice::last_mut](https://doc.rust-lang.org/std/primitive.slice.html#method.last_mut)

## References

- Tsoding: [Hash Table in Rust](https://www.youtube.com/watch?v=YBzNFt4wapA)
- [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/about.html)
- [The Cargo Book](https://doc.rust-lang.org/cargo/index.html)
