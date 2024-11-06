---
title: "Скалярные переменные"
timestamp: 2013-09-20T10:00:01
tags:
  - strict
  - my
  - undef
  - say
  - +
  - x
  - .
  - sigil
  - $
  - @
  - %
  - FATAL warnings
published: true
original: scalar-variables
books:
  - beginner
author: szabgab
translator: spidamoo
---


В этой части [Учебника Perl](/perl-tutorial) мы рассмотрим структуры данных, существующие
в Perl и узнаем, как их использовать.

В Perl 5 есть 3 основных структуры данных. Это <b>скаляры, массивы и хэши</b>. В других языках 
последние также могут называться словарями, справочными таблицами или ассоциативными массивами.


Перед переменными в Perl всегда ставится знак, называемый <b>"сигил"</b>. Этими знаками являются 
`$` для скаляров, `@` для массивов, и `%` для хэшей.

Скаляр может содержать единичное значение, например число или строку. Также он может содержать 
ссылку на другую структуру данных, к чему мы обратимся позже.

Название скалярной переменной всегда начинается с `$` (знак доллара), за которым следуют 
буквы, числа и подстрочия. В качестве названия переменной может использоваться `$name` или 
`$long_and_descriptive_name`. Также встречается вариант `$LongAndDescriptiveName`,
который обычно называют "CamelCase", но в Perl-сообществе обычно предпочитают названия, состоящие
только из символов нижнего регистра, с подстрочиями, отделяющими слова.

Поскольку мы всегда используем <b>strict</b>, нам всегда нужно объявлять переменные с помощью 
<b>my</b>. (Позже вы также узнаете об <b>our</b> и некоторых других способах, но пока что будем
использовать только объявление через <b>my</b>.) Мы можем либо присвоить переменной значение сразу,
как в этом примере:

```perl
use strict;
use warnings;
use 5.010;

my $name = "Foo";
say $name;
```

либо сначала объявить ее, а присвоить значение позже:

```perl
use strict;
use warnings;
use 5.010;

my $name;

$name = "Foo";
say $name;
```

Предпочтительно использовать первый способ, если логика кода позволяет.

Если мы объявили переменную, но еще не присвоили ей значение, она содержит значение, называемое
[undef](/undef-i-defined-v-perl), которое схоже с <b>NULL</b> в базах данных, но имеет
немного отличающееся поведение.

Можно проверить, является ли переменная `undef` с помощью функции `defined`:

```perl
use strict;
use warnings;
use 5.010;

my $name;

if (defined $name) {
  say 'defined';
} else {
  say 'NOT defined';
}

$name = "Foo";

if (defined $name) {
  say 'defined';
} else {
  say 'NOT defined';
}

say $name;
```

Можно присвоить для скалярной переменной значение `undef`:

```perl
$name = undef;
```

Скалярные переменные могут содержать числа или строки. То есть я могу написать:

```perl
use strict;
use warnings;
use 5.010;

my $x = "hi";
say $x;

$x = 42;
say $x;
```

и это сработает.

Как это работает вместе с операторами и перегрузкой операторов в Perl?

По большей части Perl устроен диаметрально противоположно другим языкам. Вместо того, чтобы операнды
определяли, как работают операторы, оператор определяет, как ведут себя операнды.

Так что, если у меня есть две переменные, содержащие числа, оператор в итоге решает, будут ли они
восприниматься как числа или как строки:

```perl
use strict;
use warnings;
use 5.010;

my $z = 2;
say $z;             # 2
my $y = 4;
say $y;             # 4

say $z + $y;        # 6
say $z . $y;        # 24
say $z x $y;        # 2222
```

`+`, оператор числового сложения, прибавляет два числа, так что и `$y` и `$z` 
ведут себя как числа.

`.`, оператор конкатенации строк, так что `$y` и `$z` ведут себя как строки. (В
других языках это бы могло называться строковым сложением.)

`x`, оператор повторения, повторяет строку слева количества раз, определяемое числом справа, 
так что в этом случае `$z` действует как строка, а `$y` - как число.

Результаты были бы теми же, если бы обе переменные создавались как строки:

```perl
use strict;
use warnings;
use 5.010;

my $z = "2";
say $z;             # 2
my $y = "4";
say $y;             # 4

say $z + $y;        # 6
say $z . $y;        # 24
say $z x $y;        # 2222
```

И даже если одна из них создана как число, а вторая как строка:

```perl
use strict;
use warnings;
use 5.010;

my $z = 7;
say $z;             # 7
my $y = "4";
say $y;             # 4

say $z + $y;        # 11
say $z . $y;        # 74
say $z x $y;        # 7777
```

Perl автоматически конвертирует числа в строки и наоборот, как того требует оператор.

Мы называем это числовым и строковым <b>контекстом</b>.

Вышеупомянутые случаи довольно просты. Преобразование числа в строку - по сути просто заключение его
в кавычки. Преобразование строки в числа, когда она состоит только из цифр - простой случай. То же 
будет, если в ней присутствует десятичная точка, например `"3.14"`. Вопрос в том, что если
в строке содержатся символы, не образующие число? Например `"3.14 is pi"`. Как тогда она себя
поведет в числовых операциях (то есть в числовом контексте)?

