---
title: "Tutorial Perl"
timestamp: 2012-07-06T00:01:50
description: "Tutorial Perl gratuit pentru persoane care trebuie să întrețină cod Perl, pentru persoane care folosesc Perl pentru mici scripturi și pentru dezvoltarea de aplicații Perl."
types:
  - training
  - course
  - beginner
  - tutorial
published: true
original: perl-tutorial
author: szabgab
translator: stefansbv
archive: false
---

Tutorialul Perl Maven te învață bazele programării în limbajul Perl.
Vei fi în stare să scrii scripturi simple, să analizezi fișiere log și
să citești și să scrii fișiere CSV.  Acesta doar ca să arătăm câteva
dintre cele mai comune sarcini.

Vei învăța să folosești CPAN și un număr de module CPAN specifice.

Va fi fundația pe care să poți construi.

Versiunea gratuită on-line a tutorialului este în dezvoltare. Multe
părți sunt gata. Părți noi sunt publicate la două - trei zile. Cel mai
nou a fost publicat în data de 15 mai 2013. Dacă ești interesat să
primești notificări pentru articolele publicate, te rog să te <a
href="/register">înscrii la newsletter</a>.

Există de asemenea și o carte în
format [e-book](https://perlmaven.com/beginner-perl-maven-e-book) a materialului
care poate fi achiziționată.  În completare la tutorialul gratuit,
acea versiune include de asemenea și diapozitivele de prezentare de la
cursul corespunzător și multe exerciții cu rezolvările lor. Materialul
de curs acoperă toate părțile, inclusiv pe cele care nu sunt încă în
versiunea gratuită.

Cursul este acompaniat și
de [video-course](https://perlmaven.com/beginner-perl-maven-video-course) în
limba engleză și include peste 210 screencast-uri, un total de mai
mult de 5 ore de vizionare. În plus față de materialul de prezentare,
cuprinde de asemenea explicații ale soluțiilor pentru toate
exercițiile.  Pachetul include de asemenea codul sursă al tuturor
exemplelor și exercițiilor.

## Tutorial gratuit on-line Perl Maven pentru începători

În acest tutorial vei învăța cum să folosești limbajul de programare Perl 5
pentru ca <b>treaba să fie făcută</b>.

Vei învăța atât despre caracteristicile generale ale limbajului, cât
și despre extensii sau biblioteci sau așa cum sunt ele numite de către
programatorii Perl - <b>module</b>.

Vom vedea module standard, cele care vin cu Perl și module pe care
le vom instala din <b>CPAN</b>.

Atunci când este posibil, voi încerca să predau lucrurile într-o
manieră orientată pe sarcini. Voi schița sarcinile și după aceea vom
învăța despre uneltele necesare pentru a le duce la
îndeplinire. Atunci când este posibil, te voi îndruma către exerciții
pe care să le rezolvi pentru a pune în practică ceea ce ai învățat.

<p>
<b>Introducere</b>
<ol>
<li>[Instalează Perl în Windows, Linux și Mac](/instalare-perl-windows-linux-mac)</li>
<li>[Perl Editor](/perl-editor-ide)</li>
<li>[Perl în linia de comandă](/perl-in-linia-de-comanda)</li>
<li>[Documentația Perl și documentația modulelor CPAN](/documentatia-perl-si-documentatia-modulelor-cpan)</li>
<li>[POD - Plain Old Documentation](/pod-plain-old-documentation-pentru-perl)</li>
<li>[Depanarea programelor Perl](/depanarea-programelor-perl)</li>
</ol>

<b>Scalari</b>
<ol>
<li>Mesaje de eroare comune și atenționări (warnings)<br />
* [Simbolul global necesită un nume de pachet explicit](/simbolul-global-necesita-nume-de-pachet-explicit)
* [Folosirea unei valori neinițializate](/folosirea-unei-valori-neinitializate)
* [Cuvintele "goale" nu sunt admise sub "strict subs"](/cuvinte-goale-in-perl)
* [Denumirea "main::x" este folosită doar o dată: posibilă eroare la ...](/denumire-folosita-doar-o-data-posibila-eroare)
* [Categorie de avertizări necunoscută](/categorie-de-avertizari-necunoscuta)
* [Scalar found where operator expected](https://perlmaven.com/scalar-found-where-operator-expected)
* ["my" variable masks earlier declaration in same scope](https://perlmaven.com/my-variable-masks-earlier-declaration-in-same-scope)
</li>
<li>[Automatic string to number conversion](https://perlmaven.com/automatic-value-conversion-or-casting-in-perl)</li>
<li>Instrucțiuni condiționale: if</li>
<li>[Boolean (true and false) values in Perl](https://perlmaven.com/boolean-values-in-perl)</li>
<li>Operatori numerici și pentru șiruri</li>
<li>[undef, the initial value and the defined function](https://perlmaven.com/undef-and-defined-in-perl)</li>
<li>[Strings in Perl: quoted, interpolated and escaped](https://perlmaven.com/quoted-interpolated-and-escaped-strings-in-perl)</li>
<li>Documente integrate (Here documents)</li>
<li>[Scalar variables](https://perlmaven.com/scalar-variables)</li>
<li>[Comparing scalars](https://perlmaven.com/comparing-scalars-in-perl)</li>
<li>[String functions: length, lc, uc, index, substr](https://perlmaven.com/string-functions-length-lc-uc-index-substr)</li>
<li>[Number Guessing game (rand, int)](https://perlmaven.com/number-guessing-game)</li>
<li>[Perl while loop](https://perlmaven.com/while-loop)</li>
<li>[Scope of variables in Perl](https://perlmaven.com/scope-of-variables-in-perl)</li>
</ol>

<b>Fișiere</b>
<ol>
<li>[exit](https://perlmaven.com/how-to-exit-from-perl-script)</li>
<li>[Standar Output, Standard Error and command line redirection](https://perlmaven.com/stdout-stderr-and-redirection)</li>
<li>[Aviz (warn)](/aviz)</li>
<li>die</li>
<li>[Crearea fișierelor cu Perl](/crearea-fisierelor-cu-perl)</li>
<li>[Adăugare conținut la fișiere](/adaugare-continut-la-fisiere)</li>
<li>[Open and read from files using Perl](https://perlmaven.com/open-and-read-from-files)</li>
<li>[Don't open files in the old way](https://perlmaven.com/open-files-in-the-old-way)</li>
<li>Binary mode, dealing with Unicode</li>
<li>Reading from a binary file, read, eof</li>
<li>tell, seek</li>
<li>truncate</li>
</ol>

<b>Liste și tablouri (arrays)</b>
<ol>
<li>Perl foreach loop</li>
<li>[Bucla for în Perl](/bucla-for-in-perl)</li>
<li>Lists in Perl</li>
<li>Using Modules</li>
<li>[Arrays in Perl](https://perlmaven.com/perl-arrays)</li>
<li>Process command line parameters @ARGV, Getopt::Long</li>
<li>[How to read and process a CSV file? (split, Text::CSV_XS)](https://perlmaven.com/how-to-read-a-csv-file-using-perl)</li>
<li>[join](https://perlmaven.com/join)</li>
<li>[The year of 19100 (time, localtime, gmtime)](https://perlmaven.com/the-year-19100) and introducing context</li>
<li>[Context sensitivity in Perl](https://perlmaven.com/scalar-and-list-context-in-perl)</li>
<li>[Sorting arrays in Perl](https://perlmaven.com/sorting-arrays-in-perl)</li>
<li>[Unique values in an array in Perl](https://perlmaven.com/unique-values-in-an-array-in-perl)</li>
<li>[Manipulating Perl arrays: shift, unshift, push, pop](https://perlmaven.com/manipulating-perl-arrays)</li>
<li>Stack and queue</li>
<li>reverse</li>
<li>the ternary operator</li>
<li>Loop controls: next and last</li>
<li>min, max, sum using List::Util</li>
</ol>

<b>Subrutine</b>
<ol>
<li>[Subroutines and Functions in Perl](https://perlmaven.com/subroutines-and-functions-in-perl)</li>
<li>Parameter passing and checking for subroutines</li>
<li>Variable number of parameters</li>
<li>Returning a list</li>
<li>Recursive subroutines</li>
</ol>

<b>Tabele de dispersie (Hashes), Tablouri (arrays)</b>
<ol>
<li>[Perl Hashes (dictionary, associative array, look-up table)](https://perlmaven.com/perl-hashes)</li>
<li>exists, delete hash elements</li>
</ol>

<b>Expresii Regulare</b>
<ol>
<li>Regular Expressions in Perl</li>
<li>Regex: character classes</li>
<li>Regex: quantifiers</li>
<li>Regex: Greedy and non-greedy match</li>
<li>Regex: Grouping and capturing</li>
<li>Regex: Anchors</li>
<li>Regex options and modifiers</li>
<li>Substitutions (search and replace)</li>
<li>[trim - remove leading and trailing spaces](https://perlmaven.com/trim)</li>
</ol>

<b>Funcțiuni relative la Perl și Shell</b>
<ol>
<li>Perl -X operators</li>
<li>Perl pipes</li>
<li>Running external programs</li>
<li>Unix commands: rm, mv, chmod, chown, cd, mkdir, rmdir, ln, ls, cp</li>
<li>[How to remove, copy or rename a file with Perl](https://perlmaven.com/how-to-remove-copy-or-rename-a-file-with-perl)</li>
<li>Windows/DOS commands: del, ren, dir</li>
<li>File globbing (Wildcards)</li>
<li>Directory handles</li>
<li>Traversing directory tree (find)</li>
</ol>

<b>CPAN</b>
<ol>
<li>[Download and install Perl (Strawberry Perl or manual compilation)](https://perlmaven.com/download-and-install-perl)</li>
<li>Download and install Perl using Perlbrew</a></li>
<li>Locating and evaluating CPAN modules</li>
<li>Downloading and installing Perl Modules from CPAN</li>
<li>[How to change @INC to find Perl modules in non-standard locations?](https://perlmaven.com/how-to-change-inc-to-find-perl-modules-in-non-standard-locations)</li>
<li>How to change @INC to a relative directory</li>
<li>local::lib</li>
</ol>

<b>Câteva exemple de utilizare pentru Perl</b>
<ol>
<li>[How to replace a string in a file with Perl? (slurp)](https://perlmaven.com/how-to-replace-a-string-in-a-file-with-perl)</li>
<li>Reading Excel files using Perl</li>
<li>Creating Excel files using Perl</li>
<li>Sending e-mail using Perl</li>
<li>CGI scripts with Perl</li>
<li>Web applications with Perl: PSGI</li>
<li>Parsing XML files</li>
<li>Reading and writing JSON files</li>
<li>[Database access using Perl (DBI, DBD::SQLite, MySQL, PostgreSQL, ODBC)](https://perlmaven.com/simple-database-access-using-perl-dbi-and-sql)</li>
<li>Accessing LDAP using Perl</li>
</ol>

<b>Altele</b>
<ol>
<li>[Splice to slice and dice arrays in Perl](https://perlmaven.com/splice-to-slice-and-dice-arrays-in-perl)</li>
<li>[How to create a Perl Module for code reuse](https://perlmaven.com/how-to-create-a-perl-module-for-code-reuse)</li>
<li>[Object Oriented Perl using Mooses](https://perlmaven.com/object-oriented-perl-using-moose)</li>
<li>[Attribute types in Perl classes when using Moose](https://perlmaven.com/attribute-types-in-perl-classes-when-using-moose)
</ol>


<hr />

Vă reamintim că există și varianta [e-book](https://perlmaven.com/beginner-perl-maven-e-book) și 
[cursuri video](https://perlmaven.com/beginner-perl-maven-video-course) care pot fi [achiziționate](/products).
