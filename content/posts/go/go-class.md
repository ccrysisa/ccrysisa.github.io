---
title: "Tutorial: Go Class"
subtitle:
date: 2024-12-22T23:23:53+08:00
slug: 60f4958
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

{{< image src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Go_Logo_Blue.svg/322px-Go_Logo_Blue.svg.png" >}}
{{< image src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Golang.png/330px-Golang.png" >}}

<!--more-->

## Intro and Why Use Go?

个人观点: Go 语言是集成了垃圾回收 (GC) 机制、并发特化、具备动态类型解释型语便利性的现代 C 语言，它继承了 C 语言一以贯之的简洁性，不追求像 C++ 那般大而全。

"A language that doesn\'t have everything is actually easier to program in than some that do." --- Dennis Ritchie

## Hello world!

Installation: [Download and install](https://go.dev/doc/install)

```sh
# Select the version for your computer's operating system
# Then remove any previous go and create a fresh Go tree in `/usr/local/`
$ tar -zxvf /path/to/go<version>.<os>-<arch>.tar.gz
# Create symbol links of programs (go and gofmt) in `go/bin/`
$ sudo ln -s /path/to/go/bin/* /usr/local/bin/
# Test go version
$ go version
go version go<version> <os>/<Arch>
```

接下来运用 `go env` 命令找到那些设定在 $HOME 目录下的环境变量，将其修改为指定地址:

```sh
$ go env | grep "$HOME/go"
GOMODCACHE='<$HOME>/go/pkg/mod'
GOPATH='<$HOME>/go'
$ go env -w GOMODCACHE='<$HOME>/.go/pkg/mod'
$ go env -w GOPATH='<$HOME>/.go'
```

使用 `$HOME/.go` 使 go 包管理的内容像 cargo 指定的路径 `$HOME/.cargo` 一般默认在 HOME 目录不显示。然后设置 `GO111MODULE` 环境变量为 `on`，启用模块功能后 `go install` 命令使用的也是模块进行下载安装。

```sh
$ go env -w GO111MODULE=on
```

另外模块功能支持像 git clone 一样下载到指定路径:

```sh
$ go mod init github.com/youruser/yourrepo
```

Output of command `go help gopath`:

> If the `GOBIN` environment variable is set, commands are installed to the directory it names instead of `DIR/bin`. `GOBIN` must be an absolute path.

如果你是按照上面方法安装配置的 go，可以通过下面这条命令来进行删除:

```sh
$ sudo rm -rf /usr/local/bin/go* $HOME/.go/ $HOME/.config/go/ /path/to/go/
```

## References

- Matt Holiday\'s [Go Class](https://www.youtube.com/playlist?list=PLoILbKo9rG3skRCj37Kn5Zj803hhiuRK6)
- Go [Documentation](https://go.dev/doc/)
- Go [Playground](https://go.dev/play/#)
- Go [Packages](https://pkg.go.dev/)
- Go [Environment variables](https://pkg.go.dev/cmd/go#hdr-Environment_variables)
- Stack Overflow: [Where are the golang environment variables stored?](https://stackoverflow.com/questions/40825613/where-are-the-golang-environment-variables-stored)
