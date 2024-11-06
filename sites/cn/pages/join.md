---
title: "join"
timestamp: 2013-04-21T16:52:19
tags:
  - join
published: true
original: join
books:
  - beginner
author: szabgab
translator: terrencehan
---


`join`是`split`的反函数。


这个函数可以将一个列表或数组的好几个元素合并成一个字符串。

```perl
use strict;
use warnings;
use v5.10;

my @names = ('Foo', 'Bar', 'Moo');
my $str = join ':', @names;
say $str;                       # Foo:Bar:Moo

my $data = join "-", $str, "names";
say $data;                      # Foo:Bar:Moo-names


$str = join '', @names, 'Baz';
say $str;                       # FooBarMooBaz
```

<b>join</b>函数的第一个参数是“连接符”，它用来连接其他的参数。

join的其他参数将会“平坦化”成一个列表，并且把这些元素通过给定的“连接符”粘合起来。

“连接符”可以是包括空串在内的任何字符串。
