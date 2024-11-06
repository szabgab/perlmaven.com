---
title: "ref - Какого типа эта ссылка?"
timestamp: 2014-04-14T11:09:01
tags:
  - ref
  - SCALAR
  - ARRAY
  - HASH
  - CODE
  - REF
  - GLOB
  - LVALUE
  - FORMAT
  - IO
  - VSTRING
  - Regexp
published: true
original: ref
author: szabgab
translator: name2rnd
---


Функция `ref()` возвращает тип переданной ей ссылки. 
Если параметр не задан, то будет возвращен тип ссылки для 
[$_, переменной по умолчанию в Perl.](https://perlmaven.com/the-default-variable-of-perl)

Согласно документации, возможные возвращаемые значения функции `ref()` такие:

```
SCALAR
ARRAY
HASH
CODE
REF
GLOB
LVALUE
FORMAT
IO
VSTRING
Regexp
```

Давайте посмотрим, что каждое из них значит.


## Простые скаляры

Если мы передадим простой скаляр в функцию `ref()`, содержащий
[undef](https://ru.perlmaven.com/undef-i-defined-v-perl), строку или число, то `ref()`
вернет пустую строку:

```perl
use strict;
use warnings;
use 5.010;

my $nothing;
my $string = 'abc';
my $number = 42;

say 'nothing:    ', ref $nothing;   # 
say 'string:     ', ref $string;    #
say 'number:     ', ref $number;    #
say 'nothing:    ', defined ref $nothing;   # 1
say 'string:     ', defined ref $string;    # 1
say 'number:     ', defined ref $number;    # 1
```

## Ссылка на скаляр (SCALAR)

Если мы передадим в функцию `ref()` ссылку на скаляр 
(содержащий undef, строку или число), то она вернет нам `SCALAR`.

```perl
use strict;
use warnings;
use 5.010;

my $nothing;
my $string = 'abc';
my $number = 42;

my $nothingref = \$nothing;
my $stringref  = \$string;
my $numberref  = \$number;

say 'nothingref: ', ref $nothingref; # SCALAR
say 'stringref:  ', ref $stringref;  # SCALAR
say 'numberref:  ', ref $numberref;  # SCALAR
```

## Ссылка на массив (ARRAY) и хеш (HASH)

Если мы передадим массив или хеш в функцию `ref()`, то она вернет пустую строку,
но если передать ей ссылку на массив или ссылку на хеш, то она вернет `ARRAY` или `HASH`
соответственно.

```perl
use strict;
use warnings;
use 5.010;

my @arr = (2, 3);
my %h = (
    answer => 42,
);

my $arrayref  = \@arr;
my $hashref   = \%h;

say 'array:      ', ref @arr;       # 
say 'hash:       ', ref %h;         #
say 'arrayref:   ', ref $arrayref;  # ARRAY
say 'hashref:    ', ref $hashref;   # HASH
```

## Ссылка на код (CODE)

Передав в функцию `ref()` ссылку на функцию, мы получим `CODE`.

```perl
use strict;
use warnings;
use 5.010;

sub answer {
     return 42;
}
my $subref    = \&answer;

say 'subref:     ', ref $subref;    # CODE
```

## Ссылка на ссылку (REF)

Если у нас есть ссылка на ссылку и мы ее передадим в `ref()`, тогда
получим `REF`.

```perl
use strict;
use warnings;
use 5.010;

my $str = 'abc';
my $strref = \$str;
my $refref    = \$strref;
say 'strref:     ', ref $strref;    # SCALAR
say 'refref:     ', ref $refref;    # REF

say 'refrefref:  ', ref \$refref;   # REF
```

Если у нас есть ссылка на ссылку на ссылку ... тогда все равно будет `REF`.

## Ссылка на регулярное выражение (Regex)

Оператор `qr` возвращает прекомпилированное регулярное выражение, 
`ref()` вернет для него `Regexp`.

```perl
use strict;
use warnings;
use 5.010;

my $regex = qr/\d/;
my $regexref = \$regex;
say 'regex:      ', ref $regex;     # Regexp

say 'regexref:   ', ref $regexref;  # REF
```

Понятное дело, что передав ссылку на `Regex`, мы снова получим `REF`.

## Ссылка на GLOB

File-handle, создаваемый функцией `open`, имеет тип `GLOB`.

```perl
use strict;
use warnings;
use 5.010;

open my $fh, '<', $0 or die;
say 'filehandle: ', ref $fh;        # GLOB
```

## Ссылка на FORMAT

Мне кажется, что функция [format](https://metacpan.org/pod/perlform) в Perl 
не особо нравится разработчикам, поэтому вы редко где ее увидите. Я долго не мог понять,
как мне взять от нее ссылку, но все-таки решил привести пример. Пожалуй, вам 
вообще не стоит задумываться об этом.

```perl
use strict;
use warnings;
use 5.010;

format fmt =
   Test: @<<<<<<<< @||||| @>>>>>
.
say 'format:     ', ref *fmt{FORMAT};  # FORMAT
```


## Ссылка на VSTRING

Строка указания версии, начинающаяся с символа `v`, является еще одной редкостью,
хотя и встречается чаще, чем format:

```perl
use strict;
use warnings;
use 5.010;

my $vs = v1.1.1;
my $vsref = \$vs;
say 'version string ref: ', ref $vsref;  # VSTRING
```


## Ссылка на LVALUE

Lvalue-функции - это функция, которая принимает агрументы слева.
Например, если вы хотите заменить часть строки, то можете использовать 
[версию substr с 4-мя аргументами](https://ru.perlmaven.com/strokovye-funkcii-length-lc-uc-index-substr),
где четвертый аргумент это строка-замена, либо можно использовать 
[версию substr с 3-мя аргументами](https://ru.perlmaven.com/lvalue-substr), присваивая строку-замену слева.

Давайте посмотрим, что произойдет, если мы возмем ссылку на обычный вариант функции substr (c 4-ми аргументами):

```perl
use strict;
use warnings;
use 5.010;

my $text = 'The black cat climbed the green tree';
my $nolv = \ substr $text, 14, 7, 'jumped from';
say 'not lvalue:  ', ref $nolv;  # SCALAR
say $nolv;    # SCALAR(0x7f8d190032b8)
say $$nolv;   # climbed
say $text;    # The black cat jumped from the green tree

$$nolv = 'abc';
say $text;    # The black cat jumped from the green tree
```

Значение, присвоенное переменной `$nolv` это обычная ссылка на скаляр, 
содержающий значение, возвращаемое функцией `substr`.
В нашем случае - слово 'climbed'.

С другой стороны, если мы возьмем ссылку на 3-аргументный вариант substr (или 2-х),
тогда возвращаемое значение, присвоенное к `$lv` ниже, будет ссылкой на `LVALUE`.
Если его разыменовать через `say $$lv;`, тогда получим оригинальное значение - строку 'climbed'.

Если мы присвоим разыменованной ссылке какое-то значение: `$$lv = 'jumped from';`, тогда 
изменится содержимое переменной `$$lv`, что в свою очередь приведет к замене содержимого
в исходной строке `$text`.

Мы можем повторить присваивание: `$$lv = 'abc';` и исходная строка снова изменится.

```perl
use strict;
use warnings;
use 5.010;

my $text = 'The black cat climbed the green tree';
my $lv = \ substr $text, 14, 7;
say 'lvalue:      ', ref $lv;    # LVALUE
say $lv;                         # LVALUE(0x7f8fbc0032b8)
say $$lv;                        # climbed
say $text;                       # The black cat climbed the green tree

$$lv = 'jumped from';
say $lv;                         # LVALUE(0x7f8fbc0032b8)
say $$lv;                        # jumped from
say $text;                       # The black cat jumped from the green tree

$$lv = 'abc';
say $$lv;                        # abc
say $text;                       # The black cat abc the green tree
```


## Blessed-ссылки

Как объясняется [тут](https://perlmaven.com/constructor-and-accessors-in-classic-perl-oop),
в [классической объектно-ориентированной модели](https://perlmaven.com/getting-started-with-classic-perl-oop) Perl
функция `bless` используется для присоединения ссылки на хеш к пространству имен. (Вообще-то
в [Moo](https://perlmaven.com/moo) и [Moose](https://perlmaven.com/moose) происходит то же самое, но оно от нас скрыто.)

Тем не менее, если мы вызовем функцию `ref()` для blessed-ссылки, то получим имя пространства имен:

```perl
use strict;
use warnings;
use 5.010;

my $r = {};
say ref $r;              # HASH
bless $r, 'Some::Name';
say ref $r;              # Some::Name
```

Аналогично, если исходная ссылка не является ссылкой на хеш:

```perl
use strict;
use warnings;
use 5.010;

my $r = [];
say ref $r;               # ARRAY
bless $r, 'Class::Name';
say ref $r;               # Class::Name
```

## Еще

Документация [perlref](https://metacpan.org/pod/perlref) содержимт много подробностей на счет `ref` и ссылок в целом.

