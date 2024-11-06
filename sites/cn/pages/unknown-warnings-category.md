---
title: "未知警告类型"
timestamp: 2013-05-02T10:45:57
tags:
  - ;
  - warnings
  - unknown warnings
published: true
original: unknown-warnings-category
books:
  - beginner
author: szabgab
translator: herolee
---


我觉得这种错误信息在Perl里并不是经常遇到。至少我不记得此前见到过。
但在最近一个Perl培训课程中，它却给我上了一课。


## Unknown warnings category '1'

完整的错误信息类似下边这样：

```
Unknown warnings category '1' at hello_world.pl line 4
BEGIN failed--compilation aborted at hello_world.pl line 4.
Hello World
```

这个错误比较烦人，尤其是代码非常简单时：

```
use strict;
use warnings

print "Hello World";
```

我盯着这段代码看了很久，没发现任何问题。
如你所见，它已经打印出来了字符串"Hello World"。

它令我倍受挫折，花了我相当长的时间才发现问题，可能你已经发现了：

问题在于`use warnings`语句之后少了个分号。Perl执行打印语句，它打印出来字符串的同时，`print`函数返回1表明执行成功。

Perl就认为我写了`use warnings 1`。

警告类型有很多，但是没有一个叫做"1"。

## Unknown warnings category 'Foo'

这是同类问题的另一个例子。

错误信息类似：

```
Unknown warnings category 'Foo' at hello.pl line 4
BEGIN failed--compilation aborted at hello.pl line 4.
```

示例代码展示了字符串插值怎么工作。这是我在"Hello World"之后教的第二个例子。

```perl
use strict;
use warnings

my $name = "Foo";
print "Hi $name\n";
```

## 遗漏分号

当然，这只是由于遗漏分号引发的常见问题其中的特例。Perl只能在下一个语句处发现它。

通常检查一下错误信息提示行的上一行是个好办法。或许只是丢了个分号。
