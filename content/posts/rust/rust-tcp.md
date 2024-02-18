---
title: Implementing TCP/IP in Rust
subtitle:
date: 2024-02-17T19:01:53+08:00
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
  - Rust
  - TCP
  - Network
categories:
  - Rust
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

> In this stream, we started implementing the ubiquitous TCP protocol that underlies much of the traffic on the internet! In particular, we followed RFC 793 — https://tools.ietf.org/html/rfc793 — which describes the original protocol, with the goal of being able to set up and tear down a connection with a "real" TCP stack at the other end (netcat in particular). We're writing it using a user-space networking interface (see https://www.kernel.org/doc/Documentation/networking/tuntap.txt and the Rust bindings at https://docs.rs/tun-tap/).

<!--more-->

整理自 John Gjengset 的影片:

- [Part 1](https://www.youtube.com/watch?v=bzja9fQWzdA)

## 影片注解 Part 1

### Raw socket vs TUN/TAP device

- [Raw sockets](https://en.wikipedia.org/wiki/Network_socket#Raw_sockets#Types) [Wikipedia]
- [TUN/TAP](https://en.wikipedia.org/wiki/TUN/TAP) [Wikipedia]
- [Raw socket vs TUN device](https://stackoverflow.com/questions/41343802/raw-socket-vs-tun-device) [Stack Overflow]
- [Universal TUN/TAP device driver](https://www.kernel.org/doc/Documentation/networking/tuntap.txt) [Linux kernel documentation]

{{< image src="https://upload.wikimedia.org/wikipedia/commons/a/af/Tun-tap-osilayers-diagram.png" >}}

Raw socket: 
- Internet --> NIC --> kernel --> user space
- Internet <-- NIC <-- kernel <-- user space
> Host interact with other hosts in Internet.

TUN/TAP device: 
- kernel --> | TUN/TAP | --> user space
- kernel <-- | TUN/TAP | <-- user space
> Kernel interact with programs in user space in the same host.

Universal TUN/TAP device driver [Linux kernel documentation]

```
3.2 Frame format:   
If flag IFF_NO_PI is not set each frame format is:   
    Flags [2 bytes]   
    Proto [2 bytes]   
    Raw protocol(IP, IPv6, etc) frame.   
```

通过 TUN/TAP 设备接收的封包，会拥有 Flags 和 Proto 这两个字段 (共 4 个字节，这也是 iface 的 `without_packet_info` 和 `recv` 方法所描述的 prepended packet info)，然后才是原始协议的 frame。其中的 Proto 字段是 [EtherType](https://en.wikipedia.org/wiki/EtherType)。

### setcap

- [setcap](https://man7.org/linux/man-pages/man8/setcap.8.html) [Linux manual page]
- [cap_from_text](https://man7.org/linux/man-pages/man3/cap_from_text.3.html) [Linux manual page]

因为 TUN/TAP 是由 kernel 提供的，所以需要赋予我们项目的可执行文件权限，使它能访问我们创建的 TUN/TAP 设备 (为了简单起见，下面只列出 release 版本的方法，debug 版本的方法类似)。

```bash
# 编译
$ cargo build --release
# 设置文件权限
$ sudo setcap cap_net_admin=eip target/release/trust
# 运行
$ cargo run --release
```

在另一终端输入命令 `ip addr` 就可以看到此时会多出一个名为 `tun0` 的设备，这正是我们创建的 TUN 设备。

- [ip-address](https://man7.org/linux/man-pages/man8/ip-address.8.html) [Linux manual page]
- [ip-link](https://man7.org/linux/man-pages/man8/ip-link.8.html) [Linux manual page]

在另一个终端中输入:

```bash
# 列出当前所有的网络设备
$ ip addr
# 配置设备 tun0 的 IP 地址
$ sudo ip addr add 192.168.0.1/24 dev tun0
# 启动设备 tun0
$ sudo ip link set up dev tun0
```

每次编译后都需要执行一遍这个流程 (因为重新编译生成的可执行文件需要重新设置权限)，我们将这些流程的逻辑写成一个脚本 [run.sh]()。这个脚本为了输出的美观性增加了额外逻辑，例如将 trust 放在后台执行，将脚本设置为等待 trust 执行完成后才结束执行。

### IP

因为 TUN 只是在 Network layer 的虚拟设备 (TAP 则是 Data link layer 层)，所以需要手动解析 IP 封包。

- [RFC 791](https://datatracker.ietf.org/doc/html/rfc791) 3.1. Internet Header Format

ping 命令使用的是 Network layer 上的 ICMP 协议，可以用于测试 TUN 是否成功配置并能接收封包。

```bash
$ ping -I tun0 192.168.0.2
```

- [ping (networking utility)](https://en.wikipedia.org/wiki/Ping_(networking_utility)) [Wikipedia]
- [ping](https://linux.die.net/man/8/ping) [Linux man page]

可以使用 tshark (Terminal Wireshark) 工具来抓包，配合 ping 命令可以分析 tun0 的封包传送。

```bash
$ sudo apt install tshark
$ sudo tshark -i tun0
```

- [Wireshark](https://en.wikipedia.org/wiki/Wireshark) [Wikipedia]
- [tshark](https://www.wireshark.org/docs/man-pages/tshark.html) [Manual Page]

### Endianness

- [Endianness](https://en.wikipedia.org/wiki/Endianness) [Wikipedia]
- [Why is network-byte-order defined to be big-endian?](https://stackoverflow.com/questions/13514614/why-is-network-byte-order-defined-to-be-big-endian) [Stack Overflow]

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

- Module [std::io](https://doc.rust-lang.org/std/io/index.html)
  - Type Alias [std::io::Result](https://doc.rust-lang.org/std/io/type.Result.html)

- Macro [std::eprintln](https://doc.rust-lang.org/std/macro.eprintln.html)

- method [std::result::Result::expect](https://doc.rust-lang.org/std/result/enum.Result.html#method.expect)

- method [u16::from_be_bytes](https://doc.rust-lang.org/std/primitive.u16.html#method.from_be_bytes)

### Crate [tun_tap](https://docs.rs/tun-tap/latest/tun_tap/)

- Enum [tun_tap::Mode](https://docs.rs/tun-tap/latest/tun_tap/enum.Mode.html)

## References

- https://datatracker.ietf.org/doc/html/rfc793
- https://datatracker.ietf.org/doc/html/rfc1122
- https://datatracker.ietf.org/doc/html/rfc7414#section-2
- https://datatracker.ietf.org/doc/html/rfc2398 
- https://datatracker.ietf.org/doc/html/rfc2525
- https://datatracker.ietf.org/doc/html/rfc791

{{< admonition >}}
- RFC 793 描述了原始的 TCP 协议的内容 
- RFC 1122 则是对原始的 TCP 功能的一些扩展进行说明
- RFC 7414 的 Section 2 则对 TCP 的核心功能进行了简要描述
- RFC 2398 描述了对实现的 TCP 的一些测试方法和工具
- RFC 2525 说明了在实现 TCP 过程中可能会出现的错误，并指出可能导致错误的潜在问题
- RFC 791 描述了 IP 协议
{{< /admonition >}}

