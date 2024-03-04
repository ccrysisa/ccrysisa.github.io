---
title: "Crust of Rust: Sorting Algorithms"
subtitle:
date: 2024-03-04T15:02:28+08:00
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
  - Sort
  - Algorithm
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

> In this Crust of Rust episode, we implement some common sorting algorithms in Rust. This episode doesn\'t aim to explain any single concept, but rather showcase what writing "normal" Rust code is like, and explaining various "odd bits" we come across along the way. The thinking here is that sorting algorithms are both familiar and easy to compare across languages, so this might serve as a good bridge into Rust if you are familiar with other languages.

<!--more-->

- 整理自 [John Gjengset 的影片](https://www.youtube.com/watch?v=h4RkCyJyXmM)

{{< admonition question >}}
You may note that the url of this posy is "orst". Why was it given this name? 

Since "sort" when sorted becomes "orst". :rofl:
{{< /admonition >}}

## 影片注解

### Total order vs Partial order

- Wikipedia: [Total order](https://en.wikipedia.org/wiki/Total_order)

- Wikipedia: [Partial order](https://en.wikipedia.org/wiki/Partially_ordered_set#Partial_order)

- Stack Overflow: [What does it mean by "partial ordering" and "total ordering" in the discussion of Lamport\'s synchronization Algorithm?](https://stackoverflow.com/questions/55889912/what-does-it-mean-by-partial-ordering-and-total-ordering-in-the-discussion-o)
> This definition says that in a total order any two things are comparable. Wheras in a partial order a thing needs neither to be "smaller" than an other nor the other way around, in a total order each thing is either "smaller" than an other or the other way around.

简单来说，在 total order 中任意两个元素都可以进行比较，而在 partial order 中则不一定满足。例如对于集合
{{< raw >}}
$$
S = \{a,\ b,\ c\}
$$
{{< /raw >}}
在 total order 中，$a, b, c$ 任意两个元素之间都必须能进行比较，而在 partial order 中没有怎么严格的要求，可能只有 $a < b, b < c$ 这两条比较规则。

在 Rust 中，浮点数 (`f32`, `f64`) 只实现了 PartialOrd 这个 Trait 而没有实现 Ord，因为根据 [IEEE 754](https://en.wikipedia.org/wiki/IEEE_754)，浮点数中存在一些特殊值，例如 NaN，它们是没法进行比较的。出于相同原因，浮点数也只实现了 `PartialEq` 而没有实现 `Eq` trait。

### Trait & Generic

```rs
pub fn sort<T, S>(slice: &mut [T])
where
    T: Ord,
    S: Sorter<T>,
{
    S::sort(slice);
}

sort::<_, StdSorter>(&mut things);
```

这段代码巧妙地利用泛型 (generic) 来传递了"参数"，当然这种技巧只限于可以通过类型来调用方法的情况 (上面代码段的 `S::sort(...)` 以及 `sort::<_, StdSorter>(...)` 片段)。

思考以下代码表示的意义:

```rs
pub trait Sorter<T> {
    fn sort(slice: &mut [T])
    where
        T: Ord;
}

pub trait Sorter {
    fn sort<T>(slice: &mut [T])
    where
        T: Ord;
}
```

第一个表示的是有多个 tait，例如 `Sorter<i32>`, `Sorter<i64>` 等，第二个表示只有一个 trait `Sorter`，但是实现这个 trait 需要实现多个方法，例如 `sort<i32>`, `sort<i64>` 等，所以第一种写法更加普适和使用 (因为未必能完全实现第二种 trait 要求的所有方法)。

### Bubble sort

- Wikipedia: [Bubble sort](https://en.wikipedia.org/wiki/Bubble_sort)

```bash
n := length(A)
repeat
    swapped := false
    for i := 1 to n-1 inclusive do
        { if this pair is out of order }
        if A[i-1] > A[i] then
            { swap them and remember something changed }
            swap(A[i-1], A[i])
            swapped := true
        end if
    end for
until not swapped
```

### Insertion sort

- Wikipedia: [Insertion sort](https://en.wikipedia.org/wiki/Insertion_sort)

```bash
i ← 1
while i < length(A)
    j ← i
    while j > 0 and A[j-1] > A[j]
        swap A[j] and A[j-1]
        j ← j - 1
    end while
    i ← i + 1
end while
```

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

- Trait [std::cmp::Ord](https://doc.rust-lang.org/std/cmp/trait.Ord.html)

- Primitive Type [slice](https://doc.rust-lang.org/std/primitive.slice.html#)
  - method [slice::sort](https://doc.rust-lang.org/std/primitive.slice.html#method.sort)
  - method [slice::sort_unstable](https://doc.rust-lang.org/std/primitive.slice.html#method.sort_unstable)
  - method [slice::sort_by](https://doc.rust-lang.org/std/primitive.slice.html#method.sort_by)
  - method [slice::sort_by_key](https://doc.rust-lang.org/std/primitive.slice.html#method.sort_by_key)
  - method [slice::swap](https://doc.rust-lang.org/std/primitive.slice.html#method.swap)
  - method [slice::binary_search](https://doc.rust-lang.org/std/primitive.slice.html#method.binary_search)

## References

- Wikipedia: [Sorting algorithm](https://en.wikipedia.org/wiki/Sorting_algorithm)
- Wikipedia: [Timsort](https://en.wikipedia.org/wiki/Timsort)
- Wikipedia: [Bubble sort](https://en.wikipedia.org/wiki/Bubble_sort)
- Wikipedia: [Insertion sort](https://en.wikipedia.org/wiki/Insertion_sort)
- Wikipedia: [Total order](https://en.wikipedia.org/wiki/Total_order)
- Wikipedia: [Partial order](https://en.wikipedia.org/wiki/Partially_ordered_set#Partial_order)
- Stack Overflow: [Partial ordering vs Potal ordering](https://stackoverflow.com/questions/55889912/what-does-it-mean-by-partial-ordering-and-total-ordering-in-the-discussion-o)
- Stack Overflow: [Difference between Benchmarking and Profiling](https://stackoverflow.com/questions/34801622/difference-between-benchmarking-and-profiling)
