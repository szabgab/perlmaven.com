---
title: "Perl na příkazové řádce"
timestamp: 2013-10-30T12:40:00
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
translator: rampa
---


Většina [Perl tutoriálu](/perl-tutorial) pojednává o skriptech uložených v souboru, uvidíme ale taky pár tzv. one-liners - jednořádkových Perl skriptů.

I v případě, že používáte [Padre](http://padre.perlide.org/)
nebo jiné IDE, které umožňuje spouštět skripty přímo, je velmi důležité se seznámit s příkazovou řádkou a naučit se používat perl odtamtud.


Pookud používáte Linux, otevřete okno terminálu. Měli byste vidět návěští (tzv. prompt), pravděpodobně končící znakem $.

pokud používáte Windows, otevřete příkazovou řádku. Klikněte na

Start -> Run -> napište "cmd" -> ENTER

Uvidíte černé okno programu CMD s návěštím (promptem), které nejspíš vypadá takto:

```
c:\>
```

## Verze Perlu

Napište `perl -v`. Vypíše se něco jako:

```
C:\> perl -v

This is perl 5, version 12, subversion 3 (v5.12.3)
  built for MSWin32-x86-multi-thread

Copyright 1987-2010, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

Podle výpisu můžete říct, že máte na tomto stroji s Windows nainstalovanou verzi Perlu 5.12.3.


## Výpis čísla

Teď napište `perl -e "print 42"`.
Na obrazovku se vypíše číslo `42`. Ve Windows se prompt zobrazí na další řádce.

```
c:>perl -e "print 42"
42
c:>
```

Na Linuxu uvidíte něco jako:

```
gabor@pm:~$ perl -e 'print 42'
42gabor@pm:~$
```

Všimněte si, že jsem použil apostrof `'` na Linuxu a uvozovky `"` ve Windows.
To je nutné kvůli různému chování příkazové řádky v těchto dvou operačních systémech.
Nemá to nic společného s Perlem.

Výsledek je na začátku řádky, bezprostředně následován promptem.
Rozdíl v zobrazení je dán různým chováním obou příkazových řádek.

V tomto příkladu používáme přepínač `-e`, který perlu říká
"Neočekávej soubor. Další část příkazu je samotný Perl kód."

Uvedené příklady samozřejmě nejsou příliš zajímavé. Ukážu vám o něco složitější příklad, prozatím bez vysvětlení:

## Nahraď Javu Perlem

Příkaz `perl -i.bak -p -e "s/\bJava\b/Perl/" zivotopis.txt`
nahradí ve vašem životopise všechny výskyty slova <b>Java</b> slovem <b>Perl</b>. Původní verze souboru bude zálohována.

Na Linuxu byste dokonce mohli napsat `perl -i.bak -p -e 's/\bJava\b/Perl/' *.txt`
pro nahrazení Javy Perlem ve <b>všech</b> textových souborech.

(Ještě jednou, na Linuxu/Unixu byste měli vždy používat na příkazové řádce apostrofy, zatímco ve Windows uvozovky.)

V jedné z dalších částí budeme mluvit dalších o jednořádkových Perl skriptech a naučíte se je používat.
Krátce řečeno, znalost one-linerů je velmi mocnou zbraní.

Mimochodem, pokud byste rádi viděli pár velmi kvalitních one-linerů, doporučuji si přečíst
[Perl One-Liners explained](http://www.catonmat.net/blog/perl-book/)
od Peterise Kruminse.

## Další

Další část je o
[dokumentaci Perlu a dokumentaci CPAN modulů](/core-perl-documentation-cpan-module-documentation).


