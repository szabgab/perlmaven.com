---
title: "如何使用Perl对文本进行字符串替换"
timestamp: 2013-05-04T13:10:10
tags:
  - open
  - close
  - replace
  - File::Slurp
  - read_file
  - write_file
  - slurp
  - $/
  - $INPUT_RECORD_SEPARATOR
published: true
original: how-to-replace-a-string-in-a-file-with-perl
books:
  - beginner
author: szabgab
translator: herolee
---


恭喜你！你的创业公司被超大企业收购了。
你需要把文件README.txt里的<b>Copyright Start-Up</b>换成<b>Copyright Large Corporation</b>。


## File::Slurp

如果你安装了[File::Slurp](https://metacpan.org/pod/File::Slurp)，
而且文件不是太大，能完全载入你电脑的内存，这可以是一种解决方案：

```perl
use strict;
use warnings;

use File::Slurp qw(read_file write_file);

my $filename = 'README.txt';

my $data = read_file $filename, {binmode => ':utf8'};
$data =~ s/Copyright Start-Up/Copyright Large Corporation/g;
write_file $filename, {binmode => ':utf8'}, $data;
```

File::Slurp里的`read_file`函数会把整个文件读入到一个单一标量变量里。这里假定文件不是太大。

我们设置`binmode => ':utf8'`用以正确处理字符编码。
之后用一个带有`/g`修改标示符的正则表达式来<b>全局</b>地在所有旧文本出现的地方，将其替换成新文本。

然后我们保存内容到同一个文件中，再次使用`binmode => ':utf8'`来正确处理字符编码。

## 单纯使用perl替换文本

要是你没法安装File::Slurp，你可以实现一个它的函数的简单版本。
本例中，代码主要部分几乎一样，除了我们不传递参数以Unicode方式打开文件。
我们把这部分写进了函数里。你可以看到里边是如何调用`open`的。

```perl
use strict;
use warnings;

my $filename = 'README.txt';

my $data = read_file($filename);
$data =~ s/Copyright Start-Up/Copyright Large Corporation/g;
write_file($filename, $data);
exit;

sub read_file {
    my ($filename) = @_;

    open my $in, '<:encoding(UTF-8)', $filename or die "Could not open '$filename' for reading $!";
    local $/ = undef;
    my $all = <$in>;
    close $in;

    return $all;
}

sub write_file {
    my ($filename, $content) = @_;

    open my $out, '>:encoding(UTF-8)', $filename or die "Could not open '$filename' for writing $!";;
    print $out $content;
    close $out;

    return;
}
```

在函数`read_file`里，我们把`$/`（也被称作输入记录分隔符）变量设置为`undef`。
这常被称作<b>slurp模式</b>。它告诉perl的"行读取"操作符把文件的所有内容读入到一个标量变量里，并赋给左值：`my $all = &lt;$in>;`。
我们也可以用`local`关键字来设置`$/`，以便其一旦退出所包含的的代码块后能被还原——在这里是一旦离开`read_file`函数。

`write_file`函数则显得更加直白，我们之所以把它放进一个函数中调用，只是为了让代码的主体跟之前的一个版本类似。