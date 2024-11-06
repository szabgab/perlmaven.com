---
title: "标量出现在操作符的位置"
timestamp: 2013-05-19T18:31:34
tags:
  - syntax error
  - scalar found
  - operator expected
published: true
original: scalar-found-where-operator-expected
books:
  - beginner
author: szabgab
translator: terrencehan
---


这是我经常遇到的错误信息，看起来有些难理解。

人们知道<b>数字操作符</b>和<b>字符串操作符</b>，但是却不认为逗号`,`也是操作符。对于这些人，错误信息的术语挺有迷惑性的。

来看几个例子：


## 缺失逗号

代码如下：

```perl
use strict;
use warnings;

print 42 "\n";
my $name = "Foo";
```

错误信息如下：

```
String found where operator expected at ex.pl line 4, near "42 "\n""
      (Missing operator before  "\n"?)
syntax error at ex.pl line 4, near "42 "\n""
Execution of ex.pl aborted due to compilation errors.
```

错误信息清楚地定位到了问题，但是我知道的是，很多人会匆忙地返回编辑器修改错误，甚至都没有读完错误信息。他们改了一下代码，期待能够修复问题，但往往会得到另外的错误信息。

这个例子的错误是忘记了在数字42后面加逗号`,`。正确的写法是：`print 42, "\n";`。


## 字符串出现在操作符的位置

在这个代码中我们漏了连接符 `.`，得到如下错误信息：

```perl
use strict;
use warnings;

my $name = "Foo"  "Bar";
```

```
String found where operator expected at ex.pl line 4, near ""Foo"  "Bar""
      (Missing operator before   "Bar"?)
syntax error at ex.pl line 54, near ""Foo"  "Bar""
Execution of ex.pl aborted due to compilation errors.
```

想写的代码是：`my $name = "Foo" . "Bar";`。

## 数字出现在操作符的位置

```perl
use strict;
use warnings;

my $x = 23;
my $z =  $x 19;
```

产生错误信息：

```
Number found where operator expected at ex.pl line 5, near "$x 19"
  (Missing operator before 19?)
syntax error at ex.pl line 5, near "$x 19"
Execution of ex.pl aborted due to compilation errors.
```

这个代码可能是缺失了一个加号`+`，或乘号`*`，也可能是重复操作符`x`。

## 逗号缺失时的语法错误

缺失逗号总是被认为是缺失操作符。例如：

```perl
use strict;
use warnings;

my %h = (
  foo => 23
  bar => 19
);
```

这样会产生错误信息: <b>syntax error at ... line ..., near "bar"</b>，而没有更多的细节。

在数字23后面加一个逗号可以修复代码：

```perl
my %h = (
  foo => 23,
  bar => 19
);
```

我自己更倾向于在hash表的每个键值对后面加一个逗号（在本例的数字19后面也是如此）：

```perl
my %h = (
  foo => 23,
  bar => 19,
);
```

这种喜欢可以帮我在大多数情况下避免此类语法错误。


## 在..行，标量出现在操作符的位置

```perl
use strict;
use warnings;

my $x = 23;
my $y = 19;

my $z =  $x $y;
```

```
Scalar found where operator expected at ... line 7, near "$x $y"
   (Missing operator before $y?)
syntax error at ... line 7, near "$x $y"
Execution of ... aborted due to compilation errors.
```

同样，在 $x 和 $y 之间可以有一个数字或者字符串操作符。

## 数组出现在操作符的位置

```perl
use strict;
use warnings;

my @x = (23);
my $z =  3 @x;
```

## 你经常遇到的其它情况是怎样的？

你还遇到过其它有趣的此类语法错误的情况么？


