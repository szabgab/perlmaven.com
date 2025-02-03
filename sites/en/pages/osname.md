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


The variable <b>$^O</b> also known as <b>$OSNAME</b> contains the the name of the operating system under which this copy of Perl was compiled.


<b>$^O</b> is the official name. You can also import the <b>$OSNAME</b> from the <b>English</b> module.

{% include file="examples/osname.pl" %}

On MS Windows it is always <b>MSWin32</b> regardless the version of Windows or if it is 32 bit or 64 bit.

On Linux it is always <b>linux</b>.

On Mac OSX it is always <b>darwin</b>.

See also the [official documentation](https://metacpan.org/pod/perlvar#OSNAME).
