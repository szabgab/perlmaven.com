---
title: "Podstawowa dokumentacja Perla i dokumentacja modułów CPAN"
timestamp: 2015-07-21T10:45:56
tags:
  - perldoc
  - documentation
  - POD
  - CPAN
published: true
books:
  - beginner
author: szabgab
original: core-perl-documentation-cpan-module-documentation
translator: rozie
---


Perl przychodzi z mnóstwem dokumentacji, ale
potrzeba nieco czasu, zanim przywykniesz do używania jej. W tej części
[samouczka Perla](/perl-tutorial) wyjaśnię jak
odnaleźć się pośród dokumentacji.


## perldoc w sieci

Najwygodniejszym sposobem dostępu do podstawowej dokumentacji perla
jest odwiedzenie strony [perldoc](http://perldoc.perl.org/).

Zawiera ona wersję HTML dokumentacji Perla, języka,
a także modułów, które przychodzą z podstawowym Perlem, jak zostały wydane przez Perl 5 Porters.

Nie zawiera ona dokumentacji modułów CPAN.
Istnieje jednak zazębienie, ponieważ część modułów jest zarówno dostępna
przez CPAN, jak i włączona do standardowej dystrybucji Perla.
(Często odnosi się do nich jako <b>dual-lifed</b>.)

Możesz użyć pola wyszukiwania w prawym górnym rogu. Na przykład możesz
wpisać `split` i otrzymasz dokumentację `split`.

Niestety, zwykle nie wie co zrobić z `while`, ani z
`$_` czy `@_`. W celu wyjaśnienia tych pojęć
będziesz musiał przejrzeć dokumentację.

Najważniejszą stroną może być [perlvar](http://perldoc.perl.org/perlvar.html),
gdzie znajdziesz informację o zmiennych takich jak `$_` oraz `@_`.

[perlsyn](http://perldoc.perl.org/perlsyn.html) wyjaśnia składnię Perla
włącznie z [pętlą while](/while-loop).

## perldoc w wierszu poleceń

Ta sama dokumentacja przychodzi z kodem źródłowym Perla, ale nie
każda dystrybucja Linuksa instaluje go domyślnie. W niektórych przypadkach
jest to osobny pakiet. Na przykład w Debianie i Ubuntu jest to pakiet
<b>perl-doc</b>. Musisz go zainstalować używając `sudo aptitude install perl-doc`,
zanim będziesz mógł skorzystać z `perldoc`.

Gdy już go zainstalujesz, możesz wpisać `perldoc perl` w wierszu poleceń
i otrzymasz nieco wyjaśnień oraz listę rozdziałów dokumentacji Perla.
Możesz wyjść z tego przy użyciu klawisza `q`, a następnie wpisać nazwę jednego z rozdziałów.
Na przykład: `perldoc perlsyn`.

Działą to zarówno na Linuksie jaki i na Windows, chociaż narzędzie stronicujące na Windows jest naprawdę słabe,
więc nie mogę go polecić. Na linuksie jest to zwykły czytnik man, więc powinieneś być
już z nim obeznany.

## Dokumentacja modułów CPAN

Każdy moduł na CPAN jest rozpowszechniany z dokumentacją i przykładami.
Ilość i jakość tej dokumentacji różni się znacznie
pomiędzy autorami, a nawet jeden autor może tworzyć bardzo
dobrze udokumentowane i bardzo słabo udokumentowane moduły.

Po instalacji modułu zwanego Module::Name,
masz dostęp do dokumentacji przez wpisanie `perldoc Module::Name`.

Jest jednak bardziej wygodna droga, która nie wymaga nawet
instalacji modułu. Istnieje kilka interfejsów webowych
do CPAN. Główne z nich to [Meta CPAN](http://metacpan.org/)
oraz [search CPAN](http://search.cpan.org/).

Oba bazują na tej samej dokumentacji, ale
dostarczają nieco innych doświadczeń.

## Szukanie słów kluczowych na Perl Maven

Niedawnym dodatkiem do tej strony jest wyszukiwarka słów kluczowych w górnej belce menu.
Powoli znajdziesz wytłumaczenie dla coraz to większych obszarów perla.
W jednym z punktów będzie też część podstawowej dokumentacji perla i
dokumentacja najważniejszych modułów CPAN.

Jeśli brakuje Ci czego z tych obszarów, po prostu zostaw komentarz poniżej,
ze słowami kluczowymi, których będziesz szukał, a jest spora szansa, że
Twoje życzenie się spełni.
