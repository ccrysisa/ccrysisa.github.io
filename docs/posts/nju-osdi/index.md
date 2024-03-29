# 南京大学 操作系统: 设计与实现 重点提示


操作系统使用正确的抽象使构造庞大的计算机软件/硬件生态从不可能变为可能。这门课围绕操作系统是 **如何设计** (应用程序视角)、**怎样实现** (硬件视角) 两个角度展开，分为两个主要部分：

原理课 (并发/虚拟化/持久化)：以教科书内容为主，介绍操作系统的原理性内容。课程同时注重讲解操作系统相关的代码实现和编程技巧，包括操作系统中常用的命令行/代码工具、教学操作系统 xv6 的代码讲解等

理解操作系统最重要的实验部分:
- Mini labs (应用程序视角；设计)：通过实现一系列有趣的 (黑科技) 代码理解操作系统中对象存在的意义和操作系统 API 的使用方法、设计理念
- OS labs (计算机硬件视角；实现)：基于一个简化的硬件抽象层实现多处理器操作系统内核，向应用程序提供一些基础操作系统 API

<!--more-->

---

时隔一年，在跟随 B 站 up 主 [@踌躇月光](https://space.bilibili.com/491131440/) 从零编写一个基于 x86 架构的内核 [Txics](https://github.com/vanJker/TXOS) 后，终于可以跟得上 [@绿导师](https://space.bilibili.com/202224425) 的课程了 :rofl: 这次以 [2022 年的 OS 课程](https://jyywiki.cn/OS/2022/index.html) 作为主线学习，辅以 [2023 年课程](https://jyywiki.cn/OS/2023/index.html) 和 [2024 年课程](https://jyywiki.cn/OS/2024/index.html) 的内容加以补充、扩展，并搭配南大的 ICS 课程进行作业，后期可能会加入清华大学的 rCore 实验 (待定)。

{{< image src="https://jyywiki.cn/pages/OS/img/tux-source.jpg" >}}

{{< admonition question >}}
JYY 2022 年的 OSDI 课程讲义和阅读材料是分开的，2023 年和 2024 年进行了改进，讲义和阅读材料合并成类似于共笔的材料，所以下面有一些 lectures 是没有阅读材料链接的。
{{< /admonition >}}

## 第 1 周: 绪论

### 操作系统概述 (为什么要学操作系统)

{{< link href="https://www.bilibili.com/video/BV1Cm4y1d7Ur/" content="直播录影" external-icon=true >}}
|
{{< link href="https://jyywiki.cn/OS/2022/slides/1.slides.html" content="讲义页面" external-icon=true >}}
|
{{< link href="https://jyywiki.cn/OS/2022/notes/1.html" content="阅读材料" external-icon=true >}}

---

一个 Talk 的经典三段式结构: Why? What? How? (这个真是汇报的大杀器 :rofl:)

1950s 的计算机
- I/O 设备的速度已经严重低于处理器的速度，中断机制出现 (1953)
- 希望使用计算机的人越来越多；希望调用 API 而不是直接访问设备
- 批处理系统 = 程序的自动切换 (换卡) + 库函数 API
- 操作系统中开始出现 *设备*、*文件*、*任务* 等对象和 API

1960s 的计算机
- 可以同时载入多个程序而不用 “换卡” 了
- 能载入多个程序到内存且灵活调度它们的管理程序，包括程序可以调用的 API
- 既然操作系统已经可以在程序之间切换，为什么不让它们定时切换呢？

操作系统机制出现和发展的原因，不需要死记硬背，这些机制都是应需求而诞生、发展的，非常的自然。

实验环境: deepin 20.9
```bash
$ uname -a
Linux cai-PC 5.15.77-amd64-desktop #2 SMP Thu Jun 15 16:06:18 CST 2023 x86_64 GNU/Linux
```

安装 tldr:
```bash
$ sudo apt install tldr
```

有些系统可能没有预装 man 手册:
```bash
$ sudo apt install manpages
```

### 操作系统上的程序 (什么是程序和编译器)

{{< link href="https://www.bilibili.com/video/BV12L4y1379V/" content="直播录影" external-icon=true >}}
|
{{< link href="https://jyywiki.cn/OS/2022/slides/2.slides.html" content="讲义页面" external-icon=true >}}
|
{{< link href="https://jyywiki.cn/OS/2022/notes/1.html" content="阅读材料" external-icon=true >}}

---

UNIX 哲学:
- Make each program do one thing well
- Expect the output of every program to become the input to another

只使用纯"计算"的指令 (无论是 deterministic 还是 non-deterministic) 无法使程序停下来，因为将程序本质是状态机，而状态机通过“计算”的指令只能从一个状态迁移到另一个状态，无法实现销毁状态机的操作 (对应退出/停下程序)，要么死循环，要么 undefined behavior。这时需要程序对应的状态机之外的另一个东西来控制、管理该状态机，以实现程序的停下/退出操作，这就是 OS 的 syscall 存在的意义，它可以游离在程序对应的状态机之外，并修改状态机的内容 (因为程序呼叫 syscall 时已经全权授予 OS 对其状态内容进行修改)。

空的 _start 函数可以成功编译并链接，但是由于函数是空的，它会编译生成 `retq` 指令，这会导致 pc 跳转到不合法的区域，而正确的做法应该是使用 `syscall exit` 来结束该程序 (熟悉 C 语言函数调用的同学应该能看懂这段描述)。

## 第 2 周: 并发


---

> 作者: [vanJker](https://github.com/vanJker)  
> URL: https://ccrysisa.github.io/posts/nju-osdi/  

