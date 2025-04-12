---
title: "Build a LLM Tokenizer in C"
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
  - BPE
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

BPE 与霍夫曼编码 (Huffman coding) 类似，都是压缩算法。注意 BPE 最终的压缩结果隐式的规定了一种语法  (grammer)，在进行 BPE 解压缩时思考一下 [BNF](https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form) 即可理解为何有隐式的语法。但 BNF 是用于分析程序的语义，但 BPE 是采用语法来压缩和解压缩文本。

### Underflow

使用 `int` 作为下标遍历可以防止 underflow，思考如果将下面程序片段中的 `int` 改为 `size_t`，当 `count` 为 0 时会发生什么？

```c
for (int i = 0; i < count - 1; i++) {
    // do something...
}
```

cppreference: [ptrdiff_t](https://en.cppreference.com/w/c/types/ptrdiff_t)

> ptrdiff_t is the signed integer type of the result of subtracting two pointers.

### stb

[stb](https://github.com/nothings/stb) 的 hash map 等数据结构的实现原理与 C 语言标准库的 `malloc` 类似，即在分配的地址处的前放存放 metadata 用于管理所分配的内存:

```
[ metadata ][][][][]..[]
            ^
            ptr
```

由于 stb 使用了 `typeof` 这个 gcc 的扩展，所以需要指定编译时期的 C 语言标准为 GNU:

- Stack Overflow: [What is the default C -std standard version for the current GCC (especially on Ubuntu)?](https://stackoverflow.com/questions/14737104/what-is-the-default-c-std-standard-version-for-the-current-gcc-especially-on-u)

### man

man 3 qsort:

> The contents of the array are sorted in ascending order according to a comparison function pointed
> to by compar, which is called with two arguments that point to the objects being compared.
> 
> The  comparison  function  must return an integer less than, equal to, or greater than zero if the
> first argument is considered to be respectively less than, equal to, or greater than  the  second.
> If two members compare as equal, their order in the sorted array is undefined.

### Memory leak

Memory leak 检测并非你所想象的那般好用，因为有时候会误报，例如 memory leak 检测会认为某一些内存区域是 unreachable 的，但实际上那块区域是 reachable 的，典型如 [XOR linked list](https://en.wikipedia.org/wiki/XOR_linked_list) (hacker 是 memory leak 检测的一生之敌 XD)。

> An XOR linked list compresses the same information into one address field by storing the bitwise XOR (here denoted by ⊕) of the address for previous and the address for next in one field.

### BNF and BPE

借鉴 BNF，设定所有 ASCII 码均为无法展开的最小单元，即语法树的叶子节点，而超出 ASCII 码范围的整数视为可以展开为 byte pair 模式，即语法树的中层节点，图示如下:

```
index      content
-----------------------
 0  => { .l=0,  .r=...} // patern means char with value 0
 1  => { .l=1,  .r=...} // patern means char with value 1
...
61  => { .l=61, .r=...} // patern means char with value 61
62  => { .l=62, .r=...} // patern means char with value 62
...
255 => { .l=0,  .r=...} // patern means char with value 255
256 => { .l=61, .r=62 } // pattern with 2 pattern 61 and 70
...
```

某一个模式 (pattern) 在表中所对应的下标 (index) 与其 `l` 字段数值相同，则表示该模式不可分解，是语法树的叶子节点，而该模式的 `r` 字段并不重要，可忽略该字段的数值。

### Graphviz

使用 Graphviz 对 BPE 算法在压缩过程中隐式产生的规则 (Rule) 生成有向图。

## References

- Tsoding: [LLM Tokenizer in C (BPE)](https://www.youtube.com/playlist?list=PLpM-Dvs8t0VaIVKmfGBztiqaIyMHIH-3Y)
- Wikipedia: [Byte pair encoding (BPE)](https://en.wikipedia.org/wiki/Byte_pair_encoding)
- Wikipedia: [Backus–Naur form (BNF)](https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form)
- GitHub: [stb](https://github.com/nothings/stb)
- [Graphviz](https://graphviz.org/)
