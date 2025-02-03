---
title: "Introducing the Perl Tidy GUI project"
timestamp: 2020-09-09T17:30:01
tags:
  - Perl::Tidy
  - perltidy
  - Path::Tiny
  - path
  - slurp
published: true
author: szabgab
types:
  - screencast
archive: true
description: "Use the Perl::Tidy module in out own code as an experient to build a GUI around it."
show_related: true
---


The [perltidy](https://metacpan.org/pod/distribution/Perl-Tidy/bin/perltidy) script allows you to
convert your Perl source code to some unified layout. The [Perl::Tidy](https://metacpan.org/pod/Perl::Tidy)
module, behind the scenes allows us to build tools like perltidy.

Let's experiment with it so we can try to build a GUI for it.


{% youtube id="XkltoJZfBX8" file="english-introducing-perltidy-tk-project.mkv" %}

## Code to be beautified

{% include file="examples/perltidy0/code.pl" %}

## Current experiment

{% include file="examples/perltidy0/tidy.pl" %}

## Output

```
--indent-columns=4
--maximum-line-length=80
--variable-maximum-line-length
--whitespace-cycle=0

use strict;
use warnings;

my $x = "a";
my $y="b";
if($x){ print $y }

if($y) {
    print "Hello World";
}


if($y)
    {
print "Hello World";
}

--------
use strict;
use warnings;

my $x = "a";
my $y = "b";
if ($x) { print $y }

if ($y) {
    print "Hello World";
}

if ($y) {
    print "Hello World";
}
```



