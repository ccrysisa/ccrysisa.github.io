# 手把手带你使用 Rust 实现链表


{{&lt; admonition abstract &gt;}}
其它语言：兄弟，语言学了吗？来写一个链表证明你基本掌握了语法。

Rust 语言: 兄弟，语言精通了吗？来写一个链表证明你已经精通了 Rust！
{{&lt; /admonition &gt;}}

&lt;!--more--&gt;

{{&lt; link href=&#34;https://www.bilibili.com/video/BV1eb4y1Q7FA/&#34; content=&#34;教学录影&#34; external-icon=true &gt;}}
/
{{&lt; link href=&#34;https://rust-unofficial.github.io/too-many-lists/&#34; content=&#34;原文地址&#34; external-icon=true &gt;}}
/ 
{{&lt; link href=&#34;https://course.rs/too-many-lists/intro.html&#34; content=&#34;中文翻译&#34; external-icon=true &gt;}}

## 通过枚举实现 Lisp 风格的链表

```rs
#[derive(Debug)]
enum List&lt;T&gt; {
    Cons(T, Box&lt;List&lt;T&gt;&gt;),
    Nil,
}

fn main() {
    let list: List&lt;i32&gt; = List::Cons(1, Box::new(List::Cons(2, Box::new(List::Nil))));
    println!(&#34;{:?}&#34;, list);
}
```

{{&lt; admonition &gt;}}
该实作将 **链表节点整体** 视为 **枚举** 进行区分，导致空元素也会占据内存空间
{{&lt; /admonition &gt;}}

符号 `[]` 表示数据存放在 stack 上，`()` 则表示数据存放在 heap 上，上面例子的内存分布为:
```
[List 1, ptr] -&gt; (List 2, ptr) -&gt; (Nil)
```

存在的问题:
1. 元素 1 是分配在 stack 而不是 heap 上
2. 最后的空元素 `Nil` 也需要分配空间

而我们预期的内存分布为:
```
[ptr] -&gt; (List 1, ptr) -&gt; (List 2, ptr) -&gt; (Nil)
```

这样的内存分布更加节省 stack 空间，并且将所有的链表节点都放置在 heap 上，这样在链表拆分和合并时就不需要对头结点进行额外考量和处理，下面是两种内存布局在链表拆分时的对比:
```
// first entry in stack
[List 1, ptr] -&gt; (List 2, ptr) -&gt; (List 3, ptr) -&gt; (Nil)
split off 3:
[List 1, ptr] -&gt; (List 2, ptr) -&gt; (Nil)
[List 3, ptr] -&gt; (Nil)

// first entry in heap
[ptr] -&gt; (List 1, ptr) -&gt; (List 2, ptr) -&gt; (List 3, ptr) -&gt; (Nil)
split off 3:
[ptr] -&gt; (List 1, ptr) -&gt; (List 2, ptr) -&gt; (Nil)
[ptr] -&gt; (List 3, ptr) -&gt; (Nil)
```

显然第一种方式在链表拆分时涉及到链表元素在 stack 和 heap 之间的位置变换，链表合并也类似，请自行思考。

但是这个内存布局并不是最好的，我们想要达到类似 C/C&#43;&#43; 的链表的内存布局:
```
[ptr] -&gt; (List 1, ptr) -&gt; (List 2, ptr) -&gt; (List 3, null)
```

## 实作 C/C&#43;&#43; 风格的链表

```rs
#[derive(Debug)]
struct Node&lt;T&gt; {
    elem: T,
    next: Link&lt;T&gt;,
}

#[derive(Debug)]
enum Link&lt;T&gt; {
    Empty,
    More(Box&lt;Node&lt;T&gt;&gt;),
}

#[derive(Debug)]
struct List&lt;T&gt; {
    head: Link&lt;T&gt;,
}

fn main() {
    let node2 = Node { elem: 2, next: Link::Empty };
    let node1 = Node { elem: 1, next: Link::More(Box::new(node2)) };
    let list  = List { head: Link::More(Box::new(node1)) };
    println!(&#34;{:?}&#34;, list);
}
```

{{&lt; admonition &gt;}}
该实作将 链表节点的 **next 指针部分** 视为 **枚举** 进行区分，这样空元素不会占据内存空间
{{&lt; /admonition &gt;}}


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/too-many-lists/  

