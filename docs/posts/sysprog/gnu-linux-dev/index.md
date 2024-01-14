# GNU/Linux 开发工具


{{< admonition abstract >}}
GNU/Linux 开发工具，几乎从硬件到软件，Linux 平台能够自下而上提供各类触及“灵魂”的学习案例，让所有课程从纸上谈兵转变成沙场实战，会极大地提升工程实践的效率和技能。
{{< /admonition >}}

<!--more-->

> 原文地址：[GNU/Linux 开发工具][source]

## 安装 Windows / Ubuntu 双系统

因为有些操作必须在物理硬件上才能执行。

## Markdown 与 LaTeX

速览 LaTeX 语法示例一节，作为工具书册，在需要使用时知道如何查询。

速览 Markdown 语法示例一节，作为工具书册，在需要使用时知道如何查询。

{{< admonition >}}
编写 Markdown 文本以及 LaTeX 语法表示的数学式可以通过：

- Hugo + FixIt :white_check_mark:
- VS Code + Markdown Preview Enhanced
{{< /admonition >}}


## Git 和 Github

阅读 SSH key 产生方法一节，配置好 Git 和 Github 的 SSH key。同时也可作为工具书册，在需要使用时知道如何查询。

***推荐通过 [LearnGitBranching][learn-git-branching] 来熟悉 Git 命令！！！***


以下资源作为自学资源，用于补充自己不熟悉的操作，或者作为以上资料的补充工具手册。

- [Git 中文教学（视频）][git-tutorials-zh] 
    - [学习记录]({{< relref "../git/git-learn.md" >}})
- [30 天精通 Git 版本控制（文本）][learn-git-in-30-days]

{{< admonition warning >}}
原文档中的将公钥复制到 clipboard 中使用了 `clip` 命令，但是这个命令在 Ubuntu 中并没有对应的命令。可以使用 `xclip` + `alias` 达到近似效果。

```bash
$ sudo apt install xclip
# using alias to implement clip, you can add this to bashrc
$ alias='xclip -sel c'
```
{{< /admonition >}}

## 编辑器: Visual Studio Code

认真阅读，跟随教学文档进行安装、设置。重点阅读 ***设定、除错（调试）*** 这两部分。更新 VS Code 部分作为手册，在需要时进行参考。

以下资源作为自学资源，用于补充自己不熟悉的操作，或者作为以上资料的补充工具手册。

- [x] [开开心心学 Vistual Studio Code][learn-vscode-happily]

