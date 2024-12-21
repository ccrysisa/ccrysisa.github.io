---
title: "Linux 核心的 hash table 实作"
subtitle:
date: 2024-03-16T10:59:36+08:00
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
  - Linux
  - Kernel
  - Hash Table
categories:
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

> Linux 核心如同其它复杂的资讯系统，也提供 [hash table](https://en.wikipedia.org/wiki/Hash_table) 的实作，但其原始程式码中却藏有间接指针 (可参见 [你所不知道的 C 语言: linked list 和非连续内存](https://hackmd.io/@sysprog/c-linked-list)) 的巧妙和数学奥秘。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/linux-hashtable" content="原文地址" external-icon=true >}}

## 间接指针

Linux 核心的 hashtable 结构示意图：

{{< image  src="https://liujunming.top/images/2018/11/4.png" >}}

不难看出，`pprev` 是指向上一个节点 `next` 的指针，即是指向 `hlist_node *` 的指针，而不是指向上一个节点 (`hlist_node`) 的指针，因为 hashtable 的数组中存放的是 `hlist_node *`，所以这样也简化了表示方法，将拉链和数组元素相互联系了起来。需要使用间接指针来实现 doubly linked 本质上是因为：**拉链节点和数组节点在表示和操作上的不等价**。

当然也可以将数组元素和拉链元素都统一为带有两个指针 `prev` 和 `next` 的 doubly linked list node，这样解决了之前所提的不等价，可以消除特判，但这样会导致存取数组元素时内存开销增大，进而降低 cache 的利用率。

{{< admonition info >}}
- [List, HList, and Hash Table](https://danielmaker.github.io/blog/linux/list_hlist_hashtable.html)
- [内核基础设施——hlist_head/hlist_node 结构解析](https://linux.laoqinren.net/kernel/hlist/)
- [hlist数据结构图示说明](https://zhuanlan.zhihu.com/p/82375193)
{{< /admonition >}}

## hash 函数

Wikipedia: [Hash function](https://en.wikipedia.org/wiki/Hash_function)
> A hash function is any function that can be used to map data of arbitrary size to fixed-size values, though there are some hash functions that support variable length output.

### 常见 hash 策略

- Division method
$$
h(k) = k % N
$$

- Mid-square
$$
h(k) = bits_{i,i+r-1}(k^2)
$$

- Folding addition
{{< raw >}}
$$
key = 3823749374 \\
382\ |\ 374\ |\ 937\ |\ 4 \\
index = 382 + 374 + 937 + 4 = 1697 \\
$$
{{< /raw >}}
> 先将 key 切成片段后再相加，也可以对相加后的结果做其他运算

- Multiplication Method

{{< image src="https://raw.githubusercontent.com/alrightchiu/SecondRound/master/content/Algorithms%20and%20Data%20Structures/HashTable%20series/Intro/f8.png" >}}

## Linux 核心的 hash 函数

Linux 核心的 [hash.h](https://github.com/torvalds/linux/blob/master/tools/include/linux/hash.h) 使用的是 Multiplication Method 策略，但是是通过整数和位运算实现的，没有使用到浮点数。

{{< raw >}}
$$
\begin{split}
  h(K) &= \lfloor m \cdot (KA - \lfloor KA \rfloor) \rfloor \\
  h(K) &= K \cdot 2^w \cdot A >> (w - p)
\end{split}
$$
{{< /raw >}}

- $K$: key value
- $A$: a constant, 且 $0 < A < 1$
- $m$: bucket 数量，且 $m = 2^p$
- $w$: 一个 word 有几个 bit

上面两条式子的等价关键在于，使用 **二进制编码** 表示的整数和小数配合进行推导，进而只使用整数来实现，具体推导见原文。

$(\sqrt{5} - 1 ) / 2 = 0.618033989$   
$2654435761 / 4294967296 = 0.618033987$   
$2^{32} = 4294967296$

因此 `val * GOLDEN_RATIO_32 >> (32 - bits)` $\equiv K \times A \times 2^w \>\> (w - p)$，其中 `GOLDEN_RATIO_32` 等于 $2654435761$

Linux 核心的 64 bit 的 hash 函数:

```c
#ifndef HAVE_ARCH_HASH_64
#define hash_64 hash_64_generic
#endif
static __always_inline u32 hash_64_generic(u64 val, unsigned int bits)
{
#if BITS_PER_LONG == 64
	/* 64x64-bit multiply is efficient on all 64-bit processors */
	return val * GOLDEN_RATIO_64 >> (64 - bits);
#else
	/* Hash 64 bits using only 32x32-bit multiply. */
	return hash_32((u32)val ^ __hash_32(val >> 32), bits);
#endif
}
```

Linux 核心采用 [golden ratio](https://en.wikipedia.org/wiki/Golden_ratio) 作为 $A$，这是因为这样碰撞较少，且分布均匀:

{{< image src="https://hackmd.io/_uploads/H15TYpxRi.png" >}}
