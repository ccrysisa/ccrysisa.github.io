---
title: Git 学习记录
subtitle:
date: 2023-12-27T23:34:45+08:00
draft: false
author:
  name: Xshine
  link: https://github.com/LoongGshine
  email: caijiaxin@dragonos.org
  avatar: https://avatars.githubusercontent.com/u/133117003?s=400&v=4
description:
keywords:
license:
comment: false
weight: 0
tags:
  - Git
categories:
  - Git
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRss: false
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

教学影片：[Git 中文教学][git-zh-tutorials]

## 安装与设定

:white_check_mark: 观看影片 [Git 教学系列 - 安装与配置][git-zh-1]，完成常用的 Git 设置。

---

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

> 效果为：命令 `git st` 等价于 `git status`，其余的类似。

## Add 和 Commit

## 指定 Commit

:white_check_mark: 观看影片 [Git 教学系列 - 指定 Commit][git-zh-3]，掌握 `git log`、`git show`、`git diff` 的常用方法。

---

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

{{< details "Examples" >}}

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

> 一般来说，使用 `^` 就已经足够了，几乎不会遇到使用 `~` 的场景，因为这种场景一般会去找图形化界面吧。:rofl:

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

{{< /details >}}

### View History

```bash
git log <path>|<commit>
```

- `-n`: limit number
- `--oneline`: view hash and commit summary
- `--stat`: view files change
- `--patch`: view lines change
- `-S or --grep`: find modification

### View Commit

```bash
git show <commit>
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
git diff <commit>
# e.g. 
git diff master^
```

查两个指定的 commit 之间的差异：

```bash
git diff <commit> <commit>
# e.g. 
git diff master^ master^^
```

## Path Add and Amend

:white_check_mark: 观看影片 [Git 教学系列 - Patch Add and Amend][git-zh-4]，掌握 `git add -p`、`git checkout -p`、`git add ---amend` 的用法，使用 `add` 和 `checkout` 时强烈建议使用 `-p`，掌握修改 commit 的两种方法。

---

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

`git commit --amend` 并不是直接替换原有的 commit，而是创建了一个新的 commit 并重新设置了 HEAD 的指向。所以，新旧两个 commit 的 Hash Value 并不相同，事实上，如果你拥有旧 commit 的 Hash Value，是可以通过 `git checkout <commit>` 切换到那个 commit 的。其原理如下图：

![amend][amend]

但是注意，`git reset HEAD^` 是会撤销原先的 commit（仅限于本地 Git 存储库）。


<!-- URL -->
[git-zh-tutorials]: https://www.youtube.com/playlist?list=PLlyOkSAh6TwcvJQ1UtvkSwhZWCaM_S07d
[git-zh-1]: https://youtu.be/LZ4oOzZwgrk
[git-zh-3]: https://youtu.be/SV7xK_6-Wcg
[git-zh-4]: https://youtu.be/3oIU7fG2UT0

<!-- Images -->
[amend]: /images/git/amend.svg
