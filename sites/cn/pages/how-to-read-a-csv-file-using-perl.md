---
title: "CSV 文件处理"
timestamp: 2013-04-13T12:45:56
tags:
  - CSV
  - split
  - Text::CSV
  - Text::CSV_XS
published: true
original: how-to-read-a-csv-file-using-perl
books:
  - beginner
author: szabgab
translator: swuecho
---


读取并处理文本是 Perl 的强项。有时候你有一个CSV (Comma-separated values)文件，需要从中提取信息，该怎么办呢？

本节给出三个解决方案。

如果你的CSV文件比较简单，简单的Perl脚本就能轻松搞定。这里是我们的方案一。

第二个方案能够对付稍微复杂的CSV文件。

第三个方案，能够处理所有的情况，不过，需要用CPAN上的模块。


假设我们有一文件，内容如下：

```
Tudor,Vidor,10,Hapci
Szundi,Morgo,7,Szende
Kuka,Hofeherke,100,Kiralyno
Boszorkany,Herceg,9,Meselo
```


这就是一个基本的CSV文件。每个数据项由逗号隔开(Comma-separated values)，多行构成一个文件。

当然，分隔符不一定是逗号，只要保持一致就好了。不过通常是逗号隔开，也有是用 TAB 或者 | 键隔开。

我们要做的是算出第三列所有数字之和。

##  思路 


<ol>
<li>按行读取文件</li>
<li>从读取的行中，取出第三列的值</li>
<li>累加</li>
</ol>


我们在以前的章节中学过怎样按行读取文件。下面我们来看怎样提取第三列的值。

你可能想到直接用`substr()`，不过，因为第三列的位置在每一行中不是固定的。那什么是不变的呢？
第三列的值总是在第二个逗号与第三个逗号之间。基于此，我们可以用`index()` 来得到每一行，
第二个和与第三个逗号的位置。然后再用`substr()`。不过，Perl中，有更好的方法。


## 用 split

`split()` 的中文意思是分隔。要实现分隔的操作，你需要分隔符和要分的字符串。
分隔符可以是字符串，甚至是正则式。简单起见，我们只用字符串。

如果你有一个字符串`$str = "Tudor:Vidor:10:Hapci"`，执行`@fields = split(":"  ,   $str);`，
`@fields`中将会有四个值， "Tudor", "Vidor", "10" and "Hapci"。`print $fields[2]`将会得到 10。
不要忘了，Perl 数组从 0 开始索引的。

对于我们的问题，用 `@fields = split("," , $str);` 就可以了。当然，`split ` 后的 ` () `通常省略。

所以，完整的程序可以这样写：

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";

my $sum = 0;
open(my $data, '<', $file) or die "Could not open '$file' $!\n";

while (my $line = <$data>) {
  chomp $line;

  my @fields = split "," , $line;
  $sum += $fields[2];
}
print "$sum\n";
```

保存为csv.pl，在终端输入 `perl csv.pl data.csv` 就可以得到结果了。

## 万一有数据项中带逗号怎么办？

显然，我们的程序不能用了。

比如这个文件，完全符合CSV的格式规定。

```
Tudor,Vidor,10,Hapci
Szundi,Morgo,7,Szende
Kuka,"Hofeherke, alma",100,Kiralyno
Boszorkany,Herceg,9,Meselo
```

第三行，split后，第三列的值是 alma"。

## Text::CSV

好像有点复杂了，是吧，那好，求助 CPAN。幸运的是，[Text::CSV](https://metacpan.org/pod/Text::CSV) 能够帮助我们。

解决上个问题的代码：

```perl
#!/usr/bin/perl
use strict;
use warnings;

use Text::CSV;
my $csv = Text::CSV->new({ sep_char => ',' });

my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";

my $sum = 0;
open(my $data, '<', $file) or die "Could not open '$file' $!\n";
while (my $line = <$data>) {
  chomp $line;

  if ($csv->parse($line)) {

      my @fields = $csv->fields();
      $sum += $fields[2];

  } else {
      warn "Line could not be parsed: $line\n";
  }
}
print "$sum\n";
```



`Text::CSV` 是Perl的第三方扩展，帮助我们读写 CSV 文件。Perl 程序员把第三方扩展称为模块，有些语言中称为类库。

使用模块之前，需要先安装。我们已经讲过怎样安装模块，在这里不做赘述。

安装了模块以后，用`use Text::CSV;`来加载。

Text::CSV 实际是一个类，可以用new来创建这个类的实例。`->` 是调用的意思。

`my $csv = Text::CSV->new({ sep_char => ',' });` 创建了一个类的实例，通常称为对象。
Perl 中对象也是一个标量。事实上，可以省略 { sep_char => ',' } 因为，默认的分隔符(sep_char) 是逗号。

接下来，说说 split 和 $sum 所在的行。

Text::CSV 模块没有split 函数，而是提供了 “parse 函数” ————在面向对象编程中，称为"parse 方法"。用箭头(->)来调用

`$csv->parse($line)` 的意思是，解析 $line， 它并不直接返回解析的内容，而是告诉你解析是否成功，
比如，如果 $line 的内容是 `Kuka,"Hofeherke, alma,100,Kiralyno`，解析就会失败，因为这行的内容不符合 CSV的格式。

如果解析成功，我们可以调用 `fields` 方法，来取得解析的值。然后取出我们想要的那个。

## 一个数据项占据多行

比如：

```
Tudor,Vidor,10,Hapci
Szundi,Morgo,7,Szende
Kuka,"Hofeherke,
alma",100,Kiralyno
Boszorkany,Herceg,9,Meselo
```

我们的上个解决方案又不行了。不过 [Text::CSV](https://metacpan.org/pod/Text::CSV) 是可以解决这个问题的。


以下代码基于[Text::CSV_XS](https://metacpan.org/pod/Text::CSV_XS) 模块现任维护者的评论:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use Text::CSV;

my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";

my $csv = Text::CSV->new ({
  binary    => 1,
  auto_diag => 1,
  sep_char  => ','    # not really needed as this is the default
});

my $sum = 0;
open(my $data, '<:encoding(utf8)', $file) or die "Could not open '$file' $!\n";
while (my $fields = $csv->getline( $data )) {
  $sum += $fields->[2];
}
if (not $csv->eof) {
  $csv->error_diag();
}
close $data;
print "$sum\n";
```


上例中，我们不再按行读取文件，而是打开文件后，交给Text::CSV 模块处理，我们通过  `getline` 来
得到需要的行。Text::CSV 会把占据多个行的数据项当作一个数据正确处理，而不是当作多行。


另外，`getline` 返回的并不是我们期望的数组，而是数组的引用。想要从数组的引用中得到第三项，用
`$fields->[2]`。我们以后会更详细的学习引用相关的知识。

如果读完CSV的数据项，正常情况下，应该是到了文件末尾。如果不是，那就是有问题，我们让程序输出诊断信息。

