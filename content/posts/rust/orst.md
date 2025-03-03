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

使用 [Binary search algorithm](https://en.wikipedia.org/wiki/Binary_search_algorithm) 可以将 insertion sort 的 comparsion 次数降到 $O(nlogn)$，但是 swap 次数仍然是 $O(n^2)$ :rofl:

```rs
// use binary search to find index
// then use .insert to splice in i
let i = match slice[..unsorted].binary_search(&slice[unsorted]) {
    // [ a, c, e].binary_search(c) => Ok(1)
    Ok(i) => i,
    // [ a, c, e].binary_search(b) => Err(1)
    Err(i) => i,
};
slice[i..=unsorted].rotate_right(1);
```

> `match` 的内部逻辑也可以改写为 `OK(i) | Err(i) => i`

### Selection sort

- Wikipedia: [Selection sort](https://en.wikipedia.org/wiki/Selection_sort)

{{< admonition quote >}}
There are many different ways to sort the cards. Here's a simple one, called selection sort, possibly similar to how you sorted the cards above:
1. Find the smallest card. Swap it with the first card.
2. Find the second-smallest card. Swap it with the second card.
3. Find the third-smallest card. Swap it with the third card.
4. Repeat finding the next-smallest card, and swapping it into the correct position until the array is sorted.
{{< /admonition >}}
> [source](https://www.khanacademy.org/computing/computer-science/algorithms/sorting-algorithms/a/selection-sort-pseudocode)

使用函数式编程可以写成相当 readable 的程式码，以下为获取 slice 最小值对应的 index:

```rs
let smallest_in_rest = slice[unsorted..]
                .iter()
                .enumerate()
                .min_by_key(|&(_, v)| v)
                .map(|(i, _)| unsorted + i)
                .expect("slice is not empty");
```

### Quicksort

- Wikipedia: [Quicksort](https://en.wikipedia.org/wiki/Quicksort)

可以通过 extra allocation 和 in-place 两种方式来实现 quicksort，其中 extra allocation 比较好理解，in-place 方式的 pseudocode 如下:

```bash
Quicksort(A,p,r) {
    if (p < r) {
       q <- Partition(A,p,r)
       Quicksort(A,p,q)
       Quicksort(A,q+1,r)
    }
}
Partition(A,p,r)
    x <- A[p]
    i <- p-1
    j <- r+1
    while (True) {
        repeat { j <- j-1 }
        until (A[j] <= x)
        repeat { i <- i+1 }
        until (A[i] >= x)
        if (i < j) swap(A[i], A[j])
        else       return(j)
    }
}
```
> [source](https://sites.cc.gatech.edu/classes/cs3158_98_fall/quicksort.html)

- method [slice::split_at_mut](https://doc.rust-lang.org/std/primitive.slice.html#method.split_at_mut)

实现 Quick sort 时使用了 `split_at_mut` 来绕开引用检查，因为如果你此时拥有一个指向 pivot 的不可变引用，就无法对 slice 剩余的部分使用可变引用，而 `split_at_mut` 则使得原本的 slice 被分为两个可变引用，从而绕开了之前的单一引用检查。
> 后面发现可以使用更符合语义的 `split_first_mut`，当然思路还是一样的

{{< admonition >}}
我个人认为实现 Quick sort 的关键在于把握以下两个 invariants:

- `left`: current checking index for element which is equal or less than the pivot
- `right`: current checking index for element which is greater than the pivot

即这两个下标对应的元素只是当前准备检查的，不一定符合元素的排列规范，如下图所示:

```
[ <= pivot ] [ ] [ ... ] [ ] [ > pivot ]
              ^           ^
              |           |
            left        right
```

所以当 `left == right` 时两边都没有对所指向的元素进行检查，分情况讨论 (该元素是 $<= pivot$ 或 $> pivot$) 可以得出: 当 `left > right` 时，`right` 指向的是 $<= pivot$ 的元素，将其与 pivot 进行 swap 即可实现 partition 操作。(其实此时 `left` 指向的是 $> pivot$ 部分的第一个元素，`right` 指向的是 $<= pivot$ 部分的最后一个元素，但是需要注意 `rest` 与 `slice` 之间的下标转换)
{{< /admonition >}}

### Benchmark

通过封装类型 `SortEvaluator` 及实现 trait `PartialEq`, `Eq`, `PartialOrd`, `Ord` 来统计排序过程中的比较操作 (`eq`, `partial_cmp`, `cmp`) 的次数。

Stack Overflow: [Why can\'t the Ord trait provide default implementations for the required methods from the inherited traits using the cmp function?](https://stackoverflow.com/questions/28387711/why-cant-the-ord-trait-provide-default-implementations-for-the-required-methods)

{{< image src="https://raw.githubusercontent.com/ccrysisa/rusty/main/sort/images/comparisons.png" >}}
{{< image src="https://raw.githubusercontent.com/ccrysisa/rusty/main/sort/images/runtime.png" >}}

### R and ggplot2

```bash
# install R
$ sudo apt install r-base
# install ggplot2 by R
$ R
> install.packages("ggplot2")
```

> 通过上面方式安装的 R 语言包，如果系统路径的存储库没有权限写入，会将包安装到用户下的 `$HOME/R/` 路径。

- [Are there Unix-like binaries for R?](https://cran.r-project.org/doc/FAQ/R-FAQ.html#Are-there-Unix_002dlike-binaries-for-R_003f)
- https://ggplot2.tidyverse.org/

{{< admonition type="question" open=false >}}
deepin 软件源下载的 R 语言包可能版本过低 (3.5)，可以通过添加库源的方式来下载高版本的 R 语言包:

1.添加 Debian buster (oldstable) 库源到 /etc/apt/sourcelist 里:
```bash
# https://mirrors.tuna.tsinghua.edu.cn/CRAN/
deb http://cloud.r-project.org/bin/linux/debian buster-cran40/
```

2.更新软件，可能会遇到没有公钥的问题 (即出现下方的 NO_PUBKEY):
```bash
$ sudo apt update
...
  NO_PUBKEY XXXXXX
...
```

此时可以 NO_PUBKEY 后的 XXXXXX 就是公钥，我们只需要将其添加一下即可:
```bash
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys XXXXXX
```

添加完公钥后再重新更新一次软件源

3.通过指定库源的方式来安装 R (如果未指定库源则还是从默认源进行下载 3.5 版本):
```bash
$ sudo apt install buster-cran40 r-base
$ R --version
R version 4.3.3 (2024-02-29)
```

大功告成，按照上面安装 ggplot2 即可
{{< /admonition >}}

## Homework

{{< admonition info >}}
实作说明:
- [x] 添加标准库的 sort_unstable 进入基准测试
- [ ] 将交换操作 (swap) 纳入基准测试
- [x] 尝试实现 Merge sort
- [x] 尝试实现 Heap sort

参考资料:
- Wikipedia: [Merge sort](https://en.wikipedia.org/wiki/Merge_sort)
- Wikipedia: [Heapsort](https://en.wikipedia.org/wiki/Heapsort)
{{< /admonition >}}

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

- Module [std::cmp](https://doc.rust-lang.org/std/cmp/index.html)
  - Trait [std::cmp::Ord](https://doc.rust-lang.org/std/cmp/trait.Ord.html)
  - Trait [std::cmp::PartialOrd](https://doc.rust-lang.org/std/cmp/trait.PartialOrd.html)
  - Trait [std::cmp::Eq](https://doc.rust-lang.org/std/cmp/trait.Eq.html)
  - Trait [std::cmp::PartialEq](https://doc.rust-lang.org/std/cmp/trait.PartialEq.html)

- Primitive Type [slice](https://doc.rust-lang.org/std/primitive.slice.html#)
  - method [slice::sort](https://doc.rust-lang.org/std/primitive.slice.html#method.sort)
  - method [slice::sort_unstable](https://doc.rust-lang.org/std/primitive.slice.html#method.sort_unstable)
  - method [slice::sort_by](https://doc.rust-lang.org/std/primitive.slice.html#method.sort_by)
  - method [slice::sort_by_key](https://doc.rust-lang.org/std/primitive.slice.html#method.sort_by_key)
  - method [slice::swap](https://doc.rust-lang.org/std/primitive.slice.html#method.swap)
  - method [slice::binary_search](https://doc.rust-lang.org/std/primitive.slice.html#method.binary_search)
  - method [slice::rotate_right](https://doc.rust-lang.org/std/primitive.slice.html#method.rotate_right)
  - method [slice::split_at_mut](https://doc.rust-lang.org/std/primitive.slice.html#method.split_at_mut)
  - method [slice::split_first_mut](https://doc.rust-lang.org/std/primitive.slice.html#method.split_first_mut)
  - method [slice::to_vec](https://doc.rust-lang.org/std/primitive.slice.html#method.to_vec)

- Trait [std::iter::Iterator](https://doc.rust-lang.org/std/iter/trait.Iterator.html)
  - method [std::iter::Iterator::min](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.min)
  - method [std::iter::Iterator::min_by_key](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.max_by_key)
  - method [std::iter::Iterator::enumerate](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.enumerate)

- Enum [std::option::Option](https://doc.rust-lang.org/std/option/enum.Option.html)
  - method [std::option::Option::expect](https://doc.rust-lang.org/std/option/enum.Option.html#method.expect)
  - method [std::option::Option::map](https://doc.rust-lang.org/std/option/enum.Option.html#method.map)

- Enum [std::result::Result](https://doc.rust-lang.org/std/result/enum.Result.html)
  - method [std::result::Result::expect](https://doc.rust-lang.org/std/result/enum.Result.html#method.expect)
  - method [std::result::Result::map](https://doc.rust-lang.org/std/result/enum.Result.html#method.map)

- Module [std::time](https://doc.rust-lang.org/std/time/index.html)
  - method [std::time::Instant::now](https://doc.rust-lang.org/std/time/struct.Instant.html)
  - method [std::time::Instant::elapsed](https://doc.rust-lang.org/std/time/struct.Instant.html#method.elapsed)
  - method [std::time::Duration::as_secs_f64](https://doc.rust-lang.org/std/time/struct.Duration.html#method.as_secs_f64)

### Crate [rand](https://docs.rs/rand/latest/rand/)

- Function [rand::thread_rng](https://docs.rs/rand/latest/rand/fn.thread_rng.html)
- method [rand::seq::SliceRandom::shuffle](https://docs.rs/rand/latest/rand/seq/trait.SliceRandom.html#tymethod.shuffle)

## References

- [orst](https://github.com/jonhoo/orst) [Github]
- [Sorting algorithm](https://en.wikipedia.org/wiki/Sorting_algorithm) [Wikipedia]
- [Timsort](https://en.wikipedia.org/wiki/Timsort) [Wikipedia]
- [Difference between Benchmarking and Profiling](https://stackoverflow.com/questions/34801622/difference-between-benchmarking-and-profiling) [Stack Overflow]
