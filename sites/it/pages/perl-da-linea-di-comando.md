---
title: "Perl da linea di comando"
timestamp: 2013-04-13T20:09:01
tags:
  - -v
  - -e
  - -p
  - -i
published: true
original: perl-on-the-command-line
books:
  - beginner
author: szabgab
translator: giatorta
---


Anche se gran parte del [tutorial Perl](/perl-tutorial) utilizza degli script salvati come
file, vedremo anche un paio di esempi di programmi di una sola riga (in Inglese: "one-liner").

Anche se usate [Padre](http://padre.perlide.org/)
o qualche altro IDE che vi permette di eseguire i vostri script da dentro l'editor stesso,
è molto importante che familiarizziate con la linea di comando (o shell) e che
siate in grado di usarla per eseguire il perl.


Se usate Linux, aprite un terminale. Dovreste vedere un
prompt, che probabilmente termina con un simbolo $.

Se usate Windows aprite una finestra di comando: Selezionate

Start -> Run -> e scrivete "cmd" -> ENTER

Apparirà la finestra nera CMD con un prompt come questo:

```
c:\>
```

## Versione di Perl

Scrivete `perl -v`. Comparirà un messaggio come il seguente:

```
C:\> perl -v

This is perl 5, version 12, subversion 3 (v5.12.3)
  built for MSWin32-x86-multi-thread

Copyright 1987-2010, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl". If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

In base ad esso, scopro di avere la versione 5.12.3 di Perl installata su questa macchina Windows.


## Stampare un numero

Ora scrivete `perl -e "print 42"`.
Verrà stampato il numero `42` sullo schermo. Su Windows il prompt apparirà a capo

```
c:>perl -e "print 42"
42
c:>
```

Su Linux invece vedrete qualcosa come:

```
gabor@pm:~$ perl -e "print 42"
42gabor@pm:~$
```

Il risultato è all'inizio della linea, seguito immediatamente dal prompt.
Questa differenza è dovuta a un diverso comportamento dei due interpreti a linea di comando.

In questo esempio abbiamo usato l'opzione `-e` che dice a perl,
"Non aspettarti un file. La prossima cosa sulla linea di comando è il codice Perl da eseguire."

Questi esempi ovviamente non sono molto interessanti. Ora vi mostro un esempio un po' più
complesso senza spiegarvelo:

## Sostituire Java con Perl

Questo comando: `perl -i.bak -p -e "s/\bJava\b/Perl/" cv.txt`
Sostituisce tutte le occorrenze della parola <b>Java</b> con la parola <b>Perl</b> nel vostro
CV facendo prima un backup del file.

Su Linux avreste potuto perfino scrivere questo `perl -i.bak -p -e "s/\bJava\b/Perl/" *.txt`
per sostituire Java con Perl in <b>tutti</b> i vostri file di testo.

In futuro parleremo ancora dei one-liner e di come potete imparare ad usarli.
Per ora è sufficiente dirvi che la conoscenza dei one-liner può essere un'arma molto potente nelle vostre mani.

A proposito, per vedere alcuni one-liner molto interessanti, vi suggerisco di leggere
[Perl One-Liners explained](http://www.catonmat.net/blog/perl-book/)
di Peteris Krumins.

## Next

La prossima parte riguarda la
[documentazione del Perl base e dei moduli CPAN](https://perlmaven.com/core-perl-documentation-cpan-module-documentation).
