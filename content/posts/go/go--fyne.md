---
title: "Build GUI applications in Go with Fyne"
subtitle:
date: 2025-03-19T16:19:33+08:00
slug: 8a02991
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
  - Go
  - Fyne
categories:
  - Go
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

<!--more-->

## 入门注解

### Go 项目开发常用命令

- `go mod init <name>`: 创建 module 和 go.mod 文件
- `go get <name>`: 为 module 添加依赖，类似于 `cargo add <name>`
- `go mod tidy`: 更新 module 的依赖情况，即更新 go.mod 和 go.sum 的内容

> 注意使用 `go mod tidy` 命令后，VS Code 的 Go 插件需要一段时间才能更新完成代码分析的缓存，不再报错。go.mod 文件认为功能类似于 Cargo.toml，go.sum 文件功能类似于 Cargo.lock。

{{< admonition type=quote title="[Difference between go mod download and go mod tidy](https://stackoverflow.com/questions/71495619/difference-between-go-mod-download-and-go-mod-tidy)" >}}
- **go mod download**: Downloads modules without modifying `go.mod` or `go.sum`.
- **go mod tidy**: Cleans and updates `go.mod` and `go.sum` by ensuring they reflect the actual dependencies required by the code.
{{< /admonition >}}

### Fyne

[Fyne](https://fyne.io/) 写 GUI 的思路是：使用控件 (widget) 来显示，绑定回调函数 (callback) 来设置控件动作，最后通无限循环的事件监听来实时更新图形界面。

### Go 模块管理

Go 语言的模块管理和 Rust 大不相同，更偏向 C 语言的多文件拼接的方式，同一 package 的文件就好象被拼接为一个大文件来一般，无需使用 `import` 来进行引入。

### GC

Go 的编译器将 `&value` 分析为取 `value` 的地址，这与 C 语言一致；但是 Go 编译器将 `&Type` 分析为类似 C++/Java `new Type {...}` 的语句，即创建 Pointer Machine 中的物件 (Object)，由 GC 对这些物件进行管理。Go 语言的函数调用也遵循 C 语言的 **值传递** 哲学。

### Interface

至于 Go 的 Interface 与 Rust 的 Trait，主要用于编译器在编译时期对代码进行分析和检查，并不在运行时期起作用，但与 Rust 通过指定来显式实现 Trait 不同，Go 中则是通过实现全部所需的方法来隐式实现 Interface 的。

### Defer

Go  中的`defer` 语句可以理解为在任意 `return` 语句执行前都会被执行的语句。

### Tests

Go 的测试也挺精简的: [Add a test](https://go.dev/doc/tutorial/add-a-test)

> Ending a file\'s name with `_test.go` tells the go test command that this file contains test functions.

## 进阶注解

### 热重载

[Air](https://github.com/air-verse/air) 热重载 fyne 和 gin 的逻辑是检测当前 module 的源文件是否被修改，若被修改则重新编译运行（因为 go 是编译型语言，只能实现这种程度的热重载来）。

## References

- bilibili: [Go + Fyne 快速上手教程](https://www.bilibili.com/video/BV1u142187Ps/)
- bilibili: [Go + Fyne 进阶教程](https://www.bilibili.com/video/BV1kz421i7iB/)

---

## 实作案例: Building Microservices with Go

YouTube:  Nic Jackson 制作的 [Building Microservices with Go](https://www.youtube.com/playlist?list=PLmD8u-IFdreyh6EUfevBcbiuCKzFk0EW_) 系列影片

> Week by week Building Microservices builds on the previous weeks code teaching you how to build a multi-tier microservice system. The code structure for the course is one of a mono repo. To make it simple to follow along, each episode has its own branch showing progress to date.

- Nic Jackson\'s [Building Microservices with Go](https://www.youtube.com/playlist?list=PLmD8u-IFdreyh6EUfevBcbiuCKzFk0EW_): 一个不错的 Go 练习项目
- [极客兔兔](https://geektutu.com/)
- [Learn Go with Tests](https://quii.gitbook.io/learn-go-with-tests)
