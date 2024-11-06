---
title: "Instalace Perlu a první kroky"
timestamp: 2013-10-30T12:40:01
tags:
  - strict
  - warnings
  - say
  - print
  - chomp
  - scalar
  - $
types:
  - screencast
published: true
original: installing-perl-and-getting-started
books:
  - beginner
author: szabgab
translator: rampa
---


Toto je první část [Perl tutoriálu](/perl-tutorial).

V této části se naučíte instalovat Perl v Microsoft Windows and používat jej ve Windows, Linuxu nebo Macu.

Najdete zde návod jak nastavit své vývojové prostředí, nebo řečeno méně vzletnými slovy: který editor nebo IDE používat pro psaní Perlu?

Ukážeme si také standardní příklad "Hello World".


## Windows

Pro Windows použijeme [DWIM Perl](http://dwimperl.com/). Je to balík, který obsahuje Perl kompilátor/interpret, [Padre, the Perl IDE](http://padre.perlide.org/)
a množství modulů z CPANu.

Začněte návštěvou stránky [DWIM Perl](http://dwimperl.com/)
a stáhněte <b>DWIM Perl for Windows</b>.

Stažený exe soubor nainstalujte. Před tím než to uděláte se prosím ujistěte, že nemáte nainstalovaný jiný Perl.

Mohly by pracovat vedle sebe, to by ale vyžadovaly hlubší vysvětlení.
Prozatím mějme v systému nainstalovanou jediinou verzi Perlu.

## Linux

Většina moderních distribucí Linuxu už obsahuje novější verzi Perlu.
Prozatím se s ní spokojíme. Jako editor můžete nainstalovat Padre - pro většinu distribucí Linuxu jsou k dispozici ofociální balíčky. Nebo můžete použít libovolný textový editor.
Pokud znáte vim nebo Emacs, můžete jej použít. Jinak by mohl být dobrým jednoduchým editorem Gedit.

## Apple

Domnívám se, že pro Macy také existuje Perl, který můžete nainstalovat standardní cestou.

## Editor a IDE

I když doporučuji používat Padre ID pro psaní Perlu, není to nezbytné.
V další části uvedu několik [editorů a IDE](/perl-editor) které můžete pro programování v Perlu použít. I v případě, že budete používat jiný editor, uivatelům Windows doporučuji nainstalovat zmíněný DWIM Perl.

Obsahuje mnoho rozšiřujících balíčků, takže vám ušetří v budoucnu hodně času.

## Video

Pokud dáváte přednost videu, můžete se podívat na moje 
[Hello world with Perl](http://www.youtube.com/watch?v=c3qzmJsR2H0). V tom případě by vás mohlo zajímat také [Beginner Perl Maven video course](https://perlmaven.com/beginner-perl-maven-video-course).

## První program

Váš první program bude vypadat takto:

```perl
use 5.010;
use strict;
use warnings;

say "Hello World";
```

Vysvětleme si ho krok za krokem.

## Hello world

Když nainstalujete DWIM Perl, kliknutím na "Start -> All programs -> DWIM Perl -> Padre" spustíte editor s prázdným souborem.

Napište

```perl
print "Hello World\n";
```

Všimněte si, že se příkazy v perlu ukončují středníkem `;`.
`\n` představuje novou řádku.
Řetězce se uzavírají do uvozovek `"`.
Funkce `print` píše na obrazovku.
Když se program spustí, vypíše na obrazovku text a na konec přidá novou řádku.

Uložte soubor jako hello.pl a spusťte jej pomocí "Run -> Run Script".
Otevře se zvláštní okno s výstupem programu.

To je vše, právě jste napsali svůj první perl skript.

Pojďme jej trochu rozšířit.

## Perl na příkazové řádce pro ne-Padre uživatele.

Pokud nepoužíváte Padre nebo žádné z dalších [IDE](/perl-editor), nebudete moci spustit váš skript přímo z editoru.
Tedy ne bez dalšího nastavení. Budte muset otevřít shell
(nebo cmd ve Windows), přepnout se do adresáře, kam jste umístili soubor hello.pl a napsat:

`perl hello.pl`

Takto můžete spouštět váš skript s příkazové řádky.

## say() namísto print()

Pojďme náš jednořádkový Perl skript trochu rozšířit:

Ze všeho nejdřív určeme, jakou minimální verzi Perlu bychom rádi použili:

```perl
use 5.010;
print "Hello World\n";
```

Teď můžete skript znovu spustit pomocí menu "Run -> Run Script" nebo pomocí klávesové zkratky <b>F5</b>.
Soubor se tím automaticky uloží.

Obecně je dobrým zvykem určovat, jakou minimální verzi perlu váš kód vyžaduje.

V našem případě díky tomu také získáme několik nových vlastností včetně klíčového slova `say`.
`say` je jako `print`, jen je kratší a automaticky přidává na konec nový řádek.

Můžete váš kód změnit takto:

```perl
use 5.010;
say "Hello World";
```

Zaměnili jsme `print` za `say` a odstranili `\n` na konci řetězce.

Instalace, kterou používáte je pravděpodobně verze 5.12.3 nebo 5.14.
Většina moderních distribucí Linuxu obsahuje verzi 5.10 nebo novější.

Starší verze perlu se ale naneštěstí stále používají.
Nebudete s nimi moci použít klíčové slovo `say()` a další pčíklady možná budou vyžadovat nějaké úpravy. Když budu používat vlastnosti vyžadující verzi 5.10, upozorním na ně.

## Záchranná síť

Navíc bych v každém skriptu důrazně doporučil pár dalších úprav chování Perlu. Proto přidáme 2 takzvaná pragmata, která jsou velmi podobná přepínačům kompilátoru v jiných jazycích.

```perl
use 5.010;
use strict;
use warnings;

say "Hello World";
```

Klíčové slovo `use` říká perlu aby nahrál a aktivoval jednotlivá pragmata.

`strict` a `warnings` vám pomohou odhalit některé běžné chyby v kódu, nebo dokonce zabrání jejich vzniku.
Jsou velmi užitečné.

## Vstup dat

V dalším kroku se dotážem uživatelky na jméno a zobrazíme jej v odpovědi.

```perl
use 5.010;
use strict;
use warnings;

say "Jak se jmenuješ? ";
my $jmeno = <STDIN>;
say "Ahoj $jmeno, jak se máš?";
```

`$jmeno` je tzv. skalární proměnná.

Proměnné se deklarují pomocí klíčového slova <b>my</b>.
(Ve skutečnosti je to jeden požadavků, které přidává `strict`.)

Skalární proměnné vždy začínají znakem `$`.
&lt;STDIN&gt; je nástroj pro čtení řádky textu z klávesnice.

Zapište kód do souboru a spusťte jej pomocí F5.

Skript se dotáže na vaše jméno. Napište své jméno a stiskněte ENTER. Tím dáte perlu najevo, že jste se zápisem jména hotovi.

Všimněte si, že výpis je trochu rozbitý: čárka za jménem se objeví na nové řádce. Důvodem je ENTER, který jste stiskli po zadání jména. Ten se zapíše do proměnné `$name` společně se jménem.

## Jak se zbavit konce řádky

```perl
use 5.010;
use strict;
use warnings;

say "Jak se jmenuješ? ";
my $jmeno = <STDIN>;
chomp $jmeno;
say "Ahoj $jmeno, jak se máš?";
```

Odstranění konce řádky je v Perlu tak běžný krok, že pro něj existuje speciální funkce `chomp`. Ta z řetězce konec řádky odstraní.


## Shrnutí

V každém skriptu, který napíšete byste měli <b>vždy</b> jako první dva příkazy použít `use strict;` a `use warnings;`.
 Velmi se také doporučuje přidat `use 5.010;`.

## Cvičení

Slíbil jsem cvičení.

Vyzkoušejte následující skript:

```perl
use strict;
use warnings;
use 5.010;

say "Hello ";
say "World";
```

Slova se nevypsala na jeden řádek.. Proč? Jak to opravit?

## Cvičení 2

Napište skript, který se uživatele dotáže na dvě čísla, jedno po druhém.
Pak vypíše součet zadaných čísel.

## Co dál?

Další část tutoriálu je o
[editorech, IDE a vývojovém prostředí pro Perl](/perl-editor).

