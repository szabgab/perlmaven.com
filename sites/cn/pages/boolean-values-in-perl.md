---
title: "Perl中的布尔值"
timestamp: 2013-04-21T16:51:56
tags:
  - undef
  - true
  - false
  - boolean
published: true
original: boolean-values-in-perl
books:
  - beginner
author: szabgab
translator: terrencehan
---


Perl 目前没有具体的布尔类型，但在Perl的文档中，你经常会看到某函数返回一个"布尔"值，有时文档中会写“函数返回true或者false”.

那么，事实如何？


Perl没有具体的布尔类型, 但是每个标量 -- 如果使用<b>if</b>来检查，都会返回true 或 false之一. 所以你可以这么写:

```perl
if ($x eq "foo") {
}
```

你也可以写：

```perl
if ($x) {
}
```

前者会判断 <b>$x</b> 变量的内容是否与"foo"字符串相等，而后者则判断 $x 本身是 true 还是 false。

## Perl中的哪些值是true和false？

这很简单, 引用文档:

<pre>
数字0, 字符串'0' 及 '', 空列表"()", 以及 "undef"在布尔上下文中都是false, 其它值为true.
使用 "!" 或 "not" 否定一个真值，会返回一个特定的假值. 当作为字符串计算时，把它看成'', 但是作为数字时, 它是0.

引用perlsyn文档的"Truth and Falsehood"一节.
</pre>

所以，以下标量被认定为false:

* undef - 未定义值
* 0    数字0, 即便你写的是000或0.0
* ''   空字符串.
* '0'  包含单个0数字的字符串.

其它所有的标量(包括下面的)是true:

* 1     任何非0数字
* ' '   有一个空格的字符串
* '00'   两个及以上'0'字符的字符串
* "0\n"  0及后面跟有一个换行符
* 'true'
* 'false'   没错, 即便是字符串'false'也被认定为是true.

我想这大概是因为Perl的创始人 [Larry Wall](http://www.wall.org/~larry/) 有着一个积极的世界观.
他可能认为, 世上坏的和假的事情是很少的, 大多数事情都是真的.
