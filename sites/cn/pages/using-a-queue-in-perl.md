---
title: "Perl中的队列"
timestamp: 2013-05-21T09:35:21
tags:
  - push
  - shift
  - queue
  - array
  - last
  - FIFO
published: true
original: using-a-queue-in-perl
books:
  - beginner
author: szabgab
translator: terrencehan
---


有好多应用程序需要使用队列。

例如，你需要处理一个文件夹，文件夹里还有很多嵌套的子文件夹。

可能你要管理一个构建系统，其中每个单元都有一系列先决条件，而你需要遍历整个依赖树。

举一个简单的例子，你打算写个交互程序来安排看牙医的病人。

上面的情况都适用队列的方法。


## 什么是队列？

队列基本上是一个列表。新项添加在列表的结尾。当队列“向前移动”时，列表的第一项被删除，其他项目“向前移动

在计算机科学中有很多标准的数据结构。队列的抽象描述为[FIFO - 先进先出](http://en.wikipedia.org/wiki/FIFO)。第一个加入队列的也会第一个离开队列。

在Perl里，普通的数组通过`push`和`shift`函数就可以实现队列。如果你记不清这俩函数的用法，请参阅[push和shift的文章](/manipulating-perl-arrays)

来看一个例子：

```perl
#!/usr/bin/perl
use strict;
use warnings;

my @people = ("Foo", "Bar");
while (@people) {
    my $next_person = shift @people;
    print "$next_person\n"; # do something with this person

    print "Type in the names of more people:";
    while (my $new = <STDIN>) {
        chomp $new;
        if ($new eq "") {
            last;
        }
        push @people, $new;
    }
    print "\n";
}
```

这里我们使用`@people`数组来表示队列。开始的时候它有两个元素。之后在[while 循环](/while-loop)中处理队列。只要还有名字在队列中，循环就会一直持续下去。

（`while ()`循环的条件部分提供的是[标量上下文](https://perlmaven.com/scalar-and-list-context-in-perl)，数组返回的是其大小。如果数组为空，则返回0，也就是[false](/boolean-values-in-perl)；如果数组中存在元素，那么它的大小为正数，也就是Perl中的[true](/boolean-values-in-perl)。

循环内部的第一步，我们通过`shift`函数获取到队列的第一个元素，这就是牙医下一个接待的人。之后应该调用`treat($next_person);`，但是现在仅仅打印出名字。

一旦诊断结束，我们会检查一下是否还有人在等待加入队列。这个实现放在了另外一个`while`循环中，等待用户一个个输入名字。我们会删除末尾的换行符，然后检查输入是否为空。如果是空，意味着用户没有输入任何名字就直接按了回车键，那么就调用`last`来结束内部while循环，执行`print "\n";`。之后Perl会回到主`while-loop`循环的开头，来接待下一个人。如果用户输入了一个名字，它会`push`到`@people`数组的结尾，也就是队列的结尾。然后继续执行内部循坏来等待输入下一个名字。

只要不断有人来，队列的规模就会增长，但是如果没有新人加入，进程就会慢慢的处理队列中的所有人。一旦队列变为空，主while循环也就结束了。

## Abstract implementation

下面的代码是一种更抽象的形式，它使用到了[函数](/subroutines-and-functions-in-perl)（没有完全实现）。

```perl
#!/usr/bin/perl
use strict;
use warnings;

my @queue = accept_new_to_queue();
while (@queue) {
    my $next_item = shift @queue;
    handle_item($next_item);

    push @queue, accept_new_to_queue()
}

sub accept_new_to_queue {
    ...
}
sub handle_item {
    ...
}
```


## 并行或异步处理

上面的实现在简单的情况下是有效的，但是它有个很严重的问题：`accept_new_to_queue()`和`handle_item()`都是阻塞的。也就是说，当正在处理一个项时，其它项就不能添加到队列。这对于处理文件夹或者依赖列表还是可以接受的，但是在一个病人在接受治疗的时候其他人甚至不能进入候诊室未免会引发不满。

为此，你需要某种并行或异步处理的方法，这样`accept_new_to_queue()` 和 `handle_item`的执行就<b>“几乎同时进行”</b>。这里写“几乎”是因为不必平行执行，仅感觉上是这样就行。

如果你的电脑是多CPU或者多核的，理论上可以同时执行多个代码。两种主要的解决方式是<b>多线程</b>和<b>多进程</b>。在很多语言中会选择多线程开发，不过大多数Perl工程师会使用多进程。如果你也是这么选择的，请看一下CPAN的[Parallel::ForkManager](https://metacpan.org/pod/Parallel::ForkManager)模块。

关于异步和事件驱动编程，请参阅[POE](https://metacpan.org/pod/POE)。

在其它文章中，我们会看到更多的例子。


