---
title: "使用Moose的面向对象编程"
timestamp: 2013-05-11T14:11:26
tags:
  - OOP
  - Moose
  - object oriented
  - class
  - object
  - instance
  - constructor
  - getter
  - setter
  - accessor
published: true
original: object-oriented-perl-using-moose
books:
  - advanced
author: szabgab
translator: terrencehan
---


在接下来几篇文章中，我们会学习到如何在Perl中写面向对象的代码。我们会从几个简单的例子开始并一步步扩展它们。开始的时候使用Moose，但是也会学习怎么用其他方法创建类。


## Moose的构造函数

开始，我们写了一个简单的脚本来使用Person`类`，而且仅仅是加载模块并调用`构造器`创建一个`实例`。

```perl
use strict;
use warnings;
use v5.10;

use Person;
my $teacher = Person->new;
```

保存在somedir/bin/app.pl

我确信你已经通过类似的方法使用过其它模块，所以这对你应该不新鲜。我们重点是Person类的实现：

```perl
package Person;
use Moose;

1;
```

就这样。

这些代码保存在somedir/lib/Perlson.pm。

为了创建一个`类`，你要做的是根据类名创建一个`pachage`，在包中调用`user Moose;`，在文件结尾放置一个真值，并将文件名保存成跟包名相同(大小写敏感)，且以 .pm 作为扩展名。

在加载Moose时就自动设置了`use strict` 和 `use warnings`。这样很方便，但是请注意不要在非Moose的代码中因为习惯而忘了写它们。

加载Moose时也自动加入了一个默认的构造器`new`。

旁注：在Perl中没有要求过构造器名字是new，只是大部分情况下模块的作者会这么写。

## 属性和访问器

得到一个空类没有任何意思。下面继续我们的例子：

```perl
use strict;
use warnings;
use v5.10;

use Person;
my $teacher = Person->new;

$teacher->name('Joe');
say $teacher->name;
```

在这个代码中，在创建`对象`之后，我们以一个字符串为参数调用"name"`方法`；这样就设置了类（应该是对象）的"name"`属性`为'Joe'。因为这个方法设置属性，所以也称为`setter`。

之后我们再一次调用相同的方法，但是这次没有参数。这样就会获取之前存的值。因为是取值，所以称为`getter`。

在我们的例子中`getter`和`setter`名字一样，但是这也不是必须的。

通常`getters`和`setters`统称为`accessors`。

新类的实现如下：

```perl
package Person;
use Moose;

has 'name' => (is => 'rw');

1;
```

新的部分`has 'name' => (is => 'rw');`的意思是：

"类Person`有has`一个属性`'name'`，这个属性`是is``可读r``可写w`的。"

这样自动创建了一个名字是"name"的方法，它既是setter也是getter。

## Try the code

为了试用代码，需要新建一个文件夹"somedir"，及其子文件夹"lib"和"bin"。Person.pm文件置"lib"中，而脚本person.pl放在"bin"中。

你应该已经有：

```
somedir/lib/Person.pm
somedir/bin/person.pl
```

打开终端（或者Windows的命令提示符窗口），切换目录到"somedir"，并输入`perl -Ilib bin/person.pl`。

（在Windows系统上你需要使用反斜线: \）

## 构造器参数

在下面的脚本中，我们向构造器传入一个键值对（对应的是属性名字和它的值）。

```perl
use strict;
use warnings;
use v5.10;

use Person;

my $teacher = Person->new( name => 'Joe' );
say $teacher->name;
```

配合着已有的模块，这么写也可有效：

使用构造器设置属性的初始化值的方法不需要对Person本身做任何改变。

Moose会在构造对象的时候自动接收每个`成员`（属性的另外一种称法）。


