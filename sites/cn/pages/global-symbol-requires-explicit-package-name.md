---
title: "全局符号需要明确包名"
timestamp: 2013-05-02T12:45:56
tags:
  - strict
  - my
  - package
  - global symbol
published: true
original: global-symbol-requires-explicit-package-name
books:
  - beginner
author: szabgab
translator: herolee
---


以我浅见，<b>全局符号需要明确包名</b>在Perl里是个常见的错误信息，而且具有相当的迷惑性。
至少对于初学者而言。

它可以简单的翻译为“你需要用<b>my</b>声明变量。”


## 最简单的例子

```perl
use strict;
use warnings;

$x = 42;
```

错误是

```
Global symbol "$x" requires explicit package name at ...
```

虽然实际的错误信息是准确的，但是对于Perl初学者来说并没什么用。
他们可能还不知道什么是包，更不用说怎么样才可以比$x更明确了。

这个错误是由于<b>use strict</b>引起的。

文档中的解释是：
<i>
如果你访问一个没有使用"our"或者"use vars"或者通过"my()"真正局部化声明的变量，会遇到一个编译期错误。
</i>

初学者很可能每个脚本都会以<b>use strict</b>开头，也很可能早就学过了<b>my</b>。

我不知道perl是否会更改错误信息。这不是本文要讨论的。本文只是帮初学者以他们自己的语言理解这个错误信息是什么意思。

要消除这个错误，需要这么写：

```perl
use strict;
use warnings;

my $x = 42;
```

亦即，需要<b>在第一次使用变量之前，用my声明变量</b>。

## 糟糕的办法

另一个“办法”是删除<b>strict</b>：
The other "solution" is to remove <b>strict</b>:

```perl
#use strict;
use warnings;

$x = 23;
```

这样可以运行，但是这个代码会产生一个警告[Name "main::x" used only once: possible typo at ...](/name-used-only-once-possible-typo)。

不管怎样，通常你都不会不系安全带开车吧？

## 例子2: 作用域

新手常犯的错误还有下面这样的：

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
my $y = 2;
}

print $y;
```

错误信息跟上边的一样：

```
Global symbol "$y" requires explicit package name at ...
```

这令很多人迷惑不解。尤其是他们已经开始编程的，毕竟他们使用`my`声明了`$y`。

首先，这有个小的视觉问题。`my $y = 2;`的缩进没有了。
要是能像下一个例子这样向右缩进一些空格或者一个tab键，问题的根源就一目了然了：

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
    my $y = 2;
}

print $y;
```

问题在于变量`$y`是在块里声明的（一对大括号），在代码块之外就不可见了。
这就是变量的<b>作用域</b>。


<b>作用域</b>的概念在不同的编程语言里是不一样的。
在Perl里，大括号包含的块创建了一个作用域。
它里边使用`my`声明的东西，在块之外是访问不到的。

（另外，`$x = 1`的存在只是让创建作用域的语句看起来更真实。）

解决方案是或者在块内调用`print`：

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
    my $y = 2;
    print $y;
}
```

或者在块外部定义变量（而非内部！！）：

```perl
use strict;
use warnings;

my $x = 1;
my $y;

if ($x) {
    $y = 2;
}

print $y;
```

用哪一种取决于实际的情况。这些只是从语法上可能的正确解决方案。

当然，如果你忘了删除块内的`my`，或者if `$x`判断为假，那我们会碰到一个[使用了未初始化值](/use-of-uninitialized-value)的警告。

## 其他办法

另有章节专门讲解`our`、`use vars`的作用，或者如何完全限定变量名称。