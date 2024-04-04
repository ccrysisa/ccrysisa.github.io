# 你所不知道的 C 语言: 前置处理器应用篇


> 相較於頻繁納入新語法的程式語言 (如 C++ 和 Java)，C 語言顯得很保守，但總是能藉由前置處理器 (preprocessor) 對語法進行擴充，甚至搭配工具鏈 (toolchain) 的若干進階機制，做到大大超出程式語言規範的複雜機制。例如主要以 C 語言開發的 Linux 核心就搭配前置處理器和連結器 (linker) 的特徵，實作出 Linux 核心模組，允許開發者動態掛載/卸載，因巨集包裝得好，多數 Linux 核心核心模組的開發者只要專注在與 Linux 核心互動的部分。
>
> 本議程回顧 C99/C11 的巨集 (macro) 特徵，探討 C11 新的關鍵字 _Generic 搭配 macro 來達到 C++ template 的作用。探討 C 語言程式的物件導向程式設計、抽象資料型態 (ADT) / 泛型程式設計 (Generics)、程式碼產生器、模仿其他程式語言，以及用前置處理器搭配多種工具程式的技巧，還探討 Linux 核心原始程式碼善用巨集來擴充程式開發的豐富度，例如: BUILD_BUG_ON_ZERO, max, min, 和 container_of 等巨集。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-preprocessor" content="原文地址" external-icon=true >}}

## 不要小看 preprocessor

- man gcc

```
-D name
    Predefine name as a macro, with definition 1.

-D name=definition
    The contents of definition are tokenized and processed as if they
    appeared during translation phase three in a #define directive.  In
    particular, the definition is truncated by embedded newline
    characters.
```

在 Makefile 中往 CFLAGS 加入 `-D’;’=’;’` 这类搞怪信息，会导致编译时出现一些不明所以的编译错误 (恶搞专用 :rofl:)