- [x] 完成 SSH key 的生成。
- [x] 完成 VS Code 的设置。
- [x] 安装 Git History 插件。
- [x] 安装 Native Debug 插件，并进行 Debug ([test-stopwatch.c](https://github.com/LoongGshine/LKI/blob/main/debug/test-stopwatch.c)) 操作。
- [x] 安装 VSCode Great Icons 文件图标主题，另外推荐两款颜色主题：One Dark Pro, Learn with Sumit。

VS Code 控制台使用说明：

- 可以在面板的输出，点击 GIT 选项显示 VS Code 背后执行的 git 命令。
- 可以使用 `ctrl + shift + P` 呼出命令区，然后通过输入 Git branch 和 Git checkout 等并选择对应选项，来达到创建分支、切换分支等功能。

{{< admonition tip >}}
- 在 VS Code 设置中，需要在设置中打开 **Open Default Settings** 选项才能在左侧面板观察到预设值。键位绑定同理。
- 要想进行调试，需要在使用 gcc 生成目标文件时，加入 `-g` 参数来生产调试信息。
- 原文档中的 **GDB 教学链接-除错程式-gdb** 已失效，这是目前的[有效链接](https://frdm.cyut.edu.tw/~ckhung/b/c/gdb.php)。也可通过该影片 [拯救资工系学生的基本素养-使用 GDB 除错基本教学](https://www.youtube.com/watch?v=IttSz0BYZ8o) 来补充学习 GDB 的操作。
{{< /admonition >}}

## 终端和 Vim 

认真阅读，跟随教学影片 [快快乐乐学 Vim][learn-vim-happily] 和教学文档配置好 **终端提示符、Vim**。

- [x] 完成命令行提示符配置
- [x] 完成 Vim 的设定
- [x] 安装并使用 Minial Vim Plugin Manager 来管理 Vim 插件 (neocomplcache, nerdtree)
- [x] 安装并使用 byobu 来管理多个终端视图。

{{< admonition tip >}}
- 在 .vimrc 中增加插件后，打开 vim，执行 `:PlugInstall` 来安装插件，完成后在 vim 执行 `:source ~/.vimrc`。（可以通过 `:PlugStatus` 来查看插件安装状态）
- 使用 `F4` 键来[显示/不显示][行数/相对行数]。
- 使用 `F5` 键来呼入/呼出文件树(nerdtree)，在文件树恻通过 `ENTER` 键来访问目录/文件。
- 使用 `Ctrl-w-h`/`Ctrl-w-l` 切换到 文件树/编辑区。
- 自动补全时使用 `ENTER` 键来选中，使用方向键或 `Ctrl-N`/`Ctrl-U`/`Ctrl-P` 来上下选择。
- 在 Vim 中可以通过 `:set paste`，并在 insert 模式下，将粘贴板的内容通过 `Ctrl-Shift-V` 进行粘贴。
{{< /admonition >}}

***推荐观看影片 [How to Do 90% of What Plugins Do (With Just Vim)][how-to-do-90%-of-what-plugins-do] 来扩展 Vim 插件的使用姿势。***

以下资源为 Cheat Sheet，需要使用时回来参考即可。

- [Vim Cheat Sheet][vim-cheat-sheet]
- [Bash terminal Cheat Sheet][bash-cheat-sheet]

## Makefile

速览教学文档，作为工具书册，在需要使用时知道如何查询。

gcc 的 `-MMD` 和 `-MF` 参数对我们编写 Makefile 是一个巨大利器。理解 Makefile 的各种变量定义的原理。

- [x] 对之前的 test-stopwatch.c 编写了一个 [Makefile](https://github.com/LoongGshine/LKI/blob/main/debug/test-stopwatch.c) 来自动化管理。

## Linux 性能分析工具: Perf

认真阅读，复现教学文档中的所有例子，初步体验 perf 在性能分析上的强大。

- [x] 安装 perf 并将 kernel.perf_event_paranoid 设置为 1。
- [x] 动手使用 perf_top_example.c，体验 perf 的作用。
- [ ] 搭配影片: [Branch Prediction](https://youtu.be/gmgfLR2h2RU)
- [ ] 对照阅读: [Fast and slow if-statements: branch prediction in modern processors](http://igoro.com/archive/fast-and-slow-if-statements-branch-prediction-in-modern-processors/)
- [ ] 编译器提供的辅助机制: [Branch Patterns, Using GCC](http://cellperformance.beyond3d.com/articles/2006/04/branch-patterns-using-gcc.html)
- [x] 动手使用 perf_top_while.c，体验 `perf top` 的作用。
- [x] 动手使用 perf_stat_cache_miss.c，体验 `perf stat` 的作用。（原文的结果有些不直观，务必亲自动手验证）
- [x] 动手使用 perf_record_example.c，体验 `perf record` 的作用。（原文的操作不是很详细，可以参考下面的 Success）

[源程序地址](https://github.com/LoongGshine/LKI/blob/main/perf)

{{< admonition type=success open=false >}}
```bash
$ perf record -e branch-misses:u,branch-instructions:u ./perf_record_example
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.009 MB perf.data (94 samples) ]
```

- 输出第一行表示 perf 工具在收集性能数据时被唤醒了 1 次，以将数据写入输出文件。
- 输出第二行表示 perf 工具已经取样并写入了一个名为 perf.data 的二进制文件，文件大小为 0.009 MB，其中包含了 94 个采样。（可以通过 `ls` 命令来检查 perf.data 文件是否存在）

接下来通过 `perf report` 对之前输出的二进制文件 `perf.data` 进行分析。可以通过方向键选择，并通过 ENTER 进入下一层查看分析结果。

```bash
$ perf report
Available samples
5 branch-misses:u
89 branch-instructions:u
```
{{< /admonition >}}

{{< admonition tip >}}
- perf 需要在 root 下进行性能分析。
- `perf top` 是对于哪个程序是性能瓶颈没有头绪时使用，可以查看哪个程序（以及程序的哪个部分）是热度点。
    - 在 `perf top` 时可以通过 `h` 键呼出帮助列表。
    - 可以通过方向键选择需要进一步分析的部分，并通过 `a` 键来查看指令级别粒度的热点。
- `perf stat` 是对某一个要优化的程序进行性能分析，对该程序涉及的一系列 events 进行取样检查。
- `perf record` 的精度比 `perf stat` 更高，可以对取样的 events 进行函数粒度的分析。
{{< /admonition >}}

## Linux 绘图工具: gnuplot

安装 gnuplot:

```bash
$ sudo apt-get install gnuplot
```


## 学习记录

### GDB 调试

观看教学视频 [拯救資工系學生的基本素養—使用 GDB 除錯基本教學](gdb-basics) 和搭配博文 ==[How to debug Rust/C/C++ via GDB][debug-gdb]==，学习 GDB 的基本操作和熟悉使用 GDB 调试 Rust/C/C++ 程序。

- 掌握 `run/r`, `break/b`, `print/p`, `continue/c`, `step/s` `info/i`, `delete/d`, `backtrace/bt`, `frame/f`, `up`/`down`, `exit/q` 等命令的用法。以及 GBD 的一些特性，例如 GDB 会将空白行的断点自动下移到下一代码行；使用 `break` 命令时可以输入源文件路径，也可以只输入源文件名称。

相关的测试文件：

- [test.c](https://github.com/LoongGshine/LKI/blob/main/debug/test.c)
- [hello_cargo/](https://github.com/LoongGshine/LKI/tree/main/debug/hello_cargo) 



[source]: https://hackmd.io/@sysprog/gnu-linux-dev/
[learn-git-branching]: https://learngitbranching.js.org/
[git-tutorials-zh]: https://www.youtube.com/playlist?list=PLlyOkSAh6TwcvJQ1UtvkSwhZWCaM_S07d
[learn-git-in-30-days]: https://github.com/doggy8088/Learn-Git-in-30-days 
[learn-vscode-happily]: https://www.youtube.com/playlist?list=PL6S9AqLQkFpph4LOfSjtD-s4WB3pNh5M3
[gdb-basics]: https://www.youtube.com/watch?v=IttSz0BYZ8o
[debug-gdb]: https://tigercosmos.xyz/post/2020/09/system/debug-gdb/
[how-to-do-90%-of-what-plugins-do]: https://www.youtube.com/watch?v=XA2WjJbmmoM&list=WL
[vim-cheat-sheet]: https://hackmd.io/@sysprog/gnu-linux-dev/https%3A%2F%2Fvim.rtorr.com%2F
[bash-cheat-sheet]: https://hackmd.io/@sysprog/gnu-linux-dev/https%3A%2F%2Fkapeli.com%2Fcheat_sheets%2FBash_Shortcuts.docset%2FContents%2FResources%2FDocuments%2Findex
[learn-vim-happily]: https://youtu.be/Y3Libi0SEp8



---

> 作者: [Xshine](https://github.com/LoongGshine)  
> URL: https://loonggshine.github.io/posts/sysprog/gnu-linux-dev/  

