# GDB 调试入门


{{&lt; admonition abstract &gt;}}
大型开源项目的规模十分庞大，例如使用 Rust 编写的 Servo 浏览器，这个项目有近十万行代码。在开发规模如此庞大的项目时，了解如何通过正确的方式进行调试非常重要，因为这样可以帮助开发者快速地找到瓶颈。
{{&lt; /admonition &gt;}}

&lt;!--more--&gt;

&gt; {{&lt; link href=&#34;https://tigercosmos.xyz/post/2020/09/system/debug-gdb/&#34; content=&#34;原文地址&#34; external-icon=true &gt;}} | {{&lt; link href=&#34;https://www.youtube.com/watch?v=IttSz0BYZ8o&#34; content=&#34;教学视频&#34; external-icon=true &gt;}}

## GDB 调试

观看教学视频 [拯救資工系學生的基本素養—使用 GDB 除錯基本教學](gdb-basics) 和搭配博文 ==[How to debug Rust/C/C&#43;&#43; via GDB][debug-gdb]==，学习 GDB 的基本操作和熟悉使用 GDB 调试 Rust/C/C&#43;&#43; 程序。

- 掌握 `run/r`, `break/b`, `print/p`, `continue/c`, `step/s` `info/i`, `delete/d`, `backtrace/bt`, `frame/f`, `up`/`down`, `exit/q` 等命令的用法。以及 GBD 的一些特性，例如 GDB 会将空白行的断点自动下移到下一代码行；使用 `break` 命令时可以输入源文件路径，也可以只输入源文件名称。

相关的测试文件：

- [test.c](https://github.com/ccrysisa/LKI/blob/main/debug/test.c)
- [hello_cargo/](https://github.com/ccrysisa/LKI/tree/main/debug/hello_cargo) 

## GDB 基本介绍

{{&lt; admonition quote &gt;}}
“GDB, the GNU Project debugger, allows you to see what is going on ‘inside’ another program while it executes — or what another program was doing at the moment it crashed.” — from {{&lt; link &#34;gnu.org&#34; &gt;}}
{{&lt; /admonition &gt;}}

安装 GDB:

```bash
$ sudo apt install gdb
```

启动 GDB 时可以加入 `-q` 参数 (quite)，表示减少或不输出一些提示或信息。

&gt; LLDB 与 GDB 的命令类似，本文也可用于 LLDB 的入门学习。

## GDB 调试 C/C&#43;&#43;

要使用 GDB 来调试 C/C&#43;&#43;，需要在编译时加上 `-g` 参数（必需），也可以使用 `-Og` 参数来对 debug 进行优化（建议），例如：

```bash
$ gcc test.c -Og -g -o test
$ gdb -q ./test
```

{{&lt; link href=&#34;https://github.com/ccrysisa/LKI/tree/main/debug/test.c&#34; content=Source external-icon=true &gt;}}

## GDB 调试 Rust

在使用 `build` 命令构建 debug 目标文件（即位于 target/debug 目录下的目标文件，与 package 同名）后，就可以通过 gdb 来进行调试：

```bash
$ cargo build
$ gdb -q ./target/debug/&lt;package name&gt;
```

但是如果是使用 `cargo build --release` 构建的 release 目标文件（即位于 target/release 目录下的目标文件），则无法使用 GDB 进行调试，因为 release 目标未包含任何调试信息，类似于未使用 `-g` 参数编译 C/C&#43;&#43; 源代码。

{{&lt; link href=&#34;https://github.com/ccrysisa/LKI/tree/main/debug/hello_cargo&#34; content=Source external-icon=true &gt;}}

## GDB 基本命令

### run

`run (r)` 命令用于从程序的执行起始点开始执行，直到遇到下一个断点或者程序结束。

### continue

`continue (c)` 命令用于从当前停止的断点位置处继续执行程序，直到遇到下一个断点或者程序结束。

{{&lt; admonition &gt;}}
`run` 和 `continue` 的区别在于 `run` 是将程序从头开始执行。例如如果未设置任何断点，使用 `run` 可以反复执行程序，而如果使用 `continue` 则会提示 *The program is not being run*。
{{&lt; /admonition &gt;}}

### step

`step (s)` 命令用于 **逐行** 执行程序，在遇到函数调用时进入对应函数，并在函数内部的第一行暂停。`step` 命令以 *单步方式* 执行程序的每一行代码，并跟踪函数调用的进入和退出。

```bash
(gdb) step
6         bar &#43;= 3;
(gdb) step
7         printf(&#34;bar = %d\n&#34;, bar);
```

{{&lt; admonition &gt;}}
`step` 命令与 `continue` 命令相同，只能在程序处于运行态（即停留在断点处）时才能使用。
{{&lt; /admonition &gt;}}

### break

`break (b)` 命令用于在可执行问卷对应的源程序中加入断点，可以在程序处于 *未运行态/运行态* 时加入断点（运行态是指程序停留在断点处但未执行完毕的姿态）。

可以通过指定源文件对应的 *行数/函数名* 来加入断点：

```bash
(gdb) break test.c:7
(gdb) break test.c:foo
```

如果可执行文件由多个源文件编译链接得到，可以通过指定 *源文件名字* 的方式来加入断点，无需源文件路径，但如果不同路径有重名源文件，则需要指定路径来区分：

```bash
(gdb) break test1.c:7
(gdb) break test2.c:main
```

### print

`print (p)` 命令用于在调试过程中打印 *变量*的值或 *表达式* 的结果，帮助开发者检查程序状态并查看特定变量的当前值。

```bash
# Assume x: 3, y: 4
(gdb) print x
$1 = 3
(gdb) print x &#43; y
$2 = 7
```

使用 `p` 命令打印变量值时，会在左侧显示一个 `$&lt;number&gt;`，这个可以理解成临时变量，后续也可以通过这个标志来复用这些值。例如在上面的例子中：

```bash
(gdb) print $1
$3 = 3
(gdb) print $1 &#43; $3
$4 = 4
```

### backtrace

`backtrace (bt)` 命令用于打印当前调用栈的信息，也称为堆栈回溯 (backtrace)。它显示了程序在执行过程中经过的函数调用序列，以及每个函数调用的位置和参数，即可以获取以下信息：

- *函数调用序列*：显示程序当前的函数调用序列，以及每个函数的名称和所在的源代码文件。
- *栈帧信息*：对于每个函数调用，显示该函数的栈帧信息，包括栈帧的地址和栈帧的大小。

```bash
(gdb) backtrace
(gdb) backtrace 
#0  foo () at test.c:7
#1  0x00005555555551d2 in main () at test.c:14
```

{{&lt; admonition tip &gt;}}
`backtrace` 命令对于跟踪程序的执行路径、检查函数调用的顺序以及定位错误非常有用。在实际中，一般会搭配其他GDB命令（如 `up`、`down` 和 `frame`）结合使用，以查看特定栈帧的更多详细信息或切换到不同的栈帧。在上面的例子中，`#0` 和 `#1` 表示栈帧的编号，可以通过 `frame` 配合这些编号来切换栈帧。
{{&lt; /admonition &gt;}}

### frame

`frame (f)` 命令用于选择特定的栈帧 (stack frame)，从而切换到不同的函数调用上下文，每个栈帧对应于程序中的一个函数调用。

接着上一个例子，切换到 `main` 函数所在的栈帧：

```bash
(gdb) frame 1
#1  0x00005555555551d2 in main () at test.c:14
14          int result = foo();
```

### up/down

`up` 和 `down` 命令用于在调试过程中在不同的栈帧之间进行切换：

- `up` 用于在调用栈中向上移动到较高的栈帧，即进入调用当前函数的函数。每次执行 `up` 命令，GDB 将切换到上一个（更高层次）的栈帧。这可以用于查看调用当前函数的上层函数的执行上下文。
- `down` 用于在调用栈中向下移动到较低的栈帧，即返回到当前函数调用的函数。每次执行 `down` 命令，GDB 将切换到下一个（较低层次）的栈帧。这可以用于返回到调用当前函数的函数的执行上下文。

&gt; 这两个命令需要开发者对应函数调用堆栈的布局有一定程度的了解。

接着上一个例子：

```bash
(gdb) up
#1  0x00005555555551d2 in main () at test.c:14
14          int result = foo();
(gdb) down
#0  foo () at test.c:7
7         printf(&#34;bar = %d\n&#34;, bar);
```

### info

`info (i)` 命令用于获取程序状态和调试环境的相关信息，该命令后面可以跟随不同的子命令，用于获取特定类型的信息。

一些常用的 `info` 子命令：

- `info breakpoints` 显示已设置的所有断点 (breakpoint) 信息，包括断点编号、断点类型、断点位置等。
- `info watchpoints` 显示已设置的所有监视点 (watchpoint) 信息，包括监视点编号、监视点类型、监视的表达式等。
- `info locals` 显示当前函数的局部变量的值和名称。
- `info args` 显示当前函数的参数的值和名称。
- `info registers` 显示当前 CPU 寄存器的值。
- `info threads` 显示当前正在调试的所有线程 (thread) 信息，包括线程编号、线程状态等。
- `info frame` 显示当前栈帧 (stack frame) 的信息，包括函数名称、参数、局部变量等。
- `info program` 显示被调试程序的相关信息，例如程序入口地址、程序的加载地址等。

```bash
(gdb) info breakpoints # or simply: i b
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x000055555555518f in foo at test.c:7
2       breakpoint     keep y   0x0000555555555175 in foo at test.c:4
```

### delete

`delete (d)` 命令用于删除断点 (breakpoint) 或观察点 (watchpoint)。断点是在程序执行期间暂停执行的特定位置，而观察点是在特定条件满足时暂停执行的位置。

可以通过指定 *断点 / 观察点* 的编号或使用 `delete` 命令相关的参数，来删除已设置的断点 / 观察点。断点 / 观察点编号可以在使用 `info breakpoints` / `info watchpoints` 命令时获得。

### quit

`quit (q)` 命令用于退出 GDB，返回终端页面。

```bash
(gdb) quit
$ # Now, in the terminial
```

### list

`list` 命令用于显示当前位置的代码片段，默认情况下，它会显示当前位置的前后10行代码。

`list` 命令也可以显示指定范围的代码，使用 `list &lt;start&gt;,&lt;end&gt;` 命令将显示从 start 行到 end 行的源代码。

### whatis

`whatis` 命令用于获取给定标识符（如变量、函数或类型）的类型信息。

```bash
// in source code
int calendar[12][31];

// in gdb
(gdb) whatis calendar
type = int [12][31]
```

### x

`x` 命令用于查看内存中的数据，使用 x 命令搭配不同的格式来显示内存中的数据，也可以搭配 `/` 后跟数字来指定要显示的内存单元数量。例如，`x/4 &lt;address&gt;` 表示显示地址 address 开始的连续 4 个内存单元的内容。

### 其他

如果被调试程序正处于运行态（即已经通过 `run` 命令来运行程序），此时可以通过 `Ctrl&#43;C` 来中断 GDB，程序将被立即中断，并在中断时所运行到的地方暂停。这种方式被称为 **手动断点**，手动断点可以理解为一个临时断点，只会在该处暂停一次。

GDB 会将空白行的断点自动下移到下一非空的代码行。

`set print pretty` 命令可以以更易读和格式化的方式显示结构化数据，以更友好的方式输出结构体、类、数组等复杂类型的数据，更易于阅读和理解。


---

> 作者: [Xshine](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/debug-gdb/  

