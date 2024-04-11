# RISC-V Optimization Guide 重点提示


&gt; The intention is to give specific actionable optimization recommendations for software developers writing code for RISC-V application processors.
&gt; 
&gt; 近日 RISE 基金会发布了一版 《RISC-V Optimization Guide》，其目的是为给 RISC-V 应用处理器编写代码的软件开发人员提供具体可行的优化建议。本次活动的主要内容是解读和讨论该文档内容。

&lt;!--more--&gt;

- {{&lt; link href=&#34;https://riscv-optimization-guide-riseproject-c94355ae3e6872252baa952524.gitlab.io/riscv-optimization-guide.html&#34; content=&#34;原文地址&#34; external-icon=true &gt;}}
- {{&lt; link href=&#34;https://riscv-optimization-guide-riseproject-c94355ae3e6872252baa952524.gitlab.io/riscv-optimization-guide.pdf&#34; content=&#34;原文 PDF&#34; external-icon=true &gt;}}
- {{&lt; link href=&#34;https://www.bilibili.com/video/BV1Ft421t7PS&#34; content=&#34;解说录影&#34; external-icon=true &gt;}}

## 相关知识

RISC-V ISA 规格书: https://riscv.org/technical/specifications/

推荐参考 [体系结构如何作用于编译器后端-邱吉](https://www.bilibili.com/video/BV1a84y1S7J7) [bilibili] 
- 这个讲座是关于微架构、指令集是怎样和编译器、软件相互协作、相互影响的 Overview
- 这个讲座介绍的是通用 CPU 并不仅限于 RISC-V 上

## Detecting RISC-V Extensions on Linux

参考以下文章构建 Linux RISC-V 然后进行原文的 `riscv_hwprobe` 系统调用实验:

- [How To Set Up The Environment for RISCV-64 Linux Kernel Development In Ubuntu 20.04](https://hackernoon.com/how-to-set-up-the-environment-for-riscv-64-linux-kernel-development-in-ubuntu-2004-si5p35kv)
- [Running 64- and 32-bit RISC-V Linux on QEMU](https://risc-v-getting-started-guide.readthedocs.io/en/latest/linux-qemu.html)

### Multi-versioning

- 最新进展: https://reviews.llvm.org/D151730
- 相关介绍: https://maskray.me/blog/2023-02-05-function-multi-versioning

## Optimizing Scalar Integer

### Materializing Constants

- RV64I 5.2 Integer Computational Instructions

&gt; Additional instruction variants are provided to manipulate 32-bit values in RV64I, indicated by a ‘W’ suffix to the opcode.
&gt; 
&gt; These “*W” instructions ignore the upper 32 bits of their inputs and always produce 32-bit signed values, i.e. bits XLEN-1 through 31 are equal.

&gt; ADDIW is an RV64I instruction that adds the sign-extended 12-bit immediate to register rs1 and produces the proper sign-extension of a 32-bit result in rd.

原文 Prefer idiomatic LUI/ADDI sequence for 32 bit constants 部分使用 `lui` 和 `addiw` 构建 0x1fffff 的说明比较晦涩难懂 (~~说实话我没看懂原文的 addiw 为什么需要减去 4096 :innocent:~~)

{{&lt; admonition &gt;}}
根据下面的参考文章，如果 `addiw` 的立即数的 MSB 被置为 1 时，只需在 `lui` 时多加一个 1 即可构建我们想要的 32-bit 数值。而原文中除了对 `lui` 加 1 外，还对 `addiw` 进行减去 4096 的操作:
```asm
addiw a0, a0, (0xfff - 4096)  ; addiw a0, a0, -1
```
这乍一看不知道为何需要减去 4096，其实本质很简单，根据上面的 ISA manual `addiw` 的立即数是 12-bit 的 signed number，即应该传入的是数值。但是直接使用 0xfff 表示传入的仅仅是 0xfff 这个编码对应的数值 (可以表示 12-bit signed 下的数值 -1，也可以表示 unsigned 编码下 0xfff 对应的数值 4095，在 12-bit signed 下 integer overflow)，为了保证 `addiw` 的立即数的数值符合我们的预期 (即 0xfff 在 12-bit signed 下数值是 -1) 以及避免 integer overflow，所以需要将 0xfff - 4096 得到 12-bit signed 数值 -1 (虽然这个编码和 0xfff 是一样的...)。

```asm
addiw a0, a0, -1    ; right
addiw a0, a0, 4095  ; integer overflow
```

- [解读计算机编码]({{&lt; relref &#34;../sysprog/binary-representation.md&#34; &gt;}})
- [C 语言: 数值系统篇]({{&lt; relref &#34;../sysprog/c-numerics.md&#34; &gt;}})
- [RV32G 下 lui/auipc 和 addi 结合加载立即数时的补值问题](https://zhuanlan.zhihu.com/p/374235855) [zhihu]
- [RISC-V build 32-bit constants with LUI and ADDI](https://stackoverflow.com/questions/50742420/risc-v-build-32-bit-constants-with-lui-and-addi) [Stack Overflow]
{{&lt; /admonition &gt;}}

原文 Fold immediates into consuming instructions where possible 部分，相关的 RISC-V 的 imm 优化:

- Craig Topper: [2022 LLVM Dev Mtg: RISC-V Sign Extension Optimizations](https://www.youtube.com/watch?v=TmWs3QsSuUg)
- [改进RISC-V的代码生成-廖春玉](https://www.bilibili.com/video/BV1pN411H7Y3) [bilibili]

### Avoid branches using conditional moves

[Zicond extension](https://github.com/riscv/riscv-zicond/releases/tag/v1.0) 提供了我们在 RISC-V 上实作常数时间函数 (contant-time function) 的能力，用于避免分支预测，从而减少因分支预测失败带来的高昂代价。

{{&lt; raw &gt;}}
$$
a0 = 
\begin{cases}
constant1 &amp; \text{if } x \neq 0 \newline
constant2 &amp; \text{if } x = 0
\end{cases}
$$
{{&lt; /raw &gt;}}

原文使用了 CZERO.NEZ，下面我们使用 CZERO.EQZ 来实作原文的例子:

```asm
li t2, constant2
li t3, (constant1 - constant2)
CZERO.EQZ t3, t3, a0
add a0, t3, t2
```

原文也介绍了如何使用 seqz 来实作 constant-time function，下面使用 snez 来实作原文的例子:

```asm
li t2, constant1
li t3, constant2
snez t0, a0
addi t0, t0, -1
xor t1, t2, t3
and t1, t1, t0
xor a0, t1, t2
```

如果有 \‘M\’ 扩展可以通过 `mul` 指令进行简化 (通过 snez 来实作原文例子):

```asm
li t2, constant1
li t3, constant2
xor t1, t2, t3
snez t0, a0
mul t1, t1, t0
xor a0, t1, t3
```

### Padding

&gt; Use canonical NOPs, NOP ( ADDI X0, X0, 0 ) and C.NOP ( C.ADDI X0, 0 ), to add padding within a function. Use the canonical illegal instruction ( either 2 or 4 bytes of zeros depending on whether the C extension is supported ) to add padding between functions.

- 因为在函数内部的执行频率高，使用合法的 NOPs 进行对齐 padding，防止在乱序执行时，流水线在遇见非法指令后就不再执行后续指令，造成效能损失
- 如果控制流被传递到两个函数之间，那么加大可能是程序执行出错了，使用非法的指令进行对齐 padding 可以帮助我们更好更快地 debug

### Align char array to greater alignment

Why use wider load/store usage for memory copy?
- [C 语言: 内存管理、对齐及硬体特性](https://hackmd.io/@sysprog/c-memory)

### Use shifts to clear leading/trailing bits

实作 64-bit 版本的原文例子 (retain the highest 12 bits):

```asm
slli x6, x5, 52
slri x7, x5, 52
```

- RV64I 5.2 Integer Computational Instructions
&gt; LUI (load upper immediate) uses the same opcode as RV32I. LUI places the 20-bit U-immediate into bits 31–12 of register rd and places zero in the lowest 12 bits. The 32-bit result is sign-extended to 64 bits.

## Optimizing Scalar Floating Point

## Optimizing Vector

What about vector instructions? 
- YouTube: [Introduction to SIMD](https://www.youtube.com/watch?v=o_n4AKwdfiA)
- [Introduction to the RISC-V Vector Extension](https://eupilot.eu/wp-content/uploads/2022/11/RISC-V-VectorExtension-1-1.pdf) [PDF]
- 2020 RISC-V Summit: [Tutorial: RISC-V Vector Extension Demystified](https://www.youtube.com/watch?v=oTaOd8qr53U)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/riscv-optimization-guide/  

