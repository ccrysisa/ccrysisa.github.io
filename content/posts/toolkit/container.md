---
title: Container
subtitle:
date: 2024-08-22T12:47:26+08:00
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

<!--more-->

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

- [Docker and Kubernetes Tutorial for Beginners](https://www.youtube.com/playlist?list=PLy7NrYWoggjwPggqtFsI_zMAwvG0SqYCb)

## Linux Containers

### Writing a Container in Rust

- [Writing a Container in Rust](https://litchipi.site/serie/containers_in_rust) ([older version](https://litchipi.github.io/series/container_in_rust))
- [Linux containers in 500 lines of code](https://blog.lizzie.io/linux-containers-in-500-loc.html)

#### Introduction to containers

> A container is an isolated execution environment providing an abstraction between a software to be executed and the underlying operating system. It can be seen as a software virtualisation process.

即以 software 为中心的虚拟化 (Virtualisation)，让 software 有一种在特定的 OS 环境下执行 / 运行的错觉。

#### Starting the project

主要是解析命令行参数并根据参数设置相应的日志输出等级。

## Papers

- Quark: A High-Performance Secure Container Runtime for Serverless Computing
- Performance Evaluation of Container Runtimes
- RunD: A Lightweight Secure Container Runtime for High-density Deployment and High-concurrency Startup in Serverless Computing
- Towards Improving Container Security by Preventing Runtime Escapes
- Aristotle Cloud Federation: Container Runtimes Technical Report

## References

