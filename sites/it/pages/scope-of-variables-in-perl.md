---
title: "Scope delle variabili in Perl"
timestamp: 2013-10-20T09:00:00
tags:
  - my
  - scope
published: true
original: scope-of-variables-in-perl
books:
  - beginner
author: szabgab
translator: giatorta
---


Ci sono due tipi principali di variabili in Perl. Uno di essi comprende le variabili globali di package, dichiarate con il costrutto
`use vars` (ora obsoleto) oppure con `our`.

L'altro comprende le variabili lessicali dichiarate con `my`.

Vediamo che cosa succede quando dichiarate una variabile usando `my`. In quali parti del codice è visibile?
In altre parole, qual è lo <b>scope</b> della variabile?


## Scope di variabili: blocco

```perl
#!/usr/bin/perl
use strict;
use warnings;

{
    my $email = 'pippo@pluto.com';
    print "$email\n";     # pippo@pluto.com
}
# print $email;
# $email does not exists
# Global symbol "$email" requires explicit package name at ...
```

All'interno del blocco anonimo (delimitato dalla coppia di parentesi graffe `{}`), troviamo anzitutto la dichiarazione di una nuova variabile 
`$email`. Questa variabile esiste dal punto in cui è dichiarata fino alla fine del blocco. Per questo la linea
dopo la parentesi graffa chiusa `}` ha dovuto essere commentata. Se rimuoveste il `#` dalla linea
`# print $email;` e provaste ad eseguire lo script, ricevereste il seguente errore di compilazione:
[Global symbol "$email" requires explicit package name at ...](/global-symbol-requires-explicit-package-name).

In altre parole, lo <b>scope di ogni variabile dichiarata con my è il blocco che la contiene.</b>.

## Scope di variabili: visibilità globale

La variabile `$lname` è dichiarata all'inizio del codice. Risulta quindi visibile
ovunque fino alla fine del file. Anche all'interno di blocchi. E anche se questi blocchi fanno parte di dichiarazioni di funzioni.
Se modifichiamo la variabile all'interno di un blocco, tale cambiamento si riflette nel resto del codice.
Anche quando si esce dal blocco:

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $lname = "Pippo";
print "$lname\n";        # Pippo

{
    print "$lname\n";    # Pippo
    $lname = "Altro";
    print "$lname\n";    # Altro
}
print "$lname\n";        # Altro
```


## Variabili nascoste da altre dichiarazioni

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $fname = "Pippo";
print "$fname\n";        # Pippo

{
    print "$fname\n";    # Pippo

    my $fname  = "Altro";
    print "$fname\n";    # Altro
}
print "$fname\n";        # Pippo
```

In questo caso la variabile `$fname` è dichiarata all'inizio del codice. Secondo quanto scritto sopra, essa sarà visibile
ovunque fino alla fine del file, <b>eccetto dove è nascosta dalla dichiarazione di una variabile locale con lo stesso nome</b>.

All'interno del blocco abbiamo usato `my` per dichiarare un'altra variabile con lo stesso nome. In questo modo la variabile `$fname` dichiarata fuori dal blocco viene nascosta finché non si esce dal blocco stesso. Alla fine del blocco (chiuso da `}`), la variabile `$fname` dichiarata nel blocco viene distrutta e la variabile `$fname` originale diventa di nuovo accessibile.
Questo meccanismo è particolarmente importante in quanto rende facile creare delle variabili all'interno di piccoli scope senza doversi preoccupare dei possibili usi degli stessi nomi all'esterno.

## Stesso nome in più blocchi

Potete liberamente usare lo stesso nome di variabile in più di un blocco. Tali variabili sono indipendenti le une dalle altre.

```perl
#!/usr/bin/perl
use strict;
use warnings;

{
    my $name  = "Pippo";
    print "$name\n";    # Pippo
}
{
    my $name  = "Altro";
    print "$name\n";    # Altro
}
```

## Dichiarazione di package nel file

Questo esempio è un po' più avanzato, ma è importante menzionarlo qui:

Perl permette di spostarsi da un <b>name-space</b> a un altro usando l'istruzione `package` all'interno
di un file. Una dichiarazione di package <b>NON</b> delimita uno scope. Se dichiarate una variabile `$fname` nel
<b>package main</b> implicito, che è semplicemente il corpo del vostro script, tale
variabile sarà visibile anche in altri name-space nello stesso file.

Se dichiarate una variabile `$lname` nel name-space 'Altro', essa sarà ancora visibile
quando tornate al name-space `main`. Se la dichiarazione del `package Altro`
fosse in un altro file, le variabili avrebbero un diverso scope determinato da tale file.

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $fname  = "Pippo";
print "$fname\n";    # Pippo

package Altro;
use strict;
use warnings;

print "$fname\n";    # Pippo
my $lname = 'Pluto';
print "$lname\n";    # Pluto


package main;

print "$fname\n";    # Pippo
print "$lname\n";    # Pluto
```


