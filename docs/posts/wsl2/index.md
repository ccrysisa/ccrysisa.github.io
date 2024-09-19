# Windows 10 WSL2 Ubuntu 22.04 配置指南


今日闲来无事，刷了会 B 站，突发奇想将发灰了一年多的 WSL2 找回来折腾一下 (之前为了在 VMware 中开启嵌套虚拟化，不得以将 WSL2 打入冷宫 :rofl:)。由于这一年内功功力大涨，很快就完成了 WLS2 的再召集启用，下面列出配置的主要步骤和相关材料。

<!--more-->

操作系统: Windows 10

## 安装 WSL2 和 Linux 发行版

{{< bilibili BV1mX4y177dJ >}}

1. 启用或关闭 Windows 功能
   - [x] 适用于 Linux 的 Windows 子系统
   - [x] 虚拟机平台

2. 以管理员身份运行 PowerShell
```bash
> bcdedit /v
...
hypervisorlaunchtype    Auto
# 保证上面这个虚拟化选项是 Auto，如果是 Off 则使用下面命令设置
> bcdedit /set hypervisorlaunchtype auto
```

3. 在 PowerShell 中安装 wsl2
```bash
> wsl --update
> wsl --set-default-version 2
> wsl -l -o
NAME                                   FRIENDLY NAME
...
Ubuntu-18.04                           Ubuntu 18.04 LTS
Ubuntu-20.04                           Ubuntu 20.04 LTS
Ubuntu-22.04                           Ubuntu 22.04 LTS
...
> wsl --install Ubuntu-22.04
# 后面需要创建用户和密码，自行设置
```

> 上面以 Ubuntu2 22.04 发行版为例，你也可以安装其它的发行版。安装过程中可能会出现无法访问源 / 仓库的问题，这个是网络问题，请自行通过魔法/科学方法解决

## 迁移至非系统盘

{{< bilibili BV1EF4m1V7pp >}}

以管理员身份运行 PowerShell

```bash
# 查看已安装的 Linux 发行版
> wsl -l- v
# 停止正在运行的发行版
> wsl --shutdown
# 导出发行版的镜像 (以 Ubuntu 22.04 为例)
> wsl --export Ubuntu-22.04 D:/ubuntu.tar
# 导出镜像后，卸载原有发行版以释放 C 盘空间
> wsl --unregister Ubuntu-22.04
# 重新导入发行版镜像。并指定该子系统储存的目录 (即进行迁移)
> wsl --import Ubuntu-22.04 D:\Ubuntu\ D:\ubuntu.tar --version 2
# 上面命令完成后，在目录 D:\Ubuntu 下会出现名为 ext4.vhdx 的文件，这个就是子系统的虚拟磁盘
# 设置启用子系统时的默认用户 (建议使用迁移前创建的用户)，否则启动子系统时进入的是 root 用户
> ubuntu-22.04.exe config --default-user <username>
```

## Windows Terminal 美化

{{< bilibili BV1GM4m1X7s3 >}}

## 其它

目前 Windows 10 上的 WSL2 应该都支持 WSLg (如果你一直更新的话)，可以使用 gedit 来测试一下 WLSg 的功能，可以参考微软的官方文档:

- {{< link href="https://github.com/microsoft/wslg" content="https://github.com/microsoft/wslg" external-icon=true >}}

## 效果展示

{{< image src="/images/tools/ubuntu-22.04-wsl2.png" >}}


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/wsl2/  

