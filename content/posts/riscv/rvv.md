---
title: "RVV: RISC-V Vector Extension"
subtitle:
date: 2024-08-17T18:44:33+08:00
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

## Introduction

重要概念: 

- VLEN: size of vector registers
- VL (vector length)
- SEW (Selected Element Width)
- LMUL: group multiplier

相关公式:

VLMAX = LMUL * VLEN / SEW

> **LMUL * VLEN** 表示该 vector 的比特数，而 **SEW** 表示该 vector 的每个 element 的比特数

{{< image src="https://substackcdn.com/image/fetch/f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fb664a2e5-26e2-4107-9675-e24f569493cb_591x358.jpeg" >}}

## Arithmetic

{{< image src="https://substackcdn.com/image/fetch/f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Ff3cb932c-e046-4ca6-9489-4a5c0061733e_481x372.jpeg" >}}

> vstart specifies the first active vector element, vl specifies the number of element(s) in the LMUL-wide vector group affected by the operation and SEW specifies what is the actual format of the operands.

RVV 1.0 specifies standard integer operations:

- add, sub
- min/max
- zero and sign extensions
- widening add/sub
- add with carry / sub with borrow

## Mask

RVV 1.0 中只有 v0 可以作为 mask register

## Permute

## References

- [riscv-v-spec](https://github.com/riscv/riscv-v-spec/tree/v1.0)
- [RISC-V Vector in a Nutshell](https://fprox.substack.com/p/risc-v-vector-in-a-nutshell)
- [Tutorial: RISC-V Vector Extension Demystified - 2020 RISC-V Summit](https://www.youtube.com/watch?v=oTaOd8qr53U)
- [RISC-V Vector 向量编程](https://www.bilibili.com/video/BV1VT411E7iQ/)
