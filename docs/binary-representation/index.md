# 解读计算机编码


人們對數學的加減運算可輕易在腦中辨識符號並理解其結果，但電腦做任何事都受限於實體資料儲存及操作方式，換言之，電腦硬體實際只認得 0 和 1，卻不知道符號 + 和 - 在數學及應用場域的意義，於是工程人員引入「補數」以便在二進位系統中，表達人們認知上的正負數。但您有沒有想過，為何「二補數」(2’s complement) 被電腦廣泛採用呢？背後的設計考量又是什麼？本文嘗試從數學觀點去解讀編碼背後的原理，並佐以資訊安全及程式碼最佳化的考量，探討二補數這樣的編碼對於程式設計有何關鍵影響。

<!--more-->

## 一补数 (Ones’ complement)

### 9 的补数

:x: 科普短片: [Not just counting, but saving lives: Curta][not-just-counting-but-saving-lives-curta]

### 运算原理

{{< admonition note >}}
以一补数编码形式表示的运算子，在参与运算后，运算结果符合一补数的编码：

{{< raw >}}
$$
[X]_{一补数} + [Y]_{一补数} = [X+Y]_{一补数}
$$
{{< /raw >}}
{{< /admonition >}}

接下来进行分类讨论，以 32-bit 正数 $X$, $Y$ 为例：

- $X + Y = X + Y$ 显然运算子和运算结果都满足一补数编码。

- $X - Y = X + (2^{32} - 1 - Y)$

  - 如果 $X > Y$，则运算结果应为 $X - Y$ 且为正数，其一补数编码为 $X - Y$。而此时 
  $$
  2^{32} - 1 + X - Y
  $$ 
  显然会溢出，为了使运算结果对应一补数编码，所以此时循环进位对应 $+\ (1 - 2_{32})$。

  - 如果 $X < Y$，则运算结果应为 $X - Y$ 且为负数，其一补数编码为 
  $$
  2^{32} - 1 - （Y - X） = 2_{32} - 1 - X - Y
  $$
  而此时 $2^{32} - 1 + X - Y$ 并不会溢出，并且满足运算结果的一补数编码，所以无需进行循环进位。

  - 如果 $X = Y$，显然 
  $$
  X - Y = X + 2^{32} - 1 - Y = 2^{32} - 1
  $$
  为 0 成立。

- $-X - Y = (2^{32} - 1 - X) + (2^{32} - 1 - Y)$，显然会导致溢出。而 $-X - Y$ 的一补数编码为 
$$
2^{32} - 1 - (X + Y) = 2^{32} - 1 - X - Y
$$
所以需要在溢出时循环进位 $+\ (1 - 2^{32})$ 来消除运算结果中的一个 $2^{32} - 1$。

## 二补数 (Two's complement)

### 正负数编码表示

假设有 n-bit 的二补数编码 $A$，$-A$ 的推导如下：

- 格式一：

{{< raw >}}
$$
\begin{align*}
A + \neg A &= 2^n - 1 \\
A + \neg A + 1 &\equiv 0 \equiv 2^n \ (\bmod 2^n) \\
-A &= \neg A + 1 \\ 
\end{align*}
$$
{{< /raw >}}

- 格式二：

{{< raw >}}
$$
\begin{align*}
A + \neg A &= 2^n - 1 \\
A + \neg A - 1 &= 2^n - 2 \\
A - 1 &= 2^n - 1 - (\neg A + 1) \\ 
\neg (A - 1) &= \neg A + 1 \\
\neg (A - 1) &= -A \\
\end{align*}
$$
{{< /raw >}}

也可以通过一补数和二补数，在时钟表上的对称轴偏差，来理解上述两种方式是等价的。

{{< figure src="https://hackmd-prod-images.s3-ap-northeast-1.amazonaws.com/uploads/upload_144d52ff047bf6c796128635301c52fe.png?AWSAccessKeyId=AKIA3XSAAW6AWSKNINWO&Expires=1704257460&Signature=Qq8tLBaablrQ6JlUBB2sxJIjPRA%3D" >}}

### 加 / 减法器设计

:white_check_mark: 科普短片: [See How Computers Add Numbers In One Lesson][see-how-computers-add-numbers-in-one-lesson]

- 了解晶体管的原理
- 了解基本逻辑门元件，例如 OR, AND 逻辑门的设计
- 了解加法器的原理和工作流程。

## 阿贝尔群及对称性

{{< admonition tip >}}
群论的最大用途是关于「对称性」的研究；所有具有对称性质，群论都可派上用场。只要发生变换后仍有什么东西还维持不变，那符合对称的性质。

- 一个圆左右翻转后还是圆，它在这种变换下是对称的，而这刚好与群的 **封闭性 (Closure)** 对应。
- 一个时钟的时刻，从 0 时刻开始，两边的时刻相加模 12 的结果均为 0，这与群的 **单位元 (Identity element)** 和 **逆元 (Inverse element)** 对应。

上述两个例子反映了群论的性质，对于对称性研究的重要性和原理依据。
{{< /admonition >}}

## 旁路攻击

:white_check_mark: 观看科普视频: [我听得到你打了什么字][2xCICHh4Pas]
- [ ] 阅读相关论文 [Keyboard Acoustic Emanations][kbdacoustic]
- [ ] 体验使用相关工具 [kbd-audio][kbd-audio]

借由 Wikipedia 了解旁路攻击 ([Side-channel attack][side-channel-attack]) 和时序攻击 ([Timing attack][timing-attack]) 的基本概念。
- [Black-box testing](https://en.wikipedia.org/wiki/Black-box_testing)
- [Row hammer](https://en.wikipedia.org/wiki/Row_hammer)
- [Cold boot attack](https://en.wikipedia.org/wiki/Cold_boot_attack)
- [Rubber-hose cryptanalysis](https://en.wikipedia.org/wiki/Rubber-hose_cryptanalysis)


<!-- URL -->
[not-just-counting-but-saving-lives-curta]: https://www.youtube.com/watch?v=kRmExkQoOPY
[see-how-computers-add-numbers-in-one-lesson]: https://www.youtube.com/watch?v=VBDoT8o4q00
[2xCICHh4Pas]: https://www.youtube.com/watch?v=2xCICHh4Pas
[kbd-audio]: https://github.com/ggerganov/kbd-audio
[kbdacoustic]: https://web.eecs.umich.edu/~genkin/teaching/fall2019/EECS598-12_files/kbdacoustic.pdf
[side-channel-attack]: https://en.wikipedia.org/wiki/Side-channel_attack
[timing-attack]: https://en.wikipedia.org/wiki/Timing_attack


---

> 作者: [Xshine](https://github.com/LoongGshine)  
> URL: https://loonggshine.github.io/binary-representation/  

