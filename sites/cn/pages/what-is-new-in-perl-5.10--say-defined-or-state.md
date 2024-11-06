---
title: "Perl 5.10有何新特点？ say, //, state"
timestamp: 2013-05-04T15:45:56
tags:
  - v5.10
  - 5.010
  - say
  - //
  - defined or
  - state
published: true
original: what-is-new-in-perl-5.10--say-defined-or-state
author: szabgab
translator: herolee
---


这早不是新闻了，Perl 5.10已经在2007年12月18日发布了，这是Perl的20岁生日。
许多人写文章讨论它，网上也有很多报告。比如参考[PerlMonks](http://perlmonks.org/?node_id=654042)的讨论。
那里有一些很好的链接。

我写这个，是因为很多公司最近才采用它。
他们想看看Perl 5.10以及以后的版本可以如何方便他们的生活。

（本文最初于2007年12月24日发布在szabgab.com上）


新特性有很多，我们先看一些简单的：

## say

有个新函数叫做`say`。它跟<b>print</b>一样，但是会在每次调用时自动添加新行符<b>\n</b>。
这听起来不是什么大问题，而且它的确不算很显著。但尽管如此，它节省了很多的打字，尤其是调试时。
有很多次，我们打出

```perl
print "$var\n";
```

现在我们可以这么说：

```perl
say $var;
```

你大可不必担心老代码里出现新的函数。
新函数只有在你明确要求使用时才可用，通过这么写：

```perl
use feature qw(say);
```

或者你要求你的代码运行在至少5.10版本以上。

```perl
use 5.010;
```

## defined or

另外一个很漂亮的助手是<b>//</b>定义或操作符。它基本上跟过去的<b>||</b>操作符一样，但是不会有<i>"0不是真实值"</i>这种bug：

此前当我们想给一个标量一个<b>默认值</b>时，我们或是这么写


```perl
$x = defined $x ? $x : $DEFAULT;
```

这有点太长，我们或是这么写

```perl
$x ||= $DEFAULT;
```

但是这样一来，0或者“0”或者空字符串不会被认为是一个合法的值。
他们会被$DEFAULT的值替换。有时候这没什么问题，但有些情况下，这带来了一个bug。

新的定义或操作符可以解决这个问题，因为他会返回右边的值即便左边的值是`undef`。
因此现在我们有了一个<b>简短而准确</b>的写法：

```perl
$x //= $DEFAULT;
```

## state

本文关注的第三个东西是新的<b>state</b>关键字。
这同样是可选的，只会在你要求时才会包含。你可以这样写

```perl
use feature qw(state);
```

或者这样写

```perl
use 5.010;
```

当使用时，它类似于<b>my</b>但是它仅仅一次创建并初始化变量。就像C语言里的<b>静态</b>变量。
从前我们会这么写一些代码：

```perl
{
   my $counter = 0;
   sub next_counter {
      $counter++;
      return $counter;
   }
}
```

这需要很费劲地解释为什么$counter仅设置为0一次却总是返回给你一个很大的值。乍一看，匿名块同样很不清晰。

如今你可以这么写：

```perl
sub next_counter {
   state $counter = 0;
   $counter++;
   return $counter;
}
```

这就比较清晰了。

关于`state`关键字的其他用例，查看[如何隐藏Perl的多个警告？](https://perlmaven.com/how-to-capture-and-save-warnings-in-perl).
