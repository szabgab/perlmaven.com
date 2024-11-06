---
title: "如何更快地排序？"
timestamp: 2013-05-02T23:24:50
tags:
  - map
  - sort
  - Schwartzian
published: true
original: how-to-sort-faster-in-perl
author: szabgab
translator: terrencehan
---



即便是一个很长的文件列表，如果按文件名的ASCII码顺序排序，也会很快处理完。然而，如果你需要根据文件大小排序的话会慢很多。


## 根据文件名排序


下面简化的示例代码创建了一个xml文件的列表，并根据文件名以字母顺序排序。 处理速度很快。

```perl

#!/usr/bin/perl
use strict;
use warnings;

my @files = glob "*.xml";

my @sorted_files = sort @files;
```

## 根据文件名长度排序

```perl
my @sorted_length = sort { length($a) <=> length($b) } @files;
```

对于3000个文件，这比根据ASCII名字排序速度要慢3倍，但是仍然很快。

## 根据文件大小排序

当尝试根据文件大小对3000个文件排序的时候，发现它竟然比以ACSII码排序的例子慢80倍!

```perl
my @sort_size = sort { -s $a <=> -s $b } @files;
```

这说来也并不奇怪。 第一个例子中，Perl仅仅比较了数值。 第二个例子中，Perl还要在比较之前计算字符串长度。
而在第三个例子中，每次比较之前都要到硬盘中获取两个文件的大小。

访问磁盘要远比访问内存慢的多。

问题是，<b>如何来提升这个速度?</b>。

访问磁盘的问题被排序的工作方式给放大了。

目前有很多排序算法([快速排序](http://en.wikipedia.org/wiki/Quicksort)，[冒泡排序](http://en.wikipedia.org/wiki/Bubblesort)，[归并排序](http://en.wikipedia.org/wiki/Mergesort), etc.)
根据输入的不同，有的快些，有的慢些。 Perl曾经使用快速排序，
之后换成了归并排序。 今天，如果你需要的话，可以通过[sort](http://perldoc.perl.org/sort.html)
指令选择排序方式。

无论你选择那一种，平均来看，至少需要N*log(N)比较。 这就意味着，对于N = 1000个文件，perl需要访问2 * 1000 * 3 = 6000次磁盘。
(两倍于比较次数。) 对每个文件，perl要获取6次大小! 这明显是很大的浪费。

我们不能避免访问磁盘来获取文件大小，我们也不能减少比较次数，但是，我们可以减少访问磁盘的次数。

## 预先获取文件大小

我们会预先获取所有文件大小，把它们存在内存，然后对内存中的数据排序。

```perl
my @unsorted_pairs = map  { [$_, -s $_] } @files;
my @sorted_pairs   = sort { $a->[1] <=> $b->[1] } @unsorted_pairs;
my @quickly_sorted_files = map  { $_->[0] } @sorted_pairs;
```

这可能比之前写的复杂一些，不过先忍一下，还有个更简单的方式。

总共分为3个步骤。首先遍历文件列表，对每个文件创建一个数组引用。数组引用包含两个元素：第一个是文件名，第二个是文件大小。这样，处理每个文件只访问一次磁盘。

第二步，对二维数组（每个文件是一个一维数组）排序。在比较小数组时，我们取元素[1]，比较它们的值。得到的结果是另一个二维数组。

第三步，丢掉文件大小元素，创建一个只含文件名的列表。完成目标结果。

## Schwartzian 转换

上面的代码使用了两个临时数组，但这并不是必须的。我们可以一个语句就能完成所有的工作。为了达到目的，需要按照“数据从右流向左”的原理反转句子顺序，不如果将每个句子放在单独一行，并且留出足够的空间，我们依然可以写出可读性高的代码。

```perl
my @quickly_sorted_files =
    map  { $_->[0] }
    sort { $a->[1] <=> $b->[1] }
    map  { [$_, -s $_] }
    @files;
```

这就是以[Randal L. Schwartz](http://en.wikipedia.org/wiki/Randal_L._Schwartz)命名的 [Schwartzian 转换](http://en.wikipedia.org/wiki/Schwartzian_transform)。

在代码里，通过map-sort-map的结构可以很容易就认出这种转换方法。

这种方法可以用来对任何东西排序，尤其是比较计算频繁的情况。

```perl
my @sorted =
    map  { $_->[0] }
    sort { $a->[1] <=> $b->[1] }
    map  { [$_, f($_)] }
    @unsorted;
```

使用这种算法对3000个xml文件排序“仅仅”比ASCII排序慢10倍，比刚开始的代码快8倍。


## 结论

实际上，在获得速度提升的同时，我们需要付出内存和代码复杂度增高的代价。对于小数组来说不值得，对大数组只有在真正对程序产生实际影响时才划算。

如果整个排序需要1秒钟，而脚本需要跑10分钟，就没有必要。相反，如果排序在整个运行时占用很大比重，你就应该使用Schwartzian转换方法。

为了找出你处于那种情况，可以在代码中使用[Devel::NYTProf to profile](https://metacpan.org/pod/Devel::NYTProf)。

(Thanks to [Smylers](http://twitter.com/Smylers2) for reviewing the article.)
