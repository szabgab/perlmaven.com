---
title: "Рисуем изображения в Perl, используя GD::Simple"
timestamp: 2014-04-21T22:30:01
tags:
  - GD
  - GD::Simple
published: true
original: drawing-images-using-gd-simple
author: szabgab
translator: name2rnd
---


Модуль [GD](https://metacpan.org/pod/GD::Simple) на CPAN это интерфейс к графической библиотеке GD.
Lincoln D. Stein создал и до сих пор поддерживает этот модуль.

[GD::Simple](https://metacpan.org/pod/GD::Simple) это обертка к GD модулю, которая предоставляет 
более простой интерфейс для создания изображений.
Следующий пример основан на примере из модуля.


<style>
img.bordered {
  border:solid 1px;
}
</style>

## Красный квадрат (new, bgcolor, fgcolor, rectangle, png)

```perl
use strict;
use warnings;
use GD::Simple;
 
# create a new image (width, height)
my $img = GD::Simple->new(200, 100);

# draw a red rectangle with blue borders
$img->bgcolor('red');
$img->fgcolor('blue');
$img->rectangle(10, 10, 50, 50); # (top_left_x, top_left_y, bottom_right_x, bottom_right_y)
                                 # ($x1, $y1, $x2, $y2)

# convert into png data
open my $out, '>', 'img.png' or die;
binmode $out;
print $out $img->png;
```

<img src="https://perlmaven.com/img/gd_simple/red_square.png" alt="Red square" class="bordered" />

(В этом примере рамка была добавлена вокруг изображения средствами CSS, чтобы показать реальный размер изображения.)
`my $img = GD::Simple->new(200, 100);` создает изображение. Принимает два параметра: `(ширина, высота)`.

Можно сказать, что $img это "перо", и методы объекта $img - это команды "перу".
В примере выше мы устанавливаем цвет заливки, используя `bgcolor`, 
и цвет рамки с помощью `fgcolor`, чтобы она была синей.

Метод `rectangle` нарисует прямоугольник, используя цвет рамки и заливки, он принимает 4 параметра (для двух вершин прямоугольника):
`(верхняя левая x, верхняя левая y, нижняя правая x, нижняя правая y)`, 
где координаты `(0,0)` соответствуют верхнему левому углу нашего изображения. 
Следующий пример будет более понятен.

Последние три строки примера выше конвертируют внутреннее представление изображения в формат PNG и сохраняют его в файл img.png.

## Пустой зеленый прямоугольник

Добавим в наш пример выше следующий код (перед тем, как сохранить изображение):

```perl
# рисует пустой прямоугольник с зеленой рамкой
$img->bgcolor(undef);
$img->fgcolor('green');
$img->rectangle(20, 40, 100, 60);
```

<img src="https://perlmaven.com/img/gd_simple/green_rectangular.png" alt="green rectangular" class="bordered" />

В этом примере заливка прозрачная, таким образом, часть прямоугольника, которая перекрывает красный квадрат, остается красной, а оставшаяся часть - белой.
Координаты, переданные в метод `rectangle`, теперь более понятно показывают, что от чего зависит.

## Рисуем прямую зеленую линию (moveTo, lineTo)

В следующей части нашего примера мы нарисуем прямую линию. Для этого мы используем метод 
`lineTo`, который рисует линию от текущей позиции "пера", до 
переданных ему координат `(x, y)`, отсчитанных от левого верхнего угла изображения.

Для перемещения нашего "пера"" в конкретное место, используем метод `moveTo`,
принимающий две координаты `(x, y)`.

```perl
# move to (30, 0) and draw a green line to (100, 40)
$img->moveTo(30, 0);   # (x, y)
$img->lineTo(100, 40); # (x, y)
```

<img src="https://perlmaven.com/img/gd_simple/green_line.png" alt="green line" class="bordered" />

## Рисует сплошной оранжевый эллипс

Дальше мы нарисуем эллипс, вписанный в прямоугольник, нарисованный ранее.
Для начала нам нужно переместить наше "перо" в центр прямоугольника, который также будет центром эллипса.
Прямоугольник выше имеет следующие координаты: (20, 40, 100, 60).

Центр по горизонтали будет `(left_x + right_x)/2  = (20+100)/2 = 60`.

Центр по вертикали будет `(top_y + bottom_y)/2  = (40+60)/2 = 50`.

Сначала нам нужно вызвать метод `moveTo(60, 50)` для перемещения "пера" в наш центр.

Общая ширина эллипса будет `(right_x - left_x) = 100-20 = 80`.

Общая высота эллипса будет `(bottom_y - top_y) = 60 - 40 = 20`.

После установки цвета заливки и рамки нарисуем эллипс с помощью `ellipse(80, 20)`.

```perl
# draw a solid orange ellipse
$img->moveTo(60, 50);    # (x, y)
$img->bgcolor('orange');
$img->fgcolor('orange');
$img->ellipse(80, 20);   # (width height)
```

<img src="https://perlmaven.com/img/gd_simple/orange_ellipse.png" alt="orange ellipse" class="bordered" />

## Рисуем дугу

Википедия определяет [дугу](http://en.wikipedia.org/wiki/Arc_(geometry)) 
как часть круга, или в более общем случае, как часть эллипса.

Чтобы нарисовать дугу, нам сначала нужно установить "перо" в начальную точку дуги, которая будет центром дуги,
и передать параметры: `($width, $height, $start, $end, $style)` (width - ширина, height - высота).

Если ширина и высота одинаковые, тогда мы получим часть окружности.
`$start` и `$end` это градусы от 0 до 360. Ноль - это крайняя правая точка эллипса, градусы увеличиваются по часовой стрелке.
Следовательно 0, 90 будет описывать нижнюю правую четверть.

```perl
# draw an arc filled with dark violet
$img->moveTo(100, 50);
$img->bgcolor('darkviolet');
$img->fgcolor('darkviolet');
$img->arc(60, 60, 0, 90, gdEdged);
```

<img src="https://perlmaven.com/img/gd_simple/dark_violet_arc.png" alt="dark violet arc" class="bordered" />

## Рисуем теекст

Метод `string` может добавить текст к изображению.

```perl
# draw a string at (10,30) using the default built-in font
$img->bgcolor('black');
$img->fgcolor('black');
$img->moveTo(10, 30);
$img->string('Perl Maven');
```

<img src="https://perlmaven.com/img/gd_simple/text.png" alt="" class="bordered" />

Конечно, GD и GD::Simple умеют гораздо больше всего, но вы уже знаете кое-что, чтобы начать их использовать.
