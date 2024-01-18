# C 规格第 6 章阅读记录


C 语言规格书 Chapter 6 - Language 阅读记录。

&lt;!--more--&gt;

## 6.5 Expressions

**Syntax**

```
unary-exprssion:
    postfix-exprssion
    &#43;&#43; unary-expression
    -- unary-expression
    unary-operator cast-exprssion
    sizeof unary-expression
    sizeof ( type-name )
unary-operator: one of
    &amp; * &#43; - ~ !
```

### 6.5.3 Unary operators

{{&lt; admonition info &gt;}}
C99 [6.2.5] **Types**

- There are three real floating types, designated as `float`, `double`, and `long double`.

- The real floating and complex types are collectively called the floating types.

- The integer and real floating types are collectively called real types.

- Integer and floating types are collectively called arithmetic types.

- A function type describes a function with specified return type. A function type is
characterized by its return type and the number and types of its parameters. A
function type is said to be derived from its return type, and if its return type is T, the
function type is sometimes called &#39;&#39;function returning T&#39;&#39;.

- Arithmetic types and pointer types are collectively called scalar types.

C99 [6.3.2.1] **Lvalues, arrays, and function designators**

- A function designator is an expression that has function type. Except when it is the
operand of the sizeof operator or the unary &amp; operator,afunction designator with
type ‘‘function returning type’’ is converted to an expression that has type ‘‘pointer to
function returning type’’.
{{&lt; /admonition &gt;}}

#### 6.5.3.1 Prefix increment and decrement operators

**Constraints**

前缀自增或自减运算符的操作数，必须为实数 (real types) 类型（即不能是复数）或者是指针类型，并且其值是可变的。

**Semantics**

- `&#43;&#43;E` 等价于 `(E&#43;=1)`
- `--E` 等价于 `(E-=1)`

#### 6.5.3.2 Address and indirection operators

**Constraints**

`&amp;` 运算符的操作数必须为 function designator，`[]` 或 `*` 的运算结果，或者是一个不是 bit-field 和 `register` 修饰的左值。

`*` 运算符的操作数必须为指针类型。

**Semantics**

`&amp;*E` 等价于 `E`，即 `&amp;` 和 `*` 被直接忽略，但是它们的 constraints 仍然起作用。所以 `(&amp;*(void *)0)` 并不会报错。
`&amp;a[i]` 等价于 `a &#43; i`，即忽略了 `&amp;` 以及 `*` (由 `[]` 隐式指代)。
其它情况 `&amp;` 运算的结果为一个指向 object 或 function 的指针。

如果 `*` 运算符的操作数是一个指向 function 的指针，则结果为对应的 function designator。
如果 `*` 运算符的操作数是一个指向 object 的指针，则结果为指示该 obejct 的左值。
如果 `*` 运算符的操作数为非法值的指针，则对该指针进行 `*` 运算的行为三未定义的。

#### 6.5.3.3 Unary arithmetic operators

**Constraints**

单目 `&#43;` 或 `-` 运算符的操作数必须为算数类型 (arithmetic type)，`~` 运算符的操作数必须为整数类型 (integer type)，`!` 运算符的操作数必须为常数类型 (scalar type)。

**Semantics**

在进行单目 `&#43;`、`-`、`~` 运算之前，会对操作数进行整数提升 (integer promotions)，结果的类型与操作数进行整数提升后的类型一致。

`!E` 等价于 `(E==0)`，结果为 `int` 类型。

#### 6.5.3.4 

待补充

### 6.5.7 Bitwise shift operators

**Syntax**

```
shift-expression:
    additive-exprssion
    shift-exprssion &gt;&gt; additive-expression
    shift-exprssion &lt;&lt;cadditive-expression
```

**Constraints**

位运算的操作数都必须为整数类型。

**Semantics**

在进行位运算之前会先对操作数进行整数提升 (integer promotion)，位运算结果类型与整数提升后的左操作数一致。如果右运算数是负数，或者大于等于整数提升后的左运算数的类型的宽度，那么这个位运算行为是未定义的。

&gt; 假设运算结果的类型为 **T**

{{&lt; raw &gt;}}$E1 &lt;&lt; E2${{&lt; /raw &gt;}}

- 如果 **E1** 是无符号，则结果为 $E1 \times 2^{E2} \bmod (\max[T] &#43; 1)$。
- 如果 **E1** 是有符号，**E1** 不是负数，并且 **T** 可以表示 $E1 \times 2^{E2}$，则结果为 $E1 \times 2^{E2}$。

除了以上两种行为外，其他均是未定义行为。

{{&lt; raw &gt;}}$E1 &gt;&gt; E2${{&lt; /raw &gt;}}

- 如果 **E1** 是无符号，或者 **E1** 是有符号并且是非负数，则结果为 $E1 / 2^{E2}$。
- 如果 **E1** 是有符号并且是负数，则结果由具体实现决定 (implementation-defined)。



---

> 作者: [Xshine](https://github.com/LoongGshine)  
> URL: https://loonggshine.github.io/posts/c-specification/ch6/  

