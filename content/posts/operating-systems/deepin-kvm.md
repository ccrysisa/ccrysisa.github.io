---
title: "Deepin 20.9 KVM 安装和管理"
subtitle:
date: 2024-03-28T12:21:48+08:00
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
  - KVM
  - QEMU
  - openEuler
categories:
  - Operating Systems
  - OERV
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

本篇主要介绍在 deepin20.9 操作系统平台下，使用 KVM 虚拟化技术来创建和安装 Linux 发行版，并以创建安装 openEuler 22.03 LTS SP3 的 KVM 虚拟机作为示范，让学员领略 KVM 虚拟化技术的强大魅力。

<!--more-->

## 什么是虚拟化?

什么是虚拟化技术？KVM 虚拟化和 Virtual Box、VMware 这类虚拟机软件的区别是什么？请阅读下面的这篇文章。

- [KVM 与 VMware 的区别盘点](https://www.redhat.com/zh/topics/virtualization/kvm-vs-vmware-comparison)

## 配置虚拟化环境

首先需要检查 CPU 是否支持虚拟化 (以 Intel 处理器为例):

```bash
# intel vmx，amd svm
$ egrep '(vmx|svm)' /proc/cpuinfo
...vmx...

$ lscpu | grep Virtualization
Virtualization:        VT-x
```

检查 KVM 模块是否已加载:

```bash
$ lsmod | grep -i kvm
kvm_intel             278528  11
kvm                   901120  1 kvm_intel
```

确保 CPU 支持虚拟化并且 KVM 模块已被加载，接下来是安装 QEMU 和 virt-manager (虚拟系统管理器)。直接通过 apt 安装的 QEMU 版本过低，而通过 GitHub 下载最新的 QEMU 源码编译安装需要Python3.9，而 deepin 20.9 的 Python 3 版本是 3.7 (保险起见不要随便升级)，所以折中一下，编译安装   QEMU 7.2.0 :rofl:

安装 QEMU:

```bash
$ wget https://download.qemu.org/qemu-7.2.0.tar.xz
$ tar xvJf qemu-7.2.0.tar.xz
$ mv qemu-7.2.0 qemu
$./configure
$ sudo make -j$(nproc)
# in ~/.bashrc
export PATH=$PATH:/path/to/qemu/build
```

安装 virt-manager:

```bash
$ sudo apt install virt-manager
```

## 安装 openEuler KVM 虚拟机

可以在启动器看到一个虚拟机管理应用图标，如下:

{{< image src="https://wiki.deepin.org/for_trans/kvm/1.png" >}}

点击打开 (需要输入密码认证，以下图片中的 "本地" 可能会显示为 "QEMU/KVM"):

{{< image src="https://wiki.deepin.org/for_trans/kvm/2.png" >}}

接下来创建虚拟机:

{{< image src="https://wiki.deepin.org/for_trans/kvm/3.png" >}}

下图的操作系统选择对应的类型 (可以在 [这里](https://www.openeuler.org/en/download/archive/) 下载 openEuler 22.03 LTS SP3 镜像，对于 openEuler 这类未被收录的类型，选择 Generic):

{{< image src="https://wiki.deepin.org/for_trans/kvm/4.png" >}}

> 这里选择 iso 镜像后可能会显示路径搜索问题，选择 "是" 将该路径加入存储池即可

接下来是处理器和内存配置，建议配置 8 核 8G 内存，根据自己物理机配置选择即可:

{{< image src="https://wiki.deepin.org/for_trans/kvm/5.png" >}}

接下来是虚拟磁盘的大小设置和存放位置，建议选择自定义存储路径，并搭配 [更改 KVM 虚拟机默认存储路径](https://www.cnblogs.com/hahaha111122222/p/15538763.html)，特别是如果你的根目录空间不太够的情况：

{{< image src="https://wiki.deepin.org/for_trans/kvm/6.png" >}}

在对应的存储卷中创建虚拟磁盘 (**注意: 如果你更改了默认存储路径，请选择对应的存储池而不是 default**):

{{< image  src="https://wiki.deepin.org/for_trans/kvm/7.png" >}}

创建虚拟磁盘 (名称可以自定义，分配默认初始为 0，它会随着虚拟机使用而增大，当然也可以直接将分配等于最大容量，这样就会直接分配相应的磁盘空间，玩过虚拟机的学员应该很熟悉):

{{< image  src="https://wiki.deepin.org/for_trans/kvm/8.png" >}}
{{< image  src="https://wiki.deepin.org/for_trans/kvm/9.png" >}}

接下来自定义虚拟机名称并生成虚拟机即可:

{{< image  src="https://wiki.deepin.org/for_trans/kvm/11.png" >}}

最后就是熟悉的安装界面:

{{< image src="https://vanjker.github.io/HITsz-OS-labs-2022/site/openeuler.assets/clip_image023.png" >}}

参考 [这里](https://vanjker.github.io/HITsz-OS-labs-2022/site/env/#22) 安装 openEuler 即可。

## 透过 SSH 连接 KVM 虚拟机

首先先检查 Guest OS 上 ssh 服务是否开启 (一般是开启的):

```bash
$ sudo systemctl status sshd
sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2024-03-28 14:40:15 CST; 20min ago
...
```

然后在 Guest OS 上获取其 IP 地址 (ens3 的 inet 后的数字即是，openEuler 启动时也会输出一下 IP 地址):

```bash
$ ip addr
```

在 Host OS 上通过 ssh 连接登录 GuestOS:

```bash
$ ssh user@ip
# user: user name in the guest os
# ip ip addr of guest os
```

## Development Tools

由于是最小安装，很多趁手的工具都没有，俗话说“工欲善其事，必先利其器”，所以先安装必要的开发工具。幸好 openEuler 提供了整合包 Development Tools，直接安装即可:

```bash
$ sudo yum group install -y "Development Tools"
```

## Neofetch

安装 neofetch 来酷炫地输出一下系统信息:

```bash
$ git clone https://github.com/dylanaraps/neofetch
$ cd neofetch
$ make install
$ neofetch
```

{{< image src="/images/oerv/openEuler-22.03-LTS-SP3-neofetch.png" >}}

## References

- [使用 KVM 安装和管理 deepin](https://wiki.deepin.org/zh/04_%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98FAQ/%E8%99%9A%E6%8B%9F%E6%9C%BA/%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8kvm%E5%AE%89%E8%A3%85%E5%92%8C%E7%AE%A1%E7%90%86deepin)
- [Linux 下使用 KVM 虚拟机安装 OpenEuler 系统](https://blog.51cto.com/zounan/4931973)
- [KVM 更改虚拟机默认存储路径](https://www.cnblogs.com/hahaha111122222/p/15538763.html)
- [实践 KVM on Deepin](https://wang-ray.github.io/os/2019/11/07/%E5%AE%9E%E8%B7%B5KVM-on-Deepin/)
