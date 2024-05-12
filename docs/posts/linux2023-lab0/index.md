# Linux 核心设计: lab0-c


{{&lt; admonition abstract  &#34;预期目标&#34; &gt;}}

- [C 语言程序设计](https://hackmd.io/@sysprog/c-programming) 议题，如 [不定个参数的处理](https://en.wikibooks.org/wiki/C_Programming/stdarg.h)，[signal](https://en.wikibooks.org/wiki/C_Programming/signal.h)，[setjmp/longjmp](https://en.wikibooks.org/wiki/C_Programming/setjmp.h)
- 学习 [GNU/Linux 开发工具](https://hackmd.io/@sysprog/gnu-linux-dev):
  - [Cppcheck](https://cppcheck.sourceforge.io/): **静态** 程序分析工具，即无需运行程序就可以分析出程序潜在的问题，当然会有一定的误差，类似的工具有 [cargo-check](https://doc.rust-lang.org/cargo/commands/cargo-check.html)
  - [Valgrind](https://valgrind.org/): **动态** 程序分析工具，即需要将程序运行起来再进行分析，通常用于检测内存泄漏 ([memory leak](https://en.wikipedia.org/wiki/Memory_leak))
- 学习使用 Git 与 GitHub
- 树立一致且易于协作的程序开发规范
- 研究自动测试机制
- 接触 [Linux Programming INterface](http://man7.org/tlpi/)
- 理解电脑乱数原理、应用场景，和相关的验证
- 研究 Linux 核心链表的实作机制，及其高效的排序实作

{{&lt; /admonition &gt;}}

&lt;!--more--&gt;

- {{&lt; link href=&#34;https://hackmd.io/@sysprog/linux2023-lab0&#34; content=&#34;原文地址&#34; external-icon=true &gt;}}

## 改写自 CMU 计算机系统概论的作业

[lab0-c](https://github.com/sysprog21/lab0-c) 改写自 CMU 的 [15-213/15-513 Introduction to Computer Systems (ICS)](http://www.cs.cmu.edu/~213/index.html) 课程的 [C Programming Lab: Assessing Your C Programming Skills](https://www.cs.cmu.edu/afs/cs/academic/class/15213-s20/www/labs/cprogramminglab.pdf)，用于检验学生对于 C 语言程序设计认知。

- [x] [LeetCode 2095. Delete the Middle Node of a Linked List](https://leetcode.com/problems/delete-the-middle-node-of-a-linked-list/)
- [x] [LeetCode 82. Remove Duplicates from Sorted List II](https://leetcode.com/problems/remove-duplicates-from-sorted-list-ii/)
- [x] [LeetCode 24. Swap Nodes in Pairs](https://leetcode.com/problems/swap-nodes-in-pairs/)
- [x] [LeetCode 25. Reverse Nodes in k-Group](https://leetcode.com/problems/reverse-nodes-in-k-group/)
- [x] [LeetCode 2487. Remove Nodes From Linked List](https://leetcode.com/problems/remove-nodes-from-linked-list/) / [参考题解](https://leetcode.com/problems/remove-nodes-from-linked-list/solutions/4188092/simple-easy-cpp-solution-with-explanation/)
- [x] [LeetCode 23. Merge k Sorted Lists](https://leetcode.com/problems/merge-k-sorted-lists/)

头文件 [list.h](https://github.com/sysprog21/lab0-c/blob/master/list.h) 依据 Linux 核心风格实作了相应的 linked list 常用操作的宏，这个文件对于本次实验很重要，需要仔细阅读并在实验过程中使用这些宏来简化程式码。

### q_size

```c
/* Return number of elements in queue */
int q_size(struct list_head *head)
 {
    if (!head) return 0;

    int len = 0;
    struct list_head *li;

    list_for_each (li, head)
        len&#43;&#43;;
    return len;
}
```

### q_new &amp; q_free

- `q_new` 使用 `malloc` 分配空间，并使用 `INIT_LIST_HEAD` 进行初始化。
- `q_free` 遍历 queue 进行逐个节点释放，所以需要使用 `_safe` 后缀的 for_each 宏，释放时需要先释放成员 `value`，再释放节点 (回想一下 C&#43;&#43; 的析构函数)，可以直接使用 `q_release_element` 函数。

&gt; `q_free` 在遍历时需要释放当前节点所在元素的空间，所以需要使用 `list_for_each_entry_safe`，而 `q_size` 无需在遍历时修改当前节点，所以使用 `list_for_each` 就足够了。

### q_insert &amp; q_remove

insert 时需要特判 head 是否为 NULL 以及 malloc 分配是否成功，接下来需要使用 `strdup` 对所给参数进行复制 (`strdup` 内部是通过 `malloc` 来实现的，所以之前 `q_free` 时也需要是否 `value`)，最后根据插入的位置调用 `list_add` 或 `list_add_tail` 进行插入。

remove 时需要特判 head 是否为 NULL 以及 queue 是否为空，接下来根据需要 remove 的节点调用 `list_first_entry` 或 `list_last_entry` 获取节点对应的元素，通过 `list_del_init` 来清除出 queue，最后如果 `value` 字段不为 NULL，则通过 `memcpy` 将 `value` 字段对应的字符串复制到指定位置。

关于 [lab0-c]() 相关命令的使用，可以参照阅读后面的「取得程式码并进行开发」部分。

```bash
$ ./qtest
cmd&gt; help
Commands:
  #           ...          | Display comment
  dedup                    | Delete all nodes that have duplicate string
  descend                  | Remove every node which has a node with a strictly greater value anywhere to the right side of it
  dm                       | Delete middle node in queue
  free                     | Delete queue
  help                     | Show summary
  ...
```

{{&lt; admonition &gt;}}
- [Difference between &#34;delete&#34; and &#34;remove&#34;](https://english.stackexchange.com/questions/52508/difference-between-delete-and-remove)

Delete and remove are defined quite similarly, but the main difference between them is that delete means erase (i.e. rendered nonexistent or nonrecoverable), while remove connotes take away and set aside (but kept in existence).

In your example, if the item is existent after the removal, just say remove, but if it ceases to exist, say delete.
{{&lt; /admonition &gt;}}

## 开发环境设定

安装必要的开发工具包:
```bash
$ sudo apt install build-essential git-core valgrind
$ sudo apt install cppcheck clang-format aspell colordiff
```

基本的 Linux 命令行操作，可参考 [鸟哥的 Linux 私房菜的](https://linux.vbird.org/) 相关章节:
- [Linux 的檔案權限與目錄配置](https://linux.vbird.org/linux_basic/centos7/0210filepermission.php)
- [Linux 檔案與目錄管理](https://linux.vbird.org/linux_basic/centos7/0220filemanager.php)
- [檔案與檔案系統的壓縮、打包與備份](https://linux.vbird.org/linux_basic/centos7/0240tarcompress.php)

{{&lt; admonition success &gt;}}
&#34;If I had eight hours to chop down a tree, I’d spend six hours sharpening my axe.&#34; – Abraham Lincoln

「工欲善其事，必先利其器」
{{&lt; /admonition &gt;}}

## 取得程式码并进行开发

建立开发目录:
```bash
$ cd ~
$ mkdir -p linux2023
```

从 GItHub 获取 [lab-c] 程式码:
```bash
$ git clone git@github.com:&lt;username&gt;/lab0-c
# or
$ git clone https://github.com/&lt;username&gt;/lab0-c
```

切换的 `lab0-c` 目录并进行编译:
```bash
$ cd lab0-c
$ make
```

预期看到以下输出:
```bash
  CC	qtest.o
  CC	report.o
  CC	console.o
  CC	harness.o
  CC	queue.o
  CC	random.o
  CC	dudect/constant.o
  CC	dudect/fixture.o
  CC	dudect/ttest.o
  CC	shannon_entropy.o
  CC	linenoise.o
  CC	web.o
  LD	qtest
```

也可以清除编译输出的档案 (一般是可执行文件和目标文件):
```bash
$ make clean
```

可以通过以下命令设定编译时输出的细节：
```bash
$ make VERBOSE=1
```

这样编译时会输出更多细节:
```bash
$ make
gcc -o qtest.o -O1 -g -Wall -Werror -c -MMD -MF .qtest.o.d qtest.c
gcc -o report.o -O1 -g -Wall -Werror -c -MMD -MF .report.o.d report.c
gcc -o console.o -O1 -g -Wall -Werror -c -MMD -MF .console.o.d console.c
gcc -o harness.o -O1 -g -Wall -Werror -c -MMD -MF .harness.o.d harness.c
gcc -o queue.o -O1 -g -Wall -Werror -c -MMD -MF .queue.o.d queue.c
gcc -o qtest qtest.o report.o console.o harness.o queue.o
```

即最终的执行档案为 `qtest`。接下来可以通过以下命令来测试 `qtest`:
```bash
$ make check
./qtest -v 3 -f traces/trace-eg.cmd
cmd&gt; 
cmd&gt; # Demonstration of queue testing framework
cmd&gt; # Use help command to see list of commands and options
cmd&gt; # Initial queue is NULL.
cmd&gt; show
q = NULL
cmd&gt; # Create empty queue
cmd&gt; new
q = []
cmd&gt; # Fill it with some values.  First at the head
cmd&gt; ih dolphin
```

即将 [traces/trace-eg.cmd](https://github.com/sysprog21/lab0-c/blob/master/traces/trace-eg.cmd) 的内容作为测试命令指派给 `qtest` 执行。

由输出可以得知命令 `make check` 只是对一些基本功能进行测试，可以通过以下命令进行全面覆盖的测试:
```bash
$ make test
```

这个命令也是本次实验的自动评分系统，其实际执行了 [scripts/driver.py](https://github.com/sysprog21/lab0-c/blob/master/scripts/driver.py) 这个 Python 程序，这个程序的基本逻辑就是将 traces/trace-XX-CAT.cmd 这类内容作为测试命令指派给 `qtest` 内部的命令解释器进行执行，并依据测试结果计算相应的分数。

通过以下命令会开启 [AddressSanitizer](https://github.com/google/sanitizers/wiki/AddressSanitizer) 从而强化执行时期的内存检测，在进行测试时会输出相应的内存检测信息:
```bash
$ make SANITIZER=1
$ make test
# the following output as an example
==8522==ERROR: AddressSanitizer: SEGV on unknown address 0x000000000008 (pc 0x55ea517092cb bp 0x7ffe778b4900 sp 0x7ffe778b4900 T0)
==8522==The signal is caused by a READ memory access.
==8522==Hint: address points to the zero page.
    #0 0x55ea517092ca in q_remove_head lab0-c/queue.c:74
    #1 0x55ea51704880 in do_remove_head lab0-c/qtest.c:311
    #2 0x55ea51707054 in interpret_cmda lab0-c/console.c:217
    #3 0x55ea51707a58 in interpret_cmd lab0-c/console.c:240
    #4 0x55ea51708725 in cmd_select lab0-c/console.c:568
    #5 0x55ea51708b42 in run_console lab0-c/console.c:627
    #6 0x55ea51705c7d in main lab0-c/qtest.c:700
    #7 0x7facce0d8b96 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6&#43;0x21b96)
    #8 0x55ea51703819 in _start (lab0-c/qtest&#43;0x5819)
```

- [Address/Thread/Memory Sanitizer](https://www.slideshare.net/sermp/sanitizer-cppcon-russia)
- [A look into the sanitizer family (ASAN &amp; UBSAN) by Akul Pillai](https://www.slideshare.net/slideshow/a-look-into-the-sanitizer-family-asan-ubsan-by-akul-pillai/135506952)

### clang-format 工具和一致的程序撰写风格

需要在当前目录或指定路径有 `.clang-format` 文件，然后通过以下使用方式:
```bash
$ clang-format -i *.[ch]
```

&gt; 相关程序风格查看原文即可

### Git Hooks 进行自动程式码排版检查

第一次 make 后，Git pre-commit / pre-push hook 将被自动安装到当前的工作区 (workspace)，之后每次执行 git commit 時，[Git hook](https://www.atlassian.com/git/tutorials/git-hooks) 都会检查 C/C&#43;&#43; 的代码风格是否与 `.clang-format` 要求的一致，并同时通过 [Cppcheck](http://cppcheck.sourceforge.net/) 进行静态程序分析检查。

{{&lt; admonition tip &gt;}}
tig 可以更加方便的浏览 git repository 的信息:
```bash
# install
$ sudo apt install tig
# read the manual
$ tig --help
# or if you have installed tldr
$ tldr tig
```
{{&lt; /admonition &gt;}}

怎么写好一个 Git Commit:
- 英文原文: [How to Write a Git Commit Message](https://cbea.ms/git-commit/)
- 中文翻译: [如何寫一個 Git Commit Message](https://blog.louie.lu/2017/03/21/%E5%A6%82%E4%BD%95%E5%AF%AB%E4%B8%80%E5%80%8B-git-commit-message/)

The seven rules of a great Git commit message:
1. Separate subject from body with a blank line
2. Limit the subject line to 50 characters
3. Capitalize the subject line
4. Do not end the subject line with a period
5. Use the imperative mood in the subject line
6. Wrap the body at 72 characters
7. Use the body to explain what and why vs. how

{{&lt; admonition &gt;}}
請避免用 `$ git commit -m`，而是透過編輯器調整 git commit message。許多網路教學為了行文便利，用 `$ git commit -m` 示範，但這樣很容易讓人留下語焉不詳的訊息，未能提升為好的 Git Commit Message。因此，從今以後，不要用 `git commit -m`, 改用 `git commit -a` (或其他參數) 並詳細查驗變更的檔案。
{{&lt; /admonition &gt;}}

设置 Git 的默认编辑器为 Vim:
```bash
$ git config --global core.editor vim
```

### GitHub Actions 设定

&gt; GitHub Actions 是 GitHub 提供的 CI/CD 服務，CI/CD 代表的是 Continuous Integration 持續整合與 Continuous Deployment 持續部署，簡單來說就是將程式流程自動化。lab0-c 提供幾項自動化測試，包含：檢查排版、編譯結果和自動評分等等。這裡需要注意的是 fork 完成後，預設情況下 GitHub Action 不會被啟動，所以需要 **手動開啟 GitHub Actions**，在你所 fork 出的 repository 的 Actions 內點選 `I understand my workflows, go ahead and enable them`

&gt; 開啟 GitHub Actions 後，當每次 push 到遠端時，GitHub 就會自動測試作業設計的檢查項目，當有錯誤時會收到 CI failed 的 email 通知。

&gt; 在現有的 GitHub Actions 對應的測試項目中，一旦收到 `git push` 的事件，系統就會自動執行 `make test`，並在失敗時發信件通知學員。

&gt; 點擊信件中的 `View workflow run` 即可在 GitHub 網站中得知 GitHub Actions 的測試狀況。

## 以 Valgrind 分析内存问题

[Valgrind](https://valgrind.org/) is an instrumentation framework for building dynamic analysis tools. There are Valgrind tools that can automatically detect many memory management and threading bugs, and profile your programs in detail. You can also use Valgrind to build new tools.

使用方式:
```bash
$ valgrind --tool=&lt;toolname&gt; &lt;program&gt;
```

- [Valgrind is NOT a leak checker](http://maintainablecode.logdown.com/posts/245425-valgrind-is-not-a-leak-checker)
&gt; Valgrind is an undefined behavior checking tool first, a function and memory profiler second, a data-race detection tool third, and a leak checking tool last.

{{&lt; admonition quote &gt;}}
dynamic Binary Instrumentation (DBI) 著重於二進位執行檔的追蹤與資訊彙整，而 dynamic Binary Analysis (DBA) 則強調對收集資訊的分析。上述 Valgrind 是個 DBI 系統框架，可建構一系列 DBA 工具，藉由 shadow values 技術來實作，後者要求對所有的暫存器和使用到的主記憶體做 shadow (即自行維護的副本)，這也使得 Valgrind 相較其他分析方法會較慢。
{{&lt; /admonition &gt;}}

{{&lt; admonition quote &gt;}}
也就是說，[Valgrind](https://valgrind.org/) 主要的手法是將暫存器和主記憶體的內容自行維護副本，並在任何情況下都可以安全正確地使用，同時記錄程式的所有操作，在不影響程式執行結果前提下，輸出有用的資訊。為了實作功能，[Valgrind](https://valgrind.org/) 利用 [dynamic binary re-compilation](https://en.wikipedia.org/wiki/Dynamic_recompilation) 把測試程式 (稱為 client 程式) 的機械碼解析到 VEX 中間表示法 (intermediate representation，簡稱 IR，是種虛擬的指令集架構，規範在原始程式碼 [VEX/pub/libvex_ir.h](https://sourceware.org/git/?p=valgrind.git;a=blob;f=VEX/pub/libvex_ir.h))。VEX IR 在 [Valgrind](https://valgrind.org/) 採用執行導向的方式，以 just-in-time (JIT) 編譯技術動態地把機械碼轉為 IR，倘若觸發特定工具感興趣的事件 (如記憶體配置)，就會跳躍到對應的處理工具，後者會插入一些分析程式碼，再把這些程式碼轉換為機械碼，儲存到 code cache 中，以利後續需要時執行。

```
Machine Code --&gt; IR --&gt; IR --&gt; Machine Code
        ^        ^      ^
        |        |      |
    translate    |      |
                 |      |
            instrument  |
                        |
                     translate  
```
{{&lt; /admonition &gt;}}


Valgrind 启动后会对 client 程序进行转换，所以 Valgrind 执行的是加工后的 client 程序:
- 2007 年的论文: [Valgrind: A Framework for Heavyweight Dynamic Binary Instrumentation](https://valgrind.org/docs/valgrind2007.pdf)
- 繁体中文版本的 [论文导读](https://wdv4758h-notes.readthedocs.io/zh_TW/latest/valgrind/dynamic-binary-instrumentation.html)

### Valgrind 使用案例

安装调试工具以让 Valgrind 更好地进行分析:
```bash
$ sudo apt install libc6-dbg
```

#### Memory Leak

常见错误有: `malloc` 了一个空间但没 `free` 导致内存泄露

memory lost:
- definitely lost
- indirectly lost
- possibly lost
- still readchable

运行 valgrind 和 gdb 类似，都需要使用 `-g` 参数来编译 C/C&#43;&#43; 源程序以生成调试信息，然后还可以通过 `-q` 参数指示 valgrind 进入 quite 模式，减少启动时信息的输出。

```bash
$ valgrind -q --leak-check=full ./case1
```

- `--leak-check=full`: 启用全面的内存泄漏检查，valgrind 将会报告所有的内存泄漏情况，包括详细的堆栈跟踪信息
- `--show-possibly-lost=no`: 不输出 possibly lost 相关报告
- `--track-fds=yes`: 侦测 file descriptor 开了没关的情况

#### Invalid Memory Access

常见错误有: `malloc` 了并 `free` 但又对这个已经被 free 的空间进行操作，即 [Use After Free](https://cwe.mitre.org/data/definitions/416.html)

&gt; valgrind 输出的报告 invalid write/read 这类的单位是 Byte，即 size of X (bytes)

#### Other

- `Conditional jump or move depends on uninitialised value(s)` 这个错误一般是因为使用了没有结束字符 (null-terminated string) 的字符串
- 不同函数使用了不合法的栈空间，例如函数 A 使用了已经返回了的函数 B 的栈空间，这样的操作是不合法的
- 对局部变量的存取超过范围会导致 `stack corrupt` (个人感觉等同 stack overflow)

程序运行时的内存布局:

{{&lt; image src=&#34;https://i.imgur.com/OhqUECc.png&#34; &gt;}}

Valgrind 配合 [Massif](https://valgrind.org/docs/manual/ms-manual.html) 可以对程序运行时的内存行为进行可视化:

{{&lt; image src=&#34;https://imgur.com/F7hbcsN.png&#34; &gt;}}

{{&lt; admonition info &gt;}}
- [Valgrind User Manual](https://valgrind.org/docs/manual/manual.html)
- [Massif: a heap profiler](https://valgrind.org/docs/manual/ms-manual.html)
{{&lt; /admonition &gt;}}

lab0-c 也引入了 Valgrind 来协助侦测实验过程中可能出现的内存相关问题，例如 [memory leak](https://en.wikipedia.org/wiki/Memory_leak), [buffer overflow](https://en.wikipedia.org/wiki/Buffer_overflow), [Dangling pointer](https://en.wikipedia.org/wiki/Dangling_pointer) 等等。使用方式如下:
```bash
$ make valgrind
```

## 自动测试程序

- [signal](https://man7.org/linux/man-pages/man7/signal.7.html)
- 异常执行流

### 追踪内存的分配和释放

- [x] Wikipedia: [Hooking](https://en.wikipedia.org/wiki/Hooking)
- [x] Wikipedia: [Test harness](https://en.wikipedia.org/wiki/Test_harness)
- [x] GCC: [Arrays of Length Zero](https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html)
&gt; The alignment of a zero-length array is the same as the alignment of its elements.

{{&lt; image src=&#34;https://imgur-backup.hackmd.io/j1fRN0B.png&#34; &gt;}}
{{&lt; image src=&#34;https://imgur-backup.hackmd.io/nkCgAZL.png&#34; &gt;}}

- [ ] [C Struct Hack - Structure with variable length array](https://frankchang0125.blogspot.com/2013/01/c-struct-hack-structure-with-variable.html)

相关源代码阅读 ([harness.h](https://github.com/sysprog21/lab0-c/blob/master/harness.h), [harness.c](https://github.com/sysprog21/lab0-c/blob/master/harness.c)):

```c
typedef struct __block_element {
    struct __block_element *next, *prev;
    size_t payload_size;
    size_t magic_header; /* Marker to see if block seems legitimate */
    unsigned char payload[0];
    /* Also place magic number at tail of every block */
} block_element_t;

/* Find header of block, given its payload.
 * Signal error if doesn&#39;t seem like legitimate block
 */
block_element_t *find_header(void *p);

/* Given pointer to block, find its footer */
size_t *find_footer(block_element_t *b);

/* Implementation of application functions */
void *test_malloc(size_t size);

// cppcheck-suppress unusedFunction
void *test_calloc(size_t nelem, size_t elsize);

void test_free(void *p);
```

### qtest 命令解释器

新增指令 hello，用于打印 `Hello, world&#34;` 的信息。调用流程:
```
main → run_console → cmd_select → interpret_cmd → interpret_cmda → do_hello
```

相关源代码阅读 ([console.h](https://github.com/sysprog21/lab0-c/blob/master/console.h), [console.c](https://github.com/sysprog21/lab0-c/blob/master/console.c)):

```c
typedef struct __cmd_element {...} cmd_element_t;

/* Optionally supply function that gets invoked when parameter changes */
typedef void (*setter_func_t)(int oldval);

/* Integer-valued parameters */
typedef struct __param_element {...} param_element_t;

/* Initialize interpreter */
void init_cmd();

/* Add a new command */
void add_cmd(char *name, cmd_func_t operation, char *summary, char *parameter);
#define ADD_COMMAND(cmd, msg, param) add_cmd(#cmd, do_##cmd, msg, param)

/* Add a new parameter */
void add_param(char *name, int *valp, char *summary, setter_func_t setter);

/* Execute a command that has already been split into arguments */
static bool interpret_cmda(int argc, char *argv[])
```

{{&lt; admonition danger &gt;}}
原文的「命令直译器的初始化准备」部分，示例的代码片段与最新的代码有许多差别 (特别是结构体的名称)，一定要搭配阅读最新的源码，否则会十分迷糊。
{{&lt; /admonition &gt;}}

### Signal 处理和应用

Linux manual page:

- [signal(2)](https://man7.org/linux/man-pages/man2/signal.2.html)
&gt; signal() sets the disposition of the signal signum to handler, which is either SIG_IGN, SIG_DFL, or the address of a  programmer-defined  function (a &#34;signal handler&#34;).

```c {title=&#34;qinit.c&#34;}
static void q_init()
{
    fail_count = 0;
    INIT_LIST_HEAD(&amp;chain.head);
    signal(SIGSEGV, sigsegv_handler);
    signal(SIGALRM, sigalrm_handler);
}
```

- [alarm(2)](https://man7.org/linux/man-pages/man2/alarm.2.html)
&gt; alarm() arranges for a SIGALRM signal to be delivered to the calling process in seconds seconds. If seconds is zero, any pending alarm is canceled. In any event any previously set alarm() is canceled.

- [setjmp(3)](https://man7.org/linux/man-pages/man3/longjmp.3.html)
&gt; The functions described on this page are used for performing
&gt; &#34;nonlocal gotos&#34;: transferring execution from one function to a
&gt; predetermined location in another function.  The setjmp()
&gt; function dynamically establishes the target to which control will
&gt; later be transferred, and longjmp() performs the transfer of
&gt; execution.

- [sigsetjmp(3)](https://linux.die.net/man/3/sigsetjmp)
&gt; setjmp() and sigsetjmp() return 0 if returning directly, and nonzero when returning from longjmp(3) or siglongjmp(3) using the saved context.

Why use `sigsetjmp()`/`siglongjmp()` instead of `setjmp()`/`longjmp()`? 

- [The Linux Programming Interface](https://man7.org/tlpi/)

&gt; The sa_mask field allows us to specify a set of signals that aren’t permitted to interrupt execution of this handler. In addition, the signal that caused the handler to be invoked is automatically added to the process signal mask. This means that a signal handler won’t recursively interrupt itself if a second instance of the same signal arrives while the handler is executing.

&gt; However, there is a problem with using the standard longjmp() function to exit from a signal handler. We noted earlier that, upon entry to the signal handler, the kernel automatically adds the invoking signal, as well as any signals specified in the act.sa_mask field, to the process signal mask, and then removes these signals from the mask when the handler does a normal return.
&gt; 
&gt; What happens to the signal mask if we exit the signal handler using longjmp()? The answer depends on the genealogy of the particular UNIX implementation.

{{&lt; admonition quote &gt;}}
簡言之，當某個 signal handler 被觸發時，該 signal 會在執行 signal handler 時會被遮罩住，並在 signal handler 回傳時恢復。而，在裡面使用 longjmp 時，解除訊號遮罩的行為有可能不會發生(是否解除則依照實作決定)。為了保證在非區域跳躍後能夠恢復，所以 POSIX 另行規範得以在 signal handler 中呼叫的 `sigsetjmp` 跟 `siglongjmp`。
{{&lt; /admonition &gt;}}

- `jmp_ready` 技巧 (用于保证在 `siglongjmp()` 之前必然执行过一次 `sigsetjmp()`):
&gt; Because a signal can be generated at any time, it may actually occur before the target of the goto has been set up by sigsetjmp() (or setjmp()). To prevent this possibility (which would cause the handler to perform a nonlocal goto using an uninitialized env buffer), we employ a guard variable, canJump, to indicate whether the env buffer has been initialized. If canJump is false, then instead of doing a nonlocal goto, the handler simply returns.

在执行 `siglongjmp` 之前执行一次 `sigsetjmp` 是必须的，这用于保存 `sigsetjmp` 所处地方的上下文，而 `sigsetjmp` 所处地方正是 `siglongjmp` 执行时需要跳转到的地方，所以为了保证长跳转后执行符合预取，需要保存上下文。

```c
void trigger_exception(char *msg)
{
    ...
    if (jmp_ready)
        siglongjmp(env, 1);
    else
        exit(1);
}

bool exception_setup(bool limit_time)
{
    if (sigsetjmp(env, 1)) {
        /* Got here from longjmp */
        jmp_ready = false;
        ...
    } else {
        /* Got here from initial call */
        jmp_ready = true;
        ...
    }
}
```

相关源代码阅读 ([qtest.c](https://github.com/sysprog21/lab0-c/blob/master/qtest.c), [report.h](https://github.com/sysprog21/lab0-c/blob/master/report.h), [report.c](https://github.com/sysprog21/lab0-c/blob/master/report.c), [harness.h](https://github.com/sysprog21/lab0-c/blob/master/harness.h), [harness.c](https://github.com/sysprog21/lab0-c/blob/master/harness.c)):

```c
/* Signal handlers */
static void sigsegv_handler(int sig);
static void sigalrm_handler(int sig)

/* Use longjmp to return to most recent exception setup */
void trigger_exception(char *msg);

/* Prepare for a risky operation using setjmp.
 * Function returns true for initial return, false for error return
 */
bool exception_setup(bool limit_time);

void report_event(message_t msg, char *fmt, ...);
```

### 检测非预期的内存操作或程序执行超时

由上面可知，当收到 `SIGSEGV` 或 `SIGALRM` 信号时，会通过 `signal handler` :arrow_right: `trigger_exception` :arrow_right: `exception_setup` 这一条链路执行。那么当 `exception_setup` 函数返回时会跳转到哪里呢？

在 [qtest.c]() 的形如 `do_&lt;operation&gt;` 这类函数里面，都会直接或间接的包含以下的程式码:
```c
if (exception_setup(true)) {
    ...
}
exception_cancel();
```

&gt; 回到稍早提及的 `if (exception_setup(true))` 敘述中，若是第一次回傳，那麼會開始測試函式。若測試函式的過程中，發生任何錯誤 (亦即觸發 `SIGSEGV` 或 SIGALRM 一類的 `signal`)，就會立刻跳回 signal handler。signal handler 會印出錯誤訊息，並進行 `siglongjmp`。由 `exception_setup` 的程式可以知道又是跳到 `exception_setup(true)` 裡面，但這時會回傳 `false`，因而跳過測試函式，直接結束測試並回傳 `ok` 內含值。換言之，`exception_cancel()` 後就算再發生 `SIGALRM` 或 `SIGSEGV`，也不會再有機會回到 exception_setup() 裡面。

## 整合网页服务器

### 整合 tiny-web-server

- [tiny-web-server](https://github.com/7890/tiny-web-server)

{{&lt; admonition danger &gt;}}
原文的示例的代码片段与最新的代码有许多差别 (特别是函数的名称)，一定要搭配阅读最新的源码，否则会十分迷糊。
{{&lt; /admonition &gt;}}

程序等待输入的调用链 ([linenoise.c](https://github.com/sysprog21/lab0-c/blob/master/linenoise.c)):
```
linenoise() -&gt; line_raw() -&gt; line_edit()
```

但 `line_edit` 中是使用 `read` 等待用户输入，所以当 `read` 阻塞时就无法接收来自 web 传来的信息。尝试使用 `select()` 来同时处理标准输入 `stdin` 和网络 `socket`。

- [select(2)](https://man7.org/linux/man-pages/man2/select.2.html)
&gt; On success, select() and pselect() return the number of file
&gt; descriptors contained in the three returned descriptor sets (that
&gt; is, the total number of bits that are set in readfds, writefds,
&gt; exceptfds).  The return value may be zero if the timeout expired
&gt; before any file descriptors became ready.
&gt; 
&gt; On error, -1 is returned, and errno is set to indicate the error;
&gt; the file descriptor sets are unmodified, and timeout becomes
&gt; undefined.

{{&lt; image src=&#34;https://hackmd.io/_uploads/HJ0_t8Kf9.jpg&#34; content=&#34;I/O Multiplexing Model&#34; &gt;}}

`select` 和 `poll` 都是上图所示的多路 I/O 复用的模型，优势在于可以同时处理多个 file descriptor，但缺点在于需要使用 2 次 syscall，第一次是等待 kernel 发出通知，第二次是从 kernel 拷贝数据，每次 syscall 都需要进行 context switch，导致这个模型比其他的 I/O 模型开销大 (context switch 开销是很大的)。

相关源代码阅读 ([linenoise.h](https://github.com/sysprog21/lab0-c/blob/master/linenoise.h), [linenoise.c](https://github.com/sysprog21/lab0-c/blob/master/linenoise.c), [console.c](https://github.com/sysprog21/lab0-c/blob/master/console.c)):

## 在 qtest 提供新命令 shuffle


---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/linux2023-lab0/  

