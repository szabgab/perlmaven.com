---
title: "Unknown warnings category"
timestamp: 2013-07-25T13:00:04
tags:
  - ;
  - warnings
  - unknown warnings
published: true
original: unknown-warnings-category
books:
  - beginner
author: szabgab
translator: spidamoo
---


Не думаю, что это сообщение об ошибке очень часто встречается. Во всяком случае, раньше я с ним не
сталкивался, но недавно это сбило меня с толку во время обучающего курса по Perl.


## Unknown warnings category '1'

Целиком сообщение об ошибке выглядит так:

```
Unknown warnings category '1' at hello_world.pl line 4
BEGIN failed--compilation aborted at hello_world.pl line 4.
Hello World
```

Это меня сильно раздосадовало, учитывая то, что код был совсем простым:

```
use strict;
use warnings

print "Hello World";
```

Я довольно долго смотрел на код и не видел в нем никаких проблем. Как вы могли заметить, он все-таки
выводит строку "Hello World".

Меня это сбило с толку, и я не сразу заметил то, что вы, возможно, уже увидели:

Проблема в пропущенной точке с запятой после выражения `use warnings`. Perl выполняет 
выражение print, оно выводит строку и возвращает 1, указывая на успешность выполнения.

Perl решает, что я написал `use warnings 1`.

Существует множество категорий предупреждений, но нет такой, которая называется "1".

## Unknown warnings category 'Foo'

Это другой случай той же проблемы.

Сообщение об ошибке выглядит так:

```
Unknown warnings category 'Foo' at hello.pl line 4
BEGIN failed--compilation aborted at hello.pl line 4.
```

и пример кода показывает, как работает интерполяция строк. Это второй пример в моем уроке, следующий
после "Hello World".

```perl
use strict;
use warnings

my $name = "Foo";
print "Hi $name\n";
```

## Пропущенная точка с запятой

Конечно, это просто частный случай все той же общей проблемы с пропущенной точкой с запятой. Perl
замечает это только на следующем выражении.

Обычно хорошей идеей будет проверить строчку перед той, о которой говорится в сообщении об ошибке.
Возможно, там пропущена точка с запятой.

