# Git/GitHub 学习指引


## Git 中文教学

新手入门推荐，对于 Git 的入门操作讲解十分友好。

- [视频地址](https://youtu.be/LZ4oOzZwgrk)
- [学习记录]({{&lt; relref &#34;git-learn&#34; &gt;}})

## Git 常见问题及解决

### git pull/push 遇到 Port 22 connect timeout

<<<<<<< HEAD
网络问题导致 22 端口被禁止，无法正常使用 ssh。切换成 443 端口并且编写配置文件即可：

```bash
$ vim ~/.ssh/config
# In ~/.ssh/config
Host github.com
HostName ssh.github.com
POrt 443
```
=======
- [视频地址](https://www.bilibili.com/video/BV1TA411q75f)
- [学习记录]({{&lt; relref &#34;&#34; &gt;}})

## Learn Git Branching

交互性学习 Git 的网站，可以边玩边学 Git 操作，趣味性 MAX（来自 THUer 的推荐）。

- [网站地址](https://learngitbranching.js.org/)
- [学习记录]({{&lt; relref &#34;&#34; &gt;}})

## ugit

动手造一个 Mini Git，锻炼代码能力和加深原理理解。建议初步理解 Git 原理后再来挑战这个轮子。

- [仓库地址](https://github.com/rafifos/ugit)
- [教程地址](https://www.leshenko.net/p/ugit/)
>>>>>>> network

## References

- [Git 基本原理](https://www.bilibili.com/video/BV1TA411q75f)
- [Learn Git Branching](https://learngitbranching.js.org/)
- [ugit](https://github.com/rafifos/ugit)
- [动手学习GIT - 最好学习GIT的方式是从零开始做一个](https://zhuanlan.zhihu.com/p/608514754)


---

> 作者: [Xshine](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/git/  

