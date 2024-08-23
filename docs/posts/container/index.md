# Container


<!--more-->

## Install

deepin 20.9 虽然基于 debian 10.10，但是为了适配 deepin 特色的 DDE (Deepin Desktop Environment) 而进行了大量的魔改，所以按照 Docker 官方文档的 debian 安装一节是无法成功安装的。鉴于此，建议使用编译好的二进制 (Binaries) 在 deepin 上安装 Docker。

- [Install Docker Engine from binaries](https://docs.docker.com/engine/install/binaries/)

{{< admonition >}}
由于一些未知原因，建议使用一个 shell 启动 docker daemon 再使用另一个 shell 来运行 docker application。
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

## References

- [Docker and Kubernetes Tutorial for Beginners](https://www.youtube.com/playlist?list=PLy7NrYWoggjwPggqtFsI_zMAwvG0SqYCb)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/container/  

