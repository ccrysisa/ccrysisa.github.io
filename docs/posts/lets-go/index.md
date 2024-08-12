# Let&#39;s Go


&lt;!--more--&gt;

## A Tour of Go

{{&lt; link href=&#34;https://go.dev/tour/list&#34; content=&#34;原文地址&#34; external-icon=true &gt;}}

### Welcome

&gt; Throughout the tour you will find a series of slides and exercises for you to complete.

- [Download and install](https://go.dev/doc/install)

```bash
# Donwload latest go, then remove previous installed go and extract archive
$ rm -rf /usr/local/go &amp;&amp; tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz
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

- Stack Overflow: [Go time.Now() is always 2009-11-10 23:00:00 &#43;0000 UTC](https://stackoverflow.com/questions/24539986/go-time-now-is-always-2009-11-10-230000-0000-utc)

&gt; This is the time and date of Go Lang\&#39;s birthday.

- Stack Overflow: [What does the &#34;imports on/off&#34; switch do in golang tour?](https://stackoverflow.com/questions/62596691/what-does-the-imports-on-off-switch-do-in-golang-tour)

&gt; Imports On/Off enables or disables `goimports`.

&gt; `goimports` is very convenient to have as a save hook in your editor to automatically set imports for you (and cleanup, which is something that can easily be forgotten).

### Packages, variables, and functions

Go 的 Package 既作为编译单元，又作为项目结构的组织单位，相当于 Rust 的 Crate 和 Module 的结合。

&gt; Programs start running in package `main`.

Go 的 Package `main` 有些类似于 Rust 的 Crate *root* (即与 Package 同名的根 crate).

&gt; In Go, a name is exported if it begins with a capital letter.

有点类似于 [Cherno](https://www.youtube.com/@TheCherno) 的 C&#43;&#43; 代码风格

&gt; Go\&#39;s return values may be named. If so, they are treated as variables defined at the top of the function.

这是一种常见的 C 代码风格的语法糖:

```c
int func(int x)
{
    int res;
    ...
    return res;
}
```

&gt; The `var` statement declares a list of variables; as in function argument lists, the type is last.

Go 和 Rust 都使用类型后置语法: Go 用 `var`, Rust 用 `let`

&gt; If an initializer is present, the type can be omitted; the variable will take the type of the initializer.

与 Rust 类似的自动类型推断功能

一些值得注意的特殊类型:

```go
byte // alias for uint8

rune // alias for int32
     // represents a Unicode code point
```

&gt; The `int`, `uint`, and `uintptr` types are usually 32 bits wide on 32-bit systems and 64 bits wide on 64-bit systems. 

与 Rust 的 `isize`, `usize` 想死，其字长与机器架构相关

&gt; The expression `T(v)` converts the value `v` to the type `T`.

&gt; Unlike in C, in Go assignment between items of different type requires an explicit conversion. 

C 语言风格的强制类型转换 (缺点是在代码库难以检索类型转换的使用时机)，但是未保留 C 语言风格的隐式类型转换

&gt; Numeric constants are high-precision values.   
&gt; An untyped constant takes the type needed by its context.

有趣的特性，需要通过编译器才能实现不同上下文使用不同精度的数值类型

### Flow control statements: for, if, else, switch and defer

&gt; Like for, the `if` statement can start with a short statement to execute before the condition.

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
    &#34;fmt&#34;
)

func Sqrt(x float64) float64 {
    z := 1.0
    for i := 0; i &lt; 10; i&#43;&#43; {
        z -= (z*z - x) / (2 * z)
    }
    return z
}

func main() {
    fmt.Println(Sqrt(2))
}
```

&gt; Another important difference is that Go\&#39;s switch cases need not be constants, and the values involved need not be integers.

Go 的 `switch` 语句的表达能力更加强大

&gt; The deferred call\&#39;s arguments are evaluated immediately, but the function call is not executed until the surrounding function returns.

&gt; Deferred function calls are pushed onto a stack. When a function returns, its deferred calls are executed in last-in-first-out order.

`defer` 表达式的意义为：完成函数调用前的一系列工作，但将函数调用这个动作推迟到当前函数 (`defer` 表达式所在的作用域) 结束后进行

### More types: structs, slices, and maps

&gt; Unlike C, Go has no pointer arithmetic.

Go 的指针相比 C 的指针被削减了最具表达能力 (黑魔法) 的指针运算语法

&gt; n array has a fixed size. A slice, on the other hand, is a dynamically-sized, flexible view into the elements of an array. In practice, slices are much more common than arrays.

与 Rust 相似，切片 (slice) 表达能力极强

&gt; The capacity of a slice is the number of elements in the underlying array, counting from the first element in the slice.

注意这里描述的计算规则

&gt; A nil slice has a length and capacity of 0 and has no underlying array.

`nil` 切片相当于空指针

#### Exercise: Slices

```go
package main

import &#34;golang.org/x/tour/pic&#34;

func Pic(dx, dy int) [][]uint8 {
    pic := make([][]uint8, dx)
    for x := 0; x &lt; dx; x&#43;&#43; {
        pic[x] = make([]uint8, dy)
        for y := 0; y &lt; dy; y&#43;&#43; {
            pic[x][y] = uint8((x &#43; y) / 2)
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
    &#34;strings&#34;

    &#34;golang.org/x/tour/wc&#34;
)

func WordCount(s string) map[string]int {
    counts := make(map[string]int)
    for _, k := range strings.Fields(s) {
        _, ok := counts[k]
        if ok {
            counts[k]&#43;&#43;
        } else {
            counts[k] = 1
        }
        // or just
        counts[k]&#43;&#43;
    }
    return counts
}

func main() {
    wc.Test(WordCount)
}
```

&gt; Go functions may be closures. A closure is a function value that references variables from outside its body.

Go 的函数和闭包的语法完全相同，与 Python 的函数的一等公民的地位相似

#### Exercise: Fibonacci closure

```go
package main

import &#34;fmt&#34;

// fibonacci is a function that returns
// a function that returns an int.
func fibonacci() func() int {
    x, y := 1, 0
    return func() int {
        x, y = y, x&#43;y
        return x
    }
}

func main() {
    f := fibonacci()
    for i := 0; i &lt; 10; i&#43;&#43; {
        fmt.Println(f())
    }
}
```

### Methods and interfaces

&gt; You can only declare a method with a receiver whose type is defined in the same package as the method. You cannot declare a method with a receiver whose type is defined in another package (which includes the built-in types such as `int`).

与 Rust 的 Struct 实现 Trait 的限制类似，防止被恶意第三方污染库

&gt; Since methods often need to modify their receiver, pointer receivers are more common than value receivers.

&gt; With a value receiver, the `Scale` method operates on a copy of the original `Vertex` value.

与 Rust 的方法的 `self`, `&amp;self`, `&amp;mut self` 的设计思路相似，但是效果并不完全相同，因为 Rust  的 `self` 参数表示所有权概念，而 Go 的 value receiver 表示的则是 Copy 行为

&gt; Functions that take a value argument must take a value of that specific type
&gt; while methods with value receivers take either a value or a pointer as the receiver when they are called:

Go 的方法具备通过解引用来对参数类型进行自动推导的能力，没有普通函数那么严格的参数类型限制

&gt; A type implements an interface by implementing its methods. There is no explicit declaration of intent, no &#34;implements&#34; keyword.

这个设计虽然让代码变得简洁，但是导致了可读性变差以及不同 interface 同名方法的冲突，个人认为这个设计不够优雅

&gt; If the concrete value inside the interface itself is nil, the method will be called with a nil receiver.

&gt; A nil interface value holds neither value nor concrete type.

nil receiver 表示知道对象的具体类型，但对象为空指针，而 nil interface 则表示具体类型都不知道，对象本身就不存在

&gt; The interface type that specifies zero methods is known as the empty interface

这个特性非常实用，可以说是表达能力极强的模板或泛型语法糖

#### Exercise: Stringers

```go
package main

import &#34;fmt&#34;

type IPAddr [4]byte

// TODO: Add a &#34;String() string&#34; method to IPAddr.
func (ip IPAddr) String() string {
    return fmt.Sprintf(&#34;%v.%v.%v.%v&#34;, ip[0], ip[1], ip[2], ip[3])
}

func main() {
    hosts := map[string]IPAddr{
        &#34;loopback&#34;:  {127, 0, 0, 1},
        &#34;googleDNS&#34;: {8, 8, 8, 8},
    }
    for name, ip := range hosts {
        fmt.Printf(&#34;%v: %v\n&#34;, name, ip)
    }
}
```

#### Exercise: Errors

```go
package main

import (
    &#34;fmt&#34;
)

type ErrNegativeSqrt float64

func (e ErrNegativeSqrt) Error() string {
    return fmt.Sprint(&#34;cannot Sqrt negative number: &#34;, float64(e))
}

func Sqrt(x float64) (float64, error) {
    if x &lt; 0 {
        return 0, ErrNegativeSqrt(x)
    }
    z := 1.0
    for i := 0; i &lt; 10; i&#43;&#43; {
        z -= (z*z - x) / (2 * z)
    }
    return z, nil
}

func main() {
    fmt.Println(Sqrt(2))
    fmt.Println(Sqrt(-2))
}
```

#### Exercise: Readers

```go
package main

import &#34;golang.org/x/tour/reader&#34;

type MyReader struct{}

// TODO: Add a Read([]byte) (int, error) method to MyReader.
func (r MyReader) Read(b []byte) (n int, err error) {
    n = len(b)
    for i := 0; i &lt; n; i&#43;&#43; {
        b[i] = &#39;A&#39;
    }
    return
}

func main() {
    reader.Validate(MyReader{})
}
```

#### Exercise: rot13Reader

```go
package main

import (
    &#34;io&#34;
    &#34;os&#34;
    &#34;strings&#34;
)

type rot13Reader struct {
    r io.Reader
}

func (r *rot13Reader) Read(b []byte) (n int, err error) {
    n, err = r.r.Read(b)
    for i := 0; i &lt; n; i&#43;&#43; {
        switch {
        case b[i] &gt;= &#39;A&#39; &amp;&amp; b[i] &lt;= &#39;M&#39;:
            b[i] &#43;= 13
        case b[i] &gt;= &#39;N&#39; &amp;&amp; b[i] &lt;= &#39;Z&#39;:
            b[i] -= 13
        case b[i] &gt;= &#39;a&#39; &amp;&amp; b[i] &lt;= &#39;m&#39;:
            b[i] &#43;= 13
        case b[i] &gt;= &#39;n&#39; &amp;&amp; b[i] &lt;= &#39;z&#39;:
            b[i] -= 13
        }
    }
    return
}

func main() {
    s := strings.NewReader(&#34;Lbh penpxrq gur pbqr!&#34;)
    r := rot13Reader{s}
    io.Copy(os.Stdout, &amp;r)
}
```

#### Exercise: Images

```go
package main

import (
    &#34;image&#34;
    &#34;image/color&#34;

    &#34;golang.org/x/tour/pic&#34;
)

type Image struct {
    w, h int
}

func (i Image) ColorModel() color.Model {
    return color.RGBAModel
}

func (i Image) Bounds() image.Rectangle {
    return image.Rect(0, 0, i.w, i.h)
}

func (i Image) At(x, y int) color.Color {
    v := uint8((x &#43; y) / 2)
    // v := uint8(x * y)
    // v := uint8(x ^ y)
    return color.RGBA{v, v, 255, 255}
}

func main() {
    m := Image{255, 255}
    pic.ShowImage(m)
}
```

### Generics

Go 的泛型与 Rust 相似，都可以使用指定特征限制语法

```go
package main

import &#34;fmt&#34;

// List represents a singly-linked list that holds
// values of any type.
type List[T any] struct {
    next *List[T]
    val  T
}

func push[T any](list List[T], val T) List[T] {
    return List[T]{
        next: &amp;list,
        val:  val,
    }
}

func pop[T any](list List[T]) (T, List[T]) {
    return list.val, *list.next
}

func main() {
    list := List[int]{nil, 1}
    fmt.Println(list)
    list = push(list, 2)
    fmt.Println(list)
    fmt.Println(list.next)
    val, list := pop(list)
    fmt.Println(val)
    fmt.Println(list)
}
```

### Concurrency

&gt; A *goroutine* is a lightweight thread managed by the Go runtime.

*goroutine* 相当轻量，这也是为什么 Go 常被用于多线程、并发的场景

&gt; Channels are a typed conduit through which you can send and receive values with the channel operator, `&lt;-`.

&gt; This allows goroutines to synchronize without explicit locks or condition variables.

&gt; Sends to a buffered channel block only when the buffer is full. Receives block when the buffer is empty.

Go 的 channel 自带锁机制，无需程序员手动使用锁来实现相应的同步机制

&gt; Only the sender should close a channel, never the receiver. Sending on a closed channel will cause a panic.

&gt; Channels aren&#39;t like files; you don&#39;t usually need to close them. Closing is only necessary when the receiver must be told there are no more values coming, such as to terminate a `range` loop.

与 C 语言中的 pipe (管道)  不同，Go 语言的 channel 只能由 sender 关闭。因为 Go 语言带有 GC，所以 channel 关闭与否并不是必要的

&gt; A `select` blocks until one of its cases can run, then it executes that case. It chooses one at random if multiple are ready.

&gt; The `default` case in a `select` is run if no other case is ready.

与系统调用 `select`, `poll`, `epoll` 相似，本质上都是 IO 多路复用模型

#### Exercise: Equivalent Binary Trees

```go
package main

import (
    &#34;fmt&#34;

    &#34;golang.org/x/tour/tree&#34;
)

// Walk walks the tree t sending all values
// from the tree to the channel ch.
func Walk(t *tree.Tree, ch chan int) {
    walk(t, ch)
    close(ch)
}

func walk(t *tree.Tree, ch chan int) {
    if t == nil {
        return
    }
    walk(t.Left, ch)
    ch &lt;- t.Value
    walk(t.Right, ch)
}

// Same determines whether the trees
// t1 and t2 contain the same values.
func Same(t1, t2 *tree.Tree) bool {
    c1, c2 := make(chan int), make(chan int)
    go Walk(t1, c1)
    go Walk(t2, c2)
    for {
        v1, ok1 := &lt;-c1
        v2, ok2 := &lt;-c2
        if ok1 == false &amp;&amp; ok2 == false {
            return true
        }
        if ok1 != ok2 || v1 != v2 {
            return false
        }
    }
}

func main() {
    ch := make(chan int)
    go Walk(tree.New(1), ch)
    for i := range ch {
        fmt.Println(i)
    }
    fmt.Println(Same(tree.New(1), tree.New(1)))
    fmt.Println(Same(tree.New(1), tree.New(2)))
}
```

&gt; This concept is called mutual exclusion, and the conventional name for the data structure that provides it is mutex.

&gt; We can also use `defer` to ensure the mutex will be unlocked as in the `Value` method.

Go 中也有互斥锁 (Mutex)，锁的的释放搭配 `defer` 语法会比较简洁

#### Exercise: Web Crawler

与并发素数筛相似，每个 goroutine 保有两种 channel，一个是向上层发送完成信号的 channel，另一个是接收下层完成信号的 channel

```goat
&#43;-----------&#43;        &#43;-----------&#43;        &#43;-----------&#43;        &#43;-----------&#43;
| goroutine |  chan  | goroutine |  chan  | goroutine |  chan  |   main    |
| (level 3) | -----&gt; | (level 2) | -----&gt; | (level 1) | -----&gt; | (level 0) |
&#43;-----------&#43;        &#43;-----------&#43;        &#43;-----------&#43;        &#43;-----------&#43;
```

```go
package main

import (
    &#34;fmt&#34;
    &#34;sync&#34;
)

type Fetcher interface {
    // Fetch returns the body of URL and
    // a slice of URLs found on that page.
    Fetch(url string) (body string, urls []string, err error)
}

// SafeCounter is safe to use concurrently.
type SafeCounter struct {
    mu sync.Mutex
    v  map[string]bool
}

// Inc increments the counter for the given key.
func (c *SafeCounter) Set(key string) {
    c.mu.Lock()
    // Lock so only one goroutine at a time can access the map c.v.
    c.v[key] = true
    c.mu.Unlock()
}

// Value returns the current value of the counter for the given key.
func (c *SafeCounter) Get(key string) bool {
    c.mu.Lock()
    // Lock so only one goroutine at a time can access the map c.v.
    defer c.mu.Unlock()
    _, ok := c.v[key]
    return ok
}

var c = SafeCounter{v: make(map[string]bool)}

// Crawl uses fetcher to recursively crawl
// pages starting with url, to a maximum of depth.
func Crawl(url string, depth int, fetcher Fetcher, exit chan bool) {
    // TODO: Fetch URLs in parallel.
    // TODO: Don&#39;t fetch the same URL twice.
    // This implementation doesn&#39;t do either:
    if depth &lt;= 0 || c.Get(url) {
        exit &lt;- true
        return
    }
    body, urls, err := fetcher.Fetch(url)
    if err != nil {
        fmt.Println(err)
        exit &lt;- true
        return
    }
    fmt.Printf(&#34;found: %s %q\n&#34;, url, body)
    c.Set(url)
    e := make(chan bool)
    for _, u := range urls {
        go Crawl(u, depth-1, fetcher, e)
    }
    for i := 0; i &lt; len(urls); i&#43;&#43; {
        &lt;- e
    }
    exit &lt;- true
    return
}

func main() {
    exit := make(chan bool)
    go Crawl(&#34;https://golang.org/&#34;, 4, fetcher, exit)
    &lt;- exit
}

// fakeFetcher is Fetcher that returns canned results.
type fakeFetcher map[string]*fakeResult

type fakeResult struct {
    body string
    urls []string
}

func (f fakeFetcher) Fetch(url string) (string, []string, error) {
    if res, ok := f[url]; ok {
        return res.body, res.urls, nil
    }
    return &#34;&#34;, nil, fmt.Errorf(&#34;not found: %s&#34;, url)
}

// fetcher is a populated fakeFetcher.
var fetcher = fakeFetcher{
    &#34;https://golang.org/&#34;: &amp;fakeResult{
        &#34;The Go Programming Language&#34;,
        []string{
            &#34;https://golang.org/pkg/&#34;,
            &#34;https://golang.org/cmd/&#34;,
        },
    },
    &#34;https://golang.org/pkg/&#34;: &amp;fakeResult{
        &#34;Packages&#34;,
        []string{
            &#34;https://golang.org/&#34;,
            &#34;https://golang.org/cmd/&#34;,
            &#34;https://golang.org/pkg/fmt/&#34;,
            &#34;https://golang.org/pkg/os/&#34;,
        },
    },
    &#34;https://golang.org/pkg/fmt/&#34;: &amp;fakeResult{
        &#34;Package fmt&#34;,
        []string{
            &#34;https://golang.org/&#34;,
            &#34;https://golang.org/pkg/&#34;,
        },
    },
    &#34;https://golang.org/pkg/os/&#34;: &amp;fakeResult{
        &#34;Package os&#34;,
        []string{
            &#34;https://golang.org/&#34;,
            &#34;https://golang.org/pkg/&#34;,
        },
    },
}
```

### Homework

阅读相关博客:
- [Inside the Go Playground](https://go.dev/blog/playground)
- [Go\&#39;s Declaration Syntax](https://go.dev/blog/declaration-syntax)
- [Defer, Panic, and Recover](https://go.dev/blog/defer-panic-and-recover)
- [Go Slices: usage and internals](https://go.dev/blog/slices-intro)

## Packages

Go [Packages](https://pkg.go.dev/)

&gt; 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

## References: 

- Matt KØDVB: [Go Class](https://www.youtube.com/playlist?list=PLoILbKo9rG3skRCj37Kn5Zj803hhiuRK6): 作为深入理解 Go 语言机制的参考材料
- [Learn Go with Tests](https://quii.gitbook.io/learn-go-with-tests)
- [Go by Example](https://gobyexample.com/)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/lets-go/  

