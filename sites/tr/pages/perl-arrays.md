---
title: "Perl Dizileri"
timestamp: 2015-03-29T20:45:02
description: "perl array denoted with @ - creating, checking size, iterating over the elements, accessing elements"
tags:
  - "@"
  - array
  - arrays
  - length
  - size
  - foreach
  - Data::Dumper
  - scalar
  - push
  - pop
  - shift
  - $#
published: true
original: perl-arrays
books:
  - beginner
author: szabgab
translator: kbeyazli
---


[Perl eğitiminin](/perl-tutorial) bu bölümünde <b>Perl'de dizileri</b> öğreneceğiz.
Bu bölüm Perl'de dizilerin nasıl çalıştığına dair bir bakış olacak. Daha detaylı açıklamaları sonra göreceğiz.

Perlde dizi değişken adları `@` karakteri ile başlar.

`strict` kullanımındaki ısrarımıza bağlı olarak, bu değişkenleri ilk kullanımda`my` anahtar sözcüğü 
ile tanımlamalısınız.


Örneklerin tümünde dosyanızın aşağıdaki terimlerle başladığını varsayıyoruz.

```perl
use strict;
use warnings;
use 5.010;
```

Bir dizi tanımlama

```perl
my @names;
```

Dizi tanımlama ve değer atama:

```perl
my @names = ("Foo", "Bar", "Baz");
```

## Bir diziyi debug etme

```perl
use Data::Dumper qw(Dumper);

my @names = ("Foo", "Bar", "Baz");
say Dumper \@names;
```

Çıktı:

```
$VAR1 = [
        'Foo',
        'Bar',
        'Baz'
      ];
```

## foreach döngüsü ve Perl dizileri

```perl
my @names = ("Foo", "Bar", "Baz");
foreach my $n (@names) {
  say $n;
}
```

Çıktı:

```
Foo
Bar
Baz
```

## Dizinin bir elemanına erişim

```perl
my @names = ("Foo", "Bar", "Baz");
say $names[0];
```

Dizinin bir elemanına erişirken `@` işaretinin `$` işaretine dönüştüğüne dikkat edelim.
Bu bazi insanlarda karışıklığa yol açabilir ama düşünüldüğünde sebebinin açık olduğu görülür.

`@` çoğul u gösterir, `$` ise tekili. Dizinin bir elemanına erişirken
düzgün skalar bir değişken gibi davranış gösterir.

## Diziyi indeksleme

Dizinin indeksi 0'dan başlar. Son index şu değişkende tutulmaktadır
`$#dizinin_adı`. Bu nedenle

```perl
my @names = ("Foo", "Bar", "Baz");
say $#names;
```

kod parçacığı ekrana 2 yazar çünkü ideksler 0,1 ve 2'dir.

## Dizinin uzunluğu veya boyutu

Perl'de dizinin boyutunu bulmak için özel bir fonksiyon yoktur ama boyutu hesaplamak
için birçok yol vardır. Bir tanesi, dizinin son indeksinin 1 fazlası değerin dizinin
boyutu olduğudur. Yukarıdaki örnekte `$#names+1` dizinin <b>boyutu</b> veya
<b>uzunluğu</b>dur.

Ek olarak `scalar` fonksiyonu dizinin boyutunu bulmak için kullanılabilir:

```perl
my @names = ("Foo", "Bar", "Baz");
say scalar @names;
```

Ekrana 3 yazar.

scalar fonksiyonu bir çeşit tip dönüştürme fonksiyonudur, diziyi skalar a dönüştürür. 
Bu dönüşüm aynı zamanda dizinin boyutunu verir.

## Bir dizinin indeksleri üzerinde döngü

Dizinin değerleri üzerinde dönmenin yeterli olmadığı durumlar vardır.
Hem değere hem de değerin indeksine ihtiyacımız olabilir.
Bu durumda indeksler üzerinde dönmeye ve indeksleri kullanarak değerlere ulasmaya
ihtiyacımız var:

```perl
my @names = ("Foo", "Bar", "Baz");
foreach my $i (0 .. $#names) {
  say "$i - $names[$i]";
}
```

çıktı:

```
0 - Foo
1 - Bar
2 - Baz
```

## push kullanımı

`push` dizinin sonuna yeni bir eleman ekler, diziyi büyütür:

```perl
my @names = ("Foo", "Bar", "Baz");
push @names, 'Moo';

say Dumper \@names;
```

Sonuç:

```
$VAR1 = [
        'Foo',
        'Bar',
        'Baz',
        'Moo'
      ];
```


## pop kullanımı

`pop` dizinin son elemanini alır:

```perl
my @names = ("Foo", "Bar", "Baz");
my $last_value = pop @names;
say "Last: $last_value";
say Dumper \@names;
```

Sonuç:

```
Last: Baz
$VAR1 = [
        'Foo',
        'Bar',
      ];
```

## shift kullanımı

`shift` dizinin sol ilk elemanını donderir
ve diğer elemanları bir sola kaydırır:

```perl
my @names = ("Foo", "Bar", "Baz");

my $first_value = shift @names;
say "First: $first_value";
say Dumper \@names;
```

Sonuç:

```
First: Foo
$VAR1 = [
        'Bar',
        'Baz',
      ];
```

