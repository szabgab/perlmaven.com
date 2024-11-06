---
title: "Crearea fișierelor cu Perl"
timestamp: 2013-04-13T13:19:00
tags:
  - open
  - close
  - write
  - die
  - open or die
  - >
  - encoding
  - UTF-8
published: true
original: writing-to-files-with-perl
books:
  - beginner
author: szabgab
translator: stefansbv
---


Multe programe Perl au de-a face cu fișiere text, cum ar fi fișiere de
configurare sau fișiere log, deci ca să facem aceste cunoștințe utile
este important să învățăm despre lucrul cu fișiere într-un stadiu
timpuriu.

Să vedem mai întâi cum putem scrie într-un fișier, pentru că asta pare
a fi mai ușor de făcut.


Înainte de a putea scrie într-un fișier trebuie să-l deschidem
cu <b>open()</b>, cerând sistemului de operare (Windows, Linux, OSX,
etc) să deschidă un canal de comunicație, pentru ca programul să poată
"vorbi cu" fișierul. Pentru asta Perl prevede funcția `open`,
funcție care are o sintaxă puțin mai ciudată.

```perl
use strict;
use warnings;

my $filename = 'report.txt';
open(my $fh, '>', $filename) or die "Nu pot deschide fisierul '$filename' $!";
print $fh "Primul meu raport generat de Perl\n";
close $fh;
print "gata\n";
```

Acesta este un bun exemplu de lucru și ne vom întoarce la el, dar să
începem cu un exemplu mai simplu:

## Exemplu Simplu

```perl
use strict;
use warnings;

open(my $fh, '>', 'report.txt');
print $fh "Primul meu raport generat de Perl\n";
close $fh;
print "gata\n";
```

Aceasta necesită câteva explicații. Funcția <b>open</b> are 3 parametri.

Primul, `$fh`, este o variabilă de tip scalar pe care am
definit-o în cadrul apelului funcției `open()`.  Am fi putut să
o definim mai devreme, dar de obicei este mai curat în felul acesta,
chiar dacă arată un pic mai ciudat la început. Al doilea parametru
definește modul de deschidere al fișierului.  În acest caz, acesta
este semnul mai-mare (`&gt;`) acesta înseamnă că deschidem
fișierul pentru scriere.  Al treilea parametru este calea către
fișierul pe care dorim să-l deschidem.

Când este apelată acestă funcție, Perl, pune un semn special în
variabila `$fh`. Se numește file-handle (în limba engleză), o
referință către canalul de comunicare cu fișierul. Nu ne pasă prea
mult care este conținutul aceste variabile; vom folosi acestă
variabilă mai târziu. De reținut că ceea ce conține fișierul este
numai pe disc și <b>NU</b> în variabila $fh.

Odată fișierul deschis putem folosi file-handle-ul `$fh` într-o
comandă `print()`.  Arată aproape la fel ca o
comandă `print()` din celelalte părți ale tutorialului, dar
acum, primul parametru este file-handle și <b>nu</b>(!) este virgulă
după el.

Comanda print() de mai sus va  printa textul în fișier.

Apoi cu linia următoare închidem file-handle-ul. Strict vorbind,
acesta nu este o cerință în Perl. Perl va închide automat și curat
toate referințele file-handle când variabilele nu mai sunt vizibile
(en: out of scope), sau cel mai târziu la terminarea execuției
scriptului.  În orice caz, poate fi considerată o bună practică
închiderea explicită a fișierelor.

Ultima linie `print "gata\n"` este doar pentru ca următorul
exemplu să fie mai clar:

## Gestionarea Erorilor

Să reluăm exemplul de mai sus și să înlocuim numele fișierului cu o
cale inexistentă.  De exemplu:

```perl
open(my $fh, '>', 'some_strange_name/report.txt');
```

Dacă rulezi scriptul acum vei primi un mesaj de eroare:

```
print() on closed file handle $fh at ...
done
```

De fapt acesta este doar o atenționare; scriptul rulează în continuare
și de aceea vedem cuvântul "gata" printat pe ecran.

Chiar mai mult, am primit atenționarea doar pentru că am cerut
explicit acest lucru cu comanda `use warnings`.  Încercați să
comentați linia `use warnings` și veți vedea că scriptul va
eșua în operațiunea de creare a fișierului în mod silențios. Deci nu
veți observa până când clientul, sau - mai rău - șeful vostru se va
plânge.

