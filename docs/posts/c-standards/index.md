# 你所不知道的 C 语言: 开发工具和规格标准


&gt; Linux 核心作为世界上最成功的开放原始码计划，也是 C 语言在工程领域的瑰宝，里头充斥则各种“艺术”，往往会吓到初次接触的人们，但总是能够使用 C 语言标准和开发工具提供的扩展 (主要是来自 gcc 的 GNU extensions) 来解释。
&gt; &gt; “工欲善其事，必先利其器”   

&lt;!--more--&gt;

- {{&lt; link href=&#34;https://hackmd.io/@sysprog/c-standards&#34; content=&#34;原文地址&#34; external-icon=true &gt;}}

{{&lt; center-quote &gt;}}
**If I had eight hours to chop down a tree, I’d spend six hours sharpening my axe.**

—— Abraham Lincoln   
{{&lt; /center-quote &gt;}}

语言规格: C89/C90 -&gt; C99 -&gt; C11 -&gt; C17/C18 -&gt; C2x

## C vs C&#43;&#43;

&gt; C is quirky, flawed, and an enormous success. Although accidents of history surely helped, it evidently satisfied a need for a system implementation language efficient enough to displace assembly language, yet sufficiently abstract and fluent to describe algorithms and interactions in a wide variety of environments. —— Dennis M. Ritchie

{{&lt; image src=&#34;https://imgur-backup.hackmd.io/1gWHzfd.png&#34; &gt;}}

- David Brailsford: [Why C is so Influential - Computerphile](https://www.youtube.com/watch?v=ci1PJexnfNE)

- [x] Linus Torvalds: [c&#43;&#43; in linux kernel](https://www.realworldtech.com/forum/?threadid=104196&amp;curpostid=104208)
&gt; And I really do dislike C&#43;&#43;. It&#39;s a really bad language, in
&gt; my opinion. It tries to solve all the wrong problems, and
&gt; does not tackle the right ones. The things C&#43;&#43; &#34;solves&#34;
&gt; are trivial things, almost purely syntactic extensions to
&gt; C rather than fixing some true deep problem.

- Bjarne Stroustrup: [Learning Standard C&#43;&#43; as a New Language](http://www.stroustrup.com/new_learning.pdf) [PDF]

- C&#43;&#43; 标准更新飞快: C&#43;&#43;11, C&#43;&#43;14, C&#43;&#43;17, ...

{{&lt; image src=&#34;https://i.imgur.com/ITVm6gI.png&#34; &gt;}}

&gt; 从 C99, C&#43;&#43;98 开始，C 语言和 C&#43;&#43; 分道扬镳

&gt; **in C, everything is a representation (unsigned char [sizeof(TYPE)]).** —— Rich Rogers

- [x] [第一個 C 語言編譯器是怎樣編寫的？](https://kknews.cc/zh-tw/tech/bx2r3j.html)
&gt; 介绍了自举 (sel-hosting/compiling) 以及 C0, C1, C2, C3, ... 等的演化过程

## C 语言规格书

### main

阅读 C 语言规格书可以让你洞察本质，不在没意义的事情上浪费时间，例如在某乎大肆讨论的 `void main()` 和 `int main()` [问题](https://www.zhihu.com/question/60047465) :rofl:

- C99/C11 5.1.2.2.1 Program startup

The function called at program startup is named `main`. The implementation declares no
prototype for this function. It shall be defined with a return type of `int` and with no
parameters:

```c
int main(void) { /* ... */ }
```

or with two parameters (referred to here as `argc` and `argv`, though any names may be
used, as they are local to the function in which they are declared):

```c
int main(int argc, char *argv[]) { /* ... */ }
```

or equivalent; or in some other implementation-defined manner.

&gt; Thus, int can be replaced by a typedef name defined as `int`, or the type of `argv` can be written as `char ** argv`, and so on.

### incomplete type

- C99 6.2.5 Types
&gt; *incomplete types* (types that describe objects but lack information needed to determine their sizes).

### 规格不仅要看最新的，过往的也要熟悉

因为很多 (嵌入式) 设备上运行的 Linux 可能是很旧的版本，那时 Linux 使用的是更旧的 C 语言规格。例如空中巴士 330 客机的娱乐系统里执行的是十几年前的 Red Hat Linux，总有人要为这些“古董”负责 :rofl:

## GDB

使用 GDB 这类调试工具可以大幅度提升我们编写代码、除错的能力 :dog:

- video: [Linux basic anti-debug](https://www.youtube.com/watch?v=UTVp4jpJoyc)
- video: [C Programming, Disassembly, Debugging, Linux, GDB](https://www.youtube.com/watch?v=twxEVeDceGw)
- [rr](http://rr-project.org/) (Record and Replay Framework)
  - video: [Quick demo](https://www.youtube.com/watch?v=hYsLBcTX00I)
  - video: [Record and replay debugging with &#34;rr&#34;](https://www.youtube.com/watch?v=ytNlefY8PIE)

## C23

上一个 C 语言标准是 C17，正式名称为 ISO/IEC 9899:2018，是 2017 年准备，2018年正式发布的标准规范。C23 则是目前正在开发的规格，其预计新增特性如下:

- `typeof`: 由 GNU extension 转正，用于实作 `container_of` 宏
- `call_once`: 保证在 concurrent 环境中，某段程式码只会执行 1 次
- `char8_t`: Unicode friendly `u8&#34;💣&#34;[0]`
- `unreachable()`: 由 GNU extension 转正，提示允许编译器对某段程式码进行更激进的最佳化
- `= {}`: 取代 `memset` 函数调用
- ISO/IEC 60559:2020: 最新的 IEEE 754 浮点数运算标准
- `_Static_assert`: 扩充 C11 允许单一参数
- 吸收 C&#43;&#43;11 风格的 attribute 语法，例如 `nodiscard`, `maybe_unused`, `deprecated`, `fallthrough`
- 新的函数: `memccpy()`, `strdup()`, `strndup()` ——— 类似于 POSIX、SVID中 C 函数库的扩充
- 强制规范使用二补数表示整数
- 不支援 [K&amp;R 风格的函数定义](https://stackoverflow.com/questions/3092006/function-declaration-kr-vs-ansi)
- 二进制表示法: `0b10101010` 以及对应 printf() 的 `%b` (在此之前 C 语言是不支援二进制表示法的 :rofl:)
- Type generic functions for performing checked integer arithmetic (Integer overflow)
- `_BitInt(N)` and `UnsignedBitInt(N)` types for bit-precise integers
- `#elifdef` and `#elifndef`
- 支持在数值中间加入分隔符，易于阅读，例如 `0xFFFF&#39;FFFF`

{{&lt; admonition info &gt;}}
- [Ever Closer - C23 Draws Nearer](https://thephd.dev/ever-closer-c23-improvements)
- [C23 is Finished: Here is What is on the Menu](https://thephd.dev/c23-is-coming-here-is-what-is-on-the-menu)
{{&lt; /admonition &gt;}}


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-standards/  

