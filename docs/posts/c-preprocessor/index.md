# 你所不知道的 C 语言: 前置处理器应用篇


&gt; 相較於頻繁納入新語法的程式語言 (如 C&#43;&#43; 和 Java)，C 語言顯得很保守，但總是能藉由前置處理器 (preprocessor) 對語法進行擴充，甚至搭配工具鏈 (toolchain) 的若干進階機制，做到大大超出程式語言規範的複雜機制。例如主要以 C 語言開發的 Linux 核心就搭配前置處理器和連結器 (linker) 的特徵，實作出 Linux 核心模組，允許開發者動態掛載/卸載，因巨集包裝得好，多數 Linux 核心核心模組的開發者只要專注在與 Linux 核心互動的部分。

&gt; 本議程回顧 C99/C11 的巨集 (macro) 特徵，探討 C11 新的關鍵字 _Generic 搭配 macro 來達到 C&#43;&#43; template 的作用。探討 C 語言程式的物件導向程式設計、抽象資料型態 (ADT) / 泛型程式設計 (Generics)、程式碼產生器、模仿其他程式語言，以及用前置處理器搭配多種工具程式的技巧，還探討 Linux 核心原始程式碼善用巨集來擴充程式開發的豐富度，例如: BUILD_BUG_ON_ZERO, max, min, 和 container_of 等巨集。

&lt;!--more--&gt;

- {{&lt; link href=&#34;https://hackmd.io/@sysprog/c-preprocessor&#34; content=&#34;原文地址&#34; external-icon=true &gt;}}

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

早期的 C&#43;&#43; 是和 C 语言兼容的，那时候的 C&#43;&#43; 相当于 C 语言的一种 preprocessor，将 C&#43;&#43; 代码预编译为对应的 C 语言代码，具体可以参考 [C with Classes](http://janvitek.org/events/NEU/4500/s20/cwc.html)。事实上现在的 C&#43;&#43; 和 C 语言早已分道扬镳，形同陌路，虽然语法上有相似的地方，但请把这两个语言当成不同的语言看待 :rofl:

&gt; 体验一下 C&#43;&#43; 模版 (template) 的威力 :x: 丑陋 :heavy_check_mark: :

{{&lt; image src=&#34;https://i.imgur.com/MVZVuDt.png&#34; &gt;}}

&gt; C 语言: 大道至简 :white_check_mark:

## Object Oriented Programming

面向对象编程时，善用前置处理器可大幅简化和开发

- [x] `#`: [Stringizing](https://gcc.gnu.org/onlinedocs/cpp/Stringizing.html) convert a macro argument into a string constant
- [x] `##`: [Concatenation](https://gcc.gnu.org/onlinedocs/cpp/Concatenation.html) merge two tokens into one while expanding macros.

**宏的实际作用: generate (产生/生成) 程式码**

&gt; Rust 的过程宏 (procedural macros) 进一步强化了这一目的，可以自定义语法树进行代码生成。

可以 `gcc -E -P` 来观察预处理后的输出:
- man gcc
```
-E  Stop after the preprocessing stage; do not run the compiler proper.
    The output is in the form of preprocessed source code, which is
    sent to the standard output.

    Input files that don&#39;t require preprocessing are ignored.

-P  Inhibit generation of linemarkers in the output from the
    preprocessor.  This might be useful when running the preprocessor
    on something that is not C code, and will be sent to a program
    which might be confused by the linemarkers.
```

可以依据不同时期的标准来对 C 源程序编译生成目标文件:
- [x] [Feature Test Macros](https://www.gnu.org/software/libc/manual/html_node/Feature-Test-Macros.html)
&gt; The exact set of features available when you compile a source file is controlled by which feature test macros you define.

使用 `gcc -E -P` 观察 objects.h 预处理后的输出，透过 `make` 和 `make check` 玩一下这个最简单光线追踪引擎
- [x] GitHub: [raytracing](https://github.com/embedded2016/raytracing) 

object oriented programming 不等于 class based programming, 只需要满足 Object-oriented programming (OOP) is a computer programming model that organizes software design around data, or objects, rather than functions and logic. 这个概念的就是 OOP。

{{&lt; link href=&#34;https://github.com/ccrysisa/LKI/blob/main/c-recursion&#34; content=Source external-icon=true &gt;}}

## C11: _Generic

- [x] 阅读 [C11 规格书](https://www.open-std.org/jtc1/sc22/WG14/www/docs/n1570.pdf) 6.5.1.1 Generic selection
&gt; The controlling expression of a generic selection is not evaluated. If a generic selection
&gt; has a generic association with a type name that is compatible with the type of the
&gt; controlling expression, then the result expression of the generic selection is the
&gt; expression in that generic association. Otherwise, the result expression of the generic
&gt; selection is the expression in the default generic association. None of the expressions
&gt; from any other generic association of the generic selection is evaluated.

```c
#define cbrt(X) \
    _Generic((X), \     
             long double: cbrtl, \
             default: cbrt,  \
             const float: cbrtf, \
             float: cbrtf  \
    )(X)
```

经过 func.c/func.cpp 的输出对比，C&#43;&#43; 模版在字符类型的的判定比较准确，C11 的 `_Generic` 会先将 `char` 转换成 `int` 导致结果稍有瑕疵，这是因为在 C 语言中字符常量 (例如 &#39;a&#39;) 的类型是 `int` 而不是 `char`。

- Stack Overflow: [What to do to make &#39;_Generic(&#39;a&#39;, char : 1, int : 2) == 1&#39; true](https://stackoverflow.com/questions/76701502/what-to-do-to-make-generica-char-1-int-2-1-true)

## Block

- Wikipedia: [Blocks (C language extension)](https://en.wikipedia.org/wiki/Blocks_(C_language_extension))
&gt; Blocks are a non-standard extension added by Apple Inc. to Clang&#39;s implementations of the C, C&#43;&#43;, and Objective-C programming languages that uses a lambda expression-like syntax to create closures within these languages. 

&gt; Like function definitions, blocks can take arguments, and declare their own variables internally. Unlike ordinary C function definitions, their value can capture state from their surrounding context. A block definition produces an opaque value which contains both a reference to the code within the block and a snapshot of the current state of local stack variables at the time of its definition. The block may be later invoked in the same manner as a function pointer. The block may be assigned to variables, passed to functions, and otherwise treated like a normal function pointer, although the application programmer (or the API) must mark the block with a special operator (Block_copy) if it&#39;s to be used outside the scope in which it was defined.

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
#define DOUBLE(a) ((a) &#43; (a))

#define DOUBLE(a) ({ \
    __typeof__(a) _x_in_DOUBLE = (a); \
    _x_in_DOUBLE &#43; _x_in_DOUBLE; \
})
```

## ARRAY_SIZE 宏

- [ ] [Linux Kernel: ARRAY_SIZE()](https://frankchang0125.blogspot.tw/2012/10/linux-kernel-arraysize.html)
- [ ] 从 Linux 核心 「提炼」 出的 [array_size](http://ccodearchive.net/info/array_size.html)
- [ ] [_countof Macro](https://msdn.microsoft.com/en-us/library/ms175773.aspx)

## dp { ... } while (0) 宏

- 避免 dangling else，即 if 和 else 未符合预期的配对 (常见于未使用 `{}` 包裹)
- [ ] Stack Overflow: [C multi-line macro: do/while(0) vs scope block](https://stackoverflow.com/questions/1067226/c-multi-line-macro-do-while0-vs-scope-block)

## 应用: String switch in C

- [ ] [String switch in C](https://tia.mat.br/posts/2012/08/09/string_switch_in_c.html)
- [ ] [More on string switch in C](https://tia.mat.br/posts/2018/02/01/more_on_string_switch_in_c.html)

## 应用: Linked List 的各式变种

- [ ] [Simple code for checking the speed difference between function call and macro](https://gist.github.com/afcidk/441abae865be13c599b8f749792908b6)

## 其它应用

### Unit Test

### Object Model

### Exception Handling

### ADT

{{&lt; admonition success &gt;}}
Linux 核心原始程式码也善用宏来扩充
{{&lt; /admonition &gt;}}

## Linux 核心宏: BUILD_BUG_ON_ZERO

- {{&lt; link href=&#34;https://hackmd.io/@sysprog/c-bitfield&#34; content=&#34;原文地址&#34; external-icon=true &gt;}}

简单来说就是编译器就进行检查的 `assert`，我写了 [一篇文章]({{&lt; relref &#34;./c-bitwise.md#linux-核心-build_bug_on_zero&#34; &gt;}}) 来说明它的原理。

## Linux 核心原始程式码宏: max, min

- {{&lt; link href=&#34;https://hackmd.io/@sysprog/linux-macro-minmax&#34; content=&#34;原文地址&#34; external-icon=true &gt;}}

## Linux 核心原始程式码宏: contain_of

- {{&lt; link href=&#34;https://hackmd.io/@sysprog/linux-macro-containerof&#34; content=&#34;原文地址&#34; external-icon=true &gt;}}


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-preprocessor/  

