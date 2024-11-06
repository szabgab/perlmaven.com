---
title: "Smart Matching in Perl 5.10"
timestamp: 2013-04-21T11:45:01
tags:
  - ~~
  - smart match
  - v5.10
  - 5.010
published: true
original: smart-matching-in-perl-5.10
author: szabgab
translator: swuecho
---

Perl 5.10 于 Perl 20 周年发布（2007年 12月 18 日）。该版本增添了不少新特性。

在 [What's new in Perl 5.10? say, //, state](/what-is-new-in-perl-5.10--say-defined-or-state) 一文中，
我已经写了一些。接下来，我们学习 <b>Smart Matching</b>。


Perl的独特之处在于，所有的 Perl 操作符都作用于特定的情形，如果其操作子不符合此情形，Perl会自动转化。比如 1 + 1 结果为 2，多数语言都是这样，
但是 1 + "1"呢，很多语言中是错误的，但是由于 Perl 的操作符作用与特定情形， “1” 首先被转换成 1 然后再加。
再如，如果你想比较两个数是否相等，用 “==”；如果想比较两个字符串是否相等，用 “eq”。
然而，~~ 是个例外，~~ 从其操作子中推断其所处的情形，然后选择合适的比较方法。


~~ 与 ==，eq 处于同样的优先级。$a ~~ $b，多数情况下读做 $a 属于 $b 或 $a 在 $b 中比较好。
与其它的比较操作符类似，$a ~~ $b 的结果为 1 或者 “”，对应于 true 和 false。
前面已经提到，~~ 从其操作子中推断其所处的情形，然后选择合适的比较方法。

<b>Smart Matching</b> 操作符。因为太灵活，有时候会引起混乱（好像在哪听说过类似的话:)）。如果学习的成本大于使用带来的收益，
就不要管它，捡好的用就好。本文只介绍比较好用的3种情形。

## 1. Any ~~ Array 

~~ 的作用是，查看 Any 是否属于 Array。

```perl
my @b = qw(Foo Bar Baz);
"Moose" ~~ @b;  #  false

my @c = qw(Foo Bar Moose Baz);
"Moose" ~~ @c; #   true
```


“Moose”在 [qw(Foo Bar Moose Baz)] 中，所以结果是 1，不在 [qw(Foo Bar Baz)] 中 ，所以结果是 “”。


上个例子可以简写如下：

```perl
"Moose" ~~ [qw(Foo Bar Baz)]  ;     #  is false
"Moose" ~~ [qw(Foo Bar Moose Baz)] ;#  is true
```


请注意，这个例子与上一个例子的区别。~~ 可以是 Array 也可一是 Array 的引用, 如果是后者，Perl 自动取出被引用的值，然后比较。


当然，也可以看某个数值是否在数组中;

```perl
42 ~~ [23, 17, 70] ;         # false
42 ~~ [23, 17, 42, 70] ;     # true
```




##  2. Any ~~ Hash 

$a ~~ $b 的右边也可以是 Hash，~~ 的作用是，查看 $a 属于 Hash 的 Keys 的集合。

比如:

```perl
'a' ~~ {a => 19, b => 23}      #  true
19  ~~ {a => 19, b => 23}      #  false
```


'a' 与 {a => 19, b => 23} 的其中一个 key ‘a’ 相同，所以结果是 1。


##  3. Any ~~ CODE 

Any ~~ CODE 相当与 CODE->(Any)

```perl
3 ~~ sub { $_[0] % 2 == 0 };  # false
2 ~~ sub { $_[0] % 3 == 0 };  # false
```

如果把 Any ~~ CODE 与 Any ~~ Array 结合起来，将变得更有意思。

```perl
7 ~~ [sub { $_[0] % 2 == 0 }, sub { $_[0] % 3 == 0 }];  # false
4 ~~ [sub { $_[0] % 2 == 0 }, sub { $_[0] % 3 == 0 }];  # true
```

7 既不能被 2 也不能被3 整除，所以结果是 false；
4 能被 2 整除，所以结果为 true。不过这种情形应该很少用到。

<hr>

译者注：本文做了比较大的调整，只介绍我认为比较有用的部分。本文部分语句译自官方文档。更多信息参考Perl 官方文档。






