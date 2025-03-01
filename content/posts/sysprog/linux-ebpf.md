---
title: "Linux 核心设计: 透过 eBPF 观察操作系统"
subtitle:
date: 2025-02-18T17:01:30+08:00
slug: b8b13cc
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
  - Sysprog
  - Linux
categories:
  - Linux Kernel Internals
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

## The Beginner's Guide to eBPF

[BCC](https://github.com/iovisor/bcc/tree/master) 要求的内核编译参数 Ubuntu 24.04 全部满足，根据安装说明进行手动编译安装，仓库的 [doc](https://github.com/iovisor/bcc/blob/master/docs) 目录下有相关教程和手册供参阅。

Kernel 中的 verifier 主要是负责检查 eBPF program 的非法行为，例如 dereference null pointer，从而阻止这些不合法行为。

### The Beginners Guide to eBPF Programming in Go

[bpftrace](https://github.com/bpftrace/bpftrace) is a high-level tracing language for Linux. 主要用于让 bpf scripts 快速便捷地执行。

## eBPF 开发实践教程

安装好 ecc 之后，还需要设置环境变量 `EUNOMIA_HOME` 才可以正常工作，以下为源代码中的处理逻辑:

- [src/config/mod.rs](https://github.com/eunomia-bpf/eunomia-bpf/blob/master/compiler/cmd/src/config/mod.rs#L100)

```rs
#[arg(long, default_value_t = format!("{}/btfhub-archive", get_eunomia_data_dir().unwrap().to_string_lossy()), help = "directory to save btfhub archive file")]
```

- [src/helpers](https://github.com/eunomia-bpf/eunomia-bpf/blob/master/compiler/cmd/src/helper.rs#L12)

```rs
pub fn get_eunomia_data_dir() -> Result<PathBuf> {
    if let Ok(e) = var(EUNOMIA_HOME_ENV) {
        return Ok(e.into());
    };
```

建议将环境变量 `EUNOMIA_HOME` 设置为 `$HOME/.eunomia`:

```sh
$ mkdir ~/.eunomia
# in ~/.bashrc
$ export EUNOMIA_HOME=~/.eunomia
```

{{< admonition tip >}}
个人配置是将 `ecc` 和 `ecli` 放置在某一目录，并通过脚本来加载相关环境变量:

```sh
$ tree Packages/eunomia/
Packages/eunomia/
├── build/
│   ├── ecc
│   └── ecli
├── data/
└── env

2 directories, 3 files
```

env 内容如下:

```sh
#!/bin/sh
export PATH=$PATH:$HOME/Packages/eunomia/build
export EUNOMIA_HOME=$HOME/Packages/eunomia/data
```

最后在 `~/.bashrc` 末尾处加入执行上面 `env` 脚本的逻辑:

```sh
. "$HOME/Packages/eunomia/env"
```
{{< /admonition >}}

## References

- Linux 核心設計: [透過 eBPF 觀察作業系統行為](https://hackmd.io/@sysprog/linux-ebpf?type=view)
- Liz Rice: [ebpf-beginners](https://github.com/lizrice/ebpf-beginners)
- Eunomia eBPF: [eBPF 开发实践教程：基于 CO-RE，通过小工具快速上手 eBPF 开发](https://eunomia.dev/zh/tutorials/)
