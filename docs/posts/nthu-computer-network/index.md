# 清大计算机网络 重点提示


{{&lt; admonition abstract &gt;}}
之前学校的计网理论课学得云里雾里，对于物理层和数据链路层并没有清晰的逻辑框架，而这学期的计网课设内容为数据链路层和网络层的相关内容，写起来还是云里雾里。虽然最终艰难地把课设水过去了，但是个人认为网络对于 CSer 非常重要，特别是在互联网行业，网络知识是必不可少的。
所以决定寒假重学计网，于是在 [HackMD](https://hackmd.io/) 上冲浪寻找相关资料。然后发现了这篇笔记 [110-1 計算機網路 (清大開放式課程)](https://hackmd.io/@0xff07/network/https%3A%2F%2Fhackmd.io%2F%400xff07%2FByADDQ57Y)，里面提到清大计网主要介绍 L2 ~ L4 一些著名的协议和算法，这完美符合个人的需求，而且该篇该笔还补充了一些额外的内容，例如 IPv6，所以当即准备搭配这篇笔记来学习清大的计算机网络概论。
{{&lt; /admonition &gt;}}

&lt;!--more--&gt;

## 清大计算机网络概论

&gt; 本課程將介紹計算機網路的基本運作原理與標準的網路七層結構,由淺入深,可以讓我們對於計算機網路的運作有最基本的認識,本課程還會介紹全球建置最多的有線網路──IEEE 802.3 Ethernet 的基本運作原理, 還有全球建置最多的無線區域網路──IEEE 802.11 Wireless LAN 的基本運作原理,  想知道網路交換機(switches) 是如何運作的嗎 ? 想知道網際網路最重要也最關鍵的通訊協議 ── TCP/IP 是如何運作的嗎 ? 想知道網際網路最重要的路由器 (Routers) 是如何運作的嗎 ? 在本課程裡您都可以學到這些重要的基本知識。

| 开课学校 | 课程主页 | 课程资料 | 课程影片 |
| :-----: | :----: | :-----: | :-----: |
| 國立清華大學 | [計算機網路概論][courseinfo] | [課程講義與練習題][slides&amp;hws] | [Youtube][playlist] |

## L1 Foundation 重点提示与练习

### Applications

{{&lt; image src=&#34;/images/network/L1-05.png&#34; caption=&#34;Foundation - 5&#34; &gt;}}

进行 1 次 URL request 需要进行 17 次的讯息交换：
- 6 次讯息交换用于查询 URL 对应的 IP Address
- 3 次讯息交换用于建立 TCP 连接（TCP 的 3 次握手）
- 4 次讯息交换用于 HTTP 协议的请求和回复
- 4 次讯息交换用于关闭 TCP 连接（TCP 的 4 次握手）

### Network Connectivity

{{&lt; image src=&#34;/images/network/L1-08.png&#34; caption=&#34;Foundation - 8&#34; &gt;}}

交换机 (Switches) 可以分为很多层级，即可以有不同层级的交换机，例如 L2 层的交换机，L3 层的交换机以及 L4 层的交换机。如何判断交换机是哪个层级？很简单，只需要根据交换机所处理的讯息，L2 层交换机处理的是 MAC Address，L3 层交换机处理的是 IP Address，而 L4 层交换机处理的是 TCP 或者 UDP 相关的讯息。

交换机 (Switches) 用于网络 (Network) 内部的连接，路由 (Router) 用于连接不同的网络 (Network)，从而形成 Internetwork。

地址 (Address)，对于网卡来说是指 MAC Address，对于主机来说是指 IP Address。Host-to-Host connectivity 是指不同网络 (Network) 的主机，即位于 Internetwork 的不同主机之间，进行连接。

### Network Architecture

{{&lt; image src=&#34;/images/network/L1-22.png&#34; caption=&#34;Foundation - 22&#34; &gt;}}

**Physical Layer:** 如何将原始资料在 link 上传输，例如不同介质、信息编码。(P25)

**Data Link Layer:** 在 Physical Layer 基础上，如何将 frame 传给直接相连的主机或设备，核心是通过 *Media Access Control Protocol* 解决 Multiple access 产生的碰撞问题。这一层交换的数据被称为 *frame*。(P26)

**Network Layer:** 在 Data Link Layer 基础上，如何将 packet 通过 Internet 送给目的地主机。核心是通过 *Routing Protocols* 动态转发 packet。这一层交换的数据被称为 *packet*。(P27)

**Transport Layer:** 在 Network Layer 基础上，提供不同主机 processes 之间的资料传送。由于 Networkd Layer 是主机间进行资料传送，所以在 Transport Layer 不论是可靠还是不可靠的传输协议，都必须要实现最基本的机制：主机与 process 之间数据的复用和分解。这一层交换的数据被称为 *message*。(P28)

{{&lt; admonition &gt;}}
Switch 一般处于 L2 Layer，Router 一般处于 L3 Layer。L4 Layer 及以上的 layers 通常只存在于 hosts，switches 和 routers 内部一般不具有这些 layers。(P29)

Internet Architecture 的层级并不是严格的，Host 可以略过 Application Layer 而直接使用 Transport Layer、Network Layer 中的协议。(P30)

Internet Architecture 的核心是 IP 协议，它作为沙漏形状的中心位置，为处于其上层的协议与处于其下层协议之间提供了一个映射关系。(P31)
{{&lt; /admonition &gt;}}

### Network Performance

{{&lt; image src=&#34;/images/network/L1-36.png&#34; caption=&#34;Foundation - 36&#34; &gt;}}
{{&lt; image src=&#34;/images/network/L1-37.png&#34; caption=&#34;Foundation - 37&#34; &gt;}}

**Bandwidth:** Number of bits per second (P34) 

**Delay** 可以近似理解为 Propagation time。有效利用 network 的标志是在接收对方的回应之前，发送方传送的资料充满了 pipe，即发送了 Delay $\times$ Bandwitdh bits 的资料量。(P39)

{{&lt; image src=&#34;/images/network/L1-40.png&#34; caption=&#34;Foundation - 40&#34; &gt;}}

**RTT** 可以近似理解为 2 $\times$ Propagation time，因为一个来回需要从 sender 到 reciever，再从 reciever 到 sender。


[courseinfo]: https://ocw.nthu.edu.tw/ocw/index.php?page=course&amp;cid=291&amp;
[slides&amp;hws]: https://ocw.nthu.edu.tw/ocw/index.php?page=course_news_content&amp;cid=291&amp;id=1015
[playlist]: https://www.youtube.com/playlist?list=PLS0SUwlYe8cxktXNovos9xleroaWyb-z5


---

> 作者: [vanJker](https://github.com/vanJker)  
> URL: https://ccrysisa.github.io/posts/nthu-computer-network/  

