---
title: "Perl Arrays"
timestamp: 2013-04-19T14:45:02
tags:
  - @
  - array
  - arrays
  - length
  - size
  - foreach
  - Data::Dumper
  - scalar
  - push
  - pop
  - shift
published: true
original: perl-arrays
books:
  - beginner
author: szabgab
translator: swuecho
---


本节[Perl 教程](/perl-tutorial)中，我们学习<b>Perl 数组</b>。

Perl 中 数组的标志符是`@`，即数组名总是以 `@` 开头。

如果你用了 `use strict`，第一次使用时，必须用关键词 `my` 声明。


需要注意的是，本文中所有的示例代码都假设已经包括以下代码。

```perl
use strict;
use warnings;
use 5.010;
```

声明一个数组：

```perl
my @names;
```


声明然后赋值：

```perl
my @names = ("Foo", "Bar", "Baz");
```


## 用Data::Dumper显示数组信息

Data::Dumper 是一个Perl 模块，通常用在调试的过过程中，用来查看Perl 变量的信息。



```perl
use Data::Dumper qw(Dumper);

my @names = ("Foo", "Bar", "Baz");
say Dumper \@names;
```

输出：

```
$VAR1 = [
        'Foo',
        'Bar',
        'Baz'
      ];
```

## 用foreach 循环输出数组内容

```perl
my @names = ("Foo", "Bar", "Baz");
foreach my $n (@names) {
  say $n;
}
```

输出：

```
Foo
Bar
Baz
```

## 读取数组元素的值

```perl
my @names = ("Foo", "Bar", "Baz");
say $names[0];
```

注意：是 $names[0] ，而不是 @names[0]，看到标志符的变化了么？

`@` 标志符用来标志数组，很容易想到，数组是个复数的概念。而标志符`$` 对应的是单数的概念。
你读取数组的某个元素，是个单数，所以标志符`$`才是正确的。如果你在学习这个教程，你应该学过英语。
对的，Perl 借鉴了不少自然语言（当然是英语）概念，这也是Perl的独特之处。


## 数组的索引

几乎所有的编程语言，数组都是从 0 开始索引，最大的索引值是`$#name_of_the_array`，即数组元素的个数减去 1 。


```perl
my @names = ("Foo", "Bar", "Baz");
say $#names;
```

输出是 2，因为数组中共有3个元素。

## 数组元素的个数

数组元素的个数也称作数组的大小，或者长度。Perl 中没有内置的函数能够告诉你数组元素的个数，因为Perl 并不需要这样一个特定的函数。
根据在数组索引中提供的信息，你应该想到，在数组最大索引值的基础上加一就好了，即 `$#names+1` 。

更常见的做法是用`scalar` 函数。

```perl
my @names = ("Foo", "Bar", "Baz");
say scalar @names;
```

结果是3。

`scalar` 其实是给 @names 提供一个上下文，告诉 Perl，想得到一个标量。Perl 返回 @names 中元素的个数。

如果已经有上下文，Perl 则不需要你显示的提示。比如

```perl
my @names = ("Foo", "Bar", "Baz");
say @names + 1;
```

结果是 4；


## 历遍数组的索引

有时候，仅仅历遍数组的元素本身还不能满足需求。我们需要同时历遍数组中的元素以及其索引，在这中情况下，
只要历遍索引就够了。因为，只要得到了数组中某个元素的索引，就能方便的得到该元素。反之，则是不成立的。


```perl
my @names = ("Foo", "Bar", "Baz");
foreach my $i (0 .. $#names) {
  say "$i - $names[$i]";
}
```

结果:

```
0 - Foo
1 - Bar
2 - Baz
```

## `push` 增加一个元素到数组的末尾



```perl
my @names = ("Foo", "Bar", "Baz");
push @names, 'Moo';

say Dumper \@names;
```

结果：

```
$VAR1 = [
        'Foo',
        'Bar',
        'Baz',
        'Moo'
      ];
```


## `pop` 取出数组的最后一个元素

```perl
my @names = ("Foo", "Bar", "Baz");
my $last_value = pop @names;
say "Last: $last_value";
say Dumper \@names;
```

结果：

```
Last: Baz
$VAR1 = [
        'Foo',
        'Bar',
      ];
```

## 取出数组的第一个元素

`shift` 取出数组的第一个元素，原来的数组剩余的所有元素索引值减一，即向左移动。

```perl
my @names = ("Foo", "Bar", "Baz");

my $first_value = shift @names;
say "First: $first_value";
say Dumper \@names;
```

结果：

```
First: Foo
$VAR1 = [
        'Bar',
        'Baz',
      ];
```

怎样增加一个元素到数组的开头呢？

`unshift`
