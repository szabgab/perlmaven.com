---
title: "Perl5中19个最重要的文件系统工具"
timestamp: 2013-04-21T12:45:04
tags:
  - cwd
  - tempdir
  - catfile
  - catdir
  - dirname
  - FindBin
  - $Bin
  - File::Spec
  - File::Basename
  - File::Temp
  - Cwd
published: true
original: the-most-important-file-system-tools
author: szabgab
translator: terrencehan
---



在写脚本处理文件系统时，经常需要加载很多模块。其中好多有用函数分散在各种不同的模块中。它们有些是Perl的内置函数，有些是在同Perl一起发行的标准模块中，另外一些是通过CPAN安装的。

下面来看15个最常用的工具。


## 当前路径

我经常需要知道当前所在的文件夹是什么。<b>Cwd</b> 模块有一个同名但是小写的函数 <b>cwd</b>，它会返回<b>当前工作目录</b>。

<img src="/img/Hdd_icon.svg" style="float: right" />

```perl
use strict;
use warnings;

use Cwd qw(cwd);

print cwd, "\n";
```


## 临时文件夹

我经常需要创建一批临时文件，并且确保它们在脚本结束的时候会被自动删除。要满足这个需求，最简单的方法是以 CLEANUP 选项使用 <b>File::Temp</b> 模块的 <b>tempdir</b> 函数来创建一个临时文件夹。


```perl
use strict;
use warnings;
use autodie;

use File::Temp qw(tempdir);

my $dir = tempdir( CLEANUP => 1 );

print "$dir\n";

open my $fh, '>', "$dir/some_file.txt";
print $fh "text";
close $fh;
```


## 与操作系统无关的路径

如果上面的代码要在 Linux 和 Windows 上都要运行，人们会习惯在 Windows 平台上用反斜线分割路径。否则，在VMS上不能执行。而这就是 <b>File::Spec::Functions</b>模块中<b>catfile</b>函数的用武之地。

```perl
use strict;
use warnings;

use File::Spec::Functions qw(catfile);

use File::Temp qw(tempdir);

my $dir = tempdir( CLEANUP => 1 );

print "$dir\n";
print catfile($dir, 'some_file.txt'), "\n";
```

执行这个代码后，能看到临时文件夹被打印出来，紧跟其后的是文件名字。

## 切换目录

通常情况下，先切换工作目录到临时文件夹再进行操作会更简单。但是也存在其他情况的写测试。此时我们可以使用内置函数<b>chdir</b>。


```perl
use strict;
use warnings;
use autodie;

use File::Temp qw(tempdir);
use Cwd;

my $dir = tempdir( CLEANUP => 1 );
print cwd, "\n";
chdir $dir;
print cwd, "\n";

open my $fh, '>', 'temp.txt';
print $fh, 'text';
close $fh;
```

以上看起来可以正常工作，但是当File::Temp尝试删除文件夹，而我们仍然“在里面”（之前切换工作目录到它）时就会有问题。

例如，我会得到下面的错误信息：

```
cannot remove path when cwd is /tmp/P3DZP_rmqg for /tmp/P3DZP_rmqg:
```

为了避免这种情况，我通常会在切换目录之前保存<b>cwd</b>的返回值，并且在最后再次调用<b>chdir</b>。

```perl
my $original = cwd;

...

chdir $original;
```

这样仍然会有个小问题。如果我在脚本中间调用<b>exit()</b>，或者在执行到<b>chdir $original</b>之前抛出异常而终止脚本，会发生什么？

Perl提供了一个解决方案:把最后一个chdir包裹在<b>END</b>块中。如此，就会确保无论何时、以何种方式退出脚本，这些代码都会执行到。

```perl
my $original = cwd;

...

END {
    chdir $original;
}
```


## 相对路径

当写一个多文件构成的项目(例如一个或多个脚本，多个模块，也可能是多个模板)，并且我不想“安装”它们时，最好的目录组织方式是：确保每个文件都在一个固定的<b>相对</b>位置。

所以，我的项目目录通常会包含一个脚本子文件夹，一个模块文件夹(lib)， 一个模板文件夹， 等等：

```
project/
     scripts/
     lib/
     templates/
```

那么，如何才能确保脚本能够找到模板？ 我有好几个处理办法：


```perl
use strict;
use warnings;
use autodie;

use FindBin qw($Bin);
use File::Basename qw(dirname);
use File::Spec::Functions qw(catdir);

print $Bin, "\n";                                # /home/foobar/Rocket-Launcher/scripts
print dirname($Bin), "\n";                       # /home/foobar/Rocket-Launcher
print catdir(dirname($Bin), 'templates'), "\n";  # /home/foobar/Rocket-Launcher/templates
```

<b>FindBin</b>模块导出的参量<b>$bin</b>存放着当前脚本的目录路径。 在我们的例子中就是指向project/scripts/文件夹的路径。

<b>File::Basename</b>中的<b>dirname</b>函数会传入一个路径，并返回除最后一部分之外的路径。

最后一行<b>File::Spec::Functions</b>模块的<b>catdir</b>函数基本上和我们之前看到的catfile一样。

除了打印到屏幕上，当然也可以使用catdir的返回值来表示templates路径。

## 从相对路径中加载模块

大部分情况下，要查找和加载的模块都会在项目的lib/文件夹中。为此，我们会把之前的代码和<b>lib</b>指令连用。这样会改变<b>@INC</b>变量的值，把相对路径添加在数组开头。

```perl
use strict;
use warnings;
use autodie;

use FindBin qw($Bin);
use File::Basename qw(dirname);
use File::Spec::Functions qw(catdir);

use lib catdir(dirname($Bin), 'lib');

use Rocket::Launcher;
```

假定存在lib/Rocket/Launcher.pm文件。


## 其它的在哪?

关于这个话题还有很多值得去讲解的，但是我认为作为本系列的开头部分，这些就已经足够了。如果你想确保自己不会错过剩下的部分， 欢迎[订阅newsletter](/register)。



[Image source](http://commons.wikimedia.org/wiki/File:Hdd_icon.svg)
