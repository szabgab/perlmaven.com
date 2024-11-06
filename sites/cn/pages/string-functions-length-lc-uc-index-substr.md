---
title: "字符串函数: length, lc, uc, index, substr"
timestamp: 2013-04-13T14:45:56
tags:
  - length
  - lc
  - uc
  - index
  - substr
  - scalar
published: true
original: string-functions-length-lc-uc-index-substr
books:
  - beginner
author: szabgab
translator: terrencehan
---


在这部分的[Perl教程](/perl-tutorial)中，我们会学习到几个操作字符串的函数。


## lc, uc, length

Perl中有不少用处处理字符串的简单函数，例如：<b>lc</b> 和 <b>uc</b> 能分别返回原始字符串的小写和大写形式；<b>length</b>可以返回给定字符串的字符个数。

看下面的例子:

```perl
use strict;
use warnings;
use 5.010;

my $str = 'HeLlo';

say lc $str;      # hello
say uc $str;      # HELLO
say length $str;  # 5
```


## index

<b>index</b> 函数会传入两个字符串参数，并且返回第二个字符串在第一个字符串中的位置。

```perl
use strict;
use warnings;
use 5.010;

my $str = "The black cat jumped from the green tree";

say index $str, 'cat';             # 10
say index $str, 'dog';             # -1
say index $str, "The";             # 0
say index $str, "the";             # 26
```

第一次调用 `index` 返回10，因为"cat"从第10个字符开始。
第二次调用 `index` 返回-1，表示句子中没有"dog"。

第三次调用 `index` 返回0， 因为第二个字符串是第一个字符串的前缀。

第四个例子表示 `index` 对大小写敏感。 "the" 与 "The" 不同。

`index()` 是搜索字符串而不仅是单词， 所以即便是"e "也可以查询:

```perl
say index $str, "e ";              # 2
```

`index()` 还可以传入第三个参数，用来说明从哪个位置开始搜索。如我们上例看到的，"e "出现在第一个string开头的第二个字符位置，然后我们可以从第三个地方开始搜索，看一下是否有另一个"e ":

```perl
say index $str, "e ";              # 2
say index $str, "e ", 3;           # 28
say index $str, "e", 3;            # 18
```

查询不带空格的"e"会得到另外一个结果。

最后，还有一个叫<b>rindex</b> (right index)的函数，它会从字符串的右侧开始搜索:

```perl
say rindex $str, "e";              # 39
say rindex $str, "e", 38;          # 38
say rindex $str, "e", 37;          # 33
```

## substr

它基本上是index()的反函数。index()能告诉你<b>给定的字符串在什么位置</b>，而substr会返回<b>给定位置的字符串</b>。 
通常`substr`会传入3个参数。第一个是字符串，第二个是从零开始计数的位置(也称为<b>偏移量</b>)，而第三个参数则是要获取的子串<b>长度</b>。

我认为在这篇文章中最有意思的函数就是`substr`。

```perl
use strict;
use warnings;
use 5.010;

my $str = "The black cat climbed the green tree";

say substr $str, 4, 5;                      # black
```

substr (位置计数)是从0开始的，所以偏移量为4的字符是'b'。

```perl
say substr $str, 4, -11;                    # black cat climbed the
```

第三个参数（长度）也可以是负数。 它指定了从原始字符串右边开始有多少个字符不包括在子串中。所以上面例子的意思是：返回从左边数4，右边数11，其中间的字符。

```perl
say substr $str, 14;                        # climbed the green tree
```

你也可以不使用第3个（长度）参数，这样的话就返回从第4个位置开始，一直到字符串结尾的所有字符。

```perl
say substr $str, -4;                        # tree
say substr $str, -4, 2;                     # tr
```

我们也可以用负数作为偏移量: 从右边数4个，并从第四个（包含）开始到结尾。等同于`length($str)-4`。

## 替换字符串的一部分

最后一个例子有些麻烦。
目前为止，每个例子中`substr`都返回子串并保持原来的字符串不变。而在这个例子中，substr的返回值不变，但是它会改变原来字符串的内容!

`substr()`的返回值总是取决于前3个参数，但是在这个例子中substr有第4个参数，它（第4个参数）用来替换从原字符串选出的子串。

```perl
my $z = substr $str, 14, 7, "jumped from";
say $z;                                                     # climbed
say $str;                  # The black cat jumped from the green tree
```

`substr $str, 14, 7, "jumped from"` 返回单词 <b>climbed</b>，并且因为有第4个参数，所以改变了原始字符串。
