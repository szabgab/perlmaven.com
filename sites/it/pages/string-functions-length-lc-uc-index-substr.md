---
title: "Funzioni su stringhe: length, lc, uc, index, substr"
timestamp: 2013-09-10T21:00:00
tags:
  - length
  - lc
  - uc
  - index
  - substr
  - scalar
published: true
original: string-functions-length-lc-uc-index-substr
books:
  - beginner
author: szabgab
translator: giatorta
---


In questa parte del [Tutorial Perl](/perl-tutorial) impareremo
alcune delle funzioni fornite da Perl per la manipolazione di stringhe.


## lc, uc, length

Ci sono molte funzioni semplici come <b>lc</b> e <b>uc</b>
che restituiscono, rispettivamente, le versioni minuscola e maiuscola della stringa originale.
Esiste poi una funzione <b>length</b> che restituisce il numero di caratteri della stringa data.

Guardate il seguente esempio:

```perl
use strict;
use warnings;
use 5.010;

my $str = 'CiAo';

say lc $str;      # ciao
say uc $str;      # CIAO
say length $str;  # 4
```


## index

Un'altra funzione è <b>index</b>. Questa funzione riceve due stringhe e restituisce
la posizione della seconda stringa nella prima.

```perl
use strict;
use warnings;
use 5.010;

my $str = "Un gatto nero salto' giu' da un albero verde";

say index $str, 'gatto';           # 3
say index $str, 'cane';            # -1
say index $str, "Un";              # 0
say index $str, "un";              # 29
```

La prima chiamata a `index` restituisce 3 perché la stringa "gatto" inizia al carattere in posizione 3.
La seconda chiamata a `index` restituisce -1 per indicare che la stringa "cane" non c'è.

La terza chiamata mostra che `index` restituisce 0
quando la seconda stringa è un prefisso della prima.

Il quarto esempio mostra che `index` cerca delle corrispondenze esatte e distingue tra maiuscole e minuscole.
Quindi "un" e "Un" sono diverse.

`index()` ricerca stringhe che non devono necessariamente essere parole, quindi anche la stringa "n " può essere cercata:

```perl
say index $str, "n ";              # 1
```

`index()` può anche ricevere un terzo parametro che indica la posizione da cui
iniziare la ricerca. Quindi, dato che abbiamo trovato l'inizio di "n " al secondo carattere della prima stringa,
possiamo provare una ricerca iniziando dalla terza posizione per vedere se c'è un'altra occorrenza di "n ":

```perl
say index $str, "n ";              # 1
say index $str, "n ", 2;           # 30
say index $str, "n", 2;            # 9
```

Cercare "n" senza lo spazio da un risultato diverso.

Infine, c'è un'altra funzione <b>rindex</b>
che inizia la ricerca nella stringa da destra:

```perl
say rindex $str, "n";             # 30
say rindex $str, "n", 29;         # 9
say rindex $str, "n", 8;          # 1
```

## substr

Penso che la funzione più interessante trattata in questo articolo sia `substr`.
Essenzialmente è l'opposto di index(). Mentre index() vi dice
<b>dove si trova una data stringa</b>, substr vi da una <b>sottostringa che si trova a una data posizione</b>.
Di solito `substr` riceve 3 parametri. Il primo è la stringa. Il secondo è una posizione
a partire da 0, anche detta <b>offset</b> e il terzo è la <b>lunghezza</b> della
sottostringa che vogliamo ottenere.

```perl
use strict;
use warnings;
use 5.010;

my $str = "Il gatto nero si arrampica sull'albero verde"

say substr $str, 3, 5;                      # gatto
```

substr conta a partire da 0 quindi il carattere in posizione 3 è la lettera g.

```perl
say substr $str, 3, -18;                    # gatto nero si arrampica
```

Il terzo parametro (la lunghezza) può anche essere un numero negativo. In quel caso va interpretato
come il numero di caratteri da destra nella stringa originale che
NON devono essere inclusi. Quindi l'istruzione sopra significa: conta 3 da sinistra, 18 da destra
e restituisci quello che sta in mezzo.

```perl
say substr $str, 14;                        # si arrampica sull'albero verde
```

Potete anche omettere il terzo parametro (lunghezza), e ciò verrà interpretato come:
restituisci tutti i caratteri dalla posizione 14 alla fine della stringa.

```perl
say substr $str, -5;                        # verde
say substr $str, -5, 2;                     # ve
```

Possiamo anche usare un numero negativo come offset, che viene interpretato come:
conta 5 da destra e inizia da lì. È come specificare l'offset
`length($str)-5`.

## Rimpiazzare parti di una stringa

L'ultimo esempio è un po' funky.
In tutti i casi esaminati fino ad ora `substr` ha restituito la sottostringa
e lasciato intatta la stringa originale. In questo esempio, il valore restituito da
substr si comporterà come sempre, ma substr cambierà anche
il contenuto della stringa originale!

Il valore restituito da `substr()` è sempre determinato dai primi 3 parametri,
ma in questo caso substr ha un quarto parametro. Si tratta di una stringa che deve
sostituire la sottostringa selezionata nella stringa originale.

```perl
my $z = substr $str, 14, 12, "salta";
say $z;                                                # si arrampica
say $str;                     # Il gatto nero salta sull'albero verde
```

Quindi `substr $str, 14, 12, "salta"` restituisce le parole <b>si arrampica</b>,
ma a causa del quarto parametro, la stringa originale è stata modificata.

