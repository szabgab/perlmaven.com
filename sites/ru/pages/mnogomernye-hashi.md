---
title: "Многомерные хеши в Perl"
timestamp: 2014-03-24T10:25:01
tags:
  - hash
  - Data::Dumper
published: true
original: multi-dimensional-hashes
books:
  - beginner
author: szabgab
translator: name2rnd
---


Каждое значение в хеше в Perl может быть ссылкой на другой хеш.
Если делать все правильно, то можно сделать двумерные или многомерные хеши.


Посмотрим несколько примеров:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my %grades;
$grades{"Foo Bar"}{Mathematics}   = 97;
$grades{"Foo Bar"}{Literature}    = 67;
$grades{"Peti Bar"}{Literature}   = 88;
$grades{"Peti Bar"}{Mathematics}  = 82;
$grades{"Peti Bar"}{Art}          = 99;

print Dumper \%grades;
print "----------------\n";

foreach my $name (sort keys %grades) {
    foreach my $subject (keys %{ $grades{$name} }) {
        print "$name, $subject: $grades{$name}{$subject}\n";
    }
}
```

Запустив скрипт, получим следующее:

```
$VAR1 = {
          'Peti Bar' => {
                          'Mathematics' => 82,
                          'Art' => 99,
                          'Literature' => 88
                        },
          'Foo Bar' => {
                         'Mathematics' => 97,
                         'Literature' => 67
                       }
        };
----------------
Foo Bar, Mathematics: 97
Foo Bar, Literature: 67
Peti Bar, Mathematics: 82
Peti Bar, Art: 99
Peti Bar, Literature: 88
```

Сначала мы напечатали весь хеш, а потом через разделительную линию прошлись
по структуре вручную, чтобы посмотреть, как осуществляется доступ к элементам.
Если вы не очень хорошо знакомы с функцией Dumper из Data::Dumper, то `$VAR1`
обозначает начало вывода. Не волнуйтесь об этом.

Важно то, что входной параметр функции `Dumper` это ссылка на структуру данных, и поэтому мы поставили 
обратный слеш `\` перед `%grades` (сделали ссылку).

Порядок ключей в хеше произвольный.

## Объяснение

Посмотрим на детали.

Мы создали хеш с названием `%grades`. Это простой одномерный хеш, который содержит
пары ключ-значение. Ничего особенного.

Следующая строка: `$grades{"Foo Bar"}{Mathematics}   = 97;`

Здесь создается пара ключ-значение в хеше `%grades`, где ключом является
`Foo Bar`, а значением ссылка на другой, вложенный хеш.
И этот вложенный хеш не имеет имени. Единственный способ получить к нему доступ - через ссылку в хеше `%grades`.
Здесь создается одна пара ключ-значение, где ключ `Mathematics` и значение `97`.

В отличие от Python в Perl создание внутреннего хеша автоматическое и это поведение называют обычно 
[autovivification](https://perlmaven.com/autovivification).

Если вы используете Data::Dumper для вывода содержимого `%grades` сразу 
после первого присвоения значения, то получите такой результат:

```
$VAR1 = {
          'Foo Bar' => {
                         'Mathematics' => 97
                       }
        };
```

Здесь внешняя пара фигурных скобок описывает `%grades`, в то время как 
внутренняя пара скобок другой хеш - вложенный.

## Создаем третий хеш

Код ниже содержит три присваивания, запустите его:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my %grades;
$grades{"Foo Bar"}{Mathematics}   = 97;
$grades{"Foo Bar"}{Literature}    = 67;
$grades{"Peti Bar"}{Literature}   = 88;

print Dumper \%grades;
```

и получите это:

```
$VAR1 = {
          'Peti Bar' => {
                          'Literature' => 88
                        },
          'Foo Bar' => {
                         'Literature' => 67,
                         'Mathematics' => 97
                       }
        };
```

Здесь вы увидите одну внешнуюю пару фигурных скобок и две внутренних пары. Таким образом, 
у нас получилось три разных хеша.

Полученных хеши не "сбалансированные" и не "симметричные". Каждый хеш содержит свои 
собственные ключи и значения. В хешах могут быть и одинаковые ключи.

## Обход хеша вручную

Data::Dumper очень удобный способ отладки, но для вывода значений пользователю он не подходит.
Посмотрим, как мы можем пройти по всем значениям двумерного хеша.

Команда `keys %grades` вернет все ключи `%grades`, то есть: "Peti Bar" и
"Foo Bar" в произвольном порядке. Команда `sort keys %grades` вернет ключи отсортированными.

Таким образом, если использовать цикл `foreach`, то `$name` будет содержать
"Peti Bar" или "Foo Bar".

Если выведем соответствующие ключам значения из `%grades` вот таким образом:

```perl
foreach my $name (sort keys %grades) {
    print "$grades{$name}\n";
}
```

то получим вот это:

```
HASH(0x7f8e42003468)
HASH(0x7f8e42802c20)
```

Это "дружественное" представление ссылок на "внутренние" хеши.

Разыменуем их с помощью `%{ }` вот так:

`%{ $grades{$name} }`

