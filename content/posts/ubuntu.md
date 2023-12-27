---
title: Ubuntu 22.04 配置
subtitle:
date: 2023-12-27T20:35:45+08:00
draft: false
author:
  name: vanJker
  link: https://github.com/vanJker
  email: cjshine@foxmail.com
  avatar: https://avatars.githubusercontent.com/u/88960102?s=96&v=4
description:
keywords:
license:
comment: false
weight: 0
tags:
  - Linux 
  - Ubuntu
categories:
  - Linux
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

# Ubuntu 网络和输入法

## 网络代理

根据项目 [clash-for-linux-backup][cflbp] 来配置 Ubuntu 的网络代理。

```bash
$ git clone https://github.com/Elegybackup/clash-for-linux-backup.git clash-for-linux
```

过程当中可能需要安装 curl 和 net-tools，根据提示进行安装即可：

- `sudo apt install curl`
- `sudo apt install net-tools`

安装并启动完成后，可以通过 `localhost:9090/ui` 来访问 Dashboard。

启动代理：

```bash
$ cd clash-for-linux
$ sudo bash start.sh
$ source /etc/profile.d/clash.sh
$ proxy_on
```

关闭代理：

```bash
$ cd clash-for-linux
$ sudo bash shutdown.sh
$ proxy_off
```

## 搜狗输入法

根据 [搜狗输入法 Linux 安装指导][sougou-linux-guide] 来安装搜狗输入法。

- 无需卸载系统 ibus 输入法框架。
- 通过 `Ctrl + space` 唤醒搜狗输入法。


[cflbp]: https://github.com/Elegybackup/clash-for-linux-backup
[sougou-linux-guide]: https://shurufa.sogou.com/linux/guide
