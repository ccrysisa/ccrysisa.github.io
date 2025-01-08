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
  - Sysprog
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

指针 扮演着 内存 (Memory) 和 物件 (Object) 之间的桥梁

<!--more-->

## 基本概念

Pointers --- variables store address of another variable

## 前言杂谈

[Let’s learn programming by inventing it](https://www.youtube.com/watch?v=l5Mp_DEn4bs) [CppCon 2018] :white_check_mark:

> 在 K&R 一书中，直到 93 页才开始谈论 pointer，而全书总计 185 页，所以大概是在全书 $50.27\\%$ 的位置才开始讲 pointer。所以即使不学 pointer，你还是能够掌握 $~50\\%$ 的 C 语言的内容，但是 C 语言的核心正是 pointer，所以 Good Luck :rofl:


[godbolt](http://gcc.godbolt.org/) 可以直接在网页上看到，源代码由各类 compiler 生成的 Assembly Code

[How to read this prototype?](https://stackoverflow.com/questions/15739500/how-to-read-this-prototype) [Stack Overflow] :white_check_mark:
{{< details "Note" >}}

这个问题是关于 `signal` 系统调用的函数原型解读，里面的回答页给出了很多对于指针，特别是 *函数指针* 的说明，下面节选一些特别有意思的回答：

{{< admonition quote >}}
The whole thing declares a function called `signal`:
- `signal` takes an int and a function pointer
  - this function pointer takes an `int` and returns `void`
- `signal` returns a function pointer
  - `this function pointer takes an `int` and returns a `void`
That's where the last int comes in.

You can use [the spiral rule](https://c-faq.com/decl/spiral.anderson.html) to make sense of such declarations, or the program `cdecl(1)`.
{{< /admonition >}}

The whole thing declares a function called `signal`:
这里面提到了 [the spiral rule](https://c-faq.com/decl/spiral.anderson.html) 这是一个用于解析 C 语言中声明 (declaration) 的方法；另外还提到了 `cdecl` 这一程序，它也有类似的作用，可以使用英文进行声明或者解释。

{{< admonition quote >}}
Find the leftmost identifier and work your way out, remembering that `[]` and `()` bind before `*`; IOW, `*a[]` is an array of pointers, `(*a)[]` is a pointer to an array, `*f()` is a function returning a pointer, and `(*f)()` is a pointer to a function. Thus,

```c
void ( *signal(int sig, void (*handler)(int)) ) (int);
```

breaks down as

```c
        signal                                          -- signal
        signal(                               )         -- is a function
        signal(    sig                        )         -- with a parameter named sig
        signal(int sig,                       )         --   of type int
        signal(int sig,        handler        )         -- and a parameter named handler
        signal(int sig,       *handler        )         --   which is a pointer
        signal(int sig,      (*handler)(   )) )         --   to a function
        signal(int sig,      (*handler)(int)) )         --   taking an int parameter
        signal(int sig, void (*handler)(int)) )         --   and returning void
       *signal(int sig, void (*handler)(int)) )         -- returning a pointer
     ( *signal(int sig, void (*handler)(int)) )(   )    -- to a function
     ( *signal(int sig, void (*handler)(int)) )(int)    --   taking an int parameter
void ( *signal(int sig, void (*handler)(int)) )(int);   --   and returning void
```
{{< /admonition >}}

这一回答强调了 `*` 和 `[]`、`()` 优先级的关系，这在判断数组指针、函数指针时是个非常好用的技巧。
{{< /details >}}

Rob Pike 于 2009/10/30 的 [Golang Talk](https://talks.golang.org/2009/go_talk-20091030.pdf) [PDF]

David Brailsford 教授解说影片 [Essentials: Pointer Power! - Computerphile](https://www.youtube.com/watch?v=t5NszbIerYc) [YouTube]

## 阅读 C 语言规格书

一手资料的重要性毋庸置疑，对于 C 语言中的核心概念 ***指针***，借助官方规格书清晰概念是非常重要的。

C99 [6.2.5] ***Types***

> An array type of unknown size is an incomplete type. It is completed, for an identifier of that type, by specifying the size in a later declaration (with internal or external linkage). A structure or union type of unknown content is an incomplete type. It is completed, for all declarations of that type, by declaring the same structure or union tag with its defining content later in the same scope.

*incomplete type* 和 *linkage* 配合可以进行 forward declaration，如果搭配 pointer 则可以进一步，在无需知道 object 内部细节即可进行程序开发。

> Array, function, and pointer types are collectively called derived declarator types. A declarator type derivation from a type T is the construction of a derived declarator type from T by the application of an array-type, a function-type, or a pointer-type derivation to T.


{{< admonition >}}
*derived declarator types*  表示衍生的声明类型，因为 array, function, pointer 本质都是地址，而它们的类型都是由其它类型衍生而来的，所以可以使用这些所谓的 *derived declarator types* 来提前声明 object，表示在某个地址会存储一个 object，这也是为什么这些类型被规格书定义为 *derived declarator types*。
{{< /admonition >}}

- **lvalue**: Locator value

{{< admonition danger >}}
C 语言里只有 ***call by value***
{{< /admonition >}}

## void & void *

C89 之前，函数如果没有标注返回类型，则默认返回类型 `int`，返回值 0。但由于这样既可以表示返回值不重要，也可以表示返回值为 0，这会造成歧义，所以引进了 `void`。

`void *` 只能表示地址，而不能对所指向的地址区域的内容进行操作。因为通过 `void *` 无法知道所指向区域的 size，所以无法对区域的内容进行操作，必须对 `void *` 进行 ***显示转换*** 才能操作指向的内容。（除此之外，**针对于 gcc**，对于指针本身的操作，`void *` 与 `char *` 是等价的，即对于 `+/- 1` 这类的操作，二者的偏移量是一致的 (这是 GNU extensions 并不是 C 语言标准)；对于其它的编译器，建议将 `void *` 转换成 `char *` 再进行指针的加减运算）

### Alignment

这部分原文描述不是很清晰，`2-byte aligned` 图示如下：

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

{{< admonition info >}}
- [ ] [The Lost Art of Structure Packing](http://www.catb.org/esr/structure-packing/)
{{< /admonition >}}

### 规格书中的 Pointer

C99 [6.3.2.3] ***Pointers***

> A pointer to a function of one type may be converted to a pointer to a function of another
type and back again; the result shall compare equal to the original pointer. Ifaconverted
pointer is used to call a function whose type is not compatible with the pointed-to type,
the behavior is undefined.

C11 [6.3.2.3] ***Pointers***

>  A pointer to a function of one type may be converted to a pointer to a function of another
type and back again; the result shall compare equal to the original pointer. If a converted
pointer is used to call a function whose type is not compatible with the referenced type,
the behavior is undefined.

**C99 和 C11 都不保证 pointers (whose type is not compatible with the *pointed-to / referenced* type) 之间的转换是正确的。**

导致这个的原因正是之前所提的 Alignment，转换后的指针类型不一定满足原有类型的 Alignment 要求，这种情况下进行 dereference 会导致异常。例如将一个 `char *` 指针转换成 `int *` 指针，然后进行 deference 有可能会产生异常。

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

- {{< link href="https://hackmd.io/@sysprog/c-pointer" content="你所不知道的 C 语言: 指针篇" external-icon=true >}}   
- {{< link href="https://www.bilibili.com/video/BV1bo4y1Z7xf" content="4小时彻底掌握C指针" external-icon=true >}}   
