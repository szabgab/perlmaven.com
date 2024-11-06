---
title: "Instalacja i rozpoczęcie pracy z Perlem"
timestamp: 2015-06-20T10:45:56
tags:
  - strict
  - warnings
  - say
  - print
  - chomp
  - scalar
  - $
  - STDIN
  - <STDIN>
types:
  - screencast
published: true
books:
  - beginner
author: szabgab
original: installing-perl-and-getting-started
translator: rozie
---


To pierwsza część [samouczka Perla](/perl-tutorial).

W tej części nauczysz się jak zainstalować Perla w systemie Microsoft Windows i jak zacząć
korzystać z niego na Windows, Linuksie czy na Macu.

Dostaniesz wskazówki jak ustawić swoje środowisko deweloperskie, albo w mniej pretensjonalnych słowach:
z którego edytora czy IDE korzystać do pisanie w Perlu?

Zobaczymy także standardowy przykład "Hello World".


Możesz także [obejrzeć odpowiednie video](https://perlmaven.com/beginner-perl-maven-installation).

## Windows

W przypadku Windows będziemy korzystać z [DWIM Perl](http://dwimperl.com/). Jest to pakiet
zawierający kompilator/interpreter Perla, [Padre, the Perl IDE](http://padre.perlide.org/)
oraz pewną ilość rozszerzeń z CPAN.

W celu rozpoczęcia odwiedź stronę [DWIM Perl](http://dwimperl.com/) i podążaj
za linkiem aby pobrać <b>DWIM Perl for Windows</b>.

Dalej, pobierz plik exe i zainstaluj go w swoim systemie. Zanim to zrobisz upewnij się proszę, że
nie masz zainstalowanego żadnego innego Perla w swoim systemie.

Mogłyby one działać łącznie, ale to wymagałoby nieco więcej wyjaśnień.
Na ten moment pozostańmy przy jednej wersji Perla zainstalowanej w Twoim systemie.

## Linux

Większość współczesnych dystrybucji Linuksa zawiera ostanią wersje Perla.
Na ten moment będziemy korzystać z tej wersji Perla. Jako edytor, możesz
zainstalować Padre - większość dystrybucji Linuksa oferuje go w swoim
oficjalnym systemie pakietów. W przeciwnym wypadku możesz wybrać jakikolwiek
zwykły edytor tekstu. Jeśli znasz vim lub Emacs, możesz wybrać jeden z nich.
W przeciwnym wypadku Gedit może być dobrym, prostym edytorem.

## Apple

Wierzę, że Maki także dostarczają Perla lub można go łatwo zainstalować
przy użyciu standardowych narzędzi instalacyjnych.

## Edytor i IDE

Chociaż jest to zalecane, nie musisz korzystać z IDE Padre do pisania kodu w Perlu.
W następnej części wymienię kilka [edytorów oraz IDE](https://perlmaven.com/perl-editor) z których
możesz korzystać do swojego programowania w Perlu. Nawet jeśli wybierzesz inny edytor, zalecam
użytkownikom Windows instalację wymienionego wyżej pakietu DWIM Perl.

Ma on dołączonych wiele rozszerzeń Perla, więc zaoszczędzisz wiele czasu w przyszłości.

## Video

Jeśli wolisz, możesz także obejrzeć video
[Hello world with Perl](http://www.youtube.com/watch?v=c3qzmJsR2H0),
które wgrałem na YouTube.

<iframe width="640" height="360" src="//www.youtube.com/embed/c3qzmJsR2H0" frameborder="0" allowfullscreen></iframe>

W takim przypadku możesz także chcieć zapoznać się z 
[Beginner Perl Maven video course](https://perlmaven.com/beginner-perl-maven-video-course).

## Pierwszy program

Twój pierwszy program będzie wyglądał tak:

```perl
use 5.010;
use strict;
use warnings;

say "Hello World";
```

Pozwól, że wyjaśnię go krok po kroku.

## Hello world

Gdy zainstalowałeś DWIM Perl, możesz kliknąć na
"Start -> All programs -> DWIM Perl -> Padre" co otworzy edytor
z pustym plikiem.

Wpisz

```perl
print "Hello World\n";
```

Jak widzisz, wyrażenia w Perlu kończą się się średnikiem `;`.
`\n` jest znakiem, którego używamy aby zapisać nowy wiersz.
Ciągi znaków są zawarte w podwójnych cudzysłowach `"`.
Funkcja `print` wyświetla na ekran.
Gdy zostanie wykonany, ten skrypt wyświetli na ekranie tekst a na jego końcu wyświetli znak nowego wiersza.

Zapisz plik jako hello.pl, a wówczas będziesz mógł uruchomić kod przez wybranie "Run -> Run Script"
Zobaczysz osobne okno pokazujące wynik.

To wszystko, napisałeś swój pierwszy skrypt perlowy.

Rozszerzmy go nieco.

## Perl w wierszu poleceń dla nieużywających Padre

Jeśli nie używasz Padre lub jednego z innych [IDE](https://perlmaven.com/perl-editor)
nie będziesz w stanie uruchomić skryptu z samego edytora.
Przynajmniej nie domyślnie. Będziesz musiał otworzyć wiersz poleceń
(albo cmd w Windows), zmienić katalog na ten w którym zapisałeś plik hello.pl
i wpisać:

`perl hello.pl`

W ten sposób możesz uruchomić skrypt w wierszu poleceń.

## say() zamiast print()

Ulepszmy nieco nasz jednowierszowy skrypt w Perlu:

Przede wszystkim określmy minimalną wersję Perla z której chcielibyśmy korzystać:

```perl
use 5.010;
print "Hello World\n";
```

Kiedy to wpiszesz, możesz uruchomić skrypt ponownie przez wybranie 
"Run -> Run Script" lub wciśnięcie <b>F5</b>.
W ten sposób zostanie automatycznie zapisany do pliku przed uruchomieniem.

Generalnie jest dobrą praktyką określenie minimalnej wersji perla jakiej wymaga Twój kod.

W tym przypadku dodaje to nieco nowych funkcjonalności do perla, łącznie ze słowem kluczowym `say`.
`say` jest jak `print` ale jest krótsze oraz
automatycznie dodaje znak nowego wiersza na końcu.

Możesz zmienić swój kod w ten sposób:

```perl
use 5.010;
say "Hello World";
```

Zastąpiliśmy `print` przez `say` oraz usunęliśmy `\n` z końca ciągu znaków.

Aktualnie zainstalowana wersja z której korzystasz to prawdopodobnie wersja 5.12.3 lub 5.14.
Większość współczesnych dystrybucji Linuksa dostarcza wersję 5.10 lub nowszą.

Niestety, nadal istnieją miejsca ze starszymi wersjami perla.
Nie będą one w stanie korzystać ze słowa kluczowego `say()` i mogą wymagać pewnych
dostosowań w późniejszych przykładach. Będę zwracał uwagę kiedy faktycznie wykorzystuję
funkcjonalności wymagające wersji 5.10.

## Zabezpieczenia

Dodatkowo silnie zalecam dla każdego skryptu dalsze modyfikacje zachowania Perla. Aby to zrobić dodamy 2
tak zwane dyrektywy (pragmy), które są bardzo podobne do flag kompilatora
w innych językach:

```perl
use 5.010;
use strict;
use warnings;

say "Hello World";
```

W tym wypadku słowo kluczowe `use` mówi perlowi aby załadował i wykonał każdą pragmę.

`strict` oraz `warnings` pomogą Ci znaleźć parę popularnych błędów
w kodzie lub nawet uchornią Cię przed popełnieniem ich.
Są bardzo przydatne.

## Wprowadzanie danych

Teraz poprawny nasz przykład przez pytanie użytkownika o imię i zawrzyjmy
je w odpowiedzi.

```perl
use 5.010;
use strict;
use warnings;

say "What is your name? ";
my $name = <STDIN>;
say "Hello $name, how are you?";
```

`$name` nazwywane jest zmienną skalarną (skalarem).

Zmienne są deklarowane przez użycie słowa kluczowego <b>my</b>.
(w rzeczywistości jest to jedno z wymagań dodawanych przez `strict`.)

Zmienne skalarne zawsze rozpoczynają się od znaku `$`.
&lt;STDIN&gt; jest narzędziem do wczytania linii z klawiatury.

Wpisz powyższe i uruchom poprzez naciśnięcie F5.

Zapyta Cię o Twoje imię. Wpisz swoje imię i naciśnij ENTER aby dać perlowi znać
że skończyłeś wpisywanie swojego imienia.

Zauważysz, że wynik jest nieco zepsuty: przecinek po imieniu pojawia się w nowym wierszu.
Dzieje się tak ponieważ ENTER, który nacisnąłeś, gdy wpisywałeś swoje imię,
dostał się do zmiennej `$name`.

## Pozbywanie się znaków nowego wiersza

```perl
use 5.010;
use strict;
use warnings;

say "What is your name? ";
my $name = <STDIN>;
chomp $name;
say "Hello $name, how are you?";
```

Jest to tak częste zadanie w Perlu, że istnieje specjalna funkcja zwana `chomp`
do usuwania znaków nowego wiersza z końca łańcuchów znaków.

## Podsumowanie

W każdym skrypcie który piszesz powinieneś <b>zawsze</b> dodawać `use strict;` i `use warnings;`
jako dwa pierwsze polecenia. Jest także bardzo zalecane dodawanie `use 5.010;`.

## Ćwiczenia

Obiecałem ćwiczenia.

Wypróbuj poniższy skrypt:

```perl
use strict;
use warnings;
use 5.010;

say "Hello ";
say "World";
```

Nie wyświetliło się w jednym wierszu. Czemu? Jak to poprawić?

## Ćwiczenie 2

Napisz skrypt, który poprosi użytkownika o dwie liczby, jedną po drugiej.
Wtedy wyświetl sumę tych dwóch liczb.

## Co dalej?

Następną część samouczka jest o
[edytorach, IDE oraz środowiskach deweloperskich dla Perla.](https://perlmaven.com/perl-editor).
