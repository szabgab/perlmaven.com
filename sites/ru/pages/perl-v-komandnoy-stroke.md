---
title: "Perl в командной строке"
timestamp: 2013-04-10T00:57:10
tags:
  - -v
  - -e
  - -p
  - -i
published: true
original: perl-on-the-command-line
books:
  - beginner
author: szabgab
translator: shatlovsky
---


В то время как большинство глав нашего [Учебника по Perl](/perl-tutorial) рассказывает о скриптах в виде
файлов, мы также увидим несколько примеров однострочников (one-liner).

Даже если вы используете [Padre](http://padre.perlide.org/)
или другую IDE, из тех, что позволяют запускать скрипты из-под себя,
очень важно знать, как работать с командной строкой (shell) и
уметь в ней пользоваться Perl.


Если вы используете Linux, откройте окно терминала. Вы увидите
приглашение, вероятно, оканчивающееся на знак $.

Если вы используете Windows, откройте окно командной строки: нажмите

Пуск -> Выполнить -> введите "cmd" -> Enter

Вы увидите черное окно CMD с подсказкой, которое, вероятно, выглядит примерно так:

```
c:\>
```

## Версия Perl

Введите `perl -v`. Эта команда выдаст нечто вроде:

```
C:\> perl -v

This is perl 5, version 12, subversion 3 (v5.12.3)
  built for MSWin32-x86-multi-thread

Copyright 1987-2010, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

Видно, что на этой Windows-машине у меня установлен Perl версии 5.12.3.


## Выводим число

Теперь наберите `perl -e "print 42"`.
Эта команда выведет на экран число `42`. Появится запрос на ввод следующей команды.

```
c:>perl -e "print 42"
42
c:>
```

В Linux вы увидите нечто подобное:

```
gabor@pm:~$ perl -e "print 42"
42gabor@pm:~$
```

Результат будет выведен в начале строки, непосредственно перед приглашением.
Эта разница объясняется различиями в поведении двух интерпретаторов командной строки.

В этом примере мы используем флаг `-e`, который говорит Perl,
"Не ищи файл скрипта. Следующий параметр командной строки это и есть тот Perl-код, который тебе нужно исполнить".

Эти примеры, конечно, не особенно интересны. Поэтому давайте я покажу вам чуть более сложный
пример, без лишних комментариев:

## Заменяем Java на Perl

Эта команда: `perl -i.bak -p -e "s/\bJava\b/Perl/" resume.txt`
заменит все упоминания слова <b>Java</b> на слово <b>Perl</b> в
вашем резюме, попутно сделав резервные копии файлов.

В Linux вы можете написать даже так `perl -i.bak -p -e "s/\bJava\b/Perl/" *.txt`,
чтобы заменить Java на Perl во <b>всех</b> ваших текстовых файлах.

Чуть позже мы ещё поговорим об однострочниках, и вы узнаете, как их использовать.
Пока же скажем, знание и умение применять однострочники является весьма мощным оружием в ваших руках.

Между прочим, если вам не терпится узнать некоторые очень хорошие однострочники, я рекомендую вам почитать
[Perl One-Liners explained](http://www.catonmat.net/blog/perl-book/)
(англ.) Петериса Круминса.

## Далее

В следующей главе мы поговорим про
[основную документацию Perl и документацию на модули из CPAN](/documentacia-na-perl-i-cpan-moduli).
