---
title: "Не используйте интерполяцию в printf (отсутствующий аргумент в sprintf ...)"
timestamp: 2014-08-18T21:26:01
tags:
  - printf
  - sprintf
published: true
original: dont-interpolate-in-printf
author: szabgab
translator: ymyasoedov
---


Однажды, когда я запустил один из моих скриптов, я получил исключение `Missing argument in sprintf at ...` (отсутствующий аргумент в sprintf ...).

В общем я написал небольшой пример, демонстрирующий проблему. Взглянем на пример:


В корне проекта у меня находятся два файла, скрипт и модуль, который представляет текущий обрабатываемый файл:

```
dir/
   printf_interpolate.pl
   lib/App/File.pm
```


Скрипт `printf_interpolate.pl` содержит следующий код:

```perl
use strict;
use warnings FATAL => 'all';

use App::File;

my $LIMIT = 80;

my $file = read_params(@ARGV);
_log("START");
check_file($file);
_log("DONE");


sub read_params {
    my $filename = shift or die "Usage: $0 FILENAME\n";
    my $file = App::File->new($filename);
    return $file;
}

sub check_file {
    my ($file) = @_;

    open my $fh, '<', $file->filename or die;
    while (my $line = <$fh>) {
        my $actual = length $line;
        if ($actual > $LIMIT) {
            _log(sprintf "Line is too long ($actual > $LIMIT) ($line) (file %s)", $file->filename);
        }
    }
}


sub _log {
    my $str = shift;
    say $str;
}
```

Всё, что делает код в этом примере, это построчное чтение файла с проверкой длины строк. Если строка слишком длинная, вызывается функция `_log` и выводится предупреждение.

Модуль `/lib/App/File.pm` содержит следующий код:

```perl
package App::File;
use strict;
use warnings;

sub new {
    my ($class, $filename) = @_;
    return bless {filename => $filename}, $class;
}
sub filename {
    my ($self) = @_;
    return $self->{filename};
}

1;
```

Это простой модуль, который представляет файл. В реальном коде реализация класса будет значительно сложнее, но в нашем случае такого примитивного класса достаточно.

Итак, что произойдёт, если я запущу скрипт, передав этот скрипт в качестве параметра? То есть, что произойдёт, если скрипт не будет содержать ни одной строки, длиннее 80 символво?

```
cd dir/
perl printf_interpolate.pl printf_interpolate.pl
```

После вывода слова "START" мы получим следующее исключение:
`Missing argument in sprintf at printf_interpolate.pl line 27, <$fh> line 27.`
pointing us to the line where we call `sprintf`.

На самом деле это <b>предупреждение</b>, т.к. код `use warnings FATAL => 'all'` включает обработку всех предупреждений как фатальные исключения.

Проблема заключается в том, что некоторые строки содержат фрагменты, которые похожи на заполнители, использующиеся в функции sprintf.
Т.к. `sprintf` содержит некоторые встроенные (интерполированные) переменные (в частности, переменную `$line`), после интерполяции строка будет содержать более одного заполнителя `%s`.

Если заменить проблемный код на следующий:
```perl
  _log(sprintf "Line is too long ($actual > $LIMIT) (%s) (file %s)", $line, $file->filename);
```

то это решит указанную выше проблему, т.к. мы вставили ещё один форматтер `%s`, который будет раскрыт во время вызова `sprintf`.

Если запустить на выполнение код, то теперь мы увидим следующее:

```
START
Line is too long (104 > 80) (            _log(sprintf "Line is too long ($actual > $LIMIT) (%s) (file %s)", $line, $file->filename);
) (file printf_interpolate.pl)
DONE
```

Ну вот, теперь лучше.

Конечно, если мы вынесли одну переменную из строки, то мы должны поступить таким же образом с двумя оставишимися переменными:

```perl
  _log(sprintf "Line is too long (%s > %s) (%s) (file %s)", $actual, $LIMIT, $line, $file->filename);
```

## Короткий пример

Следующий фрагмент кода может воспроизвести предупреждение:

```perl
use strict;
use warnings;

my $name = 'Foo';
#my $smalltalk = 'how are you?';
my $smalltalk = '%s hi?';

printf "Hello %s, $smalltalk\n", $name; 
```

```
Missing argument in printf at printf_interpolate_short line 8.
Hello Foo,  hi?
```

## Итог

Не встраивайте переменные в функции `printf` и `sprintf`, т.к. переменные могут содержать специальные символы, которые могут управлять поведением этих функций.
