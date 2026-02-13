---
title: "Docker 使用指南"
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

- Wikipedia: [Containerization (computing)](<https://en.wikipedia.org/wiki/Containerization_(computing)>)

## Install

**2026/2/13** 更新: 在 deepin V23 上可以参考以下两篇文章，实现通过 apt 包管理器来安装 docker。

- [Installing Docker on Linux: Deepin 23: an update to Francisco Dara’s guide.](https://medium.com/@kbooster17/installing-docker-on-linux-deepin-23-an-update-to-francisco-daras-guide-cbbeb119f1c2)
- [Deepin V23 系统下 Docker 安装与配置全流程指南](https://comate.baidu.com/zh/page/tj3s8xpc4v0)

---

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
$ tar xzvf /path/to/FILE.tar.gz
$ sudo cp docker/* /usr/bin/
# now you can remove tar and it's unzip directory and files

# Run and test docker engine
$ sudo dockerd
# In other shell
$ sudo docker run hello-world
```

更新 docker 版本与上面安装的步骤类似。另外，Docker Compose 也可以手动安装二进制可执行文件:

- [Install the Compose plugin](https://docs.docker.com/compose/install/linux/#install-the-plugin-manually)

```sh
$ sudo mkdir -p /usr/local/lib/docker/cli-plugins
$ sudo curl -SL https://github.com/docker/compose/releases/download/<VERSION>/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
$ sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
$ docker compose version
```

{{< admonition tip >}}
对于二进制文件的安装方法，建议使用一个 shell 启动 docker daemon (个人推荐使用 deepin 的终端雷神模式来启动 docke daemon)，再使用另一个 shell 来运行 docker application，这样能确保退出 docker daemon 而不是放任其一直在后台运行。当然你也可以通过 `ps` 方法找到 docker daemon 进程然后 kill 掉，只不过比较繁琐。
{{< /admonition >}}

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

## Uninstall

如果是按照上面的方法安装配置的 docker 以及相关套件，那么 uninstall 它们的命令为:

```sh
$ cd /usr/bin/
$ sudo rm -rf containerd containerd-shim-runc-v2 ctr docker dockerd docker-init docker-proxy runc
$ sudo rm -rf /usr/local/lib/docker/ /etc/docker/ /mnt/docker-data/
```

## Concepts

Wkipedia:

{{< admonition type=info title="[LXC](https://en.wikipedia.org/wiki/LXC)" open=false >}}
**Linux Containers (LXC)** is an operating system-level virtualization method for running multiple isolated Linux systems (containers) on a control host using a single Linux kernel.
{{< /admonition >}}

{{< admonition type=info title="[Docker](https://en.wikipedia.org/wiki/Docker_(software))" open=false >}}
**Docker** is a set of platform as a service (PaaS) products that use OS-level virtualization to deliver software in packages called containers.
{{< /admonition >}}

Stack Overflow:

{{< admonition type=question title="[What is the difference between a Docker image and a container?](https://stackoverflow.com/questions/23735149/what-is-the-difference-between-a-docker-image-and-a-container)" open=false >}}
**Dockerfile** → (Build) → **Image** → (Run) → **Container**.

- **Dockerfile**: contains a set of Docker instructions that provisions your operating system the way you like, and installs/configure all your software.

- **Image**: compiled Dockerfile. Saves you time from rebuilding the Dockerfile every time you need to run a container. And it\'s a way to hide your provision code.

- **Container**: the virtual operating system itself. You can ssh into it and run any commands you wish, as if it\'s a real environment. You can run 1000+ containers from the same Image.
  {{< /admonition >}}

{{< admonition type=question title="[Does the code gets copied from docker image to docker container](https://stackoverflow.com/questions/72820548/does-the-code-gets-copied-from-docker-image-to-docker-container)" open=false >}}
Does everything in the image get copied over to the container?

> Yes. A container is like an instance of the image.

If the same image is used among all the containers, then how does docker handle when a file is changed in a container?

> The change will only affect the container in which the change was made. It does not affect the image nor any other containers using the same image (unless the change was made to a file on a volume that multiple containers share).
> {{< /admonition >}}

{{< admonition type=question title="[Difference between KVM and LXC](https://stackoverflow.com/questions/20578039/difference-between-kvm-and-lxc)" open=false >}}
LXC, or Linux Containers are the lightweight and portable OS based virtualization units which share the base operating system\'s kernel, but at same time act as an isolated environments with its own filesystem, processes and TCP/IP stack. They can be compared to Solaris Zones or Jails on FreeBSD. As there is no virtualization overhead they perform much better then virtual machines.

KVM represents the virtualization capabilities built in the own Linux kernel. As already stated in the previous answers, it\'s the hypervisor of type 2, i.e. it\'s not running on a bare metal.
{{< /admonition >}}

## Usage

### 基本指令

{{< admonition >}}

- 获取镜像: `docker pull [Registry]Repo Name[:Tag]`

- 新建并启动容器: `docker run [-d] [--name <Name>] [-p <host port>:<conatiner port>] Image Name[:Tag]`

- 停止指定容器: `docker stop <CONTAINER_ID or CONATINER_NAME>`

- 启动停止或终止的指定容器: `docker start <CONTAINER_ID or CONATINER_NAME>`

- 重新启动指定容器: `docker restart <CONTAINER_ID or CONATINER_NAME>`

- 列出本地拥有的镜像: `docker image ls`

- 列出当前所有容器: `docker ps -a`

- 删除指定镜像: `docker rmi <IMAGE_ID or REPO:TAG>`

- 删除指定容器: `docker rm <CONTAINER_ID or CONATINER_NAME>`
  {{< /admonition >}}

docker 的端口映射的作用是让主机和容器之间有一条通信的桥梁，以实现通过主机被映射的端口来访问容器内的本地服务,例如将主机的 12345 端口和容器的 1313 端口相映射，可以在主机上通过 `localhost:12345` 来访问在容器内运行的 hugo 实例。

清理未使用的 container(s)、image(s) 等资源: [Prune unused Docker objects](https://docs.docker.com/engine/manage-resources/pruning/)

```sh
$ docker image prune
$ docker container prune
$ docker network prune
$ docker volume prune

# purn everying including images, containers, and networks, but volumes aren't pruned by default.
$ docker system prune
```

### Dockerfile

以下摘抄自 Dockerfile 的[官方文档](https://docs.docker.com/reference/dockerfile/):

The `FROM` instruction initializes a new build stage and sets the base image for subsequent instructions. As such, a valid Dockerfile must start with a `FROM` instruction. The image can be any valid image.

The `RUN` instruction will execute any commands to create a new layer on top of the current image. The added layer is used in the next step in the Dockerfile.

The purpose of a `CMD` is to provide defaults for an executing container. These defaults can include an executable, or they can omit the executable, in which case you must specify an `ENTRYPOINT` instruction as well.

The `COPY` instruction copies new files or directories from `<src>` and adds them to the filesystem of the image at the path `<dest>`. Files and directories can be copied from the build context, build stage, named context, or an image.

An `ENTRYPOINT` allows you to configure a container that will run as an executable. Command line arguments to `docker run <image>` will be appended after all elements in an exec form `ENTRYPOINT`, and will override all elements specified using `CMD`.

The `WORKDIR` instruction sets the working directory for any `RUN`, `CMD`, `ENTRYPOINT`, `COPY` and `ADD` instructions that follow it in the Dockerfile. If the `WORKDIR` doesn't exist, it will be created even if it's not used in any subsequent Dockerfile instruction.

{{< admonition >}}
`CMD` 和 `ENTRYPOINT` 的区别在于 `ENTRYPOINT` 提供了一个不可变的容器启动入口，而 `CMD` 提供的只是默认的容器入口，可以被用户附加的参数改变，例如对于 Ubuntu 镜像而言，假如 `ENTRYPOINT` 为 `/bin/bash`，则用户无法改变这个入口的命令，只能附加一些参数给 `/bin/bash` 执行，而假如使用 `CMD`，那么 `/bin/bash` 只是默认的入口命令，用户可在启动容器时使用其它命令例如 `echo` 来替换掉这个 `bash` 命令。`CMD` 和 `ENTRYPOINT` 都是只有一条有效，若提供了多条 `CMD` 或 `ENTRYPOINT` 指令，则最后一条 `CMD` 或 `ENTRYPOINT` 指令会覆盖掉前面的指令。当 `CMD` 与 `ENTRYPOINT` 搭配使用时，`CMD` 会坍塌为 `ENTRYPOINT` 的默认参数，用户可以在容器启动时指定参数来覆盖这些默认参数。
{{< /admonition >}}

构建镜像命令:

```sh
$ docker build [-t <name[:tag]>] path
```

{{< admonition example >}}

```dockerfile
FROM golang:1.23-alpine
WORKDIR /app
COPY go.mod .
COPY main.go .
RUN go build -o main .
ENTRYPOINT ./main
```

{{< /admonition >}}

### Docker compose

Docker compose 通过一个 YAML 文件（通常为 `compose.yaml`）来定义和管理多个容器，一个简单的例子如下:

```yaml {title="compose.yaml"}
services:
  backend:
    image: <IMAGE_NAME>
  mysql:
    image: <IMAGE_NAME>
  redis:
    image: <IMAGE_NAME>
```

- `services`: 定义了需要管理和使用的容器的列表
  - `image`: 从指定镜像启动容器
  - `build`: 构建镜像
    - `context`: 指定 Dockerfile 的上下文路径
    - `dockerfile`: 指定 Dockerfile 对应的文件名，默认是 Dockerfile
    - `ports`: 建立主机端口和容器端口的映射关系，格式是 `HOST_PORT:CONTAINER_PORT`
    - `environment`: 设置服务运行的环境变量
- `networks`: 容器间的网络连接配置
- `volumes`: 具备持久性的数据卷的定义
- `depends_on`: 依赖配置项，用于设定服务启动和关闭的次序

{{< admonition type=quote title="[The Compose file](https://docs.docker.com/compose/intro/compose-application-model/#the-compose-file)" >}}
The default path for a Compose file is `compose.yaml` (preferred) or `compose.yml` that is placed in the working directory. Compose also supports `docker-compose.yaml` and `docker-compose.yml` for backwards compatibility of earlier versions. If both files exist, Compose prefers the canonical `compose.yaml`.
{{< /admonition >}}

## References

- bilibili: [零基础 Docker 快速上手教程「一个半小时上手 Docker | 综合开发教程」](https://www.bilibili.com/video/BV1sRcKeWExJ/)
- Docker Docs: [Get started](https://docs.docker.com/get-started/)
- [Dockerfile reference](https://docs.docker.com/reference/dockerfile/)
- [Compose file reference](https://docs.docker.com/reference/compose-file/)
- [A Docker Tutorial for Beginners](https://docker-curriculum.com/#webapps-with-docker)
- YouTube: [Docker and Kubernetes Tutorial for Beginners](https://www.youtube.com/playlist?list=PLy7NrYWoggjwPggqtFsI_zMAwvG0SqYCb)
