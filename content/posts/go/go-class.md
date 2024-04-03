---
title: "Matt KØDVB: Go Class 重点提示"
subtitle:
date: 2024-03-25T10:16:26+08:00
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
  - Go
categories:
  - Toolbox
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

## Intro and Why Use Go?

简单介绍了一下 Go 语言以及其特点、优势。

*\"A language that doesn\'t have everything is actually easier to program in than some that do.\" — Dennis Ritchie*

## Hello world!

编写经典的 hello world 程序，在 [Go Playground](https://go.dev/play/) 上执行，介绍了该简单程序的组成部分，例如 package, import, func 等 (`main` 函数必须放置在 `main` 包里)。

根据 [用户文档](https://go.dev/doc/install) 安装 Go 并通过 `go run` 执行 hello world 程序 (这里我安装的是 Go 语言此时的最新版 1.22.1):

```bash
# install Go
$ rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.1.linux-amd64.tar.gz

# add the line below into ~/.bashrc if you use bash as your shell
export PATH=$PATH:/usr/local/go/bin

$ source ~/.bashrc
$ go version
go version go1.22.1 linux/amd64

$ mkdir hello && cd hello
# write code about print hello world in hello.go and config in go.mod
$ go run .
Hello, world!
```

学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

https://pkg.go.dev/

可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

## Simple Example

Source: https://github.com/ccrysisa/go-class/examples/cmd/

学习相关命令: `go run`, `go test`

## Basic Types

介绍了 Go 语言的基本数据类型，例如整数、浮点数等类型。

Source: 
- https://github.com/ccrysisa/go-class/examples/numbers/
- https://github.com/ccrysisa/go-class/examples/types/
