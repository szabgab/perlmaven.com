---
title: "Linia hash-bang czyli jak uruchamiać skrypty Perla pod Linuksem"
timestamp: 2015-06-24T19:03:01
tags:
  - "#!"
  - -w
  - -t
  - -T
  - /usr/bin/perl
published: true
books:
  - beginner
author: szabgab
translator: rozie
original: hashbang
---


W [pierwszych skryptach](/instalacja-perla-i-rozpoczecie-pracy), które pisaliśmy, nie ma tego
konstruktu, ale może on być przydatny w skryptach Perla na systemach uniksowych takich jak Linux czy Mac OSX.

Nie jest tak naprawdę wymagany, możesz po prostu ominąć ten artykuł i wrócić później, kiedy będziesz chciał zrozumieć co
znaczy `#!/usr/bin/perl` na początku wielu skryptów Perla.


Zanim przejdę do szczegółów, pozwól mi powiedzieć, że tak linia jest także nazywana she-bang, 
[Shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) lub sh-bang, a także innymi nazwami.

Pierwszy program, którego zwykle uczą się ludzie, to zwykle "Hello world". Oto skrypt:

```perl
use strict;
use warnings;
 
print "Hello World\n";
```

Możemy go zapisać do pliku nazwanego `hello.pl`, otworzyć terminal (lub Cmd pod Windows). `cd` do katalogu gdzie zapisaliśmy plik
i uruchomić skrypt przez wpisanie `perl hello.pl`.

To znaczy, uruchamiamy Perla i mówimy mu, by wykonał nasz skrypt.

Czy byłoby możliwe wykonanie skryptu bez wcześniejszego uruchomienie perla? Czy byłoby możliwe po prostu uruchomić `hello.pl`?

W systemach uniksowych jest to całkiem proste. Pod Windows jest to całkiem inna historia i zostanie poruszona oddzielnie.

## hash-bang w systemach uniksowych

Spróbujmy uruchomić skrypt:

```
$ hello.pl
-bash: hello.pl: command not found
```

Nasze środowisko nie może znaleźć skryptu.

Co jeśli podamy ścieżkę do skryptu (który jest i tak w bieżącym katalogu):

```
$ ./hello.pl
-bash: ./hello.pl: Permission denied
```

Teraz już znajduje skrypt, ale nie ma uprawnień do jego uruchomienia.

Na Linuksie czy Mac OSX, czy każdym innym systemie uniksowym możemy uczynić skrypt "wykonywalnym" przez ustawienie bitu w standardowych atrybutach pliku
w tak zwanej [tablicy inode'ów](https://en.wikipedia.org/wiki/Inode).
Można to łatwo zrobić używając polecenia `chmod`. Użyjemy `chmod u+x hello.pl`:

Najpierw użyjemy polecenia `ls -l` powłoki Uniksa aby zobaczyć sytuację przed,
następnie użyjemy `chmod` do zmiany uprawnień,
a na końcu sprawdzimy sytuację po tej operacji.
Część `u+x` operacji mówi chmod aby dodał prawa wykonania (x) dla użytkownika (u), który jest właścicielem tego pliku,
ale dla nikogo innego. (`chmod +x hello.pl` przyznałoby prawa wykonania każdemu w systemie.)

```
$ ls -l hello.pl
-rw-r--r--  1 gabor  staff  50 Apr 21 10:11 hello.pl

$ chmod u+x hello.pl 

$ ls -l hello.pl 
-rwxr--r--  1 gabor  staff  50 Apr 21 10:11 hello.pl
```

Zwróć uwagę na dodatkowy `x` jako czwarty znak odpowiedzi.

Spróbujmy uruchomić skrypt ponownie:

```
$ ./hello.pl 
./hello.pl: line 1: use: command not found
./hello.pl: line 2: use: command not found
./hello.pl: line 4: print: command not found
```

Znacznie lepiej :)

Teraz możemy już uruchomić skrypt, ale nie robi on tego, co chcemy. W rzeczywistości narzeka, że nie może
znaleźć poleceń 'use' ani 'print'. To co się tu wydarzyło to to, że powłoka, której używamy (prawdopodobnie bash) próbował
interpretować polecenia w pliku, ale nie znalazł takich poleceń jak `use` czy `print`
w Linuksie/Uniksie. W jakiś sposób musimy powiedzieć powłoce, że jest to skrypt perlowy. Służy do tego hash-bang.
 
Jeśli wyedytujemy plik i dodamy


```
#!/usr/bin/perl
```

jako pierwszą linię skryptu i bez spacji, a następnie spróbujemy uruchomić skrypt ponownie:

```
$ ./hello.pl 
Hello World
```

działa już jak oczekujemy.

Jednakże, jeśli spróbujemy uruchoić go bez `./`, nadal nie będzie mógł go znaleźć:

```
$ hello.pl
-bash: hello.pl: command not found
```

