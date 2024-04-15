# Ubuntu 22.04LTS 相关配置


## 网络代理

根据项目 [clash-for-linux-backup][cflbp] 来配置 Ubuntu 的网络代理。

```bash
$ git clone https://github.com/Elegybackup/clash-for-linux-backup.git clash-for-linux
```

过程当中可能需要安装 curl 和 net-tools，根据提示进行安装即可：

- `sudo apt install curl`
- `sudo apt install net-tools`

安装并启动完成后，可以通过 `localhost:9090/ui` 来访问 Dashboard。

启动代理：

```bash
$ cd clash-for-linux
$ sudo bash start.sh
$ source /etc/profile.d/clash.sh
$ proxy_on
```

关闭代理：

```bash
$ cd clash-for-linux
$ sudo bash shutdown.sh
$ proxy_off
```

## 搜狗输入法

根据 [搜狗输入法 Linux 安装指导][sougou-linux-guide] 来安装搜狗输入法。

- 安装时无需卸载系统 ibus 输入法框架 (与上面的安装指导不一致)
- 通过 `Ctrl &#43; space` 唤醒搜狗输入法
- 通过 `Ctrl &#43; Shift &#43; Z` 呼出特殊符号表

## 快捷键

新建终端：
- `Ctrl &#43; Alt &#43; T`

锁屏：
- `Super &#43; L`：锁定屏幕并熄屏。

显示桌面：
- `Super &#43; d` 或者 `Ctrl &#43; Alt &#43; d` 最小化所有运行的窗口并显示桌面，再次键入则重新打开之前的窗口。

显示所有的应用程序：
- `Super &#43; a` 
- 可以通过 `ESC` 来退出该显示。

显示当前运行的所有应用程序：
- `Super`

移动窗口位置：
- `Super &#43; 左箭头`：当前窗口移动到屏幕左半边区域
- `Super &#43; 右箭头`：当前窗口移动到屏幕右半边区域
- `Super &#43; 上箭头`：当前窗口最大化
- `Super &#43; 下箭头`：当前窗口恢复正常

隐藏当前窗口到任务栏：
- `Super &#43; h`

切换当前的应用程序：
- `Super &#43; Tab`：以应用程序为粒度显示切换选项
- `Alt &#43; Tab`：以窗口为粒度显示切换选项

切换虚拟桌面/工作区：
- `Ctrl &#43; Alt &#43; 左/右方向键`

自定义键盘快捷键：
- **Settings -&gt; Keyboard -&gt; Keyboard Shortcus | View and Customize Shortcuts -&gt; Custom Shortcuts**


[cflbp]: https://github.com/Elegybackup/clash-for-linux-backup
[sougou-linux-guide]: https://shurufa.sogou.com/linux/guide


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/ubuntu22.04lts/  

