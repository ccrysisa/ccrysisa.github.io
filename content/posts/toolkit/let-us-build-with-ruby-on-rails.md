---
title: "Let's Build: With Ruby On Rails"
subtitle:
date: 2024-07-01T19:43:52+08:00
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
  - Web
  - Ruby
  - Rails
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

> Learn Ruby on Rails with me as I build several apps that slowly introduce more features and functionality along the way. 

<!--more-->

- {{< link href="https://www.youtube.com/playlist?list=PL01nNIgQ4uxNkDZNMON-TrzDVNIk3cOz4" content="录影列表" external-icon=true >}}

## Installation

```bash
$ neofetch --stdout
cai@cai-PC 
---------- 
OS: Deepin 20.9 x86_64 
Host: RedmiBook 14 II 
Kernel: 5.15.77-amd64-desktop 
Uptime: 1 hour, 15 mins 
Packages: 2169 (dpkg) 
Shell: bash 5.0.3 
Resolution: 1920x1080 
DE: Deepin 
WM: KWin 
Theme: deepin-dark [GTK2/3] 
Icons: bloom-classic-dark [GTK2/3] 
Terminal: deepin-terminal 
CPU: Intel i7-1065G7 (8) @ 3.900GHz 
GPU: NVIDIA GeForce MX350 
GPU: Intel Iris Plus Graphics G7 
Memory: 3309MiB / 15800MiB 
```

Install Git:

```bash
$ sudo apt update
$ sudo apt install git
$ git --version
git version 2.20.1
```

Install rbenv:

```bash
$ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
$ ~/.rbenv/bin/rbenv init
$ rbenv --version 
rbenv 1.2.0-91-gc3ba994
```

Install Ruby:

```bash
$ git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
$ rbenv install 3.2.4
$ rbenv global 3.2.4
$ ruby --version
ruby 3.2.4 (2024-04-23 revision af471c0e01) [x86_64-linux]
```

Install Rails:

```bash
$ gem install rails
$ rails --version
Rails 7.1.3.4
```

{{< admonition >}}
类比来说，`rbenv` 类似与 `rustup`，是工具链的配置工具，而 `gem` 则类似于 `cargo`，是包管理工具。当然这类比不完全准确，比如 `rustup` 和 `cargo` 这两种工具是平行的关系，而 `rbenv` 和 `gem` 的关系更接近上下级 (可以通过 `which` 命令来查看它们的存储位置来判断)，通过 `rbenv` 可以安装相应版本的 `ruby`, `gem` 等等一系列软件包 (例如上面的命令 `rbenv install 3.2.4`)。
{{< /admonition >}}

### References

- https://github.com/rbenv/rbenv
- https://guides.rubyonrails.org/v5.0/getting_started.html
- https://rubygems.org/

## Blog With Comments
