---
title: "你所不知道的 C 语言: goto 和流程控制篇"
subtitle:
date: 2024-04-05T11:39:34+08:00
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
  - C
  - Control flow
categories:
  - C
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

`computed goto`  比 `switch` 效能更高的原因:
1. The switch does a bit more per iteration because of bounds checking.
2. The effects of hardware branch prediction.

C99:
> If no converted case constant expression matches and there is no default label, no part of the switch body is executed. 

因为标准的这个要求，所以编译器对于 `switch` 会生成额外的 safe 检查代码，以符合上面情形的 "no part of the switch body is executed" 的要求。

> Since the switch statement has a single "master jump" that dispatches all opcodes, predicting its destination is quite difficult. On the other hand, the computed goto statement is compiled into a separate jump per opcode, so given that instructions often come in pairs it's much easier for the branch predictor to "home in" on the various jumps correctly.

作者提到，ta 个人认为分支预测是导致效能差异的主要因素:

> I can't say for sure which one of the two factors weighs more in the speed difference between the switch and the computed goto, but if I had to guess I'd say it's the branch prediction.

除此之外，有这篇文章的 disassembly 部分可以得知，`switch` 的底层是通过所谓的 jump table 来实作的:

{{< admonition quote >}}
How did I figure out which part of the code handles which opcode? Note that the "table jump" is done with:
```
jmpq   *0x400b20(,%rdx,8)
```
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

从规格书中也可以得知，`goto` 虽然是无条件跳转 (对应汇编语言的 `jmp` 这类无条件跳转指令)，但它的跳转范围是有限制的 (jump to another place)，而不是可以跳转到任意程式码 (这也是为什么 `setjmp/longjmp` 被称为「长跳转」的原因，与 `goto` 这类「短跳转」相对应)。

