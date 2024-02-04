# Git/GitHub 资源与问题汇总


## Git 中文教学

新手入门推荐，对于 Git 的入门操作讲解十分友好。

- [视频地址](https://youtu.be/LZ4oOzZwgrk)
- [学习记录]({{&lt; relref &#34;git-learn&#34; &gt;}})

## Git 常见问题及解决

### git pull/push 遇到 Port 22 connect timeout

网络问题导致 22 端口被禁止，无法正常使用 ssh。切换成 443 端口并且编写配置文件即可：

```bash
$ vim ~/.ssh/config
# In ~/.ssh/config
Host github.com
HostName ssh.github.com
Port 443
```

## References

- [Git 基本原理](https://www.bilibili.com/video/BV1TA411q75f)
- [Learn Git Branching](https://learngitbranching.js.org/)
- [ugit](https://github.com/rafifos/ugit)
- [动手学习GIT - 最好学习GIT的方式是从零开始做一个](https://zhuanlan.zhihu.com/p/608514754)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/git/  

