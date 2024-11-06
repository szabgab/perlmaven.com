---
title: "Perl默认变量$_"
timestamp: 2013-05-17T08:41:51
tags:
  - Perl
  - $_
  - scalar
  - default
  - variable
  - topic
published: true
original: the-default-variable-of-perl
author: szabgab
translator: herolee
---


Perl里有个奇怪的标量变量叫做`$_`，它是`默认变量`，换句话说是主题。

Perl里好多函数或者操作符默认使用这个变量，以防没有明确提供参数。
总的来说，我认为你<b>不</b>应该在实际代码里看到`$_`。
我认为`$_`的意思在于你不需要明确写出来。

当然，除非你写了。


拥有一个默认变量是个很强大的想法，但是不正确地使用它会降低你的代码的可读性。
看下这个脚本：

```perl
use strict;
use warnings;
use v5.10;

while (<STDIN>) {
   chomp;
   if (/MATCH/) {
      say;
   }
}
```

这跟下边这个几乎一样：

```perl
use strict;
use warnings;
use v5.10;

while ($_ = <STDIN>) {
   chomp $_;
   if ($_ =~ /MATCH/) {
      say $_;
   }
}
```

我从不写第二种，第一种也只是写在很小的脚本里或者代码里紧致的部分。甚至都不写。

如你所见，在`while`循环里，当你从文件句柄甚至是从标准输入读入时，如果不显式赋值给一个变量，读取的这一行会被赋值给`$_`。

如果没有提供参数，`chomp()`默认操作于该变量。

正则表达式匹配可以不显式提供字符串，甚至不写`=~`操作符。如果这么写时，它将会对`$_`的内容进行操作。

最后`say()`类似于`print()`会打印`$_`的内容，如果不提供其他参数的话。

## split

`split`的第二个参数是要被分割的字符串。如果没有提供第二个参数，split将分割`$_`的内容。

```perl
my @fields = split /:/;
```

## foreach

如果我们不给`foreach`提供迭代变量的名称，它会使用`$_`。

```perl
use strict;
use warnings;
use v5.10;

my @names = qw(Foo Bar Baz);
foreach (@names) {   # puts values in $_
    say;
}
```

## 条件赋值

有些情况下，我们可能由于隐含使用了`$_`导致错误。

一些高手可能有意写这种代码，但是新手或者初学者这么写的话，这就是bug了。

```perl
if ($line = /regex/) {
}
```

你可以发现，我们使用了普通的赋值操作符：`=`而非正则表达式操作符：`=~`。
这实际上跟下边这个一样

```perl
if ($line = $_ =~ /regex/) {
}
```

它获取`$_`的内容，并对之进行模式匹配，接着把结果赋值给`$line`。然后检查$line的内容是真或假。

## 显式$_

我前边说过，建议<b>不要</b>显式使用`$_`。
有时我看到人们这么写代码：

```perl
while (<$fh>) {
  chomp;
  my $prefix = substr $_, 0, 7;
}
```

我认为，如果你使用perl的某个声明需要强制显式地写出`$_`，比如这个例子里的`substr`，你应该总是使用一个更有意义的名字。
即便它意味着更多键盘敲击：

```perl
while (my $line = <$fh>) {
  chomp $line;
  my $prefix = substr $line, 0, 7;
}
```

我经常看到另一种不好的例子：

```perl
while (<$fh>) {
   my $line = $_;
   ...
}
```

这很可能出现在人们不了解`while`语句，文件句柄读操作以及`$_`之间的交互时。

这可以以更简单的方式直接赋值给`$line`变量。

```perl
while (my $line = <$fh>) {
   ...
}
```


## 例外

有些情况下，你不可避免地需要显式使用`$_`。
此类有[grep](/filtering-values-with-perl-grep)和[map](/transforming-a-perl-array-using-map)函数以及其他类似[any](/filtering-values-with-perl-grep)的函数。
