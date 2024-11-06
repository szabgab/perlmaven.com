---
title: "使用未初始化的值"
timestamp: 2013-05-01T21:45:56
tags:
  - undef
  - uninitialized value
  - $|
  - warnings
  - buffering
published: true
original: use-of-uninitialized-value
books:
  - beginner
author: szabgab
translator: herolee
---


在运行Perl代码时，这是你最常碰到的警告之一。

这个警告不会终止脚本的执行，而且它只有在打开警告时才会出现。建议打开警告。

最常见打开警告的办法是在你的脚本或者模块开头包含`use warnings;`声明。


老的办法是在#!一行加上`-w`标志。通常脚本的第一行类似这样：

`#!/usr/bin/perl -w`

这其中有些区别，但是`use warnings`在12年前已经存在了，没必要不使用它。换句话说：
总是使用`use warnings;`！

我们回过头来看看实际的警告是什么意思。
Let's go back to the actual warning I wanted to explain.

## 简要解释

```
Use of uninitialized value $x in say at perl_warning_1.pl line 6.
```

这表明变量`$x`没有赋值（它的值是一个特殊值`undef`）。
或是从未被赋值，或是某个地方被赋了值`undef`。

你需要查找变量最后一次赋值的地方，或者试图发现为啥那段代码从未执行。

## 一个简单的例子

下边的例子会产生这种警告。

```perl
use warnings;
use strict;
use 5.010;

my $x;
say $x;
```

Perl会很体贴地告诉我们哪个文件的哪一行导致了这个警告。

## 仅仅一个警告

前边说过，这只是一个警告。如果脚本在`say`语句之后，还有更多的语句，他们将被执行：

```perl
use warnings;
use strict;
use 5.010;

my $x;
say $x;
$x = 42;
say $x;
```

这会打印

```
Use of uninitialized value $x in say at perl_warning_1.pl line 6.

42
```

## 打乱输出顺序

不过仍要小心，如果你的代码里，在产生警告的一行之前有打印语句，正如这个例子中那样：

```perl
use warnings;
use strict;
use 5.010;

print 'OK';
my $x;
say $x;
$x = 42;
say $x;
```

结果会比较令人困惑。

```
Use of uninitialized value $x in say at perl_warning_1.pl line 7.
OK
42
```

这里，第一个`say`语句的结果，在警告<b>之后</b>出现，即便它在产生警告的代码<b>之前</b>被调用。

这个怪异现象源于`IO缓存`。默认情况下，Perl缓存标准输出，但是不缓存标准错误。

因此，单词'OK'在等待缓冲区刷新时，警告信息已经输出到屏幕了。

## 关闭缓冲

你可以关闭标准输出缓存以避免这种情况。

这可以在脚本开始处通过如下代码实现：
`$| = 1;`

```perl
use warnings;
use strict;
use 5.010;

$| = 1;

print 'OK';
my $x;
say $x;
$x = 42;
say $x;
```

```
OKUse of uninitialized value $x in say at perl_warning_1.pl line 7.
42
```

（警告跟<b>OK</b>出现在同一行，这是因为我们没有在OK之后打印一个新行符`\n`。）

## 不期望的作用域

```perl
use warnings;
use strict;
use 5.010;

my $x;
my $y = 1;

if ($y) {
  my $x = 42;
}
say $x;
```

这段代码也会产生警告`Use of uninitialized value $x in say at perl_warning_1.pl line 11.`。

我曾多次犯过这种错误。都因为没注意到我在`if`代码块之内使用了`my $x`。

这意味着我创建了另一个变量$x并赋值为42，却想在代码块作用域之后继续使用。
（$y = 1只是个占位符用于模拟一些真实的代码或者一些真实的情况。这只是使这个例子更逼真。）

当然我们有需要在if代码块之内声明变量的情形，不过并不经常。而当我错误地这么做时，找bug就相当痛苦。