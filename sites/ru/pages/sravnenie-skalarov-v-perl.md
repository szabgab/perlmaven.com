---
title: "Сравнение скаляров в Perl"
timestamp: 2013-10-14T12:00:01
tags:
  - eq
  - ne
  - lt
  - gt
  - le
  - ge
  - "=="
  - "!="
  - "<"
  - ">"
  - "<="
  - ">="
published: true
original: comparing-scalars-in-perl
books:
  - beginner
author: szabgab
translator: spidamoo
---


В предыдущей части [Учебника Perl](/perl-tutorial) мы познакомились со 
[скалярами](/scalarnye-peremennye) и узнали, как числа и строки конвертируются друг в 
друга на лету. Мы даже мельком взглянули на условное выражение <b>if</b>, но пока что не узнали, как
сравнить два скаляра. Об этом пойдет речь в этой части.


Если у нас есть две переменные $x и $y, можно ли их сравнить? Равны ли 1, 1.0 и 1.00? А как насчет
"1.00"? Что больше - "foo" или "bar"?

## Два набора операторов сравнения

В Perl существует два набора операторов сравнения. Так же, как с уже изученными нами бинарными 
операторами сложения (+), конкатенации (.) и повторения (x), здесь тоже оператор определяет, как 
ведут себя операнды и как они сравниваются.

Вот эти два набора операторов:

```
Числовое   Строковое       Значение
==            eq           равно
!=            ne           не равно
<             lt           меньше
>             gt           больше
<=            le           меньше или равно
>=            ge           больше или равно
```

Операторы слева сравнивают числовые значения, а справа (в средней колонке) сравнивают значения, 
основываясь на ASCII таблице или на текущей локали.

Рассмотрим несколько примеров:

```perl
use strict;
use warnings;
use 5.010;

if ( 12.0 == 12 ) {
  say "TRUE";
} else {
  say "FALSE";
}
```

В этом простейшем случае Perl выведет TRUE, так как оператор `==` сравнивает два числа, так
что Perl'у не важно, записаны ли они как целые числа, или как числа с плавающей точкой.

В следующем сравнении ситуация немного интереснее

```
"12.0" == 12
```

это выражение также истинно, ведь оператор Perl'а `==` конвертирует строку в число.

```
 2  < 3  истинно, так как < сравнивает два числа.

 2  lt 3 также истинно, ведь 2 находистя перед 3 в таблице ASCII.

12 > 3   очевидно, истинно.

12 gt 3  вернет FALSE
```

Возможно, с первого взгляда кому-то это покажется неожиданным, но если подумать, Perl ведь 
сравнивает строки посимвольно. Так что он сравнивает "1" и "3", и раз они отличаются и "1" стоит 
перед "3" в таблице ASCII, на этом этапе Perl решает, строковое значение 12 меньше, чем строковое
значение 3.

Всегда нужно быть уверенным, что сравниваешь значение именно так, как нужно!

```
"foo"  == "bar" будет истинно
```

Также это выдаст предупреждение, если(!) предупреждения включены с помощью `use warnings`.
Причина его в том, что мы используем две строки как числа в числовом сравнении ==. Как упоминалось
в предыдущей части, Perl смотрит на строку, начиная с левого конца, и конвертирует ее в число, 
которое там находит. Поскольку обе строки начинаются с букв, они будут конвертированы в 0. 0 == 0, 
так что выражение истинно.

С другой стороны:

```
"foo"  eq "bar"  ложно
```

Так что всегда нужно быть уверенным, что сравниваешь значение именно так, как нужно!

То же будет при сравнении

```
"foo"  == "" будет истинно
```

и

```
"foo"  eq "" будет ложно
```

Результаты в этой таблице могут пригодиться:

```
 12.0   == 12    ИСТИНА
"12.0"  == 12    ИСТИНА
"12.0"  eq 12    ЛОЖЬ
  2     <   3    ИСТИНА
  2    lt   3    ИСТИНА
 12     >   3    ИСТИНА
 12    gt   3    ЛОЖЬ ! (внимание, может быть неочевидно с первого взгляда)
"foo"  ==  ""    ИСТИНА  ! (Выдает предупреждение, если использована прагма "warnings")
"foo"  eq  ""    ЛОЖЬ
"foo"  == "bar"  ИСТИНА  ! (Выдает предупреждение, если использована прагма "warnings")
"foo"  eq "bar"  ЛОЖЬ
```

И наконец пример, когда можно попасть в ловушку, получив некоторые данные от пользователя, и,
аккуратно отрезав перевод строки в конце, проверить, не является ли строка пустой.

```perl
use strict;
use warnings;
use 5.010;

print "input: ";
my $name = <STDIN>;
chomp $name;

if ( $name == "" ) {   # неверно! здесь нужно использовать eq вместо == !
  say "TRUE";
} else {
  say "FALSE";
}
```

Если запустить этот скрипт и ввести "abc", мы получим ответ TRUE, так как perl решил, что "abc" это
то же, что и пустая строка.

