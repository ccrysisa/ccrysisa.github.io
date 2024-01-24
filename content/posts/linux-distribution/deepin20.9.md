---
title: 深度操作系统 Deepin 20.9 双系统安装配置
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

记录一下折腾 Deepin 20.9 的物理机的过程与相关的配置。

<!--more-->

## 安装与配置

新手教学影片：

- [深度操作系统deepin下载安装 (附双系统安装及分区指引)](https://www.bilibili.com/video/BV1ZQ4y1C7n3/?vd_source=99b5a7ef7355e5c62fe79d489b7711ca) [bilibili]
- [安装完deepin之后该做的事情](https://www.bilibili.com/video/BV1pE411E7dL/?vd_source=99b5a7ef7355e5c62fe79d489b7711ca) [bilibili]

## 网络代理

新手教学文档:
[Ubuntu 22.04LTS 相关配置]({{< relref "ubuntu22.04lts.md" >}})

> 在境内可以使用 {{< link "gitclone.com" >}} 来加速 clone 的速度。

## 编辑器: VS Code

新手教学文档: 
[编辑器: Visual Studio Code](https://hackmd.io/@sysprog/gnu-linux-dev/https%3A%2F%2Fhackmd.io%2Fs%2FrJPKpohsx) 
[HackMD]

本人的一些注解:
[GNU/Linux 开发工具]({{< relref "../sysprog/gnu-linux-dev.md" >}})

这里列举一下本人配置的插件：

- Even Better TOML
- Git History
- Native Debug
- rust-analyzer
- Tokyo Night
- Vim
- VSCode Great Icons

## 终端和 Vim

新手教学文档: 
[終端機和 Vim 設定](https://hackmd.io/@sysprog/gnu-linux-dev/https%3A%2F%2Fhackmd.io%2Fs%2FHJv9naEwl) 
[HackMD]

本人的一些注解: 
[GNU/Linux 开发工具]({{< relref "../sysprog/gnu-linux-dev.md" >}})

- 本人的终端提示符配置: `\u@\h\W`
- 本人使用 [Minimalist Vim Plugin Manager](https://github.com/junegunn/vim-plug) 来管理插件，vimrc 配置如下:

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
