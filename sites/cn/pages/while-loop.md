---
title: "while循环"
timestamp: 2013-04-29T12:45:51
tags:
  - while
  - while (1)
  - loop
  - infinite loop
  - last
published: true
original: while-loop
books:
  - beginner
author: szabgab
translator: herolee
---


在[Perl教程](/perl-tutorial)本小节，我们来看看<b>Perl里的while循环怎么工作</b>。


```perl
use strict;
use warnings;
use 5.010;

my $counter = 10;

while ($counter > 0) {
  say $counter;
  $counter -= 2;
}
say 'done';
```

`while`循环有个条件判断，本例中是检查变量$counter是否大于0，然后执行大括号里包含的代码段。

当while循环首次开始执行时，它检查条件是<a href="/boolean-values-in-perl">真或假。
如果是`假`，代码块就会被跳过，并执行下一条语句，我们这里是打印出'done'。

如果`while`的条件是`真`，代码块将会执行，之后重新回到条件判断并再次评估条件。
如果条件为假，代码块被跳过并打印'done'。如果条件为真，代码块被执行然后重新回到条件判断……

只要条件为真，这就一直执行下去就像英语语句：

`while (条件为真) { 做某事 }`

## 无限循环

在上面的代码里，我们一直减少变量，所以最终条件会变成假。
但由于某种原因，条件永远不可能为假，你就碰到了`无限循环`。你的程序会陷入一个很小的代码块并永远走不出来。

比如我们忘记了减少变量`$counter`，或者我们在增加它的同时却依然去检查一个很小的边界。

如果这只是失误引起，那它就是个缺陷。

另外，有时<b>故意</b>使用无限循环可以让我们的程序写起来更简单易读。我们喜欢可读性强的代码！
如果我们相使用无限循环，我们可以使用一个永远为真的条件。

因此我们可以写：

```perl
while (42) {
  # here we do something
}
```

当然，你如果缺少
[必要的文化背景](http://en.wikipedia.org/wiki/Answer_to_Life,_the_Universe,_and_Everything#Answer_to_the_Ultimate_Question_of_Life.2C_the_Universe.2C_and_Everything_.2842.29)
可能会疑惑,为啥经常使用42。虽然枯燥的方式是在无限循环里总是使用数字1。

```perl
while (1) {
  # here we do something
}
```

很自然，看起来这段代码永远不可能跳出循环，你可能会疑惑不从外部终止的话，它怎么能执行结束？

这有很多办法。
其中之一是在while循环里使用`last`声明。
这会跳出剩下的代码块而且不去重新检查条件。
人们也通常通过加入某种条件判断，有效地终止循环。

```perl
use strict;
use warnings;
use 5.010;

while (1) {
  print "Which programming language are you learning now? ";
  my $name = <STDIN>;
  chomp $name;
  if ($name eq 'Perl') {
    last;
  }
  say 'Wrong! Try again!';
}
say 'done';
```

这个例子中，我们问用户一个问题并希望他使用正确的大小写来回答。如果没有输入'Perl'，他将永远被这个问题绊住。
所以，对话可能像这样进行：

```
Which programming language are you learning now?
>  Java
Wrong! Try again!
Which programming language are you learning now?
>  PHP
Wrong! Try again!
Which programming language are you learning now?
>  Perl
done
```

如你所见，一旦用户输入正确的答案，`last`将会被调用，剩下的代码块包括`say 'Wrong! Try again!';`将会被跳过，程序会跳过
`while循环`继续执行。

