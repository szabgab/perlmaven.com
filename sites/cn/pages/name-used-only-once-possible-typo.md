---
title: "Name 'main::x' used only once: possible typo at ..."
timestamp: 2013-06-02T21:17:32
tags:
  - warnings
  - strict
  - possible typo
published: true
original: name-used-only-once-possible-typo
books:
  - beginner
author: szabgab
translator: terrencehan
---


如果在Perl脚本中看到这样的警告信息，你可能有大麻烦了。


## 变量赋值

给某个变量赋值但是从来没有用它，或者变量之只用一次但没有给它赋值，这一般表示在代码中隐含某个错误。

大概唯一“合理”的解释就是输入错。

这有个例子就是<b>只对变量赋值</b>：

```perl
use warnings;

$x = 42;
```

会产生如下警告：

```
Name "main::x" used only once: possible typo at ...
```

你可能会对"main::"部分没有$符号感到奇怪。这是因为Perl的变量默认是在"main"命名空间下。
或许有好多东西都称为"main::x"，但是只有一个在将$作为前导符号。如果这听起来很迷惑人，不要担心。
因为它本来就很复杂，幸运的是你不需要总是处理这样的问题。

## 只取值

如果你<b>只使用某个变量一次</b>

```perl
use warnings;

print $x;
```

那么会得到两条错误信息：

```
Name "main::x" used only once: possible typo at ...
Use of uninitialized value $x in print at ...
```

其中之一是我们正在讨论的，而另一个将会在[使用未初始化的值](/use-of-uninitialized-value)中讨论。


## 有什么输入错误？

你可能会这么问。

设想一下，有人使用了一个变量`$l1`，之后你要使用同一个变量，但是你却输入了`$ll`。可能是因为在你的字体中它们看起来很像。

或者变量是`$color`，但你是英国人，你可能自然而然地在考虑同一个东西的时候输入`$colour`。

再或者有个变量是`$number_of_misstakes`，而你没有注意到原来的变量就有输入错误，然后你输入了`$number_of_mistakes`。

理解了吧。

如果幸运的话，你可能只犯一次错误，不过如果你倒霉地使用了两次错误的变量，这样的警告就不会出现了。毕竟你两次使用了同一个变量两次，可能有个好的理由。

那么如果避免呢？

尽可能不要使用有歧义的字母，并且在输入变量名字的时候尽量小心一点。

如果想真正的解决这个问题，你可以使用<b>use strict</b>！

## use strict

上面的例子中你发现我没有使用strict。如果用的话，就不会有可能输入错误的警告，取而代之的是编译时错误：[Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name)。

即便你多次使用错误的变量也会出现这样的提示。

当然，看到错误后有些人会匆忙地在错误的变量前面加上"my"，但你不会这么做，对么？正确的做法是好好思考问题，直到搜索到真正的变量。

如果没有使用strict通常会看到这个警告。

然后你就陷入了麻烦之中。

## Other cases while using strict

GlitchMr和一位匿名用户在评论还另外举了几个例子：

下面的代码也会产生警告。

```perl
use strict;
use warnings;

$main::x = 23;
```

警告信息是：<b>Name "main::x" used only once: possible typo ...</b>

'main'和下面例子中的Mister是哪来的应该很清楚。（提示：它是包名，这里没有[关于包名的错误](/global-symbol-requires-explicit-package-name)）在下个例子中包名是'Mister'。

```perl
use strict;
use warnings;

$Mister::x = 23;
```

警告是 <b>Name "Mister::x" used only once: possible typo ...</b>.

下面的例子会产生两条警告信息：

```perl
use strict;
use warnings;

use List::Util qw/reduce/;
print reduce { $a * $b } 1..6;
```

```
Name "main::a" used only once: possible typo at ...
Name "main::b" used only once: possible typo at ...
```

[Perl Monks](http://www.perlmonks.org/?node_id=1021888) might know.
这是因为`$a` 和 `$b`在内建的排序函数中是特殊变量，所以你可以不用声明，
但此处你只使用了一次。（事实上，对于这里为什么会产生警告信息我也不是很清楚，同样的代码
在<b>sort</b>函数中就不会有问题，请参阅[Perl Monks](http://www.perlmonks.org/?node_id=1021888)。）

