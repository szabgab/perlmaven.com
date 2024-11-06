---
title: "Moose的属性类型"
timestamp: 2013-02-26T06:13:11
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
  - attribute
published: true
original: attribute-types-in-perl-classes-when-using-moose
books:
  - advanced
author: szabgab
translator: terrencehan
---


对于一个简单的Perl脚本, 我们通常并不关心值的类型。不过，随着程序规模的增长, 类型系统却能提升程序的正确性。

Moose可以让你给每个属性定义一个类型并且可以通过设定函数来强制转换。


通过 [introduction to Object Oriented Perl with Moose](/object-oriented-perl-using-moose)，你应该大致的熟悉了Moose的类型检查系统。

## 设定类型为Int

第一个例子:

```perl
use strict;
use warnings;
use v5.10;

use Person;

my $student = Person->new( name => 'Joe' );
$student->year(1988);
say $student->year;
$student->year('23 years ago');
```

加载Person模块(类), 我们通过调用类的构造器"new"来创建对象$student。之后调用访问器"year", 设值为1998。在打印完后尝试将它设为"23 years ago"。

在模块中我们能看到有两个属性。 "year"属性有一个值是`Int`的`isa`项。因此, Moose的设置器把它的值限定为整型。

```perl
package Person;
use Moose;

has 'name' => (is => 'rw');
has 'year' => (isa => 'Int', is => 'rw');

1;
```

将模块保存在"somedir/lib/Person.pm"，脚本保存在"somedir/bin/app.pl" 然后在somedir文件夹下通过"perl -Ilib bin/app.pl"执行脚本

打印完值1988之后, 我们得到如下错误提示:

```
Attribute (year) does not pass the type constraint because:
   Validation failed for 'Int' with value "23 years ago"
       at accessor Person::year (defined at lib/Person.pm line 5) line 4
   Person::year('Person=HASH(0x19a4120)', '23 years ago')
       called at script/person.pl line 13
```

错误信息显示:Moose不能接受"23 years ago"作为一个整数。

## 用其它类作为类型限制

除了 [默认类型限制](https://metacpan.org/pod/Moose::Util::TypeConstraints#Default-Type-Constraints), Moose也允许你使用任何已有的类名作为类型限定。

例如我们声明"birthday"属性是一个DateTime对象。

```perl
package Person;
use Moose;

has 'name'     => (is => 'rw');
has 'birthday' => (isa => 'DateTime', is => 'rw');

1;
```

脚本:

```perl
use strict;
use warnings;
use v5.10;

use Person;
use DateTime;

my $student = Person->new( name => 'Joe' );
$student->birthday( DateTime->new( year => 1988, month => 4, day => 17) );
say $student->birthday;
$student->birthday(1988);
```

可以看到, 第一次对"birthday"设置器的调用, 以DateTime对象作为参数。这样的调用没有问题。第二次调用使用了数字参数1998, 则抛出了和之前类似的异常:

```
Attribute (birthday) does not pass the type constraint because:
    Validation failed for 'DateTime' with value 1988
       at accessor Person::birthday (defined at lib/Person.pm line 5) line 4
    Person::birthday('Person=HASH(0x2143928)', 1988)
       called at script/person.pl line 14
```

