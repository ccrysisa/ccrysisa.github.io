---
title: "你所不知道的 C 语言: goto 和流程控制篇"
subtitle:
date: 2024-04-05T11:39:34+08:00
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
  - Sysprog
  - C
categories:
  - C
  - Linux Kernel Internals
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

> goto 在 C 語言被某些人看做是妖魔般的存在，不過實在不用這樣看待，至少在 Linux 核心原始程式碼中，goto 是大量存在 (跟你想像中不同吧)。有時不用 goto 會寫出更可怕的程式碼

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-control-flow" content="原文地址" external-icon=true >}}

Stack Overflow: [GOTO still considered harmful?](https://stackoverflow.com/questions/46586/goto-still-considered-harmful)

## MISRA C

[MISRA-C:2004](https://caxapa.ru/thumbs/468328/misra-c-2004.pdf) Guidelines for the use of the C language in critical systems

MISRA C 禁用 `goto` 和 `continue`，但可用 `break`:

- **Rule 14.4 (required): The goto statement shall not be used.**
- **Rule 14.5 (required): The continue statement shall not be used.**
- **Rule 14.6 (required): For any iteration statement there shall be at most one break statement used for loop termination.**

> These rules are in the interests of good structured programming. One break statement is allowed in a loop since this allows, for example, for dual outcome loops or for optimal coding.

Stack Overflow 上的相关讨论:

- [Why "continue" is considered as a C violation in MISRA C:2004?](https://stackoverflow.com/questions/10975722/why-continue-is-considered-as-a-c-violation-in-misra-c2004)

使用 goto 可能会混淆静态分析的工具 (当然使用 goto 会极大可能写出 ugly 的程式码):

> Case in point: MISRA C forbids goto statements primarily because it can mess up static analysis. Yet this rule is gratuitously followed even when no static analysis tools are used, thus yielding none of the gains that you trade off for occasionally writing ugly code.

## GOTO 没有想象中那么可怕

虽然 MISRA C 这类规范都明确禁止了使用 goto，但 goto 并没有想像中的那么可怕，在一些领域还是极具活力的。

在 C 语言中 goto 语句是实作错误处理的极佳选择 (如果你看过 xv6 应该不陌生):

- [ ] [Using goto for error handling in C](http://eli.thegreenplace.net/2009/04/27/using-goto-for-error-handling-in-c)

相关实作:

- [goto 在 Linux 核心广泛应用](https://github.com/torvalds/linux/search?utf8=%E2%9C%93&q=goto)
- [OpenBSD's httpd](https://github.com/reyk/httpd/blob/master/httpd/httpd.c#L564)
- Linux kernel 里 NFS inode 验证的函数: [fs/nfs/inode.c](https://github.com/torvalds/linux/blob/v5.15/fs/nfs/inode.c)

Wikipedia: [Common usage patterns of Goto](https://en.wikipedia.org/wiki/Goto#Common_usage_patterns)

## switch & goto

- [Computed goto for efficient dispatch tables](https://eli.thegreenplace.net/2012/07/12/computed-goto-for-efficient-dispatch-tables)

## do {...} while (0) 宏

我写了 [相关笔记]({{< relref "./c-preprocessor/#do----while-0-%E5%AE%8F" >}}) 在前置处理器篇。
