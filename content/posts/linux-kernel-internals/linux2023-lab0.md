---
title: "Linux 核心设计: C Programming Lab"
subtitle:
date: 2024-02-19T16:23:01+08:00
# draft: true
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

## 程序分析工具

- [Cppcheck](https://cppcheck.sourceforge.io/) 是 **静态** 程序分析工具，即无需运行程序就可以分析出程序潜在的问题，当然会有一定的误差，类似的工具有 [cargo-check](https://doc.rust-lang.org/cargo/commands/cargo-check.html)

- [Valgrind](https://valgrind.org/) 是 **动态** 程序分析工具，即需要将程序运行起来再进行分析，通常用于检测内存泄漏 ([memory leak](https://en.wikipedia.org/wiki/Memory_leak))

## Queue

### leetcode

相关的 LeetCode 题目的实作情况:

- [x] [LeetCode 2095. Delete the Middle Node of a Linked List](https://leetcode.com/problems/delete-the-middle-node-of-a-linked-list/)
- [x] [LeetCode 82. Remove Duplicates from Sorted List II](https://leetcode.com/problems/remove-duplicates-from-sorted-list-ii/)
- [x] [LeetCode 24. Swap Nodes in Pairs](https://leetcode.com/problems/swap-nodes-in-pairs/)
- [x] [LeetCode 25. Reverse Nodes in k-Group](https://leetcode.com/problems/reverse-nodes-in-k-group/)
- [x] [LeetCode 2487. Remove Nodes From Linked List](https://leetcode.com/problems/remove-nodes-from-linked-list/) / [参考题解](https://leetcode.com/problems/remove-nodes-from-linked-list/solutions/4188092/simple-easy-cpp-solution-with-explanation/)
- [x] [LeetCode 23. Merge k Sorted Lists](https://leetcode.com/problems/merge-k-sorted-lists/)

### q_new & q_free

- `q_new` 使用 `malloc` 分配空间，并使用 `INIT_LIST_HEAD` 进行初始化。
- `q_free` 遍历 queue 进行逐个节点释放，所以需要使用 `_safe` 后缀的 for_each 宏，释放时需要先释放成员 `value`，再释放节点 (回想一下 C++ 的析构函数)，可以直接使用 `q_release_element` 函数。

> `q_free` 在遍历时需要释放当前节点所在元素的空间，所以需要使用 `list_for_each_entry_safe`，而 `q_size` 无需在遍历时修改当前节点，所以使用 `list_for_each` 就足够了。

### q_insert & q_remove

insert 时需要特判 head 是否为 NULL 以及 malloc 分配是否成功，接下来需要使用 `strdup` 对所给参数进行复制 (`strdup` 内部是通过 `malloc` 来实现的，所以之前 `q_free` 时也需要是否 `value`)，最后根据插入的位置调用 `list_add` 或 `list_add_tail` 进行插入。

remove 时需要特判 head 是否为 NULL 以及 queue 是否为空，接下来根据需要 remove 的节点调用 `list_first_entry` 或 `list_last_entry` 获取节点对应的元素，通过 `list_del_init` 来清除出 queue，最后如果 `value` 字段不为 NULL，则通过 `memcpy` 将 `value` 字段对应的字符串复制到指定位置。

## Valgrind

- 2007 年的论文: [Valgrind: A Framework for Heavyweight Dynamic Binary Instrumentation](https://valgrind.org/docs/valgrind2007.pdf)
- 繁体中文版本的 [论文导读](https://wdv4758h-notes.readthedocs.io/zh_TW/latest/valgrind/dynamic-binary-instrumentation.html)

memory lost:
- definitely lost
- indirectly lost
- possibly lost
- still readchable

运行 valgrind 和 gdb 类似，都需要使用 `-g` 参数来编译 C/C++ 源程序以生成调试信息，然后还可以通过 `-q` 参数指示 valgrind 进入 quite 模式，减少启动时信息的输出。

```bash
$ valgrind -q --leak-check=full ./case1
```

- `--leak-check=full`: 启用全面的内存泄漏检查，valgrind 将会报告所有的内存泄漏情况，包括详细的堆栈跟踪信息
- `--show-possibly-lost=no`: 不输出 possibly lost 相关报告
- `--track-fds=yes`: 侦测 file descriptor 开了没关的情况

> valgrind 输出的报告 invalid write/read 这类的单位是 Byte，即 size of X (bytes)

程序运行时内存布局:

{{< image src="https://i.imgur.com/OhqUECc.png" >}}

{{< admonition info >}}
- [Valgrind User Manual](https://valgrind.org/docs/manual/manual.html)
- [Massif: a heap profiler](https://valgrind.org/docs/manual/ms-manual.html)
{{< /admonition >}}

## 自动测试

### 追踪内存的分配和释放

- [x] Wikipedia: [Hooking](https://en.wikipedia.org/wiki/Hooking)
- [x] Wikipedia: [Test harness](https://en.wikipedia.org/wiki/Test_harness)
- [x] GCC: [Arrays of Length Zero](https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html)
> The alignment of a zero-length array is the same as the alignment of its elements.

{{< image src="https://imgur-backup.hackmd.io/j1fRN0B.png" >}}

相关源代码阅读 (harness.h, harness.c):
- `test_malloc()`
- `test_free()`
- `test_calloc()`
- `find_footer()`
- `find_header()`

### qtest 命令解释器

新增指令 hello，用于打印 `Hello, world"` 的信息。调用流程:
```
main → run_console → cmd_select → interpret_cmd → parse_args
                                                → interpret_cmda → do_hello
```

相关源代码阅读 (console.h, console.c):
- `init_cmd()`
- `ADD_COMMADN`
- `add_cmd()`

### Signal

- [signal(2) — Linux manual page](https://man7.org/linux/man-pages/man2/signal.2.html)
> signal() sets the disposition of the signal signum to handler, which is
> either SIG_IGN, SIG_DFL, or the address of a  programmer-defined  func‐
> tion (a "signal handler").

- [setjmp(3) — Linux manual page](https://man7.org/linux/man-pages/man3/longjmp.3.html)
> The functions described on this page are used for performing
> "nonlocal gotos": transferring execution from one function to a
> predetermined location in another function.  The setjmp()
> function dynamically establishes the target to which control will
> later be transferred, and longjmp() performs the transfer of
> execution.

Why use `sigsetjmp()`/`siglongjmp()` instead of `setjmp()`/`longjmp()`? 

- [The Linux Programming Interface](https://man7.org/tlpi/)

> The sa_mask field allows us to specify a set of signals that aren’t permitted to interrupt execution of this handler. In addition, the signal that caused the handler to be invoked is automatically added to the process signal mask. This means that a signal handler won’t recursively interrupt itself if a second instance of the same signal arrives while the handler is executing.

> However, there is a problem with using the standard longjmp() function to exit from a signal handler. We noted earlier that, upon entry to the signal handler, the kernel automatically adds the invoking signal, as well as any signals specified in the act.sa_mask field, to the process signal mask, and then removes these signals from the mask when the handler does a normal return.
> 
> What happens to the signal mask if we exit the signal handler using longjmp()? The answer depends on the genealogy of the particular UNIX implementation.

- `jmp_ready` 技巧 (用于保证在 `siglongjmp()` 之前必然执行过一次 `sigsetjmp()`):
> Because a signal can be generated at any time, it may actually occur before the target of the goto has been set up by sigsetjmp() (or setjmp()). To prevent this possibility (which would cause the handler to perform a nonlocal goto using an uninitialized env buffer), we employ a guard variable, canJump, to indicate whether the env buffer has been initialized. If canJump is false, then instead of doing a nonlocal goto, the handler simply returns.

相关源代码阅读:
- qtest.c
  - `q_init()`
  - `sigsegv_handler()`
  - `sigalrm_handler()`
- harness.c
  - `trigger_exception()`
  - `exception_setup()`
