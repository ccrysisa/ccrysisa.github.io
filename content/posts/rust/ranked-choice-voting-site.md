---
title: "Rust Coding: Build a Ranked-choice voting site"
subtitle:
date: 2024-03-08T21:14:30+08:00
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
  - Ranked-choice voting
  - Website
categories:
  - draft
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

<!--more-->

## 影片注解

### Ranked-choice voting

- [Ranked-choice voting (RCV)](https://ballotpedia.org/Ranked-choice_voting_(RCV))
> In instant-runoff voting, if a candidate wins a majority of first-preference votes, he or she is declared the winner. If no candidate wins a majority of first-preference votes, the candidate with the fewest first-preference votes is eliminated. Ballots that ranked a failed candidate as their first, or highest choice, depending on the round, are then reevaluated and counted as first-preference ballots for the next highest ranked candidate in that round. A new tally is conducted to determine whether any candidate has won a majority ballots. The process is repeated until a candidate wins an outright majority. 

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

## References

- Rocket: https://rocket.rs/
- Diesel: https://diesel.rs/
- RCIR: https://github.com/LivingInSyn/rcir / https://docs.rs/rcir/latest/rcir/
- Sortable: https://github.com/SortableJS/Sortable
