---
title: Deepin 20.9 构建 DragonOS
subtitle:
date: 2024-01-22T21:36:18+08:00
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
  - Deepin
  - Linux
  - DragonOS
categories:
  - Linux Distribution
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


在 deepin 20.9 上根据 [DragonOS 构建文档](https://docs.dragonos.org/zh-cn/latest/introduction/build_system.html) 的 bootstrap.sh 的方式来构建 DragonOS 时，如果没有事先安装 Qemu 会出现 KVM 相关的依赖问题。本文记录解决这一问题的过程。

<!--more-->

如果事先没有安装 Qemu，在使用 bootstrap.sh 时会出现如下报错：

```bash
$ bash bootstrap.sh
...
下列软件包有未满足的依赖关系：
qemu-kvm : 依赖: qemu-system-x86
E: 无法修正错误，因为您要求某些软件包保持现状，就是它们破坏了软件包间的依赖关系。
```

查询 deepin 论坛上的相关内容：[qemu-kvm无法安装](https://bbs.deepin.org/zh/post/253482)，可以得知是因为 qemu-kvm 在 debian 发行版上只是一个虚包，所以对于 x86 架构的机器可以直接安装 qemu-systerm-x86

{{< image src="/images/tools/debian-qemu-kvm.png" caption="Debian qemu-kvm" >}}

- https://packages.debian.org/search?keywords=qemu-kvm

安装 qemu-systerm-x86:

```bash
$ sudo apt install qemu-systerm-x86
$
$ qemu-system-x86_64 --version
QEMU emulator version 5.2.0 (Debian 1:5.2+dfsg-11+deb11u1)
Copyright (c) 2003-2020 Fabrice Bellard and the QEMU Project developers
```

安装的 qemu 版本看起来有点低，但是先使用 bootstrap.sh 快速安装其它依赖项，然后尝试编译运行一下 DragonOS:

```bash
$ bash bootstrap.sh
...
|-----------Congratulations!---------------|
|                                          |
|   你成功安装了DragonOS所需的依赖项!          |
|                                          |
|   请关闭当前终端, 并重新打开一个终端          |
|   然后通过以下命令运行:                     |
|                                          |
|                make run                  |
|                                          |
|------------------------------------------|
```

新开一个终端或刷新一下 ~/.bashrc:

```bash
$ cd DragonOS
$ make run
```

{{< image src="/images/tools/deepin-dragonos-run.png" caption="运行 DragonOS" >}}

Ok 可以成功运行