Если вызвать функцию `keys`, передав ей в качестве аргумента это выражение,
то получим список ключей внутреннего хеша.
Для `$name` "Peti Bar" мы получим 'Mathematics', 'Art', and 'Literature'.
Для "Foo Bar" получим только 'Mathematics' и 'Literature'.

С помощью переменной `$subject` и вложенного цикла `foreach` мы 
получим доступ к вложенным хешам, используя такую конструкцию `$grades{$name}{$subject}` 
для получения оценок всех студентов.

## Меньше, чем два измерения

В этом примере мы рассмотрели двумерный хеш, но Perl не имеет особых требований и ограничений на этот счет,
поэтому мы можем добавить еще значение в наш `%grades`, которое не будет вложенным хешем, например:

`$grades{Joe} = 'absent';`

Здесь ключ Joe не имеет второго уровня. И это прекрасно будет работать.

Результат будет таким:

```
$VAR1 = {
          'Peti Bar' => {
                          'Literature' => 88,
                          'Mathematics' => 82,
                          'Art' => 99
                        },
          'Foo Bar' => {
                         'Mathematics' => 97,
                         'Literature' => 67
                       },
          'Joe' => 'absent'
        };
----------------
HASH(0x7fabf8803468)
Foo Bar, Mathematics: 97
Foo Bar, Literature: 67
absent
Can't use string ("absent") as a HASH ref while "strict refs" in use at files/hash.pl line 20.
```

Data::Dumper работает отлично и показывает структуру верно (Joe не имеет фигурных скобок, 
так как не содержит вложенный хеш), но часть кода, где мы вручную проходим наш хеш, 
содержит ошибку. [use strict](https://perlmaven.com/strict) остановил программу, потому что мы 
пытались использовать строку 'absent' как [символьную ссылку](https://perlmaven.com/symbolic-reference-in-perl).
Отличная штука.

## Больше двух измерений

Мы также можем сделать больше двух измерений. Например, 'Foo Bar' может иметь 'Art', а тот в свою очередь содержать 
оценки по нескольким разным подгруппам:

```perl
$grades{"Foo Bar"}{Art}{drawing}   = 34;
$grades{"Foo Bar"}{Art}{theory}    = 47;
$grades{"Foo Bar"}{Art}{sculpture}  = 68;
```

Удалим наконец нашего Joe, чтобы он перестал нас беспокоить.
Получим вот это:

```
VAR1 = {
          'Peti Bar' => {
                          'Mathematics' => 82,
                          'Art' => 99,
                          'Literature' => 88
                        },
          'Foo Bar' => {
                         'Art' => {
                                    'sculpture' => 68,
                                    'theory' => 47,
                                    'drawing' => 34
                                  },
                         'Mathematics' => 97,
                         'Literature' => 67
                       }
        };
----------------
Foo Bar, Art: HASH(0x7fbe9a027d40)
Foo Bar, Mathematics: 97
Foo Bar, Literature: 67
Peti Bar, Mathematics: 82
Peti Bar, Art: 99
Peti Bar, Literature: 88
```

Data::Dumper все еще отлично работает и показывает все наши вложенные хеши.

К сожаление, ручной проход по хешу опять не работает как надо, хотя в этот раз у нас нет ошибки.
Мы просто получили ссылку на внутреннюю структуру Art из "Foo Bar".

Мы можем сделать хеш с еще более смешанной вложенностью.

## Смешанная вложенность

Допустим 'Foo Bar' может иметь другой предмет, называемый 'Programming', который оценивается
по каждому отдельному заданию. Задания не имеют названий, просто пронумерованы: 0, 1, 2, 3 и тд.
Мы можем конечно сделать хеш, где 0, 1, 2, 3 и тд будут ключами, но лучше
хранить их в массиве:

```perl
$grades{"Foo Bar"}{Programming}[0]  = 90;
$grades{"Foo Bar"}{Programming}[1]  = 91;
$grades{"Foo Bar"}{Programming}[2]  = 92;
```

Data::Dumper покажет их нам в квадратных скобках::

```
$VAR1 = {
          'Foo Bar' => {
                         'Literature' => 67,
                         'Programming' => [
                                            90,
                                            91,
                                            92
                                          ],
                         'Mathematics' => 97,
                         'Art' => {
                                    'sculpture' => 68,
                                    'theory' => 47,
                                    'drawing' => 34
                                  }
                       },
          'Peti Bar' => {
                          'Mathematics' => 82,
                          'Art' => 99,
                          'Literature' => 88
                        }
        };
----------------
Foo Bar, Literature: 67
Foo Bar, Programming: ARRAY(0x7fc409028508)
Foo Bar, Mathematics: 97
Foo Bar, Art: HASH(0x7fc409027d40)
Peti Bar, Mathematics: 82
Peti Bar, Art: 99
Peti Bar, Literature: 88
```

Наш проход по хешу вручную не может вывести эти элементы, и выводит не `HASH(0x7fc409027d40)`, а 
`ARRAY(0x7fc409028508)`, указывая, что это ссылка на массив, а не на хеш.
