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
  - QEMU
  - Mugen
categories:
  - RISC-V
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

> 本文对通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统的流程进行详细介绍，以及介绍如何通过 [mugen](https://gitee.com/openeuler/mugen) 测试框架来对 RISC-V 版本的 openEuler 进行系统、软件等方面测试，并根据测试日志对错误原因进行分析。

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

下载 QEMU 源码包 (此处以 7.2 版本为例):
```bash
$ wget https://download.qemu.org/qemu-7.2.0.tar.xz
```

解压源码包、修改名称并移动到目标目录 /usr/local/bin/:
```bash
$ tar xvJf qemu-7.2.0.tar.xz
$ mv qemu-7.2.0 qemu-riscv64
$ sudo mv qemu-riscv64 /usr/local/bin/
```

进入 qemu 对应目录并配置编译选项:
```bash
$ sudo ./configure --enable-slirp --target-list=riscv64-softmmu,riscv64-linux-user --prefix=/usr/local/bin/qemu-riscv64
```

编译安装:
```bash
$ sudo make -j$(nproc)
$ sudo make install -j$(nproc)
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

通过 `exit` 命令可以退出当前登录账号，通过快捷键 `Ctrl + A, X` 可以关闭 QEMU 虚拟机 (本质上是信号 signal 处理 :rofl:)

> 建议登录后修改账号的密码 (相关命令: [passwd](https://linux.die.net/man/1/passwd))

## Mugen 测试框架

> *根据 「[mugen](https://gitee.com/openeuler/mugen)」 README 的使用教程，在指定测试镜像上完成 「安装依赖软件」「配置测试套环境变量」「用例执行」这三个部分，并给出实验总结*

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
INFO  - A total of 2 use cases were executed, with 1 successes 1 failures and 0 skips.
```

根据文档 [suite2cases 中 json文件的写法](https://gitee.com/openeuler/mugen/tree/master#suite2cases%E4%B8%ADjson%E6%96%87%E4%BB%B6%E7%9A%84%E5%86%99%E6%B3%95) 的解释，分析刚刚执行的测试套 `suit2cases/cppcheck.json`，是测试用例 `oe_test_cppcheck` 失败了。    
观察该用例对应的脚本 `testcases/cli-test/cppcheck/oe_test_cppcheck/oe_test_cppcheck.sh`，并打开对应的日志 `logs/cppcheck/oe_test_cppcheck/$(date).log` 在里面检索 `LOG_ERROR`，找到两处相关错误:

```bash
+ LOG_ERROR 'oe_test_cppcheck.sh line 70'
+ LOG_ERROR 'oe_test_cppcheck.sh line 95'
```

比照用例脚本，对应的测试逻辑是:

```sh
        cppcheck --std=c99 --std=posix test.cpp
70-->   CHECK_RESULT $?

        if [ $VERSION_ID != "22.03" ]; then
            cppcheck -DA --force file.c | grep "A=1"
95-->       CHECK_RESULT $? 1
        else
            cppcheck -DA --force file.c | grep "A=1"
            CHECK_RESULT $?
        fi
```

- [Cppcheck manual](https://cppcheck.sourceforge.io/manual.pdf) P11

> The flag -D tells Cppcheck that a name is defined. There will be no Cppcheck analysis without this define.

> The flag --force
and --max-configs is used to control how many combinations are checked.
When -D is used, Cppcheck will only check 1 configuration unless these are used.

这里面 `CHECK_RESULT` 是一个自定义的 shell 函数，扫一下 mugen 的库目录 `libs`，在 `locallibs/common_lib.sh` 里找到该函数的定义，它的逻辑比较好懂 (类似于 `assert`)，但是函数开头的变量定义让我有些迷糊，于是求教于 GPT:

```sh
    actual_result=$1
    expect_result=${2-0}
    mode=${3-0}
    error_log=$4
```
> GPT: 
> - actual_result 变量被赋值为第一个参数的值。
> - expect_result 变量被赋值为第二个参数的值，如果第二个参数不存在，则默认为 0。
> - mode 变量被赋值为第三个参数的值，如果第三个参数不存在，则默认为 0。
> - error_log 变量被赋值为第四个参数的值。

所以，涉及错误的两个测试逻辑都很好理解了:
- `CHECK_RESULT $?` 表示上一条命令返回值的预期是 0
- `CHECK_RESULT $? 1` 表示上一条命令返回值的预期是 1

接下来我们就实际测试一下这两个用例:

安装 cppcheck: 
```bash
$ sudo dnf install cppcheck
```

执行测试脚本 70 行对应的上一条命令:
```bash
$ cppcheck --std=c99 --std=posix test.cpp
cppcheck: error: unknown --std value 'posix'
$ echo $?
1
```
> 测试失败原因是 cppcheck risc-v 版本不支持指定 C/C++ 标准为 posix (同时查询了下 「[cppcheck manual](https://github.com/danmar/cppcheck/blob/main/man/manual.md)」目前 cppcheck 支持的标准里并未包括 posix)

执行测试脚本 95 行对应的上一条命令:
```bash
$ cppcheck -DA --force file.c | grep "A=1"
Checking file.c: A=1...
file.c:5:6: error: Array 'a[10]' accessed at index 10, which is out of bounds. [arrayIndexOutOfBounds]
    a[10] = 0;
     ^
$ echo $?
0
```
> 测试失败原因是 grep 在之前的 cppcheck 的输出里匹配到 `A=1`，所以导致返回值为 0。这部分测试的逻辑是: 仅对于 22.03 版本 openEuler 上的 cppcheck 在以参数 `-DA` 执行时才会输出包含 `A=1` 的信息，但是个人猜测是在比 22.03 及更高版本的 openEuler 上使用 cppcheck 搭配 `-DA` 都可以输出包含 `A=1` 的信息

### 实验总结和讨论

初步体验了使用 QEMU 构建 openEuler RISC-V 系统虚拟机的流程，以及使用 ssh 连接 QEMU 虚拟机的技巧。实验过程中最大感触是 mugen 的文档，相对于 cppcheck 这类产品的文档，不够详细，很多内容需要阅读源码来理解 (好处是精进了我对 shell 脚本编程的理解 :rofl:)。

我个人比较期待 RISC-V 配合 nommu 在嵌入式这类低功耗领域的发展，同时也对 [RISC-V Hypervisor	Extension](https://riscv.org/wp-content/uploads/2017/12/Tue0942-riscv-hypervisor-waterman.pdf) 在虚拟化方面的发展感兴趣。

## References

- openEuler RISC-V: [通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统](https://github.com/openeuler-mirror/RISC-V/blob/master/doc/tutorials/vm-qemu-oErv.md)
- openEuler RISC-V: [使用 QEMU 安装 openEuler RISC-V 23.03](https://gitee.com/openeuler/RISC-V/blob/master/release/openEuler-23.03/Installation_Book/QEMU/README.md)
- Ariel Heleneto: [通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统](https://github.com/ArielHeleneto/Work-PLCT/tree/master/awesomeqemu)
- openEuler: [mugen](https://gitee.com/openeuler/mugen)
- openEuler Docs: [使用 DNF 管理软件包](https://docs.openeuler.org/zh/docs/22.03_LTS_SP2/docs/Administration/%E4%BD%BF%E7%94%A8DNF%E7%AE%A1%E7%90%86%E8%BD%AF%E4%BB%B6%E5%8C%85.html)
- [基于 openEuler 虚拟机本地执行 mugen 测试脚本](http://devops-dev.com/article/438)
- Video: [Mugen 框架的使用](https://www.bilibili.com/video/BV1UU4y1G7Zs/)
