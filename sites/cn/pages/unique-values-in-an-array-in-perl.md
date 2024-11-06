---
title: "Perl数组中的唯一值"
timestamp: 2013-05-27T11:09:03
tags:
  - unique
  - uniq
  - distinct
  - filter
  - grep
  - array
  - List::MoreUtils
  - duplicate
published: true
original: unique-values-in-an-array-in-perl
books:
  - beginner
author: szabgab
translator: terrencehan
---


在本节[Perl教程](/perl-tutorial)中我们会看到如何使<b>数组仅包含不同的值</b>。

Perl 5没有过滤数组重复值的内建函数，但还是有很多解决方案。


## List::MoreUtils

对于你的问题，可能最简单的方式是使用[List::MoreUtils](https://metacpan.org/pod/List::MoreUtils)模块的`uniq`函数。

```perl
use List::MoreUtils qw(uniq);

my @words = qw(foo bar baz foo zorg baz);
my @unique_words = uniq @words;
```

完整示例：

```perl
use strict;
use warnings;
use 5.010;

use List::MoreUtils qw(uniq);
use Data::Dumper qw(Dumper);

my @words = qw(foo bar baz foo zorg baz);

my @unique_words = uniq @words;

say Dumper \@unique_words;
```

结果：

```
$VAR1 = [
        'foo',
        'bar',
        'baz',
        'zorg'
      ];
```

另外，该模块还提供了`uniq`的别名函数——`distinct`。

你得利用CPAN先安装这个模块后才能使用。

## 自制 uniq

如果不能安装上面的模块，或者你认为加载模块的开销太大，那么可以使用一个简单表达式也能达到同样的效果：

```perl
my @unique = do { my %seen; grep { !$seen{$_}++ } @data };
```

这对不熟悉的人会很奇怪，所以建议自定义`uniq`函数，然后在代码的其他部分使用。

```perl
use strict;
use warnings;
use 5.010;

use Data::Dumper qw(Dumper);

my @words = qw(foo bar baz foo zorg baz);

my @unique = uniq( @words );

say Dumper \@unique_words;

sub uniq {
  my %seen;
  return grep { !$seen{$_}++ } @_;
}
```

## 解释自制的uniq

举例之后当然不能置之不理，下面就来解释一下。先从早点的版本开始：

```perl
my @unique;
my %seen;

foreach my $value (@words) {
  if (! $seen{$value}) {
    push @unique, $value;
    $seen{$value} = 1;
  }
}
```

这里用普通的`foreach`循环一个个处理原数组中的值，处理过程中使用了辅助哈希表`%seen`，因为哈希表的键是唯一的。

开始的时候哈希表是空的，所以当遇到第一个"foo"的时候`$seen{"foo"}`并不存在，它的值是`undef`，也就是Perl中的false，表示之前没有见过这个值，然后把这个值添加到`@uniq`数组的最后。

这里把`$seen{"foo"}`设为1，其实任何为true的值都可以。

下一次遇到相同的字符串时，它已经作为`%seen`哈希表的键且对应的值是true，所以`if`条件判断会失败，也就不会`push`重复的值到数组。


## 简化自制的 unique 函数

首先把赋值语句`$seen{$value} = 1;`替换成自增操作符`$seen{$value}++`。这不会改变之前的方案——任何正数都被看作TRUE，但是会把设置"seen标志"的语句放在`if`条件判断中。区别开使用后缀自增（而不是前缀自增）是非常重要的，因为它会在布尔表达式计算完之后再自增。当我们第一次遇到某个值时（if的布尔）表达式为TRUE，之后再遇到同一个值时为FALSE。

```perl
my @unique;
my %seen;

foreach my $value (@data) {
  if (! $seen{$value}++ ) {
    push @unique, $value;
  }
}
```

这已经缩短了代码，但是我们还有更好的方案。

## 使用grep过滤重复值

Perl的`grep`函数是Unix的grep命令的一般化形式。

它基本上是一个[过滤器](/filtering-values-with-perl-grep)。你可以在右边传入一个数组，在代码块中传入一个表达式。`grep`函数会一个一个的提取数组中的值到`$_`（[Perl的默认标量](/the-default-variable-of-perl)）中，然后执行代码块。如果代码块求值为TRUE，对应的值会通过过滤。如果代码块求值为FALSE，当前值会被过滤掉。

于是我们得到这样的表达式：

```perl
my %seen;
my @unique = grep { !$seen{$_}++ } @words;
```

## 包裹在'do'或'sub'中

最后要做的是把上面两个语句包裹在`do`代码块

```perl
my @unique = do { my %seen; grep { !$seen{$_}++ } @words };
```

或者放在具名函数中：

```perl
sub uniq {
  my %seen;
  return grep { !$seen{$_}++ } @_;
}
```

## 另一个自制uniq

如果对元素的顺序没有要求的话，可以使用Prakash Kailasa建议的更短的uniq实现版本（需要perl 5.14或更高）:

内联代码:

```perl
my @unique = keys { map { $_ => 1 } @data };
```

或者在函数里：

```perl
my @unique = uniq(@data);
sub uniq { keys { map { $_ => 1 } @_ } };
```

分开讲解一下：

`map`的语法和`grep`相似:一个代码块以及一个数组。它会遍历数组的所有元素，执行代码块并把结果传递给左边。

在我们的例子里，数组中的每个元素处理之后都会和数字1一起被传递。不要忘记`=&gt;`（也称胖逗号）就是个逗号。假设@data是('a', 'b', 'a')，那表达式会返回('a', 1, 'b', 1, 'a', 1)。

```perl
map { $_ => 1 } @data
```

如果把这个表达式赋值给一个哈希表，那么原来的数据会作为键，数字1会作为值。尝试一下：

```perl
use strict;
use warnings;

use Data::Dumper;

my @data = qw(a b a);
my %h = map { $_ => 1 } @data;
print Dumper \%h;
```

输出：
```
$VAR1 = {
          'a' => 1,
          'b' => 1
        };
```

如果把它包裹在花括号里而不是赋值的话，我们会得到一个匿名哈希表的引用。

```perl
{ map { $_ => 1 } @data }
```

Let's see it in action:
看一下实际例子：

```perl
use strict;
use warnings;

use Data::Dumper;
my @data = qw(a b a);
my $hr = { map { $_ => 1 } @data };
print Dumper $hr;
```

除了哈希表的dump顺序可能改变以外，这和之前的输出结果一致。

最后，从perl 5.14开始我们可以对哈希表引用调用`keys`函数，所以可以这样写：

```perl
my @unique = keys { map { $_ => 1 } @data };
```

这样可以从`@data`中提取唯一值。


## 练习

给定下面文件，请唯一打印出其中的值：

input.txt:

```
foo Bar bar first second
Foo foo another foo
```

预期输出：

```
foo Bar bar first second Foo another
```

## 练习 2

过滤掉重复值（不管大小写）。

预期输出：

```
foo Bar first second another
```


