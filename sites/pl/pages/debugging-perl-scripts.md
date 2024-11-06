---
title: "Debugowanie skryptów Perla"
timestamp: 2015-11-16T09:45:57
tags:
  - -d
  - Data::Dumper
  - print
  - debug
  - debugging
  - $VAR1
  - $VAR2
published: true
books:
  - beginner
author: szabgab
translator: rozie
original: debugging-perl-scripts
---


Kiedy studiowałem informatykę na uczelni, uczyliśmy się wiele o tym jak pisać programy,
ale odkąd pamiętam nikt nie mówił nam o debugowaniu. Słyszeliśmy wiele o pięknym świecie tworzenia
nowych rzeczy, ale nikt nie mówił nam, że większość czasu będziemy musieli spędzać na zrozumieniu
kodu innych ludzi.

Okazuje się, że o ile kochamy pisać program, to spędzamy
o wiele więcej czasu na próbach zrozumienia co my (albo inni) piszą, i dlaczego
zachowuje się to źle, niż na pisaniu go po raz pierwszy.


## Czym jest debugowanie?

Przed uruchomieniem programu wszystko było w dobrze znanym stanie.

Po uruchomieniu programu coś jest jest nieoczekiwane i w złym stanie.

Zadaniem jest znalezienie w którym miejscu coś poszło nie tak i poprawienie tego.

## Czym jest programowanie i czym jest błąd?

Zasadniczo, programowanie to drobna zmiana świata przez przekazywanie danych w zmiennych.

W każdym kroku programu zmieniamy pewne dane w zmiennej w programie, albo coś w "prawdziwym świecie".
(Na przykład na dysku albo na ekranie.)

Kiedy piszesz program, myślisz krokami: jaka wartość powinna być przeniesiona do której zmiennej.

Błąd jest w przypadku, kiedy myślałeś, że przekazujesz do zmiennej wartość X, podczas gdy w rzeczywistości
przekazana została wartość Y.

W pewnym punkcie, zwykle na końcu programu, widzisz, że program wyświetlił nieprawidłową wartość.

Podczas wykonania programu, może się to objawiać wystąpieniem ostrzeżenia lub nienormalnym zakończeniem wykonania programu.

## Jak debugować?

Najprostszym sposobem debugowania programu jest uruchomienie go, i sprawdzanie w każdym kroku, czy wszystkie zmienne
posiadają oczekiwane wartości. Możesz to zrobić albo <b>używając debbugera</b> albo możesz umieścić <b>polecenia print</b> w
programie i sprawdzić wynik później.

Perl przychodzi z bardzo potężnym debbugerem wiersza poleceń. O ile polecam nauczenie się go,
to może być on na początku nieco przerażający. Przygotowałem video, gdzie pokazuję
[podstawowe komendy wbudowanego debuugera Perla](/using-the-built-in-debugger-of-perl).
basic commands of the built-in debugger of Perl</a>.

IDE takie jak [Komodo](http://www.activestate.com/),
[Eclipse](http://eclipse.org/) and
[Padre, the Perl IDE](http://padre.perlide.org/) przychodzą
z graficznym debuggerem. W pewnym momencie przygotuję video także dla kilku z nich. 

## Polecania print

Wielu ludzi używa wiekowej strategii dodawania poleceń print w kodzie.

W językach, gdzie kompilacja i budowa może zająć wiele czasu, polecenia print
są uważane za zły sposób debugowania kodu.
Nie jest tak w Perlu, gdzie nawet duże aplikacje kompilują się i zaczynają działać w przeciągu paru sekund.

Przy dodawaniu poleceń print należy zadbać o dodanie delimiterów wokół wartości. To złapie przypadki
gdzie są otwierające lub kończące spacje, które powodują problem.
Trudno je zauważyć bez delimitera:

Wartości skalarne mogą być wyświetlane tak:

```perl
print "<$file_name>\n";
```

Znaki mniejszości i większości są tu jedynie po to, by czytający mógł łatwiej
zobaczyć dokładną zawartość zmiennej:

```
<path/to/file
>
```

Jeśli powyższe zostanie wyświetlone, możesz łatwo zauważyć, że jest tam kończący znak nowejlinii na końcu zmiennej
$file_name. Prawdopodobnie zapomniałeś wywołać <b>chomp</b>.

## Złożone struktury danych

Nie poznaliśmy jeszcze nawet skalarów, ale pozwól, że przeskoczę do przodu i pokażę Ci, jak
wyświetlić zawartość bardziej złożonych struktur danych. Jeśli czytasz to jako
część samouczka Perla, prawdopodobnie zechcesz pominąć następny wpis i wrócić później.
Nie będzie on dla Ciebie teraz zbyt znaczący.

W innym wypadku, czytaj dalej.

Dla złożonych struktur danych (referencje, tablice oraz hasze) możesz użyć `Data::Dumper`

```perl
use Data::Dumper qw(Dumper);

print Dumper \@an_array;
print Dumper \%a_hash;
print Dumper $a_reference;
```

To wyświetli coś podobnego, co pomoże zrozumieć zawartość zmiennych,
ale pokaże tylko ogólne nazwy zmiennych takie jak `$VAR1` oraz `$VAR2`.

```
$VAR1 = [
       'a',
       'b',
       'c'
     ];
$VAR1 = {
       'a' => 1,
       'b' => 2
     };
$VAR1 = {
       'c' => 3,
       'd' => 4
     };
```

Zalecam dodanie nieco większej ilości kodu i wyświetlenie nazw zmiennych, następująco:

```perl
print '@an_array: ' . Dumper \@an_array;
```

by otrzymać:

```
@an_array: $VAR1 = [
        'a',
        'b',
        'c'
      ];
```

albo, z Data::Dumper, w taki sposób:

```perl
print Data::Dumper->Dump([\@an_array, \%a_hash, $a_reference],
   [qw(an_array a_hash a_reference)]);
```

otrzymując:

```
$an_array = [
            'a',
            'b',
            'c'
          ];
$a_hash = {
          'a' => 1,
          'b' => 2
        };
$a_reference = {
               'c' => 3,
               'd' => 4
             };
```

Istnieją ładniejsze sposoby wyświetlania struktur danych ale w tym momencie `Data::Dumper`
jest wystarczający dla naszych potrzeb i jest on dostępny w każdej instalacji perla.
Inne metody omówimy później.
