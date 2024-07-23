# Modern C&#43;&#43;


&lt;!--more--&gt;

## Toolchain

&gt; Wikipedia: [Toolchain](https://en.wikipedia.org/wiki/Toolchain)

- OS: Windows 10
- IDE: [Visual Studio](https://visualstudio.microsoft.com/) 2019 Community edition
  - Clang Power Tools
  - [cppcheck-vs-addin](https://github.com/VioletGiraffe/cppcheck-vs-addin) vsix
  - ClangFormat
- [LLVM](https://releases.llvm.org/download.html) 17.0.1 Win64
- [Cppcheck](https://cppcheck.sourceforge.io/) 2.13 Win64

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

#### 条件编译
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

Breakpoint &amp; Memory

调试时相关信息的窗口在「调试 $\rightarrow$ 窗口」处可以开启显示

在内存查看窗口，可以通过 `&amp;var` (`var` 为当前上下文变量的名字) 来快速获取该变量对应的地址，以及查看该地址所所储存的值

调试过程中，通过「右键 $\rightarrow$ 转到反汇编」即可查看对应的汇编代码

### Project Setup 

filter 类似于一种虚拟的文件系统组织，不过只能在 VS 才能表示为层次形式 (通过解析 XML 格式的配置文件)，在主机的文件系统上没有影响

解决方案栏的「显示所有文件」可以展示当前 Project 在主机文件系统下的组织层次结构，也可以在这个视图下创建目录 / 文件，这样也会在主机文件系统创建对应的目录 / 文件

主机文件系统和 VS 的虚拟项目组织是解耦的，所以在主机移动源文件并不会影响其在 VS 的虚拟项目组织所在的位置

VS 默认设置是将构建 / 编译得到的中间文件放在 Project 的 Debug 目录，但是得到的可执行文件却放在 Solution 的 Debug 目录下，这十分奇怪。可以通过修改 Project 的属性 (右键选择属性这一选项) 里的输出目录，使得其与中间目录一致为 `$(Configuration)\`。也可以将 Solution 内的全部 Projects 的可执行文件均放置在 Solution 下的同一目录

推荐设定如下:
- Output Directory: `$(SolutionDir)\bin\$(Platform)\$(Configuration)\`
- Intermediate Directory: `$(SolutionDir)\bin\intermidiate\$(Platform)\$(Configuration)\`

{{&lt; admonition &gt;}}
在编辑这些目录设定时，其下拉框中选择「编辑」字段可以查看形如 `$(SolutionDir)` 这些宏的定义
{{&lt; /admonition &gt;}}

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

## Pointer and Reference

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

## Class, Struct and Enum

C&#43;&#43; 的 Class 和 Struct 是相同的东西，只不过 Class 默认成员字段的外部可见性为 private，而 Struct 默认成员字段的外部可见性为 public，仅仅这个区别而已

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

### Log System

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

## Static

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

## Constructor and Destructor

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

## Inheritance and Polymorphism

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

### Virtual Function

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

## Array and String

### Array

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

- cppreference: [std::array](https://en.cppreference.com/w/cpp/container/array)

&gt; std::array is a container that encapsulates fixed size arrays.

### String

## References

- The Cherno: [C&#43;&#43;](https://www.youtube.com/playlist?list=PLlrATfBNZ98dudnM48yfGUldqGD0S4FFb) / [中文翻译](https://space.bilibili.com/364152971/channel/collectiondetail?sid=13909)
- [C&#43;&#43; Weekly With Jason Turner](https://www.youtube.com/@cppweekly)
- [C&#43;&#43; 矿坑系列](https://github.com/Mes0903/Cpp-Miner)
- 南方科技大学: [快速学习 C 和 C&#43;&#43;，基础语法和优化策略](https://www.bilibili.com/video/BV1Vf4y1P7pq/)
- [C&#43;&#43; 现代实用教程](https://space.bilibili.com/437860379/channel/seriesdetail?sid=2352475)
/ [C&#43;&#43; 智能指针](https://www.bilibili.com/video/BV18B4y187uL)
/ [CMake 简明教程](https://www.bilibili.com/video/BV1xa4y1R7vT)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/modern-cpp/  

