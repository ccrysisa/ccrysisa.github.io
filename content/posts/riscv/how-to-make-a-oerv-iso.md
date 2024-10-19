---
title: "How to make a OERV General ISO"
subtitle:
date: 2024-10-15T19:22:12+08:00
slug: 457840c
draft: false
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
categories:
  - RISC-V
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRelated: false
hiddenFromFeed: false
summary:
resources:
  - name: featured-image
    src: featured-image.jpg
  - name: featured-image-preview
    src: featured-image-preview.jpg
toc: true
math: false
lightgallery: false
password:
message:
repost:
  enable: true
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

最近接了个比较有意思的任务 **制作一个统一的 OERV ISO 镜像** [^1]，本文档是对该任务探索过程的记录。

<!--more-->

## 磁盘扩容

oemaker 要求运行镜像制作工具的临时目录或根目录空间大于 60 GB，而 OERV 使用 qemu 模拟的磁盘通常为 20 GB，所以按照以下操作为 OERV 24.09 增加一块 65 GB 的磁盘。

1. 查询当前镜像磁盘的大小:

```bash
$ qemu-img info openEuler-Mega_24.09-V1-base-qemu-testing.qcow2
image: openEuler-Mega_24.09-V1-base-qemu-testing.qcow2
file format: qcow2
virtual size: 20 GiB (21474836480 bytes)
disk size: 15.8 GiB
cluster_size: 65536
Format specific information:
    compat: 1.1
    compression type: zlib
    lazy refcounts: false
    refcount bits: 16
    corrupt: false
    extended l2: false
```

2. 重新设置镜像磁盘的大小:

```bash
$ qemu-img resize openEuler-Mega_24.09-V1-base-qemu-testing.qcow2 +60G
Image resized.
```

3. 查看当前镜像磁盘的大小，确认设置生效:

```bash
$ qemu-img info openEuler-Mega_24.09-V1-base-qemu-testing.qcow2
image: openEuler-Mega_24.09-V1-base-qemu-testing.qcow2
file format: qcow2
virtual size: 80 GiB (85899345920 bytes)
disk size: 15.8 GiB
cluster_size: 65536
Format specific information:
    compat: 1.1
    compression type: zlib
    lazy refcounts: false
    refcount bits: 16
    corrupt: false
    extended l2: false
```

显然成功从 20 GB 的磁盘大小扩展到了预期的 80 GB 磁盘大小，此时需要启动 qemu 虚拟机来进行分区，参考 [该教程](https://gist.github.com/zakkak/ab08672ff9d137bbc0b2d0792a73b7d2) 完成相应操作。

注意我们需要将上面教程的 vda3 改为 vda2 进行操作，因为我们的 OERV 24.09 并没有设置 swap 分区 (其对应教程的 vda2，而教程的 vda3 和我们的 vda2 都对应根目录)。另外重新创建 vda2 时需要保留原有的 ext4 签名。

完成后相应配置应与以下输出类似:

```bash
[root@openeuler-riscv64 ~]# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
vda    253:0    0   80G  0 disk 
├─vda1 253:1    0  512M  0 part /boot
└─vda2 253:2    0 79.5G  0 part /
```

```bash
[root@openeuler-riscv64 ~]# df -h /
文件系统        大小  已用  可用 已用% 挂载点
/dev/root        79G  4.5G   71G    6% /
```

## 生成 ISO 镜像

按照参考资料进行操作 [^2]:

生成适用于 lpi4a 的 ISO 镜像:

```bash
[root@openeuler-riscv64 ~]# oemaker \
  -t standard \
  -p openEuler \
  -v 24 \
  -r 09 \
  -s "https://mirrors.huaweicloud.com/openeuler/openEuler-24.09/everything/riscv64/ https://build-repo.tarsier-infra.isrc.ac.cn/home:/ouuleilei:/test/openEuler_24.03_mainline_riscv64/" \
  > oemaker-lpi4a.log \
  2>&1  
```

输出结果位于 `/result/` 目录下:

```bash
[root@openeuler-riscv64 ~]# ls- lh /result/
总计 3.9G
-rw-r--r-- 1 root root 3.9G 10月19日 19:28 openEuler-24-09-riscv64-dvd.iso
```

新创建一个名为 `lpi41-iso` 的目录，并将刚刚生成的 ISO 镜像移动至此:

```bash
[root@openeuler-riscv64 ~]# mkdir lpi4a-iso
[root@openeuler-riscv64 ~]# mv /result/openEuler-24-09-riscv64-dvd.iso ./lpi4a-iso/
```


[^1]: openEuler RISC-V SIG: [制作统一 ISO](https://github.com/openeuler-riscv/oerv-team/issues/1387)
[^2]: ouuleilei: [统一 ISO 制作](https://gitee.com/ouuleilei/working-documents/blob/master/RISC-V/openEuler/lpi4a/%E7%BB%9F%E4%B8%80ISO%E5%88%B6%E4%BD%9C.md)
[^3]: bilibili: [使用 imageTailor 工具制作并裁剪镜像](https://www.bilibili.com/video/BV14ZyNYyEKy)
[^4]: 帅大叔的博客: [制作iso镜像全过程](https://rstyro.github.io/blog/2021/02/04/%E5%88%B6%E4%BD%9Ciso%E9%95%9C%E5%83%8F%E5%85%A8%E8%BF%87%E7%A8%8B/)
[^5]: Just for Coding: [ISO启动原理及启动盘制作](https://just4coding.com/2023/11/01/boot-iso/)
[^6]: Github: [oemaker](https://github.com/openeuler-mirror/oemaker) 
[^7]: openEuler: [oemaker 使用指南](https://docs.openeuler.org/zh/docs/22.03_LTS_SP3/docs/TailorCustom/oemaker%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.html)
[^8]: Linux man page: [mount](https://linux.die.net/man/8/mount)
[^9]: Linux man page: [mkisofs](https://linux.die.net/man/8/mkisofs)