相关实作:
- CPython 的 [Modules/_asynciomodule.c](https://github.com/python/cpython/blob/main/Modules/_asynciomodule.c#L1711)
> 以 `goto` 为关键字进行检索

[Modern C](https://gustedt.gitlabpages.inria.fr/modern-c/) 作者也总结了 3 项和 `goto` 相关的规范 (大可不必视 `goto` 为洪水猛兽，毕竟我们有规范作为指导是不是):
- Rule 2.15.0.1: Labels for goto are visible in the whole function that contains them.
- Rule 2.15.0.2: goto can only jump to a label inside the same function.
- Rule 2.15.0.3: goto should not jump over variable initializations.

## 和想象中不同的 switch-case

`switch-case` 语句中的 case 部分本质上是 label，所以使用其它语句 (例如 `if`) 将其包裹起来并不影响 `switch` 语句的跳转。所以将 `swicth-case` 的 `case` 部分用 `if (0)` 包裹起来就无需使用 `break` 来进行跳出了:

```c
switch (argc - 1) {
             case  0: num =  "zero";
    if (0) { case  1: num =   "one"; }
    if (0) { case  2: num =   "two"; }
    if (0) { case  3: num = "three"; }
    if (0) { default: num =  "many"; }
```

归纳一下，这种实作方法符合以下结构:

```c
if (0) { label: ... }
```

- [x] [Clifford’s Device](https://clifford.at/cliffords-device.html)

> A **Clifford's Device** is a section of code is surrounded by `if (0) { label: … }` so it is skipped in the normal flow of execution and is only reached via the goto label, reintegrating with the normal flow of execution and the end of the `if (0)` statement. It solves a situation where one would usually need to duplicate code or create a state variable holding the information if the additional code block should be called.

> A switch statement is nothing else than a computed goto statement. So it is possible to use Clifford's Device with a switch statement as well.

简单来说，这种方法主要用于开发阶段时的运行时信息输出，在发行阶段运行时不再输出这一信息的情景，有助于开发时程序员进行侦错。除此之外，在使用枚举作为 `switch-case` 的表达式时，如果 `case` 没有对全部的枚举值进行处理的话，编译器会给出警告 (Rust 警告 :rofl: 但 Rust 会直接报错)，使用 `if (0) { ... }` 技巧将未处理的枚举值对应的 `case` 包裹就不会出现警告，同时也不影响代码逻辑。

在 OpenSSL 中也有类似手法的实作:

```c
    if (!ok) goto end;
    if (0) {
end:
        X509_get_pubkey_parameters(NULL, ctx->chain);
    }
```

- [Something You May Not Know About the Switch Statement in C/C++](https://www.codeproject.com/Articles/100473/Something-You-May-Not-Know-About-the-Switch-Statem)
- [How to Get Fired Using Switch Statements & Statement Expressions](http://blog.robertelder.org/switch-statements-statement-expressions/)

## Duff's Device

这个技巧常用于内存数据的复制，类似于 `memcpy`。主要思路类似于在数值系统篇提到的 `strcpy`，针对 alignment 和 unalignment 的情况分别进行相应的处理，但效能比不上优化过的 `memcpy`。

- [x] Wikipedia: [Duff's Device](https://en.wikipedia.org/wiki/Duff%27s_device)
> To handle cases where the number of iterations is not divisible by the unrolled-loop increments, a common technique among assembly language programmers is to jump directly into the middle of the unrolled loop body to handle the remainder. Duff implemented this technique in C by using C's case label fall-through feature to jump into the unrolled body.

Linux 核心中的实作运用:

```c
void dsend(int count) {
    if (!count)
        return;
    int n = (count + 7) / 8;
    switch (count % 8) {
    case 0:
        do {
            puts("case 0");
        case 7:
            puts("case 7");
        case 6:
            puts("case 6");
        case 5:
            puts("case 5");
        case 4:
            puts("case 4");
        case 3:
            puts("case 3");
        case 2:
            puts("case 2");
        case 1:
            puts("case 1");
        } while (--n > 0);
    }
}
```

试着将上面这段程式码修改为 `memcpy` 功能的实作，进一步体会 Duff's Device 的核心机制，同时结合「[C语言: 内存管理篇](https://hackmd.io/@sysprog/c-memory)」思考为什么该实作效能不高。

{{< details "Answer" >}}
未充分利用 data alignment 和现代处理器的寄存器大小，每次只处理一个 byte 导致效率低下。
{{< /details >}}

- [ ] [Duff's Device 的详细解释](http://c-faq.com/misc/duffexpln.html)
- [ ] [Tom Duff 本人的解释](http://doc.cat-v.org/bell_labs/duffs_device)

{{< admonition quote >}}
但在現代的微處理器中，Duff's Device 不見得會帶來好處，改用已針對處理器架構最佳化的 memcpy 函式，例如 Linux 核心的修改 fbdev: Improve performance of sys_fillrect()

- 使用 Duff's Device 的 sys_fillrect(): 166,603 cycles
- 運用已最佳化 memcpy 的 sys_fillrect(): 26,586 cycles
{{< /admonition >}}

## co-routine 应用

Wikipedia: [Coroutine](https://en.wikipedia.org/wiki/Coroutine)

不借助操作系统也可以实作出多工交执行的 illusion (通过 `switch-case` 黑魔法来实现 :rofl:)

- [x] PuTTY 作者 Simon Tatham: [Coroutines in C](https://www.chiark.greenend.org.uk/~sgtatham/coroutines.html) 

{{< admonition >}}
这是一篇好文章，下面我对文章画一些重点
{{< /admonition >}}

> In The Art of Computer Programming, Donald Knuth presents a solution to this sort of problem. His answer is to throw away the stack concept completely. Stop thinking of one process as the caller and the other as the callee, and start thinking of them as cooperating equals.

> The callee has all the problems. For our callee, we want a function which has a "return and continue" operation: return from the function, and next time it is called, resume control from just after the return statement. For example, we would like to be able to write a function that says

```c
int function(void) {
    int i;
    for (i = 0; i < 10; i++)
        return i;   /* won't work, but wouldn't it be nice */
}
```

> and have ten successive calls to the function return the numbers 0 through 9.

> How can we implement this? Well, we can transfer control to an arbitrary point in the function using a goto statement. So if we use a state variable, we could do this:

```c
int function(void) {
    static int i, state = 0;
    switch (state) {
        case 0: goto LABEL0;
        case 1: goto LABEL1;
    }
    LABEL0: /* start of function */
    for (i = 0; i < 10; i++) {
        state = 1; /* so we will come back to LABEL1 */
        return i;
        LABEL1:; /* resume control straight after the return */
    }
}
```

这个实作里面，`staic` 这个修饰词也起到了很大作用，尝试带入一个流程去体会 `static` 在这段程式码的作用，并试着想一下如果没有 `static` 修饰变量 `i` 和 `state` 会导致上面后果。

> The famous "Duff's device" in C makes use of the fact that a case statement is still legal within a sub-block of its matching switch statement.

> We can put it to a slightly different use in the coroutine trick. Instead of using a switch statement to decide which goto statement to execute, we can use the switch statement to perform the jump itself:

```c
int function(void) {
    static int i, state = 0;
    switch (state) {
        case 0: /* start of function */
        for (i = 0; i < 10; i++) {
            state = 1; /* so we will come back to "case 1" */
            return i;
            case 1:; /* resume control straight after the return */
        }
    }
}
```

> Now this is looking promising. All we have to do now is construct a few well chosen macros, and we can hide the gory details in something plausible-looking:

```c
#define crBegin static int state=0; switch(state) { case 0:
#define crReturn(i,x) do { state=i; return x; case i:; } while (0)
#define crFinish }
int function(void) {
    static int i;
    crBegin;
    for (i = 0; i < 10; i++)
        crReturn(1, i);
    crFinish;
}
```

这里又用到了 `do { ... } while (0)` 搭配宏的技巧 :rofl:

> The only snag remaining is the first parameter to crReturn. Just as when we invented a new label in the previous section we had to avoid it colliding with existing label names, now we must ensure all our state parameters to crReturn are different. The consequences will be fairly benign - the compiler will catch it and not let it do horrible things at run time - but we still need to avoid doing it.

> Even this can be solved. ANSI C provides the special macro name __LINE__, which expands to the current source line number. So we can rewrite crReturn as

```c
#define crReturn(x) do { state=__LINE__; return x; \
                         case __LINE__:; } while (0)
```                        

这个实作手法本质上和 Knuth 所提的机制相同，将函数的状态存储在其它地方而不是存放在 stack 上，这里存储的地方就是之前所提的那些被 `static` 修饰的变量 (因为 `static` 修饰的变量存储在 data 段而不在栈上)，事实上这些 `static` 变量实现了一个小型的状态机。

> We have achieved what we set out to achieve: a portable ANSI C means of passing data between a producer and a consumer without the need to rewrite one as an explicit state machine. We have done this by combining the C preprocessor with a little-used feature of the switch statement to create an implicit state machine.

`static` 变量的表达能力有限，但是可以通过预先分配空间，并通过指针操作取代 `static` 变量操作来实现 coroutine 的可重入性:

> In a serious application, this toy coroutine implementation is unlikely to be useful, because it relies on static variables and so it fails to be re-entrant or multi-threadable. Ideally, in a real application, you would want to be able to call the same function in several different contexts, and at each call in a given context, have control resume just after the last return in the same context.

> This is easily enough done. We arrange an extra function parameter, which is a pointer to a context structure; we declare all our local state, and our coroutine state variable, as elements of that structure.

> It's a little bit ugly, because suddenly you have to use ctx->i as a loop counter where you would previously just have used i; virtually all your serious variables become elements of the coroutine context structure. But it removes the problems with re-entrancy, and still hasn't impacted the structure of the routine.

作者最后提供了相关实作:
- [coroutine.h](https://www.chiark.greenend.org.uk/~sgtatham/coroutine.h)

---

在 PuTTY 里的相关实作:
- [ssh.c](https://github.com/Yasushi/putty/blob/31a2ad775f393aad1c31a983b0baea205d48e219/ssh.c#L414)

将原文的「合作式多工」中的 `cr_yield` 宏使用 `do { ... } while (0)` 手法改写：

```c
#define cr_yield()               \
    do {                         \
        __s = __LINE__;          \
        usleep(THREAD_INTERVAL); \
        return;                  \
    case __LINE__:;              \
    } while (0)
```

延伸阅读:
- [x] [深入了解 switch-case](https://airfishqi.blogspot.com/2016/11/switch-case.html)
- [x] [Protothreads](https://dunkels.com/adam/pt/)
