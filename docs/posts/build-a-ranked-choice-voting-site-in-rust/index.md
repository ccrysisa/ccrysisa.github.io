# Build a Ranked-choice voting site in Rust


<!--more-->

> This stream is pretty different from the other ones. It's relatively informal, and is mostly me hacking together a website for you all to vote on upcoming stream ideas. I had this idea that it'd be cool to use ranked choice voting for it, since it would allow you to vote once for many ideas, as opposed to having to run many one-off Twitter polls, and that's what we're implementing here. It's mostly just hacking together rocket.rs + diesel + https://github.com/LivingInSyn/rcir, but some of you may still find it interesting!

- 整理自 [John Gjengset 的影片](https://www.youtube.com/watch?v=8LSNN-Y9Ftg)

## 影片注解

### Ranked-choice voting

- [Ranked-choice voting (RCV)](https://ballotpedia.org/Ranked-choice_voting_(RCV))

> In instant-runoff voting, if a candidate wins a majority of first-preference votes, he or she is declared the winner. If no candidate wins a majority of first-preference votes, the candidate with the fewest first-preference votes is eliminated. Ballots that ranked a failed candidate as their first, or highest choice, depending on the round, are then reevaluated and counted as first-preference ballots for the next highest ranked candidate in that round. A new tally is conducted to determine whether any candidate has won a majority ballots. The process is repeated until a candidate wins an outright majority. 

### infrastructure

Developing this ranked-choice website based on [todo](https://github.com/rwf2/Rocket/tree/master/examples/todo) example provided by [Rocket](https://github.com/rwf2/Rocket/).

Modify Cargo.toml to make the project runable:

- Crate [rocket](https://api.rocket.rs/v0.5/rocket/)
- Crate [rocket_sync_db_pools](https://api.rocket.rs/v0.5/rocket_sync_db_pools/)
- Crate [rocket_dyn_templates](https://api.rocket.rs/v0.5/rocket_dyn_templates/)

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

## References

- [Rocket](https://rocket.rs/): A web framework for Rust that makes it simple to write fast, type-safe, secure web applications with incredible usability, productivity and performance.
- [Diesel](https://diesel.rs/): Diesel is a Safe, Extensible ORM and Query Builder for Rust
- [RCIR](https://github.com/LivingInSyn/rcir) / [doc](https://docs.rs/rcir/latest/rcir/): RCIR is a ranked choice instant runoff library written in rust.
- [Sortable](https://github.com/SortableJS/Sortable): Sortable is a JavaScript library for reorderable drag-and-drop lists.



---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/build-a-ranked-choice-voting-site-in-rust/  

