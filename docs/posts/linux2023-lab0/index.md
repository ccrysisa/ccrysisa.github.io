# Linux 核心设计: C Programming Lab


<!--more-->

## 预期目标 + 开发环境设置

### 程序分析工具

- [Cppcheck](https://cppcheck.sourceforge.io/) 是 **静态** 程序分析工具，即无需运行程序就可以分析出程序潜在的问题，当然会有一定的误差，类似的工具有 [cargo-check](https://doc.rust-lang.org/cargo/commands/cargo-check.html)

- [Valgrind](https://valgrind.org/) 是 **动态** 程序分析工具，即需要将程序运行起来再进行分析，通常用于检测内存泄漏 ([memory leak](https://en.wikipedia.org/wiki/Memory_leak))

### Queue

相关的 LeetCode 题目的实作情况:

- [x] [LeetCode 2095. Delete the Middle Node of a Linked List](https://leetcode.com/problems/delete-the-middle-node-of-a-linked-list/)
- [x] [LeetCode 82. Remove Duplicates from Sorted List II](https://leetcode.com/problems/remove-duplicates-from-sorted-list-ii/)
- [x] [LeetCode 24. Swap Nodes in Pairs](https://leetcode.com/problems/swap-nodes-in-pairs/)
- [x] [LeetCode 25. Reverse Nodes in k-Group](https://leetcode.com/problems/reverse-nodes-in-k-group/)
- [x] [LeetCode 2487. Remove Nodes From Linked List](https://leetcode.com/problems/remove-nodes-from-linked-list/) / [参考题解](https://leetcode.com/problems/remove-nodes-from-linked-list/solutions/4188092/simple-easy-cpp-solution-with-explanation/)
- [x] [LeetCode 23. Merge k Sorted Lists](https://leetcode.com/problems/merge-k-sorted-lists/)

`q_free` 在遍历时需要释放当前节点所在元素的空间，所以需要使用 `list_for_each_entry_safe`，而 `q_size` 无需在遍历时修改当前节点，所以使用 `list_for_each` 就足够了。


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/linux2023-lab0/  

