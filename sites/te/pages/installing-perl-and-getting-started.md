---
title: "Perl ని ఇన్‌స్టాల్ చెయ్యడం మరియు ప్రారంభించడం"
timestamp: 2013-04-22T01:22:02
tags:
  - strict
  - warnings
  - say
  - print
  - chomp
  - scalar
  - $
published: true
original: installing-perl-and-getting-started
books:
  - beginner
author: szabgab
translator: balasatishreddykarri
---


[Perl tutorial](/perl-tutorial) లో ఇది మొదటి అద్యాయం.

ఈ భాగం లో Perl ని Microsoft Windows లో ఎలా ఇన్‌స్టాల్ చెయ్యాలో మరియు  Windows, Linux లేక  Mac లో ఎలా ఉపయోగించాలో మీరు చదువుకుంటారు.

Perl ని ఎలా ఇన్‌స్టాల్ చెయ్యాలి మరియు కోడ్ వ్రాయడానికి ఏమీ editor లేక IDE వాడాలి?

"Hello World" ఉదాహరణ మీరు చూడవచ్చు.


## Windows

Windows లో మనము [DWIM Perl](http://dwimperl.com/) ఉపయోగిస్తాము.  ఈ 
ప్యాకేజ్  Perl కంపైలర్ / ఇంటర్ప్రెటర్ కల్గి ఉంటుంది,[Padre, the Perl IDE](http://padre.perlide.org/) 
కూడా కొన్ని CPAN ఎక్స్‌టెన్షన్స్ కల్గిఉంటుంది.

[DWIM Perl](http://dwimperl.com/) వెబ్‌సైట్ ని సందర్శించి  డౌన్‌లోడ్ చేసుకోడానికి <b>DWIM Perl for Windows</b> లింక్ ని అనుసరించండి..

exe ఫైల్ ని డౌన్‌లోడ్ చేసి మీ సిస్టమ్ లో ఇన్‌స్టాల్ చేయండి. మీరు ఇన్‌స్టాల్ చేసేముందు ఇదివరకు వర్షన్ లేకుండా జాగర్తపడండి.

ప్రస్తుతం ఒక వర్షన్ తోటే మొదలుపెడదాం.

## Linux

సాదారణంగా ఎక్కువ Linux లు కొత్త Perl వర్షన్ తో వస్తాయ్. ప్రస్తుతం అదే వర్షన్ ఉపయొగిద్దాము.

ఎడిటర్ కోసం Padre ఇన్‌స్టాల్ చేసుకోవచ్చు. ఇది Linux అఫీషియల్ ప్యాకేజ్ మ్యానేజ్మెంట్ సిస్టమ్ లో ఉంటుంది. మామూలు text ఎడిటర్ కూడా ఉపయోగించవచ్చు. 

మీకు vim లేక Emacs తెల్సుంటే వాటినికూడా వాడొచ్చు. Gedit కూడా బాగుంటుంది.

## Apple

Macs లో కూడా Perl ముందుగానే ఇన్‌స్టాల్ చేసి ఉంటుంది. లేక పోతే standard installation tools ద్వారా ఇన్‌స్టాల్ చేసుకోవచ్చు.

## Editor మరియు  IDE

Perl కోడ్ వ్రాయడానికి Padre IDE కచ్చితంగా ఉపయోగించాలి అని ఏమీ లేదు. తరువాతి బాగం లో మరికొన్ని   [editors మరియు  IDEs](/perl-editor)

గురించి చదువుకుందాం.  

మీరు Windows వాడితే DWIM Perl package ఉపయోగేస్తే మీ సమయం వృదాకాదు. ఎందుకంటే ఇది చాలా Perl extensions కల్గి ఉంటుంది.

## Video

మీరు కావాలంటే  
[Hello world with Perl](http://www.youtube.com/watch?v=c3qzmJsR2H0)
వీడియో చూడవచ్చు. [Beginner Perl Maven video course](/beginner-perl-maven-video-course).
కూడా చూడండి.

## First program

మీ మొదటి ప్రోగ్రామ్ :

```perl
use 5.010;
use strict;
use warnings;

say "Hello World";
```

## Hello world

DWIM Perl ఇన్‌స్టాల్ చేసిన తరువాత 

"Start -> All programs -> DWIM Perl -> Padre" కి వెళ్ళి క్లిక్ చెయ్యండి.

ఖాళీ ఫైల్ తో ఎడిటర్ ఓపెన్ అవుతుంది.

క్రింది విదంగా టైప్ చేయండి

```perl
print "Hello World\n";
```

Perl లో ప్రతి   statement చివరా `;` ఉంటుంది..

కొత్త లైన్ మొదలుపెట్టడానికి `\n` వాడాలి.

Strings ని `"` లో పెడతాం.

`print` ని స్క్రీన్ లో ప్రింట్ చెయ్యడానికి వాడతాం .

ఫైల్ ని hello.pl అని సేవ్ చేసి   "Run -> Run Script" ని క్లిక్ చేయండి. ఒక కొత్త విండొ లో ఔట్పుట్ ప్రింట్ అవుతుంది.

మీ మొదటి Perl ప్రోగ్రామ్  పూర్తిఅయ్యీంది.

## Perl command line లో ఉపయోగించడం 

మీరు Padre లేదా మిగ తా  [IDEs](/perl-editor) వాడక పోతే editor ద్వారా ప్రోగ్రామ్ రన్ చెయ్యలేరు.

అందుకని  shell(or cmd in Windows) ఓపెన్ చేసి directory ని hello.pl ప్రోగ్రామ్ ఉన్న ప్రదేశానికి మార్చండి.

తరువాత క్రింది విదంగా ప్రోగ్రామ్ రన్ చేయండి.

`perl hello.pl`

ఈ పై విధంగా command line లో మీ ప్రోగ్రామ్ రన్ చెయ్యొచ్చు

## say() బదులు  print() వాడవచ్చు

మొదట మనం కనీస Perl వర్షన్ ని ఉపయొగిద్దామ్:

```perl
use 5.010;
print "Hello World\n";
```

పై విదంగా టైప్ చేసిన తరువాత "Run -> Run Script" లేక  <b>F5</b> ప్రెస్ చేసి రన్ చెయ్యొచ్చు,

రన్ చేసే ముందుగానే ఇది ఫైల్ ని సేవ్ చేసుకుంటుంది.

`use 5.010;` సాధారణంగా ఇది  మీ కోడ్ కనీస వెర్షన్ చెప్పడానికి ఒక మంచి పద్ధతి.

`say` కూడా `print` లాగే ఉపయోగపడుతుంది మరియు చివరిలో కొత్త లైన్ ని ఆడ్ చేస్తుంది.

మీరు మీ కోడ్ని క్రింది విదంగా మార్చుకోవచ్చు:

```perl
use 5.010;
say "Hello World";
```

`print` ని `say` గా మార్చాం మరియు ని  `\n` తీసివేసాం.

మీరు ప్రస్తుతం వెర్షన్ 5.12.3 లేదా 5.14 ఉపయోగిస్తున్నారు. కొత్త  Linux distributions వెర్షన్ 5.10 లేదా వర్షన్ తో వస్తున్నాయి.

కానీ కొంతమంది పాత వర్షన్లని ఉపయోగిస్తున్నారు. వారు  `say()` ఫంక్షన్ ని వాడలేకపోవచ్చు లేదా కొన్ని మార్పులు కావలెను మనం వాటిని ముందు ముందు చూద్దాం.

## Safety net

ఏ స్క్రిప్‌టింగ్ బాష లో ఐనా దాని యొక్క ప్రవర్తన లేదా లక్షణాలు (behavior) కోల్పోకుండా చూడడం మన బాధ్యత.

దానికోసమే రెండు pragmatas ని కలిపాము. ఇవి మిగత బాష లో కంపైలర్ ఫ్ల్యాగ్స్ లానే వుంటాయి.

```perl
use 5.010;
use strict;
use warnings;

say "Hello World";
```

ఇక్కడ  `use` కీవర్డ్ ప్రతి pragma ని ఉపయోగించడానికి సిద్దం చేస్తుంది.

`strict` మరియు `warnings` సాదారణంగా వచ్చే దోషాలుని గుర్తించి చెప్పుతుంది.

## User Input

మన ఉదాహరణాన్ని ఇంకా మెరుగుగా మార్చుదాము.

పేరుని అడిగి దానిని ప్రింట్ చేద్దాం.

```perl
use 5.010;
use strict;
use warnings;

say "What is your name? ";
my $name = <STDIN>;
say "Hello $name, how are you?";
```

`$name`  దీన్ని స్కేలర్ వేరియబల్ (scalar variable) అంటారు.

స్కేలర్ వేరియబల్స్ ని  <b>my</b> తో చూశిస్తాము. ( `strict` ఉంది అంటే కచ్చితంగా my వాడాలి.)

స్కేలర్ వేరియబల్స్  `$` తో మొదలవుతాయి

&lt;STDIN&gt; ఉపయోగించి కీబోర్డ్ ద్వారా టెక్స్ట్ని తీసుకోవచ్చు.

పై విదంగా రాసి F5 నొక్కండి

మీ పేరు అడుగుతుంది. మీ పేరు టైప్ చేసిన తరువాత ENTER నొక్కండి.

మీ output లో మీరు కామా ని చూడవచ్చు. ఇది ENTER వాడడం వలన కామా తరువాత కొత్త లైన్ ని తీసుకుంది.

## Getting rid of newlines

```perl
use 5.010;
use strict;
use warnings;

say "What is your name? ";
my $name = <STDIN>;
chomp $name;
say "Hello $name, how are you?";
```

`chomp` స్ట్రింగ్ లో వచ్చే కొత్త లైన్ ని తొలిగిస్తుంది.


## Conclusion

ఇప్పటి నుండి మీరు రాసే ప్రతి Perl script లోను  `use strict;` మరియు `use warnings;` ని కచ్చితంగా వాడండి.
`use 5.010;` ని వాడడం కూడా మంచిది.

## Exercises

క్రింది script ని ఉపయోగించండి.:

```perl
use strict;
use warnings;
use 5.010;

say "Hello ";
say "World";
```

ఇది output ని ఒకే లైన్ లో చూపించదు. ఎందుకు ? అలా చూపించడానికి ప్రోగ్రామ్ ని ఎలా వ్రాయాలి?

## Exercise 2

స్క్రిప్ట్ యూసర్ని రెండు నంబర్స్ని ఒక దాని తరువాత మరొకదాన్ని అడగాలి. తరువాత ఆ రెండిటి మొత్తాన్ని ప్రింట్ చెయ్యాలి.


## Next

తరువాతి భాగం  [Command line లో Perl ఉపయోగించడం](/perl-on-the-command-line).





