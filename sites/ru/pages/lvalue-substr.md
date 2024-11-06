---
title: "Lvalue substr - замена части строки"
timestamp: 2014-03-21T10:51:01
tags:
  - substr
  - Lvalue
published: true
original: lvalue-substr
books:
  - beginner
author: szabgab
translator: name2rnd
---


Есть несколько странных функций в Perl, которые могут принимать значения слева.
Например, если вы хотите изменить содержимое строки, то можете использовать [substr с 4-мя параметрами](https://ru.perlmaven.com/strokovye-funkcii-length-lc-uc-index-substr), где четвертый параметр это строка для замены, или можете использовать `substr` как левостороннюю функцию (lvalue) и присвоить ей значение.


`substr $text, 14, 7, "jumped from";`

and

`substr($text, 14, 7) = "jumped from";`

эти два выражения эквивалентны.

Несколько примеров:

## substr с 4-мя параметрами

```perl
use strict;
use warnings;
use 5.010;

my $text = "The black cat climbed the green tree.";
substr $text, 14, 7, "jumped from";
say $text;
```

## substr с 3-мя параметрами как Lvalue

```perl
use strict;
use warnings;
use 5.010;

my $text = "The black cat climbed the green tree.";
substr($text, 14, 7) = "jumped from";
say $text;
```

Обе эти программы выведут:

```
The black cat jumped from the green tree.
```

## Какое же выражение использовать?

Я думаю, что 4-х параметровый вариант более понятен.
Если вы хотите убедиться, что никто из вашей команды не использует Lvalue-вариант substr, 
то используйте [Perl::Critic](/perl-critic-one-policy) с включенным правилом 
[ProhibitLvalueSubstr](https://metacpan.org/pod/Perl::Critic::Policy::BuiltinFunctions::ProhibitLvalueSubstr).
