# Crust of Rust: Iterators


> In this third Crust of Rust video, we cover iterators and trait bounds, by re-implementing the "flatten" Iterator method from the standard library. As part of that, we cover some of the weirder trait bounds that are required, including what's needed to extend the implementation to support backwards iteration.

<!--more-->

整理自 [John Gjengset 的影片](https://www.youtube.com/watch?v=yozQ9C69pNs)

## 影片注解

### Generic traits vs associated types

```rs
trait Iterator {
    type Item;
    fn next(&mut self) -> Option<Self::Item>;
}

trait Iterator<Item> {
    fn next(&mut self) -> Option<Self::Item>;
}
```

为什么使用上面的 associated type 而不是下面的 generic 来实现 `Iterator`？因为使用 generic 来实现的话，可以对一个类型实现多个 Iterator trait 例如 `Iterator<i32>`, `Iterator<f64`，而从语言表达上讲，我们希望一个类型只能实现一个 Iterator trait，所以使用 associated type 来实现 Iterator trait，防止二义性。

```rs
for v in vs.iter() {
    // borrow vs, & to v  
}

for v in &vs {
    // equivalent to vs.iter()
}
```

这两条 for 语句虽然效果一样，但是后者是使用 `<&vs> into_iter` 讲 `&vs` 转为 iterator，而不是调用 `iter()` 方法。

### Iterator::flatten

> Creates an iterator that flattens nested structure.
> 
> This is useful when you have an iterator of iterators or an iterator of things that can be turned into iterators and you want to remove one level of indirection.

`flatten()` 的本质是将一种 Iterator 类型转换成另一种 Iterator 类型，所以调用者和返回值 `Flatten` 都满足 trait Iterator，因为都是迭代器，只是将原先的 n-level 压扁为 1-level 的 Iterator 了。录影视频里只考虑 2-level 的情况。

### DoubleEndedIterator

> It is important to note that both back and forth work on the same range, and do not cross: iteration is over when they meet in the middle.

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

> Crate [std](https://doc.rust-lang.org/std/index.html) 
> ---
> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

- Trait [std::iter::Iterator](https://doc.rust-lang.org/std/iter/trait.Iterator.html)
  - method [std::iter::Iterator::flatten](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.flatten)
  - method [std::iter::Iterator::rev](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.rev)

- Trait [std::iter::IntoIterator](https://doc.rust-lang.org/std/iter/trait.IntoIterator.html)

- Struct [std::iter::Flatten](https://doc.rust-lang.org/std/iter/struct.Flatten.html)

- method [std::option::Option::and_then](https://doc.rust-lang.org/std/option/enum.Option.html#method.and_then)

- function [std::iter::empty](https://doc.rust-lang.org/std/iter/fn.empty.html)

- function [std::iter::once](https://doc.rust-lang.org/std/iter/fn.once.html)

- Trait [std::iter::DoubleEndedIterator](https://doc.rust-lang.org/std/iter/trait.DoubleEndedIterator.html)

## References

- [What is the difference between iter and into_iter?](https://stackoverflow.com/questions/34733811/what-is-the-difference-between-iter-and-into-iter)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/iterators/  

