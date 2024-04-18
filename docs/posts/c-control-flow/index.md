# 你所不知道的 C 语言: goto 和流程控制篇


> goto 在 C 語言被某些人看做是妖魔般的存在，不過實在不用這樣看待，至少在 Linux 核心原始程式碼中，goto 是大量存在 (跟你想像中不同吧)。有時不用 goto 會寫出更可怕的程式碼。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-control-flow" content="原文地址" external-icon=true >}}

Stack Overflow: [GOTO still considered harmful?](https://stackoverflow.com/questions/46586/goto-still-considered-harmful)

## MISRA C

[MISRA-C:2004](https://caxapa.ru/thumbs/468328/misra-c-2004.pdf) Guidelines for the use of the C language in critical systems

MISRA C 禁用 `goto` 和 `continue`，但可用 `break`:

- **Rule 14.4 (required): The goto statement shall not be used.**
- **Rule 14.5 (required): The continue statement shall not be used.**
- **Rule 14.6 (required): For any iteration statement there shall be at most one break statement used for loop termination.**

> These rules are in the interests of good structured programming. One break statement is allowed in a loop since this allows, for example, for dual outcome loops or for optimal coding.

Stack Overflow 上的相关讨论:

- [Why "continue" is considered as a C violation in MISRA C:2004?](https://stackoverflow.com/questions/10975722/why-continue-is-considered-as-a-c-violation-in-misra-c2004)

使用 goto 可能会混淆静态分析的工具 (当然使用 goto 会极大可能写出 ugly 的程式码):

> Case in point: MISRA C forbids goto statements primarily because it can mess up static analysis. Yet this rule is gratuitously followed even when no static analysis tools are used, thus yielding none of the gains that you trade off for occasionally writing ugly code.

## GOTO 没有想象中那么可怕

虽然 MISRA C 这类规范都明确禁止了使用 goto，但 goto 并没有想像中的那么可怕，在一些领域还是极具活力的。

在 C 语言中 goto 语句是实作错误处理的极佳选择 (如果你看过 xv6 应该不陌生)，有时不用 `goto` 可能会写出更可怕的程式码:

- [x] [Using goto for error handling in C](http://eli.thegreenplace.net/2009/04/27/using-goto-for-error-handling-in-c)

Wikipedia: [RAII](https://en.wikipedia.org/wiki/Resource_acquisition_is_initialization)
> C requires significant administrative code since it doesn't support exceptions, try-finally blocks, or RAII at all. A typical approach is to separate releasing of resources at the end of the function and jump there with gotos in the case of error. This way the cleanup code need not be duplicated.

相关实作:

- [goto 在 Linux 核心广泛应用](https://github.com/torvalds/linux/search?utf8=%E2%9C%93&q=goto)
- [OpenBSD's httpd](https://github.com/reyk/httpd/blob/master/httpd/httpd.c#L564)
- Linux kernel 里 NFS inode 验证的函数: [fs/nfs/inode.c](https://github.com/torvalds/linux/blob/v5.15/fs/nfs/inode.c)

> 以 `goto` 为关键字进行检索

Wikipedia: [Common usage patterns of Goto](https://en.wikipedia.org/wiki/Goto#Common_usage_patterns)
- To make the code more readable and easier to follow
- Error handling (in absence of exceptions), particularly cleanup code such as resource deallocation.

## switch & goto

`switch` 通过 jump table 的内部实作可以比大量的 `if-else` 效率更高。

- [x] GCC: [6.3 Labels as Values](https://gcc.gnu.org/onlinedocs/gcc/Labels-as-Values.html)
> You can get the address of a label defined in the current function (or a containing function) with the unary operator ‘&&’. The value has type void *.
> 
> To use these values, you need to be able to jump to one. This is done with the computed goto statement6, goto *exp;.

下面这篇文章以 VM 为例子对 `computed goto`  和 `switch` 的效能进行了对比 (之前学的 RISC-V 模拟器派上用场了hhh):

- [x] [Computed goto for efficient dispatch tables](https://eli.thegreenplace.net/2012/07/12/computed-goto-for-efficient-dispatch-tables)
> the condition serves as an offset into a lookup table that says where to jump next.
> 
> To anyone with a bit of experience with assembly language programming, the computed goto immediately makes sense because it just exposes a common instruction that most modern CPU architectures have - jump through a register (aka. indirect jump).

{{< admonition >}}
`computed goto`  比 `switch` 效能更高的原因:
1. The switch does a bit more per iteration because of bounds checking.
2. The effects of hardware branch prediction.

C99:
{{< admonition quote >}}
If no converted case constant expression matches and there is no default label, no part of the switch body is executed. 
{{< /admonition >}}

因为标准的这个要求，所以编译器对于 `switch` 会生成额外的 safe 检查代码，以符合上面情形的 "no part of the switch body is executed" 的要求。

{{< admonition quote >}}
Since the switch statement has a single "master jump" that dispatches all opcodes, predicting its destination is quite difficult. On the other hand, the computed goto statement is compiled into a separate jump per opcode, so given that instructions often come in pairs it's much easier for the branch predictor to "home in" on the various jumps correctly.
{{< /admonition >}}

I can't say for sure which one of the two factors weighs more in the speed difference between the switch and the computed goto, but if I had to guess I'd say it's the branch prediction.
{{< /admonition >}}

> bounds checking 是在 switch 中執行的一個環節，每次迴圈中檢查是否有 default case 的狀況，即使程式中的 switch 沒有用到 default case，編譯期間仍會產生強制檢查的程式，所以 switch 會較 computed goto 多花一個 bounds checking 的步驟

> branch prediction 的部分，switch 需要預測接下來跳到哪個分支 case，而 computed goto 則是在每個 instruction 預測下一個 instruction，這之中比較直覺的想法是 computed goto 的prediction可以根據上個指令來預測，但是 switch 的prediction每次預測沒辦法根據上個指令，因此在 branch prediction accuracy 上 computed goto 會比較高。

所以在实际中大部分也是采取 computed goto 来实作 VM:
- Ruby 1.9 (YARV): also uses computed goto.
- Dalvik (the Android Java VM): computed goto
- Lua 5.2: uses a switch

## do {...} while (0) 宏

**用于避免 dangling else，即 if 和 else 未符合预期的配对 (常见于未使用 `{}` 包裹)**

- [x] Stack Overflow: [C multi-line macro: do/while(0) vs scope block](https://stackoverflow.com/questions/1067226/c-multi-line-macro-do-while0-vs-scope-block)

我写了 [相关笔记]({{< relref "./c-preprocessor/#do----while-0-%E5%AE%8F" >}}) 记录在前置处理器篇。

## 用 goto 实作 RAII 开发风格

- [x] [RAII in C](https://vilimpoc.org/research/raii-in-c/)
> If you have functions or control flows that allocate resources and a 
> failure occurs, then goto turns out to be one of the nicest ways to 
> unwind all resources allocated before the point of failure. 

Linux 核心中的实作:
- [shmem.c](https://github.com/torvalds/linux/blob/master/mm/shmem.c)
> 以 `goto` 为关键字进行检索

## 检阅 C 语言规格书

- [ISO/IEC 9899:201x Committee Draft](http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf) 6.8.6 Jump statements
> A jump statement causes an unconditional jump to another place.
> 
> The identifier in a goto statement shall name a label located somewhere in the enclosing function. A goto statement shall not jump from outside the scope of an identifier having a variably modified type to inside the scope of that identifier.

规格书后面的例子也值得一看 (特别是当你看不懂规格书严格的英语语法想表达什么的时候 :rofl:)

相关实作:
- CPython 的 [Modules/_asynciomodule.c](https://github.com/python/cpython/blob/main/Modules/_asynciomodule.c#L1711)
> 以 `goto` 为关键字进行检索

[Modern C](https://gustedt.gitlabpages.inria.fr/modern-c/) 作者也总结了 3 项和 `goto` 相关的规范 (大可不必视 `goto` 为洪水猛兽，毕竟我们有规范作为指导是不是):
- Rule 2.15.0.1: Labels for goto are visible in the whole function that contains them.
- Rule 2.15.0.2: goto can only jump to a label inside the same function.
- Rule 2.15.0.3: goto should not jump over variable initializations.

## 和想象中不同的 switch-case

`switch-case` 语句中的 case 部分本质上是 label，所以使用其它语句 (例如 `if`) 将其包裹起来并不影响 `switch` 语句的跳转。

- [Something You May Not Know About the Switch Statement in C/C++](https://www.codeproject.com/Articles/100473/Something-You-May-Not-Know-About-the-Switch-Statem)
- [How to Get Fired Using Switch Statements & Statement Expressions](http://blog.robertelder.org/switch-statements-statement-expressions/)

## Duff's Device

> 这个技巧常用于内存数据的复制，类似于 `memcpy`

- [ ] Wikipedia: [Duff's Device](https://en.wikipedia.org/wiki/Duff%27s_device)
- [ ] [Duff's Device 的详细解释](http://c-faq.com/misc/duffexpln.html)
- [ ] [Tom Duff 本人的解释](http://doc.cat-v.org/bell_labs/duffs_device)

## co-routine 应用

Wikipedia: [Coroutine](https://en.wikipedia.org/wiki/Coroutine)

不借助操作系统也可以实作出多工交执行的 illusion (通过 `switch-case` 黑魔法来实现 :rofl:)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-control-flow/  

