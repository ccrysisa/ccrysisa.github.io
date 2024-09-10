---
title: "openSUSE: Open Build Service (OBS)"
subtitle:
date: 2024-09-01T21:51:25+08:00
# draft: true
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
  - openSUSE
  - Open Build Service
  - OBS
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
lightgallery: true
password:
message:
repost:
  enable: true
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

<!--more-->

## RPM Packaging Tutorial

- [RPM Packaging Tutorial](https://www.zq1.de/~bernhard/mirror/duncan.codes/tutorials/rpm-packaging/)

> Features like an automatical finding of the required packages and retrieving them are implemented in higher-level tools like `zypper`.

```goat
+--------+                     
| zyyper |                     
+--------+                     
|  rpm   |                     
+--------+                     
```

`Requires` 和 `Provides` 字段处可以指定软件包的具体路径，这样类似于硬编码直接查询指定路径是否存在该软件，也可以指定软件包名，这样操作系统就会扫描系统上可用的软件匹配对对应的软件包名。

Repository:

- a `x86_64` directory containing all architecture-dependent packages (i.e. ones that contain executables, shared libraries, etc)
- a `noarch` directory containing architecture-independent packages (i.e. ones containing data or scripts)
- a `repodata` directory, containing the metadata for all packages.

## References

- reddit: [How Learn to use openSUSE Build Service (OBS)](https://www.reddit.com/r/openSUSE/comments/yk1vwe/how_learn_to_use_opensuse_build_service_obs/)
