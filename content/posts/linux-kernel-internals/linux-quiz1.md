---
title: "Linux 核心设计: 第 1 周测验题 linked list"
subtitle:
date: 2024-02-16T14:59:25+08:00
draft: true
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

## 2020q1 第 1 週測驗題

### 测验 1

- 本题使用的是单向 linked list

```c
typedef struct __list {
    int data;
    struct __list *next;
} list;
```

- 一开始的 if 语句用于判断 start 是否为 NULL 或是否只有一个节点，如果是则直接返回无需排序

- 接下来使用 mergesort 来对 linked list 进行从小到大排序，并且每次左侧链表只划分一个节点，剩余节点全部划为右侧链表

```c
    list *left = start;
    list *right = left->next;
    left->next = NULL; // LL0;
```

- 再来就是归并操作，将 left 和 right 进行归并，如果 merge 为 NULL，则将对应的节点赋值给它和 start，否则需要迭代 left 或 right 以及 merge 以完成归并操作

```c
    for (list *merge = NULL; left || right; ) {
        if (!right || (left && left->data < right->data)) {
            if (!merge) {
                start = merge = left; // LL1;
            } else {
                merge->next = left; // LL2;
                merge = merge->next;
            }
            left = left->next; // LL3;
        } else {
            if (!merge) {
                start = merge = right; // LL4;
            } else {
                merge->next = right; // LL5;
                merge = merge->next;
            }
            right = right->next; // LL6;
        }
    }
```

{{< admonition tip >}}
延伸問題:

1. [x] 解釋上述程式運作原理;
2. 指出程式改進空間，特別是考慮到 [Optimizing merge sort](https://en.wikipedia.org/wiki/Merge_sort#Optimizing_merge_sort);
3. 將上述 singly-linked list 擴充為 circular doubly-linked list 並重新實作對應的 sort;
4. 依循 Linux 核心 [include/linux/list.h](https://github.com/torvalds/linux/blob/master/include/linux/list.h) 程式碼的方式，改寫上述排序程式;
5. 嘗試將原本遞迴的程式改寫為 iterative 版本;
{{< /admonition >}}
