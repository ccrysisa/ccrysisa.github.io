---
title: "Zero to Production in Rust"
subtitle:
date: 2024-08-28T23:29:43+08:00
draft: true
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
  - Backend
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

记录阅读 [Zero To Production In Rust](https://www.zero2prod.com/index.html) 时的一些思考、细节。

> Zero To Production is the ideal starting point for your journey as a Rust backend developer.
> You will learn by doing: you will build a fully functional email newsletter API, starting from scratch.

<!--more-->

## Preface

什么是 Trunked-base Development 和 Git Flow?

- [Trunk-based Development vs. Git Flow](https://www.toptal.com/software/trunk-based-development-git-flow)

> In the Git flow development model, you have one main development branch with strict access to it. It’s often called the develop branch.
> 
> Developers create feature branches from this main branch and work on them. Once they are done, they create pull requests. In pull requests, other developers comment on changes and may have discussions, often quite lengthy ones.

> In the trunk-based development model, all developers work on a single branch with open access to it. Often it’s simply the master branch. They commit code to it and run it. It’s super simple.
> 
> In some cases, they create short-lived feature branches. Once code on their branch compiles and passess all tests, they merge it straight to master. It ensures that development is truly continuous and prevents developers from creating merge conflicts that are difficult to resolve.

## Getting Started

采用 Rust 的 stable 工具链进行编译，同时并不需要进行交叉编译，因为是在 Container 中进行开发

我采用的方案: VS Code + rust-analyzer

- [The rustup book](https://rust-lang.github.io/rustup/)
- [The Cargo Book](https://doc.rust-lang.org/cargo/)
- [Rust Analyzer](https://rust-analyzer.github.io/)

[The developer experience and the inner dev loop](https://www.getambassador.io/docs/telepresence/latest/concepts/devloop)

> The inner dev loop is the single developer workflow. A single developer should be able to set up and use an inner dev loop to code and test changes quickly.

```bash
cargo watch -x check -x test -x run
```

Continuous Integration (CI): [GitHub Actions - Rust Setup](https://gist.github.com/LukeMathWalker/5ae1107432ce283310c3e601fac915f3)

- Tests: `cargo test`
- Code Coverage: `cargo tarpaulin --ignore-tests`
- Linting: `cargo clippy -- -D warnings`
- Formatting: `cargo fmt -- --check`
- Security Vulnerabilities: `cargo audit`

## Building An Email Newsletter

{{< admonition note "User Stories" >}}
As a …,   
I want to …,   
So that …   
{{< /admonition >}}

A user story helps us to capture who we are building for (*as a*), the actions they want to perform (*want to*) as well as their motives (*so that*).

---

Instead of going deep on one story, we will try to build enough functionality to satisfy, to an extent, the requirements of all of our stories in our first release.

We will then go back and improve: add fault-tolerance and retries for email delivery, add a confirmation email for new subscribers, etc.

## Sign Up A New Subscriber

{{< admonition note "User Story" >}}
As a blog visitor,   
I want to subscribe to the newsletter,   
So that I can receive email updates when new content is published on the blog.
{{< /admonition >}}

Web Framework:

- [Actix Web](https://actix.rs/) is a powerful, pragmatic, and extremely fast web framework for Rust
- Crate [actix_web](https://docs.rs/actix-web/4.0.1/actix_web/index.html)
- GitHub: [actix/examples](https://github.com/actix/examples): Community showcase and examples of Actix Web ecosystem usage.

### Infrastructure

依据基础的不同，可能需要补充的相关知识:

- [Rust Async 异步编程 简易教程](https://www.bilibili.com/video/BV16r4y187P4)
- [Serde: Rust 的序列化解决方案](https://www.bilibili.com/video/BV1Nu411z7w8)

异步或者并发是一种可以充分利用 CPU 的程序结构，Rust 通过异步运行时来实现对 CPU 资源的充分利用，让程序员无需关心底层采用的技术，例如采用单线程或多线程方案，这些由异步运行时来决定，即程序员无需再关心线程以及线程之间的顺序，也就是说异步在线程之上又构建了一层抽象。

```goat
 poll                         
  +                          
  | after one moment                    
  +                          
 wake                         
```

宏 `#[derive(Serialize)]` 可以生成对应的 `serialize` 方法，但该方法需要一个 `Serializer` 参数 (序列号 / 反序列化构造器)，而该 `Serializer` 并不会被该宏生成，需要我们提供 (自己写或使用第三方库)。`deserialize` 也是类似的。

```rs
pub trait Serialize {
    // Required method
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
       where S: Serializer;
}
```


### A Basic Health Check

- [curl 的用法指南](https://www.ruanyifeng.com/blog/2019/09/curl-reference.html)

```goat
   Handler              Layer       
+------------+     +-------------+
|    App     | <-> | Application |
+------------+     +-------------+
| HttpServer | <-> |  Transport  |
+------------+     +-------------+
```

> This is often referred to as *black box testing*: we verify the behaviour of a system by examining its output given a set of inputs without having access to the details of its internal implementation.

#### Tests

- next to your code in an embedded test module: 通过条件编译的方式实现
- in an external `tests` folder 和 as part of your public documentation (doc tests): 将测试用例单独编译为独立的二进制

```goat
                  +------------+
                  | HttpServer |
+------------+    +------------+
| HttpServer |    |    run     |
|------------|    |------------|
|   closure  |    |  closure   |
+------------+    +------------+
|    main    |    |    main    |
+------------+    +------------+
```

#### Server

- Struct [actix_web::dev::Server](https://docs.rs/actix-web/4.9.0/actix_web/dev/struct.Server.html)

> The Server must be awaited or polled in order to start running. It will resolve when the server has fully shut down.

即 `Server` 的作用类似一个句柄，所以在调用 [run](https://docs.rs/actix-web/4.9.0/actix_web/struct.HttpServer.html#method.run) 方法后可以通过这个句柄来选择何种 I/O 模型 (awaited or polled)。

### HTML Forms

> You can immediately spot a limitation of “roll-your-own” parametrised tests: as soon as one test case fails, the execution stops and we do not know the outcome for the following tests cases.

手工实现的 roll-your-own 风格的 Parametrised Tests，受限于实作的 `for` 语法，只能逐个测试用例执行，一旦某个测试样例失败则会受制于 `assert` 宏的限制，不会再往下执行其他的测试用例。