早期的 C++ 是和 C 语言兼容的，那时候的 C++ 相当于 C 语言的一种 preprocessor，将 C++ 代码预编译为对应的 C 语言代码，具体可以参考 [C with Classes](http://janvitek.org/events/NEU/4500/s20/cwc.html)。事实上现在的 C++ 和 C 语言早已分道扬镳，形同陌路，虽然语法上有相似的地方，但请把这两个语言当成不同的语言看待 :rofl:

> 体验一下 C++ 模版 (template) 的威力 :x: 丑陋 :heavy_check_mark: :

{{< image src="https://i.imgur.com/MVZVuDt.png" >}}

> C 语言: 大道至简 :white_check_mark:

## Object Oriented Programming

面向对象编程时，善用前置处理器可大幅简化和开发

- [x] `#`: [Stringizing](https://gcc.gnu.org/onlinedocs/cpp/Stringizing.html) convert a macro argument into a string constant
- [x] `##`: [Concatenation](https://gcc.gnu.org/onlinedocs/cpp/Concatenation.html) merge two tokens into one while expanding macros.

**宏的实际作用: generate (产生/生成) 程式码**

> Rust 的过程宏 (procedural macros) 进一步强化了这一目的，可以自定义语法树进行代码生成。

可以 `gcc -E -P` 来观察预处理后的输出:
- man gcc
```
-E  Stop after the preprocessing stage; do not run the compiler proper.
    The output is in the form of preprocessed source code, which is
    sent to the standard output.

    Input files that don't require preprocessing are ignored.

-P  Inhibit generation of linemarkers in the output from the
    preprocessor.  This might be useful when running the preprocessor
    on something that is not C code, and will be sent to a program
    which might be confused by the linemarkers.
```

可以依据不同时期的标准来对 C 源程序编译生成目标文件:
- [x] [Feature Test Macros](https://www.gnu.org/software/libc/manual/html_node/Feature-Test-Macros.html)
> The exact set of features available when you compile a source file is controlled by which feature test macros you define.

使用 `gcc -E -P` 观察 objects.h 预处理后的输出，透过 `make` 和 `make check` 玩一下这个最简单光线追踪引擎
- [x] GitHub: [raytracing](https://github.com/embedded2016/raytracing) 

object oriented programming 不等于 class based programming, 只需要满足 Object-oriented programming (OOP) is a computer programming model that organizes software design around data, or objects, rather than functions and logic. 这个概念的就是 OOP。

{{< link href="https://github.com/ccrysisa/LKI/blob/main/c-recursion" content=Source external-icon=true >}}

## C11: _Generic

- [x] 阅读 [C11 规格书](https://www.open-std.org/jtc1/sc22/WG14/www/docs/n1570.pdf) 6.5.1.1 Generic selection
> The controlling expression of a generic selection is not evaluated. If a generic selection
> has a generic association with a type name that is compatible with the type of the
> controlling expression, then the result expression of the generic selection is the
> expression in that generic association. Otherwise, the result expression of the generic
> selection is the expression in the default generic association. None of the expressions
> from any other generic association of the generic selection is evaluated.

```c
#define cbrt(X) \
    _Generic((X), \     
             long double: cbrtl, \
             default: cbrt,  \
             const float: cbrtf, \
             float: cbrtf  \
    )(X)
```

经过 func.c/func.cpp 的输出对比，C++ 模版在字符类型的的判定比较准确，C11 的 `_Generic` 会先将 `char` 转换成 `int` 导致结果稍有瑕疵，这是因为在 C 语言中字符常量 (例如 'a') 的类型是 `int` 而不是 `char`。

- Stack Overflow: [What to do to make '_Generic('a', char : 1, int : 2) == 1' true](https://stackoverflow.com/questions/76701502/what-to-do-to-make-generica-char-1-int-2-1-true)

## Block

- Wikipedia: [Blocks (C language extension)](https://en.wikipedia.org/wiki/Blocks_(C_language_extension))
> Blocks are a non-standard extension added by Apple Inc. to Clang's implementations of the C, C++, and Objective-C programming languages that uses a lambda expression-like syntax to create closures within these languages. 

> Like function definitions, blocks can take arguments, and declare their own variables internally. Unlike ordinary C function definitions, their value can capture state from their surrounding context. A block definition produces an opaque value which contains both a reference to the code within the block and a snapshot of the current state of local stack variables at the time of its definition. The block may be later invoked in the same manner as a function pointer. The block may be assigned to variables, passed to functions, and otherwise treated like a normal function pointer, although the application programmer (or the API) must mark the block with a special operator (Block_copy) if it's to be used outside the scope in which it was defined.

使用 BLock 可以减少宏展开时的重复计算次数。目前 clang 是支持 Block 这个扩展的，但是在编译时需要加上参数 `-fblocks`:

```bash
$ clang -fblocks blocks-test.c -lBlocksRuntime
```

同时还需要 [BlocksRuntime](https://github.com/mackyle/blocksruntime) 这个库，按照仓库 README 安装即可:

```bash
# clone repo
$ git clone https://github.com/mackyle/blocksruntime.git
$ cd blocksruntime/
# building
$ ./buildlib
# testing
$ ./checktests
# installing
$ sudo ./installlib
```

除了 Block 之外，常见的避免 double evaluation 的方法还有利用 `typeof` 提前计算:

```c
#define DOUBLE(a) ((a) + (a))

#define DOUBLE(a) ({ \
    __typeof__(a) _x_in_DOUBLE = (a); \
    _x_in_DOUBLE + _x_in_DOUBLE; \
})
```

## ARRAY_SIZE 宏

```c
// get the number of elements in array
#define ARRAY_SIZE(arr)    (sizeof(arr) / sizeof((arr)[0]))
```

这样实作的 `ARRAY_SIZE` 宏有很大的隐患，例如它无法对传入的 `arr` 进行类型检查，如果碰上不合格的 C 程序员，在数组隐式转换成指针后使用 `ARRAY_SIZE` 宏会得到非预期的结果，我们需要在编译器就提醒程序员不要错用这个宏。

{{< admonition >}}
阅读以下博客以理解 Linux 核心的 `ARRAY_SIZE` 原理机制和实作手法:

- [x] [Linux Kernel: ARRAY_SIZE()](https://frankchang0125.blogspot.tw/2012/10/linux-kernel-arraysize.html)
{{< /admonition >}}

Linux 核心的 `ARRAY_SIZE` 宏在上面那个简陋版的宏的基础上，加上了类型检查，保证传入的是数组而不是指针：

```c {title="include/linux/kernel.h"}
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
```

```c {title="include/linux/compiler-gcc.h"}
/* &a[0] degrades to a pointer: a different type from an array */
#define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
```

```c {title="include/linux/compiler.h"}
/* Are two types/vars the same type (ignoring qualifiers)? */
#ifndef __same_type
# define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
#endif
```

- [6.54 Other built-in functions provided by GCC](https://gcc.gnu.org/onlinedocs/gcc-4.7.2/gcc/Other-Builtins.html#Other-Builtins)
> You can use the built-in function __builtin_types_compatible_p to determine whether two types are the same.
> 
> This built-in function returns 1 if the unqualified versions of the types *type1* and *type2* (which are types, not expressions) are compatible, 0 otherwise. The result of this built-in function can be used in integer constant expressions.

- [6.6 Referring to a Type with typeof](https://gcc.gnu.org/onlinedocs/gcc-4.7.2/gcc/Typeof.html#Typeof)
> Another way to refer to the type of an expression is with typeof. The syntax of using of this keyword looks like sizeof, but the construct acts semantically like a type name defined with typedef.

所以 Linux 核心的 `ARRAY_SIZE` 宏额外加上了 `__must_be_array` 宏，但是这个宏在编译成功时会返回 0，编译失败自然就不需要考虑返回值了 :rofl: 所以它起到的作用是之前提到的类型检查，透过 `BUILD_BUG_ON_ZERO` 宏和 `__same_type` 宏。

- [x] 从 Linux 核心 「提炼」 出的 [array_size](http://ccodearchive.net/info/array_size.html)
- [x] [_countof Macro](https://msdn.microsoft.com/en-us/library/ms175773.aspx)

## do { ... } while (0) 宏

**用于避免 dangling else，即 if 和 else 未符合预期的配对 (常见于未使用 `{}` 包裹)**

考虑以下情形:

```c
#define handler(cond) if (cond) foo()

if (<condition1>)
    handler(<conditional2>)
else
    bar()
```

这个写法乍一看没什么问题，但是我们把它展开来看一下:

```c
if (<condition1>)
    if (<conditional2>)
        foo()
else
    bar()
```

显然此时由于未使用 `{}` 区块进行包裹，导致 `else` 部分与 `handler` 宏的 `if` 逻辑进行配对了。`do {...} while (0)` 宏的作用就是提供类似于 `{}` 区块的隔离性 (因为它的循环体只能执行一遍 :rofl:)

{{< admonition >}}
下面的讨论是关于为什么要使用 `do {...} while(0)` 而不是 `{}`，非常值得一读:

- [x] Stack Overflow: [C multi-line macro: do/while(0) vs scope block](https://stackoverflow.com/questions/1067226/c-multi-line-macro-do-while0-vs-scope-block)
{{< /admonition >}}

> The more elegant solution is to make sure that macro expand into a regular statement, not into a compound one.

主要是考虑到对包含 `{}` 的宏，像一般的 statement 一样加上 `;` 会导致之前的 `if` 语句结束，从而导致后面的 `else` 语句无法配对进而编译失败，而使用 `do {...} while (0)` 后面加上 `;` 并不会导致这个问题。

## 应用: String switch in C

这篇博文展示了如何在 C 语言中对 string 使用 switch case:

- [x] [String switch in C](https://tia.mat.br/posts/2012/08/09/string_switch_in_c.html)

```c
#define STRING_SWITCH_L(s) switch (*((int32_t *)(s)) | 0x20202020)
#define MULTICHAR_CONSTANT(a,b,c,d) ((int32_t)((a) | (b) << 8 | (c) << 16 | (d) << 24))
```

> Note that `STRING_SWITCH_L` performs a bitwise OR with the 32-bit integral value – this is a fast means of lowering the case of four characters at once.

然后 `MULTICHAR_CONSTANT` 则是将参数按小端字节序计算出对应的数值。

这篇博文说明了在 C 语言中对 string 使用 switch case 提升效能的原理 (除此之外还讲解了内存对齐相关的效能问题):

- [cx] [More on string switch in C](https://tia.mat.br/posts/2018/02/01/more_on_string_switch_in_c.html)

## 应用: Linked List 的各式变种

宏和函数调用的效能对比:

- [x] [Simple code for checking the speed difference between function call and macro](https://gist.github.com/afcidk/441abae865be13c599b8f749792908b6)

{{< image src="https://imgur-backup.hackmd.io/6taKMzN.png" >}}

> 在進行函式呼叫時，我們除了需要把參數推入特定的暫存器或是堆疊，還要儲存目前暫存器的值到堆疊。在函式呼叫數量少的狀況，影響不顯著，但隨著數量增長，就會導致程式運作比用 macro 實作時慢。

这也是为什么 Linux 核心对于 linked list 的功能大量采用宏来实现。

静态的 linked list 初始化需要使用到 **compound literal**:

- [x] C99 6.5.2.5 Compound literals
> - The type name shall specify an object type or an array of unknown size, but not a variable length array type.
> - A postfix expression that consists of a parenthesized type name followed by a braceenclosed list of initializers is a compound literal. It provides an unnamed object whose value is given by the initializer list.
> - If the type name specifies an array of unknown size, the size is determined by the initializer list as specified in 6.7.8, and the type of the compound literal is that of the completed array type. Otherwise (when the type name specifies an object type), the type of the compound literal is that specified by the type name. In either case, the result is an lvalue.

- [x] C99 6.7.8 Initialization
> Each brace-enclosed initializer list has an associated current object. When no
> designations are present, subobjects of the current object are initialized in order according
> to the type of the current object: array elements in increasing subscript order, structure
> members in declaration order, and the first named member of a union. In contrast, a
> designation causes the following initializer to begin initialization of the subobject
> described by the designator. Initialization then continues forward in order, beginning
> with the next subobject after that described by the designator.

## 其它应用

### Unit Test

测试框架本质是提供一个框架模版，让程序员将精力放在测试逻辑的编写上。使用 C 语言的宏配合前置处理器，可以很方便地实现这个功能。

- [x] [unity/unity_fixture.h](https://github.com/ThrowTheSwitch/Unity/blob/master/extras/fixture/src/unity_fixture.h)
- [Google Test](https://github.com/google/googletest)

### Object Model

同样的，使用 C 语言的宏和前置处理器，可以让 C 语言拥有 OOP 的表达能力:

- [ObjectC](https://github.com/DaemonSnake/ObjectC): use as a superset of the C language adding a lot of modern concepts missing in C

### Exception Handling

通过宏和 `setjmp/longjmp` 可以很轻松地实作出 C 语言的异常机制:

[ExtendedC](https://github.com/jspahrsummers/libextc) library extends the C programming language through complex macros and other tricks that increase productivity, safety, and code reuse without needing to use a higher-level language such as C++, Objective-C, or D.

- [include/exception.h](https://github.com/jspahrsummers/libextc/blob/master/include/exception.h)

### ADT

与之前所提的 Linux 核心的 linked list 类似，使用宏取代函数调用可以降低 ADT 的相关操作的效能损失:

[pearldb](https://github.com/willemt/pearldb): A Lightweight Durable HTTP Key-Value Pair Database in C

- [klib/ksort.h](https://github.com/willemt/pearldb/blob/master/deps/klib/ksort.h) 通过宏展开实作的排序算法

{{< admonition success >}}
Linux 核心原始程式码也善用宏来扩充
{{< /admonition >}}

## Linux 核心宏: BUILD_BUG_ON_ZERO

- {{< link href="https://hackmd.io/@sysprog/c-bitfield" content="原文地址" external-icon=true >}}

简单来说就是编译器就进行检查的 `assert`，我写了 [相关笔记]({{< relref "./c-bitwise.md#linux-核心-build_bug_on_zero" >}}) 来说明它的原理。

## Linux 核心原始程式码宏: max, min

- {{< link href="https://hackmd.io/@sysprog/linux-macro-minmax" content="原文地址" external-icon=true >}}

## Linux 核心原始程式码宏: contain_of

- {{< link href="https://hackmd.io/@sysprog/linux-macro-containerof" content="原文地址" external-icon=true >}}


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-preprocessor/  

