---
title: "不要使用旧方法打开文件"
timestamp: 2013-05-24T08:49:23
tags:
  - open
published: true
original: open-files-in-the-old-way
books:
  - beginner
author: szabgab
translator: terrencehan
---


在之前的[Perl教程](/perl-tutorial)中我们看到了如何打开文件。然而，如果你在网络上搜索，或者看公司的代码，你会看到稍微不同的语法。

那是什么？它们的问题在哪里？如何避免？


## 我该怎么办?

在说明什么不该做之前，请点击链接看一下你应该怎么做：

请阅读[如何用现代的方法打开读文件](/open-and-read-from-files)或者是[用Perl写文件](/writing-to-files-with-perl)。

现在回到以前不怎么好的方式。

## 不建议使用的旧方法

直到perl5.6发布（2000年），我们写这样的代码来打开写文件：

```perl
open OUT, ">$filename" or die ...;
```

这样打开读文件：

```perl
open IN, $filename or die ...;
```

"or die"的部分沿用至今，在这里没有完全写完。

如你看到的，`open`可以传入两个参数。第一个参数通常由大写字母构成，第二个则混合了打开方式及路径。

在第一个例子中的大于号表示写打开文件，但在第二个例子中却省略了打开模式。这是因为`open()`默认的是读打开。

（旧方法和新方法）有两个大的不同：

## Filehandle glob

首先，我们使用没有前导`$`的变量来作为文件句柄。（这是实际上是<b>裸字</b>，但是它不会触发[不允许在开启"strict subs"时使用裸字](/barewords-in-perl)的错误。）

这会跟以前一样正常工作，但仍有几个问题：

它对于所有脚本是全局的，所以如果有人使用相同的名字（本例的IN或OUT）会产生冲突。

这也会比普通的标量更难传递给函数。

## 两个参数的open

第二个不同点是例子中的`open`是传入两个参数。

如果打开读的变量`$filename`包含">/etc/passwd"会怎样呢？

实际上`open IN, $filename`会写打开文件。

这样，你就删除了Linux操作系统上的密码文件。（权限）

那就不好了。

## 需要关闭文件句柄

另外一个建议是<b>使用词法作用域的标量</b>作为文件句柄，它们会在离开作用域的时候自动关闭。

## 如何避免这些问题？

最好避免这些方式而采用“新”的方式（2000年后），[配合词法变量使用3-参量的open](/open-and-read-from-files)来获得文件句柄。

在[Perl::Critic](http://www.perlcritic.com/)中甚至还有一些规则，这个站点可以帮你分析并在代码中定位出以上形式。

## Good and Bad for reading

Bad:

```perl
open IN, $filename or die ...;
```

Good:

```perl
open my $in, '<', $filename or die ...;
```

## Good and Bad for writing

Bad:

```perl
open IN, ">$filename" or die ...;
```

Good:

```perl
open my $in, '>', $filename or die ...;
```


