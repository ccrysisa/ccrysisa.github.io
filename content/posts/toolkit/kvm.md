---
title: "Linux 安装和使用 QEMU/KVM"
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
  - KVM
  - QEMU
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

本文介绍如何在 Linux 上安装 QEMU/KVM 和 Virt Manager。

<!--more-->

## 什么是虚拟化?

什么是虚拟化技术？KVM 虚拟化和 Virtual Box、VMware 这类虚拟机软件的区别是什么？可以参考文章 [KVM 与 VMware 的区别盘点](https://www.redhat.com/zh/topics/virtualization/kvm-vs-vmware-comparison)。

## 配置虚拟化环境

### 检查硬件和系统的兼容性

1. 首先需要检查 CPU 是否支持虚拟化，回传值不应为 0:

```sh
$ sudo grep -E -c '(vmx|svm)' /proc/cpuinfo
```

2. 使用 CPU-checker 检查 KVM 是否可用:

```sh
$ sudo apt install cpu-checker && kvm-ok
INFO: /dev/kvm exists
KVM acceleration can be used
```

软件仓若没有 cpu-checker 软件包，可以去镜像站下载，例如 [上海交通大学镜像站](https://ftp.sjtu.edu.cn/ubuntu/pool/main/c/cpu-checker/)

或通过 `lscpu` 命令:

```sh
$ lscpu | grep Virtualization
Virtualization:        VT-x
```

**可选:** 检查 KVM 模块是否已加载:

```bash
$ lsmod | grep -i kvm
kvm_intel             278528  11
kvm                   901120  1 kvm_intel
```

### 安装 QEMU 和 Virt Manager

1. 安装 QEMU (以 7.2.0 为例，可自行安装其他版本的 QEMU):

```sh
$ wget https://download.qemu.org/qemu-7.2.0.tar.xz
$ tar xvJf qemu-7.2.0.tar.xz
$ mv qemu-7.2.0 qemu
$./configure
$ sudo make -j$(nproc)
# append in ~/.bashrc
export PATH=$PATH:/path/to/qemu/build
```

也可以通过软件仓来安装 QEMU，但版本可能会比较低（除非你用的是 Arch 这类滚动发行版）

2. 安装 virt-manager:

```sh
$ sudo apt update
$ sudo apt install libvirt-clients libvirt-daemon-system bridge-utils virt-manager
```

3. 将用户加入 libvirt 和 kvm 的群，这样不用 root 也能启动 QEMU/KVM 虚拟机:

```sh
$ sudo usermod -a -G libvirt $USER
$ sudo usermod -a -G kvm $USER
$ sudo usermod -a -G input $USER
```

4. 启动 libvirtd 服务 (这个服务类似于 dockerd，本质上也是 daemon):

```sh
$ sudo systemctl enable libvirtd
$ sudo systemctl start libvirtd
```

5. 设定开机自动启用虚拟机网卡:

```sh
$ sudo virsh net-start default
$ sudo virsh net-autostart default
```

此时使用 `ip addr` 查看虚拟机网卡已被启用:

```sh
$ ip addr
...
3: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 52:54:00:c5:3f:83 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
       valid_lft forever preferred_lft forever
```

## 安装虚拟机

### 安装 EndeavourOS 虚拟机

参考 Ivon 的部落格里的两篇相关文章进行安装即可: 

- [如何在 Linux 安装 Bliss OS，支援 GPU 加速的 Android-x86 虚擬机，可玩手游](https://ivonblog.com/posts/blissos-qemu-installation/)
- [Linux QEMU/KVM 透过 virtio-gpu 启用虚擬机 3D 加速，免 GPU 直通](https://ivonblog.com/posts/linux-qemu-virglrenderer/)

### 安装 openEuler 虚拟机

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

```sh
$ sudo systemctl status sshd
sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2024-03-28 14:40:15 CST; 20min ago
...
```

然后在 Guest OS 上获取其 IP 地址 (ens3 的 inet 后的数字即是，openEuler 启动时也会输出一下 IP 地址):

```sh
$ ip addr
```

在 Host OS 上通过 ssh 连接登录 GuestOS:

```sh
$ ssh user@ip
# user: user name in the guest os
# ip ip addr of guest os
```

## References

- Ivon的部落格: [Ubuntu 安装 QEMU/KVM 和 Virt Manager 虚擬机管理员](https://ivonblog.com/posts/ubuntu-virt-manager/)

- [使用 KVM 安装和管理 deepin](https://wiki.deepin.org/zh/04_%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98FAQ/%E8%99%9A%E6%8B%9F%E6%9C%BA/%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8kvm%E5%AE%89%E8%A3%85%E5%92%8C%E7%AE%A1%E7%90%86deepin)
- [Linux 下使用 KVM 虚拟机安装 OpenEuler 系统](https://blog.51cto.com/zounan/4931973)
- [KVM 更改虚拟机默认存储路径](https://www.cnblogs.com/hahaha111122222/p/15538763.html)
- [实践 KVM on Deepin](https://wang-ray.github.io/os/2019/11/07/%E5%AE%9E%E8%B7%B5KVM-on-Deepin/)
