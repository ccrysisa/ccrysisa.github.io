---
title: Git/GitHub 学习指引
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
  - Git/GitHub
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
lightgallery: false
password:
message:
repost:
  enable: true
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

## Git 中文教学

新手入门推荐，对于 Git 的入门操作讲解十分友好。

- [视频地址](https://youtu.be/LZ4oOzZwgrk)
- [学习记录]({{< relref "git-learn" >}})

## Git 常见问题及解决

### git pull/push 遇到 Port 22 connect timeout

网络问题导致 22 端口被禁止，无法正常使用 ssh。切换成 443 端口并且编写配置文件即可：

```bash
$ vim ~/.ssh/config
# In ~/.ssh/config
Host github.com
HostName ssh.github.com
POrt 443
```

## References

- [Git 基本原理](https://www.bilibili.com/video/BV1TA411q75f)
- [Learn Git Branching](https://learngitbranching.js.org/)
- [ugit](https://github.com/rafifos/ugit)
- [动手学习GIT - 最好学习GIT的方式是从零开始做一个](https://zhuanlan.zhihu.com/p/608514754)
