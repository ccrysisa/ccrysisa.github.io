---
title: 清大计算机网络重点提示
subtitle:
date: 2024-01-14T12:09:38+08:00
slug: 3d012d7
draft: true
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
  - Network
categories:
  - Network
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRss: false
hiddenFromRelated: false
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

国立清华大学 黄能富教授 计算机网络概论 重点提示和练习。

<!--more-->

## L01 Foundation 重点提示与练习

{{< image src="/images/network/L1-05.png" >}}

进行 1 次 URL request 需要进行 17 次的讯息交换：
- 6 次讯息交换用于查询 URL 对应的 IP Address
- 3 次讯息交换用于建立 TCP 连接（TCP 的 3 次握手）
- 4 次讯息交换用于 HTTP 协议的请求和回复
- 4 次讯息交换用于关闭 TCP 连接（TCP 的 4 次握手）


{{< image src="/images/network/L1-08.png" >}}

交换机 (Switches) 可以分为很多层级，即可以有不同层级的交换机，例如 L2 层的交换机，L3 层的交换机以及 L4 层的交换机。如何判断交换机是哪个层级？很简单，只需要根据交换机所处理的讯息，L2 层交换机处理的是 MAC Address，L3 层交换机处理的是 IP Address，而 L4 层交换机处理的是 TCP 或者 UDP 相关的讯息。

交换机 (Switches) 用于网络 (Network) 内部的连接，路由 (Router) 用于连接不同的网络 (Network)，从而形成 Internetwork。

地址 (Address)，对于网卡来说是指 MAC Address，对于主机来说是指 IP Address。Host-to-Host connectivity 是指不同网络 (Network) 的主机，即位于 Internetwork 的不同主机之间，进行连接。