Это тоже несложно, хотя может потребовать некоторого объяснения.

```perl
use strict;
use warnings;
use 5.010;

my $z = 2;
say $z;             # 2
my $y = "3.14 is pi";
say $y;             # 3.14 is pi

say $z + $y;        # 5.14
say $z . $y;        # 23.14 is pi
say $z x $y;        # 222
```

Когда строка попадает в числовой контекст, Perl смотрит на левую часть строки, и пытается превратить
ее в число. Пока это получается, эта часть становится числовым значением переменной. В числовом 
контексте (`+`) строка `"3.14 is pi"` считается числом `3.14`.

В каком-то смысле это совершеннейший прозвол, но так это работает, так что мы живем с этим.

Код выше также выдаст предупреждение в стандартный канал ошибок (`STDERR`):

```
Argument "3.14 is pi" isn't numeric in addition(+) at example.pl line 10.
```

в случае, если вы использовали <b>use warnings</b>, что настоятельно рекомендуется. Использование
предупреждений поможет заметить, если что-то пойдет не совсем так, как предполагалось. Надеюсь,
результат выполнения `$x + $y` теперь вполне ясен.

## За кадром

На всякий случай, perl не конвертирует `$y` в 3.14, он просто использует числовое значение
для сложения. Думаю, это объясняет и результат `$z . $y`. В этом случае perl использует 
исходное строковое значение.

Возможно, вы удивлены, что `$z x $y` выдает 222, хотя справа у нас 3.14. Дело в том, что perl
может повторить строку только целое число раз... В этой операции perl молча округляет число справа.
(Если задуматься, можно понять, что "числовой" контекст, о котором шла речь раньше, на самом деле
включает в себя несколько подконтекстов, один из которых - "целочисленный". В большинстве случаев
perl делает то, что подсказывает здравый смысл большинству людей-непрограммисов)

Кроме того, мы даже не видим предупреждения "partial string to number conversion", как в случае с 
`+`.

Это не из-за другого оператора. Если закомментировать сложение, мы увидим это предупреждение уже на
этой операции. Причина отсутствия второго предупреждения в том, что когда perl создал числовое 
значение строки `"3.14 is pi"`, он сохранил его в потайном кармане переменной `$y`.
Так что по сути `$y` с тех пор имеет и строковое, и числовое значение, и нужное будет 
использоваться в соответствующие моменты уже без преобразования.

Есть еще три вещи, которые я хотел бы упомянуть. Первая это поведение переменной со значением 
`undef`, вторая - <b>fatal warnings</b>, и третья - как избежать автоматического перевода
строк в числа.

## undef

Если у меня в переменной содержится `undef`, что для большинства значит "ничего", ее все 
равно можно использовать. В числовом контексте она будет 0, а в строковом - пустой строкой:

```perl
use strict;
use warnings;
use 5.010;

my $z = 3;
say $z;        # 3
my $y;

say $z + $y;   # 3
say $z . $y;   # 3

if (defined $y) {
  say "defined";
} else {
  say "NOT";          # NOT
}
```

С двумя предупреждениями:

```
Use of uninitialized value $y in addition (+) at example.pl line 9.

Use of uninitialized value $y in concatenation (.) or string at example.pl line 10.
```

Как можно видеть, в конце скриппта переменная все еще `undef`, так что условное выражение 
выдаст "NOT".

## Fatal warnings

Второе, о чем я хотел сказать - некоторые предпочитают, чтобы приложение выбрасывало жесткое 
исключение вместо мягкого предупреждения. Если вы тоже исповедуете этот принцип, в начале скрипта
можно написать

```perl
use warnings FATAL => "all";
```

С этим скрипт выведет число 3, а затем выбросит исключение:

```
Use of uninitialized value $y in addition (+) at example.pl line 9.
```

Это то же сообщение, которое раньше было предупреждением, но теперь после этого выполнение скрипта
останавливается. (Если, конечно, исключение не было поймано, но об этом мы поговорим в другой раз.)

## Избежание автоматического перевода строки в число

Если вам не хочется, чтобы строки автоматически переводились в числа там, где невозможен полный 
перевод, вы можете проверять, выглядит ли строка как число, когда получаете ее из внешнего мира.

Для этого нам нужно подгрузить модуль 
[Scalar::Util](https://metacpan.org/pod/Scalar::Util) и содержащуюся в нем 
подпрограмму `looks_like_number`.

```perl
use strict;
use warnings FATAL => "all";
use 5.010;

use Scalar::Util qw(looks_like_number);

my $z = 3;
say $z;
my $y = "3.14";

if (looks_like_number($z) and looks_like_number($y)) {
  say $z + $y;
}

say $z . $y;

if (defined $y) {
  say "defined";
} else {
  say "NOT";
}
```


## перегрузка операторов

Наконец, можно перегрузить операторы так, чтобы операнды указывали, что должен делать оператор, но 
эту тему мы оставим в качестве продвинутой.
