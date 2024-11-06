---
title: "Core Perl డాక్యుమెంటేషన్ and CPAN module డాక్యుమెంటేషన్"
timestamp: 2013-05-18T06:54:56
tags:
  - perldoc
  - documentation
  - POD
  - CPAN
published: true
original: core-perl-documentation-cpan-module-documentation
books:
  - beginner
author: szabgab
translator: balasatishreddykarri
---


Perl చాలా డాక్యుమెంటేషన్లతో వస్తుంది,కానీ మనం అన్ని ఉపయోగించడానికి కొంత సమయం పడుతుంది.
ఈ [Perl tutorial](/perl-tutorial) లో డాక్యుమెంటేషన్ ని ఎలా ఉపయోగించాలో చూద్దాం.


## వెబ్ లో perldoc

[perldoc](http://perldoc.perl.org/) వెబ్‌సైట్ ని సందర్శించి చాలా సులభంగా డాక్యుమెంటేషన్ ని వాడుకోవచ్చు.

ఇది HTML వర్షన్ డాక్యుమెంటేషన్ కల్గి ఉంటుంది. modules, Perl 5 Porters అనుసరించి core Perl తో వస్తాయి.

ఇది CPAN modules డాక్యుమెంటేషన్ ని కల్గి ఉండదు. CPAN నుండి వచ్చే కొన్ని modules, standard Perl distribution లో కుడా  వుంటాయి.(వాటిని <b>dual-lifed</b> గా రెఫర్ చేస్తారు.)

పైన కుడి వైపు (right side) ఉన్న సర్చ్ బాక్స్ ఉపయోగించుకోవచ్చు. `split` అని టైప్ చేస్తే  `split` కి సంబందించిన డాక్యుమెంటేషన్ వస్తుంది.

`while`,`$_` లేక `@_` వాడినప్పుడు రిసల్ట్ ఏమీ చూపించదు. వీటి కోసం మీరు డాక్యుమెంటేషన్ చూడవలెను.
[perlvar](http://perldoc.perl.org/perlvar.html) పేజ్ లో `$_` మరియు `@_` గురించి వుంటుంది.
[perlsyn](http://perldoc.perl.org/perlsyn.html) లో [while loop](/while-loop)  గురించి మరియు కొన్ని Perl సింట్యాక్స్ గురించి వుంటుంది.

## command line లో perldoc

ఈ డాక్యుమెంటేషన్ Perl సోర్స్ కోడ్ తో వస్తుంది, కానీ ప్రతి Linux distribution దానంతట అదే ఇన్స్టాల్ చేసుకోదు.

కొన్ని సందర్బాలలో వేరే ప్యాకేజ్ లో ఈ డాక్యుమెంటేషన్ వుంటుంది.

ఉదాహరణకు Debian and Ubuntu లో <b>perl-doc</b> అనే ప్యాకేజ్ వుంటుంది.
మీరు `perldoc` ని ఉపయోగించాలి అంటే ముందు గా `sudo aptitude install perl-doc` అని `perldoc` ని ఇన్స్టాల్ చేసుకోవాలి.

ఇన్స్టాల్ చేసిన తరువాత,`perldoc perl` అని కమాండ్ లైన్ లో టైపు చేస్తే మీకు కొన్ని Perl డాక్యుమెంటేషన్ లో ఉన్న చాప్టర్ లిస్టు మరియు వివరణలు వస్తాయి.

ఈ డాక్యుమెంటేషన్ నుండి బయటికి రావాలంటే `q` కీ ని ప్రెస్ చేయండి.

చాప్టర్ చూడడానికి దాని పేరుని టైపు చేయండి.
ఉదాహరణ: `perldoc perlsyn`.

## CPAN modules డాక్యుమెంటేషన్

CPAN లో ప్రతి module డాక్యుమెంటేషన్ మరియు ఉదాహరణలతో వుంటాయి.
ఈ డాక్యుమెంటేషన్లు వాటిని వ్రాసే authors మీద ఆదారపడి వుంటాయి.

మీరు Module::Name ని ఇన్స్టాల్ చేసారు అనుకుందాం.
ఈ డాక్యుమెంటేషన్ కోసం `perldoc Module::Name` అని టైప్ చేసి వాటి వివరాలు పొందవచ్చు.

మీరు ఎటువంటి module ఇన్స్టాల్ చెయ్యకుండా ఈ డాక్యుమెంటేషన్ CPAN వెబ్ ఇంటర్ఫేస్ ద్వారా పొందవచ్చు.
[Meta CPAN](http://metacpan.org/) మరియు [search CPAN](http://search.cpan.org/) లు ముఖ్యమైనవి.
ఈ రెండూ ఒకే  డాక్యుమెంటేషన్ మీద ఆదారపడి వుంటాయి, కానీ డాక్యుమెంటేషన్ చూపించే విదానంలో తేడా వుంటుంది.

## Perl Maven లో కీవర్డ్ సెర్చ్

ఈ సైట్ పైన మెనూబార్ లో కీవర్డ్ సెర్చ్ ని పెట్టాము.
దీని ద్వారా మీరు ఈ సైట్ లో ఉన్న Perl ఆర్టికల్స్ని సెర్చ్ చెయ్యవచ్చు.
కొంతకాలం తరువాత కోర్ Perl డాక్యుమెంటేషన్ మరియు CPAN లో ముఖ్యమైన modules చేర్చబడతాయి.


## Next

తరువాతి భాగం  [POD - Plain Old Documentation](/pod-plain-old-documentation-of-perl).
