---
title: "Core Perl documentation and CPAN module documentation"
timestamp: 2013-01-27T10:45:56
tags:
  - perldoc
  - documentation
  - POD
  - CPAN
published: true
books:
  - beginner
author: szabgab
---


Perl comes with a lot of documentation, but
it takes some time till you get used to using it. In this part of the
[Perl tutorial](/perl-tutorial) I'll explain how
to find your way around the documentation.


## perldoc on the web

The most convenient way to access the documentation of core perl
is to visit the [perldoc](http://perldoc.perl.org/) website.

It contains an HTML version of the documentation for Perl, the language,
and for the modules that come with core Perl as released by the Perl 5 Porters.

It does not contain documentation for CPAN modules.
There is an overlap though, as there are some modules that are available
from CPAN but that are also included in the standard Perl distribution.
(These are often referred to as **dual-lifed**.)

You can use the search box at the top right corner. For example you can
type in `split` and you'll get the documentation of `split`.

Unfortunately it does not know what to do with `while`, nor with
`$_` or `@_`. In order to get explanation of those
you'll have to flip through the documentation.

The most important page might be [perlvar](http://perldoc.perl.org/perlvar.html),
where you can find information about variables such as `$_` and `@_`.

[perlsyn](http://perldoc.perl.org/perlsyn.html) explains the syntax of Perl
including that of the [while loop](/while-loop).

## perldoc on the command line

The same documentation comes with the source code of Perl, but not
every Linux distribution installs it by default. In some cases there
is a separate package. For example in Debian and Ubuntu it is the **perl-doc**
package. You need to install it using `sudo aptitude install perl-doc`
before you can use `perldoc`.

Once you have it installed, you can type `perldoc perl` on the command line
and you will get some explanation and a list of the chapters in the Perl documentation.
You can quit this using the `q` key, and then type the name of one of the chapters.
For example: `perldoc perlsyn`.

This works both on Linux and on Windows though the pager on Windows is really weak,
so I cannot recommend it. On Linux it is the regular man reader so you should be familiar
with it already.

## Documentation of CPAN modules

Every module on CPAN comes with documentation and examples.
The amount and quality of this documentation varies greatly
among the authors, and even a single author can have very
well documented and very under-documented modules.

After you installed a module called Module::Name,
you can access its documentation by typing `perldoc Module::Name`.

There is a more convenient way though, that does not even
require the module to be installed. There are several
web interfaces to CPAN. The main ones are [Meta CPAN](http://metacpan.org/)
and [search CPAN](http://search.cpan.org/).

They both are based on the same documentation, but they
provide a slightly different experience.


## Keyword search on Perl Maven

A recent addition to this site is the keyword search on the top menu bar.
Slowly you will find explanation for more and more parts of perl.
At one point part of the core perl documentation and the documentation of the
most important CPAN modules will be also included.

If you are missing something from there, just make a comment below,
with the keywords you will looking for and you have a good chance to
get your request fulfilled.

