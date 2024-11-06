---
title: "Adăugare conținut la fișiere"
timestamp: 2013-04-16T23:30:00
tags:
  - files
  - append
  - open
  - >>
published: true
original: appending-to-files
books:
  - beginner
author: szabgab
translator: stefansbv
---


În acest episod al [Tutorialului de Perl](/perl-tutorial) vom vedea <b>cum să adăugăm conținut la fișiere utilizând Perl</b>.

În episodul trecut am învățat [cum să scriem conținut în fișiere](/crearea-fisierelor-cu-perl).
Acestă abordare este bună atunci când creăm un fișier nou, dar sunt cazuri când am dori mai degrabă să păstrăm conținutul original al fișierului, și să mai adăugăm linii la sfârșit.

Cazul cel ma proeminent este acela al fișierelor log.


Comanda

```perl
open(my $fh, '>', 'report.txt') or die ...
```

Deschiderea unui fișier pentru scriere folosind semnul `>` va șterge conținutul inițial al fișierului.

Dacă vom dori să <b>adăugăm</b> conținut la sfârșitul fișierului, folosim <b>două semne mai-mare</b>, adică `>>` ca în exemplul următor:

```perl
open(my $fh, '>>', 'report.txt') or die ...
```

Folosirea aceste funcții va deschide fișierul în modul pentru adăugare. Acesta înseamnă că fișierul va rămâne intact și tot ce rezultă din operațiunile `print()` sau `say()` către el va fi adăugat la sfârșit.

Acesta este exemplul complet:

```perl
use strict;
use warnings;
use 5.010;

my $filename = 'report.txt';
open(my $fh, '>>', $filename) or die "Nu pot deschide fisierul '$filename' $!";
say $fh "Primul meu raport generat de Perl";
close $fh;
say 'done';
```

Dacă rulați acest script de mai multe ori, veți observa că va crește conținutul lui. Cu fiecare rulare va fi adăugat câte un rând.
