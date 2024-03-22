---
title: 深度操作系统 Deepin 20.9 安装配置
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
  - Deepin
categories:
  - Operating Systems
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

记录一下折腾 Deepin 20.9 的物理机的过程与相关的配置。

<!--more-->

## 安装与配置

新手教学影片：

- [深度操作系统deepin下载安装 (附双系统安装及分区指引)](https://www.bilibili.com/video/BV1ZQ4y1C7n3/?vd_source=99b5a7ef7355e5c62fe79d489b7711ca) [bilibili]
- [安装完deepin之后该做的事情](https://www.bilibili.com/video/BV1pE411E7dL/?vd_source=99b5a7ef7355e5c62fe79d489b7711ca) [bilibili]

## 网络代理

新手教学文档:
[Ubuntu 22.04LTS 相关配置]({{< relref "ubuntu22.04lts.md" >}})

> 在境内可以使用 [gitclone](http://gitclone.com) 镜像站来加快 clone 的速度。

## 编辑器: VS Code

新手教学文档: 
[编辑器: Visual Studio Code](https://hackmd.io/@sysprog/gnu-linux-dev/https%3A%2F%2Fhackmd.io%2Fs%2FrJPKpohsx) 
[HackMD]

本人的一些注解:
[GNU/Linux 开发工具]({{< relref "../sysprog/gnu-linux-dev.md" >}})

这里列举一下本人配置的插件：

- **Even Better TOML**
- **CodeLLDB** 用于调试 Rust
- **Git History**
- **Native Debug** 用于调试 C/C++
- **rust-analyzer**
- **Tokyo Night** 挺好看的一个主题
- **Vim**
- **VSCode Great Icons** 文件图标主题

## 终端和 Vim

新手教学文档: 
[終端機和 Vim 設定](https://hackmd.io/@sysprog/gnu-linux-dev/https%3A%2F%2Fhackmd.io%2Fs%2FHJv9naEwl) 
[HackMD]

本人的一些注解: 
[GNU/Linux 开发工具]({{< relref "../sysprog/gnu-linux-dev.md" >}})

- 本人的终端提示符配置: `\u@\h\W`
- 本人使用 [Minimalist Vim Plugin Manager](https://github.com/junegunn/vim-plug) 来管理 Vim 插件，配置如下:

```bash {title="~/.vimrc"}
" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)                          
call plug#begin('~/.vim/plugged')

Plug 'Shougo/neocomplcache'
Plug 'scrooloose/nerdtree'
map <F5> :NERDTreeToggle<CR>

call plug#end()

let g:neocomplcache_enable_at_startup = 1 
let g:neocomplcache_enable_smart_case = 1 
inoremap <expr><TAB> pumvisible()?"\<C-n>" : "\<TAB>"

syntax on
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

" autocomplete dropdown list colorscheme
hi Pmenu ctermfg=0 ctermbg=7 
hi PmenuSel ctermfg=7 ctermbg=4
```

## 系统语言: Rust

安装教程:

- [Installation](https://doc.rust-lang.org/book/ch01-01-installation.html) [The book]
- [安装 Rust](https://course.rs/first-try/installation.html) [Rust course]
- [Channels](https://rust-lang.github.io/rustup/concepts/channels.html) [The rustup book]

```bash
# install rust
$ curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
# install nightly toolchain
$ rustup toolchain install nightly
# change to nightly toolchain
$ rustup default nightly
# list installed toolchain
$ rustup toolchain list
# update installed toolchain
$ rustup update
```

个人偏向于使用 nightly toolchain

## 效果展示

{{< image src="/images/tools/deepin-terminal-vim.png" caption="Deepin Terminial Vim" >}}
{{< image src="/images/tools/deepin-dde-desktop.png" caption="Deepin DDE Desktop" >}}

## FAQ

{{< admonition question >}}
重启后可能会出现，输入密码无法进入图形界面重新返回登录界面，这一循环状况。这个是 deepin 的默认 shell 是 dash 造成的，只需将默认的 shell 改为 bash 即可解决问题：

```bash
$ ls -l /bin/sh
lrwxrwxrwx 1 root root 9 xx月  xx xx:xx /bin/sh -> /bin/dash
$ sudo rm /bin/sh
$ sudo ln -s /bin/bash /bin/sh
```

如果你已经处于无限登录界面循环这一状况，可以通过 `Ctrl + Alt + <F2>` 进入 tty2 界面进行修改：

```bash
# 先查看问题日志，判断是不是 shell 导致的问题
$ cat .xsession-errors
# 如果是，则重复上面的操作即可
```

{{< /admonition >}}
