---
title: "Perl变量的作用域"
timestamp: 2013-05-13T22:21:34
tags:
  - my
  - scope
published: true
original: scope-of-variables-in-perl
books:
  - beginner
author: szabgab
translator: terrencehan
---


Perl中有两个主要的变量类型。一种是包全局变量，它可以用`use vars`结构声明（这种方式已经过时）或者通过`our`声明。

另外一种通过`my`声明的词法变量。

来看一下当使用`my`声明变量时会发生什么？在代码的哪些部分这样的变量可见？换句话说，这些变量的<b>作用域</b>是什么？


## 变量作用域：闭合代码块

```perl
#!/usr/bin/perl
use strict;
use warnings;

{
    my $email = 'foo@bar.com';
    print "$email\n";     # foo@bar.com
}
# print $email;
# $email does not exists
# Global symbol "$email" requires explicit package name at ...
```

匿名代码块（一对花括号`{}`）内，首先我们看到的是新变量`$emial`的声明。从声明到代码块结束，在这段代码区间内变量是有效的。因此，闭合花括号`}`之后的代码行要注释掉。如果把`# print $email;`中的`#`去掉，再来运行脚本，你会得到如下编译错误[Global symbol "$email" requires explicit package name at ...](/global-symbol-requires-explicit-package-name)。

也就是说，<b>每个通过my声明的变量，其作用域是闭合代码块</b>。

## 变量作用域：在任何地方可见

变量`$lname`在代码开头声明。它对于到文件结尾的所有部分都是可见的，甚至是代码块和函数声明内部。如果我们在代码块内改变了变量的值，也会改变该变量在代码其它部分的值。即便离开了代码快，这种改变也是有效的：

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $lname = "Bar";
print "$lname\n";        # Bar

{
    print "$lname\n";    # Bar
    $lname = "Other";
    print "$lname\n";    # Other
}
print "$lname\n";        # Other
```


## 通过其它声明来隐藏变量

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $fname = "Foo";
print "$fname\n";        # Foo

{
    print "$fname\n";    # Foo

    my $fname  = "Other";
    print "$fname\n";    # Other
}
print "$fname\n";        # Foo
```

在这个例子里，变量`$fname`声明在代码开头。如前所述，<b>除了在那些使用同样名字声明局部变量的地方</b>，它会从声明处到文件结束的任何区域内都可见。

代码快中，使用`my`声明另一个同名变量。这样会把在外面声明的`$fname`阻隔起来，直到离开代码块。运行到代码块结束的地方（闭合`}`）时，在内部声明的`$fname`会被销毁，而原来的`$fname`又可见了。这种特性非常重要，它可以让你在小作用域中创建变量时不用顾及外部是否已经有同名变量。

## 多代码块，相同变量名

你可以无拘束地在不同代码块中使用相同变量名。这些变量互相之间是没有联系的。

```perl
#!/usr/bin/perl
use strict;
use warnings;

{
    my $name  = "Foo";
    print "$name\n";    # Foo
}
{
    my $name  = "Other";
    print "$name\n";    # Other
}
```

## in-file package declaration


这是一个稍微高级的例子，之所以在这里提，是因为它比较重要：

Perl允许通过`package`关键字在文件中切换<b>命名空间</b>。声明包<b>不会</b>新建作用域。如果在<b>main包</b>（脚本正文）中声明变量，`$fname`变量即便是在同一文件的其它命名空间也是可见的。

如果在'Other'命名空间声明变量`$lname`，在你之后切换回`main`命名空间时也是可见的。如果`Other包`是声明在其它文件，变量会因为文件的不同存在于另外一个作用域。

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $fname  = "Foo";
print "$fname\n";    # Foo

package Other;
use strict;
use warnings;

print "$fname\n";    # Foo
my $lname = 'Bar';
print "$lname\n";    # Bar


package main;

print "$fname\n";    # Foo
print "$lname\n";    # Bar
```


