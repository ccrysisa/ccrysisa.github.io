---
title: "How to make a OERV General ISO image"
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
  - OERV
  - ISO
  - image
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

最近接了个比较有意思的任务 **制作一个统一的 OERV ISO 镜像** [^1]，本文档是对该任务探索过程的记录。该任务需要对 ISO 镜像的制作过程有一定的了解，这部分可以参考这两篇博文：制作 ISO 镜像全过程 [^2]、ISO 启动原理及启动盘制作 [^3]。

<!--more-->

## 磁盘扩容

oemaker [^4] 的操作手册 [^5] 指明运行该镜像制作工具的临时目录或根目录空间大于 60 GB，而 OERV 使用 qemu 模拟的磁盘通常为 20 GB，所以按照以下操作为 OERV 24.09 增加一块 65 GB 的磁盘。

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

按照参考资料进行操作 [^6]:

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

适用于 sg2042 的 ISO 镜像的生成操作也是类似的，除了最后新建目录移动步骤:

```bash
[root@openeuler-riscv64 ~]# mkdir sg2042-iso
[root@openeuler-riscv64 ~]# mv /result/openEuler-24-09-riscv64-dvd.iso ./sg2042-iso/
```

## ISO 镜像裁剪拼合

接下来将两个 ISO 镜像的 grub 部分进行定制化裁剪、拼合，可以参考汪流老师在 B 站上的技术分析 **使用 imageTailor 工具制作并裁剪镜像** [^7] 来了解相关原理，里面也对操作中涉及的命令 `mount` [^8], `mkisofs` [^9], `rsync` [^10] 的原理和使用进行解释说明。

这个步骤的主要原理是：以适用于 sg2042 的 ISO 镜像为基础，增加适用于 lpi4a 的 ISO 镜像的 EFI boot 数据，最后通过 `mkisofs` 进行 ISO 镜像定制。

这里面主要注意 `mkisofs` 命令以下的参数设置:

```bash
-eltorito-alt-boot -e images/lpi4a/efiboot.img  -no-emul-boot -eltorito-alt-boot -e images/efiboot.img
```

查询 man 手册得到的相关解释如下:

`-eltorito-alt-boot`   
Start with a new set of El Torito boot  parameters.   Up  to  63  El  Torito  boot
entries may be stored on a single CD.

`-e` efi_boot_file

`-no-emul-boot`   
Specifies that the boot image used to create El  Torito  bootable  CDs  is  a  "no
emulation"  image.  The system will load and execute this image without performing
any disk emulation.

即设置了两个 EFI 分区引导启动

最后制作出来的 ISO 镜像大概 4.8 GB:

```bash
[root@openeuler-riscv64 ~]# ls -lh 
-rw-r--r--  1 root root 4.8G 10月20日 18:14 openEuler-24-09-riscv64-dvd-lpi4a-sg2042.iso
```

## 挂载 qcow2 镜像

由于我们是在 qemu 里启动的 oerv 24.09 并进行了上面的一系列 ISO 镜像制作操作，但是接下来我们需要使用在 Host 上使用 qemu 来测试刚刚我们所制作的 ISO 镜像是否满足我们的需求 (同时适用于 sg2042 和 lpi4a)，所以接下来我们需要参考相关文档 [^11] [^12]，在 Host 上挂载 oerv 24.09 的 qcw2 镜像，并提取出刚刚生成的 ISO 镜像到 Host 以使用 Host 上已安装的 qemu 进行相应测试。

在 **Host** 上进行以下操作:

1. Enable NBD on the Host

```bash
$ sudo modprobe nbd max_part=8
```

2. Connect the QCOW2 as network block device

```bash
$ sudo qemu-nbd --connect=/dev/nbd0 /path/to/openEuler-Mega_24.09-V1-base-qemu-testing.qcow2.qcow2
```

3. Find The Virtual Machine Partitions

```bash
$ sudo fdisk /dev/nbd0 -l
Disk /dev/nbd0: 80 GiB, 85899345920 bytes, 167772160 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 17E82169-18F8-4809-840F-944E48FC6708

Device        Start       End   Sectors  Size Type
/dev/nbd0p1    2048   1050623   1048576  512M BIOS boot
/dev/nbd0p2 1050624 167770111 166719488 79.5G Linux filesystem
```

> 这里我们只需要关心类型为 Linux filesystem 的分卷，记录下其所处的设备，这里是 `/dev/nbd0p2`

4. Mount the partition from the VM

```bash
$ sudo mount /dev/nbd0p1 /mnt/
```

5. Transfer image from VM to Host

