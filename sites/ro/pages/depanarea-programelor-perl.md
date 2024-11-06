---
title: "Depanarea programelor Perl"
timestamp: 2013-08-21T19:45:57
tags:
  - -d
  - Data::Dumper
  - print
  - debug
  - debugging
  - $VAR1
  - $VAR2
published: true
original: debugging-perl-scripts
books:
  - beginner
author: szabgab
translator: stefansbv
---


Când am studiat științele computerelor în universitate, am învățat
multe despre cum să scriem programe, dar așa cum îmi amintesc, nimeni
nu ne-a vorbit despre depanare.  Am auzit despre frumoasa lume a
creării de noi lucruri, dar nimeni nu ne-a spus că vom petrece cel mai
mult timp încercând să înțelegem codul scris de alte persoane.

Se pare că în timp ce noi prețuim mai mult procesul de scriere a
programului, ne petrecem mult mai mult timp încercând să înțelegem ce
am scris noi (sau alții) și de ce nu funcționează așa cum trebuie, decât
timpul petrecut pentru a-l scrie prima oară.


## Ce este depanarea?

Înainte de rularea programului totul a fost într-o bine-știută stare bună.

După rularea programului, ceva este într-o stare neașteptată și proastă.

Sarcina este să aflăm în ce punct ar rulării programului s-a produs
modificarea de stare și să o corectăm.

## Ce este programarea și ce este o hibă? (en: bug)

La bază, programarea este schimbarea lumii un pic (en: bit) prin
deplasarea datelor prin variabile.

La fiecare pas al programului schimbăm ceva date în variabile, sau
ceva din "lumea reală". (De exemplu pe disc sau pe ecran.)

Când scrii un program te gândești la fiecare pas: ce valoare ar trebui
să schimbăm și în ce variabilă.

O hibă este cazul în care te-ai gândit că pui valoarea X într-o
variabilă dar în realitate ea conține valoarea X.

La un moment dat, uzual la terminarea rulării programului, vezi
aceasta din faptul că programul a printat o valoare greșită.

În timpul rulării programului hiba se poate manifesta prin apariția
unei atenționări sau prin terminarea prematură a programului.

## Cum să depanăm?

Cel mai direct mod de a depana un program este prin rularea lui, și la
fiecare pas să verificăm dacă toate variabilele conțin valorile
așteptate.  Acesta se poate realiza cu ajutorul <b>unui debugger</b>
(n.t.: program pentru depanare) sau poți insera <b>comenzi de
printare</b> în program și poți examina rezultatul mai târziu.

Perl vine cu un debugger în linie de comandă foarte puternic.  Deși
recomand învățarea utilizării lui, poate fi de natură să intimideze la
început.  Am pregătit un video unde
prezint <a href="https://perlmaven.com/using-the-built-in-debugger-of-perl">
comenzile de bază ale debugger-ului integrat în Perl</a>.

IDE-uri, precum [Komodo](http://www.activestate.com/),
[Eclipse](http://eclipse.org/) și
[Padre, the Perl IDE](http://padre.perlide.org/) vin cu un
debugger cu interfață grafică.  La un moment dat voi pregăti
tutoriale video și pentru unele dintre acestea.

## Comenzi de Printare

Multă lume folosește strategia veche de a insera comenzi de printare
în cod.

Într-un limbaj pentru care compilarea și generarea poate dura mult
timp inserarea comenzilor de printare este considerată un mod greșit
de depanare.

Nu și în Perl, unde chiar și aplicațiile mari se compilează și pornesc
în câteva secunde.

La inserarea comenzilor de printare trebuie avut grijă să adăugăm
delimitatori în jurul valorilor. Aceasta va evidenția cazul în care
sunt caractere de tip spațiu înainte sau după valori care pot cauza
probleme.

Acestea sunt greu de observat fără delimitatori.

Valorile scalare pot fi printate astfel:

```perl
print "<$file_name>\n";
```

Aici semnele <b>mai mic</b> sau <b>mai mare</b> sunt acolo numai
pentru a face mai ușoară vizualizarea conținutului exact al
variabilei:

```
<path/to/file
>
```

Din rezultatul printării de mai sus poți observa rapid că este un
caracter <b>newline</b> la sfârșitul conținutului variabilei $file_name.
Probabil ai uitat să folosești funcția <b>chomp</b>.

## Structuri Complexe de Date

Nu am învățat încă despre scalari, dar dați-mi voie să sar înainte și
să vă arăt cum să printați conținutul unor structuri de date mai
complexe.  Dacă citești acesta ca parte a tutorialului de Perl atunci
probabil vei dori să sari la următorul articol și să revii mai
târziu. Acesta nu va însemna prea mult pentru tine acum.

Altfel, continuă să citești.

Pentru structuri complexe de date (references, arrays and hashes) poți
folosi modulul `Data::Dumper`

```perl
use Data::Dumper qw(Dumper);

print Dumper \@an_array;
print Dumper \%a_hash;
print Dumper $a_reference;
```

Aceste comenzi vor printa ceva care ajută la înțelegerea conținutului
variabilelor, dar arată doar un nume generic de variabilă
ca `$VAR1` și `$VAR2`.

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

Recomand adăugarea de cod pentru printarea numelui variabilei, astfel cu:

```perl
print '@an_array: ' . Dumper \@an_array;
```

obținem:

```
@an_array: $VAR1 = [
        'a',
        'b',
        'c'
      ];
```

sau cu Data::Dumper astfel:

```perl
print Data::Dumper->Dump([\@an_array, \%a_hash, $a_reference],
   [qw(an_array a_hash a_reference)]);
```

obținem

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

Sunt moduri mai agreabile de a printa structuri de date dar în acest
punct `Data::Dumper` este destul de bun pentru nevoile noastre
și este disponibil în orice instalare Perl.  Vom discuta alte
metode mai târziu.
