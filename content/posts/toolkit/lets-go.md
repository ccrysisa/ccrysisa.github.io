---
title: "Let's Go!"
subtitle:
date: 2024-03-25T10:16:26+08:00
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
  - Go
categories:
  - Toolkit
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

<!--more-->

## A Tour of Go

- [A Tour of Go](https://go.dev/tour/list)

### Welcome

> Throughout the tour you will find a series of slides and exercises for you to complete.

- [Download and install](https://go.dev/doc/install)

```bash
# Donwload latest go, then remove previous installed go and extract archive
$ rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz
# Add this path to ~/.bashrc or /etc/profile file
export PATH=$PATH:/usr/local/go/bin
# Vertify version of installed go (after refresh)
$ go version
```

Install the tour locally:

```bash
$ go install golang.org/x/website/tour@latest
```

GOPATH 的默认路径是: `/home/user/go/`

#### Exercise: Determining the significance of date 2009-11-10 23:00:00 UTC

- Stack Overflow: [Go time.Now() is always 2009-11-10 23:00:00 +0000 UTC](https://stackoverflow.com/questions/24539986/go-time-now-is-always-2009-11-10-230000-0000-utc)

> This is the time and date of Go Lang\'s birthday.

### Packages, variables, and functions

Go 的 Package 既作为编译单元，又作为项目结构的组织单位，相当于 Rust 的 Crate 和 Module 的结合。

> Programs start running in package `main`.

Go 的 Package `main` 有些类似于 Rust 的 Crate *root* (即与 Package 同名的根 crate).

> In Go, a name is exported if it begins with a capital letter.

有点类似于 [Cherno](https://www.youtube.com/@TheCherno) 的 C++ 代码风格

> Go\'s return values may be named. If so, they are treated as variables defined at the top of the function.

这是一种常见的 C 代码风格的语法糖:

```c
int func(int x)
{
    int res;
    ...
    return res;
}
```

> The `var` statement declares a list of variables; as in function argument lists, the type is last.

Go 和 Rust 都使用类型后置语法: Go 用 `var`, Rust 用 `let`

> If an initializer is present, the type can be omitted; the variable will take the type of the initializer.

与 Rust 类似的自动类型推断功能

一些值得注意的特殊类型:

```go
byte // alias for uint8

rune // alias for int32
     // represents a Unicode code point
```

> The `int`, `uint`, and `uintptr` types are usually 32 bits wide on 32-bit systems and 64 bits wide on 64-bit systems. 

与 Rust 的 `isize`, `usize` 想死，其字长与机器架构相关

> The expression `T(v)` converts the value `v` to the type `T`.

> Unlike in C, in Go assignment between items of different type requires an explicit conversion. 

C 语言风格的强制类型转换 (缺点是在代码库难以检索类型转换的使用时机)，但是未保留 C 语言风格的隐式类型转换

> Numeric constants are high-precision values.   
> An untyped constant takes the type needed by its context.

有趣的特性，需要通过编译器才能实现不同上下文使用不同精度的数值类型

> Like for, the `if` statement can start with a short statement to execute before the condition.

这也是某种常见的 C 代码风格的语法糖:

```c
int val = 0;
if (val) {
    ...
}
```

#### Exercise: Loops and Functions

```go
package main

import (
	"fmt"
)

func Sqrt(x float64) float64 {
	z := 1.0
	for i := 0; i < 10; i++ {
		z -= (z*z - x) / (2 * z)
	}
	return z
}

func main() {
	fmt.Println(Sqrt(2))
}
```

> Another important difference is that Go\'s switch cases need not be constants, and the values involved need not be integers.

Go 的 `switch` 语句的表达能力更加强大

> The deferred call\'s arguments are evaluated immediately, but the function call is not executed until the surrounding function returns.

> Deferred function calls are pushed onto a stack. When a function returns, its deferred calls are executed in last-in-first-out order.

`defer` 表达式的意义为：完成函数调用前的一系列工作，但将函数调用这个动作推迟到当前函数 (`defer` 表达式所在的作用域) 结束后进行

### More types: structs, slices, and maps

> Unlike C, Go has no pointer arithmetic.

Go 的指针相比 C 的指针被削减了最具表达能力 (黑魔法) 的指针运算语法

> n array has a fixed size. A slice, on the other hand, is a dynamically-sized, flexible view into the elements of an array. In practice, slices are much more common than arrays.

与 Rust 相似，切片 (slice) 表达能力极强

> The capacity of a slice is the number of elements in the underlying array, counting from the first element in the slice.

注意这里描述的计算规则

> A nil slice has a length and capacity of 0 and has no underlying array.

`nil` 切片相当于空指针

#### Exercise: Slices

```go
package main

import "golang.org/x/tour/pic"

func Pic(dx, dy int) [][]uint8 {
	pic := make([][]uint8, dx)
	for x := 0; x < dx; x++ {
		pic[x] = make([]uint8, dy)
		for y := 0; y < dy; y++ {
			pic[x][y] = uint8((x + y) / 2)
			// pic[x][y] = uint8(x * y)
			// pic[x][y] = uint8(x ^ y)
		}
	}
	return pic
}

func main() {
	pic.Show(Pic)
}
```

#### Exercise: Maps

```go
package main

import (
	"strings"

	"golang.org/x/tour/wc"
)

func WordCount(s string) map[string]int {
	counts := make(map[string]int)
	for _, k := range strings.Fields(s) {
		_, ok := counts[k]
		if ok {
			counts[k]++
		} else {
			counts[k] = 1
		}
		// or just
		counts[k]++
	}
	return counts
}

func main() {
	wc.Test(WordCount)
}
```

> Go functions may be closures. A closure is a function value that references variables from outside its body.

Go 的函数和闭包的语法完全相同，与 Python 的函数的一等公民的地位相似

#### Exercise: Fibonacci closure

```go
package main

import "fmt"

// fibonacci is a function that returns
// a function that returns an int.
func fibonacci() func() int {
	x, y := 1, 0
	return func() int {
		tmp := x + y
		x = y
		y = tmp
		return x
	}
}

func main() {
	f := fibonacci()
	for i := 0; i < 10; i++ {
		fmt.Println(f())
	}
}
```

### Methods and interfaces

```go
```

### Blogs

- [Inside the Go Playground](https://go.dev/blog/playground)
- [Go\'s Declaration Syntax](https://go.dev/blog/declaration-syntax)
- [Defer, Panic, and Recover](https://go.dev/blog/defer-panic-and-recover)
- [Go Slices: usage and internals](https://go.dev/blog/slices-intro)

## Packages

Go [Packages](https://pkg.go.dev/)

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

## References: 

- Matt KØDVB: [Go Class](https://www.youtube.com/playlist?list=PLoILbKo9rG3skRCj37Kn5Zj803hhiuRK6): 作为深入理解 Go 语言机制的参考材料

