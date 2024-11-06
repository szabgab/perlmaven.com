---
title: "Perl 中的文件操作：删除和重命名 "
timestamp: 2012-08-24T14:45:20
tags:
  - unlink
  - remove
  - rm
  - del
  - delete
  - copy
  - cp
  - rename
  - move
  - mv
  - File::Copy
published: true
original: how-to-remove-copy-or-rename-a-file-with-perl
books:
  - beginner
author: szabgab
translator: swuecho
---


许多系统管理员出身的程序员，即使写Perl程序，也喜欢间接利用<b>rm</b>, <b>cp</b> 和 <b>mv</b> 来完成文件操作。
虽然这是可行的，但是没有充分利用Perl本身的威力。本节我们学习怎样用Perl内置的函数完成此类操作。


## 移除

`unlink` 可以移除一个或者多个文件。

 
```perl
unlink $file;
unlink @files;
```

如果没有显示地给出参数，默认的参数为`$_`, 参见[Perl 中的默认值](/the-default-variable-of-perl)。
 
更多信息请参考 [perldoc -f unlink](http://perldoc.perl.org/functions/unlink.html).

## 重命名

Perl自带的函数为 `rename`。

```perl
rename $old_name, $new_name;
```


`File::Copy`  模块中的`move` 函数比 `rename` 支持更多文件系统，因此是在某写情况下，是更好的选择。

```perl
use File::Copy qw(move);

move $old_name, $new_name;
```

更多文档：

[perldoc -f rename](http://perldoc.perl.org/functions/rename.html).

[perldoc File::Copy](http://perldoc.perl.org/File/Copy.html).

## 复制

Perl 中没有对应的函数来完成复制操作。通常用 `File::Copy`  模块中的`copy` 函数

```perl
use File::Copy qw(copy);

copy $old_file, $new_file;
```


参见： [perldoc File::Copy](http://perldoc.perl.org/File/Copy.html).


