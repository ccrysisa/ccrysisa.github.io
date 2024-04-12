---
title: "Linux 核心的红黑树"
subtitle:
date: 2024-04-12T19:00:59+08:00
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
  - Red Black Tree
categories:
  - Linux
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

> Linux 核心原始程式碼中，許多地方出現紅黑樹的蹤影，例如：hr_timer 使用紅黑樹來記錄計時器 (timer) 端發出的要求、ext3 檔案系統使用紅黑樹來追蹤目錄內容變更，以及 CFS (Completely Fair Scheduler) 這個 Linux 預設 CPU 排程器，由於需要頻繁地插入跟移除節點 (任務)，因此開發者選擇用紅黑樹 (搭配一些效能調整)。VMA（Virtual Memory Area）也用紅黑樹來紀錄追蹤頁面 (page) 變更，因為後者不免存在頻繁的讀取 VMA 結構，如 page fault 和 mmap 等操作，且當大量的已映射 (mapped) 區域時存在時，若要尋找某個特定的虛擬記憶體地址，鏈結串列 (linked list) 的走訪成本過高，因此需要一種資料結構以提供更有效率的尋找，於是紅黑樹就可勝任。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/linux-rbtree" content="原文地址" external-icon=true >}}

## 简述红黑树

Left-Leaning Red-Black Trees:
- [论文](https://sedgewick.io/wp-content/themes/sedgewick/papers/2008LLRB.pdf) by Robert Sedgewick
- [投影片](https://sedgewick.io/wp-content/uploads/2022/03/2008-09LLRB.pdf) by Robert Sedgewick

解说录影:
- [x] [Left Leaning Red Black Trees (Part 1)](https://www.youtube.com/watch?v=0BeIo4JB0Z4)
- [x] [Left Leaning Red Black Trees (Part 2)](https://www.youtube.com/watch?v=4xIIbMFkBW4)

2-3-4 tree:

> Problem: Doesn’t work if parent is a 4-node

为解决该问题，投影片主要说明的是 **Split 4-nodes on the way down** 方法，这个方法的逻辑是：在插入节点前向下走访的过程中，如果发现某个节点是 4-nodes 则对该节点进行 split 操作，具体例子可以参考投影片的 P24 ~ P25。

LLRB tree:

> Problem: Doesn’t work if parent is a 4-node

为解决该问题，投影片主要说明的也是 **Split 4-nodes on the way down** 方法，其逻辑和之前相同，除此之外，在插入节点后向上返回的过程中，进行 rotate 操作，保证了 LLRB 节点的结构满足要求 (即红边的位置)。

{{< admonition tip >}}
在拆分 4-node 时 3-node 和 4-node 的孩子节点的大小关系不太直观，这时可以参考解说录影的老师的方法，使用数字或字母标识节点，进而可以直观看出 4-node 转换前后的等价性。

如果我们将 4-node 节点的拆分放在插入节点后向上返回的过程进行处理，则会将原本的树结构转换成 2-3 tree，因为这样插入节点后，不会保留有 4-node (插入产生的 4-node 立刻被拆分)。
{{< /admonition >}}

{{< admonition >}}
红黑树的 perfect-balance 的特性在于：它随着节点的增多而逐渐将 4-nodes (因为新增节点都是 red 边，所以叶节点很大概率在插入结束后会是 4-node) 从根节点方向移动 (on the way down 时 split 4-nodes 的效果)，当 4-node 移动到根节点时，进行颜色反转并不会破坏树的平衡，只是树高加 1 (这很好理解，因为根节点是唯一的，只要保证 4-node 的根节点拆分操作保持平衡即可，显然成立)。
{{< /admonition >}}

## Maple tree

解说录影: [The Linux Maple Tree - Matthew Wilcox, Oracle](https://www.youtube.com/watch?v=XwukyRAL7WQ)
