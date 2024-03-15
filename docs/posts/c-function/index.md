# 你所不知道的 C 语言: 函数呼叫篇


> 本講座將帶著學員重新探索函式呼叫背後的原理，從程式語言和計算機結構的發展簡史談起，讓學員自電腦軟硬體演化過程去掌握 calling convention 的考量，伴隨著 stack 和 heap 的操作，再探討 C 程式如何處理函式呼叫、跨越函式間的跳躍 (如 [setjmp](https://man7.org/linux/man-pages/man3/setjmp.3.html) 和 [longjmp](https://linux.die.net/man/3/longjmp))，再來思索資訊安全和執行效率的議題。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-function" content="原文地址" external-icon=true >}}

## function prototype

- [ ] [Very early C compilers and language](https://www.bell-labs.com/usr/dmr/www/primevalC.html)
> 一个小故事，可以解释 C 语言的一些设计理念，例如 `switch-case` 中每个 case 都需要 `break`
- [ ] [The Development of the C Language](https://www.bell-labs.com/usr/dmr/www/chist.html)
> Dennis M. Ritchie 讲述 C 语言漫长的发展史，并搭配程式码来说明当初为何如此设计、取舍考量。了解这些历史背景可以让我们成为更专业的 C 语言 Programmer
- [ ] [Rationale for International Standard – Programming Languages – C](https://pllab.cs.nthu.edu.tw/cs340402/readings/c/c9x_standard.pdf)
> 讲述 C 语言标准的变更，并搭配程式码解释变更的原理和考量

在早期的 C 语言中，并不需要 function prototype，因为当编译器发现一个函数名出现在表达式并且后面跟着左括号 `(`，例如 `a = func(...)`，就会将该函数解读为：返回值类型预设为 `int`，参数类型和个数由调用者提供来决定，按照这样规则编写程式码，可以在无需事先定义函数即可先写调用函数的逻辑。但是这样设计也会造成潜在问题：程序员在调用函数时需要谨慎处理，需要自己检查调用时的参数类型和个数符合函数定义 (因为当时的编译器无法正确判断调用函数时的参数是否符合预期的类型和个数，当时编译器的能力与先前提到的规则是一体两面)，并且返回值类型预设为 `int` (当时还没有 `void` 类型)，所以对于函数返回值，也需要谨慎处理。

显然 function prototype 的缺失导致程式码编写极其容易出错，所以从 C99 开始就规范了 function prototype，这个规范除了可以降低 programmer 心智负担之外，还可以提高程序效能。编译器的最佳化阶段 (optimizer) 可以通过 function prototype 来得知内存空间的使用情形，从而允许编译器在**函数调用表达式的上下文**进行激进的最佳化策略，例如 `const` 的使用可以让编译器知道只会读取内存数据而不会修改内存数据，从而没有 side effect，可以进行激进的最优化。

```c
int compare(const char *string1, const char *string2);

void func2(int x) {
    char *str1, *str2;
    // ...
    x = compare(str1, str2);
    // ...
}
```

> Rust 的不可变引用也是编译器可以进行更激进的最优化处理的一个例子

## 编程语言的 function

C 语言不允许 nested function 以简化编译器的设计 (当然现在的 gcc 提供 nested funtion 的扩展)，即 C 语言的 function 是一等公民，位于语法最顶层 (top-level)，因为支持 nested function 需要 staic link 机制来确认外层函数。

编程语言中的函数，与数学的函数不完全一致，编程语言的函数隐含了状态机的转换过程 (即有 side effect)，只有拥有 Referential Transparency 特性的函数，才能和数学上的函数等价。

## Process 与 C 程序

***程序存放在磁盘时叫 Program，加载到内存后叫 "Process"***

{{< image src="https://imgur-backup.hackmd.io/DpZOmhb.png" >}}

- Wikipedia: [Application binary interface](https://en.wikipedia.org/wiki/Application_binary_interface)
> In computer software, an application binary interface (ABI) is an interface between two binary program modules. Often, one of these modules is a library or operating system facility, and the other is a program that is being run by a user.

在 Intel x86 架构中，当返回值可以放在寄存器时就放在寄存器中返回，以提高效能，如果放不下，则将返回值的起始地址放在寄存器中返回。

## Stack

### Layout

{{< image src="https://imgur-backup.hackmd.io/S5QUT5I.png" >}}

[System V Application Binary Interface AMD64 Architecture Processor Supplement](https://github.com/hjl-tools/x86-psABI/wiki/x86-64-psABI-1.0.pdf) [PDF]

{{< image src="https://imgur-backup.hackmd.io/Fec7Vyx.png" >}}

### PEDA

实验需要使用到 GDB 的 PEDA 扩展:

> Enhance the display of gdb: colorize and display disassembly codes, registers, memory information during debugging.

```bash
$ git clone https://github.com/longld/peda.git ~/peda
$ echo "source ~/peda/peda.py" >> ~/.gdbinit
```

{{< admonition tip >}}
动态追踪 Stack 实验的 call funcA 可以通过 GDB 指令 `stepi` 或 `si` 来实现
{{< /admonition >}}

### stack-based buffer overflow

## ROP

## heap

使用 malloc 时操作系统可能会 overcommit，而正因为这个 overcommit 的特性，malloc 返回有效地址也不见得是安全的。除此之外，因为 overcommit，使用 malloc 后立即搭配使用 memset 代价也很高 (因为操作系统 overcommit 可能会先分配一个小空间而不是一下子分配全部，因为它优先重复使用之前已使用过的小块空间)，并且如果是设置为 0，则有可能会对原本为 0 的空间进行重复设置，降低效能。此时可以应该善用 calloc，虽然也会 overcommit，但是会保证分配空间的前面都是 0 (因为优先分配的是需要操作系统参与的大块空间)，无需使用 memset 这类操作而降低效能。

### malloc / free

## RAII

## setjmp & longjmp


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-function/  

