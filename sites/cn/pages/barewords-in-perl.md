---
title: "Perl的裸字"
timestamp: 2013-05-26T18:21:56
tags:
  - bareword
  - strict
published: true
original: barewords-in-perl
books:
  - beginner
author: szabgab
translator: terrencehan
---


`use strict`包含3个部分。其中之一（`use strict "subs"`）负责禁止乱用的<b>裸字</b>。

这是什么意思呢？


如果没有这个限制，下面的代码也可以打印出"hello"。

```perl
my $x = hello;
print "$x\n";    # hello
```

这样使用不符合我们平常把字符串放在引号里的习惯，但是Perl默认是允许（使用）<b>裸字</b>——没有引号的单词——来作为字符串。

上面的代码输出"hello"。

当然至少在脚本顶部默认添加"hello"函数之前（是这样）：

```perl
sub hello {
  return "zzz";
}

my $x = hello;
print "$x\n";    # zzz
```

在新版本中，Perl看到了hello()函数，调用它（函数）并将结果赋值给$x。

之后，如果有人将这个函数放在文件的结尾（赋值之后），Perl在赋值的时候就看不到函数，又回到老样子了：把"hello"赋给$x。

是的，你肯定不想自己陷入麻烦。那么请在代码中使用`use strict`来禁止裸字<b>hello</b>出现在代码中，从而避免困惑。

```perl
use strict;

my $x = hello;
print "$x\n";
```

会给出如下错误：

```
Bareword "hello" not allowed while "strict subs" in use at script.pl line 3.
Execution of script.pl aborted due to compilation errors.
```

## 裸字的正确使用

即便开启了<b>use strict "subs"</b>还是有些地方可以使用裸字。

首先，用户自定义的函数名就是裸字。

同样，在提取哈希表元素花括号里也使用了裸字，以及胖箭头=>的左边也可以没有引号。

```perl
use strict;
use warnings;

my %h = ( name => 'Foo' );

print $h{name}, "\n";
```

上面代码中的"name"都是裸字，它们在use strict的时候也是有效的。

