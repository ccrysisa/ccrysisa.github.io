---
title: Container
subtitle:
date: 2024-08-22T12:47:26+08:00
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
  - Container
  - Docker
categories:
  - Toolkit
  - Go
  - Rust
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

> In software engineering, containerization is operating-system–level virtualization or application-level virtualization over multiple network resources so that software applications can run in isolated user spaces called containers in any cloud or non-cloud environment, regardless of type or vendor.

<!--more-->

- Wikipedia: [Containerization (computing)](https://en.wikipedia.org/wiki/Containerization_(computing))

## Install

deepin 20.9 虽然基于 debian 10.10，但是为了适配 deepin 特色的 DDE (Deepin Desktop Environment) 而进行了大量的魔改，所以按照 Docker 官方文档的 debian 安装一节是无法成功安装的。鉴于此，建议使用编译好的二进制 (Binaries) 在 deepin 上安装 Docker。

- [Install Docker Engine from binaries](https://docs.docker.com/engine/install/binaries/)

{{< admonition >}}
由于一些未知原因，建议使用一个 shell 启动 docker daemon 再使用另一个 shell 来运行 docker application。
{{< /admonition >}}

Docker Compose 也是通过手动安装:

- [Install the Compose plugin](https://docs.docker.com/compose/install/linux/#install-the-plugin-manually)

## Configuration

> If you need to start the daemon with additional options, modify the above command accordingly or create and edit the file `/etc/docker/daemon.json` to add the custom configuration options.

在 `/etc/docker/daemon.json` 可以配置 docker daemon 的代理以及 docker pull 下来的 images 所在的路径:

- [Daemon data directory](https://docs.docker.com/engine/daemon/#daemon-data-directory)
- [Configure the daemon to use a proxy](https://docs.docker.com/engine/daemon/proxy/)

```json
{
  "data-root": "/mnt/docker-data",
  "proxies": {
    "http-proxy": "http://proxy.example.com:3128",
    "https-proxy": "https://proxy.example.com:3129",
    "no-proxy": "*.test.example.com,.example.org,127.0.0.0/8"
  }
}
```

配置 `docker` 命令无需使用 `sudo` 提升权级:

- [Linux post-installation steps for Docker Engine](https://docs.docker.com/engine/install/linux-postinstall/)

## Usage

- Docker Docs: [Get started](https://docs.docker.com/get-started/)
- [A Docker Tutorial for Beginners](https://docker-curriculum.com/#webapps-with-docker)
- YouTube: [Docker and Kubernetes Tutorial for Beginners](https://www.youtube.com/playlist?list=PLy7NrYWoggjwPggqtFsI_zMAwvG0SqYCb)

## Container Runtime

### Infrastructures

- Wikipedia: [Linux namespaces](https://en.wikipedia.org/wiki/Linux_namespaces)
- Linux manual page: [namespaces(7)](https://man7.org/linux/man-pages/man7/namespaces.7.html)
- [How Docker Works - Intro to Namespaces](https://www.youtube.com/watch?v=-YnMr1lj4Z8) ([中文翻译](https://www.bilibili.com/video/BV1JZ4y1m7Pv))

### Projects

- [Writing a Container in Rust](https://litchipi.site/serie/containers_in_rust) ([older version](https://litchipi.github.io/series/container_in_rust))
- [Linux containers in 500 lines of code](https://blog.lizzie.io/linux-containers-in-500-loc.html)
- [PURA - Lightweight & OCI-compliant container runtime](https://github.com/ccrysisa/pura)

### Seminars

- [Building a container from scratch in Go - Liz Rice (Microscaling Systems)](https://www.youtube.com/watch?v=Utf-A4rODH8)
- [Containers From Scratch • Liz Rice • GOTO 2018](https://www.youtube.com/watch?v=8fi7uSYlOdc)
- [Containers from scratch: The sequel - Liz Rice (Aqua Security)](https://www.youtube.com/watch?v=_TsSmSu57Zo)
- [Rootless Containers from Scratch - Liz Rice, Aqua Security](https://www.youtube.com/watch?v=jeTKgAEyhsA)
- [Golang UK Conf. 2016 - Liz Rice - What is a container, really? Let's write one in Go from scratch](https://www.youtube.com/watch?v=HPuvDm8IC-4)
- [Container Security • Liz Rice & Eoin Woods](https://www.youtube.com/watch?v=FyRbFcGygdk)
- [Container Security • Liz Rice & Eoin Woods • GOTO 2020](https://www.youtube.com/watch?v=iXz4i2EbB4M)

### Papers

- gitee: [awesome-lightweight-virtualization-papers](https://gitee.com/enfangcui/awesome-lightweight-virtualization-papers)
- CNTR: Lightweight OS Containers ([cntr](https://github.com/Mic92/cntr))
- Quark: A High-Performance Secure Container Runtime for Serverless Computing ([Seminar](https://www.youtube.com/watch?v=xpMPMt9JEX8))
- RunD: A Lightweight Secure Container Runtime for High-density Deployment and High-concurrency Startup in Serverless Computing ([Artifacts](https://github.com/chengjiagan/RunD_ATC22))
- Towards Improving Container Security by Preventing Runtime Escapes
- Performance Evaluation of Container Runtimes
- Aristotle Cloud Federation: Container Runtimes Technical Report

## CNTR: Lightweight OS Containers

主要是使用轻量级的容器镜像 (去除了运行时不需要的工具) 来提升容器的性能，然后通过 FUSE 来对文件系统的调用进行重定向，使得容器可以使用主机或其他容器镜像内的工具，但并不会影响容器镜像的大小。
