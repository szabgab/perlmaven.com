---
title: "标量"
timestamp: 2013-05-14T10:13:34
tags:
  - strict
  - my
  - undef
  - say
  - +
  - x
  - .
  - sigil
  - $
  - "@"
  - "%"
  - FATAL warnings
published: true
original: scalar-variables
books:
  - beginner
author: szabgab
translator: terrencehan
---


在本节[Perl Tutorial](/perl-tutorial)中我们会来看一下Perl中的数据结构以及如何应用它们。

Perl5中有3中数据结构：<b>标量，数组以及哈希表</b>。后者（哈希表）在其它语言中也称为词典、查找表或者是关联数组。


Perl中的变量总是有一个前缀<b>魔符</b>。对于标量魔符是`$`，数组是`@`，哈希表是`%`。

一个标量含有单个值，例如一个数字或者一个字符串。它也可以包含指向另外一个数据结构的引用，这样我们可以寻址使用它们。

标量的名字总是以`$`（美元符号）开头，后面是字母、数字和下划线。例如，标量的名字可以是`$name` 或 `$long_and_descriptive_name`，也可以是`$LongAndDescriptiveName`（这种称为 “驼峰式”)，但是在Perl社区中，人们更喜欢使用小写字母加下划线的形式命名。

因为我们一直使用<b>strict</b>，所以必须首先使用<b>my</b>来声明变量。（后面你也会学习到<b>out</b>以及其他声明方法，但是现在先把注意力放在<b>my</b>声明。） 我们可以在声明变量的时候立即赋值：

```perl
use strict;
use warnings;
use 5.010;

my $name = "Foo";
say $name;
```

或者也可以先声明变量之后再赋值：

```perl
use strict;
use warnings;
use 5.010;

my $name;

$name = "Foo";
say $name;
```

如果代码的逻辑允许的话，我们更倾向于使用前者的方式。

如果我们声明了一个变量，但是没有赋值，那么它含有一种称为[undef](/undef-and-defined-in-perl)的值，它类似于数据库中的<b>NULL</b>，但是又稍微的不同。

我们可以通过`defined`函数来检查一个变量是否为`undef`：

```perl
use strict;
use warnings;
use 5.010;

my $name;

if (defined $name) {
  say 'defined';
} else {
  say 'NOT defined';
}

$name = "Foo";

if (defined $name) {
  say 'defined';
} else {
  say 'NOT defined';
}

say $name;
```

我们可以通过赋值`undef`把一个变量设置成`undef`：

```perl
$name = undef;
```

标量可以赋值成数字或字符串。所以可以写：

```perl
use strict;
use warnings;
use 5.010;

my $x = "hi";
say $x;

$x = 42;
say $x;
```

它也有效。

Perl中的符号和符号重载是符合工作的呢？

大体上，Perl和其它编程语言的处理方式是不同的。它是通过操作符来告诉操作数扮演什么角色，而不是操作数告诉操作符如何去处理。

所以，假如我们有两个数字变量，操作符决定它们的表现行为是数字还是字符串：

```perl
use strict;
use warnings;
use 5.010;

my $z = 2;
say $z;             # 2
my $y = 4;
say $y;             # 4

say $z + $y;        # 6
say $z . $y;        # 24
say $z x $y;        # 2222
```

`+`（数字加号）会把两个数字相加，此时`$y`和`$z`会表现的像两个数字。

`.`会连接两个字符串，此时`$y`和`$z`会表现像两个字符串。（在其它语言中你可能称之为字符串加法。）

`x`（重复操作符），会根据右侧的数字将左侧的字符串重复相应的次数，所以此时`$z`会表现成一个字符串，而`$y`是一个数字。

如果我们赋值的时候使用的是字符串，结果还是一样的：

```perl
use strict;
use warnings;
use 5.010;

my $z = "2";
say $z;             # 2
my $y = "4";
say $y;             # 4

say $z + $y;        # 6
say $z . $y;        # 24
say $z x $y;        # 2222
```

即便其中一个是数字，而其它的是字符串，也是一样：

```perl
use strict;
use warnings;
use 5.010;

my $z = 7;
say $z;             # 7
my $y = "4";
say $y;             # 4

say $z + $y;        # 11
say $z . $y;        # 74
say $z x $y;        # 7777
```

Perl会根据操作符自动地进行数字到字符串以及字符串到数字的转换。

我们称之为数字和字符串<b>上下文</b>。

