# 并行程序设计: 执行顺序


> 多執行緒環境下，程式會出問題，往往在於執行順序的不確定性。一旦顧及分散式系統 (distributed systems)，執行順序和衍生的時序 (timing) 問題更加複雜。
> 
> 我們將從如何定義程式執行的順序開始說起，為了簡單起見，我們先從單執行緒的觀點來看執行順序這件事，其中最關鍵知識就是 Sequenced-before，你將會發現就連單執行緒的程式，也可能會產生不確定的執行順序。

<!--more-->

- {{< link href="https://hackmd.io/@sysprog/concurrency/%2F%40sysprog%2Fconcurrency-ordering" content="原文地址" external-icon=true >}}

## Evaluation

> 所謂求值 (Evaluation)，其實指二件事情，一是 value computations，對一串運算式計算的結果；另一是 side effect，亦即修改物件狀態，像是修改記憶體內變數的值、呼叫函式庫的 I/O 處理函式之類的操作。

## Sequenced-before

> sequenced-before 是種對 **同一個執行緒** 下，求值順序關係的描述。

- 若 A is sequenced-before B，代表 A 的求值會先完成，才進行對 B 的求值
- 若 A is not sequenced before B 而且 B is sequenced before A，代表 B 的求值會先完成，才開始對 A 的求值。
- 若 A is not sequenced before B 而且 B is not sequenced before A，代表兩種可能，一種是順序不定，甚至這兩者的求值過程可能會重疊（因為 CPU 重排指令交錯的關係）或不重疊。

> 而程式語言的工作，就是定義一連串關於 sequenced-before 的規範，舉例來說： 以下提到的先於、先進行之類的用詞，全部的意思都是 sequenced-before，也就是「先完成之後才開始進行」

- i++ 這類的後置運算子，value computation 會先於 side effect
- 對於 assignment operator 而言 (=, +=, -= 一類)，會先進行運算元的 value computation，之後才是 assignment 的 side effect，最後是整個 assignment expression 的 value computation。

虽然规格书定义了关于 sequenced-before 的规范，但不可能面面俱到，还是存在有些执行顺序是未定义的，例如 `f1() + f2() + f3()`，规格书只规定了 `+` 操作是在对 `f1(), f2(), f3()` 求值之后进行的，但是对于求值时的 `f1()` 这类函数呼叫，并没有规定哪个函数先进行调用求值，所以在求值时第一个调用的可能是 `f1()` 或 `f2()` 或 `f3()`。

