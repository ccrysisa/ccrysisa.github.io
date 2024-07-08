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

## 开篇点题

相关讨论: [Red-black tree over AVL tree](https://stackoverflow.com/questions/13852870/red-black-tree-over-avl-tree)

效能表现的差异，参考 [Performance Analysis of BSTs in System Software](https://benpfaff.org/papers/libavl.pdf):

> The results indicate that when input is expected to be randomly ordered with occasional runs of sorted order, red-black trees are preferred; when insertions often occur in sorted order, AVL trees excel for later random access, whereas splay trees perform best for later sequential or clustered access.

以及 [Red-black Trees (rbtree) in Linux](https://docs.kernel.org/core-api/rbtree.html):

> Red-black trees are a type of self-balancing binary search tree, used for storing sortable key/value data pairs. This differs from radix trees (which are used to efficiently store sparse arrays and thus use long integer indexes to insert/access/delete nodes) and hash tables (which are not kept sorted to be easily traversed in order, and must be tuned for a specific size and hash function where rbtrees scale gracefully storing arbitrary keys).

## 简述红黑树

Left-Leaning Red-Black Trees (by Robert Sedgewick): 
[论文](https://sedgewick.io/wp-content/themes/sedgewick/papers/2008LLRB.pdf) 
/
[投影片](https://sedgewick.io/wp-content/uploads/2022/03/2008-09LLRB.pdf) 

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

### 红黑树的定义

{{< image src="https://hackmd.io/_uploads/HJfaeBQJn.png" >}}

2-3-4 数和红黑树的转换关系:

{{< image src="https://hackmd.io/_uploads/HJ6Cp4mk2.png" >}}

{{< image src="https://hackmd.io/_uploads/Hybe0V712.png" >}}

### 红黑树的插入

{{< admonition >}}
1. 像普通的树一样寻找合适的位置插入 **红节点**
2. **自底向上** 通过旋转、分裂、合并等操作进行调整
{{< /admonition >}}

***Definition: $n$ 树节点表示该节点有 $n$ 个子树分支***

红黑树向 2 树节点插入得到 3 树节点，通过旋转操作即可完成，也不涉及树高变化 (因为从 2-3-4 树的角度来看，树的节点数不变):

{{< image src="https://hackmd.io/_uploads/BkHf0E712.png" >}}

红黑树向 3 树节点插入得到 4 树节点共有 3 种情形，通过旋转操作即可完成，不会导致树高变化 (因为从 2-3-4 树的角度来看，树的节点数不变):

- 第一种情况

{{< image src="https://hackmd.io/_uploads/SJ5EQDinn.png" >}}

- 第二种情况

{{< image src="https://hackmd.io/_uploads/SyMECNmkh.png" >}}

- 第三种情况

{{< image src="https://hackmd.io/_uploads/BkXB0Vmkh.png" >}}

如果红黑树要插入的节点是 4 树节点，这是不被运行的 (因为红黑树的节点不允许超过 4 树节点)，此时需要旋转操作搭配分裂和合并 (通过改变边的颜色) 操作，将该 4 树节点不断地向上分裂成对应等价的 2 树节点 (这可能会导致树高增加)，然后依据上面的插入方法对剩下的 2 树节点 / 3 树节点进行插入即可 (因为原先的 4 树节点已被分裂，所以要插入的节点不可能是 4 树节点):

4 树节点翻转连接父节点的边颜色进行分裂:

{{< image src="https://hackmd.io/_uploads/H1ULRVmkh.png" >}}

父节点为 2 树节点时的颜色翻转分裂，有 2 种情况:

- 情况 1: 4 树节点为父节点的左节点

{{< image src="https://hackmd.io/_uploads/ryOPAN7kn.png" >}}

- 情况 2: 4 树节点为父节点的右节点

{{< image src="https://hackmd.io/_uploads/HJLdCV7kh.png" >}}

父节点为 3 树节点时的颜色翻转分裂，比较复杂，有 3 种情况:

- 第一种情况

{{< image src="https://hackmd.io/_uploads/BJatA4Q1h.png" >}}

- 第二种情况

{{< image src="https://hackmd.io/_uploads/ByocCVQ1h.png" >}}

- 第三种情况

{{< image src="https://hackmd.io/_uploads/SyYjAEmJ3.png" >}}

因为红黑树和 2-3-4 树一样，都是从叶子节点处插入新节点，如果新插入的节点使得叶子节点变成了 4 树节点，那么此时就会从下往上对 4 树节点进行分裂颜色翻转，如果这个过程使得父节点成为了新的 4 树节点，那么继续对父节点进行分裂颜色翻转，依次处理，直到父节点不是 4 树节点或达到了根节点，如果根节点被这个过程变成了 4 树节点，那么同样的对父节点进行分裂颜色翻转，这个操作会使得红黑树树高加 1。所以正常情况下，4 树节点只会在插入节点后某个时间点短暂存在于红黑树中，所以不需要考虑父节点为 4 树节点的插入情况。

### 红黑树的移除

## Maple tree

解说录影: [The Linux Maple Tree - Matthew Wilcox, Oracle](https://www.youtube.com/watch?v=XwukyRAL7WQ)
