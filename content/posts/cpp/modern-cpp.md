---
title: "Modern C++"
subtitle:
date: 2024-06-30T00:19:25+08:00
slug: f341f9f
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
  - C++
categories:
  - C++
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRss: false
hiddenFromRelated: false
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

"Modern" C++ isn't afraid to use any or all of the following:

- RAII
- standard library containers and algorithms
- templates
- metaprogramming
- exceptions
- Boost

"Old" C++ tends to avoid these things due to a perceived lack of compiler support or run-time performance. Instead, you'll find...

- lots of `new` and `delete`
- roll-your-own linked lists and other data structures
- return codes as a mechanism for error handling
- one of the millions of custom string classes that aren't std::string

As with all this-vs-that arguments, there are merits to both approaches. Modern C++ isn't universally better. Embedded enviornments, for example, often require extra restrictions that most people never need, so you'll see a lot of old-style code there. Overall though, I think you'll find that most of the modern features are worth using regularly. Moore's Law and compiler improvements have taken care of the majority of reasons to avoid the new stuff.

<!--more-->

---

整理自 Stack Overflow: [What is modern C++?](https://stackoverflow.com/questions/3661237/what-is-modern-c)

## Toolchain

> Wikipedia: [Toolchain](https://en.wikipedia.org/wiki/Toolchain)

- OS: Windows 10
- IDE: [Visual Studio](https://visualstudio.microsoft.com/) 2019 Community edition
  - Clang Power Tools
  - [cppcheck-vs-addin](https://github.com/VioletGiraffe/cppcheck-vs-addin) vsix
  - ClangFormat
- [LLVM](https://releases.llvm.org/download.html) 17.0.1 Win64
- [Cppcheck](https://cppcheck.sourceforge.io/) 2.13 Win64
- [HxD](https://mh-nexus.de/en/hxd/)

### Compiler

#### Preprocess

> Visual Studio 2019
$\rightarrow$
右键项目然后 properties 
$\rightarrow$
C/C++ 
$\rightarrow$
Preprocess to File (Yes) 

编译 / 构建后可以得到产生后缀为 `.i` 的预处理中间文件

#### 条件编译
```c++
#if <condition>
  ...
#else
  ...
#endif
```

#### Assembly

> Visual Studio 2019
$\rightarrow$
右键项目然后 properties 
$\rightarrow$
C/C++ 
$\rightarrow$
Output Files
$\rightarrow$
Assembler Output (Assembly-Only Listing)

编译 / 构建后可以得到后缀为 `.asm` 的汇编文件

#### Optimization

> Visual Studio 2019
$\rightarrow$
右键项目然后 properties 
$\rightarrow$
C/C++ 
$\rightarrow$
Optimization
$\rightarrow$
Optimization (Maximize Speed)

可以改变当前构建环境 (一般是 Debug 模式) 所使用的编译器最优化策略

{{< admonition note "快捷键" >}}
- F7: Compile / Build
- F5: Run (Compile and Link)
{{< /admonition >}}

### Linker

Linker 的一个重要作用是 **定位程序的入口 (entry point)**，所以对于单源文件的项目来说，Linker 也会起作用

{{< admonition >}}
Visual Studio 的错误提示中，`C` 开头的错误 (error) 表示的是编译 (Compile) 时期的错误，`LNK` 开头的错误 (error) 表示的是链接 (Link) 时期的错误
{{< /admonition >}}

解决函数重复定义这个问题，可以给其中一个函数的签名加上 `static` 或 `inline` 的修饰

### Debug

Breakpoint & Memory

调试时相关信息的窗口在「调试 $\rightarrow$ 窗口」处可以开启显示

在内存查看窗口，可以通过 `&var` (`var` 为当前上下文变量的名字) 来快速获取该变量对应的地址，以及查看该地址所所储存的值

调试过程中，通过「右键 $\rightarrow$ 转到反汇编」即可查看对应的汇编代码

### Project Setup 

filter 类似于一种虚拟的文件系统组织，不过只能在 VS 才能表示为层次形式 (通过解析 XML 格式的配置文件)，在主机的文件系统上没有影响

解决方案栏的「显示所有文件」可以展示当前 Project 在主机文件系统下的组织层次结构，也可以在这个视图下创建目录 / 文件，这样也会在主机文件系统创建对应的目录 / 文件

主机文件系统和 VS 的虚拟项目组织是解耦的，所以在主机移动源文件并不会影响其在 VS 的虚拟项目组织所在的位置

VS 默认设置是将构建 / 编译得到的中间文件放在 Project 的 Debug 目录，但是得到的可执行文件却放在 Solution 的 Debug 目录下，这十分奇怪。可以通过修改 Project 的属性 (右键选择属性这一选项) 里的输出目录，使得其与中间目录一致为 `$(Configuration)\`。也可以将 Solution 内的全部 Projects 的可执行文件均放置在 Solution 下的同一目录

推荐设定如下:
- Output Directory: `$(SolutionDir)\bin\$(Platform)\$(Configuration)\`
- Intermediate Directory: `$(SolutionDir)\bin\intermidiate\$(Platform)\$(Configuration)\`

{{< admonition >}}
在编辑这些目录设定时，其下拉框中选择「编辑」字段可以查看形如 `$(SolutionDir)` 这些宏的定义
{{< /admonition >}}

## Header File

Header Guard:

```c++
#program once
```

is equivalent to:

```c++
#ifndef _XXX_H
#define _XXX_H
...
#endif
```

Make sure it just into a single translation unit.

GCC, Clang 和 MSVC 这些主流的编译器都支持 `#program once` 这个语法

```c++
#include <HEADER_FILE>
#include "HEADER_FILE"
```

`<>` 只能用于搜索标准库所在路径的头文件，而 `""` 不仅可以搜索标准库所在路径，还可以搜索当前文件的相对路径的头文件，例如:

```c++
#include "../HEADER.h"
#include "../include/HEADER.h"
```

## Pointer and Reference

> ***这两大主题可以使用 VS 调试功能的查看内存窗口进行实践***
 
- cppreference: [nullptr](https://en.cppreference.com/w/cpp/language/nullptr)

指针可以置为空，空指针可以通过 `0`, `NULL` 或 C++11 引入的关键字 `nullptr` 来表示

- cppreference: [Pointers to void](https://en.cppreference.com/w/cpp/language/pointer#Pointers_to_void)
> Pointers to void have the same size, representation and alignment as pointers to char.

`void*` 一般只用于表示地址 (因为其内存对齐要求的单位为字节，并且内存寻址的单位也是字节)，一般不用于修改所指向地址处的数据 (因为它和 `int*` 这类指针不同，并没有表示偏移量的信息)，其它指针的类型记录了其偏移量信息，例如 `double*` 这个指针类型的偏移量信息为 8 个字节 (因为 `double` 占据的内存空间为连续的 8 个字节)

```c++
itn main()
{
    char* buffer = new char[8]; 
    memset(buffer, 0, 8);
    char** ptr = &buffer;
    delete[] buffer;
}
```

- cppreference: [new expression](https://en.cppreference.com/w/cpp/language/new)
- cppreference: [operator new, operator new[]](https://en.cppreference.com/w/cpp/memory/new/operator_new)
- cppreference: [delete expression](https://en.cppreference.com/w/cpp/language/delete)
- cppreference: [operator delete, operator delete[]](https://en.cppreference.com/w/cpp/memory/new/operator_delete)

C++ 的 Reference 和 Pointer 几乎是同样的东西，除了 Reference 在使用上等价于 Pointer 解引用后的使用。Reference 不能为空以及只能依赖于已存在 object (即必须先有 object 再有 Reference) 其实也是这一点的衍生，因为 Refernece 的使用等价于 Pointer 解引用后的使用，所以 Reference 必须指向已存在的 object，否则会造成 UB，同理 Reference 也不能为空

```c++
void increment(int& value)
{
    value++;
}

int main()
{
    int a = 5;
    int& ref = a;
    ref = 2;

    increment(a);
}
```

函数体内使用 Reference (例如上面程式码的 `main` 函数) 并不会分配内存空间给所谓的 Reference 变量，编译器将 Reference 视为所引用变量的别名 (alias)，修改时直接修改所引用的变量即可

但如果在函数参数中使用 Reference (例如上面程式码的 `increment` 函数)，那么编译器在底层实现时会和使用 Pointer 相同，即会分配内存空间为 Pointer (函数参数的 Reference 所暗示的)，然后在该函数内部使用该 Reference 的函数参数，效果和使用解引用的 Pointer 一致 *(在这个场景使用 Reference 效果和 Rust 的 Reference 类似)*

即上面程式码的 `increment` 函数和下面函数在编译器层面是一致的，都会被编译成相同的机器码:

```c++
void increment(int* value)
{
    (*value)++;
}
```

除此之外，Reference 与 Pointer 不同之处还在于，在初始化之后它不能改变所指向的 object

```c++
int main()
{
    int a = 5;
    int b = 8;

    int& ref = a; // ref point to a
    ref = b;      // set a's value to be b's value (8)!!!
}
```

## Object-Oriented Programming

### Class and Struct

C++ 的 Class 和 Struct 是相同的东西，只不过 Class 默认成员字段的外部可见性为 private，而 Struct 默认成员字段的外部可见性为 public，仅仅这个区别而已

```c++
class Player
{
public:
    int x, y;
    int speed;

    void Move(int xa, int ya)
    {
        x += xa * speed;
        y += ya * speed;
    }
};

int main() {
    Player player;
    player.x = 10;
    player.y = 10;
    player.speed = 2;
    player.Move(1, -1);
}
```

上面程式码的 `Player` 类与下面定义的结构体在底层是完全相同的:

```c++
struct Player
{
    int x, y;
    int speed;

    void Move(int xa, int ya)
    {
	    x += xa * speed;
	    y += ya * speed;
    }
};
```

{{< admonition >}}
从实践角度来看，在 C++ 中定义一个 *集合体*，它的成员字段默认都是 public 并且无需我们手动设定时，应当使用 `struct` 而不是 `class`，例如表示 TCP 数据报的 Header 应该使用 `struct`。也尽量不要在 `struct` 中使用继承，让 `struct` 作为一种相对纯粹的数据的组合
{{< /admonition >}}

#### 实作案例: Log System

实作一个日志系统 (Log System) 来加深对 C++ 的 Class 的理解

```c++
#include <iostream>

class Log
{
public:
    enum Level
    {
        Error = 0,
        Warning,
        Info,
    };
private:
    int m_LogLevel = Info;
public:
    void SetLogLevel(Level level)
    {
        m_LogLevel = level;
    }

    void error(const char* message)
    {
        if (m_LogLevel >= Error)
        {
            std::cout << "[ERROR]: " << message << std::endl;
        }
    }

    void warn(const char* message)
    {
        if (m_LogLevel >= Warning)
        {
            std::cout << "[WARNING]: " << message << std::endl;
        }
    }

    void info(const char* message)
    {
        if (m_LogLevel >= Info)
        {
            std::cout << "[INFO]: " << message << std::endl;
        }
    }
};

int main() {
    using std::cout;
    cout << "Hello world" << '\n';

    Log log;
    log.SetLogLevel(Log::Level::Info);
    log.warn("Hello");
    log.error("Hello");
    log.info("Hello");

    return 0;
}
```

### Enum

- cppreference: [Enumeration declaration](https://en.cppreference.com/w/cpp/language/enum)

```c++
enum Example : unsigned char
{
    A = 5, B, C
};

int main()
{
    Example value = B;
}
```

### Visibility

- cppreference: [Access specifiers](https://en.cppreference.com/w/cpp/language/access)

> In a member-specification of a class/struct or union, define the accessibility of subsequent members.
> 
> In a base-specifier of a derived class declaration, define the accessibility of inherited members of the subsequent base class.

A **public** member of a class is accessible anywhere

A **protected** member of a class is only accessible:
1) to the members and friends of that class;
2) to the members and friends of any derived class of that class, but only when the class of the object through which the protected member is accessed is that derived class or a derived class of that derived class

A **private** member of a class is only accessible to the members and friends of that class, regardless of whether the members are on the same or different instances

- Stack Overflow: [What is the difference between private and protected members of C++ classes?](https://stackoverflow.com/questions/224966/what-is-the-difference-between-private-and-protected-members-of-c-classes)

### Constructor and Destructor

```c++
class Entity
{
public:
    float X, Y;
    Entity()
    {
        X = 0; Y = 0;
    }
    Entity(float x, float y)
    {
        X = x; Y = y;
    }
};

int main()
{
    Entity e1;
    Entity e2(10.0f, 8.1f);
}
```

有时候可以借助 `private` 来隐藏 Class 或 Struct 的 Constructor，防止用户创建该 Class 或 Struct 的实例 (例如 Java 中的 Math 类，使用 C++ 实作的话就需要使用到这种技巧)，这是因为 C++ 会自动帮我们创建一个 `public` 的默认 Constructor。除此之外还可以使用 `delete` 关键字来删除默认的 Constructor

```c++
class Math
{
private:
    Math() {}
public:
    static float sqrt(float x)
    {
        ...
    }
};

// or

class Math
{
public:
    Math() = delete;
    static float sqrt(float x)
    {
        ...
    }
};
```

手动实现 Destructor 用于正确释放该 Class 或 Struct 实例拥有的内存空间，以防止内存泄漏。与 Rust 类似，Class 或 Struct 实例 (分配在 stack 的自动变量) 在超出作用域后，会自动调用 Destructor 函数 (但是对于分配在 heap 的动态变量，需要 `delete` 对应实例时才会自动调用 Destructor)。也可以对实例手动调用 Destructor 来实现提前释放的效果 (类似于 Rust 的 `drop` 机制)

```c++
struct Entity
{
    float X, Y;
    Entity()
    {
        X = 0; Y = 0;
        std::cout << "Call the Constructor!" << std::endl;
    }
    ~Entity()
    {
        std::cout << "Call the Destructor!" << std::endl;
    } 
};

void Func()
{
    Entity e;
    e.~Entity(); // like `drop(e)` in Rust
}

int main()
{
    Func();
}
```

#### Member Initializer Lists

- cppreference: [Constructors and member initializer lists](https://en.cppreference.com/w/cpp/language/constructor)

```c++
#include <string>
class Entity
{
private:
    std::string m_Name;
public:
    Entity() : m_Name("Unknown") { ... }
    Entity(const std::string& name) : m_Name(name) { ... }
};
```

{{< admonition >}}
使用 *初始化参数列表* 会节约性能，不会丢弃默认构造的对象，具体见视频的例子。原理也很简单，初始化参数列表是在执行函数体之前进行初始化的，不会事先创建对象。而如果在函数体内对对象进行赋值，因为不论是否在初始化参数列表中是否指定了成员变量，编译器都会在执行函数体之前先对每个成员变量进行构造 (当然初始化参数列表指定的就按列表构造)，导致在函数体内对成员变量赋值时，会丢掉先前构造好的对象，从而导致性能损失。(这很好理解，因为 Rust 要求构造对象时必须指定所有成员的值，C++ 的初始化列表的作用是类似的，给对象的每个成员都分配值，这样构造函数就无需指定每个成员的值了)

```c++
#include <iostream>
#include <string>

class Example
{
public:
    Example() { std::cout << "Created Entity!" << std::endl; }
    Example(int x) { std::cout << "Created Entity with " << x << "!" << std::endl; }
};

class Entity
{
private:
    std::string m_Name;
    Example m_Example;
public:
    // call this constructor should print 2 lines (call 2 times of constructor of Example)
    Entity(const std::string& name) : m_Name(name) {}
    // call this constructor should print only 1 line (call once of constructor of Example)
    Entity(const std::string& name) { m_Name(name); }
};
```
{{< /admonition >}}

#### Copy Constructor

- cppreference: [Copy constructors](https://en.cppreference.com/w/cpp/language/copy_constructor)

> A copy constructor is a constructor which can be called with an argument of the same class type and copies the content of the argument without mutating the argument.

```c++
```

### Inheritance and Polymorphism

- Stack Overflow: [What is the main difference between Inheritance and Polymorphism?](https://stackoverflow.com/questions/6308178/what-is-the-main-difference-between-inheritance-and-polymorphism)

> Inheritance is when a 'class' derives from an existing 'class'.
> 
> Polymorphism deals with how the program decides which methods it should use, depending on what type of thing it has.

- cppreference: [Derived classes](https://en.cppreference.com/w/cpp/language/derived_class)

> Any class type (whether declared with class-key class or struct) may be declared as derived from one or more base classes which, in turn, may be derived from their own base classes, forming an inheritance hierarchy.

C++ 中的继承 (Inheritance) 是 **数据** 和 **行为** 都会被继承 (而 Rust 中的 Trait 只会继承行为)

> When a class uses public member access specifier to derive from a base, all public members of the base class are accessible as public members of the derived class and all protected members of the base class are accessible as protected members of the derived class (private members of the base are never accessible unless friended).

```c++
class Entity
{
public:
    float X, Y;
    void Move(float xa, float ya)
    {
        X += xa;
        Y += ya;
    }
};

// Class Player is subclass of Class Entity
class Player : public Entity
{
public:
    const char* Name;
    void PrintName()
    {
        std::cout << Name << std::endl;
    }
};

int main() {
    std::cout << sizeof(Entity) << std::endl; // output 8 which equal 2 * sizeof(float)
    std::cout << sizeof(Player) << std::endl; // output 12 which equal 8 + sizeof(char*)
}
```

#### Virtual Function

- cppreference: [virtual function specifier](https://en.cppreference.com/w/cpp/language/virtual)

> Virtual functions are member functions whose behavior can be overridden in derived classes. As opposed to non-virtual functions, the overriding behavior is preserved even if there is no compile-time information about the actual type of the class.

虚函数 (Virtual Function) 用于多态时提醒编译器对调用的函数进行动态查找，以调用最符合实例类型的同名函数 (这个过程可能会有一些性能损耗，因为编译器需要查表来确定最终调用的函数)

```c++
class Entity
{
public:
    virtual std::string GetName() { return "Entity"; }
};

class Player
{
private:
    std::string Name;
public:
    std::string GetName() override /* 'override' is optional */ { return Name; }
};

int main()
{
    Entity* e = new Entity();
    std::cout << e->GetName() << std::endl;         // should output "Entity"

    Player* p = new Player("Player");
    std::cout << p->GetName() << std::endl;         // should output "Player"

    Entity* entity = p;
    std::cout << entity->GetName() << std::endl;    // should output "Player"
}
```

有时候我们不需要提供一个默认的实现，而只是提供一个行为给子类型 (subclass) 实现，这时候可以使用 `virtual` 修饰得到纯虚函数 (pure virtual function)，类似于 Java 中的接口 (interface)

下面实作一个类似于 Rust 的 Trait `Display` 的接口类 `Printable` :

```c++
class Printable
{
public:
    virtual std::string GetClassName() = 0; // pure virtual function
};

class Entity : public Printable
{
public:
    virtual std::string GetName() override { return "Entity"; }
};

class Player : public Entity
{
private:
    std::string Name;
public:
    std::string GetName() override { return Name; }
    std::string GetClassName() override { return "Player"; }
};
```

### Objects

将对象 Object 分配在栈 Stack 上的方式:

```c++
using String = std::string;

// call `Entity()` which is default constructor and allocated in stack
Entity entity; 
// equals
Entity entity = Entity();
// or just
Entity entity();

// call `Entity(const String& name)` and allocated in stack
Entity entity = Entity("Hello"); 
// or you can just
Entity entity("Hello");
```

将对象 Object 分配在堆 heap 上的方式:

```c++
using String = std::string;

// call `Entity()` which is default constructor and allocated in heap
Entity* entity = new Entity; 
// equals
Entity* entity = new Entity();

// call `Entity(const String& name)` and allocated in heap
Entity* entity = new Entity("Hello"); 
```

- cppreference: [new expression](https://en.cppreference.com/w/cpp/language/new)
- cppreference: [operator new, operator new[]](https://en.cppreference.com/w/cpp/memory/new/operator_new)
- cppreference: [delete expression](https://en.cppreference.com/w/cpp/language/delete)
- cppreference: [operator delete, operator delete[]](https://en.cppreference.com/w/cpp/memory/new/operator_delete)

#### this

- cppreference: [The this pointer](https://en.cppreference.com/w/cpp/language/this)

> The expression `this` is a prvalue expression whose value is the address of the implicit object parameter (object on which the non-static member function(until C++23)implicit object member function(since C++23) is being called).

`this` 本质上是 `Type* const` 的指针类型，使用引用 (Reference) 时需要注意这一点。另外，在 `const` 修饰的方法中，`this` 会进一步表示为 `const Type* const` 的指针类型

```c++
class Entity
{
public:
    int x, y;
    Entity(int x, int y)
    {
        Entity* const& e = this; // Pass
        Entity*& e = this;       // Error
        this->x = x;
        this->y = y;
    }

    int GetX() const
    {
        const Entity* const& e = this; // Pass
        Entity* const& e = this;       // Error
        return this->x;
    }
};
```


## Static, Const and Mutable

### Static

- cppreference: [C++ keyword: static](https://en.cppreference.com/w/cpp/keyword/static)

> **Usage**
> - declarations of namespace members with static storage duration and internal linkage
> - definitions of block scope variables with static storage duration and initialized once
> - declarations of class members not bound to specific instances

```c++
// Main.cpp
int s_Variable = 10;
void Func() {}

// Static.cpp
static int s_Varibale = 5;
static void Func() {}
```

这样不会因为存在两个同名变量、函数而导致编译失败，因为我们使用 `static` 限制了 Static.cpp 文件的同名变量和函数为内部链接 (注意这这些同名变量和函数均是独立的，即它们所在的内存地址均是不同的)

也可以使用外部链接关键字 `extern` 来通过编译:

- cppreference: [C++ keyword: extern](https://en.cppreference.com/w/cpp/keyword/extern)

> **Usage**
> - static storage duration with external linkage specifier
> - language linkage specification

```c++
// Main.cpp
extern int s_Variable;
void Func();

// Static.cpp
int s_Varibale = 5;
void Func() {}
```

这样也会编译通过，注意这个实作和之前的实作不同之处在于: Main.cpp 所指向的 `s_Variable` 正是 Static.cpp 文件的同名变量，即这两个东西是相同的，位于同一内存地址处。类似的，这两个文件的同名函数所在的内存地址也是相同的

{{< admonition >}}
尽量不要使用全局变量 (Global Variable) 除非你有必要的理由，一般情况下应当使用 `static` 修饰位于文件作用域的变量 (即变量所在的作用域和函数相同)，使其仅在当前的 Transilation Unit 进行内部链接
{{< /admonition >}}

在 Class 或 Struct 内使用 `static`，其作用是将被 `static` 修饰的变量或函数被该 Class 或 Struct 所共享，需要注意的是 `static` 修饰的函数不能使用与 Class 或 Struct 的具体实例相关的数据，例如可以使用 `static` 被修饰的变量

```c++
class Entry
{
    static int x, y;
    
    static Print()
    {
        std::cout << x << ", " << y << std::endl;
    }
};

int Entry::x;
int Entry::y;
```

### Const

- cppreference: [C++ keyword: const](https://en.cppreference.com/w/cpp/keyword/const)

C++ 中的 `const` 关键字只是一种弱承诺，可以通过解引用来绕开 (不过这也取决于编译器，有些编译器会把 `const` 修饰的数据设置为只读，这样即使可以绕开但会执行时造成程序崩溃):

```c++
int main()
{
    const int MAX_CONST = 100;
    int* a = (int*)&MAX_CONST;
    *a = 90;
}
```

`const` 修饰指针:

```c++
const int* a = new int; // can't modify `*a` (data be pointed to)
int* const a = new int; // can't modify `a`  (pointer itself)
const int* const a = new int; // can't modify both `*a` and `a`

// return a pointer which both pointer itself and data pointed are read-only
const int* const get_ptr() {}
```

在 Class 或 Struct 中使用 `const` 关键字，在方法名的右边添加 `const` 表示该方法不能修改 Class 或 Struct 的成员，只能读取数据，即调用中国方法不会改变 Class 或 Struct 的成员数据 (类似于 Rust 的 `&self` 参数的限制)

```c++
class Entity
{
private:
    int m_X, m_Y;
public:
    int GetX() const // Rust: fn get_x(&self) -> i32 {
    {
        return m_X;
    }

    void SetX(int x) // Rust: fn set_x(&mut self, x: i32) {
    {
        m_X = x;
    }
};
```

函数参数的 `const` 修饰的引用，其作用和使用两个 `const` 修饰的指针相同。原理很简单，引用被限制了不能改变所引用的对象，等价于 `type* const` 的指针类型，所以只需再限制不能修改所引用的对象即可:

```c++
void func(const Entity& e) {}
// equals
void func(const Entity* const e) {}
```

这种参数需要配合之前所提的 `const` 修饰的方法来使用，类似于 Rust 的 `&self` 参数的方法的使用限制

```c++
int main()
{
    const Entity e;
    e.GetX();
}
```

### Mutable

- cppreference: [C++ keyword: mutable](https://en.cppreference.com/w/cpp/keyword/mutable)

在 Class 或 Struct 的 `const` 修饰的方法中使用，使得该方法能修改被 `mutable` 的成员变量

- [cv (`const` and `volatile`) type qualifiers](https://en.cppreference.com/w/cpp/language/cv)
> mutable - permits modification of the class member declared mutable even if the containing object is declared const (i.e., the class member is mutable).

```c++
class Entity
{
private:
    int m_X, m_Y;
    mutable int count = 0;
public:
    int GetX() const
    {
        count++;
        return m_X;
    }
};`
```

也可以在 lambda 表达式中使用 `mutable` 进行修饰，但一般比较少 (因为实践中不太可能出现)

- cppreference: [Lambda expressions (since C++11)](https://en.cppreference.com/w/cpp/language/lambda)

> Allows body to modify the objects captured by copy, and to call their non-const member functions.
> Cannot be used if an explicit object parameter is present.(since C++23)

```c++
auto f = [=]() mutable
{
    x++;
    ...
}
// equals
auto f = [=]()
{
    int y = x;
    y++;
    ...
}
```

## Collections

### Array

- cppreference: [Array declaration](https://en.cppreference.com/w/cpp/language/array)

```c++
int main()
{
    // Array and Pointer are mostly same thing
    int example[5];
    int* ptr = example;
    for (int i = 0; i < 5; i++)
    {
        example[i] = 2;
    }                               // [2, 2, 2, 2, 2]
    example[2] = 5;                 // [2, 2, 5, 2, 2]
    *(int*)((char*)ptr + 8) = 6;    // [2, 2, 6, 2, 2]
}
```

```c++
int main()
{
    // Allocate array in stack
    int example[5];
    for (int i = 0; i < 5; i++)
        example[i] = 2;

    // Allocate array in heap
    int* another = new int[5];
    for (int i = 0; i < 5; i++)
        another[i] = 3;
    delete[] another;
}
```

- cppreference: [std::array](https://en.cppreference.com/w/cpp/container/array)

> std::array is a container that encapsulates fixed size arrays.

### String

- cppreference: [std::basic_string](https://en.cppreference.com/w/cpp/string/basic_string)
- [ASCII Table](https://www.ascii-code.com/)
- cppreference: [std::basic_string<CharT,Traits,Allocator>::npos](https://en.cppreference.com/w/cpp/string/basic_string/npos)

```c++
int main()
{
    // C style
    const char* hello = "Hello";
    hello[2] = 'a'; // error! since it was allocated at text section

    char word[6] = { 'w', 'o', 'r', 'l', 'd', '\0' /* or 0 */ };
    // or
    char word[6] = "world";
    world[2] = 'a'; // pass! since it was allocated at stack
}
```

```c++
#include <string>

int main()
{
    // C++ style
    std::string hello = "Hello";
    hello[2] = 'a';
    hello += ", world";

    // or
    std::string hello = std::string("Hello") + ", world";
    bool contains = hello.find("lo") != std::string::nops;
}
```

{{< admonition >}}
经验法则: 如果你没使用 `new` 关键字来获取对象，那么就不要使用 `delete` 关键字来删除它

VS 在调试模式下进行编译，会对内存分配的对象额外分配 **内存守卫者**，以方便提醒开发者内存访问是否越界

`std::string` 在函数参数中使用时，需要特别考虑是否应该使用引用 `&` 操作，以避免无效的拷贝开销
{{< /admonition >}}

#### 字符类型

- cppreference: [Fundamental types](https://en.cppreference.com/w/cpp/language/types)
- cppreference: [C++ keyword: wchar_t](https://en.cppreference.com/w/cpp/keyword/wchar_t)
- cppreference: [C++ keyword: char16_t (since C++11)](https://en.cppreference.com/w/cpp/keyword/char16_t) / [char16_t](https://en.cppreference.com/w/c/string/multibyte/char16_t)
- cppreference: [C++ keyword: char32_t (since C++11)](https://en.cppreference.com/w/cpp/keyword/char32_t) / [char32_t](https://en.cppreference.com/w/c/string/multibyte/char32_t)

```c++
int main()
{
    const char* hello = u8"Hello"; // 'u8' represent char, it's optional
    const wchar_t* hello = L"Hello"; // 'L' represent wide char
    const char16_t* hello = u"Hello"; // 'u' represent char16_t
    const char32_t* hello = U"Hello"; // 'U' represent char32_t
}
```

{{< admonition >}}
`char` 类型的具体字节数是由操作系统额 CPU 架构来决定的，如果需要跨系统使用固定字节数的字符类型，请按需使用 `wchar_t`, `char16_t` 和 `char32_t` 
{{< /admonition >}}

#### String Literals

- cppreference: [String literal](https://en.cppreference.com/w/cpp/language/string_literal)

> Raw string literals are string literals with a prefix containing `R` (syntaxes (2,4,6,8,10)). They do not escape any character, which means anything between the delimiters `d-char-seq (` and `)d-char-seq` becomes part of the string. The terminating `d-char-seq` is the same sequence of characters as the initial `d-char-seq`.

- cppreference: [std::literals::string_literals::operator""s](https://en.cppreference.com/w/cpp/string/basic_string/operator%22%22s)

```c++
#include <string>
int main()
{
    std::string hello = "Hello"s + ", world";
    const char* raw = "hello\nAp\tple";
}
```

## Operators

### Ternary Operators

C++ 中的 `?` 和 `:` 搭配的三元运算符存在的本质原因是，C++ 中的 if-else 控制流是语句 (statement) 而不是表达式 (expression)，所以需要功能类似于 if-else 的三元运算表达式来增强语言的表达能力 (否则表达会十分冗余，还会有额外开销，因为没有返回值优化，会产生中间临时数据)，如果是 Rust 这样的表达式为主的语言，就不需要这种三元运算符了

```c++
int level/* = somthing */;
// ternary operator
std::string speed = level > 5 ? 10 : 5;
// if-else
std::string speed;
if (level > 5)
    speed = 10;
else
    speed = 5;
```

```rs
let level: i32/* = somthing*/;
let speed: i32 = if level > 5 {
    10
} else {
    5
};
```

### Overloading

- cppreference: [operator overloading](https://en.cppreference.com/w/cpp/language/operators)

```c++
struct Vector2
{
    float x, y;

    Vector2(float x, float y)
        : x(x), y(y) {}

    Vector2 Add(const Vector2& other) const
    {
        return Vector2(x + other.x, y + other.y);
    }

    Vector2 operator+(const Vector2& other) const
    {   // overload `+` of `Vector2 + Vector2`
        return Add(other);
    }

    Vector2 Multiply(const Vector2& other) const
    {
        return Vector2(x * other.x, y * other.y);
    }

    Vector2 operator*(const Vector2& other) const
    {   // overload `*` of `Vector2 * Vector2`
        return Multiply(other);
    }

    bool operator==(const Vector2& other) const
    {
        return x == other.x && y == other.y;
    }

    bool operator!=(const Vector2& other) const
    {
        return !(*this == other);
    }
};

int main()
{
    Vector2 position(4.0f, 4.0f);
    Vector2 speed(0.5f, 1.5f);
    Vector2 powerup(1.1f, 1.1f);

    Vector2 result1 = position.Add(speed.Multiply(powerup));
    Vector2 result2 = position + speed * powerup;

    if (result1 == result2) {}
}
```

运算符重载 (Operators Overloading) 不一定应用于类的方法，也可以用于函数 (其实运算符重载的语义为，重载表达式 `函数第一个参数 运算符 函数第二个参数` 的语义，而在方法中 `this` 作为第一个参数存在)

```c++
std::ostream& operator<<(std::ostream& stream, const Vector2& other)
{
    stream << other.x << ", " << other.y;
    return stream;
}
```

运算符 `<<` 的重载语义会返回 `std::ostream` 对象，这样可以保证 `<<` 运算符的链式调用

{{< admonition >}}
运算符重载 (Operators Overloading) 只能重载运算符的执行语义，但运算符的优先级是不变的。这很因为运算符的优先级是编译器在进行语法分析时进行处理的，显然不能进行重载 (除非你重写了编译器 :rofl:)
{{< /admonition >}}

## Conversions

### Implicit and Explicit

隐式转换一般不建议用，因为表达不够清晰，会造成误解，特别是用在构造函数 Constructor 上，例如下面是完全合法的 C++ 代码:

```c++
#include <iostream>
class Entity
{
public:
    Entity(int age) {}
    Entity(std::string name) {}
};

int main()
{
    Entity entity = "hello"; // Pass! call `Entity(int age)`
    Entity entity = 22;      // Pass! call `Entity(std::string name)`
}
```

可以使用 `explicit` 关键字来禁止构造函数的这种隐式转换规则:

- cppreference: [explicit specifier](https://en.cppreference.com/w/cpp/language/explicit)

> Specifies that a constructor or conversion function(since C++11)or deduction guide(since C++17) is explicit, that is, it cannot be used for implicit conversions and copy-initialization.

```c++
#include <iostream>
class Entity
{
public:
    explicit Entity(int age) {}
    explicit Entity(std::string name) {}
};

int main()
{
    Entity entity = "hello"; // Error! Now it is not allowed
    Entity entity = 22;      // Error! Now it is not allowed
}
```

## Memory Model

### Lifetime

主要是理解 **栈 (Stack)** 和 **堆 (Heap)** 上分配的对象 (Object) 的生命周期 (Lifetime) 的机制，栈 (Stack) 上分配的对象 (Object) 的生命周期无需我们关系，超出作用域会自动销毁，这就是为什么它们被称为 **自动变量** 的原因，而堆 (Heap) 上的生命周期则需要我们手动进行管理，以决定什么时候销毁它们结束它们的生命周期，当然我们也可以使用其它程序员封装好的容器，这样手动管理这些对象的生命周期的责任就交给封装这个容器的程序员的 (但还是需要人手动管理 :rofl:)。简单来说，栈上的变量不需要人来关心 (编译器会帮我们完成)，而堆上的对象则需要人来管理 (不论是直接的还是间接的)。

{{< admonition >}}
Rust 的生命周期机制本质上就是让堆 (Heap) 分配的对象 (Object) 的生命周期也由编译器来管理，超出作用域就会销毁，无需人们操心手动管理，从某种意义上说，编写 Rust 代码时无需关心对象分配在栈上或堆上，只需知道分配在内存即可。
{{< /admonition >}}

这个机制可以通过 Construtor 和 Destructor 的调用，以及搭配调试器来观察:

```c++
#include <iostream>
class Entity
{
public:
    Entity() { std::cout << "Created Entity!" << std::endl; }
    Entity() { std::cout << "Destroyed Entity!" << std::endl; }
};

int main()
{
    {
        Entity e;
    }
    {
        Entity* e = new Entity();
    }
    delete e;
}
```

我们可以利用自动变量和作用域的特性来设计类似 Rust 的生命周期机制 (实现了一个类似于 C++ 的 `unique_ptr` 的智能指针):

```c++
class ScopedPtr
{
private:
    Entity* m_Ptr;
public:
    ScopedPtr(Entity* ptr) : m_ptr(ptr) {}
    ~ScopedPtr() { delete m_Ptr; }
};

int main()
{
    {
        ScopedPtr e(new Entity);
        // or by implicit conversion
        ScopedPtr e = new Entity();
    }
}
```

{{< admonition tip >}}
这种自动变量和作用域特性在很多地方都可以用到，例如计时器，配合 Constructor 和 Destructor 可以实现对特定时间段 (该计时器存活的生命周期) 进行自动计时，实现逻辑为：调用构造函数时启动计时，调用析构函数时结束计时并记录或打印。

也可以用于互斥锁 (Mutex Lock)，在特定函数的起始处自动创建锁守卫 (Lock Guard)，在该函数的结束后自动销毁该锁守卫，这使得多线程执行时会有序执行该函数。
{{< /admonition >}}

### Smart Pointers

- cppreference: [std::unique_ptr](https://en.cppreference.com/w/cpp/memory/unique_ptr)

> `std::unique_ptr` is a smart pointer that owns and manages another object through a pointer and disposes of that object when the `unique_ptr` goes out of scope.

`unique_ptr` 不能被复制，因为这样违反了它的所有权 (ownership) 机制，它只能被移动 (move) 即转移所有权

```c++
#include <memory>
int main()
{
    std::unqiue_ptr<Entity> e(new Entity);
    // last may cause exception, thus recommend follow
    std::unique_ptr<Entity> e = std::make_unique<Entity>(); // call Entity()
    e->Print(); // unique_ptr has overloaded `->` operator
}
```

- cppreference: [std::shared_ptr](https://en.cppreference.com/w/cpp/memory/shared_ptr)

> `std::shared_ptr` is a smart pointer that retains shared ownership of an object through a pointer. Several `shared_ptr` objects may own the same object. The object is destroyed and its memory deallocated when either of the following happens:
> 
> - the last remaining `shared_ptr` owning the object is destroyed;
> - the last remaining `shared_ptr` owning the object is assigned another pointer via `operator=` or `reset()`.

底层机制是通过 **循环计数** ([Reference counting](https://en.wikipedia.org/wiki/Reference_counting)) 来实现的

类似的实作案例: Rust [std::rc::Rc](https://doc.rust-lang.org/std/rc/struct.Rc.html)

```c++
#include <memory>
int main()
{
    std::shared_ptr<Entity> e;
    {
        std::shared_ptr<Entity> sharedEntity = std::make_shared<Entity>(); // call Entity()
        e = sharedEntity;
    }
}
```

- cppreference: [std::weak_ptr](https://en.cppreference.com/w/cpp/memory/weak_ptr)

> `std::weak_ptr` is a smart pointer that holds a non-owning ("weak") reference to an object that is managed by `std::shared_ptr`. It must be converted to `std::shared_ptr` in order to access the referenced object.

`weak_ptr` 对所指向的对象没有所有权，它是用于解决 **循环引用** 问题 (例如树状结构的亲代关系会导致循环引用)。

类似的实作案例: Rust [std::rc::Weak](https://doc.rust-lang.org/std/rc/struct.Weak.html)

```c++
#include <memory>
int main()
{
    std::weak_ptr<Entity> e;
    {
        std::shared_ptr<Entity> sharedEntity = std::make_shared<Entity>(); // call Entity()
        e = sharedEntity;
    }
}
```

{{< admonition tip >}}
推荐使用 `std::make_XYZ` 这个标准库函数，这也你就可以在你的代码里永远摆脱 `new` 关键字了 :rofl: 
{{< /admonition >}}

## References

- The Cherno: [C++](https://www.youtube.com/playlist?list=PLlrATfBNZ98dudnM48yfGUldqGD0S4FFb) / [中文翻译](https://space.bilibili.com/364152971/channel/collectiondetail?sid=13909): 主要介绍 C++11 及以上版本的语法
- 我是龙套小果丁: [现代 C++ 基础](https://space.bilibili.com/18874763/channel/collectiondetail?sid=2192185)
- [C++ Weekly With Jason Turner](https://www.youtube.com/@cppweekly)
- [C++ 矿坑系列](https://github.com/Mes0903/Cpp-Miner)
- 南方科技大学: [快速学习 C 和 C++，基础语法和优化策略](https://www.bilibili.com/video/BV1Vf4y1P7pq/)
- 原子之音: [C++ 现代实用教程](https://space.bilibili.com/437860379/channel/seriesdetail?sid=2352475)
/ [C++ 智能指针](https://www.bilibili.com/video/BV18B4y187uL)
/ [CMake 简明教程](https://www.bilibili.com/video/BV1xa4y1R7vT)
- [learncpp.com](https://www.learncpp.com/)
