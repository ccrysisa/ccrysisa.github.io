# Git 学习记录


教学影片：[Git 中文教学][git-zh-tutorials]
&lt;!--more--&gt;

## 安装与设定

{{&lt; admonition &gt;}}
:white_check_mark: 观看影片 [Git 教学系列 - 安装与配置](http://localhost:1313/)，完成常用的 Git 设置。
{{&lt; /admonition &gt;}}

设置 Git 的编辑器为 vim，主要用于 `commit` 时的编辑：

```bash
$ git config --global core.editor vim
```

设置 Git 的合并解决冲突工具为 vimdiff：
```bash
$ git config --global merge.tool vimdiff
```

启用 Git 命令行界面的颜色显示：

```bash
$ git config --global color.ui true 
```

设置常用命令的别名：

```bash
$ git config --global alias.st status
$ git config --global alias.ch checkout
$ git config --global alias.rst reset HEAD
```
&gt; 效果为：命令 `git st` 等价于 `git status`，其余的类似。

设置 Windows 和 Mac/Linux 的换行符同步：

```bash
# In Windows
$ git config --global core.autocrlf true
# In Mac/Linux
$ git config --global core.autocrlf input
```
&gt; 效果为：在 Windows 提交时自动将 CRLF 转为 LF，检出代码时将 LF 转换成 CRLF。在 Mac/Linux 提交时将 CRLF转为 LF，检出代码时不转换。这是因为 Windows 的换行符为 `\r\n`，而 Mac/Linux 的换行符仅为 `\n`。

## Add 和 Commit

## 指定 Commit

{{&lt; admonition &gt;}}
:white_check_mark: 观看影片 [Git 教学系列 - 指定 Commit](http://localhost:1313/)，掌握 `git log`、`git show`、`git diff` 的常用方法。理解 Hash Value 和 commit 对于 Git 版本控制的核心作用。
{{&lt; /admonition &gt;}}

{{&lt; center-quote &gt;}}
***只要 commit 了，资料基本不可能丢失，即使误操作了也是可以补救回来的（除非把 `.git/` 文件夹也删除了）。***
{{&lt; /center-quote &gt;}}

### Hash Value

- Every commit has a *unique* hash value.
  - Calculate by SHA1
- Hash value can **indicate a commit** absolutely.

### Indicate Commit

- git manage references to commit
  - HEAD
  - Branch
  - Tag
  - Remote
- Also, We can indicate commit by `^`, `~`

通俗地将，不论是 `HEAD`、`Branch`、`Tag`、`Remote`，其本质都是使用 Hash Value 进行索引的 commit，所以 `~` 和 `^` 也可以作用于它们。

可以通过 `git log` 来查看 commit 以及对应的 Hash 值。事实上，这个命令十分灵活，举个例子：

```bash
git log 4a6ebc -n1
```

这个命令的效果是从 Hash 值为 4a6bc 的 commit 开始打印 1 条 commit 记录（没错，对应的是 `-n1`），因为 Git 十分聪明，所以 commit 对应的 Hash 值只需前 6 位即可（因为这样已经几乎不会发生 Hash 冲突）。

{{&lt; details &#34;Examples&#34; &gt;}}

打印 master 分支的最新一个 commit：

```bash
git log master -n1
```

打印 master 分支的最新一个 commit（仅使用一行打印 commit 信息）：

```bash
git log master -n1 --oneline
```

打印 HEAD 所指向的 commit：

```bash
git log HEAD -n1 --oneline
```

打印 HEAD 所指向的 commit 的前一个 commit：

```bash
git log HEAD^ -n1 --oneline
```

`^` 可以持续使用，比如 `HEAD^^` 表示 HEAD 所指向的 commit 的前两个 commit。当 `^` 数量过多时，可以使用 `~` 搭配数字来达到相同效果。例如：

```bash
git log HEAD^^^^^ -n1 --oneline
git log HEAD~5 -n1 --oneline
```

&gt; 一般来说，使用 `^` 就已经足够了，几乎不会遇到使用 `~` 的场景，因为这种场景一般会去找图形化界面吧。:rofl:

打印与文件 `README.md` 相关的 commits（仅使用一行显示）：

```bash
git log --oneline README.md
```

打印与文件 `README.md` 相关的 commits（显示详细信息，包括文件内容的增减统计）：

```bash
git log --stat README.md
```

打印与文件 `README.md` 相关的 commits（显示详细信息，包括文件内容的增减细节）：

```bash
git log --patch README.md
```

在打印的 commit 信息中抓取与 `README` 符合的信息（可以与 `--stat` 或 `--patch` 配合使用）：

```bash
git log -S README
```

{{&lt; /details &gt;}}

### View History

```bash
git log &lt;path&gt;|&lt;commit&gt;
```

- `-n`: limit number
- `--oneline`: view hash and commit summary
- `--stat`: view files change
- `--patch`: view lines change
- `-S or --grep`: find modification

### View Commit

```bash
git show &lt;commit&gt;
```

- Equal to `log -n1`

### See Difference

查看当前的修改，可以查看已经修改但没有 staged 文件的变化：

```bash
git diff
```

查看当前的修改，可以查看已经修改且 staged 文件的变化：

```bash
git diff --staged
```

查看当前与指定的 commit 的差异：

```bash
git diff &lt;commit&gt;
# e.g. 
git diff master^
```

查两个指定的 commit 之间的差异：

```bash
git diff &lt;commit&gt; &lt;commit&gt;
# e.g. 
git diff master^ master^^
```

## Path Add and Amend

{{&lt; admonition &gt;}}
:white_check_mark: 观看影片 [Git 教学系列 - Patch Add and Amend](http://localhost:1313/)，掌握 `git add -p`、`git checkout -p`、`git add ---amend` 的用法，使用 `add` 和 `checkout` 时强烈建议使用 `-p`，掌握修改 commit 的两种方法。
{{&lt; /admonition &gt;}}

### Only Add Related

```bash
git add -p
```

推荐尽量使用这个 `git add -p` 而不是单纯的 `git add`。

- 使用 `git add -p` 后，Git 会帮我们把涉及的修改分成 section，然后我们就可以对每一个 section 涉及的修改进行 review，选择 `y`(yes) 表示采纳该 sction 对应的修改，选择 `n`(no) 表示不采纳。
- 如果觉得 section 切割的粒度太大了，可以选择 `s`(split) 来进行更细粒度的划分。如果这样仍然觉得粒度不够，可以选择 `e`(edit) 对 section 涉及的修改，进行以行为粒度的 review，具体操作可以查阅此时给出的提示。
- 还有一些其它的选项，比如 `j`、`J`、`k`、`K`，这些是类似 vim，用于切换进行 review 的 section，不太常用。`q`(quit) 表示退出。

由于可以针对一个文件的不同 `section` 进行 review，所以在进行 `git add -p` 之后，使用 `git status` 可以发现同一个文件会同时处于两种状态。

### Checkout Also

```bash
git checkout -p
```

这个操作比较危险，因为这个操作的效果与 `git add -p` 相反，如果选择 `y` 的话，文件涉及的修改就会消失，如果涉及的修改没有 commit 的话，那么涉及的修改是无法救回的。但是怎么说，这个操作还是比直接使用 `git checkout` 稍微保险一点，因为会先进入 review 界面，而不是直接撤销修改。**所以，请一定要使用 `git checkout -p`！**

### Modify Commit

有两种方式来修改最新的 commit：

```bash
# 1. Use git commit --amend
git commit --amend

# 2. Use reset HEAD^ then re-commit
git reset HEAD^
git add -p
git commit
```

`git commit --amend` 并不是直接替换原有的 commit，而是创建了一个新的 commit 并重新设置了 HEAD 的指向。所以，新旧两个 commit 的 Hash Value 并不相同，事实上，如果你拥有旧 commit 的 Hash Value，是可以通过 `git checkout &lt;commit&gt;` 切换到那个 commit 的。其原理如下图：

![amend][amend]

但是注意，`git reset HEAD^` 是会撤销原先的 commit（仅限于本地 Git 存储库）。

## Branch and Merge

{{&lt; admonition &gt;}}
:white_check_mark: 观看影片 [Git 教学系列 - Branch and Merge](https://youtu.be/qUfT-4bNtwY)，掌握创建、删除、切换分支的用法，掌握合并分支、解决冲突的方法。
- `git checkout &lt;commit&gt;`
- `git branch &lt;name&gt;`
- `git branch &lt;name&gt; &lt;commit&gt;`
- `git branch [-d|-D] &lt;name&gt;`
- `git merge &lt;name&gt; --no-ff`
{{&lt; /admonition &gt;}}

### Move and Create Branch

Checkout: move HEAD
- `git checkout &lt;commit&gt;`: Move HEAD to commit
- `git checkout &lt;path&gt;`: **WARNING: discard change**
  - 可以将路径上的文件复原到之前 commit 的状态。

Branch:
- `git branch`: List branch
- `git branch &lt;name&gt;`: Create branch
  - Or just: `git checkout -b`

{{&lt; details &#34;Examples&#34; &gt;}}
修改一个文件并恢复：

```bash
# modify file load.cpp
git status
git checkout load.cpp
git status
```

删除一个文件并恢复：

```bash
rm load.cpp
git status
git checkout load.cpp
git status
```

&gt; 正如上一节所说的，`git checkout` 尽量带上 `-p` 参数，因为如果一不小心输入了 `git checkout .`，那就前功尽弃了。

显示分支：

```bash
# only show name
git branch
# show more infomation
git branch -v
```

切换分支：

```bash
# switch to branch &#39;main&#39;
git checkout main
```

创建分支：

```bash
# 1. using `git branch`
git branch cload
# 2. using `git checkout -b`
git checkout -b asmload
# 3. create a new branch in &lt;commit&gt;
git branch cload &lt;commit&gt;
```

切换到任一 commit：

```bash
git checkout &lt;commit&gt;
```

&gt; 直接 checkout 到任一 commit 会有警告，这是因为，当你以该 commit 为基点进行一系列的 commit，这些新的 commit 会在你切换分支后消失，因为没有 branch 来引用它们。之前可以被引用是因为 HEAD 引用，切换分支后 HEAD 不再引用这些 commit，所以就会消失。在这种情况，Git 会在发出警告的同时建议我们使用 `git branch` 来创建分支进行引用。
{{&lt; /details &gt;}}

### View Branch

列出仓库的所有分支：

```bash
git branch
```

也可以通过 `log` 来查看分支：

```bash
git log
```

- `--decorate`: 在 log 的首行显示所有的 references（可能需要通过 `git config log.decorate auto` 来开启）
- `--graph`: 以图形化的方式显示 branch 的关系（主要是 commit 的引用）

### Delete Branch

删除分支：

```bash
git branch -d &lt;name&gt;
```

对于有没有 merge 的 commit 的分支，Git 会警告，需要使用 `-D` 来强制删除：

```bash
git branch -D &lt;name&gt;
```

- for no-merge commit
- **WARNING: Discard Commit**

&gt; Git 会发出警告的原因同样是 no-merge commit 在删除分支后就无法被引用，所以会发出警告。

### Merge

合并分支。默认使用 fast-forward，即如果没有冲突，直接将要合并的分支提前到被合并分支的 commit 处，而不会另外生成一个 merge commit。但这样会使得被合并的分支在合并后，没有历史痕迹。可以通过 `--no-ff` (no fast forward) 来强制生成 merge commit。**推荐使用 merge 时加上 `--no-ff` 这个参数。**

```bash
git merge &lt;branch&gt;
```

通常是 main/master 这类主分支合并其它分支：

```bash
git checkout main/master
git merge &lt;branch&gt;
```

### Resolve Conflict

**Manually resolve:**
- {{&lt; raw &gt;}}Check every codes between &lt;&lt;&lt;&lt;&lt;&lt;&lt;, &gt;&gt;&gt;&gt;&gt;&gt;&gt;{{&lt; /raw &gt;}}
- Edit code to what it should be

**Use mergetool like vimdiff:**
- It shows: local, base, remote, file to be edited
- Edit &#34;file ro be edited&#34; to what is should be

**Add and Commit**

```bash
# 1. 合并分支
git merge &lt;branch&gt;
# 2. 检查状态，查看 unmerged 的文件
git status
# 3. 编辑 unmerged 文件，编辑冲突区域代码即可
vim &lt;file&gt;
# 4. 添加解决完冲突的文件
git add &lt;file&gt;
# 5. 进行 merge commit
git commit
```
{{&lt; raw &gt;}}
冲突区域就是 &lt;&lt;&lt;&lt;&lt;&lt;&lt; 和 &gt;&gt;&gt;&gt;&gt;&gt;&gt; 内的区域，在 merge 操作后，Git 已经帮我们把 unmerged 文件修改为待解决冲突的状态，直接编辑文件即可。在编辑完成后，需要手动进行 add 和 commit，此次 commit 的信息 Git 已经帮我们写好了，一般不需要修改。
{{&lt; /raw &gt;}}

如果使用的是 mergetool，以 vimdiff 为例，只需将第 3 步的 `vim &lt;file&gt;` 改为 `git mergetool` 即可。vimdiff 会提供 4 个视窗：底部视窗是我们的编辑区，顶部左边是当前合并分支的状态，顶部中间是 base (合并分支和被合并的共同父节点) 的状态，顶部右边是 remote 的状态，按需要选择、编辑。
&gt; vimdiff 在编辑完后会保留 *.orig 的文件，这个文件是待解决冲突的文件副本。

### Merge Conflict

- Prevent very long development branch.
- Split source code clearly.


## Rebase

{{&lt; admonition &gt;}}
:white_check_mark: 观看影片 [Git 教学系列 - Branch and Merge](https://youtu.be/0nwqar3ycTY)，掌握 TODO 的方法。`git rebase` 是 Git 的精华，可以让我们实现更细粒度的操作，可以说学会了 rebase 才算真正入门了 Git。

这个视频讲得比较乱，所以推荐配合视频给出的参考文章 [Git-rebase 小笔记](https://blog.yorkxin.org/posts/git-rebase/) 来学习。
{{&lt; /admonition &gt;}}


&lt;!-- URL --&gt;
[git-zh-tutorials]: https://www.youtube.com/playlist?list=PLlyOkSAh6TwcvJQ1UtvkSwhZWCaM_S07d
&lt;!-- Images --&gt;
[amend]: /images/git/amend.svg


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/git-learn/  

