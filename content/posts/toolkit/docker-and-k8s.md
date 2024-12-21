---
title: "Docker/Kubernetes 使用指南"
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
  - Kubernetes
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

> In software engineering, containerization is operating-system–level virtualization or application-level virtualization over multiple network resources so that software applications can run in isolated user spaces called containers in any cloud or non-cloud environment, regardless of type or vendor.

<!--more-->

- Wikipedia: [Containerization (computing)](https://en.wikipedia.org/wiki/Containerization_(computing))

## Install

deepin 20.9/V23 虽然基于 Debian，但是为了适配 deepin 特色的 DDE (Deepin Desktop Environment) 而进行了大量的魔改，所以按照 Docker 官方文档的 Debian 安装一节是无法成功安装的。鉴于此，建议使用编译好的二进制 (Binaries) 在 deepin 上安装 Docker。

- [Install Docker Engine from binaries](https://docs.docker.com/engine/install/binaries/)

```sh
# Install and setup prerequisites
$ sudo apt update
$ sudo apt install iptables git ps xz
# Download properly mounted `cgroupfs` hierarchy from 
# https://github.com/tianon/cgroupfs-mount/blob/master/cgroupfs-mount
# Then execute this script
$ sudo bash cgroupfs-mount

# Download sepcific version of docker engine from https://download.docker.com/linux/static/stable/
# Then unzip since sudo coundl only execute bin which belong to root
$ tar xzvf /path/to/FILE.tar.gz 
$ sudo cp docker/* /usr/bin/
# now you can remove tar and it's unzip directory

# Run and test docker engine
$ sudo dockerd
# In other shell
$ sudo docker run hello-world
```

更新 docker 版本与上面安装的步骤类似。另外，Docker Compose 也可以手动安装二进制可执行文件:

- [Install the Compose plugin](https://docs.docker.com/compose/install/linux/#install-the-plugin-manually)

```sh
$ sudo mkdir -p /usr/local/lib/docker/cli-plugins
$ sudo curl -SL https://github.com/docker/compose/releases/download/v2.32.0/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
$ sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
$ docker compose version
```

{{< admonition tip >}}
对于二进制文件的安装方法，建议使用一个 shell 启动 docker daemon，再使用另一个 shell 来运行 docker application，这样能确保退出 docker daemon 而不是放任其一直在后台运行。
{{< /admonition >}}

如果是按照上面的方法安装的 docker 以及相关套件，那么 uninstall 它们的命令为:

```sh
$ sudo rm -rf containerd containerd-shim-runc-v2 ctr docker dockerd docker-init docker-proxy runc
$ sudo rm -rf /usr/local/lib/docker/
```

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

> 清理不需要使用的 container(s)、image(s) 等资源: [Prune unused Docker objects](https://docs.docker.com/engine/manage-resources/pruning/)

```sh
$ sudo docker image prune
$ sudo docker container prune
$ sudo docker volume prune
$ sudo docker network prune
# purn everying including images, containers, and networks, but volumes aren't pruned by default.
$ sudo docker system prune
```

## Concepts

Stack Overflow: [What is the difference between a Docker image and a container?](https://stackoverflow.com/questions/23735149/what-is-the-difference-between-a-docker-image-and-a-container)

{{< admonition quote >}}
**Dockerfile** → (Build) → **Image** → (Run) → **Container**.

- **Dockerfile**: contains a set of Docker instructions that provisions your operating system the way you like, and installs/configure all your software.

- **Image**: compiled Dockerfile. Saves you time from rebuilding the Dockerfile every time you need to run a container. And it's a way to hide your provision code.

- **Container**: the virtual operating system itself. You can ssh into it and run any commands you wish, as if it's a real environment. You can run 1000+ containers from the same Image.
{{< /admonition >}}
