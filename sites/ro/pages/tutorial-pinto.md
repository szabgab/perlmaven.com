---
title: "Pinto -- Un CPAN Personalizat"
timestamp: 2013-05-03T16:30:04
tags:
  - cpan
  - pinto
published: true
original: pinto-tutorial
author: thalhammer
translator: stefansbv
---


<i>
Acesta este un articol scris de <a href="http://twitter.com/thaljef">Jeffrey Ryan
Thalhammer</a>, autorul aplicațiilor Pinto și Perl::Critic. Jeff
deține o micuță companie de consultanță în San Francisco și este un
membru activ al comunității Perl de mulți ani.  Până în data de 7 mai
Jeff derulează
o [campanie-de-adunat-fonduri](https://www.crowdtilt.com/campaigns/specify-module-version-ranges-in-pint)
pentru finanțarea dezvoltării unei noi opțiuni care va
permite <b>specificarea gamei de versiuni a modulelor în Pinto</b>.
</i>

Unul dintre cele mai bune lucruri legate de Perl este existența
modulelor open-source disponibile pe CPAN.  Dar gestionarea acestor
module este dificilă.  În fiecare săptămână sunt sute de noi lansări și nu
poți ști dacă noua versiune a unui modul nu va introduce o hibă care să-ți
afecteze aplicația.


This article was originally published on [Pragmatic Perl](http://pragmaticperl.com/)

Una dintre strategiile de rezolvare a acestei probleme este să-ți
construiești propriul depozit CPAN care să conțină doar versiunile
modulelor pe care le dorești. Astfel poți folosi uneltele CPAN pentru
a construi aplicația folosind modulele din depozitul propriu fără a
mai fi expus la potențialele probleme date de depozitul public CPAN.

De-a lungul anilor, am construit mai multe depozite CPAN la comandă
folosind unelte
ca [CPAN::Mini](https://metacpan.org/pod/CPAN::Mini)
și [CPAN::Site](https://metacpan.org/pod/CPAN::Site).

Dar întotdeauna mi s-au părut greoaie, nu am fost niciodată mulțumit de
ele.  Cu vreo doi ani în urmă un client m-a angajat să-i construiesc un
alt depozit CPAN. Dar de data acesta am avut oportunitatea de a începe
de la zero.  Pinto este rezultatul acestui efort.

[Pinto](https://metacpan.org/pod/Pinto) este o unealtă
robustă pentru crearea și administrarea de depozite CPAN, la comandă.
Are mai multe caracteristici puternice care te ajută să administrezi
în siguranță toate modulele Perl de care are nevoie aplicația
ta. Acest tutorial îți va arăta cum să creezi un depozit CPAN cu Pinto
și-ți va demonstra unele dintre acele caracteristici.

## Instalarea Pinto

Pinto este disponibil pe CPAN și poate fi instalat ca orice alt modul
folosind utilitarele CPAN sau `cpanm`.  Dar Pinto este mai mult
o aplicație decât o bibliotecă de funcții.  Este o unealtă pe care o
poți folosi să administrezi codul aplicației, dar Pinto nu este în
fapt parte a aplicației tale.  Deci îți recomand să instalezi Pinto ca pe
o aplicație de sine stătătoare cu aceste comenzi:

```
curl -L http://getpinto.stratopan.com | bash
source ~/opt/local/pinto/etc/bashrc
```

Acestea vor instala Pinto în `~/opt/local/pinto` și vor adăuga
directoarele necesare la `PATH` și `MANPATH`.
Aplicația este autonomă, conține tot ce este necesar, deci instalarea
Pinto nu va afecta mediul tău de dezvoltare și nici schimbările
acestuia nu vor afecta Pinto.

## Explorând Pinto

Așa cum se face cu orice nouă unealtă, primul lucru pe care ar trebui
să-l înveți este cum să ceri ajutor:

```
pinto commands            # Arată o listă a comenzilor disponibile
pinto help <COMMAND>      # Arată un sumar al opțiunilor și al argumentelor pentru <COMMAND>
pinto manual <COMMAND>    # Arată manualul complet pentru <COMMAND>
```

Pinto vine de asemenea și cu alte documentații, incluzând un tutorial
și un ghid de referință rapidă.  Poți accesa această documentație
folosind comenzile:

```
man Pinto::Manual::Introduction  # Explică conceptele de bază Pinto
man Pinto::Manual::Installing    # Sugestii pentru instalarea Pinto
man Pinto::Manual::Tutorial      # Un ghid descriptiv pentru Pinto
man Pinto::Manual::QuickStart    # Un sumar al comenzilor de bază
```

## Crearea Unui Depozit

Primul pas pentru folosirea Pinto este crearea depozitului folosind comanda
`init`:

```
pinto -r ~/repo init
```

Acesta va crea un nou depozit în directorul `~/repo`.  Dacă
acest director nu există, va fi creat. Dacă există deja, atunci
trebuie să fie gol.

Opțiunea -r (or --root) specifică unde este localizat depozitul.
Această opțiune este obligatorie pentru toate comenzile pinto.
Dacă te-ai plictisit să o tot tastezi, poți seta variabila de
mediu `PINTO_REPOSITORY_ROOT` să indice calea către depozit și
să omiți opțiunea -r.


## Inspectarea Depozitului

Acum că ai un depozit, hai să vedem ce conține.  Pentru a vedea
conținutul unui depozit, folosește comanda "list":

```
pinto -r ~/repo list
```

În acest moment, nu va lista nimic pentru că nu depozitul este gol
deocamdată.  Dar vei folosi comanda "list" destul de des în acest
tutorial.

## Adăugarea De Module CPAN

Să presupunem că lucrezi la o aplicație numită My-App care conține
un modul numit My::App, care depinde de modulul URI.  Poți adăuga
modulul URI în depozitul tău folosind comanda `pull`:

```
pinto -r ~/repo pull URI
```

Vei fi solicitat să introduci un mesaj de log care să descrie modificarea.
Partea de început a șablonului mesajului va include un mesaj eșantion care
poate fi editat. Restul mesajului va cuprinde ce module vor fi adăugate.
Salvează fișierul și închide editorul după ce ai terminat.

Acum ar trebui să ai modulul URI în depozit.  Hai să vedem ce am
obținut.  Încă odată, folosește comanda `list` pentru a vedea
ce conține depozitul:

```
pinto -r ~/repo list
```

De acestă dată, rezultatul va arăta cam așa:

```
rf  URI                            1.60  GAAS/URI-1.60.tar.gz
rf  URI::Escape                    3.31  GAAS/URI-1.60.tar.gz
rf  URI::Heuristic                 4.20  GAAS/URI-1.60.tar.gz
...
```

Se poate vedea că modulul URI a fost adăugat la depozit, împreună cu
toate dependențele modulului URI, și toate dependențele acestora, și
așa mai departe.

## Adăugarea Modulelor Private

Să presupunem că ai terminat lucrul la My-App și ești gata să lansezi
prima versiune.  Folosind unealta preferată (de
ex. ExtUtils::MakeMaker, Module::Build, Module::Install etc.) creezi
un pachet denumit My-App-1.0.tar.gz. Adaugi distribuția la depozitul
Pinto folosind comanda `add`:

```
$> pinto -r ~/repo add path/to/My-App-1.0.tar.gz
```

De asemenea vei fi solicitat să introduci un mesaj care să descrie
modificarea.  Când vei lista conținutul depozitului, va include
modulul My::App și numele autorului distribuției:

```
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf  URI                            1.60  GAAS/URI-1.60.tar.gz
rf  URI::Escape                    3.31  GAAS/URI-1.60.tar.gz
rf  URI::Heuristic                 4.20  GAAS/URI-1.60.tar.gz
...
```


## Instalarea Modulelor

Acum că ai modulele în depozitul Pinto, următorul pas este să încerci
să le instalezi undeva.  Sub capotă, un depozit Pinto este organizat
exact ca un depozit CPAN, deci este perfect compatibil cu cpanm și
orice altă unealtă pentru instalat module Perl.  Tot ce trebuie să
faci este să indici locația depozitului Pinto:

```
cpanm --mirror file://$HOME/repo --mirror-only My::App
```

Acesta va instala My::App folosind *numai* modulele din depozitul tău
Pinto.  În consecință vei obține exact aceleași versiuni ale acelor
module de fiecare dată, chiar dacă modulul este eliminat sau
actualizat pe CPAN.

La folosirea utilitarului cpanm, opțiunea --mirror-only este
importantă pentru că împiedică folosirea sitului public CPAN în cazul
în care nu găsește un anumit modul în depozitul tău.  De obicei când
se întâmplă aceasta, înseamnă că o anumită distribuție din depozit nu
are toate dependențele declarate corect în fișierul său META.  Pentru
a rezolva problema, folosește comanda `pull` pentru a adăuga
modulele care lipsesc.


## Actualizarea Modulelor

Să presupunem că au trecut câteva săptămâni de când ai lansat
aplicația My-App și acum versiunea 1.62 a modulului URI este
disponibilă pe CPAN.  Are niște corecții critice pe care ai dori să le incluzi. Tot așa putem include noua versiune în depozit folosind comanda
`pull`.  Dar deoarece depozitul tău conține deja o versiune a
modulului URI, trebui să indici că dorești o versiune <b>mai nouă</b>
specificând versiunea minimă dorită:

```
pinto -r ~/repo pull URI~1.62
```

Dacă te uiți la rezultatul comenzii de listare din nou, de acestă dată
vei vedea noua versiune a modulului URI (și posibil de asemenea și
pentru alte module):

```
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf  URI                            1.62  GAAS/URI-1.62.tar.gz
rf  URI::Escape                    3.38  GAAS/URI-1.62.tar.gz
rf  URI::Heuristic                 4.20  GAAS/URI-1.62.tar.gz
...
```

Dacă noua versiune a modului URI necesită actualizări ale modulelor
dependente sau dependențe suplimentare, acelea vor fi de asemenea
adăugate în depozit.  Iar la instalarea My::App, vei obține versiunea
1.62 a modulului URI.

## Lucrul Cu Stive - Stacks

Până acum am tratat depozitul ca pe o resursă singulară.  La
actualizarea modulului URI în secțiunea de mai sus, au fost afectate
toate persoanele și toate aplicațiile care ar fi utilizat depozitul.
Acest fel de impact larg nu este de dorit.  Este de preferat să faci
modificări în izolare și să le testezi înainte de a forța pe toți
ceilalți utilizatori să facă actualizarea.  Pentru aceasta sunt
folosite stivele: stacks.

Toate depozitele de tip CPAN au un index care leagă ultima versiune al
fiecărui modul de arhiva care-l conține.  Uzual, există doar un singur
index pentru fiecare depozit.  Dar în depozitele Pinto, pot fi mai
multe indexuri.  Fiecare dintre aceste indexuri poartă denumirea
<b>"stack"</b>.  Aceasta permite crearea de stive diferite pentru
dependențele dintr-un depozit.  Deci poți avea o stivă "development",
una "production", sau una "perl-5.8" și una "perl-5.16".  De câte ori
adaugi sau actualizezi un modul, va fi afectată o singură stivă.

Înainte de a merge mai departe, trebuie să vorbim despre stiva
implicită.  Pentru majoritatea operațiunilor, numele stivei este un
parametru opțional.  Dacă nu este specificat explicit, atunci comanda
este aplicată la stiva marcată ca implicită.

Într-un depozit nu este decât o singură stivă implicită.  Când a fost
creat depozitul, a fost creată și o stivă numită "master" și marcată
ca implicită.  Poți schimba stiva implicită sau numele ei, dar nu vom
intra în detalii aici.  Este de ținut minte că "master" este numele
stivei care a fost creată când a fost inițializat depozitul.

<h3>Crearea Unei Stive</h3>

Să presupunem că depozitul tău conține versiunea 1.60 a modulului URI
dar versiune 1.62 a fost lansată pe CPAN, cu puțin timp în urmă.
Dorești să încerci actualizarea, dar de data asta vei face-o pe o
stivă separată.

Până acum tot ce ai adăugat în depozit a utilizat stiva "master".  Vom
face o clonă a acelei stive folosind comanda `copy`:

```
pinto -r ~/repo copy master uri_upgrade
```

Această comandă va crea o nouă stivă numită "uri_upgrade".  Dacă
dorești să vezi conținutul stivei, folosește comanda `list` cu
opțiunea "--stack":

```
pinto -r ~/repo list --stack uri_upgrade
```

Lista ar trebui să fie identică cu cea a stivei "master":

```
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf  URI                            1.60  GAAS/URI-1.60.tar.gz
...
```

<h3>Actualizarea Unei Stive</h3>

Acum că avem o stivă separată, putem încerca să actualizăm modulul
URI.  Ca și până acum vom folosi comanda `pull`.  Dar de acestă
dată, vom instrui Pinto să adauge modulele la stiva "uri_upgrade":

```
pinto -r ~/repo pull --stack uri_upgrade URI~1.62
```

Putem să comparăm stivele "master" și "uri_upgrade" folosind comanda "diff":

```
pinto -r ~/repo diff master uri_upgrade

+rf URI                                              1.62 GAAS/URI-1.62.tar.gz
+rf URI::Escape                                      3.31 GAAS/URI-1.62.tar.gz
+rf URI::Heuristic                                   4.20 GAAS/URI-1.62.tar.gz
...
-rf URI                                              1.60 GAAS/URI-1.60.tar.gz
-rf URI::Escape                                      3.31 GAAS/URI-1.60.tar.gz
-rf URI::Heuristic                                   4.20 GAAS/URI-1.60.tar.gz
```

Rezultatul este similar cu cel al comenzii diff(1).  Înregistrările
care încep cu "+" au fost adăugate iar cele care încep cu "-" au fost
șterse.  Se poate vedea că modulele din distribuția URI-1.60 au fost
înlocuite cu modulele din distribuția URI-1.62.

<h3>Instalare Dintr-o Stivă</h3>

Odată ce ai modulele noi în stiva "uri_upgrade", poți încerca să
construiești aplicația indicând comenzii cpanm stiva.  Fiecare stivă
este doar un subdirector din depozit, deci tot ce trebuie să faci este
să-l adaugi la URL:

```
cpanm --mirror file://$HOME/repo/stacks/uri_upgrade --mirror-only My::App
```

Dacă toate teste sunt încheiate cu succes, atunci poți actualiza, cu
încredere, modulul URI la versiunea 1.62 și în stiva "master" folosind
comanda `pull`.  Stiva "master" fiind stiva implicită, poți
omite parametrul "--stack":

```
pinto -r ~/repo pull URI~1.62
```

## Comanda Pin

Stivele sunt un mod bun de a testa efectul schimbării dependențelor
aplicației tale.  Dar dacă testele eșuează?  Dacă problema ține de
My-App și poți să o corectezi rapid, ai putea să modifici codul, să
lansezi versiunea 2.0 a My-App, și după aceea să actualizezi URI din
stiva "master".

Dar dacă problema este o hibă în URI sau va dura mult pentru a remedia
My-App, atunci ai o problemă.  Nu vei dori ca altcineva să actualizeze
URI, nici să fie actualizată pe șest ca urmare a unor dependențe pe
care My-App le-ar putea avea.  Trebuie prevenită actualizarea URI până
când problema este rezolvată.  Pentru aceasta există comanda "pin".

<h3>Utilizarea Comenzii Pin</h3>

Când folosești comanda "pin" asupra unui modul, acea versiune a
modulului este forțată să stea în stivă.  Orice încercare de
actualizare (directă sau via dependințe) va eșua.  Acest efect se
obține folosind comanda `pin`:

```
pinto -r ~/repo pin URI
```

Dacă analizezi listingul stivei "master" încă o dată, vei vedea ceva
de genul acesta:

```
...
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf! URI                            1.60  GAAS/URI-1.60.tar.gz
rf! URI::Escape                    3.31  GAAS/URI-1.60.tar.gz
...
```

Semnul "!" de lângă începutul unei înregistrări indică starea de
blocare a versiunii modulului în urma comenzii "pin".  Oricine ar
încerca să actualizeze URI sau să adauge o distribuție care necesită o
versiune mai nouă a URI, va primi o atenționare din partea Pinto care
va refuza să accepte noile distribuții.  Notați că toate modulele din
distribuția URI-1.60 sunt marcate, deci este imposibil să actualizezi
parțial o distribuție (acestă situație poate apărea atunci când un
modul este mutat în altă distribuție).

<h3>Ridicarea Restricției Comenzii Pin</h3>

După un timp, să presupunem că ai rezolvat problemele din My-App sau a
fost lansată o nouă versiune a URI care rezolvă hiba.  În această
situație, poți să folosești comanda `unpin` asupra URI pentru a
ridica restricția de actualizare.

```
pinto -r ~/repo unpin URI
```

În acest moment ești liber să actualizezi URI la cea mai nouă
versiune.  La fel ca în cazul comenzii pin, unpin afectează toate
modulele distribuției.

## Pin şi Stack Împreună

Funcțiile pin și stack sunt deseori folosite împreună pentru a ajuta
la administrarea modificărilor din timpul ciclului de dezvoltare.  De
exemplu, ai putea crea o stivă numită "prod" care conține dependențele
știute a fi fără probleme.  În același timp, ai putea crea o stivă
numită "dev" care conține dependențe experimentale pentru noua ta
lansare.  Inițial, stiva "dev" este doar o copie a stivei "prod".

În cursul procesului de dezvoltare, poți actualiza sau adăuga module
în stiva "dev".  Dacă vreunul dintre modulele actualizate afectează
aplicația, atunci poți bloca actualizarea acelui modul în stiva "prod"
folosind comanda "pin".

<h3>Pin Și Petece</h3>

Pot apărea situații când o nouă versiune a unei distribuții CPAN are o
hibă pe care autorul nu dorește sau nu poate să o rezolve (cel puțin
până la termenul limită al noii tale lansări).  În această situație,
poți decide să aplici un petec local la acea distribuție CPAN.

Să presupunem că ai creat o ramificație a codului (fork) pentru URI și
o versiune locală a distribuției numită URI-1.60_PATCHED.tar.gz.  Poți
s-o adaugi la depozit folosind comanda `add`:

```
pinto -r ~/repo add path/to/URI-1.60_PATCHED.tar.gz
```

În această situație, este necesar să aplici și comanda pin, pentru că
nu este de dorit ca distribuția să fie actualizată până când nu ești
sigur că noua versiune de pe CPAN include petecul tău sau că autorul a
rezolvat hiba prin alte mijloace.

```
pinto -r ~/repo pin URI
```

Când autorul URI lansează versiunea 1.62, vei dori să o testezi înainte
de a decide să permiți actualizarea (unpin) versiunii locale peticite.  La
fel ca mai înainte acesta se poate face clonând stiva cu ajutorul comenzii `copy`.
S-o numim stiva "trial" de această dată:

```
pinto -r ~/repo copy master trial
```

Dar înainte de a putea face actualizarea URI, trebuie să ridicăm restricția
de pe stiva "trial", folosind comanda "unpin":

```
pinto -r ~/repo unpin --stack trial URI
```

Acum poți să actualizezi URI pe stivă și poți să încerci să
construiești My::App astfel:

```
pinto -r ~/repo pull --stack trial URI~1.62
cpanm --mirror file://$HOME/repo/stacks/trial --mirror-only My::App
```

Dacă totul este bine, ridică restricția și de pe stiva "master" și
adaugă noua versiune a URI.

```
pinto -r ~/repo unpin URI
pinto -r ~/repo pull URI~1.62
```

## Recenzia Modificărilor Din Trecut

Așa cum probabil ați remarcat deja până acum, fiecare comandă care
schimbă starea unei stive necesită un mesaj care să o descrie.  Poți
recenza acele mesaje folosind comanda `log`:

```
pinto -r ~/repo log
```

Rezultatul ar trebui să arate cam așa:

```
revision 4a62d7ce-245c-45d4-89f8-987080a90112
Date: Mar 15, 2013 1:58:05 PM
User: jeff

     Pin GAAS/URI-1.59.tar.gz

     Pinning URI because it is not causes our foo.t script to fail

revision 4a62d7ce-245c-45d4-89f8-987080a90112
Date: Mar 15, 2013 1:58:05 PM
User: jeff

     Pull GAAS/URI-1.59.tar.gz

     URI is required for HTTP support in our application

...
```

Antetul fiecărui mesaj arată autorul și data modificării.  Are de
asemenea un identificator unic similar codificării SHA-1 folosit de
Git.  Poți folosi acești identificatori pentru a vedea diferențele
dintre diverse revizii sau ca să resetezi stiva la o revizie
anterioară [NB: această funcționalitate nu este încă implementată].

## Concluzii

În acest tutorial, ai văzut comenzile de bază pentru crearea și
popularea unui depozit Pinto.  De asemenea ai văzut cum să folosești
stivele și comanda "pin" pentru a administra dependențele pentru a
trece de obstacolele întâlnite în cursul dezvoltării de software.

Fiecare comandă are mai multe opțiuni pe care nu le-am discutat în
acest tutorial, și de asemenea comenzi pe care nu le-am menționat aici
deloc.  În consecință te încurajez să explorezi paginile de manual ale
fiecărei comenzi și să înveți mai mult.
