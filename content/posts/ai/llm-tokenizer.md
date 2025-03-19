---
title: "LLM Tokenizer"
subtitle:
date: 2025-03-19T11:04:23+08:00
slug: 4570c47
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
  - LLM
categories:
  - LLM
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

## LLM tokenier in C

对于大模型 (LLM) 来说，由于语料库极其庞大，所以如果使用通常的编译器 tokenizer 那样的逐个字符 (char) 或逐个单词 (word) 作为 token 的方法，会消耗大量的资源，从而诞生了 BPE 这种面向大模型语料库压缩语料的算法。

> Byte pair encoding[1][2] (also known as BPE, or digram coding)[3] is an algorithm, first described in 1994 by Philip Gage, for encoding strings of text into smaller strings by creating and using a translation table.[4] A slightly-modified version of the algorithm is used in large language model tokenizers.

BPE 与霍夫曼编码 (Huffman coding) 类似，都是压缩算法。注意 BPE 最终的压缩结果隐式的规定了一种语法  (grammer)，在进行 BPE 解压缩时思考一下 [BNF](https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form) 即可理解为何有隐式的语法。

## References

- Tsoding: [LLM Tokenizer in C (BPE)](https://www.youtube.com/playlist?list=PLpM-Dvs8t0VaIVKmfGBztiqaIyMHIH-3Y)
- Wikipedia: [Backus–Naur form (BNF)](https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form)
- Wikipedia: [Byte pair encoding (BPE)](https://en.wikipedia.org/wiki/Byte_pair_encoding)
