---
title: "Linux 核心设计: 第 1 周测验题"
subtitle:
date: 2024-02-16T14:59:25+08:00
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
  - C
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

<!--more-->


{{< link href="https://github.com/ccrysisa/LKI/blob/main/2018-quiz4/" content=Source external-icon=true >}}

## 2018q1 第 4 週測驗題

### 测验 1

FuncA 的作用是
- (e) 建立新節點，內容是 value，並安插在結尾

FuncB 的作用是
- (d) 建立新節點，內容是 value，並安插在開頭

FuncC 的作用是
- (e) 找到節點內容為 value2 的節點，並在之後插入新節點，內容為 value1


在 main 函数调用 display 函数之前，链表分布为: 48 -> 51 -> 63 -> 72 -> 86

在程式輸出中，訊息 Traversal in forward direction 後依序印出哪幾個數字呢？
- (d) 48
- (c) 51
- (a) 63
- (e) 72
- (b) 86

在程式輸出中，訊息 Traversal in reverse direction 後依序印出哪幾個數字呢？
- (b) 86
- (e) 72
- (a) 63
- (c) 51
- (d) 48

{{< admonition tip >}}
延伸題目：

- 在上述 doubly-linked list 實作氣泡排序和合併排序，並提出需要額外實作哪些函示才足以達成目標

- 引入統計模型，隨機新增和刪除節點，然後評估上述合併排序程式的時間複雜度和效能分佈 (需要製圖和數學分析)
{{< /admonition >}}

### 测验 2

FuncX 的作用是 (涵蓋程式執行行為的正確描述最多者)
- (f) 判斷是否為 circular linked list，若為 circular 則回傳 0，其他非零值，過程中計算走訪的節點總數

K1 >> 後面接的輸出為何
- (b) Yes

K2 >> 後面接的輸出為何
- (a) No

K3 >> 後面接的輸出為何
- (a) No

K4 >> 後面接的輸出為何
- (a) No

K5 >> 後面接的輸出為何
- (f) 0

count >> 後面接的輸出為何
- (f) 0

