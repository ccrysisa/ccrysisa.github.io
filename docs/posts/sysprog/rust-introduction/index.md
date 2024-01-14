# Rust - 进行中的未来


## Rust in 100 Seconds

:white_check_mark: 观看短片：[Rust in 100 Seconds][rust-in-100s] 
- [x] 了解 Rust，初步了解其安全性原理
- [x] 所有权 (ownership)
- [x] 借用 (borrow) 

{{< admonition warning >}}
0:55 This is wrong, value mutability doesn't have anything to do with the value being stored on the stack or the heap (and the example `let mut hello = "hi mom"` will be stored on the stack since it's type is `&'static str`), it depends on the type of the value (if it's `Sized` or not).
{{< /admonition >}}

## The adoption of Rust in Business (2022)

:x: 阅读报告 [The adoption of Rust in Business (2022)][2022-review-the-adoption-of-rust-in-business]。


[rust-in-100s]: https://youtu.be/5C_HPTJg5ek
[2022-review-the-adoption-of-rust-in-business]: https://rustmagazine.org/issue-1/2022-review-the-adoption-of-rust-in-business/


---

> 作者: [Xshine](https://github.com/LoongGshine)  
> URL: https://loonggshine.github.io/posts/sysprog/rust-introduction/  