sequenced-before 的规范缺失导致了 [partial order](https://en.wikipedia.org/wiki/Partially_ordered_set#Partial_orders) 场景的出现，二这可能会导致未定义行为，例如经典的头脑体操 `i = i++`：

{{< image src="https://imgur-backup.hackmd.io/6D8EBmH.png" >}}

出现这个未定义行为的原因是，`i++` 的 side effect 与 `=` 之间不存在 sequenced-bofore 关系 (因为 partial order)，而这会导致该语句的执行结果是不确定的 (没想到吧，单线程的程序你也有可能不确定执行顺序 :rofl:)

{{< admonition warning >}}
注意: 在 `C++17` 後，上方敘述不是未定義行為

假設 `i` 初始值為 0，由於 `=` 在 `C++17` 後為 sequenced，因此 `i++` 的計算與 side effect 都會先完成，所以 `i++` 得到 0，隨後 side-effect 導致 `i` 遞增 1，因此此時 `i` 為 1；之後執行 `i =` 這邊，所以利用右側表達式的值來指定數值，亦即剛才的 0，因此 `i` 最後結果為 0。 所以 `i` 值轉變的順序為 $0 \rightarrow 1 \rightarrow 0$，第一個箭頭為 side effect 造成的結果，第二個則是 `=` 造成的結果。
{{< /admonition >}}

- [C++ sequenced-before graphs](http://josephmansfield.uk/articles/c++-sequenced-before-graphs.html)
- [Order of evaluation from cppreference](http://en.cppreference.com/w/cpp/language/eval_order)
- [What are sequence points, and how do they relate to undefined behavior?](https://stackoverflow.com/questions/4176328/what-are-sequence-points-and-how-do-they-relate-to-undefined-behavior)

## Happens-before

短片:
- [x] [Happened Before Relationship](https://youtu.be/gGilgOSYbaI)
- [x] [Happened Before Relation (cont)](https://youtu.be/q-CwESo9UsM)

{{< image src="/images/c/happens-beore.png" >}}

从上图可以看出 happens-before 其实就是在 sequenced-before 基础上增加了多执行绪 communication 情形，可以理解为 happens-before 将 sequenced-before 扩大到涵盖多执行绪的情形了，即执行顺序有先后次序 (执行顺序其实不太准确，**执行结果显现** 的先后次序更加准确 :rofl:)

> 图中的 concurrent events 其实就是多执行绪下没有先后次序的情形

Java 规格书 [17.4.5. Happens-before Order](https://docs.oracle.com/javase/specs/jls/se17/html/jls-17.html#jls-17.4.5) 也能佐证我们的观点:
> If one action happens-before another, then the first is visible to and ordered before the second.

{{< admonition quote >}}
換言之，若望文生義說 "Happens-Before" 是「先行發生」，那就南轅北轍。Happens-Before 並非說前一操作發生在後續操作的前面，它真正要表達的是：「前面一個操作的效果對後續操作是 **可見**」。

這裡的關鍵是，Happens-before 強調 visible，而非實際執行的順序。

實際程式在執行時，只需要「看起來有這樣的效果」即可，編譯器有很大的空間可調整程式執行順序，亦即 [compile-time memory ordering](https://en.wikipedia.org/wiki/Memory_ordering#Compile-time_memory_ordering)。

因此我們得知一個關鍵概念: A happens-before B 不代表實際上 A happening before B (注意時態，後者強調進行中，前者則是從結果來看)，亦即只要 A 的效果在 B 執行之前，對於 B 是 visible 即可，實際的執行順序不用細究。
{{< /admonition >}}

C11 正式将并行和 memory order 相关的规范引入到语言的标准:
- 5.1.2.4 Multi-threaded executions and data races
> All modifications to a particular atomic object M occur in some particular total order,
> called the modification order of M. If A and B are modifications of an atomic object M,
> and A happens before B, then A shall precede B in the modification order of M, which is
> defined below.

cppreference [std::memory_order](http://en.cppreference.com/w/cpp/atomic/memory_order#Happens-before)
> Regardless of threads, evaluation A happens-before evaluation B if any of the following is true:
> 
> 1. A is sequenced-before B
> 2. A inter-thread happens before B

{{< admonition quote >}}
通常程式開發者逐行撰寫程式，期望前一行的效果會影響到後一行的程式碼。稍早已解釋何謂 Sequenced-before，現在可注意到，Sequenced-before 實際就是同一個執行緒內的 happens-before 關係。
{{< /admonition >}}

在多执行绪情况下，如果没法确保 happens-before 关系，程序往往会产生意料之外的结果，例如:

```c
int counter = 0;
```

如果现在有两个执行绪在同时执行，执行绪 A 执行 `counter++`，执行绪 B 将 `counter` 的值打印出来。因为 A 和 B 两个执行绪不具备 happens-before 关系，没有保证 `counter++` 后的效果对打印 `counter` 是可见的，导致打印出来的可能是 `1` 也可能是 `0`，这个也就是图中的 concurrent events 关系。

{{< admonition quote >}}
因此，程式語言必須提供適當的手段，讓程式開發者得以建立跨越執行緒間的 happens-before 的關係，如此一來才能確保程式執行的結果正確。
{{< /admonition >}}

### The Happens-Before Relation

- [x] [The Happens-Before Relation](https://preshing.com/20130702/the-happens-before-relation/)

> Let A and B represent operations performed by a multithreaded process. If A happens-before B, then the memory effects of A effectively become visible to the thread performing B before B is performed.

> No matter which programming language you use, they all have one thing in common: If operations A and B are performed by the same thread, and A’s statement comes before B’s statement in program order, then A happens-before B.

Happens-Before Does Not Imply Happening Before

> In this case, though, the store to A doesn’t actually influence the store to B. (2) still behaves the same as it would have even if the effects of (1) had been visible, which is effectively the same as (1)’s effects being visible. Therefore, this doesn’t count as a violation of the happens-before rule. 

Happening Before Does Not Imply Happens-Before

> The happens-before relationship only exists where the language standards say it exists. And since these are plain loads and stores, the C++11 standard has no rule which introduces a happens-before relation between (2) and (3), even when (3) reads the value written by (2).

这里说的 happens-before 关系必须要在语言标准中有规定的才算，单执行绪的情况自然在标准内，多执行绪的情况，标准一般会制定相关的同步原语之间的 happens-before 关系，例如对 mutex 的连续两个操作必然是 happens-before 关系，更多的例子见后面的 synchronized-with 部分。

## Synchronized-with

{{< admonition quote >}}
synchronized-with 是個發生在二個不同執行緒間的同步行為，當 A synchronized-with B 時，代表 A 對記憶體操作的效果，對於 B 是可見的。而 A 和 B 是二個不同的執行緒的某個操作。

不難發現，其實 synchronized-with 就是跨越多個執行緒版本的 happens-before。
{{< /admonition >}}

### 从 Java 切入

- synchronized 关键字

{{< admonition quote >}}
**Mutual Exclusive**   
對同一個物件而言，不可能有二個前綴 synchronized 的方法同時交錯執行，當一個執行緒正在執行前綴 synchronized 的方法時，其他想執行 synchronized 方法的執行緒會被阻擋 (block)。

**確立 Happens-before 關係**   
對同一個物件而言，當一個執行緒離開 synchronized 方法時，會自動對接下來呼叫 synchronized 方法的執行緒建立一個 Happens-before 關係，前一個 synchronized 的方法對該物件所做的修改，保證對接下來進入 synchronized 方法的執行緒可見。
{{< /admonition >}}

- volatile 关键字

{{< admonition quote >}}
A write to a volatile field happens-before every subsequent read of that same volatile
{{< /admonition >}}

- thread create/join

{{< image src="https://imgur-backup.hackmd.io/BWLFl2m.png" >}}

### C++ 的观点

> The library defines a number of atomic operations and operations on mutexes that are specially identified as synchronization operations. These operations play a special role in making assignments in one thread **visible** to another.

又是 visible 说明强调的还是 happens-before 这一关系 :rofl:

```c++
#include <iostream>       // std::cout
#include <thread>         // std::thread
#include <mutex>          // std::mutex

std::mutex mtx;           // mutex for critical section
int count = 0;

void print_thread_id (int id) {
    // critical section (exclusive access to std::cout signaled by locking mtx):
    mtx.lock();
    std::cout << "thread #" << id  << "  count:" << count << '\n';
    count++;
    mtx.unlock();
}
int main () {
    std::thread threads[10];
    // spawn 10 threads:
    for (int i=0; i<10; ++i)
        threads[i] = std::thread(print_thread_id,i+1);
    for (auto& th : threads) th.join();
    return 0;
}
```

这段程序里每个执行的 thread 之间都是 happens-before / synchronized-with 关系，因为它们的执行体都被 mutex 包裹了，而对 mutex 的操作是 happens-before 关系的。如果没有使用 mutex，那么 thread 之间不存在 happens-before 关系，打印出来的内容也是乱七八糟的。

- cppreference [std::mutex](https://en.cppreference.com/w/cpp/thread/mutex)
- cplusplus [std::mutex::lock](https://cplusplus.com/reference/mutex/mutex/lock/)

### 深入 Synchronizes-with

- [ ] [The Synchronizes-With Relation](https://preshing.com/20130823/the-synchronizes-with-relation/)

{{< image src="https://imgur-backup.hackmd.io/qrgwQni.png" >}}

## Memory Consistency Models

{{< admonition tip >}}
相关论文 / 技术报告 (可以用来参考理解):
- [ ] [Shared Memory Consistency Models: A Tutorial 1995 Sarita V. Adve, Kourosh Gharachorloo](https://inst.eecs.berkeley.edu/~cs252/sp17/papers/consistency-tutorial-1995.pdf)
{{< /admonition >}}


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/concurrency-ordering/  

