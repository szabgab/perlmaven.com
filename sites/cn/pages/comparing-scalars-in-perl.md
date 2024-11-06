---
title: "Perl中标量的比较"
timestamp: 2013-05-17T16:12:23
tags:
  - eq
  - ne
  - lt
  - gt
  - le
  - ge
  - ==
  - "!="
  - "<"
  - ">"
  - "<="
  - ">="
published: true
original: comparing-scalars-in-perl
books:
  - beginner
author: szabgab
translator: terrencehan
---


在上节[Perl教程](/perl-tutorial)介绍了[标量](/scalar-variables)，并且看到了数字和字符串之间的转换。我们简单提了一下<b>if</b>条件语句，但是没有看到如何比较两个标量，这一节将会对此进行介绍。


给定两个标量 $x 和 $y，如何来比较它们呢？ 1，1.0 以及 1.00 是相等的么？那 "1.00" 有如何呢？ "foo" 和 "bar" 哪个更大呢？

## 两类比较操作符

Perl有两类比较操作符。如之前看到的二元操作符，加号（+），连接符（.）和重复符（x），这里的操作符定义了操作数的行为以及如何比较它们。

这两类操作符是：

```
Numeric    String         Meaning
==            eq           equal
!=            ne           not equal
<             lt           less than
>             gt           greater than
<=            le           less than or equal
>=            ge           greater than or equal
```

左侧的操作符会按照数字的形式比较值，而右侧的（中间一列）会根据ASCII码表或者当前的位置比较值。

来看几个例子：

```perl
use strict;
use warnings;
use 5.010;

if ( 12.0 == 12 ) {
  say "TRUE";
} else {
  say "FALSE";
}
```

在这个简单的例子中，Perl会打印 TRUE ，这是因为`==`操作符比较两个数字，并且不在乎数字是整型还是浮点型。

更有趣的是下面的比较

```
"12.0" == 12
```

结果也是TRUE，因为Perl的`==`操作符会把字符串转换成数字。

```
 2  < 3  为TRUE，因为<比较两个数字

 2  lt 3 也是TRUE，因为ASCII表中2在3的前面

12 > 3  显然也为TRUE

12 gt 3 会返回FALSE
```

有些人一开始可能会觉得奇怪，但是如果你想一下就能知道，Perl在比较字符串的时候是一个字符一个字符比较的。所以在比较"1"和"3"的时候，因为它俩不同，且在ASCII表中"1"在"3"前面，这就界定了12作为字符串的时候比字符串3小。

你需要确认比较的对象是你想要的！

```
"foo"  == "bar" 会返回TRUE
```

如果你使用`use warnings`开启警告，会获得两条警告信息。警告的原因是你在数值比较 == 的时候传入了两个字符串作为数字。在上一节我们提到过，Perl会查看字符串的左边并尝试把所有有意义的转换成数字。因为这两个字符串以字母开头，它们都会转换成0. 0 == 0 返回真。

另一方面：

```
"foo"  eq "bar"  FALSE
```

所以，你需要确认值是按照你想要的方式比较的！

同理：

```
"foo"  == "" 返回 TRUE
```

而

```
"foo"  eq "" 返回 FALSE
```


用下面的表格看结果会很方便：

```
 12.0   == 12    TRUE
"12.0"  == 12    TRUE
"12.0"  eq 12    FALSE
  2     <   3    TRUE
  2    lt   3    TRUE
 12     >   3    TRUE
 12    gt   3    FALSE ! (注意，开始时这个可能不明显)
"foo"  ==  ""    TRUE  ! (如果使用"warning"指令会发出警告)
"foo"  eq  ""    FALSE
"foo"  == "bar"  TRUE  ! (如果使用"warning"指令会发出警告)
"foo"  eq "bar"  FALSE
```

最后的例子中有一个陷阱，如果你获得一个用户输入，然后小心翼翼的删除换行符，最后检查给定的字符串是否为空。

```perl
use strict;
use warnings;
use 5.010;

print "input: ";
my $name = <STDIN>;
chomp $name;

if ( $name == "" ) {   # 错误！这里你需要使用eq而不是==!
  say "TRUE";
} else {
  say "FALSE";
}
```

如果执行这个脚本的时候输入"abc"则会返回TRUE，就好象Perl将"abc"看作空字符串处理。
