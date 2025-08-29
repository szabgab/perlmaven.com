---
title: "$^O $OSNAME"
timestamp: 2020-09-26T16:30:01
tags:
  - $^O
  - $OSNAME
published: true
author: szabgab
archive: true
description: "The variable $^O aka. $OSNAME contains the the name of the operating system under which this copy of Perl was compiled."
show_related: true
---


The variable **$^O** also known as **$OSNAME** contains the the name of the operating system under which this copy of Perl was compiled.


**$^O** is the official name. You can also import the **$OSNAME** from the <b>English</b> module.

{% include file="examples/osname.pl" %}

On MS Windows it is always **MSWin32** regardless the version of Windows or if it is 32 bit or 64 bit.

On Linux it is always **linux**.

On Mac OSX it is always **darwin**.

See also the [official documentation](https://metacpan.org/pod/perlvar#OSNAME).
