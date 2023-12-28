---
title: First_post
subtitle:
date: 2023-12-23T20:23:12+08:00
draft: false
author:
  name: Xshine
  link: https://github.com/LoongGshine
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

## References

- [FixIt 快速上手](https://fixit.lruihao.cn/zh-cn/documentation/getting-started/)
- [使用 Hugo + Github 搭建个人博客](https://zhuanlan.zhihu.com/p/105021100)
