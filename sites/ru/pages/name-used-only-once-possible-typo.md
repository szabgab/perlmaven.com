---
title: "Name 'main::x' used only once: possible typo at ..."
timestamp: 2013-07-09T08:00:03
tags:
  - warnings
  - strict
  - possible typo
published: true
original: name-used-only-once-possible-typo
books:
  - beginner
author: szabgab
translator: spidamoo
---


Если вы увидели это предупреждение в Perl-скрипте, у вас большие неприятности.


## Присваивание значения переменной

Присваивание значения переменной, но не использование ее, или использование переменной единожды,
вообще не присвоив ей значения, вряд ли будет корректным в любом коде.

Возможно, единственное разумное объяснение - вы допустили опечатку, что и привело к появлению 
переменной, используемой лишь однажды.

Вот пример кода, в котором мы <b>только присваиваем значение переменной</b>:

```perl
use warnings;

$x = 42;
```

Выполнение его приведет к предупреждению:

```
Name "main::x" used only once: possible typo at ...
```

Эта часть с "main::" и отсутствие $ могут вас смутить. "main::" здесь потому, что по умолчанию
любая переменная в Perl относится к основному пространству имен main. Существует также пара вещей,
которые могут называться "main::x", и только у одной из них есть в начале $. Если это звучит
немного запутанно, не беспокойтесь. Это и есть запутанно, но можно надеяться, что вам не придется 
иметь дела с этим в течение долгого времени.

## Только получение значения

Если получилось так, что вы <b>используете переменную лишь однажды</b>

```perl
use warnings;

print $x;
```

то вы, скорее всего, получите два предупреждения:

```
Name "main::x" used only once: possible typo at ...
Use of uninitialized value $x in print at ...
```

Об одном из них сейчас и идет речь, а о другом вы можете прочесть в статье
[Use of uninitialized value](/use-of-uninitialized-value).


## О какой опечатке речь?

Могли бы вы спросить.

Представьте, что кто-то использует переменную под названием `$l1`. Потом приходите вы и 
хотите использовать ту же переменную, но пишете `$ll`. В зависимости от используемого шрифта,
они могут выглядеть очень похоже друг на друга.

Или, возможно, существует переменная `$color`, но вам ближе британский язык, так что вы 
автоматически написали `$colour`, имея в виду эту переменную.

Или у вас была переменная `$number_of_misstakes`, и вы не заметили ошибки в исходном названии,
и написали `$number_of_mistakes`.

В общем, понятно.

Если вам повезет, вы ошибетесь только однажды, а если не повезет, и вы напишете название неправильно
дважды, то это предупреждение не появится. В конце концов, если вы используете одну переменную дважды,
на это, должно быть, есть причина.

Так как же избежать этого?

Для начала, постарайтесь избегать названий переменных с неоднозначным написанием, и будьте 
внимательны, набирая их.

Если же вы хотите действительно решить эту проблему, просто используйте <b>use strict</b>!

## use strict

Как видно в предыдущих примерах, мы не использовали strict-режим. Если бы мы его включили, то вместо
предупреждения о возможной опечатке мы бы получили ошибку компиляции:
[Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name).

Это происходило бы даже если вы использовали неверную переменную больше одного раза.

Конечно, кто-то мог бы просто, не подумав, поставить "my" перед неправильной переменной, но вы-то
не из таких, не так ли? Вы бы подумали над проблемой и нашли бы, как действительно должна 
называться переменная.

Наиболее типичный способ увидеть это предупреждение - не использовать strict.

И вот тогда-то у вас возникнут серьезные неприятности.

## Другие случаи при использовании strict

Как указали GlitchMr и анонимный комментатор, существуют и некоторые другие случаи:

Этот код также может выдать такое:

```perl
use strict;
use warnings;

$main::x = 23;
```

Вы увидите предупреждение: <b>Name "main::x" used only once: possible typo ...</b>

Здесь по крайней мере понятно, откуда взялось 'main', или в следующем примере, откуда взялось 
'Mister'. (подсказка. Это название модуля, которого не хватало другой 
[ошибке про названия модулей](/global-symbol-requires-explicit-package-name).) В
следующем примере название модуля - 'Mister'.

```perl
use strict;
use warnings;

$Mister::x = 23;
```

Мы увидим предупреждение <b>Name "Mister::x" used only once: possible typo ...</b>.

Следущий пример тоже выдает это предупреждение. Дважды:

```perl
use strict;
use warnings;

use List::Util qw/reduce/;
print reduce { $a * $b } 1..6;
```

```
Name "main::a" used only once: possible typo at ...
Name "main::b" used only once: possible typo at ...
```

Это происходит потому, что `$a` и `$b` - специальные переменные, используемые во
встроенной функции сортировки (<h1>sort</h1>), поэтому их не нужно объявлять; однако здесь они
используются только один раз.
(На самом деле мне непонятно, почему здесь эти предупреждения появляются, хотя в таком же коде с
использованием <b>sort</b> - нет, но [Perl Monks](http://www.perlmonks.org/?node_id=1021888)
могут знать.)