W celu rozwiązania tego musimy zmienić zmienną środowiskową `PATH`. Jako, że skupiamy się głównie
na linii hash-bang, nie chcę wchodzić w dalsze dokładnie wyjaśnienia, więc pozwól, że po prostu podam Ci polecenie:

```
$ PATH=$PATH:$(pwd)
```

dołączające bieżący katalog do listy katalogów w zmiennej środowiskowej PATH.
Gdy to zrobimy, możemy teraz uruchomić:

```
$ hello.pl
Hello World
```

## Jak działa linia hash-bang?

Dodaliśmy `#!/usr/bin/perl` jako pierwszą linię naszego skryptu:

Kiedy uruchamiamy skrypt, uruchamiamy go w środowisku naszej bieżącej powłoki. Dla większości ludzi pod Linuksem/Uniksem będzie to Bash.
Bash przeczyta pierwszą linię skryptu. Jeśli zaczyna się ona od hasha i wykrzyknikiem (hash-bang) `#!`,
wówczas Bash uruchomi aplikację, której ścieżka jest w linii hash-bang (w naszym przypadku `/usr/bin/perl`,
co jest standardową lokalizacją kompilatora-interpretera perl na większości współczesnych systemów Uniksowych).

Linia hash-bang zawiera ścieżkę do kompilatora-interpretera Perla.

Jeśli pierwsza linia nie zaczyna się od `#!`, jak miało to miejsce w naszym pierwotnym skrypcie, Bash będzie przypuszczał,
że jest to skrypt napisany w Bashu i będzie próbował zrozumieć go samodzielnie. Właśnie to powodowało błędy.

## Alternatywne linie hash-bang z użyciem env

Choć używaliśmy `#!/usr/bin/perl` jako naszą linię hash-bang, może ona wyglądać inaczej. Na przykłąd jeśli zainstalowaliśmy
inną wersję perla w innej lokalizacji i chcemy, by nasze skrypty z niej korzystały, możemy podać ścieżkę
do tej wersji perla. Na przykład `#!/opt/perl-5.18.2/bin/perl`.

Przewaga ustawienia hash-bang (i włączenia bitu wykonywalności) jest taka, że użytkownik nie musi
wiedzieć, że skrypt jest napisany w Perlu i jeśli masz wiele instancji Perla w swoim systemie,
linia hash-bang może zostać użyta do wybrania, która wersja perla ma być użyta. Będzie ona taka sama dla wszytkich
ludzi na danej maszynie.
Wada jest taka, że wersja perla wymieniona w linii hash-bang jest wykorzystywana tylko, gdy skrypt jest uruchamiany
jako `./hello.pl` lub jako `hello.pl`.
Jeśli zostanie uruchomiony jako `perl hello.pl`, wykorzysta wersję perla, która zostanie znaleziona jako pierwsza
w katalogach wymienionych w PATH. I może ona być inna, niż wersja perla z linii hash-bang.

Z tego powodu, na współczesnych systemach Linux/Unix, ludzie mogą preferować użycie `#!/usr/bin/env perl` jako
linii hash-bang. Kiedy Bash zobaczy taką linię, najpierw wykona polecenie `env` przekazując `perl` do niego.
`env` znajdzie pierwszego perla w katalogach PATH i uruchomi go.
Zatem jeśli mamy `#!/usr/bin/env perl` w naszym skrypcie, zawsze będzie on korzystac z pierwszego perla w naszym PATH.
Zarówno, jeśli zostanie wywołany jako `./hello.pl`, jak i gdy zostanie wywołany przez `perl hello.pl`.
Ma to także wadę, ponieważ polega na właściwym ustawieniu zmiennej PATH przez użytkowników.

Oto tabela, która próbuje wyjaśnić 4 przypadki:

```
  hash-bang                  Który perl jest używany do uruchomienia skryptu przy wywołaniu:
                             ./hello.pl                    perl hello.pl

  /usr/bin/perl              /usr/bin/perl                 pierwszy perl w PATH
  /usr/bin/env perl          pierwszy perl w PATH          pierwszy perl w PATH
```


## Flagi w linii hash-bang

W linii hash-bang, po ścieżce do perla, możemy przekazać perlowi flagi wiersza poleceń.
Prawdopodobnie zobaczysz wiele skrytpów zaczynających się od `#!/usr/bin/perl -w` czy
może `#!/usr/bin/env perl -w`.
`-w` w tym hash-bangu włącza ostrzeżenia. Jest to zupełnie podobne do tego, co robi
[use warnings](/instalacja-perla-i-rozpoczecie-pracy), ale jest użyte w starym stylu.
Nie zobaczysz tego w większości współczesnych skryptów Perla.

Kolejne popularne flagi, które możesz zobaczyć w linii hash-bang to `-t` i `-T`. Włączają
one tak zwany <b>taint-mode</b>, który pomaga pisać bezpieczniejszy kod.
