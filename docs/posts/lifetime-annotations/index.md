# Crust of Rust: Lifetime Annotations


Rust 中的 lifetime 一向是一个难点，为了更好地理解这一难点的本质，建议阅读 C 语言规格书关于 lifetime 的部分，相信你会对 Rust 的 lifetime 有不同的看法。

<!--more-->

cargo check 可以给出更简洁的提示，例如相对于编译器给出的错误信息，它会整合相同的错误信息，从而提供简洁切要的提示信息。而且它是一个静态分析工具，不需要进行编译即可给出提示，所以速度会比编译快很多，在大型项目上尤为明显。

影片大概 49 分时提到了

```rs
if let Some(ref mut remainder) = self.remainder {...} 
```

的 `ref` 的作用，这里配合 `if let` 语句体的逻辑可以体会到 pointer of pointer 的美妙之处。

在 pattern match 中形如 `&mut` 这类也是用于 pattern match 的，不能用于获取 reference，这也是为什么需要使用 `ref mut` 这类语法来获取 reference 的原因。

## Documentation

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

> Crate [std](https://doc.rust-lang.org/std/index.html) 
> ---
> 可以使用这里的搜素栏进行搜索

- Keyword [SelfTy](https://doc.rust-lang.org/std/keyword.SelfTy.html)
- method [str::find](https://doc.rust-lang.org/std/primitive.str.html#method.find)
- Trait [std::iter::Iterator](https://doc.rust-lang.org/std/iter/trait.Iterator.html)
- method [std::iter::Iterator::eq](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.eq)
- method [std::iter::Iterator::collect](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.collect)
- method [std::option::Option::take](https://doc.rust-lang.org/std/option/enum.Option.html#method.take)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/lifetime-annotations/  

