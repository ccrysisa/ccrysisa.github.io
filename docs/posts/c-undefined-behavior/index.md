# 你所不知道的 C 语言: 未定义/未指定行为篇


> C 語言最初為了開發 UNIX 和系統軟體而生，本質是低階的程式語言，在語言規範層級存在 undefined behavior，可允許編譯器引入更多最佳化

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/c-undefined-behavior" content="原文地址" external-icon=true >}}

## 从 C 语言试题谈起

```c
int i = 10;
i = i++ + ++i;
```

请问 `i` 的值在第 2 行执行完毕后为？

> C 語言沒規定 `i++` 或 `++i` 的「加 1」動作到底是在哪個敘述的哪個時刻執行，因此，不同 C 編譯器若在不同的位置 + 1，就可能導致截然不同的結果。

这一部分可以参考「并行程序设计: [执行顺序](https://hackmd.io/@sysprog/concurrency/%2F%40sysprog%2Fconcurrency-ordering)」中 Evaluation 和 Sequenced-before 的讲解。

与区分「并行」和「平行」类似，我们这里要区分「未定义行为」和「未指定行为」:

- 未定义行为 ([Undefined behavior](https://en.wikipedia.org/wiki/Undefined_behavior)): 程序行为并未在 **语言规范** (在 C 中，自然是 ISO/IEC 9899 一类的规格) 所明确定义规范。缩写为 "UB"。
> undefined behavior (UB) is the result of executing a program whose behavior is prescribed to be unpredictable, in the language specification to which the computer code adheres. 
- 未指定行为 ([Unspecified behavior](https://en.wikipedia.org/wiki/Unspecified_behavior)): 程序行为依赖 **编译器实作和平台特性** 而定。
> unspecified behavior is behavior that may vary on different implementations of a programming language.

## 程序语言不都该详细规范，怎么会有 UB 呢？

编译器最佳化建立在 UB 的基础上，即编译器会消除 UB 来进行最佳化，而让程序不是依赖与 UB 产生的结果。


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-undefined-behavior/  

