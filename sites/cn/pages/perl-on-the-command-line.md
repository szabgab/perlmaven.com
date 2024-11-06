---
title: "Perl命令行"
timestamp: 2013-05-18T20:45:56
tags:
  - -v
  - -e
  - -p
  - -i
published: true
original: perl-on-the-command-line
books:
  - beginner
author: szabgab
translator: herolee
---


虽然[Perl教程](/perl-tutorial)大部分都是关于保存在文件里的脚本，但我们也会看一些单行脚本的例子。

即便你使用[Padre](http://padre.perlide.org/)或者其它集成开发环境可以从编辑器里运行你的脚本，
了解命令行（或者shell）并可以在命令行使用perl仍然很重要。


如果你使用Linux，打开一个终端窗口。你可以看到一个命令提示符，很可能以$符号结束。
如果你使用Windows，打开一个命令窗口：点击
开始 -> 运行 -> 键入"cmd" -> 回车

你会看到CMD黑色的窗口，并很可能带有像这样的提示符：

```
c:\>
```

## Perl版本

键入`perl -v`。这会打印类似这种东西：

```
C:\> perl -v

This is perl 5, version 12, subversion 3 (v5.12.3)
  built for MSWin32-x86-multi-thread

Copyright 1987-2010, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

据此，我可以看出我在这个Windows机器上安装了5.12.3版本的Perl。

## 打印数字

现在键入`perl -e "print 42"`.
这会在屏幕上打印数字`42`。在Windows上，提示符会出现在下一行

```
c:>perl -e "print 42"
42
c:>
```

在Linux上，你会看到类似这样的东西：

```
gabor@pm:~$ perl -e "print 42"
42gabor@pm:~$
```

结果显示在行首，然后立即跟了一个提示符。
这个差异源于两种命令行解释器不同的行为。

这个例子中，我们使用了`-e`标志告诉perl，“不是解析文件。命令行之后的东西是实际的Perl代码。”

上边的例子当然没什么意思。我来演示一些略微复杂的例子，不做解释：

## 替换Java为Perl

命令：`perl -i.bak -p -e "s/\bJava\b/Perl/" resume.txt`
将替换你简历里所有的单词<b>Java</b>为单词<b>Perl</b>，同时保留文件的一个备份。

在Linux上你甚至可以写`perl -i.bak -p -e "s/\bJava\b/Perl/" *.txt`
来把你<b>所有</b>文本文件里的Java替换为Perl。

后续章节我们会谈论更多的单行脚本，你会学到如何使用它们。
可以说，单行脚本的知识是你手中非常强大的武器。

此外，要是你对一些很好的单行脚本很感兴趣，我推荐你读Peteris Krumins的大作[Perl One-Liners explained](http://www.catonmat.net/blog/perl-book/)。

## 下一步

下一部分是关于[Perl核心文档和CPAN模块文档](https://perlmaven.com/core-perl-documentation-cpan-module-documentation)。
