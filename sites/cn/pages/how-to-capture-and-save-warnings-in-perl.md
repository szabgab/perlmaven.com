---
title: "在Perl里如何捕获并保存警告"
timestamp: 2013-06-14T09:19:12
tags:
  - warnings
  - state
  - __WARN__
  - %SIG
  - local
published: true
original: how-to-capture-and-save-warnings-in-perl
books:
  - advanced
author: szabgab
translator: terrencehan
---


虽然建议在每个Perl脚本和模块中开启警告，可是你又不想用户看到Perl发出的警告。

一方面你想在代码前面使用<b>use warnings</b>作为你的安全网，另一方面，通常警告会出现在屏幕上。多数情况下，客户不知道如何处理这些警告。如果幸运的话这些警告仅仅让客户惊讶一下，当然，不幸的是他们尝试着去修复它们... （这里说的不是Perl程序员。）

第三方面，你或许想要保存这些警告供之后分析。


此外，在很多地方还有很多Perl脚本和应用程序没有使用`use warnings`也没有在#!行中使用`-w`。加上了`use warnings`就可能会产生大量的警告。

长远来看，当然是要消除这些警告，但是短期来说呢？

即便是长期计划，你也不能写出完全没有BUG的代码，你也不能确保应用将来永远不会打印出警告信息。

你能么？

<b>你可以在警告打印到屏幕之前捕获它们。</b>

## 信号

Perl有一个叫做`%SIG`的内建hash表，其中的键是操作系统信号的名字。对应的值是函数（大多数是函数引用），这些函数会在特定的信号触发时被调用。

除了系统提供的标准信号以外，Perl还添加了两个内部“信号”。其中一个是<h__WARN__`，它在每次代码调用`warn()`函数的时候触发。另外一个是`__DIE__`，它在每次调用`die()`时触发。

在本文中，我们会看到这些是怎样影响警告信息的。                                                                       

## 匿名函数

`sub { }`是匿名函数，也就是一个只有函数体而没有名字的函数。（在这个例子中函数体也是空的，但是我希望你能明白我的意思。）

## 捕获警告--不处理

如果添加如下代码：

```perl
  local $SIG{__WARN__} = sub {
     # 此处可以获得警告信息
  };
```

这实际上表示每次程序的某个地方产生了警告信息时，不做任何处理。基本上，这会隐藏所有的警告。

## 捕获警告--并转换成异常

You could also write:
你也可以写成：

```perl
  local $SIG{__WARN__} = sub {
    die;
  };
```

这样会在每次产生警告的时候调用die()，也就是把每个警告转换成异常。

如果你想在异常中包含警告信息，可以这么写：

```perl
  local $SIG{__WARN__} = sub {
    my $message = shift;
    die $message;
  };
```

实际的警告信息会作为唯一的参数传递给匿名函数。

## 捕获警告--并写入日志

你可能想在中间做些其他事情：

过滤嘈杂的警告信息，留待后来分析：

```perl
  local $SIG{__WARN__} = sub {
    my $message = shift;
    logger($message);
  };
```

这里我们假设logger()是你实现的写日志函数。

## 写日志

假设你的应用程序已经有日志机制。如果没有的话，最好加上。即便你不能添加，你也需要操作系统的内建日志机制。例如Linux的syslog，MS Windows的Event Logger，其它操作系统也有它们内部的日志机制。

在本文的例子里，我们使用一个自制logger()函数来代表这个想法。

## 捕获并写日志的完整例子

```perl
  #!/usr/bin/perl
  use strict;
  use warnings;

  local $SIG{__WARN__} = sub {
    my $message = shift;
    logger('warning', $message);
  };

  my $counter;
  count();
  print "$counter\n";
  sub count {
    $counter = $counter + 42;
  }


  sub logger {
    my ($level, $msg) = @_;
    if (open my $out, '>>', 'log.txt') {
        chomp $msg;
        print $out "$level - $msg\n";
    }
  }
```

上面的代码会在log.txt文件中添加下面一行：

```perl
  Use of uninitialized value in addition (+) at code_with_warnings.pl line 14.
```

变量`$counter`和函数`count()`仅是产生警告示例的一部分。


## 警告处理函数中的警告信息

__WARN__在其处理函数执行过程中是自动被禁用的。所以在警告处理函数执行过程中产生的（新）警告信息不会导致无限循环。

你可以在perlvar文档中了解到更多细节。

## Avoid multiple warnings

需要注意的是重复的警告信息可能会充斥日志文件。我可以使用一个简单的类似缓存的特性来减少重复警告信息的数量。

```perl
  #!/usr/bin/perl
  use strict;
  use warnings;


  my %WARNS;
  local $SIG{__WARN__} = sub {
      my $message = shift;
      return if $WARNS{$message}++;
      logger('warning', $message);
  };

  my $counter;
  count();
  print "$counter\n";
  $counter = undef;
  count();

  sub count {
    $counter = $counter + 42;
  }

  sub logger {
    my ($level, $msg) = @_;
    if (open my $out, '>>', 'log.txt') {
        chomp $msg;
        print $out "$level - $msg\n";
    }
  }
```

可以看到，我们把`$counter`变量赋值成`undef`，然后再次调用`count()`函数来产生同样的警告。

我们也把`__WARN__`的处理函数替换成一个稍微复杂的版本：

```perl
  my %WARNS;
  local $SIG{__WARN__} = sub {
      my $message = shift;
      return if $WARNS{$message}++;
      logger('warning', $message);
  };
```

在调用logger之前，会检查一下当前字符串是否已经在`%WARNS`hash表中。如果没有的话，会添加它并调用logger()。如果已经有了，就调用return，并不二次记录同样的事件。

你可能回忆起我们在[unique values in an array](/unique-values-in-an-array-in-perl)也使用了同样的点子。

## local是什么？

在上面所有的例子中，我使用`local`函数來局部化（警告处理）效果。严格来说，在这些例子中我们没有必要这么做，因为假设这些代码是主脚本的第一部分。这种情况下就无所谓了，毕竟是在全局作用域里面。

然而，最好是这么用。

`local`对于在模块中限制（对警告）的改变是很重要的。特别是要发布的模块。如果没有局部化，会影响整个应用程序。`limit`则会把影响限制在所在的闭合代码块里。

## 避免使用全局的%WARNS

如果你正在使用Perl 5.10或者更新的版本，你可以改写一下代码来替换掉全局变量%WARNS。要这么做的话，需在脚本的开头使用`use v5.10;`，然后在匿名函数内部使用`state`关键词来声明变量。

```perl
  #!/usr/bin/perl
  use strict;
  use warnings;

  use v5.10;

  local $SIG{__WARN__} = sub {
      state %WARNS;
      my $message = shift;
      return if $WARNS{$message}++;
      logger('warning', $message);
  };
```


更多细节，参阅[关键词state](/what-is-new-in-perl-5.10--say-defined-or-state)。

(感谢 Joel Berger 提醒的 `state`).


