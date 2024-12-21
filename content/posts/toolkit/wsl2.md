---
title: "Windows 10/11 WSL2 配置指南"
subtitle:
date: 2024-04-20T12:14:18+08:00
slug: f244d6d
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
  - Windows
  - WSL
  - Ubuntu
  - Arch Linux
  - Linux Mint
categories:
  - Toolkit
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRss: false
hiddenFromRelated: false
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

今日闲来无事，刷了会 B 站，突发奇想将发灰了一年多的 WSL2 找回来折腾一下 (之前为了在 VMware 中开启嵌套虚拟化，不得以将 WSL2 打入冷宫 :rofl:)。由于这一年内功功力大涨，很快就完成了 WLS2 的再召集启用，下面列出配置的主要步骤和相关材料。

2024/12/15 更新: 昨日由于被 Windows 10 的安全启动和 BitLocker 联手防范“自己人”导致全盘被锁，不得已只能全盘格式化重装系统，由于在 Windows 上一般情况下是使用 WSL 来进行开发，故选择对 Windows Terminal 和 WSL 支持较好的 Windows 11 进行重装。由于个人对滚动更新的 Arch Linux 比较感兴趣，所以重装后在 WSL 中装了 Arch 而不是传统的 Ubuntu。

<!--more-->

## 安装 WSL2 和 Linux 发行版

操作系统: Windows 10/11

{{< bilibili BV1mX4y177dJ >}}

1. 启用或关闭 Windows 功能并重启系统
  - [x] Hyper-V
  - [x] 适用于 Linux 的 Windows 子系统
  - [x] 虚拟机平台

2. 以管理员身份运行 PowerShell

```powershell
> bcdedit /v
...
hypervisorlaunchtype    Auto
# 保证上面这个虚拟化选项是 Auto，如果是 Off 则使用下面命令设置
> bcdedit /set hypervisorlaunchtype auto
```

3. 以管理员身份打开 PowerShell 安装 WSL2

```powershell
> wsl --update
> wsl --set-default-version 2
> wsl -l -o
NAME                                   FRIENDLY NAME
...
Ubuntu-18.04                           Ubuntu 18.04 LTS
Ubuntu-20.04                           Ubuntu 20.04 LTS
Ubuntu-22.04                           Ubuntu 22.04 LTS
...
> wsl --install Ubuntu-22.04
# 后面需要创建用户和密码，自行设置
```

> 上面以 Ubuntu 22.04 发行版为例，你也可以安装其它的发行版。安装过程中可能会出现无法访问软件源的问题，这个是网络问题，请自行通过魔法/科学方法解决。

## 迁移至非系统盘

{{< bilibili BV1EF4m1V7pp >}}

如果是通过 wsl 的 install 来安装，那么会默认安装到 C 盘，如果想迁移到其他盘例如 D 盘，先以管理员身份运行 PowerShell:

```powershell
# 查看已安装的 Linux 发行版
> wsl -l- v
# 停止正在运行的发行版
> wsl --shutdown
# 导出发行版的镜像 (以 Ubuntu 22.04 为例)
> wsl --export Ubuntu-22.04 D:/ubuntu.tar
# 导出镜像后，卸载原有发行版以释放 C 盘空间
> wsl --unregister Ubuntu-22.04
# 重新导入发行版镜像。并指定该子系统储存的目录 (即进行迁移)
> wsl --import Ubuntu-22.04 D:\Ubuntu\ D:\ubuntu.tar --version 2
# 上面命令完成后，在目录 D:\Ubuntu 下会出现名为 ext4.vhdx 的文件，这个就是子系统的虚拟磁盘
# 设置启用子系统时的默认用户 (建议使用迁移前创建的用户)，否则启动子系统时进入的是 root 用户
> ubuntu-22.04.exe config --default-user <username>
```

## Windows Terminal 美化

{{< bilibili BV1GM4m1X7s3 >}}

主要是给 Quake 模式和专注模式设置一下快捷键。

## 图形化支持

目前 Windows 10 上的 WSL2 应该都支持 WSLg (如果你一直更新的话)，可以使用 gedit 来测试一下 WLSg 的功能，可以参考微软的官方文档:

- {{< link href="https://github.com/microsoft/wslg" content="https://github.com/microsoft/wslg" external-icon=true >}}

Windows 11 的 WSL 则默认支持 WSLg 图形化。

## ArchWSL

仓库地址: https://github.com/yuk7/ArchWSL

根据相关的指引文档操作即可，这个比起通过 wsl 直接安装的方式，可以自定义存储位置而不需要手动进行数据迁移。

设置完成后得安装一些必备软件包:

```sh
$ sudo pacman -S coreutils binutils man-db man-pages gcc git
```

clang 太大了个人不推荐在 WSL 上使用，如果要使用 clang-format 推荐下载单独的 [AUR 包](https://aur.archlinux.org/packages/clang-format-static-bin) (pacman 源中没有单独的 clamg-format 包，而是被包含在 clang 这个超打包里面)。

Install:

```sh
$ git clone https://aur.archlinux.org/clang-format-static-bin.git
$ cd clang-format-static-bin/
$ makepkg -si 
...
# install path is /opt/archlinux-clang-format/, you can get more infomation 
# by type `archlinux-clang-format --help`
$ sudo ln -s /opt/archlinux-clang-format/clang-format /usr/sbin/
```

Remove:

```sh
$ sudo rm -rf /usr/sbin/clang-format
$ sudo rm -rf /opt/
```

关于 pacman 的用法可以参考 B 站 TheCW 的讲解视频:

{{< bilibili BV1o4411N7oH >}}

```sh
# -S: you can combine subflags like `y` and `u` used in one command
$ sudo pacman -S <package(s)>   # install package(s)
$ sudo pacman -Sy               # update sources
$ sudo pacman -Syy              # update sources compulsorily
$ sudo pacman -Su               # update local packages
$ sudo pacman -Ss <package(s)>  # search package(s)
$ sudo pacman -Sc               # clean packages cache

# -R
$ sudo pacman -R <package(s)>   # remove package only
$ sudo pacman -Rs <package(s)>  # remove package and its dependencies
$ sudo pacman -Rns <package(s)> # remove package and its dependencies, global configurations

# -Q
$ sudo pacman -Q                # list local installed packages
$ sudo pacman -Qe               # list local installed packages by user
$ sudo pacman -Qe [package]     # list installed packages with version
```

我个人比较推荐在 Arch Linux 下使用 fish，因为它速度快且功能多，非常强大！因为 fish 和 /dash/bash/zsh 这些传统的 shell 的语法不兼容，建议按照 Arch Wiki 的 [fish 文档](https://wiki.archlinux.org/title/Fish) 来安装和启用 fish:

```sh
$ sudo pacman -S fish
# edit your shell configure file, e.g. in /etc/bash.bashrc, add the line:
exec fish
```

## LinuxmintWSL2

仓库地址: https://github.com/sileshn/LinuxmintWSL2 

操作与 ArchWSL 大同小异，其实这种自定义发行版的 WSL 都差不多

## 效果展示

{{< image src="/images/tools/ubuntu-22.04-wsl2.png" caption="Ubuntu 22.04" >}}

{{< image src="/images/tools/ArchWSL.png" caption="Arch Linux" >}}

