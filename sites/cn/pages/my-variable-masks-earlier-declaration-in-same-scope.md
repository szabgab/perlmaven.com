---
title: ""my" 隐藏同作用域下之前的声明"
timestamp: 2013-05-21T15:04:23
tags:
  - my
  - scope
published: true
original: my-variable-masks-earlier-declaration-in-same-scope
books:
  - beginner
author: szabgab
translator: terrencehan
---


如果错误地尝试在一个作用域两次声明同一个变量，会产生如下编译时警告：

```
"my" variable ... masks earlier declaration in same scope at ... line ...
```

这是如何产生的？那么，每次循环的迭代重新声明的变量又如何有效呢？

如果不能在一个作用域写两次`my $x`，那该如何清空变量呢？


来看下面几个例子的不同之处：

## 普通的脚本

```perl
use strict;
use warnings;

my $x = 'this';
my $z = rand();
my $x = 'that';
print "OK\n";
```

此例会产生如下编译时警告：

```
"my" variable $x masks earlier declaration in same scope at ... line 7. )
```

因为这个脚本也会打印"OK"，所以这仅是一个警告。


## 条件语句的代码块

```perl
use strict;
use warnings;

my $z = 1;
if (1) {
    my $x = 'this';
    my $z = rand();
    my $x = 'that';
}
```

这次产生如下警告：

```
"my" variable $x masks earlier declaration in same scope at ... line 7.
```

在这两个例子中，我们都在同一个作用域中声明了两次`$x`，并且都产生了编译时警告。

在第二个例子里，我们也对`$z`进行了两次声明，但是没有产生任何警告。这是因为`$z`所在的代码块是一个独立的[作用域](/scope-of-variables-in-perl)。

## 函数的作用域

相同的代码，但这次是在函数里：

```perl
use strict;
use warnings;

sub f {
    my $x = 'this';
    my $z = rand();
    my $x = 'that';
}
f(1);
f(2);
```

这里也会产生一次针对`$x`的编译时警告。即使变量`$z`重复地在每次调用中出现也是没有问题的。变量`$z`不会触发警告，这是因为Perl可以两次创建同一个变量，只是你不应该这么做。不然，至少不能在同一个作用域里面这样做。

## for循环的作用域

同样的代码，循环中：

```perl
use strict;
use warnings;

for (1 .. 10) {
    my $x = 'this';
    my $z = rand();
    my $x = 'that';
}
```

这也会针对`$x`产生一次警告，对于`$z`则不会。

在这个代码中，<b>每次</b>迭代Perl都会为`$z`变量开辟内存。

## "my"有什么意义?

`my $x`的意思是告诉Perl，尤其是`strict`，你要在[当前作用域](/scope-of-variables-in-perl)使用一个私有变量<b>$x</b>。如果没有这个，Perl会在上层的作用域中寻找声明，如果没有找到的话会给出一个编译时错误[Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name)。代码块的每一项，每次调用函数，每个循环的迭代都是一个新的作用域。

另一方面，在同一个作用域中写两次`my $x`仅仅表示尝试着告诉Perl两遍相同的事情。这既无必要，也通常意味着出现了某个错误。

换句话说，我们之前得到的警告是与代码的<b>编译</b>相关的，代码并没有运行。这关系到开发者对变量的声明，而不是perl在运行时内存的分配。

## 如何清空已存在的变量？

如果我们不在同一作用域写两次`my $x;`，那如何把变量置“空”？

首先，如果变量在某个作用域内声明（在花括号内），那么出了[作用域](/scope-of-variables-in-perl)后它（变量）会自动消失。

如果你仅仅想“清空”当前作用域的标量，把它赋值成<hundef`就好了，如变量是[数组或hash表](https://perlmaven.com/undef-on-perl-arrays-and-hashes)，那么通过赋值成空列表就能清空：

```perl
$x = undef;
@a = ();
%h = ();
```

再说明一下。"my"会告诉perl你要使用一个变量。当执行到"my variable"时Perl会为变量本身以及它的内容分配空间；当执行到`$x = undef;`  或  `@x = ();`  或  `undef @x;`时，Perl会清空已有变量的内容。


