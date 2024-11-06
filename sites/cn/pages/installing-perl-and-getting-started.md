---
title: "安装 Perl"
timestamp: 2013-03-30T18:45:56
tags:
  - strict
  - warnings
  - say
  - print
  - chomp
  - scalar
  - $
published: true
original: installing-perl-and-getting-started
books:
  - beginner
author: szabgab
translator: swuecho
---


这是整个 [Perl 教程](/perl-tutorial) 的开始。

通过学习此教程，你将学会怎样在微软 Windows，Linux 和 Mac 操作系统上安装并使用Perl。以及，怎样搭建开发环境，简而言之，使用什么IDE或者编辑器写Perl程序。 然后，学习“Hello, World”这一经典例子。


## Windows

Windows 操作系统下，我们选择 [DWIM Perl](http://dwimperl.com/). 它包括Perl自己， Perl IDE--[Padre](http://padre.perlide.org/)，以及一些经典的Perl 模块。

去 [DWIM Perl](http://dwimperl.com/) 的网站，下载 <i>.exe</i> 文件，双击运行，即可安装Perl。请注意装DWIM perl前确保你计算机上没有其它版本的Perl。不同版本的Perl可以并存，但是可能需要你做额外的配置。

## Linux

多数Linux 发行版，已经预装来Perl。Padre也有Linux版，你可以通过软件管理中心安装。当然，你也可以用其它的文本编辑器，Vim ，Emacs 或者 Gedit。

## Apple

Macs 也预装了Perl，如果没有，很容易自行安装。

## 编辑器和IDE

对于新手，推荐使用Padre,但不是必须。如果你使用Windows操作系统，即使你不用Padre，我也强烈建议你安装 DWIM Perl。主要是它有很多你很可能会用到的模块。

## 视频

如果你仍不清楚怎么安装，你可以跟着我录制的视频学习 <a href="http://www.youtube.com/watch?v=c3qzmJsR2H0">Hello world with
Perl</a>。

## 第一个Perl程序

第一个Perl程序的最终版本：

```perl
use 5.010;
use strict;
use warnings;

say "Hello World";
```

## Hello world

安装Perl后，点击 "开始 -> 所有程序 -> DWIM Perl -> Padre"，Padre 将会为你打开一个空白文件。

输入

```perl
print "Hello World\n";
```

不要忘了行末的“；”，perl 语句以“；”结尾。在很多语言中，“；”可以省去，但是Perl 不是。“\n” 的意思是开始新一行。你可以去掉“\n”,看看输出有什么区别。字符串一般放在双引号之间。 函数 print 输出其后的内容。注意，所有的输入都要在英文状态下输入。输入中文当然是可以的，但是需要对Perl有更多的了解。

保存此文件为 hello.pl ，然后选择 “运行 -> 运行脚本” 会有一个新的窗口出现，显示运行结果。

这就是你的第一个Perl程序。

## 非 Padre 用户

保存程序为 hello.pl, 在终端中，切换到保存目录，
输入

<b>perl hello.pl</b>

即可运行 hello.pl。

## say 与 print

我们改进下第一个Perl程序。

首先，声明我们用哪个版本的Perl。

```perl
use 5.010;
print "Hello World\n";
```

选择 “运行 -> 运行脚本”或者用快捷键 F5. Padre会自动保存此程序，然后运行。

通常，建议你声明你所需要的最低的Perl版本。

在我们的例子中，Perl 5.010 包括了一些比较好的特性，比如我们要用的到的 say。
say 与print 的区别是，say自动添加 “\n"。

你可以把代码改为这样：

```perl
use 5.010;
say "Hello World";
```
请观察一下，其与上一程序的区别。

你现在用的版本可能是 5.12.3 或者 5.14。 多数linux发行版，预装5.10或者更新版本的Perl。如果你的版本低于5.10，say 是不能用的，只能用 print。

## 严格模式

另外，强烈建议用 pragmata 来改变Perl的默认设置，在这里我们用了 strict 和 warnings。有人会问，为什么不让Perl默认启用呢？这是历史原因，Perl出现与1987年，如果默认启用，在这些pragmata产生之前的很多程序将无法运行。Perl是非常重视向后兼容的，这一点比其他的语言如Python，力度要大很多。

```perl
use 5.010;
use strict;
use warnings;

say "Hello World";
```

我们用关键词 use 来启动相应的 pragma。

<b>strict</b> 和 warnings 有助于找出代码中常见的错误，有时候，甚至能够帮你避免犯某些错误。如果你想得到更详细的debug 信息，可以添加 use diagnostics 。

## 获得用户输入

我们继续改进我们的程序。使之能够获得用户输入。

```perl
use 5.010;
use strict;
use warnings;

say "What is your name? ";
my $name = <STDIN>;
say "Hello $name, how are you?";
```

$name 叫做标量，所有标量以 $ 开头。注意标量和变量并非相同。标量是变量的一种。在Perl 中，变量用 my 来声明。 <STDIN> 获取输入的内容。

运行上面的例子，程序会问你你的名字，输入并按 ENTER 键。ENTER 告诉Perl你输入完毕。

程序输出并非预想的那样。逗号并没有直接出现在名字之后，而是出现在新一行的开头。为什么呢？因为你输入名字后，按来ENTER 键，Perl 把 ENTER 也当作你输入的一部分了。你想一想，Word 中 你按 ENTER键的作用是不是换行？

改进

```perl
use 5.010;
use strict;
use warnings;

say "What is your name? ";
my $name = <STDIN>;
chomp $name;
say "Hello $name, how are you?";
```

或许你已经注意到了，chomp。它的作用是去除字符串末尾的换行符 “\n”。

## 总结

建议在每一个perl程序的开始加入

```perl
use 5.010;
use strict;
use warnings;
use diagnostics;
```

## 练习

<h3>1.</h3>

```perl
use strict;
use warnings;
use 5.010;

say "Hello ";
say "World";
```

Hello World 没有输出到同一行，怎样改进能使输出在同一行？

<h3>2.</h3>

写一个程序，请求用户输入两个数字，输出两个数字之和。