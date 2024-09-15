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

Async:
- [Rust Async 异步编程 简易教程](https://www.bilibili.com/video/BV16r4y187P4)
- [Rust Async 异步编程](https://www.bilibili.com/video/BV1Ki4y1C7gj/)
- Jon Gjengset: [Crust of Rust: async/await](https://www.youtube.com/watch?v=ThjvMReOXYM&list=PLqbS7AVVErFiWDOAVrPt7aYmnuuOLYvOa&index=11&pp=iAQB)

Serde:
- [Serde: Rust 的序列化解决方案](https://www.bilibili.com/video/BV1Nu411z7w8)
- Jon Gjengset: [Decrusting the serde crate](https://www.youtube.com/watch?v=BI_bHCGRgMY)
-  Josh Mcguigan: [Understanding Serde](https://www.joshmcguigan.com/blog/understanding-serde/)

sqlx:
- [Rust 数据库异步解决方案: sqlx + sqlb](https://www.bilibili.com/video/BV1sL411A748/)

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

这个 `Serializer` 是一个 trait，其具体的类型不由 serde 提供，而是由支持特定格式序列化 / 反序列化的第三方库来实现，例如 serde_json, serde_yaml 等。

Example:

```toml { title="Cargo.toml" }
...
[dependencies]
serde = { version = "1", features = ["derive"] }
serde_json = "1"
serde_yaml = "0.9"
```

```json { title="data.json" }
{
    "name": "gshine",
    "age": 24,
    "phone": [
        "123456",
        "98765"
    ]
}
```

```rs { title="main.rs" }
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
struct Pay {
    amount: i32,
    tax_percent: f32,
}

#[derive(Serialize, Deserialize, Debug)]
struct Person {
    name: String,
    age: u8,
    phone: String,
    pays: Vec<Pay>,
}

fn main() {
    let ps = vec![Person {
        name: "gshine".to_string(),
        age: 24,
        phone: "123456".to_string(),
        pays: vec![
            Pay {
                amount: 78,
                tax_percent: 0.3,
            },
            Pay {
                amount: 128,
                tax_percent: 0.7,
            },
        ],
    }];

    // Serialize
    let json_str = serde_json::to_string_pretty(&ps).unwrap();
    let yaml_str = serde_yaml::to_string(&ps).unwrap();
    println!("json:\n{}", json_str);
    println!("yaml:\n{}", yaml_str);

    // Deserialize
    let ps_json: Vec<Person> = serde_json::from_str(&json_str).unwrap();
    let ps_yaml: Vec<Person> = serde_yaml::from_str(&yaml_str).unwrap();
    println!("json: {:#?}", ps_json);
    println!("yaml: {:#?}", ps_yaml);

    // Modify
    let json_data = std::fs::read_to_string("./data.json").unwrap();
    let mut data: serde_json::Value = serde_json::from_str(&json_data).unwrap();
    println!("before: {}", data.to_string());

    // key-value
    data["car"] = serde_json::Value::String("fd".to_string());
    println!("after: {}", data.to_string());
    // map
    let mut map_value = serde_json::Map::new();
    map_value.insert(
        "color".to_string(),
        serde_json::Value::String("blue".to_string()),
    );
    // array
    map_value.insert(
        "year".to_string(),
        serde_json::Value::Array(vec![
            serde_json::Value::String("1945".to_string()),
            serde_json::Value::String("1950".to_string()),
        ]),
    );
    data["car"] = serde_json::Value::Object(map_value);

    println!("after: {}", data.to_string());
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

### Databases

{{< admonition >}}
Threads are for working in parallel, async is for waiting in parallel.
{{< /admonition >}}

- PostgreSQL: Documentation [5.9. Schemas](https://www.postgresql.org/docs/9.5/ddl-schemas.html)

> A PostgreSQL database cluster contains one or more named databases. Roles and a few other object types are shared across the entire cluster. A client connection to the server can only access data in a single database, the one specified in the connection request.
> 
> A database contains one or more named schemas, which in turn contain tables. Schemas also contain other kinds of named objects, including data types, functions, and operators. The same object name can be used in different schemas without conflict; for example, both `schema1` and `myschema` can contain tables named `mytable`. Unlike databases, schemas are not rigidly separated: a user can access objects in any of the schemas in the database they are connected to, if they have privileges to do so.

书中这一章节所指的 Database migration 实为 Schema migration，根据 [Wikipedia](https://en.wikipedia.org/wiki/Schema_migration) 的定义:

> In software engineering, a schema migration (also database migration, database change management) refers to the management of version-controlled, incremental and sometimes reversible changes to relational database schemas. A schema migration is performed on a database whenever it is necessary to update or revert that database's schema to some newer or older version.

即类似于 Git 的版本控制但是用于数据库的 Schema 的状态转换，即只有涉及 schema 的改动才需要使用该版本控制，而针对数据条目的改动并不需要。同时它也起到一个日志的功能，重新启动数据库时可以根据 migration 记录来将数据库的 schma 内容迁移到指定状态。

crate.io: [sqlx](https://crates.io/crates/sqlx) - Cargo Feature Flags

> Actix-web is fully compatible with Tokio and so a separate runtime feature is no longer needed.

这一节有些地方需要使用 [ConfigBuilder](https://docs.rs/config/latest/config/builder/struct.ConfigBuilder.html) 进行重写，这时可以参考作者的 [zero2prod](https://github.com/LukeMathWalker/zero-to-production) 库进行观摩学习。

[app_data](https://docs.rs/actix-web/4.0.1/actix_web/struct.App.html#method.app_data):

> Set application (root level) data.
> 
> Application data stored with `App::app_data()` method is available through the `HttpRequest::app_data` method at runtime.

即是整个应用程序的所有 handlers 都共享的 application data。

sqlx 允许同时读和互斥写，使用不可变引用和可变引用机制来实现则让其执行也满足了 $N: 1$ 模型。如果采用 `Mutex` 方案来获取可变引用，会导致读操作也是互斥的，这大大降低了性能。`PgPool` 采用了内部可变性机制，使得对于读写满足 $N: 1$ 模型，使得其性能不弱于采用不可变引用和可变引用机制的 `PgConnection`。