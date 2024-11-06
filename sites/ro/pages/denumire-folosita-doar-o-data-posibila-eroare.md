---
title: "Denumirea "main::x" este folosită doar o dată: posibilă eroare la ..."
timestamp: 2013-12-14T20:31:10
tags:
  - warnings
  - strict
  - possible typo
published: true
original: name-used-only-once-possible-typo
books:
  - beginner
author: szabgab
translator: stefansbv
---


Dacă întâlnești această avertizare într-un script Perl, ești în mare necaz.


## Atribuire valoare unei variabile

Atribuirea unei valori la o variabilă care nu va fi folosită
niciodată, sau folosirea unei variabile o dată fără să-i fi fost
atribuită o valoare vreodată, sunt cazuri care foarte rar sunt corecte
în orice cod.

Probabil singurul caz "legitim", este dacă ai făcut o greșeală de
scriere și așa te-ai ales cu o variabilă care este folosită o singură
dată.

Aici este un exemplu de cod în care noi <b>vom atribui o valoare unei
variabile fără să o folosim</b>:

```perl
use warnings;

$x = 42;
```

Va genera o avertizare ca aceasta:

```
Name "main::x" used only once: possible typo at ...
```

Partea cu "main::" și lipsa caracterului $ ar putea fi derutantă.
Partea cu "main::" este prezentă pentru că implicit fiecare variabilă
în Perl face parte din spațiul de denumiri "main".  Există de asemenea
un număr de lucruri care pot fi denumite "main::x" și doar una dintre
ele are caracterul $ la început.  Dacă acesta sună un pic derutant,
nu-ți face griji.  Este derutant, dar să sperăm că nu va trebui să ai
de a face cu acesta prea mult timp.

## Citește valoarea

Dacă se întâmplă să <b>folosești o variabilă doar o dată</b>

```perl
use warnings;

print $x;
```

probabil că vei primi două avertizări:

```
Name "main::x" used only once: possible typo at ...
Use of uninitialized value $x in print at ...
```

Pe una dintre ele o discutăm acum, pe cealaltă o s-o discutăm în
[Folosirea unei valori neinițializate](/folosirea-unei-valori-neinitializate).


## Care este greșeala de scriere aici?

Ai putea întreba.

Imaginează-ți că cineva folosește o variabilă numită `$l1`.
Mai târziu, vi tu și dorești să folosești aceeași variabilă dar
scrii `$ll`.  În funcție de fontul folosit ar putea arăta
similar.

Sau poate a fost o variabilă numită `$color` dar ești britanic
și tastezi automat `$colour` când te gândești la acel lucru.

Sau există o variabilă numită `$number_of_misstakes` și nu observi
greșeala din numele variabilei originale și scrii `$number_of_mistakes`.

Ai prins idea.

Dacă ești norocos, faci acestă eroare doar o dată, dar dacă nu ești
așa norocos, și folosești variabila incorectă de două ori, această
avertizare nu va mai apare.  La urma urmelor dacă folosești aceeași
variabilă de două ori, ai probabil un motiv întemeiat.

Cum pot să evit acest lucru?

Întâi, încearcă să eviți numele de variabile care conțin caractere
ambigue și fi foarte atent când tastezi nume de variabile.

Dacă vrei să rezolvi această problemă definitiv, folosește <b>use strict</b>!

## use strict

Așa cum poți vedea în exemplele de mai sus, nu am folosit <b>strict</b>.
Dacă l-aș fi folosit, atunci în loc să primesc o avertizare pentru o
posibilă eroare de scriere, ași primi o eroare de compilare:
[Simbolul global necesită un nume de pachet explicit](/simbolul-global-necesita-nume-de-pachet-explicit).

Acesta s-ar întâmpla chiar dacă ai folosi numele de variabilă incorect
de mai multe ori.

Dar bineînțeles că există persoane care s-ar grăbi să insereze "my"
înaintea numelui incorect de variabilă, dar tu nu faci parte dintre
ei, nu-i așa?  Tu ai cugeta asupra problemei și ai căuta până ai găsi
numele real al variabilei.

Cel mai comun mod de a întâlni acestă avertizare este când nu
folosești "use strict".

Și în acest caz ești în mare necaz.

## Alte cazuri sub "use strict"

Așa cum GlitchMr și Anonymous au subliniat, mai sunt câteva alte
cazuri:

Acest cod poate de asemenea să-l genereze

```perl
use strict;
use warnings;

$main::x = 23;
```

Avertizarea este: <b>Name "main::x" used only once: possible typo ...</b>

Aici, cel puțin, este clar de unde vine acel 'main', sau în exemplul
următor, de unde vine acel 'Mister'.  (sugestie: 'main' și 'Mister'
sunt ambele nume de pachete.  Dacă ești interesat, vezi și
<a href="/simbolul-global-necesita-nume-de-pachet-explicit">mesajul de
eroare care se referă la nume de pachete care lipsesc</a>.
În următorul exemplu, numele pachetului este 'Mister'.

```perl
use strict;
use warnings;

$Mister::x = 23;
```

Avertizarea este <b>Name "Mister::x" used only once: possible typo ...</b>.

Următorul exemplu generează de asemenea avertizarea.  De două ori:

```perl
use strict;
use warnings;

use List::Util qw/reduce/;
print reduce { $a * $b } 1..6;
```

```
Name "main::a" used only once: possible typo at ...
Name "main::b" used only once: possible typo at ...
```

Aceasta se întâmplă pentru că `$a` și `$b` sunt
variabile speciale folosite în funcția de sortare și în consecință nu
trebuiesc declarate, dar sunt folosite o singură dată aici.

(De fapt îmi este neclară cauza pentru care aceasta generează avertizarea,
în timp ce același cod care folosește funcția <b>sort</b> nu o generează, dar
[Perl Monks](http://www.perlmonks.org/?node_id=1021888) ar
putea conține răspunsul).
