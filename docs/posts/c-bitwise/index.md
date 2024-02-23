# C Bitwise


<!--more-->

位运算满足交换律，但逻辑运算并不满足交换律，因为短路机制。考虑 Linked list 中的情形:

```c
// list_head *head
if (!head || list_empty(head))
if (list_empty(head) || !head)
```

第二条语句在执行时会报错，因为 `list_empty` 要求传入的参数不为 NULL

程序语言只提供最小粒度为 Byte 的操作，但是不直接提供 Bit 粒度的操作，这与字节顺序相关。假设提供以 Bit 为粒度的操作，这就需要在编程时考虑大段、小端模式，极其繁琐。


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-bitwise/  

