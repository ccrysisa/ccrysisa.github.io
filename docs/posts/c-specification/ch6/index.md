# C 规格第 6 章阅读记录


C 语言规格书 Chapter 6 - Language 阅读记录。

<!--more-->

## 6.2 Concepts

### 6.2.2 Linkages of identifiers

linkage:
- external
- internal
- none

一个拥有 file scope 并且关于 object 或 function 的 identifier 声明，如果使用 `static` 修饰，则该 identifer 有 internal linkage，e.g.

```c
// file scope
static int a;
static void f();

int main() {}
```

一个 scope 内使用 `static` 修饰的 identifier 声明，如果在同一 scope 内已存在该 identifier 声明，则该 identifier 的 linkage 取决于先前的 identifier 声明。如果该 identifier 不存在先前声明或者先前声明 no linkage，则该 identifier 是 external linkage，e.g.

```c
// Example 1
static int a; // a is internal linkage
extern int a; // linkage is the same as prior

// Example 2
extern int b; // no prior, a is external linkage
extern int b; // linkage is the same as prior
```

如果一个 function identifier 声明没有 storage-class 修饰符，则其 linkage 等价于加上 `extern` 修饰的声明的 linkage，e.g.

```c
int func(int a, int b);
// equal to `extern int func(int a. int b);`
// and then no prior, it is external linkage
```

如果一个 object identifier 声明没有 storage-class 修饰符，且拥有 file scope，则其拥有 external linkage，e.g.

```c
// file scope
int a; // external linkage
int main() {}
```

## 6.5 Expressions

**Syntax**

```
unary-exprssion:
    postfix-exprssion
    ++ unary-expression
    -- unary-expression
    unary-operator cast-exprssion
    sizeof unary-expression
    sizeof ( type-name )
unary-operator: one of
    & * + - ~ !
```

### 6.5.3 Unary operators

{{< admonition open=false >}}
C99 [6.2.5] ***Types***

- There are three *real floating types*, designated as `float`, `double`, and `long double`.

- The real floating and complex types are collectively called the *floating types*.

- The integer and real floating types are collectively called *real types*.

- Integer and floating types are collectively called *arithmetic types*.

- A *function type* describes a function with specified return type. A function type is
characterized by its return type and the number and types of its parameters. A
function type is said to be derived from its return type, and if its return type is T, the
function type is sometimes called ''function returning T''. The construction of a
function type from a return type is called ‘‘function type derivation’’.

- Arithmetic types and pointer types are collectively called *scalar types*.

C99 [6.3.2.1] ***Lvalues, arrays, and function designators***

- A *function designator* is an expression that has function type. Except when it is the
operand of the `sizeof` operator or the unary `&` operator, a function designator with
type ‘‘function returning type’’ is converted to an expression that has type ‘‘pointer to
function returning type’’.
{{< /admonition >}}

#### 6.5.3.1 Prefix increment and decrement operators

**Constraints**

前缀自增或自减运算符的操作数，必须为实数 (real types) 类型（即不能是复数）或者是指针类型，并且其值是可变的。

**Semantics**

- `++E` 等价于 `(E+=1)`
- `--E` 等价于 `(E-=1)`

#### 6.5.3.2 Address and indirection operators

**Constraints**

`&` 运算符的操作数必须为 function designator，`[]` 或 `*` 的运算结果，或者是一个不是 bit-field 和 `register` 修饰的左值。

`*` 运算符的操作数必须为指针类型。

**Semantics**

`&*E` 等价于 `E`，即 `&` 和 `*` 被直接忽略，但是它们的 constraints 仍然起作用。所以 `(&*(void *)0)` 并不会报错。
`&a[i]` 等价于 `a + i`，即忽略了 `&` 以及 `*` (由 `[]` 隐式指代)。
其它情况 `&` 运算的结果为一个指向 object 或 function 的指针。

如果 `*` 运算符的操作数是一个指向 function 的指针，则结果为对应的 function designator。
如果 `*` 运算符的操作数是一个指向 object 的指针，则结果为指示该 obejct 的左值。
如果 `*` 运算符的操作数为非法值的指针，则对该指针进行 `*` 运算的行为三未定义的。

#### 6.5.3.3 Unary arithmetic operators

**Constraints**

单目 `+` 或 `-` 运算符的操作数必须为算数类型 (arithmetic type)，`~` 运算符的操作数必须为整数类型 (integer type)，`!` 运算符的操作数必须为常数类型 (scalar type)。

**Semantics**

在进行单目 `+`、`-`、`~` 运算之前，会对操作数进行整数提升 (integer promotions)，结果的类型与操作数进行整数提升后的类型一致。

`!E` 等价于 `(E==0)`，结果为 `int` 类型。

#### 6.5.3.4 

待补充

### 6.5.7 Bitwise shift operators

**Syntax**

```
shift-expression:
    additive-exprssion
    shift-exprssion >> additive-expression
    shift-exprssion <<cadditive-expression
```

**Constraints**

位运算的操作数都必须为整数类型。

**Semantics**

在进行位运算之前会先对操作数进行整数提升 (integer promotion)，位运算结果类型与整数提升后的左操作数一致。如果右运算数是负数，或者大于等于整数提升后的左运算数的类型的宽度，那么这个位运算行为是未定义的。

> 假设运算结果的类型为 **T**

{{< raw >}}$E1 << E2${{< /raw >}}

- 如果 **E1** 是无符号，则结果为 $E1 \times 2^{E2} \bmod (\max[T] + 1)$。
- 如果 **E1** 是有符号，**E1** 不是负数，并且 **T** 可以表示 $E1 \times 2^{E2}$，则结果为 $E1 \times 2^{E2}$。

除了以上两种行为外，其他均是未定义行为。

{{< raw >}}$E1 >> E2${{< /raw >}}

- 如果 **E1** 是无符号，或者 **E1** 是有符号并且是非负数，则结果为 $E1 / 2^{E2}$。
- 如果 **E1** 是有符号并且是负数，则结果由具体实现决定 (implementation-defined)。



---

> 作者: [Xshine](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/c-specification/ch6/  

