---
title: "Command Line Applications in Rust"
subtitle:
date: 2024-04-29T16:23:33+08:00
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
  - CLI
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

> Rust is a statically compiled, fast language with great tooling and a rapidly growing ecosystem. That makes it a great fit for writing command line applications: They should be small, portable, and quick to run. Command line applications are also a great way to get started with learning Rust; or to introduce Rust to your team!

<!--more-->

- 整理自 [Command line apps in Rust](https://rust-cli.github.io/book/index.html)

## 重点提示

### Arguments

C 语言的 CLI 程序处理参数的逻辑是过程式的，即每次执行都会通过 `argv` 来获取本次执行的参数并进行相应的处理 (Rust 的 `std::env::args()` 处理 CLI 程序的参数方式也类似，都是对每次执行实例进行过程式的处理)，而 [Clap](https://docs.rs/clap/latest/clap/) 不同，它类似于面向对象的思想，通过定义一个结构体 (object)，每次运行时通过 `clap::Parser::parse` 获取并处理本次运行的参数 (即实例化 object)，这样开发的 CLI 程序扩展性会更好。

### BufReader

Struct [std::io::BufReader](https://doc.rust-lang.org/std/io/struct.BufReader.html) 中关于系统调用 (syscall) 的开销，以及如何使用 buffer 这一机制减少 syscall 调用以此提高效能，进行了比较直观的描述:

> It can be excessively inefficient to work directly with a Read instance. For example, every call to read on TcpStream results in a system call. A BufReader<R> performs large, infrequent reads on the underlying Read and maintains an in-memory buffer of the results.
> 
> BufReader<R> can improve the speed of programs that make small and repeated read calls to the same file or network socket. It does not help when reading very large amounts at once, or reading just one or a few times. It also provides no advantage when reading from a source that is already in memory, like a Vec<u8>.
> 
> When the BufReader<R> is dropped, the contents of its buffer will be discarded. Creating multiple instances of a BufReader<R> on the same stream can cause data loss. Reading from the underlying reader after unwrapping the BufReader<R> with BufReader::into_inner can also cause data loss.

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

- Function [std::fs::read_to_string](https://doc.rust-lang.org/std/fs/fn.read_to_string.html)
- Function [std::env::args](https://doc.rust-lang.org/std/env/fn.args.html)
- Struct [std::path::PathBuf](https://doc.rust-lang.org/std/path/struct.PathBuf.html)
- Struct [std::io::BufReader](https://doc.rust-lang.org/std/io/struct.BufReader.html)
- method [std::iter::Iterator::nth](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.nth)

Primitive Type str:
- method [str::lines](https://doc.rust-lang.org/std/primitive.str.html#method.lines)
- method [str::contains](https://doc.rust-lang.org/std/primitive.str.html#method.contains)

expect:
- method [std::option::Option::expect](https://doc.rust-lang.org/std/option/enum.Option.html#method.expect)
- method [std::result::Result::expect](https://doc.rust-lang.org/std/result/enum.Result.html#method.expect)

### Crate [clap](https://docs.rs/clap/latest/clap/)

- method [clap::Parser::parse](https://docs.rs/clap/latest/clap/trait.Parser.html#method.parse)

## References