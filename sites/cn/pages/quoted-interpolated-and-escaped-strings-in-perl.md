---
title: "字符串：引起，内插替换和转义"
timestamp: 2013-05-28T09:11:42
tags:
  - strings
  - escape character
  - interpolation
  - quote
  - embedded characters
  - q
  - qq
published: true
original: quoted-interpolated-and-escaped-strings-in-perl
books:
  - beginner
author: szabgab
translator: terrencehan
---


理解字符串是如何工作的在任何编程语言中都很重要，尤其在Perl中, 它们是语言的精髓。你或许听说过，Perl又称为<b>实用报表提取语言</b>, 理所当然要了解很多关于字符串的东西。


字符串可以放在单引号`'`或者双引号`"`之间，而这两种形式的行为是不同的。

## 单引号

如果把字符放在单引号`'`之间，除了单引号本身`'`之外的绝大多数字符会解释成和写在代码中一样的形式。

```perl
my $name = 'Foo';
print 'Hello $name, how are you?\n';
```

输出：

```
Hello $name, how are you?\n
```

## 双引号

放在双引号之间的字符串支持插入替换（内嵌在字符串中的变量会被替换成其内容），而且也会替换转义字符，例如用换行符替换`\n`，用tab替换`\t`。

```perl
my $name = 'Foo';
my $time  = "today";
print "Hello $name,\nhow are you $time?\n";
```

输出：

```
Hello Foo,
how are you today?

```

注意，有个`\n`跟在逗号后面, 另一个在字符串结尾。

对于像'Foo'和"today"这样没有`$`，`@`，及`\`的简单字符串，无所谓是用什么引起的。

下面的两行是一个结果：

```perl
$name = 'Foo';
$name = "Foo";
```


## email地址

因为在双引号字符串中`@`也会引起插入替换替换，在写email地址的时候需要格外注意。

在单引号中的`@`不会插入替换。

在双引号中则会产生错误
[Global symbol "@bar" requires explicit package name at ... line ...](/global-symbol-requires-explicit-package-name)
以及警告
<b>Possible unintended interpolation of @bar in string at ... line ...</b>。

后者给出了解决问题的线索。

```perl
use strict;
use warnings;
my $broken_email  = "foo@bar.com";
```

下面的代码把email地址放在单引号中就能正常工作。

```perl
use strict;
use warnings;
my $good_email  = 'foo@bar.com';
```

如果既需要插入替换标量，又要在字符串中使用`@`该怎么办呢？

```perl
use strict;
use warnings;
my $name = 'foo';
my $good_email  = "$name\@bar.com";

print $good_email; # foo@bar.com
```

每当遇到这种情况，你都可以<b>转义</b>特殊字符，本例中的at符号`@`就是使用反斜线`\`这个<b>转义字符</b>来进行转义的。

## 在双引号字符串中内嵌$符号

同样的，如果想要在双引号字符串中包含`$`符号也可以使用这个的方法转义：

```perl
use strict;
use warnings;
my $name = 'foo';
print "\$name = $name\n";
```

输出：

```
$name = foo
```

## 转义转义字符

其实只有少部分情况下你需要在字符串中包含反斜线。如果把反斜线`\`放在字符串里（无论是在单引号还是双引号中），Perl都会认为你想转义下一个字符。

不要担心。你可以转义转义字符来告诉Perl不要这么做：

你仅需在它之前再放一个反斜线：

```perl
use strict;
use warnings;
my $name = 'foo';
print "\\$name\n";:w
```

```
\foo
```

我知道这种转义转义字符的方式有些奇怪，但是这就是其他语言的工作方式。


如果你想了解整个转义的细节，这样做：

```perl
print "\\\\n\n\\n\n";
```

see what does that print:
看一下输出：

```
\\n
\n
```

然后自己解释一下。

## 转义双引号

我们了解了可以把标量放在双引号字符串中，而且可以转义`$`符号。

我们看到了如何使用转义字符`\`，也看到了如何转义它本身。

如果想要在双引号字符串中打印双引号该怎么办呢？


下面的代码有个语法错误：

```perl
use strict;
use warnings;
my $name = 'foo';
print "The "name" is "$name"\n";
```

当Perl看到单词"name"前面的双引号时，它认为字符串结束了，然后指出单词<b>name</b>是一个[裸字](/barewords-in-perl)。

你可能已经猜到了，我们需要转义内嵌的`"`字符：

```perl
use strict;
use warnings;
my $name = 'foo';
print "The \"name\" is \"$name\"\n";
```

This will print:
这会输出：

```
The "name" is "foo"
```

以上可以正常工作，但是阅读起来可能会有些困难。


## qq, 双q操作符

你可以使用`qq`也称双q操作符来解决问题：

```perl
use strict;
use warnings;
my $name = 'foo';
print qq(The "name" is "$name"\n);
```

如果之前没有了解过的话，可能会把qq()看成函数调用，其实不是。`qq`是一个操作符，很快你就会知道它还能做什么，不过这里先解释一下上面的代码。

我们使用`qq`操作符的括号来代替原来字符串外面的双引号`"`。这样双引号在字符串中就不再特殊，进而不需要对它们转义了。这样会增加可读性。如果我不畏惧Python程序员的批评的话，甚至可以说这么写很漂亮。

不过，如果要在字符串中包含括号呢？

```perl
use strict;
use warnings;
my $name = 'foo';
print qq(The (name) is "$name"\n);
```

没关系的。如果它们是平衡的（也就是会说起始`(`和闭合`)`括号数量相同，且起始括号总是在闭合括号前面）Perl会理解的。

如果你非要破坏这种平衡，把闭合括号放在起始括号前面：

```perl
use strict;
use warnings;
my $name = 'foo';
print qq(The )name( is "$name"\n);
```

这样Perl会报出"name"是[裸字](/barewords-in-perl)的语法错误。Perl也不是万能的，对么？

当然你也可以在字符串中转义括号`\)` 和 `\(`, 不过这样会有些冒险，还是不要这么做了。

肯定还有更好的方法！

你还记得我说过`qq`是操作符而不是函数么？还有小窍门，对么？

如果我们使用花括号`{}`来代替圆括号会怎样样呢？

```perl
use strict;
use warnings;
my $name = 'foo';
print qq{The )name( is "$name"\n};
```

这也有效，并且按照我们想要的方式输出字符串：

```
The )name( is "foo"
```

（即使我不知道为什么我想这么打印...）

然后[第二行的朋友](http://perl.plover.com/yak/presentation/samples/slide027.html)举手提问：如果你想要在字符串中同时包含圆括号和花括号，<b>并且</b>它们并不配对怎么办？

你说的是这样对么？

```perl
use strict;
use warnings;
my $name = 'foo';
print qq[The )name} is "$name"\n];
```

printing this:
输出：

```
The )name} is "foo"
```


... 当然也有使用方括号的情况，对么？


## q, 单q操作符

还有一个与`qq`相似的操作符`q`。它也允许你自定义字符串分隔符，不过它的工作方式和单引号`'`相同：<b>不能</b>插入替换变量。

```perl
use strict;
use warnings;
print q[The )name} is "$name"\n];
```

打印：

```
The )name} is "$name"\n
```


