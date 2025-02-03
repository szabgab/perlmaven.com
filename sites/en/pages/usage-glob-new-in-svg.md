---
title: "usage: GLOB->new([FILENAME [,MODE [,PERMS]]])"
timestamp: 2013-11-20T07:30:01
tags:
  - GLOB
  - open
published: true
author: szabgab
---


I am the current maintainer of the
[SVG (Scalable Vector Graphics)](https://metacpan.org/release/SVG)
distribution on CPAN, and thus a the other day ago I got an e-mail about a crash:


The code looks like this:

```perl
use strict;
use warnings;

use SVG;
my $svg = SVG->new( width => 10, height => 10 );
my $filename = "svg.xml";
open( SVG, ">", $filename );
print SVG $svg->xmlify;
close( SVG );
```

Can you spot the problem?

Running the above script I get the folling error message:

`usage: GLOB->new([FILENAME [,MODE [,PERMS]]]) at ... line 5.`

## Always use lexical variables for file handles!

Besides the fact the return value of `open` is not
checked, the main problem is that the programmer happened to use the
same name (`SVG`) for the file-handle as the name of the
module. By the time the execution reached the `SVG->new` line
perl already decided that instead of the module, SVG will represent
the file-GLOB. (This happens at compile time.)

Hence the error is reported on the line of the `SVG->new` call.

I think this is a lovely error. Probably perl should have warned when it noticed
that we try to overwrite the SVG name-space with a GLOB, but I have to admit
a very similar problem happened to me too a while ago in Python.


My conclusion from this error is to remind people
to [always use lexical variables as file handles](/open-files-in-the-old-way)!


The working solution looks like this:

```perl
use strict;
use warnings;

use SVG;
my $svg = SVG->new( width => 10, height => 10 );
my $filename = "svg.xml";
open( my $SVG, ">", $filename ) or die;
print $SVG $svg->xmlify;
close( $SVG );
```

