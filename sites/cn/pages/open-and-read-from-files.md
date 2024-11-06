---
title: "打开并读取文本文件"
timestamp: 2013-04-29T10:45:56
tags:
  - open
  - <$fh>
  - read
  - <
  - encoding
  - UTF-8
  - die
  - open or die
published: true
original: open-and-read-from-files
books:
  - beginner
author: szabgab
translator: herolee
---


在本部分[Perl教程](/perl-tutorial)中，我们将会看到<b>如何使用Perl读取文件</b>.

此时，我们只关注文本文件。


根据如何处理出错的情形，通常有两种常见的方法打开文件。

## 抛出异常

情形1: 如果不能打开文件，抛出一个异常：

```perl
use strict;
use warnings;

my $filename = 'data.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

while (my $row = <$fh>) {
  chomp $row;
  print "$row\n";
}
```

## 告警或者不处理

情形2: 如果不能打开文件，提出一个警告但是继续执行程序：

```perl
use strict;
use warnings;

my $filename = 'data.txt';
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    print "$row\n";
  }
} else {
  warn "Could not open file '$filename' $!";
}
```

## 解释

我们来具体看一下:

首先，用文本编辑器创建一个文件并命名为'data.txt'，在里面加几行：

```
First row
Second row
Third row
```

打开文件并读取跟我们如何
[打开文件并写入](/writing-to-files-with-perl)非常类似，
除了是不用">" (`>`) 符号, 而是使用"<" (`<`) 符号以外。

这里我们把编码设置为UTF-8。以下的代码大部分你会只看到"<"符号。

```perl
use strict;
use warnings;

my $filename = 'data.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

my $row = <$fh>;
print "$row\n";
print "done\n";
```

获取了文件句柄之后我们可以使用同样的行读取操作符从中读取内容，这跟
[从键盘读取(标准输入)](/installing-perl-and-getting-started)一样。
这会从文本中读取第一行。
然后我们打印$row的内容并打出"done"以清晰的表明我们例子运行完毕。

运行上面的代码，你会看到打印以下内容：
If you run the above script you will see it prints

```
First row

done
```

你可能会问为什么"done"之前会有一个空行。

这是因为行读取操作符会读入该行所有内容，包括末尾的新行符。当我们用
`print()`把它打印出来时，我们又增加了一个新行。

正如从标准输入读取一样，这里我们通常不需要末尾的新行符，所以我们使用`chomp()`来删除它。

## 读取不只一行

知道如何单行读取之后，我们可以把行读取操作放到`while`循环里。

```perl
use strict;
use warnings;

my $filename = $0;
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

while (my $row = <$fh>) {
  chomp $row;
  print "$row\n";
}
print "done\n";
```

每次进入`while`循环条件，首先执行`my $row = <$fh>`，这里会读取从文件中读取下一行。
如果下一行是空，条件判定就为真。
If that line has anything in it, that will evaluate to true.
即便空行末尾也有一个新行符，所以读取时`$row`变量会包含一个`\n`，这在真假判定是认为是真。

读到最后一行后，下一个行读取操作(`<$fh>`)的迭代会返回undef，判定为假。while循环将终止。

<h3>一个特例</h3>

这里有个特例，当文本最后一行只有一个0，而且末尾没有新行符的时候。
上述代码会评估这一行为假而不执行循环体。幸运的是，Perl在这里欺骗了一下。
在这个特例（在while循环里读取文件）中，perl实际上会认为你写的是`while (defined my $row = <$fh>) {` ，因此即便这类行也会被正确读取。


## 打开时不用die退出

上述处理文件的方法适用于你的Perl脚本一定需要打开文件，否则就不执行代码。
比如，脚本的所有功能是解析那个文件。

如果只是一个可选的配置型文件怎么办？如果你可以从中获取，你修改一些配置。
如果不能，你可以使用默认值。

这种情况下，第二个方案或许是更好的办法。

```perl
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    print "$row\n";
  }
} else {
  warn "Could not open file '$filename' $!";
}
```

这里我们检查`open`的返回值。
如果是真，继续读取内容。

如果是假，我们使用内置函数`warn`提示一个警告，而不是抛出异常。
甚至可以连`else`警告部分都不要:

```perl
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    print "$row\n";
  }
}
```

