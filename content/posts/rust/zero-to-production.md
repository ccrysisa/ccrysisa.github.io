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
  - draft
categories:
  - draft
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

VS Code + rust-analyzer

- [The rustup book](https://rust-lang.github.io/rustup/)
- [The Cargo Book](https://doc.rust-lang.org/cargo/)
- [Rust Analyzer](https://rust-analyzer.github.io/)