上面的例子相对简单。我们把数字转换成字符串，似乎是仅仅用引号括起来。把字符串转换成数字的例子也很简单，因为这些字符串全是由数字组成的。如果在字符串中加入小数点也是一样的，好比`"3.14"`。问题是，如果字符串包含非构成数字的字符会怎么样？例如， `"3.14 is pi"`，这会在数字操作中（数字上下文）如何处理呢？

即便是简单的例子也需要说明一下：

```perl
use strict;
use warnings;
use 5.010;

my $z = 2;
say $z;             # 2
my $y = "3.14 is pi";
say $y;             # 3.14 is pi

say $z + $y;        # 5.14
say $z . $y;        # 23.14 is pi
say $z x $y;        # 222
```

当字符串处于数字上下文时，Perl会查看字符串的左侧，并尝试将它转换成数字。转换的时候会尽可能长的将有意义的部分转换成数字。在数字上下文（`+`）中，字符串`"3.14 is pi"`会被看成数字`3.14`。

从某种程度上来说，这样的转换相当任意，但是这就是它工作的方式。

如果你使用了<b>use warnings</b>（强烈建议这么做），上面的代码会在标准错误输出（`STDERR`）上产生一个警告：

```
Argument "3.14 is pi" isn't numeric in addition(+) at example.pl line 10.
```

这样会帮助你注意到与设想不是严格匹配的情况。希望现在`$x + $y`这样的结果对你已经很清晰了。

## Background

需要确定的是，Perl并没有把`$y`转换成3.14，而仅仅是在加法操作时使用了它有数字意义的值。从`$z . $y`的结果上也可以得到佐证。后者Perl使用的是字符串的原始值。

你可能会好奇，为什么当右侧是3.14时`$z x $y`显示的是222，但很明显的是perl只会重复整数次字符串... 在这个操作中，perl悄悄地对右侧的数字取整。（如果仔细琢磨，你就会意识到之前提到的数字上下文实际上也有好几个子上下文，其中之一就是整数上下文。在大多数情况下，perl会为不是程序员的人们做“正确的事情”）。

不仅如此，我们也看不到在`+`例子中“部分字符串转换成数字”的警告。

这不是因为操作符的不同。如果注释掉加法操作，我们又会再此操作上看到警告。缺失第二次警告的原因时，当perl给字符串`"3.14 is pi"`创建数字值时，它也把这个值放在了`$y`变量一个隐藏的位置。所以，实际上`$y`现在有字符串和数字两个值，在之后新的操作上会从中选用正确的值来避免转换。

还有三件事情我需要说明一下。第一个是包含`undef`的变量的行为，第二个是<b>fatal warnings</b>，第三个是如何避免自动地“字符串到数字转换”。

## undef

如果一个变量的值是`undef`，对于大部分人来说这表示"nothing"，不过它仍然可以使用。在数字上下文中它表示0，在字符串上下文中它表示空串。

```perl
use strict;
use warnings;
use 5.010;

my $z = 3;
say $z;        # 3
my $y;

say $z + $y;   # 3
say $z . $y;   # 3

if (defined $y) {
  say "defined";
} else {
  say "NOT";          # NOT
}
```

有两个警告：

```
Use of uninitialized value $y in addition (+) at example.pl line 9.

Use of uninitialized value $y in concatenation (.) or string at example.pl line 10.
```

如你所见，到最后变量仍然是`undef`，因此条件判断时会打印"NOT"。

## Fatal warnings

有些人可能更倾向于抛出一个硬异常而不是软警告。如果这是你想要的，你可以改变一下脚本的开头，这么写：

```perl
use warnings FATAL => "all";
```

把这些包含在代码里后，脚本会打印出数字3，然后抛出异常：

```
Use of uninitialized value $y in addition (+) at example.pl line 9.
```

这与第一个警告的信息一样，但是此时脚本会停止运行。（除非异常被捕获，这我们后再再说。）

## 避免字符串到数字的自动转换

如果想要在没有明确转换的时候避免字符串的自动转换，你可以当从外部获取数据的时候检查一下字符串是否看起来像数字。

为此，我们会加载 [Scalar::Util](https://metacpan.org/pod/Scalar::Util)模块，并调用它提供的`looks_like_number`函数。

```perl
use strict;
use warnings FATAL => "all";
use 5.010;

use Scalar::Util qw(looks_like_number);

my $z = 3;
say $z;
my $y = "3.14";

if (looks_like_number($z) and looks_like_number($y)) {
  say $z + $y;
}

say $z . $y;

if (defined $y) {
  say "defined";
} else {
  say "NOT";
}
```


## 操作符重载

在操作数告知操作符如何处理的时候，你已经使用了操作符重载。这部分留在高级内容时再讲解。

