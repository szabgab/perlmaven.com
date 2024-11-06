---
title: "字符串到数字的自动转换"
timestamp: 2013-01-10T10:45:57
tags:
  - is_number
  - looks_like_number
  - Scalar::Util
  - casting
  - type conversion
published: true
original: automatic-value-conversion-or-casting-in-perl
books:
  - beginner
author: szabgab
translator: swuecho
---


本节学习Perl中的类型转换


## Perl中的类型转换

在多数语言中，操作子的类型决定操作符的操作，比如， 两个数字相加，得到一个数字，两个字符串相加得到一个新的字符串。

Perl 中，恰好相反，操作符决定如果操作操作子。也就是说，如果你把两个值相加，如果这两个值不全是数值，这两个值先自动转换为数字，然后再相加。

C 语言中，如果把这个转换过程称为<b>casting</b> ，需要你来显式的转换，Perl中，Perl 自动为你完成。

Perl 中，至于某个值是数字还是字符串，Perl会根据上下文的需要（即操作符）进行转换。

数字转换到字符串再简单不过了，把数字放到引号中即可。

字符串到数字的转换就有些麻烦了。如果字符串仅有数字构成，去掉引号就好了。否则，
Perl尽可能多的从字符串的左边连续的取可以当作数字的值，知道遇到非数字字符为止。


我们来看几个具体的例子：

```
Original   As string   As number

  42         "42"        42
  0.3        "0.3"       0.3
 "42"        "42"        42
 "0.3"       "0.3"       0.3

 "4z"        "4z"        4        (*)
 "4z3"       "4z3"       4        (*)
 "0.3y9"     "0.3y9"     0.3      (*)
 "xyz"       "xyz"       0        (*)
 ""          ""          0        (*)
 "23\n"      "23\n"      23
```

以上例子中，因为字符串中的有些字符被舍弃，除了最后一个，Perl都会给出警告。当然，在你使用了 `use warnings` 的前提下。

## 例子

我们用代码来验证一下。
```perl
use strict;
use warnings;

my $x = "4T";
my $y = 3;

```

用作字符串的连接时，数字自动转换为字符串。

```perl
print $x . $y;    # 4T3
```

用作数字相加时，字符串自动转换为数字。
```perl
print $x + $y;  # 7  # Argument "4T" isn't numeric in addition (+) at ...
```

## 警告：参数不是数值

当Perl 把字符串转换为字符时，如果字符串中不完全是数字，即不是简单转换，Perl就会给出以上警告。

Perl 中常见的警告和错误还有很多，比如。
 [全局需要声明命名空间](/global-symbol-requires-explicit-package-name)
及[使用了未声明的变量](/use-of-uninitialized-value).

## 怎样判断一个变量是不是数字？

Perl 中，并没有 <b>is_number</b> 函数，来告诉你一个变量是不是由数字构成，但是
你可一用<b>looks_like_number</b>函数来实现此功能。

该函数在[Scalar::Util](http://perldoc.perl.org/Scalar/Util.html) 模块中。
用法参考如下例子。
```perl
use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

print "How many loaves of bread shall I buy? ";
my $loaves = <STDIN>;
chomp $loaves;

if (looks_like_number($loaves)) {
    print "I am on it...\n";
} else {
    print "Sorry, I don't get it\n";
}
```






