---
title: "Perl Editor"
timestamp: 2015-06-24T12:45:56
tags:
  - IDE
  - editor
  - Padre
  - vim
  - emacs
  - Eclipse
  - Komodo
published: true
books:
  - beginner
author: szabgab
translator: rozie
original: perl-editor
---


Perlowe skrypty czy programy w Perlu są po prostu prostymi plikami tekstowymi.
Możesz do ich tworzenia używać dowolnego rodzaju edytora tekstu, ale nie powinieneś
korzystać z procesora tekstu. Pozwól, że zasugeruję kilka edytorów oraz IDE.

BTW, ten artykuł jest częścią [samouczka Perla](/perl-tutorial).


Możesz też obejrzeć video o [edytorach i IDE](/beginner-perl-maven-editors).

## Edytor czy IDE?

Do programowania w Perlu możesz korzystać zarówno ze zwykłych edytorów tekstu jak i z
<b>Zintegrowanych Środowisk Programistycznych</b>, zwanych inaczej IDE.

Najpierw opiszę edytory na głównych platformach z których możesz korzystać,
następnie IDE, które są zwykle niezależne od platformy.

## Unix / Linux

Jeśli pracujesz na Linuksie lub Uniksie, wówczas najpopularniejsze edytory to
[Vim](http://www.vim.org/) oraz
[Emacs](http://www.gnu.org/software/emacs/).
Mają bardzo różną filozofię, zarówno od siebie nawzajem, jak i od większości innych edytorów.

Jeśli znasz którykolwiek z nich, zalecałbym używanie właśnie jego.

Dla każdego z nich istnieją specjalne rozszerzenia lub tryby, które zapewniają lepsze wsparcie dla Perla,
ale nawet bez nich są one bardzo dobre do programowania w Perlu.

Jeśli nie jesteś obeznany z tymi edytorami, prawdopodobnie zalecałbym,
abyś oddzielił swoją krzywą uczenia w Perlu od swojego doświadczenia z nauką edytorów.

Oba te edytory są bardzo potężne, ale ich opanowanie wymaga wiele czasu.

Prawdopodobnie lepiej jest skupić się teraz na nauce Perla, a później zająć nauką jednego
z tych edytorów.

Choć natywnie pochodzą z Uniksa/Linuksa, zarówno
<b>Emacs</b> jak i <b>Vim</b> są dostępne na wszystkich ważniejszych systemach operacyjnych.

## Edytory Perla dla Windows

Na Windows, wielu ludzi używa tak zwanych "edytorów Programistycznych

* [Ultra Edit](http://www.ultraedit.com/) jest edytorem płatnym.
* [TextPad](http://www.textpad.com/) to shareware.
* [Notepad++](http://notepad-plus-plus.org/) jest wolnoźródłowym i darmowym edytorem.

Korzystałem wiele z <b>Notepad++</b> i nadal mam go zainstalowanego na mojej maszynie z Windows,
ponieważ potrafi być bardzo użyteczny.

## Mac OSX

Nie posiadam Maka, ale zgodnie z ankietą popularności,
[TextMate](http://macromates.com/) jest najczęściej używanym edytorem
do programowania w Perlu na Makach.

## Perlowe IDE

Żaden z wyżej wymienionych nie jest IDE, co znaczy, że żaden z nich nie zapewnia
prawdziwego, wbudowanego debuggera dla Perla. Także żaden z nich nie oferuje właściwej dla języka pomocy.

[Komodo](http://www.activestate.com/) od ActiveState kosztuje parę setek dolarów.
Istnieje wersja darmowa o ograniczonych możliwościach.

Ludzie, którzy już są użytkownikami [Eclipse](http://www.eclipse.org/) mogą chcieć wiedzieć,
że istnieje plugin do Perla dla Eclipse zwany EPIC. Istnieje także projekt zwany
[Perlipse](https://github.com/skorg/perlipse).

## Padre, Perlowe IDE

W lipcu 2008 zacząłem pisać <b>IDE dla Perla w Perlu</b>. Nazwałem to Padre -
Perl Application Development and Refactoring Environment albo
[Padre, the Perl IDE](http://padre.perlide.org/).

Wielu ludzi dołączyło do projektu. Jest rozpowszechniany przez większe dystrybucje Linuksa
a także może być zainstalowany z CPAN. Po szczegóły zapraszam na stronę
[download](http://padre.perlide.org/download.html).

W wielu aspektach nadal nie jest tak mocne jak Eclipse czy Komodo, ale w paru innych,
szczególnych dla Perla obszarach juz jest lepsze niż tamte dwa.

Co więcej, jest bardzo aktywnie rozwijane.
Jeśli szukasz <b>edytora Perla</b> lub <b>IDE Perla</b>,
zalecałbym, abyś je wypróbował.

## Wielka ankieta edytorów Perla

W październiku 2009 przeprowadziłem ankietę i zapytałem
[Z jakiego edytora(-ów) czy IDE korzystasz do programowania w Perlu?](http://perlide.org/poll200910/)

Teraz możesz iść z prądem, pod prąd, albo wybrać edytor perla, który Ci pasuje.

## Inne

Alex Shatlovsky poleca [Sublime Text](http://www.sublimetext.com/), który jest edytorem niezależnym od platformy,
ale kosztującym pieniądze.

## Dalej

Następna część samouczka jest małym krokiem w bok aby omówić [Perla w wierszu poleceń](/perl-on-the-command-line).
