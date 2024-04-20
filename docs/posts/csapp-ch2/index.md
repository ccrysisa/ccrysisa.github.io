# CS:APP 第 2 章重点提示和练习


&gt; 千万不要小看数值系统，史上不少有名的 [软体缺失案例](https://hackmd.io/@sysprog/software-failure) 就因为开发者未能充分掌握相关议题，而导致莫大的伤害与损失。

&lt;!--more--&gt;

- {{&lt; link href=&#34;https://hackmd.io/@sysprog/CSAPP-ch2&#34; content=&#34;原文地址&#34; external-icon=true &gt;}}

搭配 CMU: 15-213: Intro to Computer Systems: Schedule for Fall 2015
- 可以在 [这里](https://www.cs.cmu.edu/afs/cs/academic/class/15213-f15/www/schedule.html) 找到相关的投影片和录影
- B 站上有一个汉化版本的 [录影](https://www.bilibili.com/video/BV1iW411d7hd/)

## 数值系统

### 导读

- [x] YouTube: [十进制，十二进制，六十进制从何而来？](https://www.youtube.com/watch?v=8J7sAYoG50A)
- [x] YouTube: [老鼠和毒药问题怎么解？二进制和易经八卦有啥关系？](https://www.youtube.com/watch?v=jYQEkkwUBxQ)
- [x] YouTube: [小精靈遊戲中的幽靈是怎麼追蹤人的? 鮮為人知的 bug](https://www.youtube.com/watch?v=jYQEkkwUBxQ)
- [X] [解读计算机编码](https://hackmd.io/@sysprog/binary-representation)
- [ ] [你所不知道的 C 语言: 未定义/未指定行为篇](https://hackmd.io/@sysprog/c-undefined-behavior)
- [x] [你所不知道的 C 语言: 数值系统篇](https://hackmd.io/@sysprog/c-numerics)
- [x] [基于 C 语言标准研究与系统程式安全议题](https://hackmd.io/@sysprog/c-std-security)
- 熟悉浮点数每个位的表示可以获得更大的最佳化空间
  - [ ] [Faster arithmetic by flipping signs](https://nfrechette.github.io/2019/05/08/sign_flip_optimization/)
  - [ ] [Faster floating point arithmetic with Exclusive OR](https://nfrechette.github.io/2019/10/22/float_xor_optimization/)

&gt; 看了上面的第 3 个影片后，对 pac-man 256 莫名感兴趣 :rofl:

### Bits, Bytes &amp; Integers


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/csapp-ch2/  

