---
title: "使用Perl的grep过滤值"
timestamp: 2013-05-11T11:37:32
tags:
  - grep
  - filter
  - any
  - List::MoreUtils
  - <>
  - glob
published: true
original: filtering-values-with-perl-grep
author: szabgab
translator: terrencehan
---


内部函数<b>grep</b>是一个<b>过滤器</b>。接收一个列表和一个条件作为参数，并返回使给定条件为真的元素构成的列表。

它是UNIX和Linux系统中grep和egrep命令的一般化形式，但是你没有必要为了理解Perl中的grep而了解它们。


`grep`函数有两个参数。一个代码块和一个列表。

对于列表中的每个元素，它的值会被赋到`$_`（[Perl的标量默认值](/the-default-variable-of-perl)）, 然后执行代码块。如果代码块的返回值是`false`，相应值被丢弃。如果代码块返回值是`true`, 相应值会作为返回值之一。


注意：代码块和第二个参数间没有逗号！

看几个grep的列子：

## 过滤掉小数字

```perl
my @numbers = qw(8 2 5 3 1 7);
my @big_numbers = grep { $_ > 4 } @numbers;
print "@big_numbers\n";      # (8, 5, 7)
```

grep返回大于4的值，过滤掉不大于4的值。


## 过滤掉新文件

```perl
my @files = glob "*.log";
my @old_files = grep { -M $_ > 365 } @files;
print join "\n", @old_files;
```

`glob "*.log"`会返回当前文件所有.log为扩展名的文件。

`-M $path_to_file` 返回文件最后一次修改至今的天数。

这个例子过滤掉365天内修改的文件，并得到至少存在了一年以上的文件。

## 数组中是否包含某个元素?

`grep`另一个有趣的应用是用来检查在数组中是否包含某个元素。例如，你有一个名单，想知道给定的名字是否也在其中。

```perl
use strict;
use warnings;

my @names = qw(Foo Bar Baz);
my $visitor = <STDIN>;
chomp $visitor;
if (grep { $visitor eq $_ } @names) {
   print "Visitor $visitor is in the guest list\n";
} else {
   print "Visitor $visitor is NOT in the guest list\n";
}
```

在这个例子中，grep函数位于[标量上下文](https://perlmaven.com/scalar-and-list-context-in-perl)。在标量上下文中，`grep`返回通过过滤的元素个数。我们检查的条件是`$visitor`是否与当前元素相等，grep会返回相等的次数。

如果返回值是0, 表达式则为false，如果是任何正数，表达式为true。

这种方法可以解决问题，但是因为它牵扯到上下文，可能对一些朋友不是很清晰。来看一下另外一个方案：[List::MoreUtils](https://metacpan.org/pod/List::MoreUtils)模块的`any`函数。

## 有匹配的元素么?

The `any` function has the same syntax as , accepting a block and a list of values,
but it only returns true or false. True, if the block gives true
for any of the values. False if none of them match.
It also short circuits so on large lists this can be a lot faster.

`any`函数的语法和`grep`一样，传入一个代码快和一个列表，但是仅返回true或false。如果任何值使代码块返回true, 则函数返回true；如果没有匹配值则返回false。在处理过程中存在短路操作，所以对于规模较大的列表会快一些。

```perl
use List::MoreUtils qw(any);
if (any { $visitor eq $_ } @names) {
   print "Visitor $visitor is in the guest list\n";
} else {
   print "Visitor $visitor is NOT in the guest list\n";
}
```


## UNIX和Linux的grep?

简单说明一下：

我之前提到过，内建的`grep`函数是UNIX grep命令的一般化实现。

<b>UNIX grep</b>基于正则表达式过滤一个文件的每行内容。

<b>Perl grep</b>可以基于任何条件过滤任何列表。

下面Perl代码是UNIX grep一个简单的实现版本：

```perl
my $regex = shift;
print grep { $_ =~ /$regex/ } <>;
```

第一行从命令行读入一个正则表达式，命令行其它参数应该是文件名。

钻石操作符`&lt;&gt`从所有文件(命令行参数)中提取每一行。grep根据正则式进行过滤。通过过滤的行会打印出来。

## Windows上的grep

Window没有grep程序，不过你可以自己安装一个或者使用上面的Perl脚本。
