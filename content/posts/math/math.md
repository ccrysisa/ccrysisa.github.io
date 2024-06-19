---
title: 数学开放式课程学习指引
subtitle:
date: 2023-12-23T21:35:47+08:00
draft: false
author:
  name: vanJker
  link: https://github.com/vanJker
  email: cjshine@foxmail.com
  avatar: https://avatars.githubusercontent.com/u/88960102?s=96&v=4
description:
keywords:
license:
comment: false
weight: 0
tags:
  - Mathematics
categories:
  - Mathematics
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

这里记录一些收集到的数学开放式课程学校资料。

<!--more-->

## 资源导航

[中大數學系開放式課程](http://www.math.ncu.edu.tw/~cchsiao/OCW/)

國立台灣大學 齊震宇
- 數學導論：[相關講義](httbookps://equation.nidbox.com/diary/read/9028768) / [教學錄影](https://www.bilibili.com/video/BV1wx411W7vB)
- 數學潛水艇：[綫性代數](https://www.bilibili.com/video/BV184411F7wr/)、[拓撲](https://www.bilibili.com/video/BV1mt411u74C/)
- 微積分: [Part 1](https://www.bilibili.com/video/BV1xY411q75M/), [Part 2](https://www.bilibili.com/video/BV1pA41167tJ/)
- 分析

國立台灣大學 謝銘倫
- 綫性代數

## 逻辑、集合论

{{< image src="/images/math/key-of-mathematics.png" >}}

### 簡易邏輯

在联结词构成的复合命题中，命题的语义和真值需要分开考虑，特别是联结词 $\implies$。以 $p \implies q$ 为例 (注意 $p$ 和 $q$ 都是抽象命题，可指代任意命题，类似于未知数 $x$)，如果从 $p$ 和 $q$ 的语义考虑，很容易就陷入语义的 “如果 $p$ 则 $q$” 这类语义混淆中，导致强加因果，但因为在逻辑上 $p$ 和 $q$ 可以没有任何关系，所以此时忽略它们的语义，而只根据它们的真值和相关定义上推断该复合命题的真值 ($p \implies q$ 等价于 $(\neg p) \lor q$)。简单来说，逻辑上的蕴涵式包括语义上的因果关系，即因果关系是蕴涵式的真子集。

第 16 页的趣味问题可以通过以下 “标准” 方式 (这里的 “标准” 指的是一种通用方法思路，并非应试教育中的得分点) 来解决:   
令悟空、八戒、悟净和龙马分别为 $a, b, c, d$，令命题「$X$ 第 $Y$」为 $XY$，例如 “悟空第一” 则表示为命题 $a1$，则有以下命题成立:
{{< raw >}}
$$
\begin{split}
       & (c1 \land (\neg b2)) \lor ((\neg c1) \land b2) \\
\land\ & (c2 \land (\neg d3)) \lor ((\neg c2) \land d3) \\
\land\ & (d4 \land (\neg a2)) \lor ((\neg d4) \land a2) \\
\end{split}
$$
{{< /raw >}}
然后化简该表达式即可得到结果 (因为这个问题是精心设计过的，所以会有一个唯一解)。

性质也是命题，即其真假值可以谈论 (但未必能确定)。但正如第 22 页的注一所说，一般不讨论性质 $A(x)$ 的真假值，只有将具体成代入时才有可能谈论其真假值 (这很好理解，抽象的不定元 $x$ 可以代表无限多的东西，代入性质 $A(x)$ 的真假值可能并不相同)。但是需要注意后面集合论中虽然也使用了性质来定义群体，但是此时的性质表示 $A(x)$ 这个命题为真，即 $x$ 满足 $A$ 这个性质。所以需要细心看待逻辑学和集合论的性质一次，它们有共同点也有不同点。

处理更多不定元的性质时，按照第 24 ~ 27 页的注二的方法，将其转换成简单形式的单一不定元的性质进行处理。

### 集合概念簡介

第 42 页上运用了类似的化简不定元技巧，通过括号将同一时间处理不定元数量减少为 1.除此之外，这里还有一个不等式和区间/射线符号的技巧: **不带等号的不等式和区间/射线符号搭配使用时，需要反转区间/射线符号**，这个技巧可以从区间/射线符号的定义推导而来。以该页最后的例子为例:

{{< raw >}}
$$
(\bigcup_{m \in (0,1)}(1-\frac{1}{k}, 9-m]) \land (8 < 9-m < 9) \\
\begin{split}
(1-\frac{1}{k}, 9-m] &= \{x \in \mathbb{R} | 1-\frac{1}{k} < x <= 9-m < 9 \} \\
                     &= \{x \in \mathbb{R} | 1-\frac{1}{k} < x < 9 \} \\
                     &= (1-\frac{1}{k}, 9) \\
\end{split}
$$
{{< /raw >}}

倒数第二个例子也类似:

{{< raw >}}
$$
(\bigcap_{j \in \mathbb{R},\ j>0}(-j, 9)) \land (-j<0) \\
\begin{split}
(-j, 9) &= \{x \in \mathbb{R} | -j < 0 <= x < 9 \} \\
        &= \{x \in \mathbb{R} | 0 <= x < 9 \} \\
        &= [0, 9) \\
\end{split}
$$
{{< /raw >}}

第 45 ~ 46 页分别展示了例行公事式的证明和受过教育似的证明这两种方法，需要注意的是第一钟方法使用的是 **逻辑上等价** 进行推导 (因为它一次推导即可证明两个集合等价)，而第二种方法使用的是 **蕴涵** 进行推导 (因为它是通过两个方向分别证明包含关系，不需要等价性推导)。例行公事式的证明的要点在于，事先说明后续证明涉及的元素 $x$ 的性质，然后在后续证明过程中某一步将这个性质加入，进而构造出另一个集合的形式。

**练习一**:

*例行公事式的证明*

**练习二**:

*例行公事式的证明*

## 初等整數論

{{< image src="/images/math/inportance-of-definition.png" >}}

第 13 页 (反转了的) 辗转相除法的阅读顺序是：先阅读左边，在阅读右边，右边的推导是将上面的式子代入到下面的式子得来。

## 群、群作用與 Burnside 引理

第 16 页的 $Perm(X)$ 表示 $X$ 的元素进行置换对应的所有映射构成的集合，这个集合的基数为 $8!$。表示这个集合的某个元素 (也就是置换对应的映射)，可以用投影片上的形如 $(1\ 4\ 2)(3\ 7)(5)(6)$ 来表示，比较直观的体现这个映射的效果。

第 18 页子群定义的结合律一般不需要特别考虑，因为子群的任意元素属于群，而群的元素都满足结合律，所以子群的任意元素都满足结合律。

第 18 页的证明提示「消去律」，是指在证明子群性质时利用群的 **可逆** 和 **单位元** 性质进行证明。因为依据定义，群的单位元可作用的范围比子群的单位元作用范围广。

第 22 页的正八边形共有 16 种保持轮廓的变换 (8 种旋转和 8 种反面)，类似的，正十六边形则有 32 种保持轮廓的变换 (16 种旋转和 16 种反面)。这只是一种找规律问题，观察第 23 和 24 页分别列举的旋转和反面映射，可以获得这个规律的直觉。总结一下，正 $n$ 边形一共有 $2n$ 种保持轮廓的变换方法 ($n$ 种旋转和 $n$ 种反面)

## 线性代数

{{< center-quote >}}
*将现实世界给我们的启发，从它们当中抽取出规则，然后作用到数学的对象上，接着可能在发展了一些东西后，套回现实世界中去，但是我们需要知道它们 (数学世界和现实世界) 的分别在哪里。大部分场景不需要讨论这个分别，但在某些特别场景下，知道这个分别对我们会有特别的帮助。*
{{< /center-quote >}}

向量 (vector) 的加法一个二元运算，而向量集合 $V$ 和向量加法运算 $+$ 构成了一个交换群 $(V, +)$:

1. $(V, +)$ 是 **交换** 的: $\forall a, b \in V (a + b = b + a)$ 
*可以通过平行四边形的对角线来证明*

2. $(V, +)$ 是 **结合** 的: $\forall a, b, c \in V ((a + b) + c = a + (b + c))$ 
*可以通过平行六面体的对角线来证明*

3. $(V, +)$ 有 **单位元**: $\exist e \in V \forall v \in V (v + e = v = e + v)$ 
*零向量即是这个单位元*

4. $V$ 的每个元素都对 $+$ **可逆**: $\forall v \in V \exist \overset{\sim}{v} (v + \overset{\sim}{v} = e = \overset{\sim}{v} + v)$ 
*任意向量 $v$ 的反元素是 $-v$*

