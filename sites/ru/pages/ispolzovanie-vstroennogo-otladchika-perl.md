---
title: "Использование встроенного отладчика Perl"
timestamp: 2013-07-10T12:00:00
tags:
  - debugger
  - -d
  - debug
types:
  - screencast
published: true
original: using-the-built-in-debugger-of-perl
author: szabgab
translator: spidamoo
---


Новый скринкаст расскажет об <a href="http://www.youtube.com/watch?v=jiYZcV3khdY">использовании 
встроенного отладчика Perl</a>. Я выступал на эту тему на нескольких семинарах и конференциях по
Perl, и каждый раз встречалось много людей, которые никогда не использовали отладчик. Надеюсь, эта
публикация поможет кому-то начать им пользоваться.


<iframe width="640" height="480" src="http://www.youtube.com/embed/jiYZcV3khdY"
frameborder="0" allowfullscreen></iframe>

Запуск отладчика:

perl -d yourscript.pl param param

Команды отладчика, упоминаемые в этом видео:

q - выход

h - помощь

p - вывод (print)

s - шагнуть внутрь (step in)

n - перешагнуть (step over)

r - шагнуть наружу (step out)

T - трассировка стека

l - листинг кода

Я также советую почитать книгу Ричарда Фоли (Richard Foley) и Энди Лестера (Andy Lester):
[Pro Perl Debugging](http://www.apress.com/9781590594544)

