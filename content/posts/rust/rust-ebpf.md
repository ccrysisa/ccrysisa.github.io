---
title: "Rust: 透过 eBPF 探测操作系统行为"
subtitle:
date: 2024-06-10T23:38:10+08:00
# draft: true
# author:
#   name:
#   link:
#   email:
  # avatar:
description:
keywords:
license:
comment: false
weight: 0
tags:
  - Rust
  - Sysprog
  - eBPF
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

> Programming the Linux Kernel for Enhanced Observability, Networking, and Security

<!--more-->

## 实验环境

```bash {title=Deepin}
$ neofetch --stdout
cai@cai-PC 
---------- 
OS: Deepin 20.9 x86_64 
Host: RedmiBook 14 II 
Kernel: 5.15.77-amd64-desktop 
Uptime: 1 hour, 55 mins 
Packages: 2145 (dpkg) 
Shell: bash 5.0.3 
Resolution: 1920x1080 
DE: Deepin 
WM: KWin 
Theme: deepin-dark [GTK2/3] 
Icons: bloom-classic-dark [GTK2/3] 
Terminal: deepin-terminal 
CPU: Intel i7-1065G7 (8) @ 3.900GHz 
GPU: NVIDIA GeForce MX350 
GPU: Intel Iris Plus Graphics G7 
Memory: 11361MiB / 15800MiB 
```

去 bpftrace 的 [Github Releases]() 页面，下载相应版本的 bpftrace，这里以 0.20.4 为例:

```bash {title=Deepin}
$ curl --location-trusted -O https://github.com/bpftrace/bpftrace/releases/download/v0.20.4/bpftrace
$ chmod a+x bpftrace
$ ./bpftrace -V
bpftrace v0.20.4
# add path to bpftrace to ~/.bashrc
$ bpftrace -V
bpftrace v0.20.4
```

安装内核对应 bpftool 组件 (这个组件连接内核中的 eBPF 模块和外部的 bpf 工具，例如 bpftrace):

```bash {title=Deepin}
$ sudo apt install -y bpftool
$ bpftool version
bpftool v5.15.5
```

{{< admonition >}}
因为 eBPF 程序是在内核中执行的，所以下面的实例代码、命令都需要提升权级，在 root 模式下执行。
{{< /admonition >}}

{{< admonition warning >}}
由于 deepin 20.9 的内核版本过低 (仅为 5.15)，对 eBPF 的支持并未完善 (使用 `-l` 参数输出的可用探测点比较少)，所以后期会使用 openSUSE Tumbleweed 重做本实验。
{{< /admonition >}}

## 实作案例: 通过 bpftrace 抓取 HTTPS 流量

