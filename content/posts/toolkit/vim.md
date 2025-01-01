---
title: "编辑器之神: Vim"
subtitle:
date: 2025-01-01T15:16:18+08:00
slug: 8104592
draft: false
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
  - Vim
categories:
  - Toolkit
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRelated: false
hiddenFromFeed: false
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

{{< center-quote >}}
**Edit Text at the Speed of Thought**
{{< /center-quote >}}

<!--more-->

以下投影片均节选自 B 站 UP 主 [@郁结YuJie](https://space.bilibili.com/523426907) 所制作的 PDF 文件。

## 初识 Vim

{{< image src="/images/tools/vim/1-01.png" >}}
{{< image src="/images/tools/vim/1-02.png" >}}
{{< image src="/images/tools/vim/1-03.png" >}}
{{< image src="/images/tools/vim/1-04.png" >}}
{{< image src="/images/tools/vim/1-05.png" >}}
{{< image src="/images/tools/vim/1-06.png" >}}
{{< image src="/images/tools/vim/1-07.png" >}}
{{< image src="/images/tools/vim/1-08.png" >}}
{{< image src="/images/tools/vim/1-09.png" >}}
{{< image src="/images/tools/vim/1-10.png" >}}

{{< admonition tip >}}
- Normal: `u` for Up, `d` for Down. `t` for Top, `b` for Bottom
- Insert: 除了 `o` / `O` 大小写分别对应上下行之外，其他的命令小写以字符为单位，大写则以行为单位
- Command: `h` for `help`
- Visual: `v` 以字符为单位，`V` 以行为单位
{{< /admonition >}}

## 移动和编辑

{{< image src="/images/tools/vim/2-01.png" >}}
{{< image src="/images/tools/vim/2-02.png" >}}
{{< image src="/images/tools/vim/2-03.png" >}}
{{< image src="/images/tools/vim/2-04.png" >}}
{{< image src="/images/tools/vim/2-05.png" >}}
{{< image src="/images/tools/vim/2-06.png" >}}
{{< image src="/images/tools/vim/2-07.png" >}}
{{< image src="/images/tools/vim/2-08.png" >}}
{{< image src="/images/tools/vim/2-09.png" >}}
{{< image src="/images/tools/vim/2-10.png" >}}

{{< admonition tip >}}
- Vim 的移动和修改是分开的，隶属于不同模式
- `gg` / `G` 这种就是跳转操作
{{< /admonition >}}

## 文本对象操作

{{< image src="/images/tools/vim/3-01.png" >}}
{{< image src="/images/tools/vim/3-02.png" >}}
{{< image src="/images/tools/vim/3-03.png" >}}
{{< image src="/images/tools/vim/3-04.png" >}}
{{< image src="/images/tools/vim/3-05.png" >}}
{{< image src="/images/tools/vim/3-06.png" >}}
{{< image src="/images/tools/vim/3-07.png" >}}
{{< image src="/images/tools/vim/3-08.png" >}}
{{< image src="/images/tools/vim/3-09.png" >}}
{{< image src="/images/tools/vim/3-10.png" >}}

{{< admonition tip >}}
- 操作符也是 Normal 模式下使用的
- 配合 Command 的 `h` 命令来查询相关的命令说明
{{< /admonition >}}

## 寄存器与宏

{{< image src="/images/tools/vim/4-01.png" >}}
{{< image src="/images/tools/vim/4-02.png" >}}
{{< image src="/images/tools/vim/4-03.png" >}}
{{< image src="/images/tools/vim/4-04.png" >}}
{{< image src="/images/tools/vim/4-05.png" >}}
{{< image src="/images/tools/vim/4-06.png" >}}

## 命令模式

{{< image src="/images/tools/vim/5-01.png" >}}
{{< image src="/images/tools/vim/5-02.png" >}}
{{< image src="/images/tools/vim/5-03.png" >}}
{{< image src="/images/tools/vim/5-04.png" >}}
{{< image src="/images/tools/vim/5-05.png" >}}
{{< image src="/images/tools/vim/5-06.png" >}}
{{< image src="/images/tools/vim/5-07.png" >}}
{{< image src="/images/tools/vim/5-08.png" >}}
{{< image src="/images/tools/vim/5-09.png" >}}
{{< image src="/images/tools/vim/5-10.png" >}}
{{< image src="/images/tools/vim/5-11.png" >}}

## 回顾与总结

{{< image src="/images/tools/vim/6-01.png" >}}
{{< image src="/images/tools/vim/6-02.png" >}}
{{< image src="/images/tools/vim/6-03.png" >}}
{{< image src="/images/tools/vim/6-04.png" >}}
{{< image src="/images/tools/vim/6-05.png" >}}

## References

- [可能是 B 站最系统的 Vim 教程](https://www.bilibili.com/video/BV1s4421A7he/)
- [Practical Vim, Second Edition](https://pragprog.com/titles/dnvim2/practical-vim-second-edition/)
