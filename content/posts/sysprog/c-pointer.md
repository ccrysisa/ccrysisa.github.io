---
title: "你所不知道的 C 语言: 指针篇"
subtitle:
date: 2024-01-14T22:41:38+08:00
draft: false
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
  - C
  - Pointer
categories:
  - 你所不知道的 C 语言
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

{{< admonition type=abstract title="Abstract" >}}
「指针 (Pointer)」扮演着「内存 (Memory)」和「物件 (Object)」之间的桥梁
{{< /admonition >}}

<!--more-->

## 基本概念

Ólafur Waage 在 CppCon 2018 的 5 分钟演讲 [Let\'s learn programming by inventing it](https://www.youtube.com/watch?v=l5Mp_DEn4bs) 借用 K&R C 的目录告诉我们即使不会指针，亦可掌握 C 语言的大部分功能。在 K&R 一书中，直到 93 页才开始谈论指针 (Pointer)，而全书总计 185 页，所以大概是在全书 $50.27\\%$ 的位置才开始讲指针 (Pointer)。所以即使不学指针 (Pointer)，你还是能够掌握 C 语言的一半内容，但是 C 语言的核心正是指针 (Pointer) 因为其通过指针 (Pointer) 打通了高级程序语言和机器硬件的通道。

Stack Overflow 上一个关于指针操作的基本问题: [How to increment a pointer address and pointer\'s value?](https://stackoverflow.com/questions/8208021/how-to-increment-a-pointer-address-and-pointers-value/8208106#8208106)

{{< admonition todo >}}

搭配 [godbolt](http://gcc.godbolt.org/) 解读指针操作对应的汇编指令:

```c
(*(void(*)())0)();
// or equal
typedef void (*funcptr)();
(* (funcptr) 0)();
```

{{< /admonition >}}

公司的类型体操面试题: 解释下面代码的类型声明

```c++
void **(*d) (int &, char **(*)(char *, char **));
```

[signal](http://man7.org/linux/man-pages/man2/signal.2.html) 系统调用也用到了函数指针来简化类型声明，Stack Overflow 上的问题 [How to read this prototype?](https://stackoverflow.com/questions/15739500/how-to-read-this-prototype) 提供来许多视角来解读指针相关的类型声明。

{{< admonition >}}
C 语言中关于指针的类型声明让人头脑发昏的原因是，在 C 语言中函数和数组的类型声明，存在参数位于函数名或变量名的右侧，导致对这函数或数组使用指针引用时，这些指针类型的右侧也存在参数。若是将类型的相关参数全部置于函数名或变量名的左侧那么解读指针类型相对而言会更简单清晰一些。例如:

```c
void ( *signal(int sig, void (*handler)(int)) ) (int)
// swap parameter lists and array declarators with the thing to their left 
// and then read the declaration backwards
void (int)( *(int sig, void (int)(*handler))signal )
```

[the spiral rule](https://c-faq.com/decl/spiral.anderson.html) 是一个用于解析 C 语言中声明 (declaration) 的方法， `cdecl` 这一程序使用的就是类似的方法对 C 语言中的类型声明进行解释。这个规则对理解 `const char *p` 和 `char *const p` 十分有帮助。可以对照 [K&R 2nd](http://cslabcms.nju.edu.cn/problem_solving/images/c/cc/The_C_Programming_Language_%282nd_Edition_Ritchie_Kernighan%29.pdf) 的 5.12 Complicated Declaration 所给的例子进行练习该声明解析规则。
{{< /admonition >}}

David Brailsford 教授解说影片 [Essentials: Pointer Power!](https://www.youtube.com/watch?v=t5NszbIerYc) 和文章 [Everything you need to know about pointers in C](https://boredzo.org/pointers/) 可以用于补充指针的基本知识。

## 语言规格

规格书 (PDF): [C99](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf) -> [C11](https://www.open-std.org/jtc1/sc22/WG14/www/docs/n1570.pdf)

C 语言中的 pointer 很重要，但 object 也很重要，这两个概念是一体两面的。注意 object != object-oriented，前者的重点在于 **数据的表示方法**，而后者的重点在于 **everything is object**，是一种思维范式。

{{< admonition type=quote title="C99 3.14 - *object*" >}}
region of data storage in the execution environment, the contents of which can represent values
{{< /admonition >}}

即 C 语言的 object 是指在执行时期，数据存储的区域，其内容可以明确地表示为数值。了解这个概念之后，就可以清晰地认知到在 C 语言中 (int)7 和 (float)7.0 是不等价的，具体解释可以延伸阅读 CSAPP 的第二章。

{{< admonition type=quote title="C99 6.2.4 - *Storage durations of objects*" >}}
- An object has a storage duration that determines its lifetime. There are three storage durations: static, automatic, and allocated.

- The lifetime of an object is the portion of program execution during which storage is guaranteed to be reserved for it. An object exists, has a constant address and retains its last-stored value throughout its lifetime. If an object is referred to outside of its lifetime, the behavior is undefined.

- The value of a pointer becomes indeterminate when the object it points to reaches the end of its lifetime.

- An object whose identifier is declared with no linkage and without the storage-class specifier static has automatic storage duration.
{{< /admonition >}}

C 语言中的 object 也具备生命周期 (lifetime)，但比较简单，就是存放在数据段的全局变量、栈上变量和堆上变量这三种，另外需要注意在 C 语言中只有 **call-by-value** 的操作。

{{< admonition type=quote title="C99 6.2.5 - *Types*" >}}
- A pointer type may be derived from a function type, an object type, or an incomplete type, called the referenced type. A pointer type describes an object whose value provides a reference to an entity of the referenced type. A pointer type derived from the referenced type T is sometimes called \"pointer to T\". The construction of a pointer type from a referenced type is called \"pointer type derivation\".

- Arithmetic types and pointer types are collectively called scalar types. Array and structure types are collectively called aggregate types.

- An array type of unknown size is an incomplete type. It is completed, for an identifier of that type, by specifying the size in a later declaration (with internal or external linkage). A structure or union type of unknown content is an incomplete type. It is completed, for all declarations of that type, by declaring the same structure or union tag with its defining content later in the same scope.

- Array, function, and pointer types are collectively called derived declarator types. A declarator type derivation from a type T is the construction of a derived declarator type from T by the application of an array-type, a function-type, or a pointer-type derivation to T.

- A pointer to void shall have the same representation and alignment requirements as a pointer to a character type.
{{< /admonition >}}

算术操作例如 `++`, `--`, `+=`, `-=` 等都是针对 scalar types 而言的，所以指针的 `++` 操作有其自己的含义，表示后移一个单位，而不是直接对其数值加一。

Incomplete Type 指的是不能明确占用空间大小的类型，类似于 Rust 中的切片类型 `T[]`，类似的，没法建立实例因为大小未知，但是可以使用指针对其进行引用，因为指针的大小是已知的，另外还可以在 C/C++ 中使用 Incomplete Type 来使用 forward declaration 技巧，使用该技巧可以兼顾二进制的相容性 (binary compatibility)，因为结构体类型的变化并不会影响作为函数参数的指针类型的变化，因此该函数在二进制层面得以保持不变。

array、function 以及 pointer 这三者在 C 语言中都属于 derived declarator types，因为它们的重点都在于对地址的操作。另外 `void *` 和 `char *` 属于可以互换的表述，即这两个指针类型作为 object 的内容是一致的（此外在 GNU C 中，`void *` 除了并不能使用 `*` 解引用运算之外，其它操作均与 `char *` 相同，包括 `++`, `--`, `+=` 等操作，后面会说）。`void *` 的优势在于其天然地表示以字节 (Byte) 为单位的内存地址，并且仅能表示地址，不能进行解引用操作。

{{< admonition tip >}}
在 21 世纪，`(*p).x` 和 `p->x` 效果等同，跟 `i++` 和 `++i` 类似，都只是之前处理器和编译器性能有限时的妥协产物。
{{< /admonition >}}

## 与生俱来的机制

由于通用计算机是由处理器和内存组成的 **存取——执行** 的计算模型，所以其天然的需要指针，以在内存和寄存器之间进行存取操作，所以 C 语言天然地就与通用计算机适配，也因此是汇编语言的简化，因为它延续了对机器直接操作的汇编语言的逻辑。

> ***指標，不僅是 C 語言的靈魂，更是儲存-執行模型中不可或缺的存在。***

{{< admonition type=quote title="GNU C Language Manual 14.10 - *Pointer Arithmetic*" >}}
In standard C, addition and subtraction are not allowed on `void *`, since the target type\'s size is not defined in that case. Likewise, they are not allowed on pointers to function types. However, these operations work in GNU C, and the \"size of the target type\" is taken as 1 byte.
{{< /admonition >}}

指针操作还可以帮忙解决某些架构因为内存对齐而导致的异常，并且与汇编语言的思路一致。`2-byte aligned` 图示如下：

{{< image src="/images/c/2-byte-aligned.svg" caption="Alignment" >}}

如果是 2-byte aligned 且是 little-endian 的处理器，对于左边，可以直接使用 `*(uint16_t *) ptr`，但对于右边就无法这样（不符合 alignment）：

```c
/* may receive wrong value if ptr is not 2-byte aligned */
uint16_t value = *(uint16_t *) ptr;
/* portable way of reading a little-endian value */
uint16_t value = *(uint8_t *) ptr | ((*(uint8_t *) (ptr + 1)) << 8);
```

因为内存寻址的最小粒度是 Byte，所以使用 `(uint_8 *)` 不需要担心 alignment 的问题。原文并没有给出 32-bit aligned 的 portable way，我们来写一下：

```c
/* may receive wrong value if ptr is not 2-byte aligned */
uint32_t value = *(uint32_t *) ptr;
/* portable way of reading a little-endian value */
uint32_t value = *(uint8_t *) ptr 
                 | ((*(uint8_t *) (ptr + 1)) << 8) 
                 | ((*(uint8_t *) (ptr + 2)) << 16) 
                 | ((*(uint8_t *) (ptr + 3)) << 24);
```

## void 和 void *

C89 之前，函数如果没有标注返回类型，则默认返回类型 `int`，返回值 0。但由于这样既可以表示返回值不重要，也可以表示返回值为 0，这会造成歧义，所以引进了 `void`，方便使用函数声明对函数的使用 (特别是返回值) 进行检查。

`void *` 只能表示地址，而不能对所指向的地址区域的内容进行操作。因为通过 `void *` 无法知道所指向区域的 size，所以无法对区域的内容进行操作，必须对 `void *` 进行 ***显示转换*** 才能操作指向的内容以及对指针自身进行递增或递减操作。在 GNU C 中，`void *` 除了并不能使用 `*` 解引用运算之外，其它操作均与 `char *` 相同，包括 `++`, `--`, `+=` 等操作。

`void *` 作为指针表示地址也不是万能的:

{{< admonition type=quote title="C99 6.3.2.3 - *Pointers*" >}}
A pointer to a function of one type may be converted to a pointer to a function of another type and back again; the result shall compare equal to the original pointer. If a converted pointer is used to call a function whose type is not compatible with the pointed-to type, the behavior is undefined.
{{< /admonition >}}

C99/C11 均不保证 pointers to data 例如 `void *` 或 `char *` 与 pointers to functions 之间的转换是正确的，这种转换操作反而属于 undefined behavior (UB)，所以在 C 语言程序中使用 `void *` 来存放函数的地址，然后通过指针类型转换为函数指针再进行调用的结果是未定义的，不建议这么做，推荐直接使用与函数声明兼容的函数指针来存放函数的地址，并进行调用。

导致这个的原因之一是之前所提的 Alignment，转换后的指针类型不一定满足原有类型的 Alignment 要求，这种情况下进行 dereference 会导致异常。例如将一个 `char *` 指针转换成 `int *` 指针，然后进行 deference 在某些架构有可能会产生异常，而程序语言是架构无关的，所以没有将这种指针类型之间转换合法列入语言标准。

---

## Pointers vs. Arrays

C99 6.3.2.1
> Except when it is the operand of the sizeof operator or the unary & operator, or is a string literal used to initialize an array, an expression that has type ‘‘array of type’’ is converted to an expression with type ‘‘pointer to type’’ that points to the initial element of the array object and is not an lvalue.

Array 只有在表示其自身为数组时才不会被 converted to Pointer，例如

```c
// case 1: extern declaration of array
extern char a[];
// case 2: defintion of array
char a[10];
// case 3: size of array
sizeof(a);
// case 4: address of array
&a
```

在其他情况则会倍 converted to Pointer，这时 Array 可以和 Pointer 互换进行表示或操作，例如

```c
// case 1: function parameter
void func(char a[]);
void func(char *a);

// case 2: operation in expression
char c = a[2];
char c = *(a + 2);
```

这也是为什么对于一个 Array `a`，`&a` 和 `&a[0]` 值虽然相同，但 `&a + 1` 和 `&a[0] + 1` 的结果大部分时候是大不相同的，这件事乍一看是非常惊人的，但其实不然，在了解 Array 和 Pointer 之后，也就那么一回事 :rofl:

{{< link href="https://github.com/ccrysisa/LKI/blob/main/c-pointer" content=Source external-icon=true >}}

### GDB 实作

```c
char a[10];
int main() {
    return 0;
};
```

我们以上面这个例子，通过 GDB 来对 Array 和 Pointer 进行深入研究：

```bash
(gdb) print &a
$1 = (char (*)[10]) 0x555555558018 <a>
(gdb) print &a[0]
$2 = 0x555555558018 <a> ""
```

符合预期，`&a` 和 `&a[0]` 得到的值是相同的，虽然类型看起来不同，但是现在先放到一边。

```bash
(gdb) print &a + 1
$3 = (char (*)[10]) 0x555555558022
(gdb) print &a[0] + 1
$4 = 0x555555558019 <a+1> ""
(gdb) print a + 1
$5 = 0x555555558019 <a+1> ""
```

Oh! 正如我们之前所说的 `&a + 1` 与 `&a[0] + 1` 结果并不相同（而 `&a[0] + 1` 和 `a + 1` 结果相同正是我们所提到的 Array 退化为 Pointer），虽然如此，GDB 所给的信息提示我们可能是二者 Pointer 类型不相同导致的。

```bash
(gdb) whatis &a
type = char (*)[10]
(gdb) whatis &a[0]
type = char *
```

Great! 果然是 Pointer 类型不同导致的，我们可以看到 `&a` 的类型是 `char (*)[10]` 一个指向 Array 的指针，`&a[0]` 则是 `char *`。所以这两个 Pointer 在进行 `+/-` 运算时的偏移量是不同的，`&a[0]` 的偏移量为 `sizeof(a[0])` 即一个 `char` 的宽度 ($0x18 + 1 = 0x19$)，而 `&a` 的偏移量为 `sizeof(a)` 即 10 个 `char` 的宽度 ($0x18 + 10 = 0x22$)。

{{< admonition warning >}}
在 GDB 中使用 `memcpy` 后直接打印可能会出现以下错误：

```bash
(gdb) p memcpy(calendar, b, sizeof(b[0]))
'memcpy' has unknown return type; cast the call to its declared return type
```

只需加入 `void *` 进行类型转换即可解决该问题：

```bash
(gdb) p (void *) memcpy(calendar, b, sizeof(b[0]))
...
```

{{< /admonition >}}

{{< admonition tip >}}
遇到陌生的函数，可以使用 `man` 来快速查阅手册，例如 `man strcpy`, `man strcat`，手册可以让我们快速查询函数的一些信息，从而进入实作。
{{< /admonition >}}

### Runtime Environment

根据 [Zero size arrays in C ](https://news.ycombinator.com/item?id=11674374)，原文中的 `char (*argv)[0]` 在函数参数传递时会被转换成 `char **argv`。而为什么在查看地址 `((char **) argv)[0]` 开始的连续 4 个 `char *` 内容时，会打印出 `envp` 中的内容，可以参考以下的进入 `main` 函数时的栈布局：

{{< image src="/images/c/argv.png" >}}

`argv` 和 `envp` 所指的字符串区域是相连的，所以在越过 `argv` 字符串区域的边界后，会继续打印 `envp` 区域的字符串。这也是为什么打印出的字符串之间地址增长于其长度相匹配。所以从地址 `(char **) argv` 开始的区域只是一个 `char *` 数组，使用 `x/4s` 对这部分进行字符串格式打印显然是看不懂的。

{{< admonition >}}
`argv` 和 `envp` 都是在 shell 进行 `exec` 系统调用之前进行传递（事实上是以 arguments 的形式传递给 `exec`）

man 2 execve
```c
int execve(const char *pathname, char *const argv[],
           char *const envp[]);
```

`execve` 实际上在内部调用了 `fork`，所以 `argv` 和 `envp` 的传递是在 `fork` 之前。（设想如果是在 `fork` 之后传递，可能会出现 `fork` 后 child process 先执行，这种情况 child process 显然无法获得这些被传递的信息）

注意到 `execve` 只传递了 `argv` 而没有传递 `argc`，这也很容易理解，`argc` 是 `argv` 的计数，只需 `argv` 即可推导出 `argc`。

{{< /admonition >}}

## Function Pointer

{{< admonition danger>}}
与 Array 类似，Function 只有在表示自身时不会被 converted to Function Pointer (即除 `sizeof` 和 `&` 运算之外)，其它情况、运算时都会被 convert to Function Pointer

理解 C 语言中的 Function 以及 Function Pointer 的核心在于理解 ***Function Designator*** 这个概念，函数名字必然是 Function Designator，其它的 designator 则是根据以下两条规则进行推导得来。
{{< /admonition >}}

C99 [ 6.3.2.1 ] 
> A function designator is an expression that has function type. **Except** when it is the operand of the **sizeof** operator or the unary **&** operator, a **function designator** with type ‘‘function returning type’’ **is converted to** an expression that has type ‘‘**pointer to function returning type**’’.

C99 [6.5.3.2-4] 
> The unary * operator denotes indirection. **If the operand points to a function, the result is a function designator.**

## 指针的修饰符

指针 `p` 自身不能变更，既不能改变 `p` 自身所存储的地址。const 在 * 之后：

```c
char * const p;
```

指针 `p` 所指向的内容不能变更，即不能通过 `p` 来更改所指向的内容。const 在 * 之前：

```c
const char * p;
char const * p;
```

指针 `p` 自身于所指向的内容都不能变更：

```c
const char * const p;
char const * const p;
```

## 字符串

对于函数内部的

```c
char *p  = "hello";
char p[] = "hello";
```

这两个是不一样的，因为 string literals 是必须放在 “static storage” 中，而 char p[] 则表示将资料分配在 stack 內，所以这会造成编译器隐式地生成额外代码，在执行时 (runtime) 将 string literals 从 static storage 拷贝到 stack 中，所以此时 `return p` 会造成 UB。而 `char *p` 的情形不同，此时 `p` 只是一个指向 static storage 的指针，进行 `return p` 是合法的。除此之外，无法对第一种方法的字符串进行修改操作，因为它指向的字符串存放的区域的资料是无法修改的，否则会造成 segmentationfalut :rofl:

在大部分情况下，null pointer 并不是一个有效的字符串，所以在 glibc 中字符相关的大部分函数也不会对 null pointer 进行特判 (特判会增加分支，从而影响程序效能)，所以在调用这些函数时需要用户自己判断是否为 null pointer，否则会造成 UB。

## Linus 的“教导”

[Linus 親自教你 C 語言 array argument 的使用](https://hackmd.io/@sysprog/c-array-argument)

> because array arguments in C don’t actually exist. Sadly, compilers accept it for various bad historical reasons, and silently turn it into just a pointer argument. There are arguments for them, but they are from weak minds.

> The “array as function argument” syntax is occasionally useful (particularly for the multi-dimensional array case), so I very much understand why it exists, I just think that in the kernel we’d be better off with the rule that it’s against our coding practices.

array argument 应该只用于多维数组 (multi-dimensional arrays) 的情形，这样可以保证使用下标表示时 offset 是正确的，但对于一维数组则不应该使用数组表示作为函数参数，因为这会对函数体内的 `sizeof` 用法误解 (以为会获得数组的 size，实际上获得的只是指针的 size)。

{{< admonition tip >}}
一个常用于计算数组中元素个数的宏：

```c
#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
```

这个宏非常有用，[xv6](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/defs.h#L189) 中使用到了这个宏。

但是需要注意，使用时必须保证 `x` 是一个数组，而不是函数参数中由数组退化而来的指针，以及保证数组必须至少拥有一个元素的长度 (这个很容易满足，毕竟 `x[0]` 编译器会抛出警告)。
{{< /admonition >}}

## Lvalue & Rvalue

- Lvalue: locator value
- Rvalue: Read-only value

C99 6.3.2.1 footnote

> The name “lvalue” comes originally from the assignment expression E1 = E2, in which the left operand E1 is required to be a (modifiable) lvalue. It is perhaps better considered as representing an object “locator value”. What is sometimes called “rvalue” is in this International Standard described as the “value of an expression”. An obvious example of an lvalue is an identifier of an object. As a further example, if E is a unary expression that is a pointer to an object, *E is an lvalue that designates the object to which E points.

即在 C 语言中 lvalue 是必须能在内存 (memory) 中可以定位 (locator) 的东西，因为可以定位 (locator) 所以才可以在表达式左边从而修改值。想像一下，在 C 语言中修改一个常数的值显然是不可能的，因为常数无法在内存 (memory) 定位 (locator) 所以常数在 C 语言中不是 lvalue。C 语言中除了 lvalue 之外的 value 都是 rvalue (这与 C++ 有些不同，C++ 的 lvalue 和 rvalue 的定义请参考 C++ 的规格书)。

## References

- 你所不知道的 C 语言: [指针篇](https://hackmd.io/@sysprog/c-pointer)
- bilibili: [4 小时彻底掌握 C 指针](https://www.bilibili.com/video/BV1bo4y1Z7xf)
