---
title: "POD - Plain Old Documentation"
timestamp: 2015-08-08T13:40:59
tags:
  - POD
  - perldoc
  - =head1
  - =cut
  - =pod
  - =head2
  - documentation
  - pod2html
  - pod2pdf
published: true
books:
  - beginner
author: szabgab
translator: rozie
original: pod-plain-old-documentation-of-perl
---


Programiści zwykle nie lubią pisać dokumentacji. Częściowo z tego powodu, że
programy są zwykle plikami tekstowymi, a w wielu przypadkach od developerów
wymaga się pisania dokumentacji w jakimś edytora tekstu.

To wymaga nauki edytora tekstu i zainwestowania sporej energii w
postaranie się, żeby dokument "dobrze wyglądał" zamiast "miał dobrą treść".

Nie jest tak w przypadku Perla. Normalnie można napisać dokumentację
swoich modułów bezpośrednio w kodzie źródłowym i polegać na 
zewnętrznych narzędziach, które sformatują ją, by wyglądała dobrze.  


W tym odcinku [samouczka Perla](/perl-tutorial)
zapoznamy się z <b>POD - Plain Old Documentation</b> który jest
językiem znaczników używanym przez developerów perla.

Prosty kawałek perlowego kodu z POD wygląda tak:

```perl
#!/usr/bin/perl
use strict;
use warnings;

=pod

=head1 DESCRIPTION

This script can have 2 parameters. The name or address of a machine
and a command. It will execute the command on the given machine and
print the output to the screen.

=cut

print "Here comes the code ... \n";
```

Jeśli zapiszesz go jako `script.pl` i uruchomisz używając `perl script.pl`,
perl pominie wszystko pomiędzy liniami `=pod` oraz `=cut`.
Wykona tylko faktyczny kod.

Z drugiej strony, jeśli wpiszesz  `perldoc script.pl`, polecenie <b>perldoc</b>
zignoruje cały kod. Pobierze tylko linie pomiędzy `=pod` oraz `=cut`,
sformatuje je według pewnych reguł i wyświetli je na ekranie.

Reguły te zależą od Twojego systemu operacyjnego, ale są dokładnie takie same jak
te, które widziałeś kiedy uczyliśmy się o
[podstawowej dokumentacji Perla](/core-perl-documentation-cpan-module-documentation).

Wartością dodaną używania zagnieżdżonego POD is to, że Twój kod nigdy nie będzie
dostarczony przypadkowo bez dokumentacji, gdyż jest ona wewnątrz modułów i skryptów.
Możesz także powtórnie wykorzystaywać narzędzia i infrastrukturę społeczności Open Source Perl
dla siebie. Nawet na wewnętrzny użytek.

## Zbyt proste?

Założeniem jest, że jeśli usuniesz większość przeszkód do pisania
dokumentacji, wówczas ludzie będą pisać dokumentację. Zamiast uczyć się
korzystania z edytora tekstu do tworzenia ładnie wyglądających dokumentów, możesz po prostu
wpisać trochę tekstu z dodatkowymi symbolami i otrzymasz rozsądnie wyglądających
dokument. (Sprawdź domumentację na [Meta CPAN](http://metacpan.org/)
aby zobaczyć ładnie sformatowane wersje POD.

## Język znaczników

Szczegółowy opis [języka znaczników POD](http://perldoc.perl.org/perlpod.html)
można znaleźć wpisując [perldoc perlpod](http://perldoc.perl.org/perlpod.html) ale
jest on bardzo prosty.

Istnieje kilka tagów takich jak `=head1` i `=head2`
do oznaczania nagłówków jako "bardzo ważne" oraz "nieco mniej ważne".
Jest `=over` do tworzenia wcięć oraz `=item`
to tworzenia punktów, oraz parę innych.

Istnieje `=cut` do oznaczania końca sekcji POD oraz
`=pod` do jej rozpoczęcia. Chociaż rozpoczynanie nie jest ścićle wymagane.

Każdy ciąg znaków zaczynający się od znaku równości `=` jako pierwszego znaku, będzie
interpretowany jako znacznik POD, i rozpocznie sekcję POD zamykaną przez `=cut`.

POD pozwala nawet na umieszczanie hiperłączy przy użyciu notacji L&lt;jakiś-link>

Teks pomiędzy częściami znaczników będzie pokazany jako akapity czystego tekstu.

Jeśi tekst nie zacznie się od pierwszego znaku w linii, będzie traktowany dosłownie,
czyli będzie wyglądał dokładnie tak, jak został wpisany: długie linie pozostaną
długimi liniami, a krótkie pozostaną krótkie. Może to być wykorzystane do przykładów kodu.

Ważną rzeczą do zapamiętania jest to, że POD wymaga pustych wierszy dookoła tagów.
Zatem

```perl
=head1 Title
=head2 Subtitle
Some Text
=cut
```

nie zrobi tego, czego oczekujesz.

## Wygląd
Jako że POD jest językiem znaczników, sam z siebie nie definiuje, jak rzeczy zostaną wyświetlone.
Używanie `=head1` wskazuje na coś ważnego, `=head2` oznacza coś mniej ważnego.

Narzędzie używane do wyświetlania POD zwykle użyje większych znaków do wyświetlenia
tekstu head1, niż do head2, który z kolei będzie wyświetlony przy użyciu większych fontów niż zwykły
tekst. Kontrola jest w rękach narzędzia do wyświetlania.

Polecenia `perldoc`, które jest dystrybuowane z perlem, wyświetla POD jako stronę man. Jest to całkiem przydatne na Linuksie.
Nie tak bardzo na Windows.

Moduł [Pod::Html](https://metacpan.org/pod/Pod::Html) dostarcza kolejne narzędzie pracujące w wierszu poleceń
zwane `pod2html`. Potrafi ono konwertować POD na dokument HTML, który możesz obejrzeć w przeglądarce.

Istnieją też dodatkowe narzędzia do generowania pdf czy mobi z POD.

## Kto jest obiorcą?

Po zapoznaniu sie z techniką, zobaczmy, kto jest obiorcą?

Komentarze (to, co zaczyna się od #) są wyjaśnieniami dla
programistów. Dla osoby, która potrzebuje dodawać funkcjonalności
lub poprawiać błędy.

Dokumentacja napisana w POD jest dla użytkowników. Dla ludzi, którzy
nie powinni patrzeć na kod źródłowy. W przypadku aplikacji tych, którzy są
nazywani "użytkownikami końcowymi". Czyli dla każdego.

W przypadku modułów Perla, użytkownikami są także inni programiści Perla,
którzy potrzebują tworzyć aplikację lub inne moduły. Oni nadal nie powinni
musieć patrzeć w Twój kod źródłowy. Powinni być w stanie używać
Twojego modułu po prostu czytając dokumentację przy użyciu
polecenia `perldoc`.

## Podsumowanie

Pisanie dokumentacji i sprawienie, by wyglądała ładnie, nie jest tak trudne w Perlu.


