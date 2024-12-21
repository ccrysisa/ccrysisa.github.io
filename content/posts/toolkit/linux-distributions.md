---
title: "Linux 发行版使用体验"
subtitle:
date: 2024-01-24T18:59:56+08:00
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
  - Linux
  - deepin
  - Ubuntu
categories:
  - Toolkit
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

记录我所使用过的 Linux 发行版的心得体会: deepin 20.9/V23, Ubuntu 22.04/24.04, openSUSE Tumbleweed。

<!--more-->

## 系统通用配置

### 安装与配置

新手教学影片：

bilibili: [深度操作系统 deepin 下载安装 (附双系统安装及分区指引)](https://www.bilibili.com/video/BV1ZQ4y1C7n3/?vd_source=99b5a7ef7355e5c62fe79d489b7711ca)

### man & tldr

deepin 默认没有预装完整的 man 手册，需要手动安装:

```bash
$ sudo apt install manpages manpages-dev
```

但是有些程序的 `man` 手册页是无法被安装的，例如 gcc，这是因为 deepin 软件仓里没有相应的包，可以考虑使用 tldr 来进行部分替代。

[tldr pages](https://tldr.sh/):

> The tldr-pages project is a collection of community-maintained help pages for command-line tools, that aims to be a simpler, more approachable complement to traditional man pages.

安装 [tldr](https://github.com/tldr-pages/tldr) / [tlrc](https://github.com/tldr-pages/tlrc):

```bash
$ cargo install tlrc
...
Installed package `tlrc v1.9.3` (executable `tldr`)
```

### Git & GitHub

git:

```bash
$ git config user.name <username>
$ git config user.email <useremail>
# optional
$ git config core,editor vim
$ git config merge.tool vimdiff
$ git config color.ui true
$ git config alias.st status
$ git config alias.ck checkout
$ git config alias.rst "reset HEAD"
$ git config init.defaultbranch main
$ git config pull.rebase=false
```

github ssh key:

```bash
$ ssh-keygen -t rsa -C "your_email@example.com"
...
# enter 3 times to generate ssh key
$ eval `ssh-agent -s`
$ ssh-add ~/.ssh/id_rsa
$ cat ~/.ssh/id_rsa.pub
...
# paste output (public key) to your github ssh key setting
$ ssh -T git@github.com
...
Hi [username]! You've successfully authenticated, but GitHub does not provide shell access.
```

### Vim & VS Code

```bash {title="~/.vimrc"}
syntax on
set relativenumber
set number
set cursorline
colorscheme default
set bg=dark
set tabstop=4
set expandtab
set shiftwidth=4
set ai
set hlsearch
set smartindent
map <F4> : set nu!<BAR>set nonu?<CR>
```

也可以参考 George Hotz 的 [极简 Vim 设定](https://github.com/geohot/configuration/blob/master/.vimrc)

这里列举一下本人 VS Code 配置的插件：

- **Vim**
- **VSCode Great Icons**
- **Tokyo Night**
- **Git History**
- **Even Better TOML**: toml 语法高亮
- **clangd**: C/C++ 语法服务
- **Native Debug**: 调试 C/C++
- **rust-analyzer**: Rust 语法服务
- **CodeLLDB**: 调试 C++/Rust
- **Dependi**: 管理包依赖关系
- **Error Lens**: 更强大的错误提示

{{< admonition question >}}
rust-analyzer 插件可能会因为新版本要求 glibc 2.29 而导致启动失败，请参考这个 [issue](https://github.com/rust-lang/rust-analyzer/issues/11558) 来解决。
{{< /admonition >}}

## deepin

### 系统库

deepin 预装的系统库比较陈旧（沿袭自“侏罗纪”时代的 Debian），特别是 `libstdc++`，如果你想使用 LLVM 的产品，预装的版本根本不满足，需要手动安装较新版本的包（`libstd++-12-dev` 及以上的版本）:

```bash
$ sudo apt install libstdc++-13-dev
```

另外为了获得更好的 LLVM/Clang 产品体验，建议手动安装全家桶（同时将 VS Code 的 clangd 扩展的可执行文件的路径改为相应的安装路径，一般为 `/usr/bin/clangd`，可以通过 `which` 命令查询）:

```bash
$ sudo apt install llvm clang clangd
```

### 根用户

deepin 没法直接使用 `su` 命令，而是需要使用 `sudo su` 命令来进入 root 用户。

## 效果展示

deepin 20.9/V23 的用户指导做的很好，每个内置应用程序都有相应的帮助手册。

{{< image src="/images/tools/deepin-terminal-vim.png" caption="deepin Terminial Vim" >}}

{{< image src="/images/tools/deepin-dde-desktop.png" caption="deepin DDE Desktop" >}}

## FAQ

### 网络代理

使用项目 [clash-for-linux-backup](https://github.com/Elegybackup/clash-for-linux-backup) 来配置 Linux 发行版的网络代理。

```bash
$ git clone https://github.com/Elegybackup/clash-for-linux-backup.git clash-for-linux
```

> 在境内可以使用 [gitclone](http://gitclone.com) 镜像站来加快 clone 的速度。过程当中可能需要安装 curl 和 net-tools，根据提示进行安装对应的包即可。

安装并启动完成后，可以通过 `localhost:9090/ui` 来访问 Dashboard。

重启后可能会出现，输入密码无法进入图形界面重新返回登录界面，这一循环状况。这个是 Linux 发行版默认的 shell 是 dash，但位于 `/etc/` 路径下的 clash 服务脚本需要使用 bash 才能运行造成的，只需将默认的 shell 改为 bash 即可解决问题：

```bash
$ ls -l /bin/sh
lrwxrwxrwx 1 root root 9 xx月  xx xx:xx /bin/sh -> /bin/dash
$ sudo rm /bin/sh
$ sudo ln -s /bin/bash /bin/sh
```

如果你已经处于无限登录界面循环这一状况，可以通过 `Ctrl + Alt + <F2>` 进入 tty2 界面进行修改。

一些相关的便利脚本:

快速启用代理脚本:

```bash {title=run.sh}
#!/bin/bash
sudo bash start.sh
source /etc/profile.d/clash.sh
proxy_on
```

快速关闭代理脚本:

```bash {title=exit.sh}
#!/bin/bash
sudo bash shutdown.sh
unset http_proxy
unset https_proxy
unset no_proxy
unset HTTP_PROXY
unset HTTPS_PROXY
unset NO_PROXY
echo -e "\033[31m[×] 已关闭代理\033[0m"
```

### 时间同步

如果是 Windows/Linux 双系统会出现时间不同步的问题（北京时区的话会相差 8 小时），可以将 Linux 发行版的时间策略调整为与 Windows 的策略一致，即统一读取 BIOS 的 RTC 时间作为系统时间。

```bash
# check RTC status
$ timedatectl status
...
RTC in local TZ: no
# modify RTC status
$ timedatectl set-local-rtc 1
# RTC status has changed
$ timedatectl status
...
RTC in local TZ: yes
```

### 编程字体

可以尝试使用 **[Sarasa Gothic (更纱黑体 / 更紗黑體)](https://github.com/be5invis/Sarasa-Gothic)** 或微软家的 **[Cascadia Code](https://github.com/microsoft/cascadia-code)**。

个人 VS Code 字体设置:

- Windows: Cascadia Code
- deepin: Noto Sans Mono
- Ubuntu: 待补充
