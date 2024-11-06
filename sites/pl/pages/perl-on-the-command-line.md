---
title: "Perl w wierszu poleceń"
timestamp: 2015-07-12T14:45:56
tags:
  - -v
  - -e
  - -p
  - -i
published: true
books:
  - beginner
author: szabgab
original: perl-on-the-command-line
translator: rozie
---


Chociaż większość [Perl tutorial](/perl-tutorial) traktuje o skryptach zapisanych w
pliku, zapoznamy się także z przykładami <b>jednolinijkowców</b>.

Nawet jeśli korzystasz z [Padre](http://padre.perlide.org/)
albo jakiegoś innego IDE które pozwoliłoby Ci uruchamiać skrypty z samego edytora,
jest bardzo ważne zapoznanie się z wierszem poleceń (powłoką) i
bycie w stanie używanie Perla z niego.


Jeśli używasz Linuksa, otwórz okno terminala. Powienieneś zobaczyć
znak zachęty (prompt), prawdopodobnie zakończony znakiem $.

Jeśli używasz Windows, otwórz wiersz poleceń: Kliknij na

Start -> Uruchom -> wpisz "cmd" -> ENTER

Start -> Run -> type in "cmd" -> ENTER

Zobaczysz czarne okno CMD ze znakiem zachęty, który prawdopodobnie wygląda następująco:

```
c:\>
```

## Wersja Perla

Wpisz `perl -v`. Wyświetli to coś w stylu:

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

Na tej podstawie możesz stwierdzić, że na tej maszynie z Windows mam Perla w wersji 5.12.3.

## Wyświetlanie liczby

Teraz wpisz `perl -e "print 42"`.
To polecenie wyświetli liczbę `42` na ekranie. Pod Windows, znak zachęty pojawi się w następnej linii

```
c:>perl -e "print 42"
42
c:>
```

Pod Linuksem zobaczysz coś w stylu:

```
gabor@pm:~$ perl -e 'print 42'
42gabor@pm:~$
```

Zauważ, że użyłem pojedynczego cudzysłowu (apostrofu) `'` pod Linuskem a podwójnego `"` na Windows.
Zrobiłem to z powodu różnego zachowania wiersza poleceń w tych dwóch systemach operacyjnych.
Nic związanego z Perlem. Ogólnie, na Linux/Unix zawsze używaj pojedynczych cudzysłowów wokół kodu,
na Windows zawsze używaj podwójnych.

Wynik jest na początku linii, natychmiast za nim jest znak zachęty.
Ta różnica wynika z różnego zachowania obu interpreterów wiersza poleceń.

W tym przykładzie używamy flagi `-e`, która mówi perlowi,
"Nie oczekuj pliku. Następna rzecz w wierszu poleceń to faktyczny kod Perla."

Powyższe przykłady nie są oczywiście zbyt interesujące. Pozwól, że pokażę Ci coś nieco bardziej złożony
przykład, bez wyjaśniania go:

## Zamiana Java na Perl

To polecenie: `perl -i.bak -p -e "s/\bJava\b/Perl/" resume.txt`
zamieni wszystkie wystąpienia słowa <b>Java</b> na słowo <b>Perl</b> Twoim
CV, z zachowaniem kopii pliku.

Pod Linuksem możesz nawet napisać `perl -i.bak -p -e 's/\bJava\b/Perl/' *.txt`
by zamienić Java na Perl we <b>wszystkich</b>swoich plikach tekstowych.

(Ponownie zauważ, że na Linuksie/Uniksie powinieneś prawdopodobnie zawsze używać pojedynczych cudzysłowów w wierszu poleceń,
podczas gdy na Windows podwójnych.)

W późniejszej części będziemy więcej mówić o jednolinijkowcach i nauczysz się, jak z nich korzystać.
Wystarczy powiedzieć, że znajomość jednolinijkowców to bardzo potężna broń w Twoich rękach.

BTW Jeśli jesteś zainteresowany bardzo dobrymi jednolinijkowcami, polecam lekturę
[Perl One-Liners explained](http://www.catonmat.net/blog/perl-book/) autorstwa
Peterisa Kruminsa.

Jeśli potrzebujesz zrobić to samo zadanie, ale jako część większego skryptu, zobaczysz
artykuł [jak zastąpić ciąg znakó w pliku](/how-to-replace-a-string-in-a-file-with-perl).

## Dalej

Kolejna część jest o
[podstawowej dokumentacji Perla oraz dokumentacji modułó CPAN](/core-perl-documentation-cpan-module-documentation).
