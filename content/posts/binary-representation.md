---
title: 解读计算机编码
subtitle:
date: 2023-12-31T15:43:50+08:00
draft: false
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
  - LKI, binary
categories:
  - LKI
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

人們對數學的加減運算可輕易在腦中辨識符號並理解其結果，但電腦做任何事都受限於實體資料儲存及操作方式，換言之，電腦硬體實際只認得 0 和 1，卻不知道符號 + 和 - 在數學及應用場域的意義，於是工程人員引入「補數」以便在二進位系統中，表達人們認知上的正負數。但您有沒有想過，為何「二補數」(2’s complement) 被電腦廣泛採用呢？背後的設計考量又是什麼？本文嘗試從數學觀點去解讀編碼背後的原理，並佐以資訊安全及程式碼最佳化的考量，探討二補數這樣的編碼對於程式設計有何關鍵影響。

<!--more-->

## 一补数 (Ones’ complement)

### 9 的补数

:x: 科普短片: [Not just counting, but saving lives: Curta][not-just-counting-but-saving-lives-curta]

### 运算原理

**以一补数编码形式表示的运算子，在参与运算后，运算结果符合一补数的编码：**

{{< raw >}}
$$
[X]_{一补数} + [Y]_{一补数} = [X+Y]_{一补数}
$$
{{< /raw >}}

接下来进行分类讨论，以 32-bit 正数 $X$, $Y$ 为例：

- $X + Y = X + Y$ 显然运算子和运算结果都满足一补数编码。

- $X - Y = X + (2^{32} - 1 - Y)$

  - 如果 $X > Y$，则运算结果应为 $X - Y$ 且为正数，其一补数编码为 $X - Y$。而此时 
  $$
  2^{32} - 1 + X - Y
  $$ 
  显然会溢出，为了使运算结果对应一补数编码，所以此时循环进位对应 $+\ (1 - 2_{32})$。

  - 如果 $X < Y$，则运算结果应为 $X - Y$ 且为负数，其一补数编码为 
  $$
  2^{32} - 1 - （Y - X） = 2_{32} - 1 - X - Y
  $$
  而此时 $2^{32} - 1 + X - Y$ 并不会溢出，并且满足运算结果的一补数编码，所以无需进行循环进位。

  - 如果 $X = Y$，显然 
  $$
  X - Y = X + 2^{32} - 1 - Y = 2^{32} - 1
  $$
  为 0 成立。

- $-X - Y = (2^{32} - 1 - X) + (2^{32} - 1 - Y)$，显然会导致溢出。而 $-X - Y$ 的一补数编码为 
$$
2^{32} - 1 - (X + Y) = 2^{32} - 1 - X - Y
$$
所以需要在溢出时循环进位 $+\ (1 - 2^{32})$ 来消除运算结果中的一个 $2^{32} - 1$。

## 二补数 (Two's complement)

### 正负数编码表示

假设有 n-bit 的二补数编码 $A$，$-A$ 的推导如下：

- 格式一：

{{< raw >}}
$$
\begin{align*}
A + \neg A &= 2^n - 1 \\
A + \neg A + 1 &\equiv 0 \equiv 2^n \ (\bmod 2^n) \\
-A &= \neg A + 1 \\ 
\end{align*}
$$
{{< /raw >}}

- 格式二：

{{< raw >}}
$$
\begin{align*}
A + \neg A &= 2^n - 1 \\
A + \neg A - 1 &= 2^n - 2 \\
A - 1 &= 2^n - 1 - (\neg A + 1) \\ 
\neg (A - 1) &= \neg A + 1 \\
\neg (A - 1) &= -A \\
\end{align*}
$$
{{< /raw >}}

### 加 / 减法器设计

:x: 科普短片: [See How Computers Add Numbers In One Lesson][see-how-computers-add-numbers-in-one-lesson]


<!-- URL -->
[not-just-counting-but-saving-lives-curta]: https://www.youtube.com/watch?v=kRmExkQoOPY
[see-how-computers-add-numbers-in-one-lesson]: https://www.youtube.com/watch?v=VBDoT8o4q00

