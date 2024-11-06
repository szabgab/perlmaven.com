---
title: "猜数字 "
timestamp: 2013-04-02T10:45:27
tags:
  - rand
  - random
  - int
  - integer
published: true
original: number-guessing-game
books:
  - beginner
author: szabgab
translator: swuecho
---


在 [Perl 教程](/perl-tutorial)的这一节，我们学习怎样写一个简单而有趣的游戏。 



作为准备，我们需要了解在Perl中 <b>怎样获取随机数</b> 以及 <b>怎样得到一个小数的整数部分</b>。


## 小数的整数部分

Perl 中用 `int()` 函数，获得小数的整数部分。

```perl
use strict;
use warnings;
use 5.010;

my $x = int 3.14;
say $x;          # will print 3

my $z = int 3;
say $z;          # will also print 3.

                 # Even this will print 3.
my $w = int 3.99999;
say $w;

say int -3.14;   # will print -3
```

## 随机数


`rand($n)`  返回一个在区间 [0,$n)上的随机数。

如果没有参数，`rand()` 函数返回一个在区间 [0,1)上的随机数。

综合利用 `rand` 和 `int`，就可以得到随机的整数。

```perl
use strict;
use warnings;
use 5.010;

my $z = int rand 6;
say $z;
```

$z 是位于区间[0,6)的整数，即 0,1,2,3,4,5 中的一个。

所以 $z + 1 将是 1,2,3,4,5,6 中的一个。

## 练习：猜数字游戏

写一个小程序，让计算机“想”一个位于区间 [1,200] 的整数，让人来猜。 

等人给出所一个数字后，让电脑告诉人猜对了，小了，还是大了。

如果你想让人多猜几次，可以参考 [while 循环](/while-loop)。





