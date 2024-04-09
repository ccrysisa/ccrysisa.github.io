# Linux 核心设计/实作 (Linux Kernel Internals)


> 在「Linux 核心设计/实作」Spring 2023 课程进度页面的原始档案的基础上，稍作修改以记录我的学习进度

<!--more-->

{{< link href="http://wiki.csie.ncku.edu.tw/linux/schedule?revision=ff44817ff7c75ed4ec0d22e6fdc3337af1f597c3" content="原始页面" external-icon=true >}}
|
{{< link href="/archives/Linux.pdf" content="PDF" external-icon=true >}}

{{< admonition success >}}
如果你学习时感到挫折，感到进度推进很慢，这很正常，因为 Jserv 的一个讲座，需要我们花费一个星期去消化 :rofl:

所以没必要为此焦虑，如果你觉得某个内容不太理解，可以尝试先去看其他讲座，将原先不懂的知识交给大脑隐式消化，过段时间再回来看，你的理解会大有不同。
{{< /admonition >}}

------------------------------------------------------
- Instructor: [Jim Huang](/User/jserv) (黃敬群) `<jserv.tw@gmail.com>`
- [往年課程進度](/linux/schedule-old)
- [Linux 核心設計 (線上講座)](https://hackmd.io/@sysprog/linux-kernel-internal)
- 注意: 下方課程進度表標註有 `*` 的項目，表示內附錄影的教材
- 注意: 新開的「Linux 核心實作」課程內容幾乎與「Linux 核心設計」一致，採線上為主的進行方式

Linux 核心設計/實作 (Spring 2023) 課程進度表暨線上資源
------------------------------------------------------
### 第 1 週: 誠實面對自己
> (Feb 13, 14, 16)
- [x] [教材解說](https://youtu.be/ptbJQUAv2ro)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
- [x] [課程簡介和注意須知](https://docs.google.com/presentation/d/1xmb_mvsHISWp6naP1rHOyrxzMzNQkVoKK69lGRRXV9M/edit?usp=sharing) / [課程簡介解說錄影](https://youtu.be/qebDgIIEDYw)`*`
    * 每週均安排隨堂測驗，採計其中最高分的 9 次
    * 學期評分方式: 隨堂測驗 (20%) + 個人作業+報告及專題 (30%) + 自我評分 (50%)
- 歷屆修課學生心得: [向景亘](/User/OscarShiang), [張家榮](/User/JaredCJR), [蕭奕凱](/User/Veck), [方鈺學](/User/JulianATA)
- 分組報告示範: [ARM-Linux](/embedded/arm-linux), [Xvisor](/embedded/xvisor)
- [x] [GNU/Linux 開發工具共筆](https://hackmd.io/@sysprog/gnu-linux-dev/)`*`: 務必 *自主* 學習 Linux 操作, Git, HackMD, LaTeX 語法 (特別是數學式), GNU make, perf, gnuplot
    * 確認 Ubuntu Linux 22.04-LTS (或更新的版本) 已順利安裝到你的電腦中
- [透過 Computer Systems: A Programmer’s Perspective 學習系統軟體](https://hackmd.io/c/S1vGugaDQ)`*`: 本課程指定的教科書 (請及早購買: [天瓏書店](https://www.tenlong.com.tw/products/9787111544937))
- [軟體缺失導致的危害](https://hackmd.io/@sysprog/B1eo44C1-)
    * 1970 年代推出的首款廣體民航客機波音 747 軟體由大約 40 萬行程式碼構成，而 2011 年引進的波音 787 的軟體規模則是波音 747 的 16 倍，約 650 萬行程式碼。換言之，你我的性命緊繫於一系列極為複雜的軟體系統之中，能不花點時間了解嗎？
    * 軟體開發的安全性設計和測試驗證應獲得更高的重視
- [x] [The adoption of Rust in Business (2022)](https://rustmagazine.org/issue-1/2022-review-the-adoption-of-rust-in-business/)
    * 搭配觀看短片: [Rust in 100 Seconds](https://youtu.be/5C_HPTJg5ek)
- [x] [解讀計算機編碼](https://hackmd.io/@sysprog/rylUqXLsm)
    * 人們對數學的加減運算可輕易在腦中辨識符號並理解其結果，但電腦做任何事都受限於實體資料儲存及操作方式，換言之，電腦硬體實際只認得 0 和 1，卻不知道符號 + 和 - 在數學及應用場域的意義，於是工程人員引入「補數」以表達人們認知上的正負數
    * 您有沒有想過，為何「二補數」(2’s complement) 被電腦廣泛採用呢？背後的設計考量是什麼？本文嘗試從數學觀點去解讀編碼背後的原理
- [x] [你所不知道的 C 語言：指標篇](https://hackmd.io/@sysprog/c-pointer)`*`
- [x] [linked list 和非連續記憶體操作](https://hackmd.io/@sysprog/c-linked-list)`*`
    * 安排 linked list 作為第一份作業及隨堂測驗的考量點:
        + 檢驗學員對於 C 語言指標操作的熟悉程度 (附帶思考：對於 Java 程式語言來說，該如何實作 linked list 呢？)
        + linked list 本質上就是對非連續記憶體的操作，乍看僅是一種單純的資料結構，但對應的演算法變化多端，像是「如何偵測 linked list 是否存在環狀結構？」和「如何對 linked list 排序並確保空間複雜度為 O(1) 呢？」
        + linked list 的操作，例如走訪 (traverse) 所有節點，反映出 Locality of reference (cache 用語) 的表現和記憶體階層架構 (memory hierarchy) 高度相關，學員很容易從實驗得知系統的行為，從而思考其衝擊和效能改進方案
        + 無論是作業系統核心、C 語言函式庫內部、應用程式框架，到應用程式，都不難見到 linked list 的身影，包含多種針對效能和安全議題所做的 linked list 變形，又還要考慮到應用程式的泛用性 (generic programming)，是很好的進階題材
    * [x] [題目 1 + 分析](https://hackmd.io/@sysprog/linked-list-quiz)`*`
    * [x] [題目2](https://hackmd.io/@sysprog/linux2020-quiz1) / [參考題解1](https://hackmd.io/@Ryspon/HJVH8B0XU), [參考題解2](https://hackmd.io/@chses9440611/Sy5gwE37I)
    * [題目3](https://hackmd.io/@sysprog/sysprog2020-quiz1) / [參考題解](https://hackmd.io/@RinHizakura/BysgszHNw)
    * [題目4](https://hackmd.io/@sysprog/linux2021-quiz1) / [參考題解](https://hackmd.io/@linD026/2021q1_quiz1)
    * [題目5](https://hackmd.io/@sysprog/linux2022-quiz1) / [參考題解](https://hackmd.io/@qwe661234/linux2022-quiz1)
- 佳句偶得：「大部分的人一輩子洞察力不彰，原因之一是怕講錯被笑。想了一點點就不敢繼續也沒記錄或分享，時間都花在讀書查資料看別人怎麼想。看完就真的沒有自己的洞察了」([出處](https://www.facebook.com/chtsai/posts/pfbid0Sw9Bv8GN8houyS6A6Mvg5gtWXShKFgguhTHuNFsDDGn9XZQE7C64pBy5atB9gXtJl))
- [作業](https://hackmd.io/@sysprog/linux2023-homework1): 截止繳交日: Feb 28, 2023
    * [ ] [lab0](https://hackmd.io/@sysprog/linux2023-lab0)`*`
    * [quiz1](https://hackmd.io/@sysprog/ByiHJidps)
- 第 1 週隨堂測驗: [題目](https://hackmd.io/@sysprog/linux2023-quiz1) (內含作答表單)
- [課堂問答簡記](https://hackmd.io/VIvUZemESvGUev4aCwOnWA?view)

### 第 2 週: C 語言程式設計
> (Feb 20, 21, 23)
* [x] [教材解說](https://youtu.be/YawpeXUiN1k)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
* [Linux v6.2 發布](https://kernelnewbies.org/Linux_6.2): 接下來會是讓學員眼花撩亂的主版號/次版號的飛快跳躍 / [kernel.org](https://kernel.org/)
* [x] [Linux: 作業系統術語及概念](https://hackmd.io/@sysprog/linux-concepts)`*`
* [x] [系統軟體開發思維](https://hackmd.io/@sysprog/concepts)
- [x] [C 語言: 數值系統](https://hackmd.io/@sysprog/c-numerics)`*`
    - 儘管數值系統並非 C 語言所特有，但在 Linux 核心大量存在 u8/u16/u32/u64 這樣透過 typedef 所定義的型態，伴隨著各式 alignment 存取，若學員對數值系統的認知不夠充分，可能立即就被阻擋在探索 Linux 核心之外 —— 畢竟你完全搞不清楚，為何在 Linux 核心存取特定資料需要繞一大圈。
- [x] [C 語言: Bitwise 操作](https://hackmd.io/@sysprog/c-bitwise)`*`
    - Linux 核心原始程式碼存在大量 bit(-wise) operations (簡稱 bitops)，頗多乍看像是魔法的 C 程式碼就是 bitops 的組合
    - [x] [類神經網路的 ReLU 及其常數時間複雜度實作](https://hackmd.io/@sysprog/constant-time-relu)
    - [ ] [從 √2 的存在談開平方根的快速運算](https://hackmd.io/@sysprog/sqrt)
* [x] [Linux 核心的 hash table 實作](https://hackmd.io/@sysprog/linux-hashtable)
* [x] [為什麼要深入學習 C 語言？](https://hackmd.io/@sysprog/c-standards)`*`
    - C 語言發明者 Dennis M. Ritchie 說：「C 很彆扭又缺陷重重，卻異常成功。固然有歷史的巧合推波助瀾，可也的確是因為它能滿足於系統軟體實作的程式語言期待：既有相當的效率來取代組合語言，又可充分達到抽象且流暢，能用於描述在多樣環境的演算法。」
    - Linux 核心作為世界上最成功的開放原始碼計畫，也是 C 語言在工程領域的瑰寶，裡頭充斥各式「藝術」，往往會嚇到初次接觸的人們，但總是能夠用 C 語言標準和開發工具提供的擴展 (主要來自 gcc 的 GNU extensions) 來解釋。
* [x] [基於 C 語言標準研究與系統程式安全議題](https://hackmd.io/@sysprog/c-std-security)
    - 藉由研讀漏洞程式碼及 C 語言標準，討論系統程式的安全議題
    - 透過除錯器追蹤程式碼實際運行的狀況，了解其運作原理;
    - 取材自 dangling pointer, CWE-416 Use After Free, CVE-2017-16943 以及 integer overflow 的議題;
* [ ] [C 語言：記憶體管理、對齊及硬體特性](https://hackmd.io/@sysprog/c-memory)`*`
    * [ ] 搭配閱讀: [The Lost Art of Structure Packing](http://www.catb.org/esr/structure-packing/)
    * 從虛擬記憶體談起，歸納出現代銀行和虛擬記憶體兩者高度相似: malloc 給出 valid pointer 不要太高興，等你要開始用的時候搞不好作業系統給個 OOM ——簡單來說就是一張支票，能不能拿來開等到兌現才知道。
    * 探討 heap (動態配置產生，系統會存放在另外一塊空間)、data alignment，和 malloc 實作機制等議題。這些都是理解 Linux 核心運作的關鍵概念。
* [x] [C 語言: bit-field](https://hackmd.io/@sysprog/c-bitfield)
    - bit field 是 C 語言一個很被忽略的特徵，但在 Linux 和 gcc 這類系統軟體很常出現，不僅是精準規範每個 bit 的作用，甚至用來「擴充」C 語言
- [參考題目](https://hackmd.io/@sysprog/linux2022-quiz2) / [參考題目](https://hackmd.io/@sysprog/linux2021-quiz2)`*` / [參考題解 1](https://hackmd.io/@93i7xo2/sysprog2021q1-hw2-quiz2), [參考題解 2](https://hackmd.io/@hankluo6/2021q1quiz2), [參考題解 3](https://hackmd.io/@bakudr18/SkS-Y_lX_)
- [作業](https://hackmd.io/@sysprog/linux2023-homework2): 截止繳交日 Mar 7
    - [quiz2](https://hackmd.io/@sysprog/H143OpNCo)
- 第 2 週隨堂測驗: [題目](https://hackmd.io/@sysprog/linux2023-quiz2) (內含作答表單)
- [課堂問答簡記](https://hackmd.io/VIvUZemESvGUev4aCwOnWA?view)

### 第 3 週: 並行和 C 語言程式設計
> (Feb 27, 28, Mar 2)
* [x] [教材解說](https://youtu.be/7efdpMCx-ak)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
* 公告
    + 2 月 28 日沒有實體課程，但安排線上測驗 (「Linux 核心設計」課程的學員務必參加)，在 15:20-23:59 之間依據 [Google Calendar](https://calendar.google.com/calendar/embed?src=embedded.master2015%40gmail.com&ctz=Asia%2FTaipei) 進行作答
    + 第二次作業已指派，可在 2 月 28 日晚間起開始繳交，截止繳交日 Mar 7
    + 3 月 1 日晚間安排第一次作業的檢討直播 (事後有錄影)，請參見 [Google Calendar](https://calendar.google.com/calendar/embed?src=embedded.master2015%40gmail.com&ctz=Asia%2FTaipei)
* [x] [Linux: 發展動態回顧](https://hackmd.io/@sysprog/linux-dev-review)`*`
* [ ] [從 Revolution OS 看作業系統生態變化](https://hackmd.io/@sysprog/revolution-os-note)`*`
* [並行和多執行緒程式設計](https://hackmd.io/@sysprog/concurrency/)`*`: 應涵蓋 Part 1 到 Part 4
    - [x] Part 1: 概念、执行顺序
    - [ ] Part 2
    - [ ] Part 3
    - [ ] Part 4
* [C 語言: 函式呼叫](https://hackmd.io/@sysprog/c-function)`*`
    - 著重在計算機架構對應的支援和行為分析
* [x] [C 語言: 遞迴呼叫](https://hackmd.io/@sysprog/c-recursion)`*`
    - 或許跟你想像中不同，Linux 核心的原始程式碼裡頭也用到遞迴函式呼叫，特別在較複雜的實作，例如檔案系統，善用遞迴可大幅縮減程式碼，但這也導致追蹤程式運作的難度大增
* [x] [C 語言: 前置處理器應用](https://hackmd.io/@sysprog/c-preprocessor)`*`
    - C 語言之所以不需要時常發佈新的語言特徵又可以保持活力，前置處理器 (preprocessor) 是很重要的因素，有心者可逕行「擴充」C 語言
* [C 語言: goto 和流程控制](https://hackmd.io/@sysprog/c-control-flow)`*`
    - goto 在 C 語言被某些人看做是妖魔般的存在，不過實在不用這樣看待，至少在 Linux 核心原始程式碼中，goto 是大量存在 (跟你想像中不同吧)。有時不用 goto 會寫出更可怕的程式碼
* [C 語言程式設計技巧](https://hackmd.io/@sysprog/c-trick)`*`
* [作業](https://hackmd.io/@sysprog/linux2023-homework3): 截止繳交日: Mar 21
    - [fibdrv](https://hackmd.io/@sysprog/linux2023-fibdrv)`*`, [quiz3](https://hackmd.io/@sysprog/H1hV29nRj), [review](https://hackmd.io/@sysprog/linux2023-review)`*`
* Week3 隨堂測驗: [題目](https://hackmd.io/@sysprog/linux2023-quiz3) (內含作答表單)

* 第 4 週 (Mar 6, 7, 9): 數值系統 + 編譯器
    - [教材解說](https://youtu.be/cjq0OuUeepA)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
    * 公告:
        - 請填寫 [Google 表單](https://forms.gle/rANw1FmXxd2rB3dP8)，以利後續追蹤
        - 《Demystifying the Linux CPU Scheduler》的書稿已寄送給成功大學的選課學生，旁聽的學員預計在 3 月 13 日取得 (第 5 週進度)
    * 貢獻程式碼到 Linux 核心
        - [第一次給 Linux Kernel 發 patch](https://hackmd.io/@rhythm/BkjJeugOv)
        - [提交第一份 Patch 到 Linux Kernel](https://hackmd.io/@steven1lung/submitting-patches)
        - [第一次發 patch 到 LKML](https://hackmd.io/@Risheng/ry5futJF9)
    * [追求神乎其技的程式設計之道](https://vgod.medium.com/7cccc3c68f1e)
        - 「可以看出抄襲風氣在台灣並不只是小時候在學校抄抄作業而已；媒體工作者在報導中任意抄襲及轉載是種不尊重自己專業的表現，不但隱含著一種應付了事的心態，更代表著這些人對於自己的工作沒有熱情，更沒有著一點堅持。如果要說我在美國看到這邊和台灣有什麼最大的不同，我想關鍵的差異就在對自己的工作有沒有熱情和堅持而已了。」
        - 「程式藝術家也不過是在『簡潔』、『彈性』、『效率』這三大目標上進行一連串的取捨 (trade-off) 和最佳化。」
    * [Linux 核心的紅黑樹](https://hackmd.io/@sysprog/linux-rbtree)
    * [CS:APP 第 2 章重點提示和練習](https://hackmd.io/@sysprog/CSAPP-ch2)`*`
    * 核心開發者當然要熟悉編譯器行為
        - [Linus Torvalds 教你分析 gcc 行為](https://lkml.org/lkml/2019/2/25/1092)
        - [Pointers are more abstract than you might expect in C](https://pvs-studio.com/en/blog/posts/cpp/0576/) / [HackerNews 討論](https://news.ycombinator.com/item?id=17439467)
    * [C 編譯器原理和案例分析](https://hackmd.io/@sysprog/c-compiler-construction)`*`
    * [C 語言: 未定義行為](https://hackmd.io/@sysprog/c-undefined-behavior)`*`: C 語言最初為了開發 UNIX 和系統軟體而生，本質是低階的程式語言，在語言規範層級存在 undefined behavior，可允許編譯器引入更多最佳化
    * [C 語言: 編譯器和最佳化原理](https://hackmd.io/@sysprog/c-compiler-optimization)`*`
    * 《Demystifying the Linux CPU Scheduler》第 1 章
    * [作業](https://hackmd.io/@sysprog/linux2023-homework4): 截止繳交日: Mar 30
        * [quiz4](https://hackmd.io/@sysprog/HJaX8tuyh)
    * Week4 隨堂測驗: [題目](https://hackmd.io/@sysprog/linux2023-quiz4) (內含作答表單)
    - [課堂問答簡記](https://hackmd.io/@sysprog/rJVas7NJn)

* 第 5 週 (Mar 13, 14, 16): Linux CPU scheduler
    - [教材解說](https://youtu.be/f-SprmkcOI0)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
    * 公告:
        - 本週導入客製化作業，讓學員選擇改進前四週的作業或自訂題目 (例如貢獻程式碼到 Linux 核心)，隨後安排授課教師和學員的線上一對一討論
    * [浮點數運算](https://hackmd.io/@sysprog/c-floating-point)`*`: 工程領域往往是一系列的取捨結果，浮點數更是如此，在軟體發開發有太多失誤案例源自工程人員對浮點數運算的掌握不足，本議程希望藉由探討真實世界的血淋淋案例，帶著學員思考 IEEE 754 規格和相關軟硬體考量點，最後也會探討在深度學習領域為了改善資料處理效率，而引入的 [BFloat16](https://en.wikipedia.org/wiki/Bfloat16_floating-point_format) 這樣的新標準
        - [float16 vs. bfloat16](https://twitter.com/rasbt/status/1631679894219284480)
    * 記憶體配置器涉及 bitwise 操作及浮點數運算。傳統的即時系統和該領域的作業系統 (即 RTOS) 為了讓系統行為更可預測，往往捨棄動態記憶體配置的能力，但這顯然讓系統的擴充能力大幅受限。後來研究人員提出 TLSF (Two-Level Segregated Fit) 嘗試讓即時系統也能享用動態記憶體管理，其關鍵訴求是 "O(1) cost for malloc, free, realloc, aligned_alloc"
        - [Benchmarking Malloc with Doom 3](https://www.forrestthewoods.com/blog/benchmarking-malloc-with-doom3/)
        - [tlsf-bsd](https://github.com/jserv/tlsf-bsd)
        - TLSF: [Part 1: Background](https://brnz.org/hbr/?p=1735), [Part 2: The floating point](https://brnz.org/hbr/?p=1744)
    * [Linux 核心模組運作原理](https://hackmd.io/@sysprog/linux-kernel-module)
    * [Linux: 不只挑選任務的排程器](https://hackmd.io/@sysprog/linux-scheduler)`*`: 排程器 (scheduler) 是任何一個多工作業系統核心都具備的機制，但彼此落差極大，考量點不僅是演算法，還有當應用規模提昇時 (所謂的 scalability) 和涉及即時處理之際，會招致不可預知的狀況 (non-determinism)，不僅即時系統在意，任何建構在 Linux 核心之上的大型服務都會深受衝擊。是此，Linux 核心的排程器經歷多次變革，需要留意的是，排程的難度不在於挑選下一個可執行的行程 (process)，而是讓執行完的行程得以安插到合適的位置，使得 runqueue 依然依據符合預期的順序。
    * [C 語言: 動態連結器](https://hackmd.io/@sysprog/c-dynamic-linkage)`*`
    * [C 語言: 連結器和執行檔資訊](https://hackmd.io/@sysprog/c-linker-loader)`*`
    * [C 語言: 執行階段程式庫 (CRT)](https://hackmd.io/@sysprog/c-runtime)`*`
    * [作業](https://hackmd.io/@sysprog/linux2023-homework5): 截止繳交 Apr 10
        - [assessment](https://hackmd.io/@sysprog/r1O7Xcp12)
    * Week5 隨堂測驗: [題目](https://hackmd.io/@sysprog/linux2023-quiz5) (內含作答表單)
    - [課堂問答簡記](https://hackmd.io/@sysprog/rJVas7NJn)

* 第 6 週 (Mar 20, 21, 23): System call + CPU Scheduler
    - [教材解說](https://youtu.be/zW_MAMy7DBE)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
    * 公告
        - 自 3 月 22 日起，開放讓學員 (選課的學生 + 完成前二次作業過半要求的旁聽者) 跟授課教師預約一對一線上討論，請參照[課程行事曆](https://bit.ly/sysprog-calendar)裡頭標注 "Office hour" 的時段，發訊息到 [Facebook 粉絲專頁](https://www.facebook.com/JservFans/)，簡述你的學習狀況並選定偏好的時段 (建議是 30 分鐘)。留意課程發送的公告信件
        - 選修課程的學員在本學期至少要安排一次一對一討論，否則授課教師難以評估學習狀況，從而會影響評分，請重視自己的權益。
    * [coroutine](https://hackmd.io/@sysprog/coroutine)
    * [Linux: 賦予應用程式生命的系統呼叫](https://hackmd.io/@sysprog/linux-syscall)
    * [vDSO: 快速的 Linux 系統呼叫機制](https://hackmd.io/@sysprog/linux-vdso)
    * [UNIX 作業系統 fork/exec 系統呼叫的前世今生](https://hackmd.io/@sysprog/unix-fork-exec)
    * 《Demystifying the Linux CPU Scheduler》
        - 1.2.1 System calls
        - 1.2.2 A different kind of software
        - 1.2.3 User and kernel stacks
        - 1.3 Process management
        - 2.1 Introduction
        - 2.2 Prior to CFS
        - 2.3 Completely Fair Scheduler (CFS)
        - 3.1 Structs and their role
    * [作業](https://hackmd.io/@sysprog/linux2023-homework6): 截止繳交 Apr 17
        - [quiz5](https://hackmd.io/@sysprog/rJf4_1x-3), [quiz6](https://hackmd.io/@sysprog/B1rcF1e-h)
    * Week6 隨堂測驗: [題目](https://hackmd.io/@sysprog/linux2023-quiz6) (內含作答表單)
    - [課堂問答簡記](https://hackmd.io/@sysprog/rJVas7NJn)

* 第 7 週 (Mar 27, 28, 30): Process, 並行和多執行緒
    - [教材解說-1](https://youtu.be/mnbIi82iT2A)`*`, [教材解說-2](https://youtu.be/G_BLP3tqocc)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
    * 公告:
        * [第 5 次作業](https://hackmd.io/@sysprog/linux2023-homework5) 和 [第 6 次作業](https://hackmd.io/@sysprog/linux2023-homework6) 作業已指派
        * 本週測驗順延到 4 月 4 日和 4 月 6 日，3 月 30 日晚間安排課程講解
        * 4 月 3 日晚間依舊講課 (事後有錄影)、4 月 4 日下午到晚間安排在家測驗，4 月 6 日晚間安排測驗
    * [Linux: 不僅是個執行單元的 Process](https://hackmd.io/@sysprog/linux-process)`*`: Linux 核心對於 UNIX Process 的實作相當複雜，不僅蘊含歷史意義 (幾乎每個欄位都值得講古)，更是反映出資訊科技產業的變遷，核心程式碼的 `task_struct` 結構體更是一絕，廣泛涵蓋 process 狀態、處理器、檔案系統、signal 處理、底層追蹤機制等等資訊，更甚者，還很曖昧地保存著 thread 的必要欄位，好似這兩者天生就脫不了干係
        - 探討 Linux 核心設計的特有思維，像是如何透過 LWP 和 NPTL 實作執行緒，又如何透過行程建立記憶體管理的一種抽象層，再者回顧行程間的 context switch 及排程機制，搭配 signal 處理
    * [測試 Linux 核心的虛擬化環境](https://hackmd.io/@sysprog/linux-virtme)
    * [建構 User-Mode Linux 的實驗環境](https://hackmd.io/@sysprog/user-mode-linux-env)`*`
    * [〈Concurrency Primer〉導讀](https://hackmd.io/@sysprog/concurrency-primer)
    * [The C11 and C++11 Concurrency Model](https://docs.google.com/presentation/d/1IndzU1LDyHcm1blE0FecDyY1QpCfysUm95q_D2Cj-_U/edit?usp=sharing)
        - [Time to move to C11 atomics?](https://lwn.net/Articles/691128/)
        - [C11 atomic variables and the kernel](https://lwn.net/Articles/586838/)
        - [C11 atomics part 2: "consume" semantics](https://lwn.net/Articles/588300/)
        - [An introduction to lockless algorithms](https://lwn.net/Articles/844224/)
    * [並行和多執行緒程式設計](https://hackmd.io/@sysprog/concurrency/)`*`
    * CS:APP 第 12 章
        - [Concurrency](https://www.cs.cmu.edu/afs/cs/academic/class/15213-f19/www/lectures/24-concprog.pdf) / [錄影](https://scs.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=0be3c53f-5d35-40f0-a5ab-55897a2c91a5)`*`
        - [Synchronization: Basic](https://www.cs.cmu.edu/afs/cs/academic/class/15213-f19/www/lectures/25-sync-basic.pdf) / [錄影](https://scs.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=aae5ff94-1551-42b6-8981-7d19157afa0c)`*`
        - [Synchronization: Advanced](https://www.cs.cmu.edu/afs/cs/academic/class/15213-f19/www/lectures/26-sync-advanced.pdf) / [錄影](https://scs.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=06892ab8-1a16-46de-8910-537dab546828)`*`
        - [Thread-Level Parallelism](https://www.cs.cmu.edu/afs/cs/academic/class/15213-f19/www/lectures/27-parallelism.pdf) / [錄影](https://scs.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=9ba08262-5318-45f2-a7e1-475e33a98e53)`*`
    - [課堂問答簡記](https://hackmd.io/@sysprog/SyOhklg-3)

* 第 8 週 (Apr 3, 4, 6): 並行程式設計, lock-free, Linux 同步機制
    - [教材解說](https://youtu.be/05x65CayUNw)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
    * 公告:
        - 4 月 4 日下午到晚間安排在家測驗，請在當日 15:00 刷新課程進度表/行事曆，以得知測驗方式
        - 4 月 6 日晚間安排測驗
    * [並行和多執行緒程式設計](https://hackmd.io/@sysprog/concurrency)，涵蓋
        - Atomics 操作
        - POSIX Threads (請對照 CS:APP 第 12 章自行學習)
        - Lock-free 程式設計
        - 案例: Hazard pointer
        - 案例: Ring buffer
        - 案例: Thread Pool
    * [Linux: 淺談同步機制](https://hackmd.io/@sysprog/linux-sync)`*`
    * [利用 lkm 來變更特定 Linux 行程的內部狀態](https://hackmd.io/@cwl0429/linux2022-quiz8-3)
    * Week8 隨堂測驗: [題目](https://hackmd.io/@sysprog/linux2023-quiz8) (內含作答表單)

* 第 9 週 (Apr 10, 11, 13): futex, RCU, 伺服器開發與 Linux 核心對應的系統呼叫
    - [教材解說](https://youtu.be/BH6vdKd6kGY)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
    * [第二次作業檢討](https://hackmd.io/@sysprog/linux2023-review2)
    * 公告:
        + 請於 4 月 14 日 10:00PM 刷新本頁面，以得知新指派的作業
        + 4 月 13 日晚間安排課程測驗和作業解說，優先回覆學員在[第 5 次作業](https://hackmd.io/@sysprog/linux2023-homework5)的提問
        + 由於其他課程的期中考陸續告一段落，本課程又要恢復之前的強度，請務必跟授課教師預約一對一討論，以進行相關調整
    * Twitter 上面的笑話: index 的複數寫作 indices, complex 的複數寫作 complices, 那 mutex 的複數是什麼？答 "deadlock" -- [出處](https://twitter.com/jfbastien/status/1408440373408460803)
    * [A Deep dive into (implicit) Thread Local Storage](https://chao-tic.github.io/blog/2018/12/25/tls)
        - 允許執行緒擁有私自的資料。對於每個執行緒來說，TLS 是獨一無二，不會相互影響。案例: 全域變數 `errno` 可能在多執行緒並行執行時錯誤，透過 TLS 處理 `errno` 是個解決方案
        - `__thread`, 在 POSIX Thread 稱為 thread-specific data，可見 [pthread_key_create](https://linux.die.net/man/3/pthread_key_create), [pthread_setspecific](https://linux.die.net/man/3/pthread_setspecific)
        - 在 x86/x86_64 Linux，[fs segment 用以表示 TLS 的起始位置](https://www.kernel.org/doc/html/latest/x86/x86_64/fsgs.html)，讓執行緒知道該用的空間位於何處
    * [建立相容於 POSIX Thread 的實作](https://hackmd.io/@sysprog/concurrency-thread-package)
    * [RCU 同步機制](https://hackmd.io/@sysprog/linux-rcu)`*`
    * [Linux 核心設計: 針對事件驅動的 I/O 模型演化](https://hackmd.io/@sysprog/linux-io-model)`*`
    * [精通數位邏輯對 coding 有什麼幫助？](https://www.ptt.cc/bbs/Soft_Job/M.1587694288.A.3B5.html)
    * [Linux: 透過 eBPF 觀察作業系統行為](https://hackmd.io/s/SJTuuG9a7)`*`: 動態追蹤技術（dynamic tracing）是現代軟體的進階除錯和追蹤機制，讓工程師以非常低的成本，在非常短的時間內，克服一些不是顯而易見的問題。它興起和繁榮的一個大背景是，我們正處在一個快速增長的網路互連異質運算環境，工程人員面臨著兩大方面的挑戰：
        - 規模：無論是使用者規模還是機房的規模、機器的數量都處於快速增長的時代;
        - 複雜度：業務邏輯越來越複雜，運作的軟體也變得越來越複雜，我們知道它會分成很多很多層次，包括作業系統核心和其上各種系統軟體，像資料庫和網頁伺服器，再往上有腳本語言或者其他高階語言的虛擬機器或執行環境，更上面是應用層面的各種業務邏輯的抽象層次和很多複雜的程式邏輯。
    * Week9 隨堂測驗: [題目](https://hackmd.io/@sysprog/linux2023-quiz9) (內含作答表單)
    - [課堂問答簡記](https://hackmd.io/@sysprog/B1smldGzh)

* 第 10 週 (Apr 17, 18, 20): 現代微處理器
    * [教材解說](https://youtu.be/1zDQfxp_AuU)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
    * 公告:
        - 本週指派新作業: [ktcp](https://hackmd.io/@sysprog/linux2023-ktcp)`*`
        - 選修「Linux 核心設計/實作」課程的研究生有額外的作業 (課程回顧和分享學習經驗給指導教授)，詳情請留意後續信件
    * [Cautionary Tales on Implementing the Software That People Want](https://multicore.world/speakers/paul-mckenney/)`*`
        - [slides](https://2019multicoreworld.files.wordpress.com/2023/02/mckenney-paul-23.pdf)
        - 1990: Queueing Problem: Stochastic Fair Queueing: Hash
        - 2004: Real-Time Linux
        - 2004: Dawn of Multicore Embedded
        - Formal Verification is Heavily Used
        - Natural Selection: Bugs are Software!
        - People don’t know what they want. But for software developers, this is no excuse. 
    * [現代處理器設計：原理和關鍵特徵](https://hackmd.io/@sysprog/cpu-basics)`*`
    * 《Demystifying the Linux CPU Scheduler》
        + 2.4 Multiprocessing
        + 3.2 Time keeping
        + 3.4 Per-Entity Load Tracking
        + 4.1 Group scheduling and cgroups: Introduction
        + 4.2 Group scheduling and CPU bandwidth
    * [Linux: 中斷處理和現代架構考量](https://hackmd.io/@sysprog/linux-interrupt)`*`
    * [Linux: 多核處理器和 spinlock](https://hackmd.io/@sysprog/multicore-locks)`*`
    * [CPU caches](https://lwn.net/Articles/252125/) by Ulrich Drepper
        - 進行中的繁體中文翻譯: 《[每位程式開發者都該有的記憶體知識](https://sysprog21.github.io/cpumemory-zhtw/)》
        - 本文解釋用於現代電腦硬體的記憶體子系統的結構、闡述 CPU 快取發展的考量、它們如何運作，以及程式該如何針對記憶體操作調整，從而達到最佳的效能。
    * [作業](https://hackmd.io/@sysprog/linux2022-homework6): 截止繳交 May 14
        - [ktcp](https://hackmd.io/@sysprog/linux2023-ktcp)
    - [課堂問答簡記](https://hackmd.io/@sysprog/H1NdQ5AGn)

* 第 11 週 (Apr 24, 25, 20): 現代微處理器 + 記憶體管理
    * [教材解說](https://youtu.be/JWuw8M6Q-_k)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
    * 公告
        - 學員應及早跟授課教師預約一對一線上討論，請參照[課程行事曆](https://bit.ly/sysprog-calendar)裡頭標注 "Office hour" 的時段，發訊息到 [Facebook 粉絲專頁](https://www.facebook.com/JservFans/)，簡述你的學習狀況並選定偏好的時段 (建議是 30 分鐘)
        - 課程規劃在 6 月下旬舉辦成果發表，[時段調查](https://www.facebook.com/groups/system.software2023/posts/654568036495354/)
        - 4 月 27 日晚間以 Google Meet 方式進行
    * [CS:APP 第 6 章重點提示](https://hackmd.io/@sysprog/CSAPP-ch6)`*`
    * [CPU caches](https://lwn.net/Articles/252125/) by Ulrich Drepper
        - 進行中的繁體中文翻譯: 《[每位程式開發者都該有的記憶體知識](https://sysprog21.github.io/cpumemory-zhtw/)》
        - 本文解釋用於現代電腦硬體的記憶體子系統的結構、闡述 CPU 快取發展的考量、它們如何運作，以及程式該如何針對記憶體操作調整，從而達到最佳的效能。
    * [CS:APP 第 9 章重點提示](https://hackmd.io/@sysprog/CSAPP-ch9)`*`
    * [解析 Linux 共享記憶體機制](https://hackmd.io/@sysprog/linux-shared-memory)
    * [Linux 核心的 /dev/mem 裝置](https://hackmd.io/@sysprog/linux-mem-device)
    * Week11 隨堂測驗: [題目](https://hackmd.io/@sysprog/linux2023-quiz11) (內含作答表單)
    - [課堂問答簡記](https://hackmd.io/@sysprog/H1NdQ5AGn)

* 第 12 週 (May 1, 2, 4): 期末專題介紹和回顧
    * [課程期末專題](https://hackmd.io/@sysprog/linux2023-projects)`*`
    * Week12 隨堂測驗: [題目](https://hackmd.io/@sysprog/linux2023-quiz12) (內含作答表單)
    - [課堂問答簡記](https://hackmd.io/@sysprog/H1NdQ5AGn)

* 第 13 週 (May 8, 9, 11): 記憶體管理 + 裝置驅動程式
    * [教材解說-1](https://youtu.be/jOY159H0Iyo)`*`, [教材解說-2](https://youtu.be/eplQPz1Qegc)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
    * [The Linux Virtual Memory System](https://people.redhat.com/pladd/NUMA_Linux_VM_NYRHUG.pdf)
    * [Linux: 記憶體管理](https://hackmd.io/@sysprog/linux-memory)`*`: 記憶體管理是 Linux 核心裡頭最複雜的部分，涉及到對計算機結構、slob/slab/slub 記憶體配置器、行程和執行檔樣貌、虛擬記憶體對應的例外處理、記憶體映射, UMA vs. NUMA 等等議題。
    * [POSIX Shared Memory](http://logan.tw/posts/2018/01/07/posix-shared-memory/): 在 Linux 中要實作出共享記憶體 (shared memory) 的機制很多，例如: 1) SysV shared memory; POSIX shared memory; 3) 以 mmap 對檔案進行記憶體映射; 4) 以 memfd_create() 實作跨越行程存取; 本文章探討 POSIX shared memory 的使用，並提供完整應用案例，最後探討相關的同步議題。
    * [C 語言: 物件導向程式設計](https://hackmd.io/@sysprog/c-oop)`*`
    * [Object-oriented design patterns in the kernel, part 1](https://lwn.net/Articles/444910/) / [Object-oriented design patterns in the kernel, part 2](https://lwn.net/Articles/446317/)
        + 對照《Demystifying the Linux CPU Scheduler》 `3.1 Structs and their role: sched class`
    * [C 語言: Stream I/O, EOF 和例外處理](https://hackmd.io/@sysprog/c-stream-io)`*`
    * [CS:APP 第 10 章重點提示](https://hackmd.io/@sysprog/CSAPP-ch10)`*`
    * [Linux: 裝置驅動程式介面和模型](https://github.com/gregkh/presentation-driver-model) / [錄影](https://youtu.be/AdPxeGHIZ74)`*` by [Greg Kroah-Hartman](https://github.com/gregkh)
        + 針對 Linux v5.x 的素材請見《[The Linux Kernel Module Programming Guide](https://sysprog21.github.io/lkmpg/)》
    * [How to avoid writing device drivers for embedded Linux](http://2net.co.uk/slides/ew2016-userspace-drivers-slides.pdf) / [錄影](https://youtu.be/QIO2pJqMxjE)`*`
    * [Debugging Embedded Devices using GDB](https://elinux.org/images/0/01/Debugging-with-gdb-csimmonds-elce-2020.pdf) / [錄影](https://youtu.be/JGhAgd2a_Ck)`*`
    * [Linux: Device Tree](https://events.static.linuxfound.org/sites/events/files/slides/petazzoni-device-tree-dummies.pdf) / [錄影](https://youtu.be/m_NyYEBxfn8)`*`
    * [Linux: Timer 及其管理機制](https://hackmd.io/@sysprog/linux-timer)`*`
    * [Linux: Scalability 議題](https://hackmd.io/@sysprog/linux-scalability)`*`
    * [An Introduction to Cache-Oblivious Data Structures](https://rcoh.me/posts/cache-oblivious-datastructures/)
        - 「自動快取資料結構」，特性是無視硬體特定的快取大小，可能達到接近最優化快取的效能;
        - 在現代 CPU 多層多種大小的快取架構下，它的理論宣稱其能自動優化在所有層的快取的存取效率。傳統上電腦科學做偏理論的人不重視實作的效能表現，而實作或硬體優化的從業人員往往不重視理論分析。這個學門卻是橫跨相當理論的演算法分析（需要相當多的進階數學工具），及相當低階的硬體效能理解;
        - 影片: [Memory Hierarchy Models](https://youtu.be/V3omVLzI0WE)
        - Google Research 強者的心得: [關於變強這檔事（九）](https://medium.com/@fchern/3fd36c986313), [設計高效 Hash Table (一)](https://medium.com/@fchern/303d9713abab), [設計高效 Hash Table (二)](https://medium.com/@fchern/9b5dc744219f)
        - [Skip List](http://en.wikipedia.org/wiki/Skip_list): 置放大量數字並進行排序的資料結構。不用樹狀結構，而改用高度不同的 List 來連接資料。資料結構在概念上可以表示成 Left Child-Right Sibling Binary Tree 的模式。是 Cache-oblivious Algorithm 的經典範例，時間複雜度與空間複雜度與 Binary Search Tree 皆相同，但精心調整的實作可超越 Binary Search Tree。
        - Linux 核心: [A kernel skiplist implementation (Part 1)](https://lwn.net/Articles/551896/), [Skiplists II: API and benchmarks](https://lwn.net/Articles/553047/)
    * Linux: linked list, Queues, Maps, Binary Trees: [錄影](https://youtu.be/7ZQNb7Fu_A4)`*` / [共筆](https://docs.google.com/document/d/1n31QMPyvdAkS2uxM5AyKu_DD3uRu6-zoRukAitDwPvA/edit#)
    * [C11 atomic variables and the kernel](https://lwn.net/Articles/586838/) / [Linux Documentation: Circular Buffers](https://www.kernel.org/doc/Documentation/circular-buffers.txt)

* 第 14 週 (May 15, 16, 18): 網路封包處理
    * [教材解說](https://youtu.be/HfXYAQRLfko)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
    * 公告:
        - 5 月 16 日恢復實體課程，討論期末專題
        - 慶祝授課教師的[論文被 OSDI 採納](https://www.usenix.org/conference/osdi23/presentation/lo) (成功大學第一篇 OSDI 論文)，授課教師請學員喝飲料
        - 本週「已進行一對一討論」的學員會收到期末專題的確認信件，尚未預約討論的學員請及早進行
    * [Linux 核心網路](https://hackmd.io/@rickywu0421/BJxD_3989)
        - [socket 的譯法](https://hackmd.io/@sysprog/it-vocabulary)
    * [semu: 精簡 RISC-V 系統模擬器](https://hackmd.io/@sysprog/Skuw3dJB3): 支援 TAP/TUN 以存取電腦網路
    * [Build a virtual WiFi Driver for Linux](https://docs.google.com/presentation/d/1vlKkPRoURkqzCjZPDkvsGZVyfXtoRFF_/edit#slide=id.p1)`*` / [錄影](https://youtu.be/DZMIpBI4Rc0)
        - [背景知識](https://hackmd.io/@rickywu0421/vwifi_background), [2022 年開發紀錄](https://hackmd.io/@rickywu0421/FinalProject)
    * **[cserv](https://github.com/sysprog21/cserv)** is an event-driven and non-blocking web server.
        - 展現 [event-driven, non-blocking I/O Multiplexing](https://hackmd.io/@sysprog/fast-web-server) (主要是 [epoll](https://man7.org/linux/man-pages/man7/epoll.7.html)), shared memory, processor affinity, coroutine, context switch, UNIX signal, [dynamic linking](https://hackmd.io/@sysprog/c-dynamic-linkage), circular buffer, hash table, red-black tree, atomic operations 等議題的實際應用
        - 可視為 [seHTTPd](https://hackmd.io/@sysprog/linux2023-ktcp) 的後繼改進實作
    * [Memory Externalization With userfaultfd](http://ftp.ntu.edu.tw/pub/linux/kernel/people/andrea/userfaultfd/userfaultfd-LSFMM-2015.pdf) / [錄影](https://youtu.be/pC8cWWRVSPw)`*` / [kernel documentation: userfaults](https://www.kernel.org/doc/html/latest/admin-guide/mm/userfaultfd.html)
    - [課堂問答簡記](https://hackmd.io/@sysprog/BySO9ieSn)

* 第 15 週 (May 22, 23, 25): 網路封包處理 + 多核處理器架構
    * [教材解說-1](https://youtu.be/WwyifIQIYdY)`*`, [教材解說-2](https://youtu.be/CkgL2dVAaag)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
    * 公告:
        - 請學員及早進行 [課程期末專題](https://hackmd.io/@sysprog/linux2023-projects) 並預約一對一討論
    * [How Linux Processes Your Network Packet](https://www.slideshare.net/DevopsCon/how-linux-processes-your-network-packet-elazar-leibovich) / [錄影](https://youtu.be/3Ij0aZRsw9w)`*`
    * [Kernel packet capture technologies](https://www.slideshare.net/ennael/kernel-recipes-2015-kernel-packet-capture-technologies) / [錄影](https://youtu.be/5gEWyCW-qx8)`*`
    * [PACKET_MMAP](https://www.kernel.org/doc/Documentation/networking/packet_mmap.txt)
        - `PACKET_MMAP` 在核心空間內配置一塊核心緩衝區，一旦使用者層級的應用程式呼叫 mmap 將前述緩衝區映射到使用者層級時，接收到的 skb 會直接在該核心緩衝區，從而讓應用程式得以直接捕捉封包
        - 若沒有啟用 `PACKET_MMAP`，就只能使用低效率的 `AF_PACKET`，不但有緩衝區空間的限制，而且每次捕捉封包就要一次系統呼叫。反之，`PACKET_MMAP` 多數時候不需要呼叫系統呼叫，也能實作出 zero-copy
        - [圖解 Linux tcpdump](https://jgsun.github.io/2019/01/21/linux-tcpdump/)
    * [Multi-Core in Linux](https://youtu.be/UNI6Mbqryv0)`*`
    * [Multiprocessor OS](/11-smp_os.pdf)
        - [Arm 處理器筆記](http://wiki.csie.ncku.edu.tw/embedded/arm-smp-note.pdf)
    * 《Demystifying the Linux CPU Scheduler》
        - 2.4 Multiprocessing
        - 2.5 Energy-Aware Scheduling (EAS)
        - 3.4 Per-Entity Load Tracking
        - 4.2 Group scheduling and CPU bandwidth
        - 4.3 Control Groups
        - 4.4 Core scheduling
    * [從 CPU cache coherence 談 Linux spinlock 可擴展能力議題](https://hackmd.io/@sysprog/linux-spinlock-scalability)
    * Week15 隨堂測驗: [題目](https://hackmd.io/@sysprog/linux2023-quiz15) (內含作答表單)
    * [課堂問答簡記](https://hackmd.io/@sysprog/BySO9ieSn)

* 第 16 週 (May 29, Jun 1): 程式碼最佳化概念 + 多核處理器架構
    * [教材解說](https://youtu.be/ICRzw5Ye2sM)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
    * 公告
       - 5 月 31 日下午，財團法人開放文化基金會 (OCF) 將在國立成功大學資訊工程系舉辦校園工作坊，主題是「[開放原始碼 ——
打造護國神山的社會基礎建設](https://www.facebook.com/photo.php?fbid=630501992454129&set=a.626275629543432)」，談如何透過分享、討論和探索工程領域的秘技，利用科學與數學知識解決問題，發揮最強大的社會效益。
       - 原訂 5 月 30 日下午的實體課程因應上述活動，暫停一次
       - 及早更新 [課程期末專題](https://hackmd.io/@sysprog/linux2023-projects): 編輯「開發紀錄」頁面
       - 補課: 6 月 19 日晚間及 6 月 20 日晚間 (線上直播)
       - 期末成果發表: 6 月 24 日傍晚 (線上直播)
    * [現代硬體架構上的演算法: 以 Binary Search 為例](https://hackmd.io/@RinHizakura/BJ-Zjjw43)
        - [Beautiful Binary Search in D](https://muscar.eu/shar-binary-search-meta.html)
        - [binary_search.c](https://gist.github.com/jserv/6023c2fc2d4477fca9038b05f293a543)
    * [CS:APP 第 5 章重點提示和練習](https://hackmd.io/s/SyL8m4Lnm)`*`
    * [CS:APP Assign 5.18](https://hackmd.io/s/rkdzvWJTX)`*`
    * [Linux: Scalability 議題](https://hackmd.io/@sysprog/linux-scalability)`*`
    * [atomic 和 memory order](https://medium.com/fcamels-notes/%E7%B0%A1%E4%BB%8B-c-11-memory-model-b3f4ed81fea6), [memory barrier 的實作和效果](https://medium.com/fcamels-notes/%E5%BE%9E%E7%A1%AC%E9%AB%94%E8%A7%80%E9%BB%9E%E4%BA%86%E8%A7%A3-memry-barrier-%E7%9A%84%E5%AF%A6%E4%BD%9C%E5%92%8C%E6%95%88%E6%9E%9C-416ff0a64fc1)
    * [Linux-Kernel Memory Ordering: Help Arrives At Last!](http://www.rdrop.com/users/paulmck/scalability/paper/LinuxMM.2017.04.08b.Barcamp.pdf) / [video](https://www.youtube.com/watch?v=ULFytshTvIY)`*`
        - [I/O ordering 學習紀錄](https://hackmd.io/@butastur/rkkQEGjUN), [Memory ordering](https://hackmd.io/@Cbg1XpL0Rim8U6YOMdjgUg/rJ6NNKdqc)
        - [Experiments on Concurrency - Happens-before](https://hackmd.io/@butastur/concurrency-happens-before)
        - [Memory barriers in C](https://mariadb.org/wp-content/uploads/2017/11/2017-11-Memory-barriers.pdf)
    * Week16 隨堂測驗: [題目](https://hackmd.io/@sysprog/linux2023-quiz16) (內含作答表單)
    * [課堂問答簡記](https://hackmd.io/@sysprog/BySO9ieSn)
 
* 第 17 週 (Jun 10): 即時 Linux 的基礎建設
    * [教材解說](https://youtu.be/4kfRe8TQY9g)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
    * 公告
        - 佔學期總成績 50% 的自我評量，請在 6 月 24 日前完成。範例: [User/OscarShiang](http://wiki.csie.ncku.edu.tw/User/OscarShiang)
        - 自我評量的網址**必須**符合 `/User/你的GitHub帳號名稱` 格式 (區分大小寫)，請不要打錯字
        - 自我評分項目 (都要有對應的超連結和延伸資訊)
            * 成果發表: 與 Linux 核心相關的公開演講、貢獻到 Linux 核心和相關專案 (應標註對應的公開 commits/patches)
            * 作業/隨堂測驗: 你的開發紀錄，人在做，Google 在看
            * 期末專題: 開發紀錄，標注與授課教師「一對一討論」的時間，並列出你針對授課教師的問答、啟發及相關成果
            * 所見所聞所感，包含授課教師編撰/翻譯的書籍 (《Demystifying the Linux CPU Scheduler》, 《Concurrency Primer》, 《Linux Kernel Module Programming Guide》, 〈每位程式開發者都該有的記憶體知識〉) 的讀後，務必提及閱讀〈[因為自動飲料機而延畢的那一年](https://hackmd.io/@sysprog/r1O7Xcp12)〉和回顧自身在本課程的投入狀況
            * 自我評量: 介於 1 到 10 之間的「整數」(不要自作主張寫 `8.7` 這樣的數值) 並要能充分反映上述評分項目
    * [Re: [問卦] 精通作業系統對Coding有什麼幫助？](https://disp.cc/b/163-cidY)
    * [Linux: Timer 及其管理機制](https://hackmd.io/@sysprog/linux-timer)
    * [PREEMPT_RT 作為邁向硬即時作業系統的機制](https://hackmd.io/@sysprog/preempt-rt)
    * [Linux 核心搶佔](https://hackmd.io/@sysprog/linux-preempt)
    * [Towards PREEMPT_RT for the Full Task Isolation](https://ossna2022.sched.com/event/11NtQ)

* 第 18 週 (Jun 12, 13): 即時 Linux 的基礎建設 + 多核處理器 + Rust
    * [教材解說](https://youtu.be/VFgRAHemG0Q)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
    * 公告
        - 6 月 13 日下午是本學期最後一次實體課程，以討論期末專題為主，歡迎大家出席，授課教師請喝飲料
        - 及早進行[期末專題](https://hackmd.io/@sysprog/linux2023-projects)
        - 準備自我評量 (佔學期總分的 50%)
    * [Linux 核心搶佔](https://hackmd.io/@sysprog/linux-preempt)
    * [Towards PREEMPT_RT for the Full Task Isolation](https://ossna2022.sched.com/event/11NtQ)
    * [Customize Real-Time Linux for Rocket Flight Control System](https://osseu19.sched.com/event/TLNR)
    * [RTMux: A Thin Multiplexer To Provide Hard Realtime
Applications For Linux](https://elinux.org/images/a/a4/Huang--rtmux_a_thin_multiplexer_to_provide_hard_realtime_applications_for_linux.pdf) / [EVL](https://evlproject.org/)
    * Memory Barrier
        - [Memory Barriers in the Linux Kernel: Semantics and Practices](https://elinux.org/images/a/ab/Bueso.pdf)
        - [From Weak to Weedy: Effective Use of Memory Barriers in the ARM Linux Kernel](https://elinux.org/images/7/73/Deacon-weak-to-weedy.pdf) / [video](https://youtu.be/6ORn6_35kKo)`*` / [Cortex-A9 MPcore](https://wiki.csie.ncku.edu.tw/embedded/arm-smp-note.pdf)
    * Rust 程式語言
        - 現況: [已被 Google Android 團隊選為開發系統軟體的另一個程式語言，與 C 和 C++ 並列](https://www.phoronix.com/scan.php?page=news_item&px=Rust-For-Android-OS-System-Work); [自 2017 年 Facebook 內部採納 Rust 程式語言的專案增加，像是加密貨幣 Diem (前身為 Libra) 就將 Rust 作為主要程式語言並對外發布](https://engineering.fb.com/2021/04/29/developer-tools/rust/), 
        - [撰寫 LKMPG 的 Rust 核心模組](https://hackmd.io/@sysprog/Sk8IMQ9S2)
    * [課堂問答簡記](https://hackmd.io/@sysprog/B1RFhOBP3)

* 第 19 週 (Jun 18, 20): Rust, KVM
    * [教材解說-1](https://youtu.be/vS8U23bhidg)`*` (僅止於概況，請詳閱下方教材及個別的對應解說錄影)
    * [COSCUP 2023 議程預覽](https://pretalx.coscup.org/coscup-2023/schedule/)
    * [Rust for Linux 研究](https://hackmd.io/@hank20010209/SJmVNPMQ2)
    * [撰寫 LKMPG 的 Rust 核心模組](https://hackmd.io/@sysprog/Sk8IMQ9S2)
    * Rust 程式語言
        - Steve Klabnik 與 Carol Nichols，及 Rust 社群的協同撰寫的《The Rust Programming Language》線上書籍，由台灣的 Rust 社群提供[繁體中文翻譯](https://rust-lang.tw/book-tw/)
        - [Rust by Example](https://doc.rust-lang.org/rust-by-example/)
        - [C vs. Rust](http://www-verimag.imag.fr/~mounier/Enseignement/Software_Security/19RustVsC.pdf)
        - [Unsigned Integers Are Dangerous](https://jacobegner.blogspot.com/2019/11/unsigned-integers-are-dangerous.html)
        - [constant vs. immutable](https://hackmd.io/@jserv/By5307tsV)
    * [KVM: Linux 虛擬化基礎建設](https://hackmd.io/@sysprog/linux-kvm)
        - [Arm64 移植](https://hackmd.io/@sysprog/rkro_FeSh)
        - [RISC-V 系統模擬器，支援 VirtIO](https://hackmd.io/@sysprog/Skuw3dJB3)


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/linux2023/  

