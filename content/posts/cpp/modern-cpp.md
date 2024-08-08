---
title: "Modern C++ (MSVC)"
subtitle:
date: 2024-06-30T00:19:25+08:00
slug: f341f9f
# draft: true
author:
  name: vanJker
  link: https://github.com/vanJker
  email: cjshine@foxmail.com
  avatar: https://avatars.githubusercontent.com/u/88960102?s=96&v=4
description:
keywords:
license:
comment: false
weight: 0
tags:
  - C++
  - MSVC
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

"Modern" [C++](https://en.wikipedia.org/wiki/C%2B%2B) isn't afraid to use any or all of the following:

- RAII
- standard library containers and algorithms
- templates
- metaprogramming
- exceptions
- Boost

"Old" [C++](https://en.wikipedia.org/wiki/C%2B%2B) tends to avoid these things due to a perceived lack of compiler support or run-time performance. Instead, you'll find...

- lots of `new` and `delete`
- roll-your-own linked lists and other data structures
- return codes as a mechanism for error handling
- one of the millions of custom string classes that aren't `std::string`

As with all this-vs-that arguments, there are merits to both approaches. Modern C++ isn't universally better. Embedded enviornments, for example, often require extra restrictions that most people never need, so you'll see a lot of old-style code there. Overall though, I think you'll find that most of the modern features are worth using regularly. Moore's Law and compiler improvements have taken care of the majority of reasons to avoid the new stuff.

<!--more-->

> 以上整理自 Stack Overflow: [What is modern C++?](https://stackoverflow.com/questions/3661237/what-is-modern-c)

{{< admonition success >}}
写出好的 C++ 代码，而不是炫耀你所会的 C++ 的特性。不要为了炫技而炫技！
{{< /admonition >}}

## Toolchain

Wikipedia: [Toolchain](https://en.wikipedia.org/wiki/Toolchain)

- [Compiler Exploer](https://godbolt.org/)
- OS: Windows 10
- IDE: [Visual Studio](https://visualstudio.microsoft.com/) 2019 Community edition
    - [MSVC](https://en.wikipedia.org/wiki/Microsoft_Visual_C%2B%2B)
    - Clang Power Tools
    - [cppcheck-vs-addin](https://github.com/VioletGiraffe/cppcheck-vs-addin) vsix
    - ClangFormat
- [LLVM](https://releases.llvm.org/download.html) 17.0.1 Win64
- [Cppcheck](https://cppcheck.sourceforge.io/) 2.13 Win64
- [HxD](https://mh-nexus.de/en/hxd/) Editor

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

#### Conditional Compilation

- Wikipedia: [Conditional compilation](https://en.wikipedia.org/wiki/Conditional_compilation)

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

调试时相关信息的窗口在「调试 $\rightarrow$ 窗口」处可以开启显示

在内存查看窗口，可以通过 `&var` (`var` 为当前上下文变量的名字) 来快速获取该变量对应的地址，以及查看该地址所所储存的值

调试过程中，通过「右键 $\rightarrow$ 转到反汇编」即可查看对应的汇编代码

#### Contional and Action Breakpoints

Microsoft Learn: [Use breakpoints in the Visual Studio debugger](https://learn.microsoft.com/en-us/visualstudio/debugger/using-breakpoints?view=vs-2022)

- **Breakpoint conditions**

> You can control when and where a breakpoint executes by setting conditions. The condition can be any valid expression that the debugger recognizes.

- **Breakpoint actions and tracepoints**

> A tracepoint is a breakpoint that prints a message to the Output window. A tracepoint can act like a temporary trace statement in the programming language and does not pause the execution of code. You create a tracepoint by setting a special action in the Breakpoint Settings window.


### Projects

filter 类似于一种虚拟的文件系统组织，不过只能在 VS 才能表示为层次形式 (通过解析 XML 格式的配置文件)，在主机的文件系统上没有影响

解决方案栏的「显示所有文件」可以展示当前 Project 在主机文件系统下的组织层次结构，也可以在这个视图下创建目录 / 文件，这样也会在主机文件系统创建对应的目录 / 文件

主机文件系统和 VS 的虚拟项目组织是解耦的，所以在主机移动源文件并不会影响其在 VS 的虚拟项目组织所在的位置

VS 默认设置是将构建 / 编译得到的中间文件放在 Project 的 Debug 目录，但是得到的可执行文件却放在 Solution 的 Debug 目录下，这十分奇怪。可以通过修改 **Project 的属性** (右键选择属性这一选项) 里的输出目录，使得其与中间目录一致为 `$(Configuration)\`。也可以将 Solution 内的全部 Projects 的可执行文件均放置在 Solution 下的同一目录

推荐设定如下:
- Output Directory: `$(SolutionDir)\bin\$(Platform)\$(Configuration)\`
- Intermediate Directory: `$(SolutionDir)\bin\intermidiate\$(Platform)\$(Configuration)\`

{{< admonition >}}
在编辑这些目录设定时，其下拉框中选择「编辑 -> 宏」可以查看形如 `$(SolutionDir)` 这些宏的定义

设定 Solution 或 Project 的属性时，需要注意选择合适的 Configuration (配置) 和 Platform (平台) 进行应用
{{< /admonition >}}

```
SolutionDir
    |__ bin
          |__ Platform
          |         |__ Configuration
          |__ intermidiate
                    |__ Platform
                            |__ Configuration
```

#### Managing Multiple Projects and Libraries

同一 Solution 创建多个 Project:

- Solution 资源管理器 -> 右击 Solution 名称 -> Add (**New Project**)

一般来说，一个 Solution 只有一个生成可运行文件的 Project，其它 Project 应该作为静态链接存在 (当然测试作用的 Project 也应该是可执行文件类型)。设定 Project 类型:

右击 Project 名称 -> Properties -> Configuration Properties -> General -> Configuration Type 

- 可执行 Project: **Application (.exe)**
- 其余的 Project: **Static library (.lib)**

这样即可将整个 Solution 构建成一个可执行文件，但是这样引用其它 Project 的头文件比较麻烦，我们还是需要使用真实文件系统的路径进行引用，为了避免繁杂的头文件路径以及防止路径变更导致构建失败，我们使用和上一节类似的技术：设定 Project 的属性: C/C++ -> Additional Include Directoris，在里面添加我们想要引用的 Project 头文件所在的目录路径 (一般为 `$(SolutionDir)\ProjectName\src`)。

{{< admonition >}}
这个设定 Include 目录的过程实际上也设置了 Projects 之间的依赖关系 (某种意义上的 CMake，VS 是使用 sln 来管理包和代码库的)
{{< /admonition >}}

### Libraries

- Unix 哲学: 自己编译代码进行构建 (例如 [LFS](https://www.linuxfromscratch.org/lfs/))
- Windows 哲学: 能用就行，最好双击就可运行 :rofl:

接下来以 [GLFW](https://www.glfw.org/) 这个库为例来说明 C++ 项目中如何使用 **静态链接** ([static linking](https://en.wikipedia.org/wiki/Static_library)) 和 **动态链接库** ([dynamic libraries](https://en.wikipedia.org/wiki/Dynamic-link_library))，以及这两者的区别。

- Stack Overflow: [Static linking vs dynamic linking](https://stackoverflow.com/questions/1993390/static-linking-vs-dynamic-linking)

在 GLFW 的 [Download](https://www.glfw.org/download.html) 页面有源代码、预构建好的二进制，注意这个预构建好的二进制分为 32-bit 和 64-bit，但是这个与我们使用的操作系统和 CPU 架构无关，选择它们取决于想构建 32-bit 还是 64-bit 的 **应用程序** (CSAPP: 64-bit 结构的计算机可以运行 32-bit 或 64-bit 的应用程序，这是处出于兼容性的需要。一般来说，构建 32-bit 的 Win 程序比较普遍)。在这个页面我们可以看到 Linux / BSD 并没有提供二进制，符合我们之前所提的 Unix 哲学 XD (事实上，使用 Unix 类的操作系统并不需要都自己手动构建，可以使用包管理器进行下载别人打好包的二进制，例如 Ubuntu / Debian 的 `apt`、openSUSE 的 `zypper`、Arch Linux 的 `pacman`)

库 (Library) 的组织结构为: include 目录 (包含头文件) 和 lib 目录 (包含源文件对应的二进制，分为静态库 (后缀为 `.lib`) 和动态库 (后缀为 `.dll`)，但不是每个库都会提供这两种类型 (这可能是因为受限于开源协议))。通过 include 目录下的头文件和链接器 (Linker)，我们可以使用 lib 目录对应源代码所提供的函数 (`include` 目录与项目采用何种链接方式无关，因为头文件仅仅与编译相关)。

```
SolutionDir
    |__ Dependencies
            |__ GLFW
                  |__ include
                  |__ lib
```

管理依赖项设置:

1. Solution 目录下创建一个 Dependencies 目录 (与 Projects 的目录评级)，用于存放所依赖的库
2. 设定 **Project 的属性**: C/C++ -> Additional Include Directoris 为上一步存放依赖库的路径
   - `$(SolutionDir)\Dependencies\GLFW\include`
   - 指定完成后编译器就知道如何去寻找相关的头文件了，不会导致编译错误
   - 但是链接器还没有设定，会导致链接错误
3. 设定 Linker -> Additional Library Directories 为依赖库文件所处路径
   - `$(SolutionDir)\Dependencies\GLFW\lib-vc2019`
   - 该路径可包含静态库和动态库

#### Static Linking

在 Linker -> input -> Addtional Dependencies 处添加相对于之前依赖库目录的静态库文件路径: `glfw3.lib` (注意这里的依赖项不能包含相应的动态库相关文件)

```c++
#include <iostream>
#include "GLFW\glfw3.h"

int main()
{
    int a = glfwInit();
    std::cout << a << std::endl; // ouput 1
}
```

#### Dynamic Linking

{{< admonition quote >}}
C++ 在使用动态库的时候，一般提供两个文件：一个引入库 (后缀为 `dll.lib`，本质为静态链接文件) 和一个 DLL (后缀为 `.dll`，为动态链接文件)。引入库包含被 DLL 导出的函数和变量的符号名以及相应的寻址位置，而 DLL 包含实际的函数和数据。在编译链接可执行文件时，只需要链接引入库，DLL 中的函数代码和数据并不复制到可执行文件中，在运行的时候，再去加载 DLL 以访问 DLL 中导出的函数。不需要引入库也可以使用 DLL，但是效率会低，因为 **运行时** 每次访问 DLL 的资源都需要进行遍历 DLL 查询资源的具体位置 (类似于顺序遍历) 再进行链接，而如果有引入库，因为引入库记录了 DLL 所有公开资源的具体位置，可以直接在 **链接时** 在引入库查询 (类似于哈希表查找) 然后运行时直接对具体位置进行链接即可。
{{< /admonition >}}

- 以上整理自 [@神经元猫](https://space.bilibili.com/364152971) 的评论

在 Linker -> input -> Addtional Dependencies 处添加相对于之前依赖库目录的动态链接引入库文件路径: `glfw3dll.lib` (注意这里的依赖项不能包含相应的静态库相关文件)

将 `glfw3.dll` 这个动态库文件 (后缀为 `.dll`) 放置在可执行文件目录下 (Ouput Directory)，让该 DLL 可以被可执行文件 (后缀为 `.exe`) 在执行时搜索到

```c++
#include <iostream>
#include "GLFW\glfw3.h"

int main()
{
    int a = glfwInit();
    std::cout << a << std::endl; // ouput 1
}
```

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

### Precompiled Headers

预编译头文件会使得 C++ 头文件 (特别是 STL) 达到类似模块的效果，即头文件本身也是一个编译单元，这样就不会因为我们自己编写的源文件修改了，而一遍一遍的解析其所引用的头文件然后进行全部编译，这样会提升我们项目的编译速度。如果你关心编译时间，那一定要使用预编译头文件。

但是不要往预编译头文件中添加那些会被经常修改的东西，这样会导致该头文件会被重新编译，同样会延长编译时间。推荐将不常修改的东西放入至预编译头文件当中，并且是被很多源文件所需要的外部依赖，例如 STL。对于被源文件需要较少的外部依赖，例如 ImGui 需要的外部依赖 GLFW。推荐使用 Linker 设定而不是 PCH。

下面这个头文件在预处理后足足有 40 万行，如果不使用预编译头文件，又被多个源文件引用了该头文件，那么编译时间会极其恐怖:

```c++ {title="pch.h"}
#pragma once

// Utilities
#include <iostream>
#include <algorithm>
#include <functional>
#include <optional>
#include <memory>
#include <thread>
#include <utility>

// Data structures
#include <vector>
#include <array>
#include <stack>
#include <queue>
#include <deque>
#include <string>
#include <set>
#include <map>
#include <unordered_set>
#include <unordered_map>

// Windows API
#include <Windows.h>
```

为了避免这种情况 (被大量源文件所引用的外部依赖)，可以使用预编译头文件来处理:

1. 创建一个仅引用上面头文件的源文件 `pch.cpp`:

```c++ {title="pch.cpp"}
#include "pch.h"
```
2. 右击该 **源文件** 并进入其属性设定: C/C++ $\rightarrow$ Precompiled Headers $\rightarrow$ Precompiled Header (**Create**)

3. 右击 **项目** 并进入其属性设定: C/C++ $\rightarrow$ Precompiled Headers $\rightarrow$ Precompiled Header (**Use**) $\rightarrow$ Precompiled Header File (**pch.h**)

{{< admonition tip >}}
Visual Studio 的 Tools $\rightarrow$ Options $\rightarrow$ Projects and Solutions $\rightarrow$ Project Settings $\rightarrow$ Build Timing (**Yes**) 可以开启显示构建计时功能。
{{< /admonition >}}

g++ 也可以使用预编译头文件功能:

```bash
# without precompiled header
$ time g++ -std=c++11 main.cpp

real    0m1.257s
user    0m0.000s
sys     0m0.000s

# build precompiled header
$ g++ -std=c++11 pch.h

# with precompiled header
$ time g++ -std=c++11 main.cpp

real    0m0.266s
user    0m0.000s
sys     0m0.030s
```

## Pointers and References

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

**实作案例**: 日志系统 Log System

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

#### Copy Constructors

- Stack Overflow: [What is the difference between a deep copy and a shallow copy?](https://stackoverflow.com/questions/184710/what-is-the-difference-between-a-deep-copy-and-a-shallow-copy)

> Shallow copies duplicate as little as possible. A shallow copy of a collection is a copy of the collection structure, not the elements. With a shallow copy, two collections now share the individual elements.

> Deep copies duplicate everything. A deep copy of a collection is two collections with all of the elements in the original collection duplicated.

- cppreference: [Copy constructors](https://en.cppreference.com/w/cpp/language/copy_constructor)

> A copy constructor is a constructor which can be called with an argument of the same class type and copies the content of the argument without mutating the argument.

C++ 编译器会提供一个默认的复制构造函数 (Copy Constructor)，如果你想禁止这种复制构造的行为，可以使用 `delete` 关键字:

```c++
Class Type
{
    Type(const Type& other) = delete;
};
```

C++ 的智能指针 `unique_ptr` 也是通过这种方式来实作禁止复制行为的:

- Standard library header <[memory](https://en.cppreference.com/w/cpp/header/memory)>

```c++
class unique_ptr { // non-copyable pointer to an object
public:
    ...
    unique_ptr(const unique_ptr&) = delete;
    ...
};
```

下面是一个自定义 String 类的实作案例，用于加深对 Copy 行为和 Copy Construtor 的理解:

```c++
#include <iostream>
#include <string>

class String
{
private:
    char* m_Buffer;
    unsigned int m_Size;
public:
    String(const char* string)
    {
        m_Size = strlen(string);
        m_Buffer = new char[m_Size + 1];
        memcpy(m_Buffer, string, m_Size);
        m_Buffer[m_Size] = 0 /* or '\0` */;
    }

    String(const String& other)
        : m_Size(other.m_Size)
    {
        m_Buffer = new char[m_Size + 1];
        memcpy(m_Buffer, other.m_Buffer, m_Size + 1);
    }

    ~String()
    {
        delete[] m_Buffer;
    }

    char& operator[](unsigned int index)
    {
        return m_Buffer[index];
    }

    friend std::ostream& operator<<(std::ostream& stream, const String& string);
};

std::ostream& operator<<(std::ostream& stream, const String& string)
{
    stream << string.m_Buffer;
    return stream;
}

int main() {
    String string = "Hello";
    String second = string;

    second[1] = 'a';

    std::cout << string << std::endl;
    std::cout << second << std::endl;
}
```

{{< admonition >}}
复制构造 (Copy Structor) 和引用 (Reference) 的联系也比较紧密，因为一般情况下进行函数调用，不使用引用的话，会进行复制操作 (可以通过观察复制构造函数的调用)，这会造成性能损耗。所以一般情况下建议使用常量引用 (`const Type&`) 以避免不必要的性能损耗 (当然这样你在函数内部也可以决定是否进行复制操作，并没有限制了不能使用复制)，但是某些场景下使用复制会更快，这时候就需要进行衡量了。
{{< /admonition >}}

#### Virtual Destructors

- cppreference: [Destructors](https://en.cppreference.com/w/cpp/language/destructor) - **Virtual destructors**

> Deleting an object through pointer to base invokes **undefined behavior** unless the destructor in the base class is virtual.

> A common guideline is that a destructor for a base class must be either **public and virtual** or protected and nonvirtual.

虚析构函数 (Virtual Destructors) 与普通的虚函数不太一样，它的意义不是覆写 (override) 虚构函数，而是加上一个析构函数 (一般是加上具体派生类型的析构函数)。如果不使用 `vittual` 进行修饰，会导致内存泄漏，因为基类的析构函数只释放了基类的拥有的数据成员，并没有释放派生类的拥有的数据成员。

```c++
#include <iostream>

class Base
{
public:
    Base() { std::cout << "Base Constructor\n"; }
    virtual ~Base() { std::cout << "Base Destructor\n"; }
};

class Derived : public Base
{
public:
    Derived() { m_Array = new int[5]; std::cout << "Derived Constructor\n"; }
    ~Derived() { delete[] m_Array; std::cout << "Derived Destructor\n"; }
private:
    int* m_Array;
};

int main()
{
    Base* base = new Base();
    // Base Constructor
    delete base;
    // Base Destructor

    std::cout << "--------------------\n";

    Derived* derived = new Derived();
    // Base Constructor
    // Derived Constructor
    delete derived;
    // Derived Destructor
    // Base Destructor

    std::cout << "--------------------\n";

    Base* poly = new Derived();
    // Base Constructor
    // Derived Constructor
    delete poly;
    // Derived Destructor
    // Base Destructor
}
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

## Specifiers

### Static

#### Static vs. Extern

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

#### Local Static

- cppreference: [static members](https://en.cppreference.com/w/cpp/language/static)

> Inside a class definition, the keyword static declares members that are not bound to class instances.

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

局部作用域使用 `static` 修饰变量，例如在函数内部或类内部声明 `static` 修饰的变量，这类变量被称为 Local Static。它的生命周期和程序运行时期相同，但它的作用范围被限制在声明所处的作用域内:

```c++
#include <iostream>

void Function()
{
    static int i = 0;
    i++;
    std::cout << i << std::endl;
}

int main()
{
    Function(); // should print 1
    Function(); // should print 2
    Function(); // should print 3
}
```

**实作案例**: 单例设计模式的单例类 `Singleton`

```c++
class Singleton
{
private:
    static Singleton* s_Instance;
public:
    static Singleton& Get() { return *s_Instance; }
    
    void Hello() {}
};
Singleton* Singleton::s_Instance = nullptr; // or `new Singleton`
// or
class Singleton
{
public:
    static Singleton& Get() 
    { 
        static Singleton instance;
        return instance;
    }
    
    void Hello() {}
};

int main()
{
    Singleton::Get().Hello();
}
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

在 Class 或 Struct 中使用 `const` 关键字，在方法名的右边添加 `const` 表示该方法不能修改 Class 或 Struct 的成员，只能读取数据，即调用这个方法不会改变 Class 或 Struct 的成员数据 (类似于 Rust 的 `&self` 参数的限制)

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

### Explicit

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

### Auto

- cppreference: [Placeholder type specifiers (since C++11)](https://en.cppreference.com/w/cpp/language/auto)

在函数 API 返回场景处使用，这样就不需要因为 API 改变而手动修改返回值的类型标注:

```c++
const char* GetName() { return "Hello"; }
// or
std::string GetName() { return "Hello"; }

int main()
{
    auto name = GetName();
}
```

但这是一把双刃剑，这也会导致虽然 API 改变了但仍然构建成功，但 API 改变可能破坏了代码导致项目运行时的奇怪行为 (冷笑话: Linux kernel 表示对这样的 C++ 代码进行 Code Review 实在是...)

比较适合 `auto` 使用的场景：使用迭代器循环遍历，迭代器的类型比较复杂，但我们并不关心迭代器的类型，只需要知道它是个迭代器即可:

```c++
std::vector<std::string> strings;

for (std::vector<std::string>::iterator it = strings.begin();
    it != strings.end(); it++)
{
    std::cout << *it << std::endl;
}
// more readable
for (auto it = strings.begin(); it != strings.end(); it++)
{
    std::cout << *it << std::endl;
}
```

类型名很长时也是 `auto` 的另一个比较好的应用场景:

```c++
#include <vector>
#include <string>
#include <unordered_map>

class DeviceManager
{
private:
    std::unordered_map<std::string, std::vector<Device*>> m_Devices;
public:
    const std::unordered_map<std::string, std::vector<Device*>>& GetDevices() const
    {
        return m_Devices;
    }
};

int mainn()
{
    DeviceManager dm;
    const auto& devices = dm.GetDevices();
    // -> const std::unordered_map<std::string, std::vector<Device*>>& devices = dm.GetDevices();
}
```

**注意 `auto` 并不会推导出引用 `&`，所以需要手动标注**，否则会导致复制行为产生一个新的局部变量。例如上面的例子如果没有标注 `&`，那么会等价于:

```c++
auto devices = dm.GetDevices();
// -> const std::unordered_map<std::string, std::vector<Device*>> devices = dm.GetDevices();
```

除了上面说明的两种应用场景之外，不建议在其它地方滥用 `auto`，这会导致代码可读写变差，还可能会导致不必要的复制行为造成性能开销。尽量不要让自己的代码变成不得不使用 `auto` 的复杂程度！

函数返回类型的 `auto` 推导:

```c++
auto GetName() -> const char* {}
auto main() -> int {}
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

### Arrow Operator

可以通过 `->` 运算符来计算某个 Class / Struct 对象的成员的偏移值:

```c++
#include <iostream>

struct Vector3
{
    float x, y, z;
};

int main()
{
    int offset = (int)&((Vector3*)nullptr)->y;
    std::cout << offset << std::endl; // should be 4
}
```

这种技巧在工程上也很常用，最为著名的即为 Linux 核心的 `container_of` 宏:

- Stack Overflow: [Understanding container_of macro in the Linux kernel](https://stackoverflow.com/questions/15832301/understanding-container-of-macro-in-the-linux-kernel)

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

Copy Constructor vs. `=` operator overloading:

- Stack Overflow: [The copy constructor and assignment operator](https://stackoverflow.com/questions/5368258/the-copy-constructor-and-assignment-operator)

```c++
Entity a, b;
Entity e = a;   // Copy Constructor
e = c;          // `=` operator overloading
```
{{< /admonition >}}

## Templates and Containers

### Templates

{{< admonition tip >}}
模板和宏类似，它允许你定义一个可以根据你的用途进行编译的蓝图。简单来说，所谓模拟，就是 **让编译器基于你给它的规则为你写代码**。
{{< /admonition >}}

- cppreference: [Templates](https://en.cppreference.com/w/cpp/language/templates)
- cppreference: [Template parameters and template arguments](https://en.cppreference.com/w/cpp/language/template_parameters)

```c++
#include <iostream>

template<typename T>
void Print(T value)
{
    std::cout << value << std::endl;
}

int main()
{
    Print(5); // or `Print<int>(5)`
    Print("Hello");
    Print(5.5f);
}
```

MSVC 不会对未使用的模板进行报错，但其他编译器可能会 (例如 clang)

Template non-type arguments 可在模板指定类型处指定常量作为编译规则:

```c++
#include <iostream>

template<int N>
class Array 
{
private:
    int m_Array[N];
public:
    int GetSize() const { return N; }
};

int main()
{
    Array<5> array;
    std::cout << array.GetSize() << std::endl; // should be 5
}
```

进一步将类型指定规则和常量指定规则结合起来，实作一个泛型的栈分配的 `Array` (类似于标准库的 `std::array`):

```c++
#include <iostream>

template<typename T, int N>
class Array 
{
private:
    T m_Array[N];
public:
    int GetSize() const { return N; }
};

int main()
{
    Array<int, 5> array;
    std::cout << array.GetSize() << std::endl; // should be 5
}
```

### Containers

#### Array

##### array

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

##### std::array

- cppreference: [std::array](https://en.cppreference.com/w/cpp/container/array)

> `std::array` is a container that encapsulates fixed size arrays.

> This container is an aggregate type with the same semantics as a struct holding a C-style array `T[N]` as its only non-static data member. Unlike a C-style array, it doesn't decay to `T*` automatically.

> The struct combines the performance and accessibility of a C-style array with the benefits of a standard container, such as knowing its own size, supporting assignment, random access iterators, etc.

`std::array` 和普通数组一样，都是分配在栈 (Stack) 上的，与 `std::vector` 这种底层数据存储分配在堆 (Heap) 上的数据结构不同，所以 `std::array` 的性能比 `std::vector` 表现要好，实际上在编译器最佳化的条件下，它的性能表现和普通数组一样好。另外，与普通数组相比，`std::array` 拥有边界检查，更加安全。在存储空间方面，`std::array` 占用的空间与普通数组并无区别，因为它实际上并不存储 `size` 这个变量 (因为这个是通过常量模板规则传递的，并不占据空间，而是直接生成了对应的代码)。

```c++
#include <array>

int main()
{
    // old style
    int data_old[5];
    data_old[0] = 1;

    // new style
    std::array<int, 5> data;
    data[0] = 1;
}
```

`std::array` 在作为函数参数时可知数组的长度 (因为 `std::array` 是一个类)，这一点比起普通数组是优势 (普通数组作为函数参数时会退化为指针，使用 `sizeof` 无法获得正确的数组长度):

```c++
template<std::size_t N>
void PrintArray(std::array<int, N>& data)
{
    for (int i = 0; i < data.size(); i++) {}
}
```

使用常量模板规则生成对应的 `PrintArray` 函数

- Stack Overflow: [Passing a std::array of unknown size to a function](https://stackoverflow.com/questions/17156282/passing-a-stdarray-of-unknown-size-to-a-function)
- Stack Overflow: [Difference between size_t and std::size_t](https://stackoverflow.com/questions/5813700/difference-between-size-t-and-stdsize-t)

{{< admonition question "为什么 `std::array` 不需要存储 `size` 变量？" false >}}
这是因为常量模板规则，在编译时期即可确定 `size()` 函数的具体实现了，无需额外存储变量:

```c++
std::array<int, 5> arr;
// this will generate
class array...
{
    ...
    size_t size() const
    {
        return 5;
    }
    ...
}
```

边界检查的具体代码实现也是类似的，是通过常量模板规则生成的
{{< /admonition >}}

##### Multidimensional Arrays

```c++
int main()
{
    // 1 Dimension
    int* array = new int[50];

    // 2 Dimension
    int** a2d = new int*[50];
    for (int i = 0; i < 50; i++)
        a2d[i] = new int[50];

    a2d[0][0] = 0; // a2d[0] -> int*, a2d[0][0] -> int
    a2d[0][1] = 1;
    a2d[0][2] = 2;

    for (int i = 0; i < 50; i++)
        delete[] a2d[i];
    delete[] a2d;

    // 3 Dimension, it's too complex!
    int*** a3d = new int**[50];
    for (int i = 0; i < 50; i++)
    {
        a3d[i] = new int*[50];
        for (int j = 0; j < 50; j++)
            a3d[i][j] = new int[50];
    }
}
```

- Stack Overflow: [C++ multidimensional array on heap](https://stackoverflow.com/questions/72018905/c-multidimensional-array-on-heap)

上面这种形式的多维数组会极大可能导致 cache miss，进而导致性能表现不如等价的一维数组。下面是二维数组和等价的一维数组在顺序读取时的性能表现对比:

```c++
int main()
{
    // slower
    int** a2d = new int*[5];
    for (int i = 0; i < 5; i++)
        a2d[i] = new int[5];

    for (int i = 0; i < 5; i++)
        for (int j = 0; j < 5; i++)
            a2d[i][j] = 2;
    
    // faster
    int* array = new int[5 * 5];
    for (int i = 0; i < 5; i++)
        for (int j = 0; j < 5; i++)
            a2d[i + 5*j] = 1;
}
```

尽量避免使用二维数组 (以及二维以上维度)，推荐将其转换为等价的一维数组，利用 cache 的特性增强性能。

#### String

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

##### Char Types

- cppreference: [Fundamental types](https://en.cppreference.com/w/cpp/language/types)
- cppreference: [C++ keyword: wchar_t](https://en.cppreference.com/w/cpp/keyword/wchar_t)
- cppreference: [C++ keyword: char16_t (since C++11)](https://en.cppreference.com/w/cpp/keyword/char16_t) / [char16_t](https://en.cppreference.com/w/c/string/multibyte/char16_t)
- cppreference: [C++ keyword: char32_t (since C++11)](https://en.cppreference.com/w/cpp/keyword/char32_t) / [char32_t](https://en.cppreference.com/w/c/string/multibyte/char32_t)

```c++
int main()
{
    const char* hello = u8"Hello";      // 'u8' represent utf-8, it's optional
    const wchar_t* hello = L"Hello";    // 'L' represent wide char
    const char16_t* hello = u"Hello";   // 'u' represent char16_t
    const char32_t* hello = U"Hello";   // 'U' represent char32_t
}
```

{{< admonition >}}
`char` 类型的具体字节数是由操作系统额 CPU 架构来决定的，如果需要跨系统使用固定字节数的字符类型，请按需使用 `wchar_t`, `char16_t` 和 `char32_t` 
{{< /admonition >}}

##### String Literals

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

#### Vector

- Stack Overflow: [Why is a C++ Vector called a Vector?](https://stackoverflow.com/questions/581426/why-is-a-c-vector-called-a-vector)

> It's called a vector because Alex Stepanov, the designer of the Standard Template Library, was looking for a name to distinguish it from built-in arrays. He admits now that he made a mistake, because mathematics already uses the term 'vector' for a fixed-length sequence of numbers. C++11 compounds this mistake by introducing a class 'array' that behaves similarly to a mathematical vector.

- cppreference: [std::vector](https://en.cppreference.com/w/cpp/container/vector)

```c++
#include <iostream>

struct Vertex
{
    float x, y, z;
};

std::ostream& operator<<(std::ostream& stream. const Vertx& vertex)
{
    stream << vertex.x << ", " << vertex.y << ", " << vertex.z << std::endl; 
    return stream;
}

void Function(const vector<Vertex>& vertices)
{

}

int main()
{
    std::vector<Vertex> vertices;
    vertices.push_back({ 1, 2, 3 });
    vertices.push_back({ 4, 5, 6 });

    for (int i = 0; i < vertices.size(); i++)
        std::cout << vertices[i] << std::endl;
    // or
    for (const Vertex& v : vertices)
        std::cout << v << std::endl;
    
    Function(vertices);

    vertices.erase(vertices.begin() + 1);
}
```

{{< admonition >}}
STL 的容器，它们在被设计时，速度不是优先考虑的因素，所以我们可以设计出比 STL 里的容器性能更强的类似容器，这也是为什么很多工作室会自己设计容器库而不采用 STL，例如 [Qt Container Classes](https://doc.qt.io/qt-6/containers.html)、[EASTL](https://github.com/electronicarts/EASTL)。
{{< /admonition >}}

##### Optimizing Usage

一般情况下，STL 的 `vector` 是比较慢的 (因为它倾向于经常分配内存空间，这会导致大量的性能开销)，所以我们需要通过一些策略来压榨出 `vector` 的全部性能。下面通过之前的例子来展示这些优化策略。

通过复制构造函数确认什么时候发生了大量的复制，以应用相应的复制优化策略:

```c++
struct Vertex
{
    ...
    Vertex(float x, float y, float z)
        : x(x), y(y), z(z) {}
    Vertex(const Vertex& other)
        : x(other.x), y(other.y), z(other.z)
    {
        std::cout << "Copied!" << std::endl;
    }
};
```

运行后发现之前的例子总共进行了 6 次复制

1. **优化复制**。预先分配内存，防止过多的内存分配和复制操作造成性能损耗。

```c++
    std::vector<Vertex> vertices;
    vertices.resize(3); // pre-allocation
    vertices.push_back(Vertex(1, 2, 3));
    vertices.push_back(Vertex(4, 5, 6));
    vertices.push_back(Vertex(7, 8, 9));
```

现在减少为 3 次复制了

注意 `reserve` 方法和 `vector` 构造函数中指定元素数量这两者是不太一样的:

- [std::vector<T,Allocator>::reserve](https://en.cppreference.com/w/cpp/container/vector/reserve)
> Increase the capacity of the vector (the total number of elements that the vector can hold without requiring reallocation) to a value that's greater or equal to `new_cap`.

- [std::vector<T,Allocator>::vector](https://en.cppreference.com/w/cpp/container/vector/vector)
> 4\) Constructs the container with `count` default-inserted instances of `T`. No copies are made.

即构造函数指定元素数量会构造相应的默认实例，而 `reserve` 不会，所以 `reserve` 的性能开销更低。

2. **避免复制**。直接在 `vector` 合适的位置构造对象，而不是先在栈上构造再复制到 `vector` 里。

- [std::vector<T,Allocator>::emplace_back](https://en.cppreference.com/w/cpp/container/vector/emplace_back)
> Appends a new element to the end of the container. ...  which typically uses placement-new to construct the element **in-place** at the location provided by the container. 

```c++
    std::vector<Vertex> vertices;
    vertices.resize(3); // pre-allocation
    vertices.emplace_back(Vertex(1, 2, 3));
    vertices.emplace_back(Vertex(4, 5, 6));
    vertices.emplace_back(Vertex(7, 8, 9));
```

现在没有复制操作了

### Algorithms

- cppreference: [Algorithms library](https://en.cppreference.com/w/cpp/algorithm)

> The algorithms library defines functions for a variety of purposes (e.g. searching, sorting, counting, manipulating) that operate on ranges of elements. Note that a range is defined as **[`first`, `last`)** where `last` refers to the element past the last element to inspect or modify.

#### Sorting

- cppreference: [std::sort](https://en.cppreference.com/w/cpp/algorithm/sort)

> Sorts the elements in the range **[`first`, `last`)** in non-descending order. The order of equal elements is not guaranteed to be preserved.

> **comp**	-	comparison function object (i.e. an object that satisfies the requirements of Compare) which returns `​true` if the first argument is less than (i.e. is ordered before) the second.

```c++
#include <iostream>
#include <vector>
#include <algorithm>
#include <functional>

int main()
{
    std::vector<int> values = { 3, 5, 1, 4, 2 };
    std::sort(values.begin(), values.end()); // [1, 2, 3, 4, 5]
    std::sort(values.begin(), values.end(), std::greater<int>()); // [5, 4, 3, 2, 1]
    std::sort(values.begin(), values.end(), [](int a, int b) {
        return a < b;
    }); // [1, 2, 3, 4, 5]
    std::sort(values.begin(), values.end(), [](int a, int b) {
        if (a == 1)
            return false;
        if (b == 1)
            return true;
        return a < b;
    }); // [2, 3, 4, 5, 1]

    for (int value : values)
        std::cout << value << std::endl;
}
```

- Cppreference: [std::greater](https://en.cppreference.com/w/cpp/utility/functional/greater)

> Function object for performing comparisons. The main template invokes operator> on type T.

## Memory and Safety

### Stack, Heap and Lifetime

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
    Entity()  { std::cout << "Created Entity!" << std::endl; }
    ~Entity() { std::cout << "Destroyed Entity!" << std::endl; }
    void Print() const { std::cout << "Hello" << std::endl; }
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
    ScopedPtr(Entity* ptr) : m_Ptr(ptr) {}
    ~ScopedPtr() { delete m_Ptr; }
    Entity* operator->() { return m_Ptr; }
    const Entity* operator->() const { return m_Ptr; }
};

int main()
{
    {
        ScopedPtr e(new Entity);
        // or by implicit conversion
        ScopedPtr e = new Entity();
    }
    const ScopedPtr e = new Entity();
    e->Print();
}
```

智能指针一般都会重载 `->` 运算符，以使得智能指针使用起来和普通指针相同

- cppreference: [operator overloading](https://en.cppreference.com/w/cpp/language/operators)

> The overload of operator `->` must either return a raw pointer, or return an object (by reference or by value) for which operator `->` is in turn overloaded.

按照这个描述，碰到 `->` 运算符时会不断调用相应的操作函数 (例如 `->` 的运算符重载函数)，直到 `->` 被推导到对应的类型 (符合 `->` 右边的操作数的类型要求)

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
推荐使用 `std::make_XYZ` 这这种风格标准库函数来构造智能指针实例，这样你就可以在你的代码里永远摆脱 `new` 关键字了 :rofl: 
{{< /admonition >}}

### Safety

安全编程的目的主要是是降低崩溃、内存泄漏、非法访问的问题 (这一点 Rust 做的比较好，但也没有解决内存泄漏的问题)，从 C++11 开始推荐使用智能指针而不是原始指针来解决内存泄漏的相关问题，这是因为基于 RAII 的自动内存管理系统。

如果是生产环境则使用智能指针，如果是学习则使用原始指针。当然，如果你需要定制的话，也可以使用自己写的智能指针。

## Benchmarking

Wikipedia: [Benchmark](https://en.wikipedia.org/wiki/Benchmark_(computing))

### Timing

- cppreference: [Date and time utilities](https://en.cppreference.com/w/cpp/chrono)
- cppreference: [Standard library header <chrono> (C++11)](https://en.cppreference.com/w/cpp/header/chrono)

chrono 是一个平台无关的计时库，如果不是特定平台高精度的计时需求，使用这个库就足够了。

```c++
#include <iostream>
#include <thread>
#include <chrono>

int main()
{
    using namespace std::literals::chrono_literals;

    auto start = std::chrono::high_resolution_clock::now();
    std::this_thread::sleep_for(1s);
    auto end = std::chrono::high_resolution_clock::now();

    std::chrono::duration<float> duration = end - start;
    std::cout << duration << "s" << std::endl;
}
```

运用作用域、生命周期以及析构函数来实现自动计时:

```c++
#include <iostream>
#include <thread>
#include <chrono>

struct Timer
{
    std::chrono::steady_clock::time_point start, end;
    std::chrono::duration<float> duration;

    Timer()
    {
        start = std::chrono::high_resolution_clock::now();
    }

    ~Timer()
    {
        end = std::chrono::high_resolution_clock::now();
        duration = end - start;

        float ms = duration.count() * 1000.0f;
        std::cout << "Timer took " << ms << "ms" << std::endl;
    }
};

void Function()
{
    Timer timer;

    for (int i = 0; i < 100; i++)
        std::cout << "Hello\n" /* << std::endl */;
}

int main()
{
    Function();
}
```



## Advanced Topics

### Multiple Return Values

在 C++ 中，实现函数可以返回多个值有很多种方式:

- 适用性最强的是返回自定义的结构体使用结构体包装返回的多个值)
- 如果返回的多个值类型相同，可以返回 `vector` 或数组
- 如果返回的多个值类型不同，可以返回 `tuple` 或 `pair`
- 也可以使用引用或指针作为参数，在函数体内进行相应修改 (这是 C 语言风格的处理)

使用哪个方法需要依据具体情况而定，不能一概而论。因为在语法层面，涉及多返回值，或多或少都会有性能问题。

- cppreference: [std::tuple](https://en.cppreference.com/w/cpp/utility/tuple)
- cppreference: [std::pair](https://en.cppreference.com/w/cpp/utility/pair)

### Macros

- cppreference: [Replacing text macros](https://en.cppreference.com/w/cpp/preprocessor/replace)
- cppreference: [Preprocessor](https://en.cppreference.com/w/cpp/preprocessor)

宏和预处理的本质其实是文本替换:

```c++
#define WAIT std::cin.get()
```

"专门从事编写迷惑性代码":

```c++
#define OPEN_CURLY {
int main()
OPEN_CURLY
    return 0;
}
```

比较有意义的宏使用场景: Project 属性 -> C/C++ -> Preprocessor -> Preprocessor Definitions: 添加自定义的宏 (作用有些类似于 gcc 的 `-D` 参数)

这样可以实现不同模式下日志系统的输出不相同，例如 Debug 模式下定义 `PR_DEBUG` 宏，Release 模式下定义 `PR_RELEASE` 宏。然后在日志系统针对这两个宏是否被定义进行不同的处理，以让日志系统针对不同模式进行不同处理。

```c++
#ifdef PR_DEBUG
#define LOG(x) std::cout << x << std::endl;
#else
#define LOG(x)
#endif
```

`ifdef` 在很多情况下表现比较糟糕，使用 `if` 改写上面的代码 (搭配 `defined` 进行定义判定):

```c++
#if PR_DEBUG == 1
#define LOG(x) std::cout << x << std::endl;
#else defined(PR_RELEASE)
#define LOG(x)
#endif
```

`#if 0` 可以用于删除特定代码 (本质上是条件编译)

可以通过 `\` 来编写多行的宏，但是注意不要在 `\` 后面多按了空格，这样会导致是对空格的转义，一点要确保 `\` 后面是换行，这才是对换行符的转义:

```c++
#define MAIN int main() \
{ \
    std::cin.get(); \
}
```

{{< admonition >}}
宏常用于跟踪、调试，例如追踪内存分配 (e.g. 那哪一行、哪个函数分配了多少字节)、日志系统的输出
{{< /admonition >}}

### Function Pointers

#### Pointer to Function in C

- cppreference: [Pointer declaration](https://en.cppreference.com/w/cpp/language/pointer) - **Pointers to functions**

> A pointer to function can be initialized with an address of a non-member function or a static member function. Because of the function-to-pointer implicit conversion, the address-of operator is optional

```c++
#include <iostream>
void HelloWorld(int a) 
{ 
    std::cout << "Hello, world!" << << a << std::endl; 
}
int main()
{
    void(*function)(int) = HelloWorld; // C style
    auto function = HelloWorld; // or &HelloWorld;
    function(5); // same as call `HelloWorld(5)`
}
```

`auto` 在推导裸函数指针 (raw function pointer) 上特别有用 (因为裸函数指针类型实在是太复杂了)。也可以使用 `using` 或 `typedef` 为函数指针取别名，增加可读性:

```c++
typedef void(*HelloWorldFunction)(int);  // by `typedef`
using HelloWroldFunction = void(*)(int); // by `using`

HelloWorldFunction function = HelloWorld;
function(5);
function(6);
function(7);
```

函数指针作为函数参数传递:

```c++
#include <iostream>
#include <vector>

void PrintValue(int value)
{
    std::cout << "Value: " << value << std::endl;
}

void ForEach(const std::vector<int>& values, void(*func)(int))
{
    for (int value : values)
        func(value);
}

int main()
{
    std::vector<int> values = { 1, 5, 4, 2, 3 };
    ForEach(values, PrintValue); // should print 1, 5, 4, 2, 3 line by line
}
```

#### Lambdas

- cppreference: [Lambda expressions (since C++11)](https://en.cppreference.com/w/cpp/language/lambda)

> Constructs a closure: an unnamed function object capable of capturing variables in scope.

只要你有一个函数指针，你都可以在 C++ 中使用 Lambda 表达式。即我们会在设置函数指针以指向函数的地方，我们都可以使用 Lambda 表达式来代替函数指针使用 (例如函数参数)。但这个规则是有前提的，仅限于非捕获类的 Lambda 表达式，如果是捕获类的 Lambda 表达式，则需要使用 `std::function`。

使用 Lambda 表达式改写之前的函数指针作为函数参数的例子:

```c++
int main()
{
    std::vector<int> values = { 1, 5, 4, 2, 3 };
    ForEach(values, [](int value) { std::cout << "Value: " << value << std::endl; });
}
```

> The captures is a comma-separated list of zero or more captures, optionally beginning with the *capture-default*. The capture list defines the outside variables that are accessible from within the lambda function body. The only *capture-defaults* are
> 
> - `&` (implicitly capture the used variables with automatic storage duration by reference) and
> - `=` (implicitly capture the used variables with automatic storage duration by copy).
>
> The syntax of an individual capture in captures is ...

Lambda 表达式的捕获分为 capture-default 和 individual capture，这两者都是可选的。capture-default 指定的是该 Lambda 表达式默认的捕获规则，而 individual capture 指定的是单独变量的捕获规则。

- cppreference: [std::function](https://en.cppreference.com/w/cpp/utility/functional/function)

```c++
#include <iostream>
#include <vector>
#include <functional>
#include <algorithm>

void ForEach(const std::vector<int>& values, const std::function<void(int)>& func)
{
    for (int value : values)
        func(value);
}

int main()
{
    std::vector<int> values = { 1, 5, 4, 2, 3 };
    int a = 5;
    auto lambda = [=](int value) { std::cout << "Value: " << a << std::endl; };
    ForEach(values, lambda); // should print 5 five times line by line

    auto it = std::find_if(values.begin(), values.end(), [](int value) { return value > 3; });
    std::cout << *it << std::endl; // should print 5
}
```

- cppreference: [std::find, std::find_if, std::find_if_not](https://en.cppreference.com/w/cpp/algorithm/find)

- cppreference: [Function objects](https://en.cppreference.com/w/cpp/utility/functional)

> A function object is any object for which the function call operator is defined. C++ provides many built-in function objects as well as support for creation and manipulation of new function objects.

### Type Punning

- Stack Overflow: [What is the modern, correct way to do type punning in C++?](https://stackoverflow.com/questions/67636231/what-is-the-modern-correct-way-to-do-type-punning-in-c)

通过指针和引用直接操作内存来实现类型双关 (Type Punning)，可以搭配调试器的内存查看功能进行观察:

```c++
int a = 50;
double value = *(double*)&a;    // copy
double& value = *(double*)&a;   // in-place
```

```c++
#include <iostream>
class Entity
{
    int x, y;
};
int main()
{
    Entity e = { 5, 8 };
    int* position = (int*)&e;
    std::cout << position[0] << ", " << position[1] << std::endl; // [5, 8]
    int y = *(int*)((char*)&e + 4);
    std::cout << y << std::endl; // 8
}
```

上面的这些代码不建议使用，除非你是研究操作系统内核这类对内存操作精度极高的领域。下面使用 `union` 来实现类型双关 (Type Punning):

- cppreference: [Union declaration](https://en.cppreference.com/w/c/language/union)

> Similar to struct, an unnamed member of a union whose type is a union without name is known as anonymous union. Every member of an anonymous union is considered to be a member of the enclosing struct or union keeping their union layout. This applies recursively if the enclosing struct or union is also anonymous.

```c++
struct Union
{
    union 
    {
        float a;
        int b;
    };
};

Union u;
u.a = 2.0f;
std::cout << u.b << std::endl;
```

```c++
struct Vector2
{
    float x, y;
};
struct Vector4
{
    // By pointer and reference
    float x, y, z, w;

    Vector2& GetA()
    {
        return *(Vector*)&x;
    }

    // By union
    union
    {
        struct
        {
            float x, y, z, w;
        };
        struct 
        {
            Vector2 a, b;
        };
    }

    Vector2& GetA()
    {
        return a;
    }
};
```

### Casting

{{< link href="#explict" content="Specifiers::Explict" >}} 处有讲解了一部分隐式转换和显式转换。{{< link href="#union-and-type-punning" content="Union and Type Punning" >}} 处也对类型转换进行了一定程度的讲解。下面对 C 风格和 C++ 风格的强制类型转换 (casting) 进行详细说明。

- cppreference: [Explicit type conversion](https://en.cppreference.com/w/cpp/language/explicit_cast)

```c++
double value = 5.25;

// C style
double a = (int)value + 5.3; // a == 10.3

// C++ style
double s = static_cast<int>(value) + 5.3; // a == 10.3
```

所有 C++ 风格的强制类型转换都可以使用 C 风格的强制类型转换来实现。C++ 风格只是多了些语法糖，例如 `static_cast` 会在编译时期进行一些检查 (例如检查转换的类型是否合法，这在 Linux kernel 是常有的操作)，本质一样都是从一个类型转换成另一个类型。使用 C++ 风格的类型转换还有另一个好处，就是可以在代码库检索类型转换在哪发生，这样可以针对性的禁用某些类型转换以提高性能。

{{< admonition quote >}}
* cast 分为 `static_cast`, `dynamic_cast`, `reinterpret_cast`, `const_cast`
* [static_cast](https://en.cppreference.com/w/cpp/language/static_cast) 用于进行比较“自然”和低风险的转换，如整型和浮点型、字符型之间的互相转换，不能用于指针类型的强制转换，会在编译时进行检查
* [reinterpret_cast](https://en.cppreference.com/w/cpp/language/reinterpret_cast) 用于进行各种不同类型的指针之间强制转换
* [const_cast](https://en.cppreference.com/w/cpp/language/const_cast) 仅用于进行增加或去除 `const` 属性的转换
* [dynamic_cast](https://en.cppreference.com/w/cpp/language/dynamic_cast) 不检查转换安全性，仅运行时检查，如果不能转换，返回 null (常用于多态)
{{< /admonition >}}

- 以上整理自 [@ljnelf](https://space.bilibili.com/27560356) 的评论

#### Dynamic Casting

```c++
```

### Namespaces

- cppreference: [Namespaces](https://en.cppreference.com/w/cpp/language/namespace)

> Namespaces provide a method for preventing name conflicts in large projects.

Rust 中的 [Module](https://doc.rust-lang.org/book/ch07-02-defining-modules-to-control-scope-and-privacy.html) 也是类似的语法

类本身也是一个 namespace，所以使用类似的操作符 `::` 访问内部成员

#### Don't "using namspace std" 

不推荐使用 `using namespace std;` 类似的语句，使用 `std;:xxx` 这样的风格。因为现实中比较少用 STL，都是工作室自己开发类似 STL 的库来使用，这样可以区分代码中使用的是哪个库的 API。

实作案例: EASTL [vector.h](https://github.com/electronicarts/EASTL/blob/master/include/EASTL/vector.h#L77)

```c++
vector<int> vec; // what about vector? std::vector or eastl::vector?
```

滥用 `using namespace xxx;` 也可能会造成 API 名字冲突，例如上面的例子如果同时使用了:

```c++
using namespace std;
using namespace eastl;
```

会因为指定调用函数不明确而导致编译失败。这种会导致编译失败的情景还算比较好的了 (因为编译时期就报错了)，下面这种情景更是灾难性的:

```c++
#include <iostream>
#include <string>

namespace apple {
    void Print(const std::string& text)
    {
        std::cout << text << std::endl;
    }
}

namespace purple {
    void Print(const char* text)
    {
        std::string temp = text;
        std::reverse(temp.begin(), temp.end());
        std::cout << temp << std::endl;
    }
}

int main()
{
    using namespace apple;
    using namespace purple;
    Print("Hello"); // we want to print "Hello" but print "olleH"
}
```

这段代码没有编译错误也没有警告，但是运行起来不符合预期，是灾难性的运行时错误。这是因为不同库不能保证相同 API 接口是互斥的，所以会导致如上这种情况，调用的 API 不如我们预期。

{{< admonition tip >}}
另外需要特别注意，千万不要在头文件中使用 `using namspace`！这会导致将 namespace 引入到不必要的地方，编译失败时很难追踪。

尽量在比较小的作用域中使用 `using namespace`，例如 `if` 语句的作用域，函数体内，这样使用是没问题的。最大作用域的使用场景就是一个单独的 cpp 文件中使用了，以控制 namespace 的扩散范围。

大项目尽量将函数、类等等定义在 namspace 内，防止出现 API 冲突。
{{< /admonition >}}

### Threads

- cppreference: [Concurrency support library (since C++11)](https://en.cppreference.com/w/cpp/thread)
- cppreference: [std::thread](https://en.cppreference.com/w/cpp/thread/thread)

> The class `thread` represents a single thread of execution. Threads allow multiple functions to execute concurrently.

```c++
#include <iostream>
#include <thread>

static bool s_Finished = false;

void DoWork()
{
    using namespace std::literals::chrono_literals;

    std::cout << "Start thread id=" << std::this_thread::get_id() << std::endl;

    while (!s_Finished)
    {
        std::cout << "Working...\n";
        std::this_thread::sleep_for(1s);
    }
}

int main()
{
    std::thread worker(DoWork);

    std::cin.get();
    s_Finished = true;

    worker.join();

    std::cout << "Finished." << std::endl;
    std::cout << "Start thread id=" << std::this_thread::get_id() << std::endl;
}
```


### Coding Style

个人偏好如下:

- 函数名: [PscalCase](https://en.wikipedia.org/wiki/Naming_convention_(programming)#Letter_case-separated_words) 命名法 e.g. `ForEach`
- 类成员: [Hungarian](https://en.wikipedia.org/wiki/Hungarian_notation) 命名法 e.g. `m_Devices`

## Gui

### ImGui

bilibili: [ImGui 入门到精通](https://space.bilibili.com/443124242/channel/collectiondetail?sid=824431)
/ [项目源代码](https://www.bilibili.com/read/cv19537138/)

依赖库:
- [GLFW](https://www.glfw.org/download): 64-bit Windows binaries
- [GLEW](https://glew.sourceforge.net/): Windows 32-bit and 64-bit Binaries
- [imgui](https://github.com/ocornut/imgui/tree/docking): Branch docking

项目组织结构按照 Cherno 推荐的进行设定:
- C/C++ -> Additional Include Directoris
    - `$(SolutionDir)\Dependencies\GLFW\include`
    - `$(SolutionDir)\Dependencies\GLEW\include`
    - `$(ProjectDir)\imgui`
- Linker -> Additional Library Directories
    - `glfw3.lib`
    - `glew32s.lib`
    - `Opengl32.lib`: 这个库是计算机自带的

```c++
// must keep this import order!
#include "GL/glew.h"
#include "GLFW/glfw3.h"

#include "imgui.h"
#include "imgui_impl_glfw.h"
#include "imgui_impl_opengl3.h"
```

#### 创建窗口

```c++
GLFWwindow* Windows;

int main()
{
    // init GLFW and OpenGL
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    // create main window
    Windows = glfwCreateWindow(1000, 800, "ImGuiDemo", NULL, NULL);
    // give control permission to main window
    glfwMakeContextCurrent(Windows);
    // disable sync
    glfwSwapInterval(0);

    // init ImGui
    IMGUI_CHECKVERSION();
    ImGui::CreateContext(NULL);
    // read from io and set content of ImGui
    ImGuiIO& io = ImGui::GetIO(); (void)io;

    // set ImGui's style
    ImGui::StyleColorsDark();
    // init ImGui to window created by GLFW 
    ImGui_ImplGlfw_InitForOpenGL(Windows, true);
    // init ImGui to be rendered by OpenGL
    ImGui_ImplOpenGL3_Init("#version 330");

    // check the close flag (is not entered) of window
    while (!glfwWindowShouldClose(Windows))
    {
        // clear rendered data
        glClear(GL_COLOR_BUFFER_BIT);

        // ImGui init every frame with GLFW and OpenGL
        ImGui_ImplOpenGL3_NewFrame();
        ImGui_ImplGlfw_NewFrame();
        ImGui::NewFrame();

        // ImGui Demo
        ImGui::ShowDemoWindow();

        // get data to be rendered
        ImGui::Render();
        // draw GmGui's data got before
        ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());

        // draw content of window
        glfwSwapBuffers(Windows);
        // draw events
        glfwPollEvents();
    }
}
```

#### 基础控件

##### 窗口

```c++
ImGui::Begin("MyImGuiWindow", 0, ImGuiWindowFlags_::ImGuiWindowFlags_MenuBar);
...
ImGui::End();
```

##### 文本框

```c++
std::string Text = "Hello, world! 123";
ImGui::Text(Text.c_str());
```

##### 按钮

```c++
if (ImGui::Button("Button"))
{
    Text = "You click the button";
}
```

##### 输入文本框

```c++
char  textbox[64] = "Test Text Box";
ImGui::InputText("Test Text Box", textbox, 64);
```

##### 固定显示选项的列表

```c++
ImGui::BeginListBox("List");
for (size_t i = 0; i < 32; i++)
{
    if (ImGui::Selectable(std::to_string(i).c_str()))
    {
        Text = std::to_string(i);
    }
}
ImGui::EndListBox();
```

- Issue: [Horizontal scrollbar when using ListBoxHeader](https://github.com/ocornut/imgui/issues/2510)
> Also note that `ListBoxHeader()` was renamed to `BeginListBox()` on 2023-05-31 

##### 可展开显示选项的列表

```c++
if (ImGui::BeginCombo("Combo", Text.c_str()))
{
	for (size_t i = 0; i < 32; i++)
	{
		if (ImGui::Selectable(std::to_string(i).c_str()))
		{
			Text = std::to_string(i);
		}
	}
	ImGui::EndCombo();
}
```

##### 颜色选择器

```c++
ImVec4 color;
ImGui::ColorEdit4("Color", (float*)&color, ImGuiColorEditFlags_::ImGuiColorEditFlags_AlphaBar);
```

#### 高级定制

## References

- The Cherno: [C++](https://www.youtube.com/playlist?list=PLlrATfBNZ98dudnM48yfGUldqGD0S4FFb) / [中文翻译](https://space.bilibili.com/364152971/channel/collectiondetail?sid=13909): 主要介绍 C++11 及以上版本的语法
- [C++ Weekly With Jason Turner](https://www.youtube.com/@cppweekly): 这个博主超级猛
- [CppCon](https://www.youtube.com/@CppCon): 强烈推荐 [Back To Basics](https://www.youtube.com/@CppCon/search?query=Back%20to%20Basics) 专题
- [C++ 矿坑系列](https://github.com/Mes0903/Cpp-Miner)
- 我是龙套小果丁: [现代 C++ 基础](https://space.bilibili.com/18874763/channel/collectiondetail?sid=2192185)
- 南方科技大学: [快速学习 C 和 C++，基础语法和优化策略](https://www.bilibili.com/video/BV1Vf4y1P7pq/)
- 原子之音: [C++ 现代实用教程](https://space.bilibili.com/437860379/channel/seriesdetail?sid=2352475)
/ [C++ 智能指针](https://www.bilibili.com/video/BV18B4y187uL)
/ [CMake 简明教程](https://www.bilibili.com/video/BV1xa4y1R7vT)
- [Learn C++](https://www.learncpp.com/)
