---
title: "Template Toolkit processing Hash of Hashes"
timestamp: 2020-08-23T14:30:01
tags:
  - Template::Toolkit
published: true
author: szabgab
archive: true
description: "Temlate::Toolkit is a great tool. In this example we show to use it in two differnt ways to display a hash of hashes."
show_related: true
---


[Template Toolkit](/template-toolkit) is an excellent and very powerful templating language.
In this example we'll see how can we display a hash of hashes.


## Plain Text display

In the script you can see the data structure that was taken, with slight modifications from a question that was posted
to the [Perl Dancer](http://perldancer.org/) mailing list.

{% include file="examples/tt_hoh/create.pl" %}

First let's see a template to display the data in plain text format. This template actually includes two examples. In the first
one we just iterate over the keys of the external hash and then the keys of each on of the internal hashes.


In the second example we have a rather well-formatted table.

{% include file="examples/tt_hoh/templates/report.tt" %}

```
    BryceJones(2021)
    -------------
           atbats : 4
           bb : 1
           hits : 2
           rbis : 4
           runs : 2
           so : 1

    ChaseLangan(2022)
    -------------
           atbats : 5
           bb : 0
           hits : 24
           rbis : 2
           runs : 4
           so : 1

    TylerMontgomery(2022)
    -------------
           atbats : 117
           bb : 1
           hits : 2
           rbis : 0
           runs : 2
           so : 1


===============================================



Name                    atbats so   bb  rbis hits runs

BryceJones(2021)         4      1   1    4     2    2
ChaseLangan(2022)        5      1   0    2    24    4
TylerMontgomery(2022)  117      1   1    0     2    2
```

## HTML page

Creating an HTML page using this template is a lot easier as we don't have to worry about padding with spaces.
That's handled by HTML and CSS.