```bash
$ sudo rsync -avP /mnt/root/openEuler-24-09-riscv64-dvd-lpi4a-sg2042.iso ./iso/
```

6. After you done, check image, unmount and disconnect

```bash
$ ls ./iso/ -lh
-rw-r--r-- 1 root root 4.8G 10月 20 18:14 openEuler-24-09-riscv64-dvd-lpi4a-sg2042.iso
$ sudo unmount /mnt
$ qemu-nbd --disconnect /dev/nbd0
```

## 验证镜像

验证脚本还需要一些额外的资源文件支持:

- `RISCV_VIRT_CODE.fd` 和 `RISCV_VIRT_VARS.fd` 可以使用 OERV 24.09 的同名文件
- `test.raw` 可以参考这个教程 [^13] 来将 OERV 24.09 的 `.qcow2` 镜像转换为 `raw` 格式

接下来只需要通过 qemu 分别模拟在 lpi4a 设备和 sg2042 设备的安装即可

### lpi4a 设备的安装

1. 启动相应脚本

{{< image src="" >}}

2. 进入这个界面时按 `F2` 键进入引导启动选项 (deepin 终端的 `F2` 被设置为更改标签页的标题，最初给我造成了混淆)

{{< image src="" >}}

3. 通过方向键选择其中的 `Boot Mananger` 栏目并进入

{{< image src="" >}}

4. 通过方向键选择其中的 `EFI Internal Shell` 栏目并进入

{{< image src="" >}}

5. 此时便进入了 UEFI shell 界面

{{< image src="" >}}

6. 输入命令 `fs0:\EFI\BOOT\BOOTRISCV64.EFI` 来启动对应 lpi4a 设备的 EFI 程序进行模拟安装

{{< image src="" >}}

7. 选择 `Install openEuler 24-09` 开始进行模拟在 lpi4a 设备的安装

{{< image src="" >}}

8. 等待片刻后 qemu 窗口便会出现我们熟悉的 openEuler 通过 ISO 镜像安装的界面

模拟 lpi4a 设备安装 OERV 24.09 成功

### sg2042 设备的安装

流程与 lpi4a 设备的安装类似，不同之处在于在 UEFI shell 输入命令时，输入 `fs1:\EFI\BOOT\BOOTRISCV64.EFI` 来启动对应 sg2042 设备的 EFI 程序进行模拟安装

{{< image src="" >}}

最终 qemu 窗口也会出现我们熟悉的 openEuler 通过 ISO 镜像安装的界面

模拟 sg2042 设备安装 OERV 24.09 成功


[^1]: openEuler RISC-V SIG: [制作统一 ISO](https://github.com/openeuler-riscv/oerv-team/issues/1387)
[^2]: 帅大叔的博客: [制作 ISO 镜像全过程](https://rstyro.github.io/blog/2021/02/04/%E5%88%B6%E4%BD%9Ciso%E9%95%9C%E5%83%8F%E5%85%A8%E8%BF%87%E7%A8%8B/)
[^3]: Just for Coding: [ISO 启动原理及启动盘制作](https://just4coding.com/2023/11/01/boot-iso/)
[^4]: Github: [oemaker](https://github.com/openeuler-mirror/oemaker) 
[^5]: openEuler: [oemaker 使用指南](https://docs.openeuler.org/zh/docs/22.03_LTS_SP3/docs/TailorCustom/oemaker%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.html)
[^6]: ouuleilei: [统一 ISO 制作](https://gitee.com/ouuleilei/working-documents/blob/master/RISC-V/openEuler/lpi4a/%E7%BB%9F%E4%B8%80ISO%E5%88%B6%E4%BD%9C.md)
[^7]: bilibili: [使用 imageTailor 工具制作并裁剪镜像](https://www.bilibili.com/video/BV14ZyNYyEKy)
[^8]: Linux man page: [mount](https://linux.die.net/man/8/mount)
[^9]: Linux man page: [mkisofs](https://linux.die.net/man/8/mkisofs)
[^10]: Linux man page: [rsync](https://linux.die.net/man/1/rsync)
[^11]: Alex Simenduev: [How to mount a qcow2 disk image](https://gist.github.com/shamil/62935d9b456a6f9877b5)
[^12]: Baeldung Linux: [How to Mount a QCOW2 Image in Linux?](https://www.baeldung.com/linux/mount-qcow2-image)
[^13]: [Converting the QCOW2 image to a raw file format](https://documentation.avaya.com/bundle/DeployingAvayaSBConanAWSPlatform_r102x/page/Converting_the_QCOW2_image_to_a_raw_file_format.html)
