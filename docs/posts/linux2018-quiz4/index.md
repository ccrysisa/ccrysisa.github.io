# Linux 核心设计: 2018 第 4 周测验题


<!--more-->


{{< link href="https://github.com/ccrysisa/LKI/blob/main/2018-quiz4/" content=Source external-icon=true >}}

## 测验 1

```c
#include <stdlib.h>
#include <stdio.h>
struct node { int data; struct node *next, *prev; };

void FuncA(struct node **start, int value) {
    if (!*start) {
        struct node *new_node = malloc(sizeof(struct node));
        new_node->data = value;
        new_node->next = new_node->prev = new_node;
        *start = new_node;
        return;
    }
    struct node *last = (*start)->prev;
    struct node *new_node = malloc(sizeof(struct node));
    new_node->data = value;
    new_node->next = *start;
    (*start)->prev = new_node;
    new_node->prev = last;
    last->next = new_node;
}

void FuncB(struct node **start, int value) {
    struct node *last = (*start)->prev;
    struct node *new_node = malloc(sizeof(struct node));
    new_node->data = value;
    new_node->next = *start;
    new_node->prev = last;
    last->next = (*start)->prev = new_node;
    *start = new_node;
}

void FuncC(struct node **start, int value1, int value2) {
    struct node *new_node = malloc(sizeof(struct node));
    new_node->data = value1;
    struct node *temp = *start;
    while (temp->data != value2)
        temp = temp->next;
    struct node *next = temp->next;
    temp->next = new_node;
    new_node->prev = temp;
    new_node->next = next;
    next->prev = new_node;
}

void display(struct node *start) {
    struct node *temp = start;
    printf("Traversal in forward direction \n");
    for (; temp->next != start; temp = temp->next)
	    printf("%d ", temp->data);
    printf("%d ", temp->data);
    printf("\nTraversal in reverse direction \n");
    struct node *last = start->prev;
    for (temp = last; temp->prev != last; temp = temp->prev)
	printf("%d ", temp->data);
    printf("%d ", temp->data);
    printf("\n");
}

int main() {
    struct node *start = NULL;
    FuncA(&start, 51); FuncB(&start, 48);
    FuncA(&start, 72); FuncA(&start, 86);
    FuncC(&start, 63, 51);
    display(start);
    return 0;
}
```

FuncA 的作用是
- (e) 建立新節點，內容是 value，並安插在結尾

FuncB 的作用是
- (d) 建立新節點，內容是 value，並安插在開頭

FuncC 的作用是
- (e) 找到節點內容為 value2 的節點，並在之後插入新節點，內容為 value1


在 main 函数调用 display 函数之前，链表分布为: 48 -> 51 -> 63 -> 72 -> 86

在程式輸出中，訊息 Traversal in forward direction 後依序印出哪幾個數字呢？
- (d) 48
- (c) 51
- (a) 63
- (e) 72
- (b) 86

在程式輸出中，訊息 Traversal in reverse direction 後依序印出哪幾個數字呢？
- (b) 86
- (e) 72
- (a) 63
- (c) 51
- (d) 48

{{< admonition tip >}}
在上述 doubly-linked list 實作氣泡排序和合併排序，並提出需要額外實作哪些函示才足以達成目標
{{< /admonition >}}

## 测验 2

```c
#include <stdio.h>
#include <stdlib.h>

/* Link list node */
struct node { int data; struct node *next; };

int FuncX(struct node *head, int *data) {
    struct node *node;
    for (node = head->next; node && node != head; node = node->next)
        data++;
    return node - head;
}

struct node *node_new(int data) {
    struct node *temp = malloc(sizeof(struct node));
    temp->data = data; temp->next = NULL;
    return temp;
}

int main() {
    int count = 0;
    struct node *head = node_new(0);
    head->next = node_new(1);
    head->next->next = node_new(2);
    head->next->next->next = node_new(3);
    head->next->next->next->next = node_new(4);
    printf("K1 >> %s\n", FuncX(head, &count) ? "Yes" : "No");
    head->next->next->next->next = head;
    printf("K2 >> %s\n", FuncX(head, &count) ? "Yes" : "No");
    head->next->next->next->next->next = head->next;
    printf("K3 >> %s\n", FuncX(head, &count) ? "Yes" : "No");
    head->next = head->next->next->next->next->next->next->next->next;
    printf("K4 >> %s\n", FuncX(head, &count) ? "Yes" : "No");
    printf("K5 >> %d\n", head->next->data);
    printf("count >> %d\n", count);
    return 0;
}
```

FuncX 的作用是 (涵蓋程式執行行為的正確描述最多者)
- (f) 判斷是否為 circular linked list，若為 circular 則回傳 0，其他非零值，過程中計算走訪的節點總數

K1 >> 後面接的輸出為何
- (b) Yes

K2 >> 後面接的輸出為何
- (a) No

K3 >> 後面接的輸出為何
- (a) No

K4 >> 後面接的輸出為何
- (a) No

K5 >> 後面接的輸出為何
- (f) 0

count >> 後面接的輸出為何
- (f) 0



---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/linux2018-quiz4/  

