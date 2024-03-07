---
title: "openEuler RISC-V 系统: QEMU 仿真和 Mugen 测试框架"
subtitle:
date: 2024-03-07T14:48:21+08:00
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
  - Linux
  - openEuler
  - Qemu
  - Mugen
categories:
  - RISC-V
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

<!--more-->

## 实验环境

- 操作系统: deepin 20.9

## 安装支持 RISC-V 架构的 QEMU 模拟器

```bash
$ sudo apt install qemu-system-misc
$ qemu-system-riscv64 --version
QEMU emulator version 5.2.0 (Debian 1:5.2+dfsg-11+deb11u1)
Copyright (c) 2003-2020 Fabrice Bellard and the QEMU Project developers
```

~~虽然 deepin 仓库提供的 QEMU 软件包版本比较低 (5.2.0)，但是根据「[引用文档](https://github.com/openeuler-mirror/RISC-V/blob/master/doc/tutorials/vm-qemu-oErv.md)」的说明，不低于 5.0 即可~~

---

通过上面安装的 QEMU 版本过低，无法支持 VGA 这类虚拟外设 (virtio)，需要手动编译安装:

如果之前通过 apt 安装了 QEMU 的可以先进行卸载:
```bash
$ sudo apt remove qemu-system-risc
$ sudo apt autoremove
```

安装必要的构建工具:
```bash
$ sudo apt install build-essential git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev ninja-build libslirp-dev
```

创建 /usr/local 下的目标目录:
```bash
$ sudo mkdir -p /usr/local/bin/qemu-riscv64
```

下载 QEMU 源码包 (此处以 7.2 版本为例):
```bash
$ wget https://download.qemu.org/qemu-7.2.0.tar.xz
```

解压源码包并切换目录:
```bash
$ tar xvJf qemu-7.2.0.tar.xz && cd qemu-7.2.0
```

配置编译选项:
```bash
$ sudo ./configure --enable-slirp --target-list=riscv64-softmmu,riscv64-linux-user --prefix=/usr/local/bin/qemu-riscv64
```

编译安装:
```bash
$ sudo make -j$(nproc)
$ sudo make install -j$(nproc)
```

拷贝编译完成的目标文件到目标目录 /usr/local:
```bash
$ sudo cp -r build/ /usr/local/bin/qemu-riscv64
```

在 ~/.bashrc 中添加环境变量:
```bash
export PATH=$PATH:/usr/local/bin/qemu-riscv64/build
```

刷新一下 ~/.bashrc (或新开一个终端) 查看一下 QEMU 是否安装成功:
```bash
$ source ~/.bashrc
$ qemu-system-riscv64 --version
QEMU emulator version 7.2.0
Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
```

## 下载 openEuler RISC-V 系统镜像

实验指定的测试镜像 (当然如果不是实验指定的话，你也可以使用其他的镜像):
- https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-23.09-V1-riscv64/QEMU/

由于我是直接使用 ssh 连接 openEuler RISC-V 的 QEMU 虚拟机，所以只下载了:
- `fw_payload_oe_uboot_2304.bin` 启动用内核
- `openEuler-23.09-V1-base-qemu-preview.qcow2.zst` 不带有桌面镜像的根文件系统
- `start_vm.sh` 启动不带有桌面镜像的根文件系统用脚本

```bash
$ wget https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-23.09-V1-riscv64/QEMU/fw_payload_oe_uboot_2304.bin
$ wget https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-23.09-V1-riscv64/QEMU/openEuler-23.09-V1-base-qemu-preview.qcow2.zst
$ wget https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-23.09-V1-riscv64/QEMU/start_vm.sh
```

解压缩根文件系统的磁盘映像:

```bash
# install unzip tool zstd for zst
$ sudo apt install zstd
$ unzstd openEuler-23.09-V1-base-qemu-preview.qcow2.zst
```

## 启动 openEuler RISC-V 系统并连接

确认当前在刚刚下载了内核、根文件系统、启动脚本的目录，然后在一个终端上执行启动脚本:
```bash
$ bash start_vm.sh
```
安心等待输出完毕出现提示登录界面 (时间可能会有点长)，然后输入账号和密码进行登录即可

或者启动 QEMU 虚拟机后，新开一个终端通过 ssh 进行登录:
```bash
$ ssh -p 12055 root@localhost
$ ssh -p 12055 openeuler@localhost
```

通过 `exit` 命令可以退出当前登录账号，通过快捷键 `Ctrl + A + Z` 可以关闭 QEMU 虚拟机 (本质上是信号 signal 处理 :rofl:)

> 建议登录后修改账号的密码 (相关命令: [passwd](https://linux.die.net/man/1/passwd))

## Mugen 测试框架

> 根据 「[mugen](https://gitee.com/openeuler/mugen)」 README 的使用教程，在指定测试镜像上完成 「安装依赖软件」「配置测试套环境变量」「用例执行」这三个部分，并给出实验总结

### 安装 git & 克隆 mugen 仓库

登录普通用户 openeuler 然后发现此时没有安装 git 无法克隆 mugen 仓库，先安装 git:

```bash
$ sudo dnf install git
$ git clone https://gitee.com/openeuler/mugen.git
```

> 原始设定的 vim 配置不太优雅，我根据我的 vim 配置进行了设置，具体见 [「Vim 配置]({{< relref "../sysprog/gnu-linux-dev.md#终端和-vim" >}})」

### 安装依赖软件

进入 mugen 目录执行安装依赖软件脚本 (因为我使用的是普通用户，需要使用 `sudo` 提高权级):

```bash
$ sudo bash dep_install.sh
...
Complete!
```

### 配置测试套环境变量

```bash
$ sudo bash mugen.sh -c --ip $ip --password $passwd --user $user --port $port
```

> 这部分仓库的文档对于本机测试没有很清楚地说明，参考文章 「[基于openEuler虚拟机本地执行mugen测试脚本](http://devops-dev.com/article/438)」完成配置

执行完成后会多出一个环境变量文件 ./conf/env.json

### 用例执行 & 结果分析

我对于 openEuler RISC-V 是否支持了 binutils 比较感兴趣，便进行了测试:
```bash
$ sudo bash mugen.sh -f binutils -x
...
INFO  - A total of 8 use cases were executed, with 8 successes 0 failures and 0 skips.
```

执行结果显示已正确支持 binutils

接下来对程序静态分析工具 cppcheck 的支持进行测试:

```bash
$ sudo bash mugen.sh -f cppcheck -x
...
```

根据文档 [suite2cases 中 json文件的写法](https://gitee.com/openeuler/mugen/tree/master#suite2cases%E4%B8%ADjson%E6%96%87%E4%BB%B6%E7%9A%84%E5%86%99%E6%B3%95) 的解释，分析刚刚执行的测试套:

## References

- openEuler RISC-V: [通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统](https://github.com/openeuler-mirror/RISC-V/blob/master/doc/tutorials/vm-qemu-oErv.md)
- openEuler RISC-V: [使用 QEMU 安装 openEuler RISC-V 23.03](https://gitee.com/openeuler/RISC-V/blob/master/release/openEuler-23.03/Installation_Book/QEMU/README.md)
- Ariel Heleneto: [通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统](https://github.com/ArielHeleneto/Work-PLCT/tree/master/awesomeqemu)
- openEuler: [mugen](https://gitee.com/openeuler/mugen)
- openEuler Docs: [使用DNF管理软件包](https://docs.openeuler.org/zh/docs/22.03_LTS_SP2/docs/Administration/%E4%BD%BF%E7%94%A8DNF%E7%AE%A1%E7%90%86%E8%BD%AF%E4%BB%B6%E5%8C%85.html)
- [基于openEuler虚拟机本地执行mugen测试脚本](http://devops-dev.com/article/438)
