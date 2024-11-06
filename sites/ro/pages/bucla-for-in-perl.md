---
title: "Bucla for în Perl"
timestamp: 2013-06-02T20:27:00
tags:
  - for
  - foreach
  - buclă
  - buclă infinită
published: true
original: for-loop-in-perl
books:
  - beginner
author: szabgab
translator: ggl
---


În partea aceasta a [Tutorialului Perl](perl-tutorial) vom vorbi despre 
<b>bucla for în Perl</b>. Unii o mai numesc <b>bucla for în stil C</b>, deşi această
construcţie este de fapt disponibilă în mai multe limbaje.


## for în Perl

Cuvântul cheie <b>for</b> în Perl poate funcţiona în două moduri diferite:
poate funcţiona la fel ca o buclă <b>foreach</b> sau poate să se comporte
ca o buclă for din 3 părţi în stil C. E numită în stil C cu toate că e disponibilă în multe
limbaje.

Voi descrie cum funcţionează aceasta deşi prefer să scriu bucla în stil `foreach`,
aşa cum este descrisă în secţiunea despre  
[vectori Perl](https://perlmaven.com/perl-arrays).


Cele două cuvinte cheie `for` şi `foreach` sunt sinonime.
Perl va descifra singur la care dintre semnificaţii vă referiţi.

Bucla <b>for în stil C</b> are trei părţi în secţiunea de comandă. În general arată ca şi
codul acesta, deşi puteţi omite oricare dintre cele 4 părţi.

```perl
for (INITIALIZE; TEST; STEP) {
  BODY;
}
```

Vezi acest cod drept exemplu:

```perl
for (my $i=0; $i <= 9; $i++) {
   print "$i\n";
}
```

Partea INITIALIZE va fi executată odată ce execuţia ajunge în acel punct.

Apoi, imediat după aceea va fi executată partea TEST. Dacă aceasta este falsă, atunci se sare peste
toată bucla. Dacă partea TEST este adevărată atunci este executată partea BODY, urmată de partea
STEP.

(Pentru semnificaţia reală a valorilor ADEVĂRAT sau FALS, vezi
[valori logice în Perl](https://perlmaven.com/boolean-values-in-perl).)

Apoi urmează din nou TEST şi tot aşa, atâta timp cât TEST se execută cu valoare de adevăr. 
Deci arată aşa:

```
INITIALIZE

TEST
BODY
STEP

TEST
BODY
STEP

...

TEST
```


## foreach

Bucla de mai sus este parcursă de la 0 la 9 şi poate fi scrisă ca o <b>buclă foreach</b>,
intenţia fiind probabil mult mai clară:

```perl
foreach my $i (0..9) {
  print "$i\n";
}
```

Aşa cum sunt scrise, cele două bucle sunt de fapt echivalente. Unii oameni folosesc
cuvântul cheie `for` însă scriu o buclă <b>în stil foreach</b> ca aceasta:

```perl
for my $i (0..9) {
  print "$i\n";
}
```

## Părţile buclei for în Perl

INITIALIZE iniţializează o varibilă. Este executată exact odată.

TEST este o expresie logică  oarecare şi verifică dacă bucla for trebuie să se oprească sau
să continue. Este executată cel puţin odată. Odată ce BODY şi STEP au fost executate, TEST
mai este executată încă odată. Probabil că toate aceste studii de caz pot fi rescrise într-un mod
mai atrăgător.

STEP este o altă instrucţiune folosită în mod normal pentru a incrementa sau decrementa un fel
de index. Aceasta poate fi lăsată necompletată dacă de exemplu facem acest lucru în interiorul
BODY.

## Infinite loop

Puteţi compune un ciclu infinit folosind <b>bucla for</b>:

```perl
for (;;) {
  # fă ceva
}
```

Lumea îl scrie de obicei folosind o instrucţiune `while` cum ar fi:

```perl
while (1) {
  # fă ceva
}
```

Este descrisă în partea despre <a href="https://perlmaven.com/while-loop">bucla while
în Perl</a>.

## perldoc

Puteţi găsi descrierea oficială a buclei for în secţiunea <b>perlsyn</b> a
[documentaţiei Perl](http://perldoc.perl.org/perlsyn.html#For-Loops).




