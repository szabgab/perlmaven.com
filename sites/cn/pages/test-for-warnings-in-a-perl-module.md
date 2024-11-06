---
title: "测试Perl模块中的警告信息"
timestamp: 2013-05-25T08:00:12
tags:
  - warnings
  - __WARN__
  - Test::Warn
published: true
original: test-for-warnings-in-a-perl-module
author: szabgab
translator: terrencehan
---


Perl模块在某些情况下（作为API的一部分）需要发出警告信息。

我们得能确保这些警告信息在其他人在修复bug或者添加新特性的时候不会消失。

为了满足上面的需求，写一个测试用例来检查你是否能够在合适的时间得到警告是应该是最简单的处理办法。


例如在你的模块中有一个函数用来分析日志文件。如果（日志）其中一行被破坏了怎么办？你的函数会抛出异常么？还是忽视掉这错误的一行然后继续？亦或给出警告然后继续？

或许在代码中存在一个函数，当每次调用的时候会发出警告信息，这至少在该函数被删除之前是能满足需求的，但是这种做法不被提倡。

你想要确保警告一直存在，它不会因为错误或者某些人不知道警告也是API的一部分而删除或者隐藏掉。

那么，如何测试代码中警告出现在正确的时间呢？

## 警告的信号量__WARN__

在Perl中, 每次调用<b>warn</b>都会发出一个内部信号。你可以使用<b>$SIG{__WARN__}</b>让测试代码[捕获并保存警告信息](/how-to-capture-and-save-warnings-in-perl)，之后检查一下它是不是你想要的。

例如：

```perl
{
  my @warnings;
  local $SIG{__WARN__} = sub {
     push @warnings, @_;
  };
  process_log();
  is scalar(@warn), 1, 'exactly one warning';
  like $warn[0], qr{Invalid row}, 'warning of invalid row';
}
```

如果我们想要测试多个用例，该怎么办？一次次复制代码？自己写一个函数来做这些事情？

## Test::Warn

幸运的是 Janek Schleicher 已经写了[Test::Warn](http://metacpan.org/module/Test::Warn)模块来做这样的工作，这个模块现在由[Alexandr Ciornii](http://chorny.net/)在维护。

你可以使用该模块提供的函数（很方便），而不必重复发明轮子。

使用这个模块，上面的代码可以简化成：

```perl
warning_like { process_log() } qr{Invalid row}, 'warning of invalid row';
```

注意，函数是包裹在一个代码块中，在代码块和期望的正则表达式中间没有逗号。


