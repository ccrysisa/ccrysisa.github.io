# Linux 核心设计: 2023q1 第一周测验题


{{&lt; admonition abstract &gt;}}
目的: 检验学员对 linked list 的认知
{{&lt; /admonition &gt;}}

&lt;!--more--&gt;

- {{&lt; link href=&#34;https://hackmd.io/@sysprog/linux2023-quiz1&#34; content=&#34;原文地址&#34; external-icon=true &gt;}}

## 测验 1

```c
    if (list_empty(head) || list_is_singular(head))
        return;
```

如果 linked list 的节点数量为 0 或 1，此时 linked list 已经有序了，无需进行处理

```c
    struct list_head list_less, list_greater;
    INIT_LIST_HEAD(&amp;list_less);
    INIT_LIST_HEAD(&amp;list_greater);

    // struct item *pivot = list_first_entry(head, AAA, BBB);
    struct item *pivot = list_first_entry(head, struct item, list);
    list_del(&amp;pivot-&gt;list);
```

将 linked list 的第一个节点作为 pivot 分离出原 linked list，并新建两个 linked list 用于后续接收原 linked list 的节点，`less` 用于接收值 $&lt; pivot$ 的节点，而 `greater` 用于接收值 $\ge pivot$ 的节点:

- 原 linked list
```mermaid
classDiagram
    direction LR

    class item 0 {
        i: int
        list: list_head
    }
    class item 1 {
        i: int
        list: list_head
    }
    class item 2 {
        i: int
        list: list_head
    }
    class list_head {
        prev: list_head*
        next: list_head*
    }

    list_head --&gt; item 0
    list_head &lt;-- item 0
    item 0 --&gt; item 1
    item 1 --&gt; item 2
    item 1 --&gt; item 0
    item 2 --&gt; item 1
```

- 处理后
```mermaid
classDiagram
    direction LR

    class item 0 {
        i: int
        list: list_head
    }
    class item 1 {
        i: int
        list: list_head
    }
    class item 2 {
        i: int
        list: list_head
    }
    class list_head {
        prev: list_head*
        next: list_head*
    }

    pivot --&gt; item 0

    list_head --&gt; item 1
    list_head &lt;-- item 1
    item 1 --&gt; item 2
    item 1 &lt;-- item 2
```

预期想要将原 linked_list 处理成 $&lt; pivot\ |\ pivot\ | \ge pivot$ 的序列，即 `less` 获取原 linked list 中的 $&lt; pivot$ 的节点，`greater` 获取 $\ge pivot$ 的节点，这是为了满足 stable 的要求:

- [stable sorting](https://en.wikipedia.org/wiki/Sorting_algorithm#Stability)
&gt; Stable sort algorithms sort equal elements in the same order that they appear in the input. 

所以这样处理后得到的序列，所有 $=pivot$ 的节点里 `pivot` 仍然排在最前面，与原 linked list 的位置关系一致

```c
    struct item *itm = NULL, *is = NULL;
    // CCC(itm, is, head, list) {
    list_for_each_entry_safe (itm, is, head, list) {
        if (cmpint(&amp;itm-&gt;i, &amp;pivot-&gt;i) &lt; 0)
            // DDD(&amp;itm-&gt;list, &amp;list_less);
            list_move_tail(&amp;itm-&gt;list, &amp;list_less);
        else
            // EEE(&amp;itm-&gt;list, &amp;list_greater);
            list_move_tail(&amp;itm-&gt;list, &amp;list_greater);
    }
```

接下来遍历原 linked_list，依据节点和 `pivot` 的关系，使用 `list_move_tail` 将其加入 `less` 或 `greater`。这里使用 `list_move_tail` 一方面是尾插入保证了原序列的顺序关系 (符合 stable)，另一方面是它的作用是先进行移除在插入，保证了原 linked list 结构的正确性。这一步处理完成后，原 linked_list 此时为空，后续我们会将排序完成的 linked list 节点重新插入回它。

```c
    list_sort(&amp;list_less);
    list_sort(&amp;list_greater);
```

然后对 $&lt; pivot$ 的 `less` 和 $\ge pivot$ 的 `greater` 分别进行快速排序，排序完成后再处理成
$$&lt; pivot (sorted)\ |\ pivot\ | \ge pivot (sorted)$$ 

```c
    list_add(&amp;pivot-&gt;list, head);
    list_splice(&amp;list_less, head);
    // FFF(&amp;list_greater, head);
    list_splice_tail(&amp;list_greater, head);
```

即大功告成

{{&lt; admonition tip &gt;}}
关于 stable sorting，可以从 linked list 的元素全部相同的角度进行思考，例如 `l = [1 1 1]`，然后追踪该例子排序的过程。在我实作的源代码中，是通过节点的地址来判断是否满足 stable sorting 的要求的。
{{&lt; /admonition &gt;}}


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/linux2023-quiz1/  

