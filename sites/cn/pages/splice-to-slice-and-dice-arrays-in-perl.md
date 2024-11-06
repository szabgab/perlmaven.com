---
title: "数组操作 Splice"
timestamp: 2013-04-21T09:05:56
tags:
  - splice
  - array
published: true
original: splice-to-slice-and-dice-arrays-in-perl
books:
  - advanced
author: szabgab
translator: swuecho
---


学习了[pop, push, shift, and unshift](/manipulating-perl-arrays)之后，
有人问我怎样从数组中删除一个元素。

这个问题并不简单，不过，根据你自己的需求，你可以决定是否花时间学习。


## 怎样从数组中删除一个元素

```perl
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
splice @dwarfs, 3, 2;

print "@dwarfs";    # Doc Grumpy Happy Dopey Bashful
```


仔细观测上例的结果，不难发现，数组中的第4个和第5个元素被删除了。 <b>splice</b>
的二个参数告诉它偏移值（offset） 是多少，第三个参数告诉它要删除几个。

## 怎样在数组中添加一个元素?

```perl
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
splice @dwarfs, 3, 0, 'SnowWhite';
print "@dwarfs";
# Doc Grumpy Happy SnowWhite Sleepy Sneezy Dopey Bashful
```

观察以上例子的结果，结合前面介绍的你就可以猜到<b>splice</b> 在类似情形如何使用了。


## 怎样在数组中增添多个元素？

其实，增添一个元素是增添多个元素的特殊情况。

```perl
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
splice @dwarfs, 3, 0, 'SnowWhite', 'Humbert';
print "@dwarfs";

# Doc Grumpy Happy SnowWhite Humbert Sleepy Sneezy Dopey Bashful
```

很容易明白吧。

## 怎样把一个数组中的元素添加到另一个数组中？

只要把<b>splice</b>的第四个参数换成你想要添加的数组就好了。

```perl
my @others = qw(SnowWhite Humbert);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
splice @dwarfs, 3, 0, @others;
print "@dwarfs";
```


## 替换掉数组中的某些元素？

添加和删除一起完成。

```perl
my @others = qw(SnowWhite Humbert);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
splice @dwarfs, 2, 4, @others;
print "@dwarfs\n";

# Doc Grumpy SnowWhite Humbert Bashful
```


## splice

几乎所有的数组操作都可用 <b>splice</b> 实现。
除了第一个参数，数组，为必须，其余的参数都不是必须的。

```perl
splice ARRAY, OFFSET, LENGTH, LIST
```

OFFSET 和 LENGTH 定义了 ARRAY 中将要删除的部分， LIST 表示在删除的位置上要添加的元素。
如果LIST 省略，表示只删除，不增加。


## 返回值

在 <b>LIST 情境</b> splice 返回移除的值.

```perl
my @others = qw(SnowWhite Humbert);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
my @who = splice @dwarfs, 3, 2, @others;
print "@who\n";

# Sleepy Sneezy
```

在 <b>SCALAR 情境</b>，返回最后一个移除的值，如果没有值被移除，则返回 undef。

```perl
my @others = qw(SnowWhite Humbert);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
my $who = splice @dwarfs, 3, 2, @others;
print "$who\n";

# Sneezy
```

## 参数为负值？

偏移值(OFFSET)和长度(LENGTH)值都可以为负数，表示从数组的末尾算起。

```perl
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
my @who = splice @dwarfs, 3, -1;
print "@who";

# Sleepy Sneezy Dopey
```

偏移为3，即从第四个算起，-1 表示直到整个数组的倒数第一个。

```perl
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
my @who = splice @dwarfs, -3, 1;
print "@who";

# Sneezy
```

从倒数第三个开始，向右移除的第一个元素。

## 总结

希望你弄清楚了怎样使用 `splice`。
