# GNU/Linux 开发工具


# GNU/Linux 开发工具

[原文地址][source]

## 安装 Windows / Ubuntu 双系统

因为有些操作必须在物理硬件上才能执行。

## Markdown 文本标记语言

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

## Visual Studio Code

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
- 使用 `F5` 键来[显示/不显示][行数/相对行数]。
- 使用 `TAB` 键来呼出文件树(nerdtree)，在文件树恻通过 `ENTER` 键来访问目录/文件。
- 使用 `C-w-h`/`C-w-l` 切换到 文件树/编辑区。
- 自动补全时使用 `ENTER` 键来选中，使用方向键或 `C-N`/`C-U`/`C-P` 来上下选择。
{{< /admonition >}}

***推荐观看影片 [How to Do 90% of What Plugins Do (With Just Vim)][how-to-do-90%-of-what-plugins-do] 来扩展 Vim 插件的使用姿势。***

以下资源为 Cheat Sheet，需要使用时回来参考即可。

- [Vim Cheat Sheet][vim-cheat-sheet]
- [Bash terminal Cheat Sheet][bash-cheat-sheet]

## Makefile

速览教学文档，作为工具书册，在需要使用时知道如何查询。

gcc 的 `-MMD` 和 `-MF` 参数对我们编写 Makefile 是一个巨大利器。理解 Makefile 的各种变量定义的原理。

- [x] 对之前的 test-stopwatch.c 编写了一个 [Makefile](https://github.com/LoongGshine/LKI/blob/main/debug/test-stopwatch.c) 来自动化管理。


## 学习记录

### GDB 调试

观看教学视频 ==[拯救資工系學生的基本素養—使用 GDB 除錯基本教學](gdb-basics)== 和搭配博文 ==[How to debug Rust/C/C++ via GDB][debug-gdb]==，学习 GDB 的基本操作和熟悉使用 GDB 调试 Rust/C/C++ 程序。

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
> URL: https://loonggshine.github.io/sysprog/gnu-linux-dev/  

