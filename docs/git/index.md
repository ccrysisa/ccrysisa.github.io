# Git 学习记录


教学影片：[Git 中文教学][git-zh-tutorials]

## 安装与设定

完成常用的 Git 设置：

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

## Add 和 Commit

## 指定 Commit

**Hash Value:**
- Every commit has a *unique* hash value.
  - Calculate by SHA1
- Hash value can indicate a commit absolutely.

可以通过 `git log` 来查看 commit 记录以及对应的 Hash 值。事实上，这个命令十分灵活，举个例子：

```bash
git log 4a6ebc -n1
```

这个命令的效果是从 Hash 值为 4a6bc 的 commit 开始打印 1 条 commit 记录（没错，对应的是 `-n1`），因为 Git 十分聪明，所以 commit 对应的 Hash 值只需前 6 位即可（因为这样已经几乎不会发生 Hash 冲突）。

[git-zh-tutorials]: https://www.youtube.com/playlist?list=PLlyOkSAh6TwcvJQ1UtvkSwhZWCaM_S07d


---

> 作者: [Xshine](https://github.com/LoongGshine)  
> URL: https://loonggshine.github.io/git/  

