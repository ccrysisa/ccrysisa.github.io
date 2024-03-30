# Hello, World


博客（英语：Blog）是一种在线日记型式的个人网站，借由张帖子章、图片或视频来记录生活、抒发情感或分享信息。博客上的文章通常根据张贴时间，以倒序方式由新到旧排列。

## 数学公式

行内公式：$N(b,d)=(b-1)M$

公式块：

{{&lt; raw &gt;}}
$$
\int_{a}^{b}x(t)dt =
\dfrac{b - a}{N} \\
=\sum_{k=1}^{N}x(t_k)\cdot\dfrac{b-a}{N}
$$
{{&lt; /raw &gt;}}

{{&lt; raw &gt;}}
$$
\begin{aligned}
\int_{a}^{b}x(t)dt &amp;=
\dfrac{b - a}{N} \\
&amp;=\sum_{k=1}^{N}x(t_k)\cdot\dfrac{b-a}{N} \\
\end{aligned}
$$
{{&lt; /raw &gt;}}

{{&lt; raw &gt;}}
$$
\mathrm{Integrals\ are\ numerically\ approximated\ as\ finite\ series}:\\ 
\begin{split}
\int_{a}^{b}x(t)dt &amp;=
\dfrac{b - a}{N} \\
&amp;=\sum_{k=1}^{N}x(t_k)\cdot\dfrac{b-a}{N}
\end{split} \\ 
where\ t_k = a &#43; (b-a)\cdot k/N
$$
{{&lt; /raw &gt;}}

{{&lt; raw&gt;}}
$$
\begin{align*}
p(x) = 3x^6 &#43; 14x^5y &amp;&#43; 590x^4y^2 &#43; 19x^3y^3 \\
&amp;- 12x^2y^4 - 12xy^5 &#43; 2y^6 - a^3b^3 - a^2b - ab &#43; c^5d^3 &#43; c^4d^3 - cd
\end{align*}
$$
{{&lt; /raw &gt;}}

{{&lt; raw &gt;}}
$$
\begin{split}
&amp;(X \in B) = X^{-1}(B) = {s \in S: X(s) \in B} \subset S \\
&amp;\Rightarrow P(x \in B) = P({s \in S: X(s) \in B})
\end{split}
$$
{{&lt; /raw &gt;}}

## 代码块

```rs
let i: i32 = 13;
let v = vec![1, 2, 3, 4, 5, 65];
for x in v.iter() {
    println!(&#34;{}&#34;, x);
}
```

```c
typedef struct Block_t {
    int head;
    int data;
} Block_t;
```

## Admonition

{{&lt; admonition &gt;}} 一个 注意 横幅 {{&lt; /admonition &gt;}}

{{&lt; admonition abstract &gt;}} 一个 摘要 横幅 {{&lt; /admonition &gt;}}

{{&lt; admonition info &gt;}} 一个 信息 横幅 {{&lt; /admonition &gt;}}

{{&lt; admonition tip &gt;}} 一个 技巧 横幅 {{&lt; /admonition &gt;}}

{{&lt; admonition success &gt;}} 一个 成功 横幅 {{&lt; /admonition &gt;}}

{{&lt; admonition question &gt;}} 一个 问题 横幅 {{&lt; /admonition &gt;}}

{{&lt; admonition warning &gt;}} 一个 警告 横幅 {{&lt; /admonition &gt;}}

{{&lt; admonition failure &gt;}} 一个 失败 横幅 {{&lt; /admonition &gt;}}

{{&lt; admonition danger &gt;}} 一个 危险 横幅 {{&lt; /admonition &gt;}}

{{&lt; admonition bug &gt;}} 一个 Bug 横幅 {{&lt; /admonition &gt;}}

{{&lt; admonition example &gt;}} 一个 示例 横幅 {{&lt; /admonition &gt;}}

{{&lt; admonition quote &gt;}} 一个 引用 横幅 {{&lt; /admonition &gt;}}

## References

- [FixIt 快速上手](https://fixit.lruihao.cn/zh-cn/documentation/getting-started/)
- [使用 Hugo &#43; Github 搭建个人博客](https://zhuanlan.zhihu.com/p/105021100)
- [Markdown 基本语法](https://fixit.lruihao.cn/zh-cn/documentation/content-management/markdown-syntax/basics/)
- [Emoji 支持](https://fixit.lruihao.cn/zh-cn/guides/emoji-support/)
- [扩展 Shortcodes 概述](https://fixit.lruihao.cn/zh-cn/documentation/content-management/shortcodes/extended/introduction/#admonition)
- [图表支持](https://fixit.lruihao.cn/zh-cn/documentation/content-management/diagrams/)
- [URL management](https://gohugo.io/content-management/urls/#permalinks)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/hello_world/  

