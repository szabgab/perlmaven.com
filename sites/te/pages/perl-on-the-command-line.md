---
title: "Command line లో Perl ఉపయోగించడం"
timestamp: 2013-04-26T23:02:56
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
translator: balasatishreddykarri
---


[Perl tutorial](/perl-tutorial) లో ఎక్కువగా స్క్రిప్ట్స్ ని ఫైల్స్ లో సేవ్ చేసి వాడతాము.
ఇప్పుడు మనం one-liners లో ఎలా వాడాలో చూద్దాం.

మీరు [Padre](http://padre.perlide.org/) లేదా వేరే IDE వాడితే వాటిలోనే స్క్రిప్ట్ ని రన్ చెయ్యవచ్చు.
command line (or shell) లో Perl ని ఎలా రన్ చెయ్యాలో కూడా తెలుసుకోవడం చాలా ముఖ్యం.


మీరు Linux ని వాడుతుంటే టెర్మినల్ విండొ (terminal window) ని ఓపెన్ చెయ్యండి. $ సింబల్ తో ఆఖరి అయ్యే ప్రాంప్ట్ (prompt) ని చూడవచ్చు.

మీరు Windows ని వాడుతుంటే క్రింది విధంగా ఓపెన్ చెయ్యొచ్చు.

Start -> Run -> "cmd" అని టైప్ చేసి -> OK ని ప్రెస్ చెయ్యండి.

క్రింద చూపించిన విధంగా ఒక నలుపు రంగు విండొ ఓపెన్ అవుతుంది.

```
c:\>
```

## Perl వర్షన్

`perl -v` అని టైప్ చేసి ENTER ప్రెస్ చెయ్యండి.  క్రింది విధంగా ప్రింట్ అవుతుంది.

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

దీనిని బట్టే మీ సిస్టమ్ లో ఏ Perl వర్షన్ ఇన్‌స్టాల్ అయ్యిందో తెలుసుకోవచ్చు.

## ఒక నంబర్ ని ప్రింట్ చేద్దాం

`perl -e "print 42"` అని టైప్ చెయ్యండి.
`42` నంబర్ ని స్క్రీన్ మీద ప్రింట్ చేస్తుంది. క్రింది విధంగా Windows లో తరువాత లైన్ లో ఔట్పుట్ ప్రింట్ అవుతుంది.

```
c:>perl -e "print 42"
42
c:>
```

Linux లో క్రింది విధంగా ఉంటుంది.

```
gabor@pm:~$ perl -e "print 42"
42gabor@pm:~$
```

ఔట్పుట్ లైన్ మొదటగా prompt ముందు వస్తుంది.
ఈ తేడా కమ్యాండ్-లైన్ ఇంటర్ప్రెటర్స్ బిహేవియర్ (command-line interpreter behavior) మీద ఆధారపడి ఉంటుంది.

Perl తరువాత `-e` ఉండడం వలన ఫైల్ కోసం చూడకుండా తరువాత ఉన్న Perl కోడ్ ని రన్ చేస్తుంది.

పైన చెప్పుకుంది చిన్న ఉదాహరణ మాత్రమే, క్రింద మరొక ఉదాహరణ చూద్దాం.

## Java ఉన్న చోట Perl అని మారుద్ధాం.

`perl -i.bak -p -e "s/\bJava\b/Perl/" resume.txt`

పై కమ్యాండ్ టెక్స్ట్ ఫైల్ లో Java అని ఉన్న ప్రతి చోట Perl అని మార్చి, పాత డాటని బ్యాకప్ ఫైల్ లో పెడుతుంది.

Linux లో `perl -i.bak -p -e "s/\bJava\b/Perl/" *.txt` అని వ్రాసి <b>అన్ని ఫైల్స్ </b>లో ఒక్కసారే Java ని Perl గా మర్చొచ్చు.

one-liners ఇంకా ఏవిధంగా వాడొచ్చో ముందు సెక్షన్స్ లో తెలుసుకొందాం.

one-liners నాలెజ్ కల్గి ఉండడం చాలా మంచిది మరియు ముఖ్యమైనది.

మీరు ఇంకా కొన్ని one-liners గురించి తెలుసుకోవాలంటే  Peteris Krumins వ్రాసిన [Perl One-Liners explained](http://www.catonmat.net/blog/perl-book/) బాగుంటుంది.

## Next

తరువాతి భాగం  [Core Perl డాక్యుమెంటేషన్ and CPAN module డాక్యుమెంటేషన్](/core-perl-documentation-cpan-module-documentation).


