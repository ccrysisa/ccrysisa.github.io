# Modern C&#43;&#43; (MSVC)


&#34;Modern&#34; [C&#43;&#43;](https://en.wikipedia.org/wiki/C%2B%2B) isn&#39;t afraid to use any or all of the following:

- RAII
- standard library containers and algorithms
- templates
- metaprogramming
- exceptions
- Boost

&#34;Old&#34; [C&#43;&#43;](https://en.wikipedia.org/wiki/C%2B%2B) tends to avoid these things due to a perceived lack of compiler support or run-time performance. Instead, you&#39;ll find...

- lots of `new` and `delete`
- roll-your-own linked lists and other data structures
- return codes as a mechanism for error handling
- one of the millions of custom string classes that aren&#39;t `std::string`

As with all this-vs-that arguments, there are merits to both approaches. Modern C&#43;&#43; isn&#39;t universally better. Embedded enviornments, for example, often require extra restrictions that most people never need, so you&#39;ll see a lot of old-style code there. Overall though, I think you&#39;ll find that most of the modern features are worth using regularly. Moore&#39;s Law and compiler improvements have taken care of the majority of reasons to avoid the new stuff.

&lt;!--more--&gt;

&gt; 以上整理自 Stack Overflow: [What is modern C&#43;&#43;?](https://stackoverflow.com/questions/3661237/what-is-modern-c)

{{&lt; admonition success &gt;}}
写出好的 C&#43;&#43; 代码，而不是炫耀你所会的 C&#43;&#43; 的特性。不要为了炫技而炫技！
{{&lt; /admonition &gt;}}

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

&gt; Visual Studio 2019
$\rightarrow$
右键项目然后 properties 
$\rightarrow$
C/C&#43;&#43; 
$\rightarrow$
Preprocess to File (Yes) 

编译 / 构建后可以得到产生后缀为 `.i` 的预处理中间文件

#### Conditional Compilation

- Wikipedia: [Conditional compilation](https://en.wikipedia.org/wiki/Conditional_compilation)

```c&#43;&#43;
#if &lt;condition&gt;
  ...
#else
  ...
#endif
```

#### Assembly

&gt; Visual Studio 2019
$\rightarrow$
右键项目然后 properties 
$\rightarrow$
C/C&#43;&#43; 
$\rightarrow$
Output Files
$\rightarrow$
Assembler Output (Assembly-Only Listing)

编译 / 构建后可以得到后缀为 `.asm` 的汇编文件

#### Optimization

&gt; Visual Studio 2019
$\rightarrow$
右键项目然后 properties 
$\rightarrow$
C/C&#43;&#43; 
$\rightarrow$
Optimization
$\rightarrow$
Optimization (Maximize Speed)

可以改变当前构建环境 (一般是 Debug 模式) 所使用的编译器最优化策略

{{&lt; admonition note &#34;快捷键&#34; &gt;}}
- F7: Compile / Build
- F5: Run (Compile and Link)
{{&lt; /admonition &gt;}}

### Linker

Linker 的一个重要作用是 **定位程序的入口 (entry point)**，所以对于单源文件的项目来说，Linker 也会起作用

{{&lt; admonition &gt;}}
Visual Studio 的错误提示中，`C` 开头的错误 (error) 表示的是编译 (Compile) 时期的错误，`LNK` 开头的错误 (error) 表示的是链接 (Link) 时期的错误
{{&lt; /admonition &gt;}}

解决函数重复定义这个问题，可以给其中一个函数的签名加上 `static` 或 `inline` 的修饰

### Debug

调试时相关信息的窗口在「调试 $\rightarrow$ 窗口」处可以开启显示

在内存查看窗口，可以通过 `&amp;var` (`var` 为当前上下文变量的名字) 来快速获取该变量对应的地址，以及查看该地址所所储存的值

调试过程中，通过「右键 $\rightarrow$ 转到反汇编」即可查看对应的汇编代码

#### Contional and Action Breakpoints

Microsoft Learn: [Use breakpoints in the Visual Studio debugger](https://learn.microsoft.com/en-us/visualstudio/debugger/using-breakpoints?view=vs-2022)

- **Breakpoint conditions**

&gt; You can control when and where a breakpoint executes by setting conditions. The condition can be any valid expression that the debugger recognizes.

- **Breakpoint actions and tracepoints**

&gt; A tracepoint is a breakpoint that prints a message to the Output window. A tracepoint can act like a temporary trace statement in the programming language and does not pause the execution of code. You create a tracepoint by setting a special action in the Breakpoint Settings window.


### Projects

filter 类似于一种虚拟的文件系统组织，不过只能在 VS 才能表示为层次形式 (通过解析 XML 格式的配置文件)，在主机的文件系统上没有影响

解决方案栏的「显示所有文件」可以展示当前 Project 在主机文件系统下的组织层次结构，也可以在这个视图下创建目录 / 文件，这样也会在主机文件系统创建对应的目录 / 文件

主机文件系统和 VS 的虚拟项目组织是解耦的，所以在主机移动源文件并不会影响其在 VS 的虚拟项目组织所在的位置

VS 默认设置是将构建 / 编译得到的中间文件放在 Project 的 Debug 目录，但是得到的可执行文件却放在 Solution 的 Debug 目录下，这十分奇怪。可以通过修改 **Project 的属性** (右键选择属性这一选项) 里的输出目录，使得其与中间目录一致为 `$(Configuration)\`。也可以将 Solution 内的全部 Projects 的可执行文件均放置在 Solution 下的同一目录

推荐设定如下:
- Output Directory: `$(SolutionDir)\bin\$(Platform)\$(Configuration)\`
- Intermediate Directory: `$(SolutionDir)\bin\intermidiate\$(Platform)\$(Configuration)\`

{{&lt; admonition &gt;}}
在编辑这些目录设定时，其下拉框中选择「编辑 -&gt; 宏」可以查看形如 `$(SolutionDir)` 这些宏的定义

设定 Solution 或 Project 的属性时，需要注意选择合适的 Configuration (配置) 和 Platform (平台) 进行应用
{{&lt; /admonition &gt;}}

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

- Solution 资源管理器 -&gt; 右击 Solution 名称 -&gt; Add (**New Project**)

一般来说，一个 Solution 只有一个生成可运行文件的 Project，其它 Project 应该作为静态链接存在 (当然测试作用的 Project 也应该是可执行文件类型)。设定 Project 类型:

右击 Project 名称 -&gt; Properties -&gt; Configuration Properties -&gt; General -&gt; Configuration Type 

- 可执行 Project: **Application (.exe)**
- 其余的 Project: **Static library (.lib)**

这样即可将整个 Solution 构建成一个可执行文件，但是这样引用其它 Project 的头文件比较麻烦，我们还是需要使用真实文件系统的路径进行引用，为了避免繁杂的头文件路径以及防止路径变更导致构建失败，我们使用和上一节类似的技术：设定 Project 的属性: C/C&#43;&#43; -&gt; Additional Include Directoris，在里面添加我们想要引用的 Project 头文件所在的目录路径 (一般为 `$(SolutionDir)\ProjectName\src`)。

{{&lt; admonition &gt;}}
这个设定 Include 目录的过程实际上也设置了 Projects 之间的依赖关系 (某种意义上的 CMake，VS 是使用 sln 来管理包和代码库的)
{{&lt; /admonition &gt;}}

### Libraries

- Unix 哲学: 自己编译代码进行构建 (例如 [LFS](https://www.linuxfromscratch.org/lfs/))
- Windows 哲学: 能用就行，最好双击就可运行 :rofl:

接下来以 [GLFW](https://www.glfw.org/) 这个库为例来说明 C&#43;&#43; 项目中如何使用 **静态链接** ([static linking](https://en.wikipedia.org/wiki/Static_library)) 和 **动态链接库** ([dynamic libraries](https://en.wikipedia.org/wiki/Dynamic-link_library))，以及这两者的区别。

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
2. 设定 **Project 的属性**: C/C&#43;&#43; -&gt; Additional Include Directoris 为上一步存放依赖库的路径
   - `$(SolutionDir)\Dependencies\GLFW\include`
   - 指定完成后编译器就知道如何去寻找相关的头文件了，不会导致编译错误
   - 但是链接器还没有设定，会导致链接错误
3. 设定 Linker -&gt; Additional Library Directories 为依赖库文件所处路径
   - `$(SolutionDir)\Dependencies\GLFW\lib-vc2019`
   - 该路径可包含静态库和动态库

#### Static Linking

在 Linker -&gt; input -&gt; Addtional Dependencies 处添加相对于之前依赖库目录的静态库文件路径: `glfw3.lib` (注意这里的依赖项不能包含相应的动态库相关文件)

```c&#43;&#43;
#include &lt;iostream&gt;
#include &#34;GLFW\glfw3.h&#34;

int main()
{
    int a = glfwInit();
    std::cout &lt;&lt; a &lt;&lt; std::endl; // ouput 1
}
```

#### Dynamic Linking

{{&lt; admonition quote &gt;}}
C&#43;&#43; 在使用动态库的时候，一般提供两个文件：一个引入库 (后缀为 `dll.lib`，本质为静态链接文件) 和一个 DLL (后缀为 `.dll`，为动态链接文件)。引入库包含被 DLL 导出的函数和变量的符号名以及相应的寻址位置，而 DLL 包含实际的函数和数据。在编译链接可执行文件时，只需要链接引入库，DLL 中的函数代码和数据并不复制到可执行文件中，在运行的时候，再去加载 DLL 以访问 DLL 中导出的函数。不需要引入库也可以使用 DLL，但是效率会低，因为 **运行时** 每次访问 DLL 的资源都需要进行遍历 DLL 查询资源的具体位置 (类似于顺序遍历) 再进行链接，而如果有引入库，因为引入库记录了 DLL 所有公开资源的具体位置，可以直接在 **链接时** 在引入库查询 (类似于哈希表查找) 然后运行时直接对具体位置进行链接即可。
{{&lt; /admonition &gt;}}

- 以上整理自 [@神经元猫](https://space.bilibili.com/364152971) 的评论

在 Linker -&gt; input -&gt; Addtional Dependencies 处添加相对于之前依赖库目录的动态链接引入库文件路径: `glfw3dll.lib` (注意这里的依赖项不能包含相应的静态库相关文件)

将 `glfw3.dll` 这个动态库文件 (后缀为 `.dll`) 放置在可执行文件目录下 (Ouput Directory)，让该 DLL 可以被可执行文件 (后缀为 `.exe`) 在执行时搜索到

```c&#43;&#43;
#include &lt;iostream&gt;
#include &#34;GLFW\glfw3.h&#34;

int main()
{
    int a = glfwInit();
    std::cout &lt;&lt; a &lt;&lt; std::endl; // ouput 1
}
```

## Header File

Header Guard:

```c&#43;&#43;
#program once
```

is equivalent to:

```c&#43;&#43;
#ifndef _XXX_H
#define _XXX_H
...
#endif
```

Make sure it just into a single translation unit.

GCC, Clang 和 MSVC 这些主流的编译器都支持 `#program once` 这个语法

```c&#43;&#43;
#include &lt;HEADER_FILE&gt;
#include &#34;HEADER_FILE&#34;
```

`&lt;&gt;` 只能用于搜索标准库所在路径的头文件，而 `&#34;&#34;` 不仅可以搜索标准库所在路径，还可以搜索当前文件的相对路径的头文件，例如:

```c&#43;&#43;
#include &#34;../HEADER.h&#34;
#include &#34;../include/HEADER.h&#34;
```

### Precompiled Headers

预编译头文件会使得 C&#43;&#43; 头文件 (特别是 STL) 达到类似模块的效果，即头文件本身也是一个编译单元，这样就不会因为我们自己编写的源文件修改了，而一遍一遍的解析其所引用的头文件然后进行全部编译，这样会提升我们项目的编译速度。如果你关心编译时间，那一定要使用预编译头文件。

但是不要往预编译头文件中添加那些会被经常修改的东西，这样会导致该头文件会被重新编译，同样会延长编译时间。推荐将不常修改的东西放入至预编译头文件当中，并且是被很多源文件所需要的外部依赖，例如 STL。对于被源文件需要较少的外部依赖，例如 ImGui 需要的外部依赖 GLFW。推荐使用 Linker 设定而不是 PCH。

下面这个头文件在预处理后足足有 40 万行，如果不使用预编译头文件，又被多个源文件引用了该头文件，那么编译时间会极其恐怖:

```c&#43;&#43; {title=&#34;pch.h&#34;}
#pragma once

// Utilities
#include &lt;iostream&gt;
#include &lt;algorithm&gt;
#include &lt;functional&gt;
#include &lt;optional&gt;
#include &lt;memory&gt;
#include &lt;thread&gt;
#include &lt;utility&gt;

// Data structures
#include &lt;vector&gt;
#include &lt;array&gt;
#include &lt;stack&gt;
#include &lt;queue&gt;
#include &lt;deque&gt;
#include &lt;string&gt;
#include &lt;set&gt;
#include &lt;map&gt;
#include &lt;unordered_set&gt;
#include &lt;unordered_map&gt;

// Windows API
#include &lt;Windows.h&gt;
```

为了避免这种情况 (被大量源文件所引用的外部依赖)，可以使用预编译头文件来处理:

1. 创建一个仅引用上面头文件的源文件 `pch.cpp`:

```c&#43;&#43; {title=&#34;pch.cpp&#34;}
#include &#34;pch.h&#34;
```
2. 右击该 **源文件** 并进入其属性设定: C/C&#43;&#43; $\rightarrow$ Precompiled Headers $\rightarrow$ Precompiled Header (**Create**)

3. 右击 **项目** 并进入其属性设定: C/C&#43;&#43; $\rightarrow$ Precompiled Headers $\rightarrow$ Precompiled Header (**Use**) $\rightarrow$ Precompiled Header File (**pch.h**)

{{&lt; admonition tip &gt;}}
Visual Studio 的 Tools $\rightarrow$ Options $\rightarrow$ Projects and Solutions $\rightarrow$ Project Settings $\rightarrow$ Build Timing (**Yes**) 可以开启显示构建计时功能。
{{&lt; /admonition &gt;}}

g&#43;&#43; 也可以使用预编译头文件功能:

```bash
# without precompiled header
$ time g&#43;&#43; -std=c&#43;&#43;11 main.cpp

real    0m1.257s
user    0m0.000s
sys     0m0.000s

# build precompiled header
$ g&#43;&#43; -std=c&#43;&#43;11 pch.h

# with precompiled header
$ time g&#43;&#43; -std=c&#43;&#43;11 main.cpp

real    0m0.266s
user    0m0.000s
sys     0m0.030s
```

## Pointers and References

&gt; ***这两大主题可以使用 VS 调试功能的查看内存窗口进行实践***
 
- cppreference: [nullptr](https://en.cppreference.com/w/cpp/language/nullptr)

指针可以置为空，空指针可以通过 `0`, `NULL` 或 C&#43;&#43;11 引入的关键字 `nullptr` 来表示

- cppreference: [Pointers to void](https://en.cppreference.com/w/cpp/language/pointer#Pointers_to_void)
&gt; Pointers to void have the same size, representation and alignment as pointers to char.

`void*` 一般只用于表示地址 (因为其内存对齐要求的单位为字节，并且内存寻址的单位也是字节)，一般不用于修改所指向地址处的数据 (因为它和 `int*` 这类指针不同，并没有表示偏移量的信息)，其它指针的类型记录了其偏移量信息，例如 `double*` 这个指针类型的偏移量信息为 8 个字节 (因为 `double` 占据的内存空间为连续的 8 个字节)

```c&#43;&#43;
itn main()
{
    char* buffer = new char[8]; 
    memset(buffer, 0, 8);
    char** ptr = &amp;buffer;
    delete[] buffer;
}
```

- cppreference: [new expression](https://en.cppreference.com/w/cpp/language/new)
- cppreference: [operator new, operator new[]](https://en.cppreference.com/w/cpp/memory/new/operator_new)
- cppreference: [delete expression](https://en.cppreference.com/w/cpp/language/delete)
- cppreference: [operator delete, operator delete[]](https://en.cppreference.com/w/cpp/memory/new/operator_delete)

C&#43;&#43; 的 Reference 和 Pointer 几乎是同样的东西，除了 Reference 在使用上等价于 Pointer 解引用后的使用。Reference 不能为空以及只能依赖于已存在 object (即必须先有 object 再有 Reference) 其实也是这一点的衍生，因为 Refernece 的使用等价于 Pointer 解引用后的使用，所以 Reference 必须指向已存在的 object，否则会造成 UB，同理 Reference 也不能为空

```c&#43;&#43;
void increment(int&amp; value)
{
    value&#43;&#43;;
}

int main()
{
    int a = 5;
    int&amp; ref = a;
    ref = 2;

    increment(a);
}
```

函数体内使用 Reference (例如上面程式码的 `main` 函数) 并不会分配内存空间给所谓的 Reference 变量，编译器将 Reference 视为所引用变量的别名 (alias)，修改时直接修改所引用的变量即可

但如果在函数参数中使用 Reference (例如上面程式码的 `increment` 函数)，那么编译器在底层实现时会和使用 Pointer 相同，即会分配内存空间为 Pointer (函数参数的 Reference 所暗示的)，然后在该函数内部使用该 Reference 的函数参数，效果和使用解引用的 Pointer 一致 *(在这个场景使用 Reference 效果和 Rust 的 Reference 类似)*

即上面程式码的 `increment` 函数和下面函数在编译器层面是一致的，都会被编译成相同的机器码:

```c&#43;&#43;
void increment(int* value)
{
    (*value)&#43;&#43;;
}
```

除此之外，Reference 与 Pointer 不同之处还在于，在初始化之后它不能改变所指向的 object

```c&#43;&#43;
int main()
{
    int a = 5;
    int b = 8;

    int&amp; ref = a; // ref point to a
    ref = b;      // set a&#39;s value to be b&#39;s value (8)!!!
}
```

### Function Pointers

- cppreference: [Pointer declaration](https://en.cppreference.com/w/cpp/language/pointer) - **Pointers to functions**

&gt; A pointer to function can be initialized with an address of a non-member function or a static member function. Because of the function-to-pointer implicit conversion, the address-of operator is optional

```c&#43;&#43;
#include &lt;iostream&gt;
void HelloWorld(int a) 
{ 
    std::cout &lt;&lt; &#34;Hello, world!&#34; &lt;&lt; &lt;&lt; a &lt;&lt; std::endl; 
}
int main()
{
    void(*function)(int) = HelloWorld; // C style
    auto function = HelloWorld; // or &amp;HelloWorld;
    function(5); // same as call `HelloWorld(5)`
}
```

`auto` 在推导裸函数指针 (raw function pointer) 上特别有用 (因为裸函数指针类型实在是太复杂了)。也可以使用 `using` 或 `typedef` 为函数指针取别名，增加可读性:

```c&#43;&#43;
typedef void(*HelloWorldFunction)(int);  // by `typedef`
using HelloWroldFunction = void(*)(int); // by `using`

HelloWorldFunction function = HelloWorld;
function(5);
function(6);
function(7);
```

函数指针作为函数参数传递:

```c&#43;&#43;
#include &lt;iostream&gt;
#include &lt;vector&gt;

void PrintValue(int value)
{
    std::cout &lt;&lt; &#34;Value: &#34; &lt;&lt; value &lt;&lt; std::endl;
}

void ForEach(const std::vector&lt;int&gt;&amp; values, void(*func)(int))
{
    for (int value : values)
        func(value);
}

int main()
{
    std::vector&lt;int&gt; values = { 1, 5, 4, 2, 3 };
    ForEach(values, PrintValue); // should print 1, 5, 4, 2, 3 line by line
}
```

### Lambdas

- cppreference: [Lambda expressions (since C&#43;&#43;11)](https://en.cppreference.com/w/cpp/language/lambda)

&gt; Constructs a closure: an unnamed function object capable of capturing variables in scope.

只要你有一个函数指针，你都可以在 C&#43;&#43; 中使用 Lambda 表达式。即我们会在设置函数指针以指向函数的地方，我们都可以使用 Lambda 表达式来代替函数指针使用 (例如函数参数)。但这个规则是有前提的，仅限于非捕获类的 Lambda 表达式，如果是捕获类的 Lambda 表达式，则需要使用 `std::function`。

使用 Lambda 表达式改写之前的函数指针作为函数参数的例子:

```c&#43;&#43;
int main()
{
    std::vector&lt;int&gt; values = { 1, 5, 4, 2, 3 };
    ForEach(values, [](int value) { std::cout &lt;&lt; &#34;Value: &#34; &lt;&lt; value &lt;&lt; std::endl; });
}
```

&gt; The captures is a comma-separated list of zero or more captures, optionally beginning with the *capture-default*. The capture list defines the outside variables that are accessible from within the lambda function body. The only *capture-defaults* are
&gt; 
&gt; - `&amp;` (implicitly capture the used variables with automatic storage duration by reference) and
&gt; - `=` (implicitly capture the used variables with automatic storage duration by copy).
&gt;
&gt; The syntax of an individual capture in captures is ...

Lambda 表达式的捕获分为 capture-default 和 individual capture，这两者都是可选的。capture-default 指定的是该 Lambda 表达式默认的捕获规则，而 individual capture 指定的是单独变量的捕获规则。

- cppreference: [std::function](https://en.cppreference.com/w/cpp/utility/functional/function)

```c&#43;&#43;
#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;functional&gt;
#include &lt;algorithm&gt;

void ForEach(const std::vector&lt;int&gt;&amp; values, const std::function&lt;void(int)&gt;&amp; func)
{
    for (int value : values)
        func(value);
}

int main()
{
    std::vector&lt;int&gt; values = { 1, 5, 4, 2, 3 };
    int a = 5;
    auto lambda = [=](int value) { std::cout &lt;&lt; &#34;Value: &#34; &lt;&lt; a &lt;&lt; std::endl; };
    ForEach(values, lambda); // should print 5 five times line by line

    auto it = std::find_if(values.begin(), values.end(), [](int value) { return value &gt; 3; });
    std::cout &lt;&lt; *it &lt;&lt; std::endl; // should print 5
}
```

- cppreference: [std::find, std::find_if, std::find_if_not](https://en.cppreference.com/w/cpp/algorithm/find)

- cppreference: [Function objects](https://en.cppreference.com/w/cpp/utility/functional)

&gt; A function object is any object for which the function call operator is defined. C&#43;&#43; provides many built-in function objects as well as support for creation and manipulation of new function objects.

## Object-Oriented Programming

### Class and Struct

C&#43;&#43; 的 Class 和 Struct 是相同的东西，只不过 Class 默认成员字段的外部可见性为 private，而 Struct 默认成员字段的外部可见性为 public，仅仅只有这个区别而已。

&gt; The data members of a class are private by default and the members of a structure are public by default. 

```c&#43;&#43;
class Player
{
public:
    int x, y;
    int speed;

    void Move(int xa, int ya)
    {
        x &#43;= xa * speed;
        y &#43;= ya * speed;
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

```c&#43;&#43;
struct Player
{
    int x, y;
    int speed;

    void Move(int xa, int ya)
    {
        x &#43;= xa * speed;
        y &#43;= ya * speed;
    }
};
```

{{&lt; admonition &gt;}}
从实践角度来看，在 C&#43;&#43; 中定义一个 *集合体*，它的成员字段默认都是 public 并且无需我们手动设定时，应当使用 `struct` 而不是 `class`，例如表示 TCP 数据报的 Header 应该使用 `struct`。也尽量不要在 `struct` 中使用继承，让 `struct` 作为一种相对纯粹的数据的组合
{{&lt; /admonition &gt;}}

**实作案例**: 日志系统 Log System

实作一个日志系统 (Log System) 来加深对 C&#43;&#43; 的 Class 的理解

```c&#43;&#43;
#include &lt;iostream&gt;

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
        if (m_LogLevel &gt;= Error)
        {
            std::cout &lt;&lt; &#34;[ERROR]: &#34; &lt;&lt; message &lt;&lt; std::endl;
        }
    }

    void warn(const char* message)
    {
        if (m_LogLevel &gt;= Warning)
        {
            std::cout &lt;&lt; &#34;[WARNING]: &#34; &lt;&lt; message &lt;&lt; std::endl;
        }
    }

    void info(const char* message)
    {
        if (m_LogLevel &gt;= Info)
        {
            std::cout &lt;&lt; &#34;[INFO]: &#34; &lt;&lt; message &lt;&lt; std::endl;
        }
    }
};

int main() {
    using std::cout;
    cout &lt;&lt; &#34;Hello world&#34; &lt;&lt; &#39;\n&#39;;

    Log log;
    log.SetLogLevel(Log::Level::Info);
    log.warn(&#34;Hello&#34;);
    log.error(&#34;Hello&#34;);
    log.info(&#34;Hello&#34;);

    return 0;
}
```

### Enum

- cppreference: [Enumeration declaration](https://en.cppreference.com/w/cpp/language/enum)

```c&#43;&#43;
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

&gt; In a member-specification of a class/struct or union, define the accessibility of subsequent members.
&gt; 
&gt; In a base-specifier of a derived class declaration, define the accessibility of inherited members of the subsequent base class.

A **public** member of a class is accessible anywhere

A **protected** member of a class is only accessible:
1) to the members and friends of that class;
2) to the members and friends of any derived class of that class, but only when the class of the object through which the protected member is accessed is that derived class or a derived class of that derived class

A **private** member of a class is only accessible to the members and friends of that class, regardless of whether the members are on the same or different instances

- Stack Overflow: [What is the difference between private and protected members of C&#43;&#43; classes?](https://stackoverflow.com/questions/224966/what-is-the-difference-between-private-and-protected-members-of-c-classes)

### Constructor and Destructor

```c&#43;&#43;
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

有时候可以借助 `private` 来隐藏 Class 或 Struct 的 Constructor，防止用户创建该 Class 或 Struct 的实例 (例如 Java 中的 Math 类，使用 C&#43;&#43; 实作的话就需要使用到这种技巧)，这是因为 C&#43;&#43; 会自动帮我们创建一个 `public` 的默认 Constructor。除此之外还可以使用 `delete` 关键字来删除默认的 Constructor

```c&#43;&#43;
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

```c&#43;&#43;
struct Entity
{
    float X, Y;
    Entity()
    {
        X = 0; Y = 0;
        std::cout &lt;&lt; &#34;Call the Constructor!&#34; &lt;&lt; std::endl;
    }
    ~Entity()
    {
        std::cout &lt;&lt; &#34;Call the Destructor!&#34; &lt;&lt; std::endl;
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

```c&#43;&#43;
#include &lt;string&gt;
class Entity
{
private:
    std::string m_Name;
public:
    Entity() : m_Name(&#34;Unknown&#34;) { ... }
    Entity(const std::string&amp; name) : m_Name(name) { ... }
};
```

{{&lt; admonition &gt;}}
使用 *初始化参数列表* 会节约性能，不会丢弃默认构造的对象，具体见视频的例子。原理也很简单，初始化参数列表是在执行函数体之前进行初始化的，不会事先创建对象。而如果在函数体内对对象进行赋值，因为不论是否在初始化参数列表中是否指定了成员变量，编译器都会在执行函数体之前先对每个成员变量进行构造 (当然初始化参数列表指定的就按列表构造)，导致在函数体内对成员变量赋值时，会丢掉先前构造好的对象，从而导致性能损失。(这很好理解，因为 Rust 要求构造对象时必须指定所有成员的值，C&#43;&#43; 的初始化列表的作用是类似的，给对象的每个成员都分配值，这样构造函数就无需指定每个成员的值了)

```c&#43;&#43;
#include &lt;iostream&gt;
#include &lt;string&gt;

class Example
{
public:
    Example() { std::cout &lt;&lt; &#34;Created Entity!&#34; &lt;&lt; std::endl; }
    Example(int x) { std::cout &lt;&lt; &#34;Created Entity with &#34; &lt;&lt; x &lt;&lt; &#34;!&#34; &lt;&lt; std::endl; }
};

class Entity
{
private:
    std::string m_Name;
    Example m_Example;
public:
    // call this constructor should print 2 lines (call 2 times of constructor of Example)
    Entity(const std::string&amp; name) : m_Name(name) {}
    // call this constructor should print only 1 line (call once of constructor of Example)
    Entity(const std::string&amp; name) { m_Name(name); }
};
```
{{&lt; /admonition &gt;}}

#### Copy Constructors

- Stack Overflow: [What is the difference between a deep copy and a shallow copy?](https://stackoverflow.com/questions/184710/what-is-the-difference-between-a-deep-copy-and-a-shallow-copy)

&gt; Shallow copies duplicate as little as possible. A shallow copy of a collection is a copy of the collection structure, not the elements. With a shallow copy, two collections now share the individual elements.

&gt; Deep copies duplicate everything. A deep copy of a collection is two collections with all of the elements in the original collection duplicated.

- cppreference: [Copy constructors](https://en.cppreference.com/w/cpp/language/copy_constructor)

&gt; A copy constructor is a constructor which can be called with an argument of the same class type and copies the content of the argument without mutating the argument.

C&#43;&#43; 编译器会提供一个默认的复制构造函数 (Copy Constructor)，如果你想禁止这种复制构造的行为，可以使用 `delete` 关键字:

```c&#43;&#43;
Class Type
{
    Type(const Type&amp; other) = delete;
};
```

C&#43;&#43; 的智能指针 `unique_ptr` 也是通过这种方式来实作禁止复制行为的:

- Standard library header &lt;[memory](https://en.cppreference.com/w/cpp/header/memory)&gt;

```c&#43;&#43;
class unique_ptr { // non-copyable pointer to an object
public:
    ...
    unique_ptr(const unique_ptr&amp;) = delete;
    ...
};
```

下面是一个自定义 String 类的实作案例，用于加深对 Copy 行为和 Copy Construtor 的理解:

```c&#43;&#43;
#include &lt;iostream&gt;
#include &lt;string&gt;

class String
{
private:
    char* m_Buffer;
    unsigned int m_Size;
public:
    String(const char* string)
    {
        m_Size = strlen(string);
        m_Buffer = new char[m_Size &#43; 1];
        memcpy(m_Buffer, string, m_Size);
        m_Buffer[m_Size] = 0 /* or &#39;\0` */;
    }

    String(const String&amp; other)
        : m_Size(other.m_Size)
    {
        m_Buffer = new char[m_Size &#43; 1];
        memcpy(m_Buffer, other.m_Buffer, m_Size &#43; 1);
    }

    ~String()
    {
        delete[] m_Buffer;
    }

    char&amp; operator[](unsigned int index)
    {
        return m_Buffer[index];
    }

    friend std::ostream&amp; operator&lt;&lt;(std::ostream&amp; stream, const String&amp; string);
};

std::ostream&amp; operator&lt;&lt;(std::ostream&amp; stream, const String&amp; string)
{
    stream &lt;&lt; string.m_Buffer;
    return stream;
}

int main() {
    String string = &#34;Hello&#34;;
    String second = string;

    second[1] = &#39;a&#39;;

    std::cout &lt;&lt; string &lt;&lt; std::endl;
    std::cout &lt;&lt; second &lt;&lt; std::endl;
}
```

{{&lt; admonition &gt;}}
复制构造 (Copy Structor) 和引用 (Reference) 的联系也比较紧密，因为一般情况下进行函数调用，不使用引用的话，会进行复制操作 (可以通过观察复制构造函数的调用)，这会造成性能损耗。所以一般情况下建议使用常量引用 (`const Type&amp;`) 以避免不必要的性能损耗 (当然这样你在函数内部也可以决定是否进行复制操作，并没有限制了不能使用复制)，但是某些场景下使用复制会更快，这时候就需要进行衡量了。
{{&lt; /admonition &gt;}}

#### Virtual Destructors

- cppreference: [Destructors](https://en.cppreference.com/w/cpp/language/destructor) - **Virtual destructors**

&gt; Deleting an object through pointer to base invokes **undefined behavior** unless the destructor in the base class is virtual.

&gt; A common guideline is that a destructor for a base class must be either **public and virtual** or protected and nonvirtual.

虚析构函数 (Virtual Destructors) 与普通的虚函数不太一样，它的意义不是覆写 (override) 虚构函数，而是加上一个析构函数 (一般是加上具体派生类型的析构函数)。如果不使用 `vittual` 进行修饰，会导致内存泄漏，因为基类的析构函数只释放了基类的拥有的数据成员，并没有释放派生类的拥有的数据成员。

```c&#43;&#43;
#include &lt;iostream&gt;

class Base
{
public:
    Base() { std::cout &lt;&lt; &#34;Base Constructor\n&#34;; }
    virtual ~Base() { std::cout &lt;&lt; &#34;Base Destructor\n&#34;; }
};

class Derived : public Base
{
public:
    Derived() { m_Array = new int[5]; std::cout &lt;&lt; &#34;Derived Constructor\n&#34;; }
    ~Derived() { delete[] m_Array; std::cout &lt;&lt; &#34;Derived Destructor\n&#34;; }
private:
    int* m_Array;
};

int main()
{
    Base* base = new Base();
    // Base Constructor
    delete base;
    // Base Destructor

    std::cout &lt;&lt; &#34;--------------------\n&#34;;

    Derived* derived = new Derived();
    // Base Constructor
    // Derived Constructor
    delete derived;
    // Derived Destructor
    // Base Destructor

    std::cout &lt;&lt; &#34;--------------------\n&#34;;

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

&gt; Inheritance is when a &#39;class&#39; derives from an existing &#39;class&#39;.
&gt; 
&gt; Polymorphism deals with how the program decides which methods it should use, depending on what type of thing it has.

- cppreference: [Derived classes](https://en.cppreference.com/w/cpp/language/derived_class)

&gt; Any class type (whether declared with class-key class or struct) may be declared as derived from one or more base classes which, in turn, may be derived from their own base classes, forming an inheritance hierarchy.

C&#43;&#43; 中的继承 (Inheritance) 是 **数据** 和 **行为** 都会被继承 (而 Rust 中的 Trait 只会继承行为)

&gt; When a class uses public member access specifier to derive from a base, all public members of the base class are accessible as public members of the derived class and all protected members of the base class are accessible as protected members of the derived class (private members of the base are never accessible unless friended).

```c&#43;&#43;
class Entity
{
public:
    float X, Y;
    void Move(float xa, float ya)
    {
        X &#43;= xa;
        Y &#43;= ya;
    }
};

// Class Player is subclass of Class Entity
class Player : public Entity
{
public:
    const char* Name;
    void PrintName()
    {
        std::cout &lt;&lt; Name &lt;&lt; std::endl;
    }
};

int main() {
    std::cout &lt;&lt; sizeof(Entity) &lt;&lt; std::endl; // output 8 which equal 2 * sizeof(float)
    std::cout &lt;&lt; sizeof(Player) &lt;&lt; std::endl; // output 12 which equal 8 &#43; sizeof(char*)
}
```

#### Virtual Function

- cppreference: [virtual function specifier](https://en.cppreference.com/w/cpp/language/virtual)

&gt; Virtual functions are member functions whose behavior can be overridden in derived classes. As opposed to non-virtual functions, the overriding behavior is preserved even if there is no compile-time information about the actual type of the class.

虚函数 (Virtual Function) 用于多态时提醒编译器对调用的函数进行动态查找，以调用最符合实例类型的同名函数 (这个过程可能会有一些性能损耗，因为编译器需要查表来确定最终调用的函数)

```c&#43;&#43;
class Entity
{
public:
    virtual std::string GetName() { return &#34;Entity&#34;; }
};

class Player
{
private:
    std::string Name;
public:
    std::string GetName() override /* &#39;override&#39; is optional */ { return Name; }
};

int main()
{
    Entity* e = new Entity();
    std::cout &lt;&lt; e-&gt;GetName() &lt;&lt; std::endl;         // should output &#34;Entity&#34;

    Player* p = new Player(&#34;Player&#34;);
    std::cout &lt;&lt; p-&gt;GetName() &lt;&lt; std::endl;         // should output &#34;Player&#34;

    Entity* entity = p;
    std::cout &lt;&lt; entity-&gt;GetName() &lt;&lt; std::endl;    // should output &#34;Player&#34;
}
```

有时候我们不需要提供一个默认的实现，而只是提供一个行为给子类型 (subclass) 实现，这时候可以使用 `virtual` 修饰得到纯虚函数 (pure virtual function)，类似于 Java 中的接口 (interface)

下面实作一个类似于 Rust 的 Trait `Display` 的接口类 `Printable` :

```c&#43;&#43;
class Printable
{
public:
    virtual std::string GetClassName() = 0; // pure virtual function
};

class Entity : public Printable
{
public:
    virtual std::string GetName() override { return &#34;Entity&#34;; }
};

class Player : public Entity
{
private:
    std::string Name;
public:
    std::string GetName() override { return Name; }
    std::string GetClassName() override { return &#34;Player&#34;; }
};
```

### Objects

将对象 Object 分配在栈 Stack 上的方式:

```c&#43;&#43;
using String = std::string;

// call `Entity()` which is default constructor and allocated in stack
Entity entity; 
// equals
Entity entity = Entity();
// or just
Entity entity();

// call `Entity(const String&amp; name)` and allocated in stack
Entity entity = Entity(&#34;Hello&#34;); 
// or you can just
Entity entity(&#34;Hello&#34;);
```

将对象 Object 分配在堆 heap 上的方式:

```c&#43;&#43;
using String = std::string;

// call `Entity()` which is default constructor and allocated in heap
Entity* entity = new Entity; 
// equals
Entity* entity = new Entity();

// call `Entity(const String&amp; name)` and allocated in heap
Entity* entity = new Entity(&#34;Hello&#34;); 
```

- cppreference: [new expression](https://en.cppreference.com/w/cpp/language/new)
- cppreference: [operator new, operator new[]](https://en.cppreference.com/w/cpp/memory/new/operator_new)
- cppreference: [delete expression](https://en.cppreference.com/w/cpp/language/delete)
- cppreference: [operator delete, operator delete[]](https://en.cppreference.com/w/cpp/memory/new/operator_delete)

#### this

- cppreference: [The this pointer](https://en.cppreference.com/w/cpp/language/this)

&gt; The expression `this` is a prvalue expression whose value is the address of the implicit object parameter (object on which the non-static member function(until C&#43;&#43;23)implicit object member function(since C&#43;&#43;23) is being called).

`this` 本质上是 `Type* const` 的指针类型，使用引用 (Reference) 时需要注意这一点。另外，在 `const` 修饰的方法中，`this` 会进一步表示为 `const Type* const` 的指针类型

```c&#43;&#43;
class Entity
{
public:
    int x, y;
    Entity(int x, int y)
    {
        Entity* const&amp; e = this; // Pass
        Entity*&amp; e = this;       // Error
        this-&gt;x = x;
        this-&gt;y = y;
    }

    int GetX() const
    {
        const Entity* const&amp; e = this; // Pass
        Entity* const&amp; e = this;       // Error
        return this-&gt;x;
    }
};
```

## Specifiers

### Static

#### Static vs. Extern

- cppreference: [C&#43;&#43; keyword: static](https://en.cppreference.com/w/cpp/keyword/static)

&gt; **Usage**
&gt; - declarations of namespace members with static storage duration and internal linkage
&gt; - definitions of block scope variables with static storage duration and initialized once
&gt; - declarations of class members not bound to specific instances

```c&#43;&#43;
// Main.cpp
int s_Variable = 10;
void Func() {}

// Static.cpp
static int s_Varibale = 5;
static void Func() {}
```

这样不会因为存在两个同名变量、函数而导致编译失败，因为我们使用 `static` 限制了 Static.cpp 文件的同名变量和函数为内部链接 (注意这这些同名变量和函数均是独立的，即它们所在的内存地址均是不同的)

也可以使用外部链接关键字 `extern` 来通过编译:

- cppreference: [C&#43;&#43; keyword: extern](https://en.cppreference.com/w/cpp/keyword/extern)

&gt; **Usage**
&gt; - static storage duration with external linkage specifier
&gt; - language linkage specification

```c&#43;&#43;
// Main.cpp
extern int s_Variable;
void Func();

// Static.cpp
int s_Varibale = 5;
void Func() {}
```

这样也会编译通过，注意这个实作和之前的实作不同之处在于: Main.cpp 所指向的 `s_Variable` 正是 Static.cpp 文件的同名变量，即这两个东西是相同的，位于同一内存地址处。类似的，这两个文件的同名函数所在的内存地址也是相同的

{{&lt; admonition &gt;}}
尽量不要使用全局变量 (Global Variable) 除非你有必要的理由，一般情况下应当使用 `static` 修饰位于文件作用域的变量 (即变量所在的作用域和函数相同)，使其仅在当前的 Transilation Unit 进行内部链接
{{&lt; /admonition &gt;}}

#### Local Static

- cppreference: [static members](https://en.cppreference.com/w/cpp/language/static)

&gt; Inside a class definition, the keyword static declares members that are not bound to class instances.

在 Class 或 Struct 内使用 `static`，其作用是将被 `static` 修饰的变量或函数被该 Class 或 Struct 所共享，需要注意的是 `static` 修饰的函数不能使用与 Class 或 Struct 的具体实例相关的数据，例如可以使用 `static` 被修饰的变量

```c&#43;&#43;
class Entry
{
    static int x, y;
    
    static Print()
    {
        std::cout &lt;&lt; x &lt;&lt; &#34;, &#34; &lt;&lt; y &lt;&lt; std::endl;
    }
};

int Entry::x;
int Entry::y;
```

局部作用域使用 `static` 修饰变量，例如在函数内部或类内部声明 `static` 修饰的变量，这类变量被称为 Local Static。它的生命周期和程序运行时期相同，但它的作用范围被限制在声明所处的作用域内:

```c&#43;&#43;
#include &lt;iostream&gt;

void Function()
{
    static int i = 0;
    i&#43;&#43;;
    std::cout &lt;&lt; i &lt;&lt; std::endl;
}

int main()
{
    Function(); // should print 1
    Function(); // should print 2
    Function(); // should print 3
}
```

**实作案例**: 单例设计模式的单例类 `Singleton`

```c&#43;&#43;
class Singleton
{
private:
    static Singleton* s_Instance;
public:
    static Singleton&amp; Get() { return *s_Instance; }
    
    void Hello() {}
};
Singleton* Singleton::s_Instance = nullptr; // or `new Singleton`
// or
class Singleton
{
public:
    static Singleton&amp; Get() 
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

- cppreference: [C&#43;&#43; keyword: const](https://en.cppreference.com/w/cpp/keyword/const)

C&#43;&#43; 中的 `const` 关键字只是一种弱承诺，可以通过解引用来绕开 (不过这也取决于编译器，有些编译器会把 `const` 修饰的数据设置为只读，这样即使可以绕开但会执行时造成程序崩溃):

```c&#43;&#43;
int main()
{
    const int MAX_CONST = 100;
    int* a = (int*)&amp;MAX_CONST;
    *a = 90;
}
```

`const` 修饰指针:

```c&#43;&#43;
const int* a = new int; // can&#39;t modify `*a` (data be pointed to)
int* const a = new int; // can&#39;t modify `a`  (pointer itself)
const int* const a = new int; // can&#39;t modify both `*a` and `a`

// return a pointer which both pointer itself and data pointed are read-only
const int* const get_ptr() {}
```

在 Class 或 Struct 中使用 `const` 关键字，在方法名的右边添加 `const` 表示该方法不能修改 Class 或 Struct 的成员，只能读取数据，即调用这个方法不会改变 Class 或 Struct 的成员数据 (类似于 Rust 的 `&amp;self` 参数的限制)

```c&#43;&#43;
class Entity
{
private:
    int m_X, m_Y;
public:
    int GetX() const // Rust: fn get_x(&amp;self) -&gt; i32 {
    {
        return m_X;
    }

    void SetX(int x) // Rust: fn set_x(&amp;mut self, x: i32) {
    {
        m_X = x;
    }
};
```

函数参数的 `const` 修饰的引用，其作用和使用两个 `const` 修饰的指针相同。原理很简单，引用被限制了不能改变所引用的对象，等价于 `type* const` 的指针类型，所以只需再限制不能修改所引用的对象即可:

```c&#43;&#43;
void func(const Entity&amp; e) {}
// equals
void func(const Entity* const e) {}
```

这种参数需要配合之前所提的 `const` 修饰的方法来使用，类似于 Rust 的 `&amp;self` 参数的方法的使用限制

```c&#43;&#43;
int main()
{
    const Entity e;
    e.GetX();
}
```

### Mutable

- cppreference: [C&#43;&#43; keyword: mutable](https://en.cppreference.com/w/cpp/keyword/mutable)

在 Class 或 Struct 的 `const` 修饰的方法中使用，使得该方法能修改被 `mutable` 的成员变量

- [cv (`const` and `volatile`) type qualifiers](https://en.cppreference.com/w/cpp/language/cv)
&gt; mutable - permits modification of the class member declared mutable even if the containing object is declared const (i.e., the class member is mutable).

```c&#43;&#43;
class Entity
{
private:
    int m_X, m_Y;
    mutable int count = 0;
public:
    int GetX() const
    {
        count&#43;&#43;;
        return m_X;
    }
};`
```

也可以在 lambda 表达式中使用 `mutable` 进行修饰，但一般比较少 (因为实践中不太可能出现)

- cppreference: [Lambda expressions (since C&#43;&#43;11)](https://en.cppreference.com/w/cpp/language/lambda)

&gt; Allows body to modify the objects captured by copy, and to call their non-const member functions.
&gt; Cannot be used if an explicit object parameter is present.(since C&#43;&#43;23)

```c&#43;&#43;
auto f = [=]() mutable
{
    x&#43;&#43;;
    ...
}
// equals
auto f = [=]()
{
    int y = x;
    y&#43;&#43;;
    ...
}
```

### Explicit

隐式转换一般不建议用，因为表达不够清晰，会造成误解，特别是用在构造函数 Constructor 上，例如下面是完全合法的 C&#43;&#43; 代码:

```c&#43;&#43;
#include &lt;iostream&gt;
class Entity
{
public:
    Entity(int age) {}
    Entity(std::string name) {}
};

int main()
{
    Entity entity = &#34;hello&#34;; // Pass! call `Entity(int age)`
    Entity entity = 22;      // Pass! call `Entity(std::string name)`
}
```

可以使用 `explicit` 关键字来禁止构造函数的这种隐式转换规则:

- cppreference: [explicit specifier](https://en.cppreference.com/w/cpp/language/explicit)

&gt; Specifies that a constructor or conversion function(since C&#43;&#43;11)or deduction guide(since C&#43;&#43;17) is explicit, that is, it cannot be used for implicit conversions and copy-initialization.

```c&#43;&#43;
#include &lt;iostream&gt;
class Entity
{
public:
    explicit Entity(int age) {}
    explicit Entity(std::string name) {}
};

int main()
{
    Entity entity = &#34;hello&#34;; // Error! Now it is not allowed
    Entity entity = 22;      // Error! Now it is not allowed
}
```

### Auto

- cppreference: [Placeholder type specifiers (since C&#43;&#43;11)](https://en.cppreference.com/w/cpp/language/auto)

在函数 API 返回场景处使用，这样就不需要因为 API 改变而手动修改返回值的类型标注:

```c&#43;&#43;
const char* GetName() { return &#34;Hello&#34;; }
// or
std::string GetName() { return &#34;Hello&#34;; }

int main()
{
    auto name = GetName();
}
```

但这是一把双刃剑，这也会导致虽然 API 改变了但仍然构建成功，但 API 改变可能破坏了代码导致项目运行时的奇怪行为 (冷笑话: Linux kernel 表示对这样的 C&#43;&#43; 代码进行 Code Review 实在是...)

比较适合 `auto` 使用的场景：使用迭代器循环遍历，迭代器的类型比较复杂，但我们并不关心迭代器的类型，只需要知道它是个迭代器即可:

```c&#43;&#43;
std::vector&lt;std::string&gt; strings;

for (std::vector&lt;std::string&gt;::iterator it = strings.begin();
    it != strings.end(); it&#43;&#43;)
{
    std::cout &lt;&lt; *it &lt;&lt; std::endl;
}
// more readable
for (auto it = strings.begin(); it != strings.end(); it&#43;&#43;)
{
    std::cout &lt;&lt; *it &lt;&lt; std::endl;
}
```

类型名很长时也是 `auto` 的另一个比较好的应用场景:

```c&#43;&#43;
#include &lt;vector&gt;
#include &lt;string&gt;
#include &lt;unordered_map&gt;

class DeviceManager
{
private:
    std::unordered_map&lt;std::string, std::vector&lt;Device*&gt;&gt; m_Devices;
public:
    const std::unordered_map&lt;std::string, std::vector&lt;Device*&gt;&gt;&amp; GetDevices() const
    {
        return m_Devices;
    }
};

int mainn()
{
    DeviceManager dm;
    const auto&amp; devices = dm.GetDevices();
    // -&gt; const std::unordered_map&lt;std::string, std::vector&lt;Device*&gt;&gt;&amp; devices = dm.GetDevices();
}
```

**注意 `auto` 并不会推导出引用 `&amp;`，所以需要手动标注**，否则会导致复制行为产生一个新的局部变量。例如上面的例子如果没有标注 `&amp;`，那么会等价于:

```c&#43;&#43;
auto devices = dm.GetDevices();
// -&gt; const std::unordered_map&lt;std::string, std::vector&lt;Device*&gt;&gt; devices = dm.GetDevices();
```

除了上面说明的两种应用场景之外，不建议在其它地方滥用 `auto`，这会导致代码可读写变差，还可能会导致不必要的复制行为造成性能开销。尽量不要让自己的代码变成不得不使用 `auto` 的复杂程度！

函数返回类型的 `auto` 推导:

```c&#43;&#43;
auto GetName() -&gt; const char* {}
auto main() -&gt; int {}
```

## Operators

### Ternary Operators

C&#43;&#43; 中的 `?` 和 `:` 搭配的三元运算符存在的本质原因是，C&#43;&#43; 中的 if-else 控制流是语句 (statement) 而不是表达式 (expression)，所以需要功能类似于 if-else 的三元运算表达式来增强语言的表达能力 (否则表达会十分冗余，还会有额外开销，因为没有返回值优化，会产生中间临时数据)，如果是 Rust 这样的表达式为主的语言，就不需要这种三元运算符了

```c&#43;&#43;
int level/* = somthing */;
// ternary operator
std::string speed = level &gt; 5 ? 10 : 5;
// if-else
std::string speed;
if (level &gt; 5)
    speed = 10;
else
    speed = 5;
```

```rs
let level: i32/* = somthing*/;
let speed: i32 = if level &gt; 5 {
    10
} else {
    5
};
```

### Arrow Operator

可以通过 `-&gt;` 运算符来计算某个 Class / Struct 对象的成员的偏移值:

```c&#43;&#43;
#include &lt;iostream&gt;

struct Vector3
{
    float x, y, z;
};

int main()
{
    int offset = (int)&amp;((Vector3*)nullptr)-&gt;y;
    std::cout &lt;&lt; offset &lt;&lt; std::endl; // should be 4
}
```

这种技巧在工程上也很常用，最为著名的即为 Linux 核心的 `container_of` 宏:

- Stack Overflow: [Understanding container_of macro in the Linux kernel](https://stackoverflow.com/questions/15832301/understanding-container-of-macro-in-the-linux-kernel)

### Overloading

- cppreference: [operator overloading](https://en.cppreference.com/w/cpp/language/operators)

```c&#43;&#43;
struct Vector2
{
    float x, y;

    Vector2(float x, float y)
        : x(x), y(y) {}

    Vector2 Add(const Vector2&amp; other) const
    {
        return Vector2(x &#43; other.x, y &#43; other.y);
    }

    Vector2 operator&#43;(const Vector2&amp; other) const
    {   // overload `&#43;` of `Vector2 &#43; Vector2`
        return Add(other);
    }

    Vector2 Multiply(const Vector2&amp; other) const
    {
        return Vector2(x * other.x, y * other.y);
    }

    Vector2 operator*(const Vector2&amp; other) const
    {   // overload `*` of `Vector2 * Vector2`
        return Multiply(other);
    }

    bool operator==(const Vector2&amp; other) const
    {
        return x == other.x &amp;&amp; y == other.y;
    }

    bool operator!=(const Vector2&amp; other) const
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
    Vector2 result2 = position &#43; speed * powerup;

    if (result1 == result2) {}
}
```

运算符重载 (Operators Overloading) 不一定应用于类的方法，也可以用于函数 (其实运算符重载的语义为，重载表达式 `函数第一个参数 运算符 函数第二个参数` 的语义，而在方法中 `this` 作为第一个参数存在)

```c&#43;&#43;
std::ostream&amp; operator&lt;&lt;(std::ostream&amp; stream, const Vector2&amp; other)
{
    stream &lt;&lt; other.x &lt;&lt; &#34;, &#34; &lt;&lt; other.y;
    return stream;
}
```

运算符 `&lt;&lt;` 的重载语义会返回 `std::ostream` 对象，这样可以保证 `&lt;&lt;` 运算符的链式调用

{{&lt; admonition &gt;}}
运算符重载 (Operators Overloading) 只能重载运算符的执行语义，但运算符的优先级是不变的。这很因为运算符的优先级是编译器在进行语法分析时进行处理的，显然不能进行重载 (除非你重写了编译器 :rofl:)

Copy Constructor vs. `=` operator overloading:

- Stack Overflow: [The copy constructor and assignment operator](https://stackoverflow.com/questions/5368258/the-copy-constructor-and-assignment-operator)

```c&#43;&#43;
Entity a, b;
Entity e = a;   // Copy Constructor
e = c;          // `=` operator overloading
```
{{&lt; /admonition &gt;}}

## Templates and Containers

### Templates

{{&lt; admonition tip &gt;}}
模板和宏类似，它允许你定义一个可以根据你的用途进行编译的蓝图。简单来说，所谓模拟，就是 **让编译器基于你给它的规则为你写代码**。
{{&lt; /admonition &gt;}}

- cppreference: [Templates](https://en.cppreference.com/w/cpp/language/templates)
- cppreference: [Template parameters and template arguments](https://en.cppreference.com/w/cpp/language/template_parameters)

```c&#43;&#43;
#include &lt;iostream&gt;

template&lt;typename T&gt;
void Print(T value)
{
    std::cout &lt;&lt; value &lt;&lt; std::endl;
}

int main()
{
    Print(5); // or `Print&lt;int&gt;(5)`
    Print(&#34;Hello&#34;);
    Print(5.5f);
}
```

MSVC 不会对未使用的模板进行报错，但其他编译器可能会 (例如 clang)

Template non-type arguments 可在模板指定类型处指定常量作为编译规则:

```c&#43;&#43;
#include &lt;iostream&gt;

template&lt;int N&gt;
class Array 
{
private:
    int m_Array[N];
public:
    int GetSize() const { return N; }
};

int main()
{
    Array&lt;5&gt; array;
    std::cout &lt;&lt; array.GetSize() &lt;&lt; std::endl; // should be 5
}
```

进一步将类型指定规则和常量指定规则结合起来，实作一个泛型的栈分配的 `Array` (类似于标准库的 `std::array`):

```c&#43;&#43;
#include &lt;iostream&gt;

template&lt;typename T, int N&gt;
class Array 
{
private:
    T m_Array[N];
public:
    int GetSize() const { return N; }
};

int main()
{
    Array&lt;int, 5&gt; array;
    std::cout &lt;&lt; array.GetSize() &lt;&lt; std::endl; // should be 5
}
```

### Containers

#### Array

##### array

- cppreference: [Array declaration](https://en.cppreference.com/w/cpp/language/array)

```c&#43;&#43;
int main()
{
    // Array and Pointer are mostly same thing
    int example[5];
    int* ptr = example;
    for (int i = 0; i &lt; 5; i&#43;&#43;)
    {
        example[i] = 2;
    }                               // [2, 2, 2, 2, 2]
    example[2] = 5;                 // [2, 2, 5, 2, 2]
    *(int*)((char*)ptr &#43; 8) = 6;    // [2, 2, 6, 2, 2]
}
```

```c&#43;&#43;
int main()
{
    // Allocate array in stack
    int example[5];
    for (int i = 0; i &lt; 5; i&#43;&#43;)
        example[i] = 2;

    // Allocate array in heap
    int* another = new int[5];
    for (int i = 0; i &lt; 5; i&#43;&#43;)
        another[i] = 3;
    delete[] another;
}
```

C&#43;&#43; 支持可变长的数组，但是其长度必须在运行时明确，否则会导致未定义行为:

```c&#43;&#43;
#include &lt;iostream&gt;
int main()
{
    std::cin &lt;&lt; n;
    int a[n];
}
```

```c&#43;&#43;
#include &lt;iostream&gt;
int main()
{
    int a[n];
    std::cin &lt;&lt; n;
    // UB!
}
```

##### std::array

- cppreference: [std::array](https://en.cppreference.com/w/cpp/container/array)

&gt; `std::array` is a container that encapsulates fixed size arrays.

&gt; This container is an aggregate type with the same semantics as a struct holding a C-style array `T[N]` as its only non-static data member. Unlike a C-style array, it doesn&#39;t decay to `T*` automatically.

&gt; The struct combines the performance and accessibility of a C-style array with the benefits of a standard container, such as knowing its own size, supporting assignment, random access iterators, etc.

`std::array` 和普通数组一样，都是分配在栈 (Stack) 上的，与 `std::vector` 这种底层数据存储分配在堆 (Heap) 上的数据结构不同，所以 `std::array` 的性能比 `std::vector` 表现要好，实际上在编译器最佳化的条件下，它的性能表现和普通数组一样好。另外，与普通数组相比，`std::array` 拥有边界检查，更加安全。在存储空间方面，`std::array` 占用的空间与普通数组并无区别，因为它实际上并不存储 `size` 这个变量 (因为这个是通过常量模板规则传递的，并不占据空间，而是直接生成了对应的代码)。

```c&#43;&#43;
#include &lt;array&gt;

int main()
{
    // old style
    int data_old[5];
    data_old[0] = 1;

    // new style
    std::array&lt;int, 5&gt; data;
    data[0] = 1;
}
```

`std::array` 在作为函数参数时可知数组的长度 (因为 `std::array` 是一个类)，这一点比起普通数组是优势 (普通数组作为函数参数时会退化为指针，使用 `sizeof` 无法获得正确的数组长度):

```c&#43;&#43;
template&lt;std::size_t N&gt;
void PrintArray(std::array&lt;int, N&gt;&amp; data)
{
    for (int i = 0; i &lt; data.size(); i&#43;&#43;) {}
}
```

使用常量模板规则生成对应的 `PrintArray` 函数

- Stack Overflow: [Passing a std::array of unknown size to a function](https://stackoverflow.com/questions/17156282/passing-a-stdarray-of-unknown-size-to-a-function)
- Stack Overflow: [Difference between size_t and std::size_t](https://stackoverflow.com/questions/5813700/difference-between-size-t-and-stdsize-t)

{{&lt; admonition question &#34;为什么 `std::array` 不需要存储 `size` 变量？&#34; false &gt;}}
这是因为常量模板规则，在编译时期即可确定 `size()` 函数的具体实现了，无需额外存储变量:

```c&#43;&#43;
std::array&lt;int, 5&gt; arr;
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
{{&lt; /admonition &gt;}}

##### Multidimensional Arrays

```c&#43;&#43;
int main()
{
    // 1 Dimension
    int* array = new int[50];

    // 2 Dimension
    int** a2d = new int*[50];
    for (int i = 0; i &lt; 50; i&#43;&#43;)
        a2d[i] = new int[50];

    a2d[0][0] = 0; // a2d[0] -&gt; int*, a2d[0][0] -&gt; int
    a2d[0][1] = 1;
    a2d[0][2] = 2;

    for (int i = 0; i &lt; 50; i&#43;&#43;)
        delete[] a2d[i];
    delete[] a2d;

    // 3 Dimension, it&#39;s too complex!
    int*** a3d = new int**[50];
    for (int i = 0; i &lt; 50; i&#43;&#43;)
    {
        a3d[i] = new int*[50];
        for (int j = 0; j &lt; 50; j&#43;&#43;)
            a3d[i][j] = new int[50];
    }
}
```

- Stack Overflow: [C&#43;&#43; multidimensional array on heap](https://stackoverflow.com/questions/72018905/c-multidimensional-array-on-heap)

上面这种形式的多维数组会极大可能导致 cache miss，进而导致性能表现不如等价的一维数组。下面是二维数组和等价的一维数组在顺序读取时的性能表现对比:

```c&#43;&#43;
int main()
{
    // slower
    int** a2d = new int*[5];
    for (int i = 0; i &lt; 5; i&#43;&#43;)
        a2d[i] = new int[5];

    for (int i = 0; i &lt; 5; i&#43;&#43;)
        for (int j = 0; j &lt; 5; i&#43;&#43;)
            a2d[i][j] = 2;
    
    // faster
    int* array = new int[5 * 5];
    for (int i = 0; i &lt; 5; i&#43;&#43;)
        for (int j = 0; j &lt; 5; i&#43;&#43;)
            a2d[i &#43; 5*j] = 1;
}
```

尽量避免使用二维数组 (以及二维以上维度)，推荐将其转换为等价的一维数组，利用 cache 的特性增强性能。

#### String

- cppreference: [std::basic_string](https://en.cppreference.com/w/cpp/string/basic_string)
- [ASCII Table](https://www.ascii-code.com/)
- cppreference: [std::basic_string&lt;CharT,Traits,Allocator&gt;::npos](https://en.cppreference.com/w/cpp/string/basic_string/npos)

```c&#43;&#43;
int main()
{
    // C style
    const char* hello = &#34;Hello&#34;;
    hello[2] = &#39;a&#39;; // error! since it was allocated at text section

    char word[6] = { &#39;w&#39;, &#39;o&#39;, &#39;r&#39;, &#39;l&#39;, &#39;d&#39;, &#39;\0&#39; /* or 0 */ };
    // or
    char word[6] = &#34;world&#34;;
    world[2] = &#39;a&#39;; // pass! since it was allocated at stack
}
```

```c&#43;&#43;
#include &lt;string&gt;

int main()
{
    // C&#43;&#43; style
    std::string hello = &#34;Hello&#34;;
    hello[2] = &#39;a&#39;;
    hello &#43;= &#34;, world&#34;;

    // or
    std::string hello = std::string(&#34;Hello&#34;) &#43; &#34;, world&#34;;
    bool contains = hello.find(&#34;lo&#34;) != std::string::nops;
}
```

{{&lt; admonition &gt;}}
经验法则: 如果你没使用 `new` 关键字来获取对象，那么就不要使用 `delete` 关键字来删除它

VS 在调试模式下进行编译，会对内存分配的对象额外分配 **内存守卫者**，以方便提醒开发者内存访问是否越界

`std::string` 在函数参数中使用时，需要特别考虑是否应该使用引用 `&amp;` 操作，以避免无效的拷贝开销
{{&lt; /admonition &gt;}}

##### Char Types

- cppreference: [Fundamental types](https://en.cppreference.com/w/cpp/language/types)
- cppreference: [C&#43;&#43; keyword: wchar_t](https://en.cppreference.com/w/cpp/keyword/wchar_t)
- cppreference: [C&#43;&#43; keyword: char16_t (since C&#43;&#43;11)](https://en.cppreference.com/w/cpp/keyword/char16_t) / [char16_t](https://en.cppreference.com/w/c/string/multibyte/char16_t)
- cppreference: [C&#43;&#43; keyword: char32_t (since C&#43;&#43;11)](https://en.cppreference.com/w/cpp/keyword/char32_t) / [char32_t](https://en.cppreference.com/w/c/string/multibyte/char32_t)

```c&#43;&#43;
int main()
{
    const char* hello = u8&#34;Hello&#34;;      // &#39;u8&#39; represent utf-8, it&#39;s optional
    const wchar_t* hello = L&#34;Hello&#34;;    // &#39;L&#39; represent wide char
    const char16_t* hello = u&#34;Hello&#34;;   // &#39;u&#39; represent char16_t
    const char32_t* hello = U&#34;Hello&#34;;   // &#39;U&#39; represent char32_t
}
```

{{&lt; admonition &gt;}}
`char` 类型的具体字节数是由操作系统额 CPU 架构来决定的，如果需要跨系统使用固定字节数的字符类型，请按需使用 `wchar_t`, `char16_t` 和 `char32_t` 
{{&lt; /admonition &gt;}}

##### String Literals

- cppreference: [String literal](https://en.cppreference.com/w/cpp/language/string_literal)

&gt; Raw string literals are string literals with a prefix containing `R` (syntaxes (2,4,6,8,10)). They do not escape any character, which means anything between the delimiters `d-char-seq (` and `)d-char-seq` becomes part of the string. The terminating `d-char-seq` is the same sequence of characters as the initial `d-char-seq`.

- cppreference: [std::literals::string_literals::operator&#34;&#34;s](https://en.cppreference.com/w/cpp/string/basic_string/operator%22%22s)

```c&#43;&#43;
#include &lt;string&gt;
int main()
{
    std::string hello = &#34;Hello&#34;s &#43; &#34;, world&#34;;
    const char* raw = &#34;hello\nAp\tple&#34;;
}
```

##### String Stream

- cppreference: [std::basic_stringstream](https://en.cppreference.com/w/cpp/io/basic_stringstream)

stringstream is a stream class to operate on strings. It implements input/output operations on memory (string) based streams. stringstream can be helpful in different type of parsing. The following operators/functions are commonly used here

- Operator `&gt;&gt;` Extracts formatted data.
- Operator `&lt;&lt;` Inserts formatted data.
- Method `str()` Gets the contents of underlying string device object.
- Method `str(string)` Sets the contents of underlying string device object.

Its header file is **sstream**.

```c&#43;&#43;
stringstream ss(&#34;23,4,56&#34;);
char ch;
int a, b, c;
ss &gt;&gt; a &gt;&gt; ch &gt;&gt; b &gt;&gt; ch &gt;&gt; c;  // a = 23, b = 4, c = 56
```

#### Vector

- Stack Overflow: [Why is a C&#43;&#43; Vector called a Vector?](https://stackoverflow.com/questions/581426/why-is-a-c-vector-called-a-vector)

&gt; It&#39;s called a vector because Alex Stepanov, the designer of the Standard Template Library, was looking for a name to distinguish it from built-in arrays. He admits now that he made a mistake, because mathematics already uses the term &#39;vector&#39; for a fixed-length sequence of numbers. C&#43;&#43;11 compounds this mistake by introducing a class &#39;array&#39; that behaves similarly to a mathematical vector.

- cppreference: [std::vector](https://en.cppreference.com/w/cpp/container/vector)

```c&#43;&#43;
#include &lt;iostream&gt;

struct Vertex
{
    float x, y, z;
};

std::ostream&amp; operator&lt;&lt;(std::ostream&amp; stream. const Vertx&amp; vertex)
{
    stream &lt;&lt; vertex.x &lt;&lt; &#34;, &#34; &lt;&lt; vertex.y &lt;&lt; &#34;, &#34; &lt;&lt; vertex.z &lt;&lt; std::endl; 
    return stream;
}

void Function(const vector&lt;Vertex&gt;&amp; vertices)
{

}

int main()
{
    std::vector&lt;Vertex&gt; vertices;
    vertices.push_back({ 1, 2, 3 });
    vertices.push_back({ 4, 5, 6 });

    for (int i = 0; i &lt; vertices.size(); i&#43;&#43;)
        std::cout &lt;&lt; vertices[i] &lt;&lt; std::endl;
    // or
    for (const Vertex&amp; v : vertices)
        std::cout &lt;&lt; v &lt;&lt; std::endl;
    
    Function(vertices);

    vertices.erase(vertices.begin() &#43; 1);
}
```

C&#43;&#43; 的 vector 的 reomve 操作需要通 **迭代器** 来操作:

```c&#43;&#43;
// Removes the element present at position.  
v.erase(v.begin()&#43;4); // erases the fifth element of the vector v

// Removes the elements in the range from start to end inclusive of the start and exclusive of the end.
v.erase(v.begin()&#43;2,v.begin()&#43;5); // erases all the elements from the third element to the fifth element.
```

{{&lt; admonition &gt;}}
STL 的容器，它们在被设计时，速度不是优先考虑的因素，所以我们可以设计出比 STL 里的容器性能更强的类似容器，这也是为什么很多工作室会自己设计容器库而不采用 STL，例如 [Qt Container Classes](https://doc.qt.io/qt-6/containers.html)、[EASTL](https://github.com/electronicarts/EASTL)。
{{&lt; /admonition &gt;}}

##### Optimizing Usage

一般情况下，STL 的 `vector` 是比较慢的 (因为它倾向于经常分配内存空间，这会导致大量的性能开销)，所以我们需要通过一些策略来压榨出 `vector` 的全部性能。下面通过之前的例子来展示这些优化策略。

通过复制构造函数确认什么时候发生了大量的复制，以应用相应的复制优化策略:

```c&#43;&#43;
struct Vertex
{
    ...
    Vertex(float x, float y, float z)
        : x(x), y(y), z(z) {}
    Vertex(const Vertex&amp; other)
        : x(other.x), y(other.y), z(other.z)
    {
        std::cout &lt;&lt; &#34;Copied!&#34; &lt;&lt; std::endl;
    }
};
```

运行后发现之前的例子总共进行了 6 次复制

1. **优化复制**。预先分配内存，防止过多的内存分配和复制操作造成性能损耗。

```c&#43;&#43;
    std::vector&lt;Vertex&gt; vertices;
    vertices.resize(3); // pre-allocation
    vertices.push_back(Vertex(1, 2, 3));
    vertices.push_back(Vertex(4, 5, 6));
    vertices.push_back(Vertex(7, 8, 9));
```

现在减少为 3 次复制了

注意 `reserve` 方法和 `vector` 构造函数中指定元素数量这两者是不太一样的:

- [std::vector&lt;T,Allocator&gt;::reserve](https://en.cppreference.com/w/cpp/container/vector/reserve)
&gt; Increase the capacity of the vector (the total number of elements that the vector can hold without requiring reallocation) to a value that&#39;s greater or equal to `new_cap`.

- [std::vector&lt;T,Allocator&gt;::vector](https://en.cppreference.com/w/cpp/container/vector/vector)
&gt; 4\) Constructs the container with `count` default-inserted instances of `T`. No copies are made.

即构造函数指定元素数量会构造相应的默认实例，而 `reserve` 不会，所以 `reserve` 的性能开销更低。

2. **避免复制**。直接在 `vector` 合适的位置构造对象，而不是先在栈上构造再复制到 `vector` 里。

- [std::vector&lt;T,Allocator&gt;::emplace_back](https://en.cppreference.com/w/cpp/container/vector/emplace_back)
&gt; Appends a new element to the end of the container. ...  which typically uses placement-new to construct the element **in-place** at the location provided by the container. 

```c&#43;&#43;
    std::vector&lt;Vertex&gt; vertices;
    vertices.resize(3); // pre-allocation
    vertices.emplace_back(Vertex(1, 2, 3));
    vertices.emplace_back(Vertex(4, 5, 6));
    vertices.emplace_back(Vertex(7, 8, 9));
```

现在没有复制操作了

### Algorithms

- cppreference: [Algorithms library](https://en.cppreference.com/w/cpp/algorithm)

&gt; The algorithms library defines functions for a variety of purposes (e.g. searching, sorting, counting, manipulating) that operate on ranges of elements. Note that a range is defined as **[`first`, `last`)** where `last` refers to the element past the last element to inspect or modify.

#### Sorting

- cppreference: [std::sort](https://en.cppreference.com/w/cpp/algorithm/sort)

&gt; Sorts the elements in the range **[`first`, `last`)** in non-descending order. The order of equal elements is not guaranteed to be preserved.

&gt; **comp**	-	comparison function object (i.e. an object that satisfies the requirements of Compare) which returns `​true` if the first argument is less than (i.e. is ordered before) the second.

```c&#43;&#43;
#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;algorithm&gt;
#include &lt;functional&gt;

int main()
{
    std::vector&lt;int&gt; values = { 3, 5, 1, 4, 2 };
    std::sort(values.begin(), values.end()); // [1, 2, 3, 4, 5]
    std::sort(values.begin(), values.end(), std::greater&lt;int&gt;()); // [5, 4, 3, 2, 1]
    std::sort(values.begin(), values.end(), [](int a, int b) {
        return a &lt; b;
    }); // [1, 2, 3, 4, 5]
    std::sort(values.begin(), values.end(), [](int a, int b) {
        if (a == 1)
            return false;
        if (b == 1)
            return true;
        return a &lt; b;
    }); // [2, 3, 4, 5, 1]

    for (int value : values)
        std::cout &lt;&lt; value &lt;&lt; std::endl;
}
```

- Cppreference: [std::greater](https://en.cppreference.com/w/cpp/utility/functional/greater)

&gt; Function object for performing comparisons. The main template invokes operator&gt; on type T.

## Memory and Safety

### Stack, Heap and Lifetime

主要是理解 **栈 (Stack)** 和 **堆 (Heap)** 上分配的对象 (Object) 的生命周期 (Lifetime) 的机制，栈 (Stack) 上分配的对象 (Object) 的生命周期无需我们关系，超出作用域会自动销毁，这就是为什么它们被称为 **自动变量** 的原因，而堆 (Heap) 上的生命周期则需要我们手动进行管理，以决定什么时候销毁它们结束它们的生命周期，当然我们也可以使用其它程序员封装好的容器，这样手动管理这些对象的生命周期的责任就交给封装这个容器的程序员的 (但还是需要人手动管理 :rofl:)。简单来说，栈上的变量不需要人来关心 (编译器会帮我们完成)，而堆上的对象则需要人来管理 (不论是直接的还是间接的)。

{{&lt; admonition &gt;}}
Rust 的生命周期机制本质上就是让堆 (Heap) 分配的对象 (Object) 的生命周期也由编译器来管理，超出作用域就会销毁，无需人们操心手动管理，从某种意义上说，编写 Rust 代码时无需关心对象分配在栈上或堆上，只需知道分配在内存即可。
{{&lt; /admonition &gt;}}

这个机制可以通过 Construtor 和 Destructor 的调用，以及搭配调试器来观察:

```c&#43;&#43;
#include &lt;iostream&gt;
class Entity
{
public:
    Entity()  { std::cout &lt;&lt; &#34;Created Entity!&#34; &lt;&lt; std::endl; }
    ~Entity() { std::cout &lt;&lt; &#34;Destroyed Entity!&#34; &lt;&lt; std::endl; }
    void Print() const { std::cout &lt;&lt; &#34;Hello&#34; &lt;&lt; std::endl; }
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

我们可以利用自动变量和作用域的特性来设计类似 Rust 的生命周期机制 (实现了一个类似于 C&#43;&#43; 的 `unique_ptr` 的智能指针):

```c&#43;&#43;
class ScopedPtr
{
private:
    Entity* m_Ptr;
public:
    ScopedPtr(Entity* ptr) : m_Ptr(ptr) {}
    ~ScopedPtr() { delete m_Ptr; }
    Entity* operator-&gt;() { return m_Ptr; }
    const Entity* operator-&gt;() const { return m_Ptr; }
};

int main()
{
    {
        ScopedPtr e(new Entity);
        // or by implicit conversion
        ScopedPtr e = new Entity();
    }
    const ScopedPtr e = new Entity();
    e-&gt;Print();
}
```

智能指针一般都会重载 `-&gt;` 运算符，以使得智能指针使用起来和普通指针相同

- cppreference: [operator overloading](https://en.cppreference.com/w/cpp/language/operators)

&gt; The overload of operator `-&gt;` must either return a raw pointer, or return an object (by reference or by value) for which operator `-&gt;` is in turn overloaded.

按照这个描述，碰到 `-&gt;` 运算符时会不断调用相应的操作函数 (例如 `-&gt;` 的运算符重载函数)，直到 `-&gt;` 被推导到对应的类型 (符合 `-&gt;` 右边的操作数的类型要求)

{{&lt; admonition tip &gt;}}
这种自动变量和作用域特性在很多地方都可以用到，例如计时器，配合 Constructor 和 Destructor 可以实现对特定时间段 (该计时器存活的生命周期) 进行自动计时，实现逻辑为：调用构造函数时启动计时，调用析构函数时结束计时并记录或打印。

也可以用于互斥锁 (Mutex Lock)，在特定函数的起始处自动创建锁守卫 (Lock Guard)，在该函数的结束后自动销毁该锁守卫，这使得多线程执行时会有序执行该函数。
{{&lt; /admonition &gt;}}

### Smart Pointers

- cppreference: [std::unique_ptr](https://en.cppreference.com/w/cpp/memory/unique_ptr)

&gt; `std::unique_ptr` is a smart pointer that owns and manages another object through a pointer and disposes of that object when the `unique_ptr` goes out of scope.

`unique_ptr` 不能被复制，因为这样违反了它的所有权 (ownership) 机制，它只能被移动 (move) 即转移所有权

```c&#43;&#43;
#include &lt;memory&gt;
int main()
{
    std::unqiue_ptr&lt;Entity&gt; e(new Entity);
    // last may cause exception, thus recommend follow
    std::unique_ptr&lt;Entity&gt; e = std::make_unique&lt;Entity&gt;(); // call Entity()
    e-&gt;Print(); // unique_ptr has overloaded `-&gt;` operator
}
```

- cppreference: [std::shared_ptr](https://en.cppreference.com/w/cpp/memory/shared_ptr)

&gt; `std::shared_ptr` is a smart pointer that retains shared ownership of an object through a pointer. Several `shared_ptr` objects may own the same object. The object is destroyed and its memory deallocated when either of the following happens:
&gt; 
&gt; - the last remaining `shared_ptr` owning the object is destroyed;
&gt; - the last remaining `shared_ptr` owning the object is assigned another pointer via `operator=` or `reset()`.

底层机制是通过 **循环计数** ([Reference counting](https://en.wikipedia.org/wiki/Reference_counting)) 来实现的

类似的实作案例: Rust [std::rc::Rc](https://doc.rust-lang.org/std/rc/struct.Rc.html)

```c&#43;&#43;
#include &lt;memory&gt;
int main()
{
    std::shared_ptr&lt;Entity&gt; e;
    {
        std::shared_ptr&lt;Entity&gt; sharedEntity = std::make_shared&lt;Entity&gt;(); // call Entity()
        e = sharedEntity;
    }
}
```

- cppreference: [std::weak_ptr](https://en.cppreference.com/w/cpp/memory/weak_ptr)

&gt; `std::weak_ptr` is a smart pointer that holds a non-owning (&#34;weak&#34;) reference to an object that is managed by `std::shared_ptr`. It must be converted to `std::shared_ptr` in order to access the referenced object.

`weak_ptr` 对所指向的对象没有所有权，它是用于解决 **循环引用** 问题 (例如树状结构的亲代关系会导致循环引用)。

类似的实作案例: Rust [std::rc::Weak](https://doc.rust-lang.org/std/rc/struct.Weak.html)

```c&#43;&#43;
#include &lt;memory&gt;
int main()
{
    std::weak_ptr&lt;Entity&gt; e;
    {
        std::shared_ptr&lt;Entity&gt; sharedEntity = std::make_shared&lt;Entity&gt;(); // call Entity()
        e = sharedEntity;
    }
}
```

{{&lt; admonition tip &gt;}}
推荐使用 `std::make_XYZ` 这这种风格标准库函数来构造智能指针实例，这样你就可以在你的代码里永远摆脱 `new` 关键字了 :rofl: 
{{&lt; /admonition &gt;}}

### Safety

安全编程的目的主要是是降低崩溃、内存泄漏、非法访问的问题 (这一点 Rust 做的比较好，但也没有解决内存泄漏的问题)，从 C&#43;&#43;11 开始推荐使用智能指针而不是原始指针来解决内存泄漏的相关问题，这是因为基于 RAII 的自动内存管理系统。

如果是生产环境则使用智能指针，如果是学习则使用原始指针。当然，如果你需要定制的话，也可以使用自己写的智能指针。

## Benchmarking

Wikipedia: [Benchmark](https://en.wikipedia.org/wiki/Benchmark_(computing))

### Timing

- cppreference: [Date and time utilities](https://en.cppreference.com/w/cpp/chrono)
- cppreference: [Standard library header &lt;chrono&gt; (C&#43;&#43;11)](https://en.cppreference.com/w/cpp/header/chrono)

chrono 是一个平台无关的计时库，如果不是特定平台高精度的计时需求，使用这个库就足够了。

```c&#43;&#43;
#include &lt;iostream&gt;
#include &lt;thread&gt;
#include &lt;chrono&gt;

int main()
{
    using namespace std::literals::chrono_literals;

    auto start = std::chrono::high_resolution_clock::now();
    std::this_thread::sleep_for(1s);
    auto end = std::chrono::high_resolution_clock::now();

    std::chrono::duration&lt;float&gt; duration = end - start;
    std::cout &lt;&lt; duration &lt;&lt; &#34;s&#34; &lt;&lt; std::endl;
}
```

运用作用域、生命周期以及析构函数来实现自动计时:

```c&#43;&#43;
#include &lt;iostream&gt;
#include &lt;thread&gt;
#include &lt;chrono&gt;

struct Timer
{
    std::chrono::steady_clock::time_point start, end;
    std::chrono::duration&lt;float&gt; duration;

    Timer()
    {
        start = std::chrono::high_resolution_clock::now();
    }

    ~Timer()
    {
        end = std::chrono::high_resolution_clock::now();
        duration = end - start;

        float ms = duration.count() * 1000.0f;
        std::cout &lt;&lt; &#34;Timer took &#34; &lt;&lt; ms &lt;&lt; &#34;ms&#34; &lt;&lt; std::endl;
    }
};

void Function()
{
    Timer timer;

    for (int i = 0; i &lt; 100; i&#43;&#43;)
        std::cout &lt;&lt; &#34;Hello\n&#34; /* &lt;&lt; std::endl */;
}

int main()
{
    Function();
}
```



## Advanced Topics

### Multiple Return Values

在 C&#43;&#43; 中，实现函数可以返回多个值有很多种方式:

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

```c&#43;&#43;
#define WAIT std::cin.get()
```

&#34;专门从事编写迷惑性代码&#34;:

```c&#43;&#43;
#define OPEN_CURLY {
int main()
OPEN_CURLY
    return 0;
}
```

比较有意义的宏使用场景: Project 属性 -&gt; C/C&#43;&#43; -&gt; Preprocessor -&gt; Preprocessor Definitions: 添加自定义的宏 (作用有些类似于 gcc 的 `-D` 参数)

这样可以实现不同模式下日志系统的输出不相同，例如 Debug 模式下定义 `PR_DEBUG` 宏，Release 模式下定义 `PR_RELEASE` 宏。然后在日志系统针对这两个宏是否被定义进行不同的处理，以让日志系统针对不同模式进行不同处理。

```c&#43;&#43;
#ifdef PR_DEBUG
#define LOG(x) std::cout &lt;&lt; x &lt;&lt; std::endl;
#else
#define LOG(x)
#endif
```

`ifdef` 在很多情况下表现比较糟糕，使用 `if` 改写上面的代码 (搭配 `defined` 进行定义判定):

```c&#43;&#43;
#if PR_DEBUG == 1
#define LOG(x) std::cout &lt;&lt; x &lt;&lt; std::endl;
#else defined(PR_RELEASE)
#define LOG(x)
#endif
```

`#if 0` 可以用于删除特定代码 (本质上是条件编译)

可以通过 `\` 来编写多行的宏，但是注意不要在 `\` 后面多按了空格，这样会导致是对空格的转义，一点要确保 `\` 后面是换行，这才是对换行符的转义:

```c&#43;&#43;
#define MAIN int main() \
{ \
    std::cin.get(); \
}
```

{{&lt; admonition &gt;}}
宏常用于跟踪、调试，例如追踪内存分配 (e.g. 那哪一行、哪个函数分配了多少字节)、日志系统的输出
{{&lt; /admonition &gt;}}



### Type Punning

- Stack Overflow: [What is the modern, correct way to do type punning in C&#43;&#43;?](https://stackoverflow.com/questions/67636231/what-is-the-modern-correct-way-to-do-type-punning-in-c)

通过指针和引用直接操作内存来实现类型双关 (Type Punning)，可以搭配调试器的内存查看功能进行观察:

```c&#43;&#43;
int a = 50;
double value = *(double*)&amp;a;    // copy
double&amp; value = *(double*)&amp;a;   // in-place
```

```c&#43;&#43;
#include &lt;iostream&gt;
class Entity
{
    int x, y;
};
int main()
{
    Entity e = { 5, 8 };
    int* position = (int*)&amp;e;
    std::cout &lt;&lt; position[0] &lt;&lt; &#34;, &#34; &lt;&lt; position[1] &lt;&lt; std::endl; // [5, 8]
    int y = *(int*)((char*)&amp;e &#43; 4);
    std::cout &lt;&lt; y &lt;&lt; std::endl; // 8
}
```

上面的这些代码不建议使用，除非你是研究操作系统内核这类对内存操作精度极高的领域。

#### Union

下面使用 `union` 来实现类型双关 (Type Punning):

- cppreference: [Union declaration](https://en.cppreference.com/w/c/language/union)

&gt; Similar to struct, an unnamed member of a union whose type is a union without name is known as anonymous union. Every member of an anonymous union is considered to be a member of the enclosing struct or union keeping their union layout. This applies recursively if the enclosing struct or union is also anonymous.

```c&#43;&#43;
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
std::cout &lt;&lt; u.b &lt;&lt; std::endl;
```

```c&#43;&#43;
struct Vector2
{
    float x, y;
};
struct Vector4
{
    // By pointer and reference
    float x, y, z, w;

    Vector2&amp; GetA()
    {
        return *(Vector*)&amp;x;
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

    Vector2&amp; GetA()
    {
        return a;
    }
};
```

### Casting

{{&lt; link href=&#34;#explict&#34; content=&#34;Specifiers::Explict&#34; &gt;}} 处有讲解了一部分隐式转换和显式转换。{{&lt; link href=&#34;#union-and-type-punning&#34; content=&#34;Union and Type Punning&#34; &gt;}} 处也对类型转换进行了一定程度的讲解。下面对 C 风格和 C&#43;&#43; 风格的强制类型转换 (casting) 进行详细说明。

- cppreference: [Explicit type conversion](https://en.cppreference.com/w/cpp/language/explicit_cast)

```c&#43;&#43;
double value = 5.25;

// C style
double a = (int)value &#43; 5.3; // a == 10.3

// C&#43;&#43; style
double s = static_cast&lt;int&gt;(value) &#43; 5.3; // a == 10.3
```

所有 C&#43;&#43; 风格的强制类型转换都可以使用 C 风格的强制类型转换来实现。C&#43;&#43; 风格只是多了些语法糖，例如 `static_cast` 会在编译时期进行一些检查 (例如检查转换的类型是否合法，这在 Linux kernel 是常有的操作)，本质一样都是从一个类型转换成另一个类型。使用 C&#43;&#43; 风格的类型转换还有另一个好处，就是可以在代码库检索类型转换在哪发生，这样可以针对性的禁用某些类型转换以提高性能。

{{&lt; admonition quote &gt;}}
* cast 分为 `static_cast`, `dynamic_cast`, `reinterpret_cast`, `const_cast`
* [static_cast](https://en.cppreference.com/w/cpp/language/static_cast) 用于进行比较“自然”和低风险的转换，如整型和浮点型、字符型之间的互相转换，不能用于指针类型的强制转换，会在编译时进行检查
* [reinterpret_cast](https://en.cppreference.com/w/cpp/language/reinterpret_cast) 用于进行各种不同类型的指针之间强制转换
* [const_cast](https://en.cppreference.com/w/cpp/language/const_cast) 仅用于进行增加或去除 `const` 属性的转换
* [dynamic_cast](https://en.cppreference.com/w/cpp/language/dynamic_cast) 不检查转换安全性，仅运行时检查，如果不能转换，返回 null (常用于多态)
{{&lt; /admonition &gt;}}

- 以上整理自 [@ljnelf](https://space.bilibili.com/27560356) 的评论

#### Dynamic Casting

```c&#43;&#43;
```

### Namespaces

- cppreference: [Namespaces](https://en.cppreference.com/w/cpp/language/namespace)

&gt; Namespaces provide a method for preventing name conflicts in large projects.

Rust 中的 [Module](https://doc.rust-lang.org/book/ch07-02-defining-modules-to-control-scope-and-privacy.html) 也是类似的语法

类本身也是一个 namespace，所以使用类似的操作符 `::` 访问内部成员

#### Don&#39;t &#34;using namspace std&#34; 

不推荐使用 `using namespace std;` 类似的语句，使用 `std;:xxx` 这样的风格。因为现实中比较少用 STL，都是工作室自己开发类似 STL 的库来使用，这样可以区分代码中使用的是哪个库的 API。

实作案例: EASTL [vector.h](https://github.com/electronicarts/EASTL/blob/master/include/EASTL/vector.h#L77)

```c&#43;&#43;
vector&lt;int&gt; vec; // what about vector? std::vector or eastl::vector?
```

滥用 `using namespace xxx;` 也可能会造成 API 名字冲突，例如上面的例子如果同时使用了:

```c&#43;&#43;
using namespace std;
using namespace eastl;
```

会因为指定调用函数不明确而导致编译失败。这种会导致编译失败的情景还算比较好的了 (因为编译时期就报错了)，下面这种情景更是灾难性的:

```c&#43;&#43;
#include &lt;iostream&gt;
#include &lt;string&gt;

namespace apple {
    void Print(const std::string&amp; text)
    {
        std::cout &lt;&lt; text &lt;&lt; std::endl;
    }
}

namespace purple {
    void Print(const char* text)
    {
        std::string temp = text;
        std::reverse(temp.begin(), temp.end());
        std::cout &lt;&lt; temp &lt;&lt; std::endl;
    }
}

int main()
{
    using namespace apple;
    using namespace purple;
    Print(&#34;Hello&#34;); // we want to print &#34;Hello&#34; but print &#34;olleH&#34;
}
```

这段代码没有编译错误也没有警告，但是运行起来不符合预期，是灾难性的运行时错误。这是因为不同库不能保证相同 API 接口是互斥的，所以会导致如上这种情况，调用的 API 不如我们预期。

{{&lt; admonition tip &gt;}}
另外需要特别注意，千万不要在头文件中使用 `using namspace`！这会导致将 namespace 引入到不必要的地方，编译失败时很难追踪。

尽量在比较小的作用域中使用 `using namespace`，例如 `if` 语句的作用域，函数体内，这样使用是没问题的。最大作用域的使用场景就是一个单独的 cpp 文件中使用了，以控制 namespace 的扩散范围。

大项目尽量将函数、类等等定义在 namspace 内，防止出现 API 冲突。
{{&lt; /admonition &gt;}}

### Threads

- cppreference: [Concurrency support library (since C&#43;&#43;11)](https://en.cppreference.com/w/cpp/thread)
- cppreference: [std::thread](https://en.cppreference.com/w/cpp/thread/thread)

&gt; The class `thread` represents a single thread of execution. Threads allow multiple functions to execute concurrently.

```c&#43;&#43;
#include &lt;iostream&gt;
#include &lt;thread&gt;

static bool s_Finished = false;

void DoWork()
{
    using namespace std::literals::chrono_literals;

    std::cout &lt;&lt; &#34;Start thread id=&#34; &lt;&lt; std::this_thread::get_id() &lt;&lt; std::endl;

    while (!s_Finished)
    {
        std::cout &lt;&lt; &#34;Working...\n&#34;;
        std::this_thread::sleep_for(1s);
    }
}

int main()
{
    std::thread worker(DoWork);

    std::cin.get();
    s_Finished = true;

    worker.join();

    std::cout &lt;&lt; &#34;Finished.&#34; &lt;&lt; std::endl;
    std::cout &lt;&lt; &#34;Start thread id=&#34; &lt;&lt; std::this_thread::get_id() &lt;&lt; std::endl;
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
- C/C&#43;&#43; -&gt; Additional Include Directoris
    - `$(SolutionDir)\Dependencies\GLFW\include`
    - `$(SolutionDir)\Dependencies\GLEW\include`
    - `$(ProjectDir)\imgui` 或者新建一个 Project 并将其作为静态库
- Linker -&gt; Additional Library Directories
    - `glfw3.lib`
    - `glew32s.lib`
    - `Opengl32.lib`: 这个库是计算机自带的

```c&#43;&#43;
// must keep this import order!
#include &#34;GL/glew.h&#34;
#include &#34;GLFW/glfw3.h&#34;

#include &#34;imgui.h&#34;
#include &#34;imgui_impl_glfw.h&#34;
#include &#34;imgui_impl_opengl3.h&#34;
```

#### 创建窗口

```c&#43;&#43;
GLFWwindow* Windows;

int main()
{
    // init GLFW and OpenGL
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    // create main window
    Windows = glfwCreateWindow(1000, 800, &#34;ImGuiDemo&#34;, NULL, NULL);
    // give control permission to main window
    glfwMakeContextCurrent(Windows);
    // disable sync
    glfwSwapInterval(0);

    // init ImGui
    IMGUI_CHECKVERSION();
    ImGui::CreateContext(NULL);
    // read from io and set content of ImGui
    ImGuiIO&amp; io = ImGui::GetIO(); (void)io;

    // set ImGui&#39;s style
    ImGui::StyleColorsDark();
    // init ImGui to window created by GLFW 
    ImGui_ImplGlfw_InitForOpenGL(Windows, true);
    // init ImGui to be rendered by OpenGL
    ImGui_ImplOpenGL3_Init(&#34;#version 330&#34;);

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
        // draw GmGui&#39;s data got before
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

```c&#43;&#43;
ImGui::Begin(&#34;MyImGuiWindow&#34;, 0, ImGuiWindowFlags_::ImGuiWindowFlags_MenuBar);
...
ImGui::End();
```

##### 文本框

```c&#43;&#43;
std::string Text = &#34;Hello, world! 123&#34;;
ImGui::Text(Text.c_str());
```

##### 按钮

```c&#43;&#43;
if (ImGui::Button(&#34;Button&#34;))
{
    Text = &#34;You click the button&#34;;
}
```

##### 输入文本框

```c&#43;&#43;
char  textbox[64] = &#34;Test Text Box&#34;;
ImGui::InputText(&#34;Test Text Box&#34;, textbox, 64);
```

##### 固定显示选项的列表

```c&#43;&#43;
ImGui::BeginListBox(&#34;List&#34;);
for (size_t i = 0; i &lt; 32; i&#43;&#43;)
{
    if (ImGui::Selectable(std::to_string(i).c_str()))
    {
        Text = std::to_string(i);
    }
}
ImGui::EndListBox();
```

- Issue: [Horizontal scrollbar when using ListBoxHeader](https://github.com/ocornut/imgui/issues/2510)
&gt; Also note that `ListBoxHeader()` was renamed to `BeginListBox()` on 2023-05-31 

##### 可展开显示选项的列表

```c&#43;&#43;
if (ImGui::BeginCombo(&#34;Combo&#34;, Text.c_str()))
{
	for (size_t i = 0; i &lt; 32; i&#43;&#43;)
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

```c&#43;&#43;
ImVec4 color;
ImGui::ColorEdit4(&#34;Color&#34;, (float*)&amp;color, ImGuiColorEditFlags_::ImGuiColorEditFlags_AlphaBar);
```

#### 高级定制

## References

- The Cherno: [C&#43;&#43;](https://www.youtube.com/playlist?list=PLlrATfBNZ98dudnM48yfGUldqGD0S4FFb) / [中文翻译](https://space.bilibili.com/364152971/channel/collectiondetail?sid=13909): 主要介绍 C&#43;&#43;11 及以上版本的语法
- [C&#43;&#43; Weekly With Jason Turner](https://www.youtube.com/@cppweekly): 这个博主超级猛
- [CppCon](https://www.youtube.com/@CppCon): 强烈推荐 [Back To Basics](https://www.youtube.com/@CppCon/search?query=Back%20to%20Basics) 专题
- [Learn C&#43;&#43;](https://www.learncpp.com/)
- [HackerRank](https://www.hackerrank.com/): 一个与 LeetCode 类似的练习网站
- [C&#43;&#43; 矿坑系列](https://github.com/Mes0903/Cpp-Miner)
- 我是龙套小果丁: [现代 C&#43;&#43; 基础](https://space.bilibili.com/18874763/channel/collectiondetail?sid=2192185)
- 南方科技大学: [快速学习 C 和 C&#43;&#43;，基础语法和优化策略](https://www.bilibili.com/video/BV1Vf4y1P7pq/)
- 原子之音: [C&#43;&#43; 现代实用教程](https://space.bilibili.com/437860379/channel/seriesdetail?sid=2352475)
/ [C&#43;&#43; 智能指针](https://www.bilibili.com/video/BV18B4y187uL)
/ [CMake 简明教程](https://www.bilibili.com/video/BV1xa4y1R7vT)


---

> 作者: [vanJker](https://github.com/vanJker)  
> URL: https://ccrysisa.github.io/posts/modern-cpp/  

