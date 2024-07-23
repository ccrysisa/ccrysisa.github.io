---
title: "计算机网络"
subtitle:
date: 2024-01-14T12:09:38+08:00
slug: 3d012d7
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
  - Network
  - Security
categories:
  - Systems
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

<!--more-->

## NTHU 计算机网络概论

{{< admonition >}}
必看部分为 L2 IEEE 802.3 Ethernet，即学习数据链路层，其它部分可以选择来看。后续可以看 Stanford 的 CS144，它是从 IP Level 开始讲的，所以需要我们对数据链路层有一定的认知。
{{< /admonition >}}

之前学校的计网理论课学得云里雾里，对于物理层和数据链路层并没有清晰的逻辑框架，而这学期的计网课设内容为数据链路层和网络层的相关内容，写起来还是云里雾里。虽然最终艰难地把课设水过去了，但是个人认为网络对于 CSer 非常重要，特别是在互联网行业，网络知识是必不可少的。
所以决定寒假重学计网，于是在 [HackMD](https://hackmd.io/) 上冲浪寻找相关资料。然后发现了这篇笔记 [110-1 計算機網路 (清大開放式課程)](https://hackmd.io/@0xff07/network/https%3A%2F%2Fhackmd.io%2F%400xff07%2FByADDQ57Y)，里面提到清大计网主要介绍 L2 ~ L4 一些著名的协议和算法，这完美符合个人的需求，而且该笔记还补充了一些额外的内容，例如 IPv6，所以当即决定搭配这篇笔记来学习清大的计算机网络概论。

| 开课学校 | 课程主页 | 课程资料 | 课程影片 |
| :-----: | :----: | :-----: | :-----: |
| 國立清華大學 | [計算機網路概論][courseinfo] | [課程講義與練習題][slides&hws] | [Youtube][playlist] |

### Foundation

Outline:

- Applications
- Network Connectivity
- Network Architecture
- Network Performance

#### Applications

{{< image src="/images/network/L1-05.png" caption="Foundation - 5" >}}

进行 1 次 URL request 需要进行 17 次的讯息交换：
- 6 次讯息交换用于查询 URL 对应的 IP Address
- 3 次讯息交换用于建立 TCP 连接（TCP 的 3 次握手）
- 4 次讯息交换用于 HTTP 协议的请求和回复
- 4 次讯息交换用于关闭 TCP 连接（TCP 的 4 次握手）

#### Network Connectivity

{{< image src="/images/network/L1-08.png" caption="Foundation - 8" >}}

交换机 (Switches) 可以分为很多层级，即可以有不同层级的交换机，例如 L2 层的交换机，L3 层的交换机以及 L4 层的交换机。如何判断交换机是哪个层级？很简单，只需要根据交换机所处理的讯息，L2 层交换机处理的是 MAC Address，L3 层交换机处理的是 IP Address，而 L4 层交换机处理的是 TCP 或者 UDP 相关的讯息。

交换机 (Switches) 用于网络 (Network) 内部的连接，路由 (Router) 用于连接不同的网络 (Network)，从而形成 Internetwork。

地址 (Address)，对于网卡来说是指 MAC Address，对于主机来说是指 IP Address。Host-to-Host connectivity 是指不同网络 (Network) 的主机，即位于 Internetwork 的不同主机之间，进行连接。

#### Network Architecture

{{< image src="/images/network/L1-22.png" caption="Foundation - 22" >}}

**Physical Layer:** 如何将原始资料在 link 上传输，例如不同介质、信息编码。(P25)

**Data Link Layer:** 在 Physical Layer 基础上，如何将 frame 传给直接相连的主机或设备，核心是通过 *Media Access Control Protocol* 解决 Multiple access 产生的碰撞问题。这一层交换的数据被称为 *frame*。(P26)

**Network Layer:** 在 Data Link Layer 基础上，如何将 packet 通过 Internet 送给目的地主机。核心是通过 *Routing Protocols* 动态转发 packet。这一层交换的数据被称为 *packet*。(P27)

**Transport Layer:** 在 Network Layer 基础上，提供不同主机 processes 之间的资料传送。由于 Networkd Layer 是主机间进行资料传送，所以在 Transport Layer 不论是可靠还是不可靠的传输协议，都必须要实现最基本的机制：主机与 process 之间数据的复用和分解。这一层交换的数据被称为 *message*。(P28)

{{< admonition >}}
Switch 一般处于 L2 Layer，Router 一般处于 L3 Layer。L4 Layer 及以上的 layers 通常只存在于 hosts，switches 和 routers 内部一般不具有这些 layers。(P29)

Internet Architecture 的层级并不是严格的，Host 可以略过 Application Layer 而直接使用 Transport Layer、Network Layer 中的协议。(P30)

Internet Architecture 的核心是 IP 协议，它作为沙漏形状的中心位置，为处于其上层的协议与处于其下层协议之间提供了一个映射关系。(P31)
{{< /admonition >}}

#### Network Performance

{{< image src="/images/network/L1-36.png" caption="Foundation - 36" >}}
{{< image src="/images/network/L1-37.png" caption="Foundation - 37" >}}

**Bandwidth:** Number of bits per second (P34) 

**Delay** 可以近似理解为 Propagation time。有效利用 network 的标志是在接收对方的回应之前，发送方传送的资料充满了 pipe，即发送了 Delay $\times$ Bandwitdh bits 的资料量。(P39)

{{< image src="/images/network/L1-40.png" caption="Foundation - 40" >}}

**RTT** 可以近似理解为 2 $\times$ Propagation time，因为一个来回需要从 sender 到 reciever，再从 reciever 到 sender。

#### Homework

{{< admonition info >}}
Redis 作者 Salvatore Sanfilippo 的聊天室项目: [smallchat](https://github.com/antirez/smallchat)，通过该项目可以入门学习网络编程 (Network Programming)，请复现该项目。

Salvatore Sanfilippo 在 YouTube 上对 smallchat 的讲解：

- [Smallchat intro](https://www.youtube.com/watch?v=eT02gzeLmF0)
- [smallchat client & raw line input](https://www.youtube.com/watch?v=yogoUJ2zVYY)

GitHub 上也有使用 Go 和 Rust 实现该项目的仓库，如果你对 Go 或 Rust 的网络编程 (Network Programming) 感兴趣，可以参考这个[仓库](https://github.com/smallnest/smallchat)。
{{< /admonition >}}

### IEEE 802.3 Ethernet

**Outline:**
- Introduction
- Ethernet Topologies
- Ethernet Frame Format
- Ethernet MAC Protocol -- CSMA/CD
- 802.3 Ethernet Standards

**Summary:**
- MAC Protocol -- CSMA/CD
- Connection less, unreliable transmission
- Topology from **Bus** to **Star (switches)**
- Half-duplex transmission in Bus topology
    - Work best under **lightly loaded** conditions
    - Too much collision under **heavy load**
- Full-duplex transmission in Switch topology (point-to-point)
    - No more collisions !!
    - Excellent performance (wired speed)

#### Introduction

{{< image src="/images/network/L2-03.png" caption="Ethernet - 03" >}}

Ethernet 发展过程: 传输速度从 10Mb 发展到 100Gb (P4)
Ethernet 的特点: Unreliable, Connectionless, CSMA/CD (P5)

#### Ethernet Topologies

{{< image src="/images/network/L2-07.png" caption="Ethernet - 07" >}}
{{< image src="/images/network/L2-18.png" caption="Ethernet - 18" >}}

- 10Base5: 10Mbps, segment up to 500m (P8)
- 10Base2: 10Mbps, segment up to 200m (P8)
- 10BaseT: 10Mbps, Twisted pair, segment up to 100m (P16)

* Repeater, Hub 都是 physical layer 的设备，只负责 **转发信号**，无法防止 collision (P12, P16)
* Switch 则是 data-link layer 的设备，内置芯片进行 **数据转发**，可以防止 collision (P19)

**Manchester Encoding** (P11):    
Ethernet 下层的 physical layer 使用的编码方式是 Manchester Encoding: 在一个时钟周期内，信号从低到高表示 1，从高到低表示 0

{{< admonition >}}
Manchester Encoding 发送方在进行数据传输之前需要发送一些 bits 来进行时钟同步 (例如 P22 的 Preamble 部分)，接收方完成时钟同步后，可以对一个时钟周期进行两次采样：一次前半段，一次后半段，然后可以通过两次取样电位信号的变化来获取对应的 bit (低到高表示 1，高到低表示 0)。

有些读者可能会疑惑，既然都进行时钟同步了，为什么不直接使用高电位信号表示 1，低电位信号表示 0 这样直观的编码方式？这是因为如果采取这种编码方式，那么在一个时钟周期内信号不会有变化，如果接收的是一系列的 1 或 0，信号也不会变化。这样可能会导致漏采样，或者编码出错却无法及时侦测。而采用 Manchester Encoding 接收方每个时钟周期内信号都会变化，如果接收方在一次时钟周期内的两次采样，信号没有发生变化，那么可以立即侦测到出错了 (要么是漏采样了，要么是编码出错了)。
{{< /admonition >}}

#### Ethernet Frame Format

{{< image src="/images/network/L2-23.png" caption="Ethernet - 23" >}}

除开 Preamble, SFD 之外，一个 Frame 的大小为 $64 \sim 1518$ bytes。因为 DA, SA, TYPE, FCS 占据了 $6 + 6 + 2 + 4 = 18$ bytes，所以 Data 部分的大小为 $48 ~\sim 1500$ bytes (P43)

MAC Address 是 unique 并且是与 Adaptor 相关的，所以一个主机可能没有 MAC Address (没有 Adaptor)，可能有两个 MAC Address (有两个 Adaptor)。MAC Address 是由 Adaptor 的生产商来决定的。(P24)

unicast address, broadcast address, multicast address (P26)

#### CSMA/CD

{{< image src="/images/network/L2-46.png" caption="Ethernet - 46" >}}
{{< image src="/images/network/L2-41.png" caption="Ethernet - 41" >}}
{{< image src="/images/network/L2-45.png" caption="Ethernet - 45" >}}
{{< image src="/images/network/L2-49.png" caption="Ethernet - 49" >}}

- 关于 CSMA/CD 的详细介绍可以查看 P34 ~ P38
- 关于 Ethernet Frame 的大小限制设计可以查看 P39 ~ P43
- 关于 CSMA/CD Collision Handling 的策略机制可以查看 P44 ~ P45, P47 ~ P48

{{< admonition >}}
Host 在 detect collision 之后进行 backoff random delay，delay 结束后按照 1-persistent protocol (P35) 继续等待到  busy channel goes idle 后立刻进行传输。
{{< /admonition >}}

### IEEE 802.11 Wireless LAN

无线网络这章太难了，战术性放弃

## Stanford CS144

| 开课学校 | 课程主页 | 课程资料 | 课程影片 |
| :-----: | :-----: | :-----: | :-----: |
| Stanford University | [Website](https://vixbob.github.io/cs144-web-page/) | [GitHub](https://github.com/lawliet9712/Stanford-CS144-2021) | [bilibili](https://space.bilibili.com/457173750/channel/collectiondetail?sid=1445483) |

### TCP

- [TCP Operational Overview and the TCP Finite State Machine (FSM)](http://tcpipguide.com/free/t_TCPOperationalOverviewandtheTCPFiniteStateMachineF-2.htm)

{{< image src="http://tcpipguide.com/free/diagrams/tcpfsm.png" caption="TCP FSM" >}}

### Packet Switching

Circuit Switching 相对于 Packet Switching，它对于中间的交换网络的拓扑设计需要更加谨慎，防止某些极端情况下，在建立某条专用路线后，其它通信双方就无法使用该中间交换网络了，同理对于这种交换网络，只需攻击某个核心交换节点，即可瘫痪该交换网络。

Packet Swicthing 上的数据报交换机一般是接收完整个数据报之后，才进行下一跳的转发，当然也可以进行快速传播，只不过一般不启用 (因为在数据报交换机处可能需要做一些校验工作，这需要拥有完整数据报方可进行)

{{< admonition >}}
CS 144 听前 4 单元 (Unit) 就可以了，第二单元 TCP 讲的特别清除，后面就一般般了。关于网络的应用部分可以参考 [Professor Messer](https://www.youtube.com/@professormesser) 的频道

Unit 3 分组交换的队列模型那部分听的不是很明白... 毕竟涉及到排队论 (Queuing Theory)

Unit 4 拥塞控制，讲的也比较一般，参考清大或中科大相关的教学录影会比较好...
{{< /admonition >}}

## USTC 计算机网络: 自顶向下

| 开课学校 | 课程主页 | 课程资料 | 课程影片 |
| :-----: | :-----: | :-----: | :-----: |
| 中国科学技术大学 | 无 | [课件](https://pan.baidu.com/s/1EElOrkkY4WQqgeKHuGm-bg) (密码: 1958) | [bilibili](https://www.bilibili.com/video/BV1JV411t7ow) | 

CS 144 的 **拥塞控制** 讲的不是很好，科大讲的相对比较好

## CompTIA Network+

- Professor Messer: [CompTIA Network+ N10-006 Training Course](https://www.youtube.com/playlist?list=PLG49S3nxzAnnXcPUJbwikr2xAcmKljbnQ)

## CompTIA Network+

## Referenecs

- [小菜学网络](https://fasionchan.com/network/)
- [NUDT 高级计算机网络实验: 基于UDP的可靠传输](https://luzhixing12345.github.io/netlab/)
- [可靠 UDP 的实现 (KCP over UDP)](https://sunyunqiang.com/blog/reliable_udp_protocol/) 
- [基于 UDP 的可靠传输](https://www.bilibili.com/video/BV1di4y1z7Mn) [bilibili]
- [实现基于 UDP 的网络文件传输器](https://www.bilibili.com/video/BV12P411T78X) [bilibili]
- [ping 命令也可以用来通信](https://www.bilibili.com/video/BV1Wd4y1b7b4) [bilibili]
- [Implementing TCP in Rust](https://www.youtube.com/playlist?list=PLqbS7AVVErFivDY3iKAQk3_VAm8SXwt1X) [YouTube]
- [Let\'s code a TCP/IP stack](http://www.saminiir.com/lets-code-tcp-ip-stack-1-ethernet-arp/)


[courseinfo]: https://ocw.nthu.edu.tw/ocw/index.php?page=course&cid=291&
[slides&hws]: https://ocw.nthu.edu.tw/ocw/index.php?page=course_news_content&cid=291&id=1015
[playlist]: https://www.youtube.com/playlist?list=PLS0SUwlYe8cxktXNovos9xleroaWyb-z5
