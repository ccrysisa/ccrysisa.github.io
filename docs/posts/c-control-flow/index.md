# 你所不知道的 C 语言: goto 和流程控制篇


&gt; goto 在 C 語言被某些人看做是妖魔般的存在，不過實在不用這樣看待，至少在 Linux 核心原始程式碼中，goto 是大量存在 (跟你想像中不同吧)。有時不用 goto 會寫出更可怕的程式碼。

&lt;!--more--&gt;

- {{&lt; link href=&#34;https://hackmd.io/@sysprog/c-control-flow&#34; content=&#34;原文地址&#34; external-icon=true &gt;}}

Stack Overflow: [GOTO still considered harmful?](https://stackoverflow.com/questions/46586/goto-still-considered-harmful)

## MISRA C

[MISRA-C:2004](https://caxapa.ru/thumbs/468328/misra-c-2004.pdf) Guidelines for the use of the C language in critical systems

MISRA C 禁用 `goto` 和 `continue`，但可用 `break`:

- **Rule 14.4 (required): The goto statement shall not be used.**
- **Rule 14.5 (required): The continue statement shall not be used.**
- **Rule 14.6 (required): For any iteration statement there shall be at most one break statement used for loop termination.**

&gt; These rules are in the interests of good structured programming. One break statement is allowed in a loop since this allows, for example, for dual outcome loops or for optimal coding.

Stack Overflow 上的相关讨论:

- [Why &#34;continue&#34; is considered as a C violation in MISRA C:2004?](https://stackoverflow.com/questions/10975722/why-continue-is-considered-as-a-c-violation-in-misra-c2004)

使用 goto 可能会混淆静态分析的工具 (当然使用 goto 会极大可能写出 ugly 的程式码):

&gt; Case in point: MISRA C forbids goto statements primarily because it can mess up static analysis. Yet this rule is gratuitously followed even when no static analysis tools are used, thus yielding none of the gains that you trade off for occasionally writing ugly code.

## GOTO 没有想象中那么可怕

虽然 MISRA C 这类规范都明确禁止了使用 goto，但 goto 并没有想像中的那么可怕，在一些领域还是极具活力的。

在 C 语言中 goto 语句是实作错误处理的极佳选择 (如果你看过 xv6 应该不陌生):

- [ ] [Using goto for error handling in C](http://eli.thegreenplace.net/2009/04/27/using-goto-for-error-handling-in-c)

&gt; 以 `setjmp` 为关键字进行检索

相关实作:

- [goto 在 Linux 核心广泛应用](https://github.com/torvalds/linux/search?utf8=%E2%9C%93&amp;q=goto)
- [OpenBSD&#39;s httpd](https://github.com/reyk/httpd/blob/master/httpd/httpd.c#L564)
- Linux kernel 里 NFS inode 验证的函数: [fs/nfs/inode.c](https://github.com/torvalds/linux/blob/v5.15/fs/nfs/inode.c)

&gt; 以 `goto` 为关键字进行检索

Wikipedia: [Common usage patterns of Goto](https://en.wikipedia.org/wiki/Goto#Common_usage_patterns)

## switch &amp; goto

- [Computed goto for efficient dispatch tables](https://eli.thegreenplace.net/2012/07/12/computed-goto-for-efficient-dispatch-tables)

效能对比:
- bounds checking
- branch prediction

&gt; bounds checking 是在 switch 中執行的一個環節，每次迴圈中檢查是否有 default case 的狀況，即使程式中的 switch 沒有用到 default case，編譯期間仍會產生強制檢查的程式，所以 switch 會較 computed goto 多花一個 bounds checking 的步驟

&gt; branch prediction 的部分，switch 需要預測接下來跳到哪個分支 case，而 computed goto 則是在每個 instruction 預測下一個 instruction，這之中比較直覺的想法是 computed goto 的prediction可以根據上個指令來預測，但是 switch 的prediction每次預測沒辦法根據上個指令，因此在 branch prediction accuracy 上 computed goto 會比較高。

## do {...} while (0) 宏

**用于避免 dangling else，即 if 和 else 未符合预期的配对 (常见于未使用 `{}` 包裹)**

- [x] Stack Overflow: [C multi-line macro: do/while(0) vs scope block](https://stackoverflow.com/questions/1067226/c-multi-line-macro-do-while0-vs-scope-block)

我写了 [相关笔记]({{&lt; relref &#34;./c-preprocessor/#do----while-0-%E5%AE%8F&#34; &gt;}}) 记录在前置处理器篇。

## 用 goto 实作 RAII 开发风格

- [ ] [RAII in C](https://vilimpoc.org/research/raii-in-c/)

Linux 核心中的实作:
- [shmem.c](https://github.com/torvalds/linux/blob/master/mm/shmem.c)

## 检阅 C 语言规格书

- [ISO/IEC 9899:201x Committee Draft](http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf)

## 和想象中不同的 switch-case

`switch-case` 语句中的 case 部分本质上是 label，所以使用其它语句 (例如 `if`) 将其包裹起来并不影响 `switch` 语句的跳转。

- [Something You May Not Know About the Switch Statement in C/C&#43;&#43;](https://www.codeproject.com/Articles/100473/Something-You-May-Not-Know-About-the-Switch-Statem)
- [How to Get Fired Using Switch Statements &amp; Statement Expressions](http://blog.robertelder.org/switch-statements-statement-expressions/)

## Duff&#39;s Device

&gt; 这个技巧常用于内存数据的复制，类似于 `memcpy`

- [ ] Wikipedia: [Duff&#39;s Device](https://en.wikipedia.org/wiki/Duff%27s_device)
- [ ] [Duff&#39;s Device 的详细解释](http://c-faq.com/misc/duffexpln.html)
- [ ] [Tom Duff 本人的解释](http://doc.cat-v.org/bell_labs/duffs_device)

## co-routine 应用

Wikipedia: [Coroutine](https://en.wikipedia.org/wiki/Coroutine)

不借助操作系统也可以实作出多工交执行的 illusion (通过 `switch-case` 黑魔法来实现 :rofl:)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-control-flow/  

