---
title: "Scalar found where operator expected"
timestamp: 2013-07-25T13:00:03
tags:
  - syntax error
  - scalar found
  - operator expected
published: true
original: scalar-found-where-operator-expected
books:
  - beginner
author: szabgab
translator: spidamoo
---


Это сообщение об ошибке встречается действительно часто. Однако понять его может быть довольно
сложно.

Дело в том, что люди знают о <b>числовых операторах</b> и <b>строковых операторах</b>, но не
рассматривают запятую (`,`) как оператор. Терминология сообщения об ошибке немного вводит их
в заблуждение.

Давайте рассмотрим пару примеров:


## Пропущенная запятая

Код выглядит так:

```perl
use strict;
use warnings;

print 42 "\n";
my $name = "Foo";
```

а сообщение об ошибке

```
String found where operator expected at ex.pl line 4, near "42 "\n""
      (Missing operator before  "\n"?)
syntax error at ex.pl line 4, near "42 "\n""
Execution of ex.pl aborted due to compilation errors.
```

Оно четко указывает местонахождение проблемы, но, как показывает опыт, многие люди торопятся открыть
свой редактор и исправить ошибку, толком не прочитав сообщение. Они вносят изменения в надежде, что
этим решат проблему, а в итоге получают еще одно сообщение об ошибке.

В данном случае проблема была в том, что мы забыли запятую (`,`) после числа 42. Эта строчка
должна выглядеть так: `print 42, "\n";`.


## String found where operator expected

В этом коде мы пропустили оператор конкатенации `.` и получили такое же сообщение об ошибке:

```perl
use strict;
use warnings;

my $name = "Foo"  "Bar";
```

```
String found where operator expected at ex.pl line 4, near ""Foo"  "Bar""
      (Missing operator before   "Bar"?)
syntax error at ex.pl line 54, near ""Foo"  "Bar""
Execution of ex.pl aborted due to compilation errors.
```

На самом деле код должен был выглядеть так: `my $name = "Foo" . "Bar";`.

## Number found where operator expected

Этот код
```perl
use strict;
use warnings;

my $x = 23;
my $z =  $x 19;
```

выдает такую ошибку:

```
Number found where operator expected at ex.pl line 5, near "$x 19"
  (Missing operator before 19?)
syntax error at ex.pl line 5, near "$x 19"
Execution of ex.pl aborted due to compilation errors.
```

Здесь, видимо, не хватает оператора сложения `+` или умножения `*`, ну или оператора
повтора `x`.

## Ошибка синтаксиса, когда не хватает запятой

Отсутствующая запятая не всегда понимается интерпретатором, как пропущенный оператор. Например, этот
код:

```perl
use strict;
use warnings;

my %h = (
  foo => 23
  bar => 19
);
```

Генерирует такую ошибку: <b>syntax error at ... line ..., near "bar"</b>, без дополнительных деталей.

Добавление запятой после числа 23 исправит код:

```perl
my %h = (
  foo => 23,
  bar => 19
);
```

Я предпочитаю добавлять запятую после каждой пары в хэше (то есть, в данном случае, после 19):

```perl
my %h = (
  foo => 23,
  bar => 19,
);
```

Эта привычка в большинстве случаев помогает избежать таких ошибок.


## Scalar found where operator expected at

```perl
use strict;
use warnings;

my $x = 23;
my $y = 19;

my $z =  $x $y;
```

```
Scalar found where operator expected at ... line 7, near "$x $y"
    (Missing operator before $y?)
syntax error at ... line 7, near "$x $y"
Execution of ... aborted due to compilation errors.
```

Опять же, между $x и $y может быть числовой или строковый оператор.

## Array found where operator expected

```perl
use strict;
use warnings;

my @x = (23);
my $z =  3 @x;
```

## С какими еще случаями вы часто сталкиваетесь?

Знаете ли вы другие интересные случаи, в которых мы получаем такую синтаксическую ошибку?


