---
title: "POD - Plain Old Documentation "
timestamp: 2013-04-22T18:40:59
tags:
  - POD
  - perldoc
  - =head1
  - =cut
  - =pod
  - =head2
  - documentation
  - pod2html
  - pod2pdf
published: true
original: pod-plain-old-documentation-of-perl
books:
  - beginner
author: szabgab
translator: swuecho
---



许多程序员不愿意写文档，原因之一就是代码写在文本文件中，文档却要在专门的文字排版软件中写。
这就要求程序员要学习排版的细节，而不是把所有的精力都放到内容本身上来。

Perl 中，程序和文档一般是写在同一个文件中的，程序员不必在琐碎的排版细节上浪费精力。


本节 [Perl 教程](/perl-tutorial) 中，我们学习 Perl 文档格式标准 <b>POD - Plain Old Documentation</b>。

下面是一个简单的例子：

```perl
#!/usr/bin/perl
use strict;
use warnings;

=pod

=head1 DESCRIPTION

This script can have 2 parameters. The name or address of a machine
and a command. It will execute the command on the given machine and
print the output to the screen.

=cut

print "Here comes the code ... \n";
```

保存以上代码到`script.pl`。`perl script.pl`运行，输出与去掉 ` =pod `和 ` =cut `之间的内容是一样的。

如果你在终端中键入， `perldoc script.pl`，输出却是`=pod` and `=cut` 之间的部分。
perl 和 perldoc 在这里功能正好想反，前者执行代码部分，后者提取文档部分，然后根据POD 的相应输出标准输出。

输出的格式标准参见[Perl 标准文档](https://perlmaven.com/core-perl-documentation-cpan-module-documentation).

直接在代码中插入 POD 的好处是，文档和代码在一起，比不必维护两个文件。

## 太简单了？

确实如此，POD 的设计就是尽可能简单。不过，简单不等与简陋，你看看[Meta CPAN](http://metacpan.org/) 上，
的Perl文档，就知道了。

## 文档格式标准

详细的标准可以参考：[POD markup language](http://perldoc.perl.org/perlpod.html)。[perldoc perlpod](http://perldoc.perl.org/perlpod.html) 命令就可以查看。这里学习最基本的概念。

 
`=head1` and `=head2` 相当与 html 中的`<h1></h1>` 和 `<h2></h2>` 。
`=over`  用来设置缩进，`=item` 创建列表。当然还有更多，不过，仅这些，多数情况下就够用了。

`=cut` 用来标记 POD 部分的结束，`=pod`  标记开始。


所有以`=` 开头的行，都会被当作是 POD 的一部分。

POD 也可以插入链接，格式是L&lt;some-link> 。

在POD 中，没有特殊标记的部分，会显示为普通文本段落。


如果文本行，缩进不为 0，显示时不会做任何处理，比如，不会重新断行。代码通常用这种格式。


需要注意的是，两个特殊标记需要用空行隔开，比如下面的代码就不正确。

```perl
=head1 Title
=head2 Subtitle
Some Text
=cut
```


## 文档显示

POD 只规定了标记格式，至于怎样显示，并不是POD 的事情。有很多工具可以使用，通常重要的东西字号大，颜色深。

Perl 自带的 `perldoc` 把 POD 显示为 man-page。在类 Linux 系统中，很方便，Windows 系统中，很鸡肋。 

[Pod::Html](https://metacpan.org/pod/Pod::Html) 模块提供了一个`pod2html`。可以把POD 转换成 HTML 格式，便于在浏览器中浏览。

当然，也有些工具可以把POD 转换为 pdf 格式，甚至是 mobi 和 epub。其实这些转换实质上是字符串操作，正是Perl的强项。

## 文档给谁看呢？


注释是给可能更改程序的人看的，比如以后的维护者，甚至是自己；程序的文档，面向的是使用者。

至于Perl 模块中的 POD，主要是写给可能用到该模块的Perl 程序员。



## 结论

Perl 中，由于POD 的存在，写文档轻松，输出的文档漂亮。




