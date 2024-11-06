---
title: "Perl里的函数和子例程"
timestamp: 2013-04-30T22:34:56
tags:
  - sub
  - return
  - subroutine
  - function
  - "@_"
  - "$_[0]"
published: true
original: subroutines-and-functions-in-perl
books:
  - beginner
author: szabgab
translator: herolee
---


最简单的办法重用代码就是构建子例程。

这使得你可以在应用中的多个地方执行同样的代码，也可以使用不同的参数执行代码。


在一些编程语言中，函数和子例程是有区别的。但在Perl里只有一个。
它通过 `sub`关键字创建，并通常返回一个值。
Perl程序员常常可交替地使用<b>function</b>和<b>subroutine</b>这两个词。

## 简单函数

例如，我们假设你想问用户一个问题：

```perl
ask_question();
my $answer = get_answer();
# some code
ask_question();
my $second_answer = get_answer();

########## 子函数在这里声明

sub ask_question {
  print "Have we arrived already?";
  return;
}

sub get_answer {
  my $answer = <STDIN>;
  chomp $answer;
  return $answer;
}

sub terminate {
   die "Hasta La Vista";
}
```

代码第一部分，我们调用函数`ask_question`两次，同时也两次调用函数`get_answer`。
代码第二部分，在井号注释之后，我们声明了三个子例程。

第一个很简单。它只是打印一个写死的字符串到屏幕并返回空。

第二个合并了行读取操作和`chomp`在一个函数调用中。
它将等待一些输入直到敲回车键后返回你键入的字符串，不包括末尾的新行符。

第三个同样很简单，但是它在代码中从未被调用，因此永不会被执行。
对不熟悉函数和子例程的人来说，这是一个要点。他们的代码无论写在文件中的何处，只有在以他们的名字<b>调用</b>时才会被执行。

除了最后一个例子，其它例子中我们都调用了Perl的`return`函数来返回一个值。
事实上，函数总会返回一些值即便我们没有显式地添加一个`return`调用。
不过我们仍然强烈建议总是调用`return`，即便我们没有什么需要返回的，就像`ask_question()`函数那样。

## prompt

把两个函数合并一起或许更有意义，你可以这样写：

```perl
my $answer = prompt();
# some code
my $second_answer = prompt();

sub prompt {
   print "Have we arrived already?";

   my $answer = <STDIN>;
   chomp $answer;
   return $answer;
}
```

当然，你可能想在每次调用`prompt()`函数时显示一些独特的文本。
比如你可能希望在调用`prompt()`函数时，能够设定提示文本。好比这样：

```perl
my $first_name = prompt("First name: ");
my $last_name = prompt("Last name: ");

sub prompt {
   my ($text) = @_;
   print $text;

   my $answer = <STDIN>;
   chomp $answer;
   return $answer;
}
```

这个例子中，我们两次调用了prompt()函数。
每一次我们传递了一个字符串用于提示我们将会问到的问题。首先打印该字符串，之后子例程获取输入并返回给调用者。

这个例子中的新奇之处在于我们传递参数的方式，以及子例程如何接收参数。

当你调用一个子例程时，你可以传递任意个数的参数给子例程，这些值会被存入内部变量`@_`。
这个变量仅属于当前的子例程。每个子例程有自己的`@_`。

你可以像访问其它数组的方式一样，访问其中的元素。`$_[0]`是它的第一个元素。不过这并不易读。

通常比较好的办法是使用列表赋值的办法把`@_`的值拷贝给内部变量。
这就是我们在上面例子中通过`my ($text) = @_;`实现的。

常见的错误是赋值时缺少了括号。

```perl
sub prompt {
   my $text = @_;    # BAD! this is not what you want!!!
   ...
}
```

这使数组处于标量的上下文中，此时它将返回数组的元素个数。因此$text变量将会是一个数字。
如果你对上下文还不清楚，你可以参阅
[标量和列表上下文](https://perlmaven.com/scalar-and-list-context-in-perl)之后，回到这里。

## 原型

某些语言允许甚至要求你在创建实际的子例程之前创建原型。

Perl不需要原型。

实际上Perl里也有个东西叫做原型，但是他们并非你期望的那样工作，我也不提倡使用。尤其是对初学者。

只有在极个别的情况下，Perl里用到这些原型。

## 参数或类型

Perl 5里你不需要也不能声明函数的<b>类型</b>。
也就是说，你不能指定一个所期望参数的列表。换句话说，语言不会为你做任何的参数检查。

CPAN上有些模块可以辅助创建定义了类型的函数，你可以试一试。

```perl
sub do_somethig() {    # BAD !
}
```

声明函数时，你不能在函数名之后写括号。即便你可以在调用函数时使用括号：

## 括号

如果函数已经被定义，则在调用函数时，函数名后使用括号`()`是可选的。
你需要明白自己的想法。

因此，如果你通过`use`声明加载了一个模块，它导入了一个函数，你可以在代码里调用它时，不使用括号。

另一方面，如果你在脚本最后定义了函数，我建议你在调用函数时加括号。

## 返回值

Perl函数总会返回一个值。
或是显式地调用`return`，或是隐式地返回最后一句的执行结果。
建议总是显式地调用`return`。

甚至有个[Perl::Critic](http://perlcritic.com/)规定会检查你的代码并指出每个没有显式地在函数声明的末尾调用return的函数。

如果没什么要返回的，可以只是调用`return;`，不加任何参数。
这可以确保你什么也没有返回，而不是隐式地返回最后一句的执行结果。这会使函数的使用者少遇到惊讶的事情。