Oricum este o problemă. Am încercat să deschidem un fișier. Am eșuat
dar totuși am încercat să printăm ceva în el.

Mai bine am verifica dacă `open()` a fost cu succes înainte de
a continua.

Din fericire comanda `open()` ea însăși returnează
<a href="https://perlmaven.com/boolean-values-in-perl">ADEVĂR la
succes și FALS la eșec</a>, deci putem scrie așa:

## Open or die

```perl
open(my $fh, '>', 'some_strange_name/report.txt') or die;
```

Acesta este un idiom "standard": <b>open or die</b>. Foarte comun în Perl.

`die` este un apel de funcție care va genera o excepție și
astfel va termina execuția scriptului.

"open or die" este o expresie logică. Așa cum știți din părțile
precedente ale tutorialului, "or" scurtcircuitează în Perl (așa ca în
multe alte limbaje).  Acesta înseamnă că dacă partea dreptă returnează
ADEVĂR, știm că întreaga expresie va fi ADEVĂRATĂ, și partea dreaptă
nici nu mai este executată. Pe de altă parte dacă partea stângă este
FALSĂ atunci și partea dreaptă este executată și rezultatul ei devine
rezultatul întregii expresii.

În acest caz folosim acest scurtcircuit pentru a scrie expresia.

Dacă comanda `open()` este cu succes atunci returnează ADEVĂR
și astfel partea dreaptă nu mai este executată. Scriptul continuă cu
linia următoare.

Dacă comanda `open()` eșuează, atunci va returna FALS. Atunci
partea dreaptă a `or` este de asemenea executată. Generează o
excepție, care termină scriptul.

În codul de mai sus nu verificăm rezultatul efectiv al operațiunilor
logice. Nu ne pasă. Am folosit-o doar pentru "efectul secundar".

Dacă încerci scriptul cu modificările de mai sus vei obține un mesaj
de eroare:

```
Died at ...
```

și NU va printa "gata".

## O mai bună raportare a erorilor

În loc să apelăm "die" fără parametri, am putea adăuga câteva
explicații despre ce s-a întâmplat.

```perl
open(my $fh, '>', 'some_strange_name/report.txt')
  or die "Nu pot deschide fisierul 'some_strange_name/report.txt'";
```

va printa

```
  Nu pot deschide fisierul 'some_strange_name/report.txt' ...
```

Este mai bine, dar al un moment dat cineva va încerca să schimbe calea
la directorul corect...

```perl
open(my $fh, '>', 'correct_directory_with_typo/report.txt')
  or die "Nu pot deschide fisierul 'some_strange_name/report.txt'";
```

... dar vei obține tot vechiul mesaj de eroare pentru că ei au
modificat numai în apelul funcției open(), nu și în mesajul de eroare.

Este, probabil, mai bine de folosit o variabilă pentru numele
fișierului:

```perl
my $filename = 'correct_directory_with_typo/report.txt';
open(my $fh, '>', $filename) or die "Nu pot deschide fisierul '$filename'";
```

Acum primim mesajul de eroare corect, dar tot nu știm de ce a eșuat.
Mergând cu un pas mai departe putem folosi `$!` - o variabilă
integrată în Perl - pentru a printa ce ne-a transmis sistemul de
operare în legătură cu eșecul.

```perl
my $filename = 'correct_directory_with_typo/report.txt';
open(my $fh, '>', $filename) or die "Nu pot deschide fisierul '$filename' $!";
```

Rezultatul va fi

```
Nu pot deschide fisierul 'some_strange_name/report.txt' No such file or directory ...
```

Asta este mult mai bine.

Acum să ne întoarcem la exemplul original.

## Mai-mare-decât?

Acel semn mai-mare-decât în apelul funcției open() ar putea fi puțin
neclar, dar dacă ești familiarizat cu redirectarea în linia de comandă
atunci acesta este similar.  Altfel interpretează-o ca pe o săgeată
care indică direcția curgerii datelor, în fișierul din partea dreaptă.

## Caractere nelatine?

În cazul în care este nevoie să folosești caractere care nu sunt în
tabelul ASCII, probabil vei dori să le salvezi ca UTF-8. Pentru acesta
trebuie să înștiințezi Perl, că fișierul este codat UTF-8.

```perl
open(my $fh, '>:encoding(UTF-8)', $filename)
  or die "Nu pot deschide fișierul '$filename'";
```
