---
title: "POD - Plain Old Documentation"
timestamp: 2013-07-14T20:40:59
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
original: pod-plain-old-documentation-of-perl
books:
  - beginner
author: szabgab
translator: stefansbv
---


Programatorilor, îndeobște, nu le place să scrie documentație.  Unul
dintre motive este acela că deși programele sunt fișiere text, în
multe cazuri dezvoltatorii sunt nevoiți să scrie documentația într-un
procesor de texte.

Aceasta presupune învățarea modului de lucru cu procesorul de texte și
investirea de multă energie pentru a încerca să faci documentul să "arate bine"
în loc de a "avea conținut bun".

Nu este cazul cu Perl.  Uzual vei scrie documentația modulelor chiar
în codul sursă și te vei baza pe unelte externe pentru formatare, ca
să arate bine.


În acest episod al [Tutorialelor Perl](/perl-tutorial) vom
vedea la lucru <b>POD - Plain Old Documentation</b> un limbaj de
marcare folosit de programatorii Perl.

O bucățică de cod simplu cu POD arată așa:

```perl
#!/usr/bin/perl
use strict;
use warnings;

=pod

=head1 DESCRIPTION

This script can have 2 parameters.  The name or address of a machine
and a command. It will execute the command on the given machine and
print the output to the screen.

=cut

print "Here comes the code ... \n";
```

Dacă vei salva codul acesta ca `script.pl` și-l vei executa
folosind `perl script.pl`, Perl va ignora tot ce este
între `=pod` și `=cut`. Va executa numai codul efectiv.

Pe de altă parte, dacă vei tasta `perldoc script.pl`, adică
comanda <b>perldoc</b>, va ignora tot codul. Va formata și va afișa
liniile cuprinse între `=pod` și `=cut`.

Aceste reguli depind de sistemul de operare, dar sunt exact la fel ca
cele despre care am învățat despre
<li><a href="/documentatia-perl-si-documentatia-modulelor-cpan">documentația
Perl și documentația modulelor CPAN</a></li>.

Valoarea adăugată a utilizării de documentație încorporată în format
POD este următoarea: codul nu va fi niciodată distribuit fără
documentație, nici măcar accidental.

De asemenea poți refolosii uneltele și infrastructura pe care
Comunitatea Open Source Perl le-a construit pentru sine. Chiar și
pentru utilizare privată în cadrul firmei.

## Prea simplu?

Ipoteza este aceea că dacă îndepărtezi cele mai multe dintre
obstacolele scrierii de documentație atunci din ce în ce mai mulți vor
scrie documentație.  În loc să înveți cum să folosești procesorul de
texte ca să creezi documente care să arate bine, introduci textul
folosind câteva simboluri suplimentare și poți obține un document care
arată rezonabil. (Vezi și documentația de pe [Meta CPAN](http://metacpan.org/) o versiune frumos formatată a POD-urilor).

## Limbajul de marcare

O descriere detaliată
a <a href="http://perldoc.perl.org/perlpod.html">limbajului de marcare
POD</a> poate fi găsită la
adresa <a href="http://perldoc.perl.org/perlpod.html">perldoc
perlpod</a>, dar este foarte simplu.

Sunt câteva etichete ca `=head1` și `=head2`
care marchează antele "foarte importante" și "mai puțin importante".
Este și `=over` pentru indentare și `=item`
pentru a crea liste și de asemenea câteva altele.

Mai este și `=cut` care marchează sfârșitul secțiunii POD și
`=pod` pentru a începe o secțiunile nouă.  Aceasta din urmă nu
este strict necesar să fie folosită.

Orice șir care începe cu caracterul egal `=` pe prima poziție a
unui rând va fi interpretat ca marcaj POD, și va începe o secțiune POD
care se închide cu `=cut`.

POD permite și încorporarea de hyper-link-uri folosind notația
L&lt;some-link&gt;.

Textul dintre marcaje va fi afișat ca paragrafe de text simplu.

Dacă textul nu începe pe prima poziție a rândului, atunci va fi
interpretat textual, adică va arăta exact cum este: liniile lungi vor
rămâne lungi iar cele scurte vor rămâne scurte.  Acestă facilitate
este folosită pentru exemple de cod sursă.

Un lucru important de reținut este că POD necesită rânduri goale în
jurul marcajelor.

Deci

```perl
=head1 Title
=head2 Subtitle
Some Text
=cut
```

nu va face ceea ce te aștepți.

## Aspectul

POD fiind un limbaj de marcare, nu definește el însuși cum vor fi
afișate lucrurile.

Folosirea unui marcaj `=head1` indică ceva
important, `=head2` înseamnă ceva mai puțin important.

Unealta folosită pentru a afișa POD va folosi în mod uzual caractere
mai mari pentru textul marcat cu head1 decât pentru cel marcat cu
head2 iar ambele vor folosi fonturi mai mari decât cel pentru textul
normal.  Controlul este în sarcina uneltei folosite pentru afișare.

Comanda `perldoc` care vine cu Perl afișează documentele POD ca
pagini de manual.  Este chiar folositor în Linux.  Nu chiar atât de bun
pentru Windows.

Modulul [Pod::Html](https://metacpan.org/pod/Pod::Html)
furnizează o altă unealtă pentru linia de comandă
numită `pod2html`. Aceasta poate converti documente POD în HTML
care pot fi vizualizate într-un browser.

Mai sunt și unelte adiționale pentru a genera fișiere pdf sau mobi din
POD.

## Care este audiența?

După prezentarea tehnicii, haideți să vedem care este audiența?

Comentariile (textele care încep cu #) sunt explicații pentru
programatorul de întreținere.  Persoana care trebuie să adauge noi
facilități sau să corecteze greșeli.

Documentația scrisă folosind POD este pentru utilizatori.  Persoane
care nu ar trebui să se uite la codul sursă.  În cazul unei aplicații
aceștia se vor numi "end users".  Adică oricine utilizează aplicația.

În cazul modulelor Perl, utilizatorii sunt alți programatori Perl care
trebuie să construiască aplicații sau alte module.  Nici ei nu ar
trebui să fie nevoiți să se uite la codul sursă.  Ar trebui să
fie în stare să folosească modulul doar după citirea documentației
folosind comanda `perldoc`.

## Concluzie

Scrierea documentației care arată bine nu este o sarcină așa de grea
în Perl.
