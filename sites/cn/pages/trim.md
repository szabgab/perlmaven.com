---
title: "trim - 使用Perl删除前导和拖尾空白"
timestamp: 2013-05-05T10:01:01
tags:
  - trim
  - ltrim
  - rtrim
published: true
original: trim
books:
  - beginner
author: szabgab
translator: herolee
---


其它一些编程语言中，有函数<b>ltrim</b>和<b>rtrim</b>分别用于从字符串开头和末尾删除空格和制表符。
也有的提供了函数<b>trim</b>来删除字符串两端的空白字符。

Perl里没这些函数因为简单的正则表达式替换就能实现这个目的（不过我确信CPAN有很多模块实现了这些函数）。

事实上这太简单了以至于成了[帕金森琐碎定理](https://en.wikipedia.org/wiki/Parkinson%27s_law_of_triviality)里的一个显著主题。


## 左侧整理

<b>ltrim</b>或者<b>lstrip</b>从字符串左侧删除空白字符：

```perl
$str =~ s/^\s+//;
```

从字符串开头`^`开始匹配一个或者多个空白字符(`\s+`)，并将之替换成空字符。

## 右侧整理

<b>rtrim</b>或者<b>rstrip</b>从字符串右侧删除空白字符：

```perl
$str =~ s/\s+$//;
```

匹配一个或者多个空白字符(`\s+`)直到字符串末尾(`$`)，并将之替换成空字符。

## 整理两端

<b>trim</b>删除字符串两端的空白字符：

```perl
$str =~ s/^\s+|\s+$//g
```

将上面两个正则表达式用或记号`|`连起来，并在最后增加`/g`用以<b>全局</b>地执行替换操作（反复多次）。


## 封装在函数里

如果你不想在代码中看到这些结构，你可以在代码里添加这些函数：

```perl
sub ltrim { my $s = shift; $s =~ s/^\s+//;       return $s };
sub rtrim { my $s = shift; $s =~ s/\s+$//;       return $s };
sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };
```

使用时像这样：

```perl
my $z = " abc ";
printf "<%s>\n", trim($z);   # <abc>
printf "<%s>\n", ltrim($z);  # <abc >
printf "<%s>\n", rtrim($z);  # < abc>
```


## String::Util

要是实在不想拷贝那些东西，你可以安装一个模块。

例如[String::Util](https://metacpan.org/pod/String::Util)提供了函数`trim`，你可以如下使用：

```perl
use String::Util qw(trim);

my $z = " abc ";
printf "<%s>\n", trim( $z );              # <abc>
printf "<%s>\n", trim( $z, right => 0 );  # <abc >
printf "<%s>\n", trim( $z, left  => 0 );   # < abc>
```

默认它整理两侧，你不需要提供参数。
我觉得，自己实现`ltrim`和`rtrim`会清晰些。

## Text::Trim

另一个模块[Text::Trim](https://metacpan.org/pod/Text::Trim)提供了3个函数，但是它极度采纳了Perl风格的写法，可能到了有些危险的地步。

如果你调用它并将返回值用在print语句或者赋给一个变量，它会返回整理过的字符串，并保持原始字符串不变。

```perl
use Text::Trim qw(trim);

my $z = " abc ";
printf "<%s>\n", trim($z);  # <abc>
printf "<%s>\n", $z;       # < abc >
```

另一方面，如果你在空白上下文调用它，亦即不使用返回值，trim函数就会修改参数，产生类似[chomp](/perldoc/chomp)的行为。

```perl
use Text::Trim qw(trim);

my $z = " abc ";
trim $z;
printf "<%s>\n", $z;       # <abc>
```