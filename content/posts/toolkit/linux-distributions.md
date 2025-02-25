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
  - openSUSE
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

- [新手教程: Ubuntu 24.04 LTS 和 Windows 10/11 双系统安装指南](https://www.bilibili.com/video/BV1Xkm2Y2EJE/?vd_source=99b5a7ef7355e5c62fe79d489b7711ca)
- [深度操作系统 deepin 下载安装 (附双系统安装及分区指引)](https://www.bilibili.com/video/BV1ZQ4y1C7n3/?vd_source=99b5a7ef7355e5c62fe79d489b7711ca)

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
# install tldr/tlrc by cargo
$ cargo install tlrc
...
Installed package `tlrc v1.9.3` (executable `tldr`)
```

### Git & GitHub

Git:

```sh
$ git config --list
user.name=<username>
user.email=<email>
core.editor=vim
merge.tool=vimdiff
color.ui=true
alias.st=status
alias.ck=checkout
alias.rst=reset HEAD
init.defaultbranch=main
pull.rebase=false
```

GitHub ssh key:

```sh
$ ssh-keygen -t rsa -C "your_email@example.com"
...
# enter 3 times to generate ssh key
$ eval ssh-agent -s
$ ssh-add ~/.ssh/id_rsa
$ cat ~/.ssh/id_rsa.pub
...
# paste output (public key) to your github ssh key setting
$ ssh -T git@github.com
...
Hi [username]! You've successfully authenticated, but GitHub does not provide shell access.
```

### Vim & VS Code

```sh {title="~/.vimrc"}
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
- **Git History**
- **clangd**: C/C++ 语法服务 (LSP)
- **rust-analyzer**: Rust 语法服务 (LSP)
- **Go**: Go 语法服务 (LSP)
- **Even Better TOML**: toml 语法高亮
- **Native Debug**: 调试 C/C++
- **CodeLLDB**: 调试 C++/Rust
- **Dependi**: 管理包依赖关系
- **Error Lens**: 更强大的错误提示

{{< admonition question >}}
rust-analyzer 插件可能会因为新版本要求 glibc 2.29 而导致启动失败，请参考这个 [issue](https://github.com/rust-lang/rust-analyzer/issues/11558) 来解决。

clangd 建议先手动通过包管理器安装（一般情况下路径为 `/usr/bin/clangd`，可以通过 `which` 命令查询具体路径），然后再设置 VS Code 里 clangd 插件对应的 clangd 可执行文件路径。
{{< /admonition >}}

## deepin

### 系统库

deepin 预装的系统库比较陈旧（沿袭自“侏罗纪”时代的 Debian），特别是 `libstdc++`，如果你想使用 LLVM 的产品，预装的版本根本不满足，需要手动安装较新版本的包（`libstd++-12-dev` 及以上的版本）:

```bash
$ sudo apt install libstdc++-13-dev
```

{{< admonition >}}
2024/12/25 更新：可以直接安装 `build-essential` 包，里面有包含最新版本的 `libstdc++` 等系统库和 `gcc` 等常用工具。
{{< /admonition >}}

另外为了获得更好的 LLVM/Clang 产品体验，建议手动安装全家桶（同时将 VS Code 的 clangd 扩展的可执行文件的路径改为相应的安装路径，一般为 `/usr/bin/clangd`，可以通过 `which` 命令查询）:

```bash
$ sudo apt install llvm clang clangd
```

### 根用户

deepin 没法直接使用 `su` 命令，而是需要使用 `sudo su` 命令来进入 root 用户。

## Ubuntu

安装 tweaks 以获得对 GNOME 桌面的更多设置（例如字体设置）:

```bash
$ sudo apt install gnome-tweaks
```

> 如果是笔记本的小尺寸屏幕，在 tweaks 里面字体 (font) 设置处将 font size 缩放至 1.25 即可；或者在显示 (Display) 设置中开启分数缩放，调成至 125% 即可。

参考下面链接安装 fcitx5 输入法框架:

- [Ubuntu 22.04 Chinese (simplified) pinyin input support](https://askubuntu.com/questions/1408873/ubuntu-22-04-chinese-simplified-pinyin-input-support)

安装完成后在 fcitx5 里面搜索安装 Pinyin 即可，然后还得在设置里边安装一下简体中文语言包，要不然没有 CJK 支持汉字渲染很怪异。

Ubuntu 预装的终端主题个人认为 GET 不到美感，可以在 [Goph](https://github.com/Gogh-Co/Gogh) 挑一款自己喜欢的主题，笔者用的是 Tokyo Night 这款主题。

### fish

个人在 Ubuntu 处采用 [fish](https://github.com/fish-shell/fish-shell) 作为 shell，可以直接通过 apt 进行安装。因为 fish 和 bash 语法不兼容，最合适的方法是在 `/etc/bash.bashrc` 文件末尾处加上下面这行代码:

```sh
exec fish
```

fish 可以通过 `fish_config` 命令来设置主题等样式，非常方便。

### tmux

个人的终端方案是 [tmux](https://github.com/tmux/tmux)，也是可以通过 apt 进行安装，参考 [这个链接](https://stackoverflow.com/questions/21115370/how-to-launch-tmux-automatically-when-konsole-yakuake-start/) 来让终端默认启动 tmux。

bilibili: [终端神器 tmux：多任务管理大师](https://www.bilibili.com/video/BV1ML411h7tF)

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

{{< admonition tip >}}

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
sudo rm /etc/profile.d/clash.sh
echo -e "\033[31m[×] 已关闭代理\033[0m"
```

因为涉及到要继承使用 `export` 命令设置的临时环境变量 (`http_proxy` 和 `https_proxy`)，所以使用如下格式执行上述脚本:

```sh
$ . ./[run.sh|exit.sh]
```

> The first `.` stands for current shell and the second `.` for current directory.

- Stack Overflow: [How to execute bash script in same shell](https://stackoverflow.com/questions/44122714/how-to-execute-bash-script-in-same-shell)

{{< /admonition >}}

然后可以进一步地在 `~/.bashrc`、`~/.bash_aliases` 文件中设置快速启动/关闭的命令别名。 

如果你没有关闭 clash 服务就关机，那么重启后可能会出现，输入密码无法进入图形界面重新返回登录界面，这一循环状况。这个是有些 Linux 发行版默认的 shell 是 dash，但位于 `/etc/` 路径下的 clash 服务脚本需要使用 bash 才能运行造成的，有几种方式可以解决该问题。

> 目前只在 deepin 上发现该问题，至于 Ubuntu 并没有影响

第一种方法，也是最简单的方法，每次关机前都关闭掉 clash 服务即可:

```bash
$ sudo bash shutdown.sh
# or
$ . ./exit.sh
```

第二种方法，只需将默认的 shell 改为 bash 即可解决问题：

```bash
$ ls -l /usr/bin/sh
lrwxrwxrwx 1 root root 9 xx月  xx xx:xx /usr/bin/sh -> dash
$ sudo rm /usr/bin/sh
$ sudo ln -s /usr/bin/bash /usr/bin/sh
```

如果你已经处于无限登录界面循环这一状况，可以通过 `Ctrl + Alt + <F3>/<F2>` 切换进入 TTY/GUI 界面进行修改。

{{< admonition type=todo open=false >}}

进阶可以尝试基于 [v2ray](https://www.v2ray.com/) 的 [v2raya](https://github.com/v2rayA/v2rayA)，安装完后所有软件处会出现启动管理面板的图标，常用的指令如下:

systemd 服务:

```sh
# 首次启动 v2rayA 的命令，它同时设置了相应的启动服务
$ sudo systemctl start v2raya.service
# 设置开机自动启动
$ sudo systemctl enable v2raya.service
# 设置开机不自动启动
$ sudo systemctl disable v2raya.service
```

启动、停止、查询服务:

```sh
# 启动 v2rayA 服务
$ sudo service v2raya start
# 停止 v2rayA 服务
$ sudo service v2raya stop
# 查看 v2rayA 状态
$ sudo service v2raya status
```

v2raya 若采用全局透明代理方案，则无需设置系统代理和某些软件的代理。

{{< /admonition >}}

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

可以尝试使用 **[Sarasa Gothic (更纱黑体 / 更紗黑體)](https://github.com/be5invis/Sarasa-Gothic)**、**[Fira Code](https://github.com/tonsky/FiraCode)** 或微软家的 **[Cascadia Code](https://github.com/microsoft/cascadia-code)**。

个人 VS Code 字体设置:

- Windows: Cascadia Code
- deepin/Ubuntu: Fira Code

### 声音增强

Linux 发行版大多都没有安装声音增强工具，使得通过电脑本身的音量设备输出的声音是原生的，音量会比较小，相对于预装音量增强工具的 Windows 而言，可以参考 [这篇文章](https://linuxhint.com/pulseeffects-equalizer-audio-enhancer/) 来开启音量增强。需要注意有线耳机和蓝牙无线耳机则不受影响，因为这些设备的输出取决于这些设备，而不是电脑自身。

### 软件包

除了系统自带的包管理之外，Debian/Ubuntu 可以尝试 Flatpak 包管理器。

如果是自己手动编译安装软件包的二进制，则主要有三种将编译后的二进制文件引入 `PATH` 的方法:

1. 在 `~/.bashrc` / `/etc/bash.bashrc` 或使用的 shell 对应的配置文件中加入形如 `export PATH=$PATH:/path/to/package` 的语法，可以将 `package` 下的所有可执行文件都加入到 `PATH` 中。笔者对于 qemu 采用该设定进行引入。
2. 直接将编译完成的二进制可执行文件丢进 `/usr/bin` 或 `/usr/local/bin` 之中，这个方法十分简单易用，但如果 `/` 和 `/home` 分开挂载，可能会导致 `/` 空间被占用过多。
3. 将编译完成的二进制可执行文件通过符号链接 (symbol link) 至 `/usr/bin` 或 `/usr/local/bin`，这个就相当于将第二种方法实际占用空间的分区由 `/` 移动至用户指定的地方。
