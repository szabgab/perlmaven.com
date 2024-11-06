---
title: "使用map转换数组"
timestamp: 2013-05-11T11:38:56
tags:
  - map
  - transform
  - list
  - array
published: true
original: transforming-a-perl-array-using-map
books:
  - advanced
author: szabgab
translator: terrencehan
---


`map`函数提供了一种将一系列值转换成另一系列值的方法。通常是一对一的转换，但是最后的结果也可以比原来的列表长或短一些。


我们在[grep of Perl](/filtering-values-with-perl-grep)中已经看过类似UNIX命令grep的函数。它从原始列表中选取元素，然后原封不动的返回。

`map`函数则用来修改原列表元素的值。

语法方面很类似。你需要传入一个代码快和一个列表：数组或者其他能返回列表的表达式。原列表的每个值都会放到`$_`（[Perl默认值](/the-default-variable-of-perl)）中，然后执行代码快。执行的结果会传递给等号左边。

## 使用map的简单转换

```perl
my @numbers = (1..5);
print "@numbers\n";       # 1 2 3 4 5
my @doubles = map {$_ * 2} @numbers;
print "@doubles\n";       # 2 4 6 8 10
```

## 建立快速查找表

有时需要在代码执行时判断给定的值是否在列表里。我们可以每次调用[grep](/filtering-values-with-perl-grep)来检查值是否在列表中。也可以使用[List::MoreUtils](http://metacpan.org/modules/List::MoreUtils)模块的[any](/filtering-values-with-perl-grep)函数，但是如果使用hash来查找会有更好的可读性和更快的速度。

我们需要创建一个hash表，把数组的所有元素作为key，1作为值。然后，用一个简单的hash查找代替`grep`。

```perl
use Data::Dumper qw(Dumper);

my @names = qw(Foo Bar Baz);
my %is_invited = map {$_ => 1} @names;

my $visitor = <STDIN>;
chomp $visitor;

if ($is_invited{$visitor}) {
   print "The visitor $visitor was invited\n";
}

print Dumper \%is_invited;
```

下面是`Dumper`的输出:

```perl
$VAR1 = {
          'Bar' => 1,
          'Baz' => 1,
          'Foo' => 1
        };
```

上面的代码，我们并不关心hash项的值，但是应该是Perl中的真值。

这种方案可以有效的避免对大集合的反复查找，小集合则可以使用`any`或者`grep`。

如你看到的，本例子中对于每个原数组的元素`map`会返回两个值：原始值和1。

```perl
my @names = qw(Foo Bar Baz);
my @invited = map {$_ => 1} @names;
print "@invited\n"
```

输出:

```
Foo 1 Bar 1 Baz 1
```


## 宽箭头

`=>`称为<b>胖箭头</b>或<b>胖逗号</b>。基本上，它的效果和普通的逗号`,`相同（但是逗号没有关联性）。（在[Perl hashes](/perl-hashes)中有说明）


## map中复杂表达式

你可以向map传入更复杂的表达式：

```perl
my @names = qw(Foo Bar Baz);
my @invited = map { $_ =~ /^F/ ? ($_ => 1) : () } @names;
print "@invited\n"
```

会输出：

```
Foo 1
```

在代码块中有一个三元操作符，它返回一个键值对或者一个空列表。显然，我们只想获取名字以F开头的人。

```perl
$_ =~ /^F/ ? ($_ => 1) : ()
```

## perldoc

更多的例子请参阅[perldoc -f map](http://perldoc.perl.org/functions/map.html).