{{< admonition info >}}
- [讲解视频](https://www.bilibili.com/video/BV1794y1L7as/) / [讲义](http://timd.cn/bpftrace-demo/)
- [Learning eBPF](https://cilium.isovalent.com/hubfs/Learning-eBPF%20-%20Full%20book.pdf) Chapter 10: eBPF Programming
{{< /admonition >}}

> The bpftrace command-line tool converts programs written in this high-level lan‐
guage into eBPF kernel code and provides some output formatting for the results
within the terminal.

bpftrace 可以将我们编写的高级程序语言转换成对应的 BPF 字节码，用于后续给内核中的 BPF 虚拟机执行

```bash
bpftrace -e 'kprobe:do_execve { @[comm] = count(); }'
Attaching 1 probe...
^C

@[node]: 6
@[sh]: 6
@[cpuUsage.sh]: 18
```

其中 `{ @[comm] = count(); }` 表示同=统计每个命令触发 `do_execve` 这个探针点的次数，`comm` 表示 command，而 `count()` 顾名思义就是统计次数，所以通过 `Ctrl-C` 中断该 BPF 脚本执行后，输出的是各个命令触发 `do_execve` 这个探针点的次数。

- bpftrace(8) Manual Page: [Variables and Maps](https://github.com/bpftrace/bpftrace/blob/master/man/adoc/bpftrace.adoc#variables-and-maps)

> bpftrace knows two types of variables, 'scratch' and 'map'.
> 
> 'map' variables use BPF 'maps'. These exist for the lifetime of bpftrace itself and can be accessed from all action blocks and user-space. Map names always start with a @, e.g. @mymap.

{{< admonition >}}
实际上形如 `@[]` 这类的代码其实是 eBPF 中的一个重要数据结构 `map`，即键值对，它常被用于在不同的 eBPF 程序之间进行数据的传递。
{{< /admonition >}}

> Scripts for bpftrace can coordinate multiple eBPF programs attached to different
events.

```c
tracepoint:syscalls:sys_enter_open,
tracepoint:syscalls:sys_enter_openat
{
	@filename[tid] = args.filename;
}

tracepoint:syscalls:sys_exit_open,
tracepoint:syscalls:sys_exit_openat
/@filename[tid]/
{
	$ret = args.ret;
	$fd = $ret >= 0 ? $ret : -1;
	$errno = $ret >= 0 ? 0 : - $ret;

	printf("%-6d %-16s %4d %3d %s\n", pid, comm, $fd, $errno,
	    str(@filename[tid]));
	delete(@filename[tid]);
}
```

`@filename` 如前面所说，表示一个 `map`，而第 9 行的 `/@filename[tid]/` 则表示，当 `filename` 这个 `map` 中键 `tid` 对应的值存在时才执行这一部分逻辑。

- bpftrace(8) Manual Page: [Filtering](https://github.com/bpftrace/bpftrace/blob/master/man/adoc/bpftrace.adoc#filtering)
> Filters (also known as predicates) can be added after probe names. The probe still fires, but it will skip the action unless the filter is true.

```c
#ifndef BPFTRACE_HAVE_BTF
#include <net/tcp_states.h>
#include <net/sock.h>
#include <linux/socket.h>
#include <linux/tcp.h>
#else
#include <sys/socket.h>
#endif

uprobe:/usr/local/lib/libssl.so:SSL_write
{
    @write_buf[tid] = arg1;
}

uretprobe:/usr/local/lib/libssl.so:SSL_write
/@write_buf[tid]/
{
    $buf = @write_buf[tid];
  $len = (int32)retval;
    if ($len <= 0) {
        return;
    }
    @write_sock[tid] = true;

  $i = 0;
  $consumed = 0;
  printf("write[%d] starting\n", $len);
  while ($i <= 500) {
    $i += 1;
    if ($len - $consumed > 64) {
      printf("%r\n", buf($buf, 64));
      $buf += (uint64)64;
      $consumed += 64;
    } else {
      $remaining = $len - $consumed;
      printf("%r\n", buf($buf, $remaining));
      $buf += (uint64)$remaining;
      $consumed = $len;
      break;
    }
  }
  printf("write[%d] ending\n", $len);
    delete(@write_buf[tid]);
}

kprobe:tcp_sendmsg
/@write_sock[tid]/
{
    $sk = (struct sock *)arg0;
    $lport = $sk->__sk_common.skc_num;
    $dport = $sk->__sk_common.skc_dport;
    $dport = bswap($dport);
    $saddr = ntop(0);
    $daddr = ntop(0);
    $family = $sk->__sk_common.skc_family;
    if ($family == AF_INET) {
        $saddr = ntop(AF_INET, $sk->__sk_common.skc_rcv_saddr);
        $daddr = ntop(AF_INET, $sk->__sk_common.skc_daddr);
    } else {
        // AF_INET6
        $saddr = ntop(AF_INET6,
            $sk->__sk_common.skc_v6_rcv_saddr.in6_u.u6_addr8);
        $daddr = ntop(AF_INET6,
            $sk->__sk_common.skc_v6_daddr.in6_u.u6_addr8);
    }
    printf("send: %-15s %-5d %-15s %-6d\n", $saddr, $lport, $daddr, $dport);
    delete(@write_sock[tid]);
}

uprobe:/usr/local/lib/libssl.so:SSL_read
{
  @read_buf[tid] = arg1;
}

uretprobe:/usr/local/lib/libssl.so:SSL_read
/@read_buf[tid]/
{
  $buf = @read_buf[tid];
  $len = (int32)retval;
  if ($len <= 0) {
    return;
  }
    @read_sock[tid] = true;

  $i = 0;
  $consumed = 0;
  printf("read[%d] starting\n", $len);
  while ($i <= 500) {
    $i += 1;
    if ($len - $consumed > 64) {
      printf("%r\n", buf($buf, 64));
      $buf += (uint64)64;
      $consumed += 64;
    } else {
      $remaining = $len - $consumed;
      printf("%r\n", buf($buf, $remaining));
      $buf += (uint64)$remaining;
      $consumed = $len;
      break;
    }
  }
  printf("read[%d] ending\n", $len);
  delete(@read_buf[tid]);
}

kprobe:tcp_recvmsg
/@read_sock[tid]/
{
    $sk = (struct sock *)arg0;
    $lport = $sk->__sk_common.skc_num;
    $dport = $sk->__sk_common.skc_dport;
    $dport = bswap($dport);
    $saddr = ntop(0);
    $daddr = ntop(0);
    $family = $sk->__sk_common.skc_family;
    if ($family == AF_INET) {
        $saddr = ntop(AF_INET, $sk->__sk_common.skc_rcv_saddr);
        $daddr = ntop(AF_INET, $sk->__sk_common.skc_daddr);
    } else {
        // AF_INET6
        $saddr = ntop(AF_INET6,
            $sk->__sk_common.skc_v6_rcv_saddr.in6_u.u6_addr8);
        $daddr = ntop(AF_INET6,
            $sk->__sk_common.skc_v6_daddr.in6_u.u6_addr8);
    }
    printf("recv: %-15s %-5d %-15s %-6d\n", $saddr, $lport, $daddr, $dport);
    delete(@read_sock[tid]);
}
```

程序讲解 TODO

- OpenSSL: [SSL_read](https://www.openssl.org/docs/man1.1.1/man3/SSL_read.html)
- OpenSSL: [SSL_write](https://www.openssl.org/docs/man1.0.2/man3/SSL_write.html)
- Linux manual page: [sendmsg](https://man7.org/linux/man-pages/man3/sendmsg.3p.html)
- Linux manual page: [recvmsg](https://man7.org/linux/man-pages/man3/recvmsg.3p.html)

## Improving the eBPF Developer Experience with Rust

- Dave Tucker/Alessandro Decina: [直播录影](https://www.youtube.com/watch?v=yCf6AYpA8u0) / [投影片](https://lpc.events/event/11/contributions/936/attachments/812/1530/Improving%20the%20eBPF%20Developer%20experience%20with%20Rust%20(1).pdf)

## References

- [bpftrace](https://github.com/bpftrace/bpftrace)
