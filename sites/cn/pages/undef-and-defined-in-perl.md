---
title: "undef, 初始值及Perl函数"
timestamp: 2013-01-31T08:45:57
tags:
  - undef
  - defined
published: true
original: undef-and-defined-in-perl
books:
  - beginner
author: szabgab
translator: terrencehan
---


在许多编程语言中, 都会有特殊的方法来表示“该字段没有值”。
<b>SQL</b>, <b>PHP</b> 和 <b>Java</b> 使用`NULL`，<b>Python</b> 中是`None`，
<b>Ruby</b> 中则是 `Nil`。

而在Perl的世界中，这个值称为`undef`。

来看下细节。


## 哪里可以得到undef？

当你声明一个标量，却没有赋值时，它会被定义成`undef`。

```perl
my $x;
```

有些函数用返回 `undef` 来表示执行失败了, 其它函数则会在没有可返回值时返回undef。

```perl
my $x = do_something();
```

你可以使用 `undef()` 函数把一个变量重置为 `undef`:

```perl
# some code
undef $x;
```

甚至你也可以使用 `undef()` 的返回值来把一个变量设置为`undef`:

```perl
$x = undef;
```

函数名后面的括号是可选的，所以我在这例子中省略了它们。

如你看到的这样，有很多方法可以把一个标量设置为<b>undef</b>。
接下来的问题是：如果你使用这样一个变量会怎么样？

在此之前，先看一下其他的东西:

## 如何检查一个变量的值是否为undef?

如果给定的值<b>不是undef</b>, `defined()`函数会返回 [true](/boolean-values-in-perl) 。
如果给定值是<b>undef</b>则返回[false](/boolean-values-in-perl) 。

你也可以这么用：

```perl
use strict;
use warnings;
use 5.010;

my $x;

# 这里的某些代码可能会给$x赋值

if (defined $x) {
    say '$x is defined';
} else {
    say '$x is undef';
}
```


## undef的真实值是什么?

因为 <b>undef</b> 表示缺失一个值, 它仍是不可用的。
除此之外，Perl还提供了两个可用的默认值。

如果你在数值操作中使用 undef , 它效果上看起来和0一样。

如果它是用在字符串操作中, 则基本等同于空字符串。

看下面的例子:

```perl
use strict;
use warnings;
use 5.010;

my $x;
say $x + 4, ;  # 4
say 'Foo' . $x . 'Bar' ;  # FooBar

$x++;
say $x; # 1
```

在上面的例子中，变量 $x (默认是 undef )，在加法运算中起的作用是0, 在字符串连接过程中表现为空串，而在自增操作中又表现为0。

它也并不是完美的。如果你通过 `use warnings` 语句开启警告([推荐使用](/installing-perl-and-getting-started)), 
那么你将在前两个操作中得到 [use of unitialized value](/use-of-uninitialized-value) 警告，但是自增操作却不会。

```
Use of uninitialized value $x in addition (+) at ... line 6.
Use of uninitialized value $x in concatenation (.) or string at ... line 7.
```

如果你现在不知道Perl的自增操作也没关系，后面我们会看到, 它在处理计数操作的时候有多么方便。

当然，你可以通过给变量初始化成正确的数值(根据你的需要赋值0或空串)来避免警告, 或者选择性的关闭警告。
我们将在另外单独的文章中讨论这些。
