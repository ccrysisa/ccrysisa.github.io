---
title: "OERV 之 Pretask"
subtitle:
date: 2024-03-28T19:15:59+08:00
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
  - RISC-V
  - openEuler
  - QEMU
  - Neofetch
  - Container
  - chroot
  - nspawn
categories:
  - Architecture
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

> pretask 作为社区入门探索，目的是帮助实习生一起搭建工作环境，熟悉 oerv 的工作流程和合作方式。pretask 分为三个步骤:
> - 任务一：通过 QEMU 仿真 RISC-V 环境并启动 openEuler RISC-V 系统，设法输出 neofetch 结果并截图提交
> - 任务二：在 openEuler RISC-V 系统上通过 obs 命令行工具 osc，从源代码构建 RISC-V 版本的 rpm 包，比如 pcre2。提示首先需要在 [openEuler 的 OBS](https://build.openeuler.openatom.cn/project/show/openEuler:Mainline:RISC-V) 上注册账号 
> - 任务三：尝试使用 qemu user & nspawn 或者 docker 加速完成任务二

<!--more-->

## Pretask 1: Neofetch

> 任务一：通过 QEMU 仿真 RISC-V 环境并启动 openEuler RISC-V 系统，设法输出 neofetch 结果并截图提交

由于工作内容是对软件包进行: 编译 -> 失败 -> 定位问题 -> 修复 -> 重新编译，所以我们倾向于直接从源码编译，根据 [neofetch wiki](https://github.com/dylanaraps/neofetch/wiki/Installation#latest-git-master-bleeding-edge) 从 git 拉取最新数据进行构建:

```bash
# enter into euler openEuler RISC-V QEMU
$ git clone https://github.com/dylanaraps/neofetch
$ cd neofetch
$ make install
$ neofetch
```

{{< image src="/images/oerv/openEuler-RISC-V-neofetch.png" >}}

## Pretask 2: Open Build Service (OBS)

> 任务二：在 openEuler RISC-V 系统上通过 obs 命令行工具 osc，从源代码构建 RISC-V 版本的 rpm 包，比如 pcre2。提示首先需要在 [openEuler 的 OBS](https://build.openeuler.openatom.cn/project/show/openEuler:Mainline:RISC-V) 上注册账号 

观看教学影片: [openEuler构建之OBS使用指导 - bilibili](https://www.bilibili.com/video/BV1YK411H7E2/) 并对比阅读

- [Beginnerʼs Guide](https://openbuildservice.org/help/manuals/obs-user-guide/art.obs.bg)
- [openSUSE:Build Service 新手入门](https://zh.opensuse.org/openSUSE:Build_Service_%E6%96%B0%E6%89%8B%E5%85%A5%E9%97%A8)
- [如何通过OpenSUSE Open Build Service（OBS）构建Debian包 for RISCV-64](https://zhuanlan.zhihu.com/p/564032072)

了解掌握 OBS 的基本概念、OBS 网页 以及 **OSC 命令行工具** 的使用方法。

> 这部分内容很重要，和后续工作内容息息相关，在这里不要图快，打牢基础比较好。

{{< image src="/images/oerv/obs-concepts.png" >}}
{{< image src="/images/oerv/obs-concepts-2.png" >}}

OBS 的 Package 中 _service 配置文件，revision 字段是对应与 Git 仓库的 commit id (如果你使用的 Source Code Management (SCM) 方式是 Git 托管的话)

参考仓库: https://gitee.com/zxs-un/doc-port2riscv64-openEuler 内的相关文档

- [osc命令工具的安装与~/.oscrc配置文件](https://gitee.com/zxs-un/doc-port2riscv64-openEuler/blob/master/doc/build-osc-config-oscrc.md)
- [在 openEuler 上安装 osc build 本地构建工具](https://gitee.com/zxs-un/doc-port2riscv64-openEuler/blob/master/doc/build-osc-build-tools.md)
- [使用 osc build 在本地构建 openEuler OBS 服务端的内容](https://gitee.com/zxs-un/doc-port2riscv64-openEuler/blob/master/doc/build-osc-obs-service.md)

在 openEuler RISC-V QEMU 虚拟机内完成 OBS、OSC 相关基础设施的安装:

```bash
# install osc and build
$ sudo yum install osc build

# configure osc in ~/.oscrc
[general]
apiurl = https://build.openeuler.openatom.cn
no_verify = 1 # 未配置证书情况下不验证

[https://build.openeuler.openatom.cn]
user=username # 用户名
pass=password # 明文密码
trusted_prj=openEuler:selfbuild:function # 此项目为openEuler:Mailine:RISC-V项目的依赖库
```

在 openEuler RISC-V QEMU 虚拟机内完成 pcre2 的本地编译构建:

```bash
# 选定 pcre2 包
$ osc co openEuler:Mainline:RISC-V/pcre2
$ cd openEuler\:Mainline\:RISC-V/pcre2/
# 更新并下载相关文件到本地
$ osc up -S
# 重命名刚刚下载的文件
$ rm -f _service;for file in `ls | grep -v .osc`;do new_file=${file##*:};mv $file $new_file;done
# 查看一下仓库信息，方便后续构建
$ osc repos
standard_riscv64  riscv64
mainline_gcc      riscv64
# 指定仓库和架构并进行本地构建
$ osc build standard_riscv64 riscv64
```

{{< image src="/images/oerv/osc-build-pcre2.png" >}}

总计用时 1301s

## Pretask 3: 容器加速构建

> 任务三：尝试使用 qemu user & nspawn 或者 docker 加速完成任务二

参考 [文档](https://gitee.com/openeuler/RISC-V/blob/master/doc/tutorials/qemu-user-mode.md)

由于 deepin 20.9 的 Python3 版本仅为 3.7，构建 osc 和 qemu 显然不太够，所以我通过 KVM 构建了一个 openEuler 22.03 LTS SP3 的虚拟机，在上面进行这项任务。

- [Deepin 20.9 KVM 安装和管理 openEuler 22.03 LTS SP3]({{< relref "../toolkit/deepin-kvm" >}})

编译 QEMU 时常见错误修正:

```bash
ERROR: Python package 'sphinx' was not found nor installed.
$ sudo yum install python3-sphinx

ERROR: cannot find ninja
$ sudo yum install ninja-build
```

openEuler 22.03 LTS SP3 没有预先安装好 nspawn，所以需要手动安装:

```bash
$ sudo yum install systemd-container systemd-nspawn
```

其余同任务二。

尝试使用 nspawn 来构建 pcre2:

```bash
$ osc build standard_riscv64 riscv64 --vm-type=nspawn
```

会遇到以下报错 (且经过相当多时间排错，仍无法解决该问题，个人猜测是平台问题):

```bash
can't locate file/copy.pm: /usr/lib64/perl5/vendor_perl/file/copy.pm: permission denied at /usr/bin/autoreconf line 49.
```

所以退而求其次，使用 chroot 来构建:

```bash
$ osc build standard_riscv64 riscv64 --vm-type=chroot
```

{{< image src="/images/oerv/osc-build-pcre2-chroot.png" >}}

总计用时 749s，比 qemu-system-riscv64 快了将近 2 倍，效能提升相当可观。

## References

- https://gitee.com/zxs-un/doc-port2riscv64-openEuler/blob/master/doc/build-osc-config-oscrc.md
- https://gitee.com/zxs-un/doc-port2riscv64-openEuler/blob/master/doc/build-osc-build-tools.md
- https://gitee.com/zxs-un/doc-port2riscv64-openEuler/blob/master/doc/build-osc-obs-service.md
- https://gitee.com/openeuler/RISC-V/blob/master/doc/tutorials/qemu-user-mode.md
- https://stackoverflow.com/questions/5308816/how-can-i-merge-multiple-commits-onto-another-branch-as-a-single-squashed-commit