---
title: "perl来帮忙（解析错误日志）"
timestamp: 2013-05-09T11:45:56
tags:
  - parsing
published: true
original: parsing-error-log
author: szabgab
translator: herolee
---



今天是2013年1月1日。
通常会做些重大决定、安排整年计划然后绝望地陷入无法实现“新年打算”之中。

相反的，让我们带着本站的真实意图来度过这一天。那就是使用Perl帮助别人。

几天前，我收到一份求救信。我来给大家引述一下，当然不含任何个人信息。


## 请求

我正学着如何使用perl处理各种类型的文件。
我会用Pascal、C或者VBA来做，但是目前还不知道怎么用perl高效地实现。

以下这些行来自一个错误日志：

```
================================================================
SOURCE LINE   00347
&N 77_F1_SOE_FREE
              ^
NOT A VALID NAME

SOURCE LINE   00390
&N SCAN_TIME_S
              ^
NOT A VALID NAME

SOURCE LINE   00433
&N XMIT_FAIL_TD
              ^
NOT A VALID NAME
==========     ERRORS  ON  ENTITY    77CF1007      ===========

SOURCE LINE   00482
ASSOCDSP = ""
             ^
MISSING QUOTE

SOURCE LINE   00483
$CDETAIL = ""
             ^
MISSING QUOTE

SOURCE LINE   00488
PRIMMOD = -
          ^
NOT A VALID NAME

SOURCE LINE   00489
PLCADDR = 33003
^
NAMED ITEM DOESN'T EXIST

SOURCE LINE   00490
PVHCAR   = LINEAR
^        ^ ^
NAMED ITEM DOESN'T EXIST
NAMED ITEM DOESN'T EXIST
NAMED ITEM DOESN'T EXIST

SOURCE LINE   00515
CCSRC = 0
^
NAMED ITEM DOESN'T EXIST
"MODNUM   "
MISSING DATA
"PVSRCOPT "
INVALID ENTRY
"$AUXUNIT "
INVALID ENTRY
==========     ERRORS  ON  ENTITY    77CF1008      ===========

SOURCE LINE   00525
ASSOCDSP = ""
             ^
MISSING QUOTE

SOURCE LINE   00526
$CDETAIL = ""
             ^
MISSING QUOTE

SOURCE LINE   00531
PRIMMOD = -
          ^
NOT A VALID NAME

SOURCE LINE   00532
PLCADDR = 33004
^
NAMED ITEM DOESN'T EXIST

SOURCE LINE   00533
PVHCAR   = LINEAR
^        ^ ^
NAMED ITEM DOESN'T EXIST
NAMED ITEM DOESN'T EXIST
NAMED ITEM DOESN'T EXIST

SOURCE LINE   00558
CCSRC = 0
^
NAMED ITEM DOESN'T EXIST
"MODNUM   "
MISSING DATA
"PVSRCOPT "
INVALID ENTRY
"$AUXUNIT "
INVALID ENTRY

========================================================
```

第一行表明原始文件哪一行有错。
第二行以&N开头表明哪条记录（关键字字段）包含错误。
第三行表明这是那种错误。

你怎么用perl处理这个文件呢？

十分感谢，
Foo

## CPAN上有这种解析器么？

