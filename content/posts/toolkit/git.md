---
title: "Git/GitHub 资源与问题汇总"
subtitle:
date: 2024-01-04T19:00:36+08:00
draft: false
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
  - Git
  - GitHub
categories:
  - Toolkit
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
lightgallery: false
password:
message:
repost:
  enable: true
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

## FAQ

{{< admonition type=question title="git pull/push 遇到 Port 22 connect timeout" >}}
网络问题导致 22 端口被禁止，无法正常使用 ssh。切换成 443 端口并且编写配置文件即可：

```bash
$ vim ~/.ssh/config
# In ~/.ssh/config
Host github.com
HostName ssh.github.com
Port 443
```
{{< /admonition >}}

{{< admonition type=question type="ssh: connect to host ssh.github.com port 443: Connection refused" >}}
使用 `ssh` 进一步确认是否为 DNS 的解析问题:

```sh
$ ssh -vT -p 443 git@ssh.github.com
...
debug1: Connecting to ssh.github.com [::1] port 443.
debug1: connect to address ::1 port 443: Connection refused
debug1: Connecting to ssh.github.com [127.0.0.1] port 443.
debug1: connect to address 127.0.0.1 port 443: Connection refused
ssh: connect to host ssh.github.com port 443: Connection refused
```

如果出现以上输出，则表示 github.com 已被 DNS 解析为 localhost，通过在 `/etc/resolv.conf` 处加入可信的 DNS 服务器即可解决:

```sh
$ vim /etc/resolv.conf
nameserver 8.8.8.8
...
```
{{< /admonition >}}

{{< admonition type=question type="GitHub 支持多个账户通过 ssh 连接" >}}
[Using multiple github accounts with ssh keys](https://gist.github.com/oanhnn/80a89405ab9023894df7)
{{< /admonition >}}

## Resources

- [Pro Git](https://git-scm.com/book/en/v2)
- [Git 中文教学](https://www.youtube.com/playlist?list=PLlyOkSAh6TwcvJQ1UtvkSwhZWCaM_S07d)
- [Learn Git Branching](https://learngitbranching.js.org/)
- [DIY a Git](https://space.bilibili.com/18777618/channel/collectiondetail?sid=2067230)
- [ugit](https://github.com/rafifos/ugit)
- [动手学习GIT - 最好学习 GIT 的方式是从零开始做一个](https://zhuanlan.zhihu.com/p/608514754)
- [Git 基本原理](https://www.bilibili.com/video/BV1TA411q75f)
