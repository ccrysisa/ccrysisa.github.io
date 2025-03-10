---
title: "Probability and Statistics"
subtitle:
date: 2024-01-20T17:20:09+08:00
slug: 7592e7c
draft: true
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
  - Probility
  - Statistics
  - Random Variable
categories:
  - Mathematics
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRss: false
hiddenFromRelated: false
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

随机变量 (Random Variable) 是概率 (Probability) 和统计 (Statistics) 的“灵魂”，从数学上讲，Random Variable 是连接 Probability 和 Statistics 的桥梁；从实际上讲，Random Variable 表示我们所关心、期望的东西。例如一批产品的硬度，每个产品的硬度显然是不同的、是随机的，尽管硬度是随机的，但产品的硬度遵循一定的概率规律，这种随机、但却遵循一定概率规律的东西，就是 Random Value。

<!--more-->

## NTHU 概率论

- [概率论](http://www.stat.nthu.edu.tw/~swcheng/Teaching/math2810/index.php)

### Combinatorial Analysis 

最底层结构: vector, set

在其上面构造的结构:

- List
- Permutation
- Combination
- Partition
- Solution of Integer

如果物件之间不平等 (位置有差异)，即存在 Order，此时需要使用 vector 来进行区分，反之则使用 set

除了 List 之外的模型，有时可以将 **可分配的资源** 视为资源总量，例如位于排序中的位置。从这个角度出发，会比较好的理解 Partition 和 Integer Solution 的构造 (此时可以使用 Permuatation 搭配 List 来推导出 Partition 的公式)

{{< raw >}}
$$
C^n_{n_1} \cdot C^{n - n_1}_{n_2} \cdot ... C^{n_r}_{n_r} = \frac{A^n_n}{A^{n_1}_{n_1} \cdot A^{n_2}_{n_2} \cdot ... A^{n_r}_{n_r}},\ where\ n_1 + n_2 + ... n_r = n
$$
{{< /raw >}}

## NCTU 统计学

国立阳明交通大学 陈邻安老师，开设了两学期的统计课程，分别是上学期的 **统计学** 和下学期的 **高等统计学**。

| 课程名称 | 英文名称 | 课程地址 | 课程视频 |
| :----: | :-----: | :----: | :-----: |
| 统计学    | Statistics          | [课程资讯][stat]  | [YouTube][stat-video] |
| 高等统计学 | Advanced Statistics | [课程资讯][astat] | [YouTube][astat-video] |

这两个学期课程的作业、习题以及解答都可以在 [这里](https://stat.nycu.edu.tw/zh_tw/course/community/info7) 找到。

{{< center-quote >}}
***学习一门课，要学习其“精神”，而不是学习其方法。***
{{< /center-quote >}}

### Concepts

{{< admonition quote >}}
Sample space $S$: Set of possible outcomes of a ***random experiment***.

Every subset of $S$ is an ***event***.
{{< /admonition >}}

**Random experiment** 是一种特殊的实验。物理实验、化学实验在相同的条件下所产生的结果是相同的，但 Random experiment 不同，在相同的条件下，每次实验的结果是随机的。但 Random experiment 结果的情况是有限的，所有实验结果的集合就称为 Sample space。

{{< admonition quote >}}
***Probability set function*** $P$ on subset of $S$ satisfies:
1. $P(A) \geq 0$
2. $P(S) = 1$
3. $P(\bigcup\limits_{k=1}^{\infty} A_k) = \sum\limits_{k=1}^{\infty} A_k\ \ \ if A_i \bigcap A_j = \emptyset\ for\ all\ i \neq j$

A random variable $X$ is a ***real-valued function*** define on $S$.
$$
X:\ S \rightarrow R\ \ \ or \ \ \ S \xrightarrow{X} R
$$
{{< /admonition >}}

**set function** 是对 set 进行映射的 function，所以 $P$ 是 subset of $S$ 到实数的映射关系，通过 $P$ 可以计算 event 对应的概率值。
Probability set function $P$ 有 3 个符合直觉的基本准则，我们可以从这 3 个准则可以推导出其它符合直觉的性质:
{{< raw >}}
$$
\forall A \subset S \implies
\begin{cases}
  P(\emptyset) &= 0 \\
  P(A^{C}) &= 1 - p
\end{cases}
$$
{{< /raw >}}

---

{{< raw >}}
$$
\begin{split}
& \mathrm{Since}\ \emptyset \cap S = \emptyset \\
& \mathrm{Then}\ P(S) = P(\emptyset \cap S) = P(\emptyset) + P(S) \\
& \mathrm{and}\ P(S) = 1 \\
& \mathrm{Thus}\ P(\emptyset) = P(S) - P(S) = 0 \\
& Q.D.E. \\
& \\
& \mathrm{Since}\ A^{C} \cap A = \emptyset \\
& \mathrm{Then}\ P(S) = P(A^{C} \cup A) = P(A^{C}) + P(A) \\
& \mathrm{and}\ P(S) = 1 \\
& \mathrm{Thus}\ P(A^{C}) = P(S) - P(A) = 1 - p \\
& Q.D.E.
\end{split}
$$
{{< /raw >}}

---

**Random variable** $X$ 是将 sample space $S$ 映射到实数域 $R$ 的映射关系，即 $S$ 是定义域 (domain)，$R$ 是值域 (co-domain)。由于 $S$ 和 $R$ 在计数上并不相同，所以 $r.v.\ X$ 只是单射，并不是满射。
为什么需要这样的映射关系？因为对于实数，可以使用微积分这类数学工具对概率的性质进行研究，而微积分这类数学工具对于 sample space 显然是无法使用的。
但是注意，根据 **Probability set function** 的定义，对于映射后实数域上的集合，我们是无法直接求得对应的概率值，所以需要一个类似反函数的映射关系 $X^{-1}:\ R \rightarrow S$ 来将 $R$ 映射回 $S$，从而计算对应的概率值。

> 为什么是*类似反函数的映射*？原因如上面所说的，$S$ 和 $R$ 在计数上并不相等，所以 $R$ 到 $S$ 的映射有可能不满足单射。

{{< admonition quote >}}
Our interest of Probability:
- Given $B \subset R$, what $P(x \in B) =\ ?$
  {{< raw >}}
  $$
  (X \in B) = X^{-1}(B) = \{s \in S: X(s) \in B\} \subset S \\
  \implies P(x \in B) = P(\{s \in S: X(s) \in B\})
  $$
  {{< /raw >}}
- Distribution function (df) of a r.v. $X$ is
  $$
  F(x) = P(X \leq x),\ x \in R
  $$
{{< /admonition >}}

如果我们需要对实数域上的集合 $B$ 求其概率值，则如我们之前所说的，需要使用 $X^{-1}$ 将 $R$ 映射回 $S$。由于可能是非单射的映射关系，所以我们使用集合 $\\{s \in S: X(s) \in B\\}$ 来表示映射结果，所以 $(x \in B)$ 也可以表示 event。
这样我们就可以对实数域上的集合求其概率值了，也即此时我们拥有一个 $subset\ of\ R$ 到 $R$ 的映射关系。
但是这样仍然无法在二维坐标轴上进行直观表示，也无法对该关系使用微积分等工具进行研究，我们需要 $R \rightarrow R$ 的映射关系。

**Distribution function (df)** 就是我们所期望的 $R \rightarrow R$ 的映射关系，对于 $R$ 上的每一个 $x$ 映射到 $P(X \leq x)$。
注意 $X \leq x$ 只是一个数学表示，并不具备数学意义，因为 $X$ 作为一个 real-valued function 和实数 $x$ 进行关系运算显然是没有意义的。
$X \leq x$ 表示在 r.v. $X$ 的映射关系下，集合 $y \in (-\infty, x]$ 即 $\\{s \in S: X(s) \in (-\infty, x]\\}$，所以 
$$
P(X \leq x) = P(\\{s \in S: X(s) \in (-\infty, x]\\})
$$
有了 df 我们就可以将概率的性质通过二维坐标轴进行直观显示，并且可以使用微积分这类工具进行进一步研究。

接下来以一些常见的概率分布来对之前所提的概念进行实作：

{{< admonition quote >}}
Some Distributions:   
***Bernoulli distribution*** and ***Binomial distribution***.   

A experiment with two possible outcomes is called a Bernoulli experiment.
We denote the sample space by 
$$S = \\{S, F\\},\ S = Success,\ F = Failure$$
Probability set function: 
$$P(\\{S\\}) = p,\ P(\\{F\\}) = 1-p,\ 0 \le p \le 1$$
We define r.v. $X$ on $S = \\{S, F\\}$ by
{{< raw >}}
$$
X(S) = 1, X(F) = 0 \\
\implies \{S, F\} \xrightarrow{X} \{0, 1\}
$$
{{< /raw >}}
The Probability are
{{< raw >}}
$$
P(X = 1) = P(X^{-1}\{1\}) = P(\{S\}) = p
$$
{{< /raw >}}
{{< /admonition >}}

我们可以从这个 Bernoulli distribution 的例子中提炼统计的一般思路:
1. 从 Random experiment 中构建 Sample space $S$
2. 通过 Probability set function 计算 event 对应的概率值
3. 定义 Random variable $X$ 实现 $S$ 到 $R$ 的映射关系
4. 对 Distribution function (df) 进一步分析

## References

- [List of LaTeX mathematical symbols](https://oeis.org/wiki/List_of_LaTeX_mathematical_symbols)


[stat]: https://ocw.nycu.edu.tw/?post_type=course_page&p=25566
[stat-video]: https://www.youtube.com/playlist?list=PLj6E8qlqmkFtvN44vX_D7YRxAgivkONyN

[astat]: https://ocw.nycu.edu.tw/?post_type=course_page&p=25439
[astat-video]: https://www.youtube.com/playlist?list=PLj6E8qlqmkFvneoIIsf3yPr_TVPy6qimA