---
title: Hello, World
subtitle:
date: 2023-12-23T20:23:12+08:00
draft: false
author:
  name: ccrysisa
  link: https://github.com/ccrysisa
  email: caijiaxin@dragonos.org
  avatar: https://avatars.githubusercontent.com/u/133117003?s=400&v=4
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

博客（英语：Blog）是一种在线日记型式的个人网站，借由张帖子章、图片或视频来记录生活、抒发情感或分享信息。博客上的文章通常根据张贴时间，以倒序方式由新到旧排列。

## 数学公式

行内公式：$N(b,d)=(b-1)M$

公式块：

{{< raw >}}
$$
\int_{a}^{b}x(t)dt =
\dfrac{b - a}{N} \\
=\sum_{k=1}^{N}x(t_k)\cdot\dfrac{b-a}{N}
$$
{{< /raw >}}

{{< raw >}}
$$
\begin{aligned}
\int_{a}^{b}x(t)dt &=
\dfrac{b - a}{N} \\
&=\sum_{k=1}^{N}x(t_k)\cdot\dfrac{b-a}{N} \\
\end{aligned}
$$
{{< /raw >}}

{{< raw >}}
$$
\mathrm{Integrals\ are\ numerically\ approximated\ as\ finite\ series}:\\ 
\begin{split}
\int_{a}^{b}x(t)dt &=
\dfrac{b - a}{N} \\
&=\sum_{k=1}^{N}x(t_k)\cdot\dfrac{b-a}{N}
\end{split} \\ 
where\ t_k = a + (b-a)\cdot k/N
$$
{{< /raw >}}

{{< raw>}}
$$
\begin{align*}
p(x) = 3x^6 + 14x^5y &+ 590x^4y^2 + 19x^3y^3 \\
&- 12x^2y^4 - 12xy^5 + 2y^6 - a^3b^3 - a^2b - ab + c^5d^3 + c^4d^3 - cd
\end{align*}
$$
{{< /raw >}}

{{< raw >}}
$$
\begin{split}
&(X \in B) = X^{-1}(B) = {s \in S: X(s) \in B} \subset S \\
&\Rightarrow P(x \in B) = P({s \in S: X(s) \in B})
\end{split}
$$
{{< /raw >}}

## 代码块

```rs
let i: i32 = 13;
let v = vec![1, 2, 3, 4, 5, 65];
for x in v.iter() {
    println!("{}", x);
}
```

```c
typedef struct Block_t {
    int head;
    int data;
} Block_t;
```

## Admonition

{{< admonition >}} 
[111年度資工所心得](https://hackmd.io/@ygb5JBlmSc-8GJtxiMg5Fw/B1-rO9vb9)
{{< /admonition >}}

{{< admonition abstract >}} 
Udacity (Georgia Tech):

- Advanced Operating Systems:
[Part 1](https://www.youtube.com/playlist?list=PLAwxTw4SYaPkKfusBLVfklgfdcB3BNpwX) /
[Part 2](https://www.youtube.com/playlist?list=PLAwxTw4SYaPm4vV1XbFV93ZuT2saSq1hO) /
[Part 3](https://www.youtube.com/playlist?list=PLAwxTw4SYaPk5-YaXFkWY4UXdv6pVdiYg) /
[Part 4](https://www.youtube.com/playlist?list=PLAwxTw4SYaPmfaiuzJcK3tNoeKlvRR990)
- High Performance Computer Architecture:
[Part 1](https://www.youtube.com/playlist?list=PLAwxTw4SYaPmqpjgrmf4-DGlaeV0om4iP) /
[Part 2](https://www.youtube.com/playlist?list=PLAwxTw4SYaPkNw98-MFodLzKgi6bYGjZs) /
[Part 3](https://www.youtube.com/playlist?list=PLAwxTw4SYaPnhRXZ6wuHnnclMLfg_yjHs) /
[Part 4](https://www.youtube.com/playlist?list=PLAwxTw4SYaPn79fsplIuZG34KwbkYSedj) /
[Part 5](https://www.youtube.com/playlist?list=PLAwxTw4SYaPkr-vo9gKBTid_BWpWEfuXe) /
[Part 6](https://www.youtube.com/playlist?list=PLAwxTw4SYaPndXEsI4kAa6BDSTRbkCKJN)
{{< /admonition >}}

{{< admonition info >}} 
Reddit: [Best book to learn in-depth knowledge about the Linux Kernel?](https://www.reddit.com/r/linux/comments/z26h5h/best_book_to_learn_indepth_knowledge_about_the/)
- Project: [Linux From Scratch](https://www.linuxfromscratch.org/)
- Book: [Linux Kernel Development](https://www.amazon.com/Linux-Kernel-Development-Robert-Love/dp/0672329468)
- Video: [Steven Rostedt - Learning the Linux Kernel with tracing](https://www.youtube.com/watch?v=JRyrhsx-L5Y)
{{< /admonition >}}

{{< admonition tip >}} 
Wikipedia: 
[Xenix](https://en.wikipedia.org/wiki/Xenix) /
[Multics](https://en.wikipedia.org/wiki/Multics) /
[Plan9](https://en.wikipedia.org/wiki/Plan_9_from_Bell_Labs) /
[FreeBSD](https://en.wikipedia.org/wiki/FreeBSD)
{{< /admonition >}}

{{< admonition success >}}
Talks:

- [Developing Kernel Drivers with Modern C++ - Pavel Yosifovich](https://www.youtube.com/watch?v=AsSMKL5vaXw)
- [Containers From Scratch • Liz Rice • GOTO 2018](https://www.youtube.com/watch?v=8fi7uSYlOdc)
- [Rich Hickey Talks](https://www.youtube.com/playlist?list=PLZdCLR02grLrEwKaZv-5QbUzK0zGKOOcr)
{{< /admonition >}}

{{< admonition question >}} 一个 问题 横幅 {{< /admonition >}}

{{< admonition warning >}} 一个 警告 横幅 {{< /admonition >}}

{{< admonition failure >}} 一个 失败 横幅 {{< /admonition >}}

{{< admonition danger >}} 一个 危险 横幅 {{< /admonition >}}

{{< admonition bug >}} 一个 Bug 横幅 {{< /admonition >}}

{{< admonition example >}} 一个 示例 横幅 {{< /admonition >}}

{{< admonition quote >}} 一个 引用 横幅 {{< /admonition >}}

## References

- [FixIt 快速上手](https://fixit.lruihao.cn/zh-cn/documentation/getting-started/)
- [使用 Hugo + Github 搭建个人博客](https://zhuanlan.zhihu.com/p/105021100)
- [Markdown 基本语法](https://fixit.lruihao.cn/zh-cn/documentation/content-management/markdown-syntax/basics/)
- [Emoji 支持](https://fixit.lruihao.cn/zh-cn/guides/emoji-support/)
- [扩展 Shortcodes 概述](https://fixit.lruihao.cn/zh-cn/documentation/content-management/shortcodes/extended/introduction/#admonition)
- [图表支持](https://fixit.lruihao.cn/zh-cn/documentation/content-management/diagrams/)
- [URL management](https://gohugo.io/content-management/urls/#permalinks)



