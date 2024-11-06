---
title: "Here Document, ovvero come creare stringhe multi-linea in Perl"
timestamp: 2013-08-04T22:00:00
tags:
  - <<
  - /m
  - /g
  - q
  - qq
published: true
original: here-documents
books:
  - beginner
author: szabgab
translator: giatorta
---


Ogni tanto può capitarvi di dover creare una stringa che occupa diverse linee.
Come al solito, in Perl ci sono molte soluzioni per questo problema.
Una soluzione comune consiste nell'uso di un here-document.


Un <b>here-document</b> vi permette di creare una stringa che occupa <b>diverse linee</b> preservando
i caratteri di spaziatura e di a capo. Se eseguite il codice qui sotto verrà stampato esattamente ciò che vedete
dalla parola Caro fino alla linea che precede la seconda occorrenza di END_MESSAGE.

## Non-interpolating here document

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $name = 'Pippo';

my $message = <<'END_MESSAGE';
Caro $name,

questo e' un messaggio che vorrei spedirti.

saluti
  firmato: il Perl Maven
END_MESSAGE

print $message;
```

L'output è:

```
Caro $name,

questo e' un messaggio che vorrei spedirti.

saluti
  firmato: il Perl Maven
```

L'here document inizia con due caratteri minore-di `&lt;&lt;` seguiti da una stringa arbitraria che diventa
il terminatore dell'here-document, seguita dal punto e virgola `;` che chiude l'istruzione.
Può sembrare un po' strano dato che l'istruzione non termina davvero lì. Infatti il contenuto dell'here document
inizia alla linea successiva al punto e virgola (nel nostro caso con la parola "Caro") e continua finché perl trova il
terminatore scelto arbitrariamente. Nel nostro caso la stringa <b>END_MESSAGE</b>.

Se vi è già capitato di vedere degli here-document in qualche pezzo di codice, probabilmente sarete sorpresi dalla presenza degli apici intorno al primo <b>END_MESSAGE</b>. Credo che se trovate degli esempi di here-document in Internet, o anche dietro ai firewall aziendali,
probabilmente vedrete la parte iniziale senza apici. Come in questo codice:

```perl
my $message = <<END_MESSAGE;
...
END_MESSAGE
```

Funziona e si comporta come se aveste racchiuso END_MESSAGE tra doppi apici come nel prossimo esempio,
ma è <b>deprecato</b> e sarà rimosso a partire da perl 5.20. Quindi <b>non</b> usatelo! Non usate here-document
senza racchiudere tra apici la definizione della stringa-terminatore.

```perl
my $message = <<"END_MESSAGE";
...
END_MESSAGE
```

Se conoscete già la
[differenza tra apici singoli e doppi](/quoted-interpolated-and-escaped-strings-in-perl)
in Perl non vi sorprenderà che gli here-document si comportino nello stesso modo.
L'unica differenza è che gli apici vengono messi
intorno, al terminatore anziché alla stringa vera e propria. Se omettete gli apici, Perl assume per default i doppi apici.

Se riguardate il primo esempio, noterete che `$name` faceva parte dell'here-document
e che continuava a far parte anche dell'output. Questo perché Perl non tentava di sostituirlo
con il contenuto della variabile `$name`. (Non dovevamo neppure dichiarare la variabile nel
codice. Potete provare lo script anche senza la parte `my $name = 'Pippo';`.)

## Interpolazione di here document

Nel prossimo esempio racchiuderemo il terminatore tra doppi apici in modo che la variabile `$name`
venga interpolata:

```perl
use strict;
use warnings;

my $name = 'Pippo';
my $message = <<"END_MSG";
Ciao $name,

come stai?
END_MSG

print $message;
```

Il risultato dell'esecuzione di questo script è:

```
Ciao Pippo,

come stai?
```

## Attenzione: alla fine ci vuole il terminatore corretto

Solo una nota. Dovete assicurarvi che la stringa-terminatore alla fine della stringa
sia <b>esattamente</b> uguale a quella che c'è all'inizio. Nessun carattere di spaziatura prima o dopo.
Altrimenti Perl non la riconoscerà e penserà che l'here-document non sia ancora finito.
Ciò significa che non potete indentare il terminatore per seguire l'indentazione del resto del vostro codice.
O invece sì?

## Here document e indentazione del codice

Se l'here document deve essere definito in un posto dove normalmente indentereste
il codice, abbiamo due problemi:


```perl
#!/usr/bin/perl
use strict;
use warnings;

my $name = 'Pippo';
my $send = 1;

if ($send) {
    my $message = <<"END_MESSAGE";
        Caro $name,
    
        questo e' un messaggio che vorrei spedirti.
    
        saluti
          firmato: il Perl Maven
END_MESSAGE
    print $message;
}
```

Uno è che, come detto sopra, il terminatore della stringa deve essere esattamente lo stesso sia quando viene
dichiarato che quando chiude la stringa, e quindi non potete indentarlo alla fine della stringa. 

L'altro problema è che l'output conterrà molti caratteri di spaziatura all'inizio di ogni linea:

```
        Caro Pippo,
    
        questo e' un messaggio che vorrei spedirti.
    
        saluti
          firmato: il Perl Maven
```

L'assenza di indentazione del terminatore può essere risolta usandone uno che
includa un numero sufficiente di spazi iniziali: (qui uso 4 spazi, dato che i tab non
vanno bene qui nell'articolo, ma potrebbero funzionare in un pezzo di codice reale. Sempre che siate dei patiti
di indentazione coi tab.)

```perl
    my $message = <<"    END_MESSAGE";
       ...
    END_MESSAGE
```

L'indentazione extra del testo vero e proprio può essere rimossa aggiungendo una sostituzione nell'assegnamento.

```perl
    (my $message = <<"    END_MESSAGE") =~ s/^ {8}//gm; 
        ...
    END_MESSAGE
```

Nella sostituzione rimpiazziamo 8 spazi iniziali con la stringa vuota. Usiamo due modificatori:
`/m` cambia il comportamento di `^` in modo che faccia il match all'<b>inizio della linea</b>
anziché all'<b>inizio della stringa</b>.  `/g` dice a perl di fare una sostituzione <b>globale</b>,
ovvero di ripetere la sostituzione tante volte quanto è possibile.

Insieme questi due flag hanno l'effetto di far rimuovere alla sostituzione 8 spazi iniziali da ogni linea nella
variabile a sinistra di `=~`.
A sinistra abbiamo dovuto mettere l'assegnmento tra parentesi perché la precedenza
dell'operatore di assegnamento (`=`) è più bassa di quella del match `=~`. Senza
le parentesi, perl proverebbe per prima cosa ad applicare la regex di sostituzione all'here-document stesso
generando un errore di compilazione:

Can't modify scalar in substitution (s///) at programming.pl line 9, near "s/^ {8}//gm;"

## Usare le alternative q e qq

Ora che ho finito la mia spiegazione, posso confessare che non sono sicuro di consigliarvi di usare gli here-document.
Personalmente, in molti casi, invece degli here-document uso gli operatori `qq` e `q`.
A seconda che voglia o non voglia interpolare le stringhe:

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $name = 'Pippo';
my $send = 1;

if ($send) {
    (my $message = qq{
        Caro $name,

        questo e' un messaggio che vorrei spedirti.
    
        saluti
          firmato: il Perl Maven
        }) =~ s/^ {8}//mg;
    print $message;
}
```

