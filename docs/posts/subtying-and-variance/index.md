# Crust of Rust: Subtying and Variance


> In this episode of Crust of Rust, we go over subtyping and variance — a niche part of Rust that most people don't have to think about, but which is deeply ingrained in some of Rust's borrow ergonomics, and occasionally manifests in confusing ways. In particular, we explore how trying to implement the relatively straightforward `strtok` function from C/C++ in Rust quickly lands us in a place where the function is more or less impossible to call due to variance!

<!--more-->

- 整理自 [John Gjengset 的影片](https://www.youtube.com/watch?v=iVYWDIW71jk)

## 影片注解

### strtok

> A sequence of calls to this function split str into tokens, which are sequences of contiguous characters separated by any of the characters that are part of delimiters.

- cplusplus: [strtok](https://cplusplus.com/reference/cstring/strtok/)
- cppreference: [strtok](https://en.cppreference.com/w/cpp/string/byte/strtok)

### shortening lifetimes

影片大概 19 分时给出了为何 cargo test 失败的推导，个人觉得非常巧妙

```rs
pub fn strtok<'a>(s: &'a mut &'a str, delimiter: char) { ... }

let mut x = "hello world";
strtok(&mut x, ' ');
```

为了更直观地表示和函数 `strtok` 的返回值 lifetime 无关，这里将返回值先去掉了。在调用 `strtok` 时，编译器对于参数 `s` 的 lifetime 推导如下:

```rs
parameter: &'a mut &'a str
argument:  &   mut x

parameter: &'a mut &'a str
argument:  &   mut &'static str

parameter: &'a mut &'static str
argument:  &   mut &'static str

parameter: &'static mut &'static str
argument:  &        mut &'static str

parameter: &'static mut &'static str
argument:  &'static mut &'static str
```

所以 `strtok` 在接收参数 `s` 后 (通过传入 `&mut x`)，会推导其 lifetime 为 static，这就会导致后面使用 `x` 的不可变引用 (`&x`) 时发生冲突。

### Subtypes

下面是 Covariance 的一个例子，生命周期长的引用是生命周期短的引用的 subtype

```rs
fn main() {
    let s = String::new();
    let x: &'static str = "hello, world";
    let mut y: &str = &s;
    y = x;
}
```

> Since `'static` is subtype of `'a`

```rs
T: U
T is at least as useful as U

// e.g.
'static: 'a
'static is at least as useful as 'a
```

### Variance

- Covariance

```rs
fn foo(&'a str) {}
let x = &'a str

foo(&'a str)      -> x = 'a str
foo(&'static str) -> x = &'static str
```

- Contravariance

| Type          | Variance in `T` |
| :-----------: | :-------------: |
| `fn(T) -> ()`	|	contravariant   |

The only contravariance in Rust now (2024/6/25).

```rs
/* covariance */
&'static str  // more useful
&'a str
// &'static str is subtype of &'a str
// since 'static str is at least as useful as 'a str
'static <: 'a
&'static T <: &'a T

/* contravariance */
Fn(&'static str)
Fn(&'a str)   // more useful
// Fn(&'a str) subtype  of Fn(&'static str)
// since Fn(&'a str) is at least as useful as Fn(&'static str)
'static <: 'a
Fn(&'a T) <: Fn(&'static T)
```

- Invariance

| Type	      | Variance in `'a` |	Variance in `T` |
| :---------: | :--------------: | :--------------: |
| `&'a T`	    | covariant	       | covariant        |
| `&'a mut T` |	covariant	       | invariant        |

```rs
fn foo(s: &mut &'a str, x: &'a str) {
  *s = x;
}

let mut x: &'static str = "hello world";
let z = String::new();
foo(&mut x, &z);
    foo(&mut &'a      str, &'a      str)
    foo(&mut &'static str, &'a      str)
    foo(&mut &'static str, &'static str)
drop(z);
println("{}", z); // should compiler error!
```

`&'a mut T` 是 Invariant，如果它是 Covariant 的话，上面例子会造成 `x` 的生命周期缩短 (因为 `&mut` 可以改变值，这可能会导致原预定生命周期内出现了悬垂引用)，这不符合我们的预期，所以需要将函数参数的 `&mut` 设置为 Invariant，即只能传入和原先生命周期完全一致的才行，more useful 或 less useful 都不行。而 `&` 并不能改变值，并不会隐形被引用部分的生命周期，所以是 Covariant。

***Invariant 也是编译器推导未知生命周期的一个主要理论依据***，此时可以运用该规则去思考一下之前 `strtok` 的错误。

注意上面表格规定的是 `&'a mut T` 里的 `'a` 是 Covariant:

```rs
pub fn bar() {
    let mut y = true;
    let mut z /* &'y mut bool */ = &mut y;

    let x = Box::new(true);
    let x: &'static mut bool = Box::leak(x);

    // ignore this line
    let _ = z;

    z = x; // &'y mut bool = &'static mut bool

    // ignore this line
    drop(z);
}
```

### 再看 strtok

分析 `check_is_static()` 这个函数对生命周期的影响:
- 当没有调用 `check_is_static(x)` 时，编译器会认为 `x` 所指向的字符串的生命周期为当前这个函数范围 (`'x`)，所以只要 `strtok` 调用后没有使用任意 `x` 的引用都不会出现问题
- 当调用了 `check_is_static(x)` 后，编译器只能认为 `x` 所指向的字符串的生命周期为 `'static` 了，这就导致了 `x` 在超过这个函数后就被 drop 了 (`'x`)，但是 `&mut x` 这个引用被编译器推导为 `'static`，会出现 `&mut x` 这个引用 (`'static`) 超过了 `x` 的作用域 (`'x`) 的错误 =

```rs
fn check_is_static(_: &'static str) {}

let mut x = "Hello world";
check_is_static(x);

<'a> &'a mut &'a str
     &'x mut &'x str            // without check_is_static()
     &'static mut &'static str  // with check_is_static()

let hello = strtok(&mut x, ' ');
```

此时对可变引用 `&mut` 使用额外的生命周期标注即可解决上面的两个问题:

```rs
pub fn strtok<'a, 'b>(s: &'a mut &'b str, delimiter: char) -> &'b str {
```

```rs
strtok<'a, 'b>(&'a mut &'b      str) -> 'b      str
strtok        (&'x mut &'static str) -> 'static str

let z = &mut x; // &'x -> &'until-ZZZ
                // until-ZZZ: borrow of x stop here

let hello = strtok(&mut x, ' ');
```

因为 `&` 里的 `'a` 是 covariant，所以实际上编译器会认为 `z` 的类型为 `&'until-ZZZ mut`，依据 Covariance 可以接受 `&'x mut` 的变量。

### PhantomData and drop check

{{< admonition question "PhantomData 有何作用?" >}}
The reason why yu use `PhantomData` in general is yu might have a type that is generic over `T`, but doesn't contain a `T`. THis comes up often if you do something with FFI, like you do some kind of deserialzing something. You want a deserializer that is generic over the type it's going to deserialze, but it doesn't contain a `T`, it's just that you want the deserializer to know which types to produce.

So you add a field that's `PhantomData` and `PhantomData` is the only type in Rust that is generic over a type parameter, but doesn't contain that type parameter.
{{< /admonition >}}

```rs
struct TouchDrop<T: std::fmt::Debug>(T);

impl<T: std::fmt::Debug> Drop for TouchDrop<T> {
    fn drop(&mut self) {
        println!("{:?}", self.0);
    }
}

fn main() {
    let x = String::new();
    let z = vec![TouchDrop(&x)];
    drop(x);
    // drop(z)
}
```

这段程式码会导致编译错误，因为在 `main` 函数的末尾会有一个隐式的 `drop(z)`，而 `drop(z)` 这个调用依据上面的自定义 `drop` 函数，需要访问 `self.0`，但是 `self.0` 这个引用所指向的对象，在上一行的 `drop(x)` 时就被销毁了，所以此时隐式调用的 `drop(z)` 会有悬垂引用的危险，从而导致编译错误。

但是将上面程式码的第 11 行改为 `let z = vec![&x];` 则不会有编译错误，这是因为 `Vec` 类型的 `drop` 方法并不会访问内部的 `T` (这段程式码里对应 `&String`)，不会出现悬垂引用。

```rs
use std::marker::PhantomData;
struct Deserializer<T> {
    // some fields
    _t: PhantomData<T>,
}
struct Deserializer2<T> {
    // some fields
    _t: PhantomData<fn() -> T>,
}
struct Deserializer3<T> {
    // some fields
    _t: PhantomData<fn(T)>,
}
struct Deserializer4<T> {
    // some fields
    _t1: PhantomData<fn(T)>,
    _t2: PhantomData<fn() -> T>,
    // or just
    _t: PhantomData<fn(T) -> T>,
}
```

上面的第一种结构体 `Deserializer`，编译器在 drop check 时会检查是否也 drop 了泛型参数表示的内部数据类型 `T`，但这个 `T` 类型所指向的对象在 `drop` 可能早被 drop 了 (悬垂引用，比如 `T` 为引用的场景)，而第二种结构体 `Deserializer2`，编译器 drop check 时就不会进行这种检查，因为包含的仅仅是函数签名，需要注意的是第三种结构体 `Deserializer3` 和第二种结构体 `Deserializer3` 是不同的，这是因为 Variance 的存在，对于第二种结构体 `Deserializer2`，它是 Covariance，而第三种结构体 `Deserializer3` 却是 Contravariance 的。

第四种结构体 `Deserializer4` 的内部数据类型 `T` 则是 Invariance，因为 `_t1` 说明它是 Covariance，`_t2` 说明它是 Contravariance，结合起来就是 Invariance。这个结构体也可以改为以下来实现 INvariance:

```rs
struct Deserializer4<T> {
    // some fields
    _t: PhantomData<*mut T>,
}
```

使用可变裸指针 `*mut`，这是因为如果使用可变引用 `&mut` 的话需要引入生命周期标注，而使用可变裸指针 `*mut` 也可以达到 Invariance 的效果又无需添加生命周期标注。

| Type          | Variance in `T` |
| :-----------: | :-------------: |
| `*const T`		| covariant       |
| `*mut T`		  | invariant       |

{{< admonition >}}
关于 drop check 这部分的内容，下一期会特别针对性的讲解，这里有个大概印象即可。
{{< /admonition >}}

## Homework

{{< admonition info >}}
- [ ] 完善 `strtok` 函数使其可以接受多个分隔符作为参数
{{< /admonition >}}

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

> 可以使用这里提供的搜素栏进行搜索 (BTW 不要浪费时间在 Google 搜寻上！)

- method [str::find](https://doc.rust-lang.org/std/primitive.str.html#method.find)
- method [char::len_utf8](https://doc.rust-lang.org/std/primitive.char.html#method.len_utf8)
- method [std::boxed::Box::leak](https://doc.rust-lang.org/std/boxed/struct.Box.html#method.leak)
- Struct [std::marker::PhantomData](https://doc.rust-lang.org/std/marker/struct.PhantomData.html)
- Struct [std::ptr::NonNull](https://doc.rust-lang.org/std/ptr/struct.NonNull.html)

## References

- The Rust Reference: [Subtyping and Variance](https://doc.rust-lang.org/reference/subtyping.html)
- The Rustonomicon: [Subtyping and Variance](https://doc.rust-lang.org/nomicon/subtyping.html)
- [Lifetime variance in Rust](https://github.com/sunshowers-code/lifetime-variance)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/subtying-and-variance/  