我不知道这是什么格式的，不过我觉得Foo应该知道。
因此我首先想到的是看看[CPAN](http://metacpan.org/)上是否已经有了某个模块，可以解析这种文件了。

要是找不到，我就得开始思考如何自己解析它。

## 尝试理解问题

我当时忙于修改一些其他的东西，耽搁了几天之后，我读了电子邮件并开始思考他的真实意图是什么？
除了学习Perl之外，Foo想从这个文件解析出什么东西？

我回了封邮件还在等候他的澄清，不过可以先看一下我们能做些什么。

我觉得===这类位于顶部和底部的行只是用于分割实际数据和邮件内容。
我把这两行之间的数据保存成一个文件，叫做error.log。此后，我会处理这个文件。

<h3>实体</h3>

我发现文件被这些行分成了一些实体：

==========     ERRORS  ON  ENTITY    77CF1008      ===========

第一部分没有这个标题，我估计可能是在我拿到的片段里遗漏了，或者是这个实体真的可能就没这种标题。也可能这部分根本就没有标题。

没有进一步说明的情况下，我假定这是实体名字，而且有一类通用的实体根本就没有名字。

## 块

如邮件所说，第一行指出行号，下一行以&N开头指出记录，第三行是错误内容。
看了例子之后，我可以找到这三行，但我发现错误文本在第四行，第三行有个补字符号，可能用于表明在行中的位置。

```
SOURCE LINE   00347
&N 77_F1_SOE_FREE
              ^
NOT A VALID NAME
```

这倒没什么，但是我发现有另一类块。
比如这个块，第二行没有&N，而且错误信息有3行（而且第三行有3个补字符号）。

```
SOURCE LINE   00490
PVHCAR   = LINEAR
^        ^ ^
NAMED ITEM DOESN'T EXIST
NAMED ITEM DOESN'T EXIST
NAMED ITEM DOESN'T EXIST
```

为了阐述更方便，我将这类行的集合称为一个<b>块</b>，它以表达式"SOURCE LINE"开头并直到下一个块开始结束。
实际上，块也可能以新实体的标题或者文本末尾作为结束。因此我们需要处理这些特殊情况。

## 解析什么信息？

我可以想到有很多东西可以从这个文件解析出来：

每个实体有多少个块（错误），一共有多少？

出现哪些错误信息，频率怎么样？

## 处理文件——第一步

通常Perl里逐行读取文件。尤其是不知道文件有多大的时候。
有可能文件比计算机的可用内存还大呢？
我们不能假定能把整个文件读入内存。因此，采用逐行读取。

问题是在这个情况下，我们必须整块处理，保存好几行的信息作为一个单元。
另外我们只能在新的块开始时或者新的实体开始时或者文件结束时才能发现块已经结束了。

因此我们最好保存一个块的所有信息到内存中。

同样在内存中保存统计信息。通常哈希来处理这种情况很有效。

我们开头仍是老生常谈的代码。

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;
```

然后添加代码从命令行获取错误日志的文件名。
如果文件未提供，我们抛出异常并要求用户提供文件名。

```perl
my $filename = shift or die "Usage: $0 error.log\n";
```

接着我们打开文件并使用while循环逐行读入并使用<b>chomp</b>删除末尾新行符。
这里我们只是使用<b>say</b>函数打印出当前行。

我们把整个东西封装到子例程process中，以便使代码更可重用。

```perl
process($filename);

sub process {
    my ($file) = @_;

    open my $fh, '<', $file or die "Could not open '$file' $!";
    while (my $line = <$fh>) {
        chomp $line;
        say $line;
    }
}
```

将这部分代码合并，你可以这么尝试：

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

my $filename = shift or die "Usage: $0 error.log\n";

process($filename);

sub process {
    my ($file) = @_;

    open my $fh, '<', $file or die "Could not open '$file' $!";
    while (my $line = <$fh>) {
        chomp $line;
        say $line;
    }
}
```

## 解析并识别行

现在我们需要关注识别不同的特殊行。这里我们需要用到<b>正则表达式</b>。

<h3>实体标题</h3>

我们要识别是否到了实体标题行。
这需要使用以下代码替换`say $line;`。

```perl
    if ($line =~ /^=+ \s+ ERRORS \s+ ON \s+ ENTITY  \s+  (\w+) \s+ =+$/x) {
        $entity = $1;
        say $entity;
        say $line;
        next;
    }
```

这里我们在<b>正则表达式</b>末尾增加了<b>x</b>字符以便可以使用扩展语法。
这意味着我们可以在正则表达式里使用空格以提高可读性。

两个斜线<b>/</b>之间的部分是正则表达式。
以补字符号<b>^</b>标记开始，以美元符号<b>$</b>标记结束，这样确保我们描述了整个字符串。

`=+` 匹配一个或多个等号符号.

`\s+` 匹配一个或多个空白字符。

`(\w+)` 匹配一个或多个单词字符（字母，数字和下划线）。括号会捕获匹配的字符串并将其放入特殊变量`$1`。

我们同时保存当前的实体到一个全局变量里。

<h3>块标题</h3>

```perl
    if ($line =~ /^SOURCE \s+ LINE \s+ (\d+)$/x) {
        $block = $1;
        say $block;
        say $line;
        next;
    }
```

这里跟实体标题的情况差不多，除了`\d`只匹配数字。

<h3>记录名</h3>

记录名以&N开头为标识。

```perl
    if ($line =~ /^&N \s+(\w+)$/x) {
        $record = $1;
        say $record;
        say $line;
        next;
    }
```

<h3>丢弃的行</h3>

我们可能希望丢弃空行、只有补字符号的行。这里我们调用`next`从文件读入下一行。

```perl
    if ($line =~ /^[ ^]*$/) {
        say $line;
        next;
    }
```

我们假设余下的每行描述了一个错误，并把它们保存在一个数组里。

```perl
    push @errors, $line;
```

目前，我们的代码如下：
```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

my $filename = shift or die "Usage: $0 error.log\n";
process($filename);

my $entity;
my $block;
my $record;
my @errors;

sub process {
    my ($file) = @_;


    open my $fh, '<', $file or die "Could not open '$file' $!";
    while (my $line = <$fh>) {
        chomp $line;
        #say $line;
        if ($line =~ /^=+ \s+ ERRORS \s+ ON \s+ ENTITY  \s+  (\w+) \s+ =+$/x) {
            $entity = $1;
            #say $line;
            next;
        }
        if ($line =~ /^SOURCE \s+ LINE \s+ (\d+)$/x) {
            $block = $1;
            #say $line;
            next;
        }
        if ($line =~ /^&N \s+(\w+)$/x) {
            $record = $1;
            #say $line;
            next;
        }
        if ($line =~ /^[ ^]*$/) {
            #say $line;
            next;
        }
        push @errors, $line;
    }

    return;
}
```


## 处理一个块

当一个块结束时，我们需要处理收集到的信息，清理全局变量以便这个块里收集到的值不会出现在另一个块里。
我们创建了一个子例程process_block来达到这个目的。如上所述，我们需要在3个地方调用它。

子例程内，首先需要检查我们是否已经收集完了一个块的信息。这样我们不需要在行处理代码里进行特殊的处理。

之后我们填充两个哈希数组，一个用于统计每个实体里有多少块，一个用于统计每个错误出现的次数。
第二个不需要特殊处理，但是第一个有个例外。
如前边所讨论，可能在第一个实体声明之前存在某个块。这样变量$entity就是`undef`了。这会引发一个[使用未初始化的值](https://perlmaven.com/use-of-uninitialized-value)的警告。

为了让它能正常工作，我们或是需要用单独的变量统计这些块，或者需要使用一个特殊的默认实体名称。
我选择后者，并将$entry变量在声明时赋值为'_DEFAULT_'。

最后，我们清空全局变量里的值。

```perl
sub process_block {
    return if not $block;

    $block_count{$entity}++;
    foreach my $err (@errors) {
        $error_messages{$err}++;
    }

    $block = undef;
    $record = undef;
    @errors = ();

    return;
}
```


## 报表

代码最后一部分是生成报表。process()函数结束后，我们得到两个填充了值的哈希。
我们遍历每个哈希的键，根据键值[排序](https://perlmaven.com/sorting-arrays-in-perl)之后打印出他们的内容。

```perl
say "\nNumber of blocks in each Entity";
foreach my $bl (reverse sort { $block_count{$a} <=> $block_count{$b} } keys %block_count) {
    printf("%-15s %s\n", $bl, $block_count{$bl});
}
say "\nFrequency of errors";
foreach my $msg (reverse sort { $error_messages{$a} <=> $error_messages{$b} } keys %error_messages) {
    printf("%-25s %s\n", $msg, $error_messages{$msg});
}
```

## 完整脚本

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

my $filename = shift or die "Usage: $0 error.log\n";

my $entity = '_DEFAULT_';
my $block;
my $record;
my @errors;

my %error_messages;
my %block_count;

process($filename);
say "\nNumber of blocks in each Entity";
foreach my $bl (reverse sort { $block_count{$a} <=> $block_count{$b} } keys %block_count) {
    printf("%-15s %s\n", $bl, $block_count{$bl});
}
say "\nFrequency of errors";
foreach my $msg (reverse sort { $error_messages{$a} <=> $error_messages{$b} } keys %error_messages) {
    printf("%-25s %s\n", $msg, $error_messages{$msg});
}

sub process {
    my ($file) = @_;


    open my $fh, '<', $file or die "Could not open '$file' $!";
    while (my $line = <$fh>) {
        chomp $line;
        #say $line;
        if ($line =~ /^=+ \s+ ERRORS \s+ ON \s+ ENTITY  \s+  (\w+) \s+ =+$/x) {
            process_block();

            $entity = $1;
            #say $line;
            next;
        }
        if ($line =~ /^SOURCE \s+ LINE \s+ (\d+)$/x) {
            process_block();
            $block = $1;
            #say $line;
            next;
        }
        if ($line =~ /^&N \s+(\w+)$/x) {
            $record = $1;
            #say $line;
            next;
        }
        if ($line =~ /^[ ^]*$/) {
            #say $line;
            next;
        }
        push @errors, $line;
    }
    process_block();

    return;
}

sub process_block {
    return if not $block;

    $block_count{$entity}++;
    foreach my $err (@errors) {
        $error_messages{$err}++;
    }

    $block = undef;
    $record = undef;
    @errors = ();

    return;
}
```


## 输出

```
Number of blocks in each Entity
77CF1008        6
77CF1007        6
_DEFAULT_       3

Frequency of errors
NAMED ITEM DOESN'T EXIST  10
NOT A VALID NAME          5
INVALID ENTRY             4
MISSING QUOTE             4
PRIMMOD = -               2
"$AUXUNIT "               2
PVHCAR   = LINEAR         2
MISSING DATA              2
CCSRC = 0                 2
"PVSRCOPT "               2
"MODNUM   "               2
ASSOCDSP = ""             2
$CDETAIL = ""             2
PLCADDR = 33003           1
PLCADDR = 33004           1
```


## Further work

我相信可以针对这些值进行更进一步的处理。比如，一些字符串在引号里。我们可以删掉这些引号。
有些键值对在错误代码里，这些可以分隔开。
