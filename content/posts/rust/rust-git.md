---
title: "Rust Coding: Implementing git from scratch in Rust"
subtitle:
date: 2024-03-13T15:03:16+08:00
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
  - draft
  - Rust
  - Git 
categories:
  - draft
  - Rust
  - Git
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

> In this stream, we implement core pieces of git from scratch by following the CodeCrafters git "course" https://github.com/codecrafters-io/build-your-own-git.

<!--more-->

- 整理自 [John Gjengset 的影片](https://www.youtube.com/watch?v=u0VotuGzD_w)

{{< admonition quote >}}
Git is a version control system used to track changes in source code. In this challenge, you\'ll build your own Git implementation that is capable of cloning a public repository from GitHub.

Along the way, you\'ll learn about the .git directory, Git objects, plumbing commands and more.
{{< /admonition >}}

## 影片注解

### Starter Code

CodeCrafters 的课程是需要付费的，但好在它们在 Github 上也提供了起始代码，只是少了很多“基础设施” (例如测试用例，实现提示之类的)。但是不要紧，优秀的 Programmer 就是可以自己完成实现、测试一条龙服务 :rofl:

在 [这里](https://github.com/codecrafters-io/build-your-own-git/tree/main/starter_templates/rust) 将 Rust 版本的起始代码拷贝下来，然后进行开发。关于这个目录下的 your_git 脚本，看自身需求，个人认为如果不付费的话不需要。

### clap

使用 [clap](https://docs.rs/clap/latest/clap/) 可以简化命令行参数的处理流程，比标准库提供的方法更方便。

向开发项目添加依赖项 clap:

```bash
$ cargo add clap --features derive
```

> 效果相当于在 Cargo.toml 中添加依赖，执行完该命令后可以发现 Cargo.toml 的依赖项已正确添加了 clap

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

### Crate [clap](https://docs.rs/clap/latest/clap/)

- Trait [clap::Subcommand](https://docs.rs/clap/latest/clap/trait.Subcommand.html)

## References

- [Missing Semester class on git](https://missing.csail.mit.edu/2020/version-control/)
- https://github.com/jonhoo/codecrafters-git-rust
