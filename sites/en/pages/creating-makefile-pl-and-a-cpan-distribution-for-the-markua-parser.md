---
title: "Creating Makefile.PL and a CPAN distribution for the Markua Parser"
timestamp: 2018-03-03T20:30:01
tags:
  - make
  - Makefile.PL
  - ExtUtils::MakeMaker
published: true
author: szabgab
archive: true
---


When you start writing a project, especially when it is in-house, creating a CPAN distribution might not be high on
your priorities, but having the capability will simplify the use of various tools and services. So I recommend that
you prepare your module/application in a similar way.


We need to create a file called Makefile.PL that holds the list of dependencies of our code and a few other instructions
how to install it. For simple Perl-only modules (that don't include code in C or XS or in some other language), the Makefile.PL
is quite simple and standard.

{% include file="examples/markua-parser/79f7a57/Makefile.PL" %}

For detailed explanation see the [Makefile.PL of ExtUtils::MakeMaker](/makefile-pl-of-extutils-makemaker)
and the [packaging with Makefile.PL](/packaging-with-makefile-pl) articles.


The first time you run it with `perl Makefile.PL` you'll get a warning:

```
WARNING: Setting VERSION via file 'lib/Markua/Parser.pm' failed
```

In order to fix this we add the version number to the 'lib/Markua/Parser.pm' file:

```perl
our $VERSION = 0.01;
```

The whole file can be seen here:

{% include file="examples/markua-parser/79f7a57/lib/Markua/Parser.pm" %}

## Run the tests and generate the distribution

The following sequence of command will

<ol>
  <li>Check if all the prerequisites are met and generate `Makefile`.</li>
  <li>Rearrange the files in the `blib` subdirectory in the same structure as they will be after installation.</li>
  <li>Run the tests</li>
  <li>Generate the `MANIFEST` that lists all the file that need to be included in the distribution. (This is based on the `MANIFEST.SKIP` file, but we did not need it for the simple case.</li>
  <li>Generate the tar.gz file that can be uploaded to PAUSE or distributed in another way.</li>
</ol>

```
$ perl Makefile.PL
$ make
$ make test
$ make manifest
$ make dist
```

## gitignore generated files

The above process generates a few files and directories that don't need to be in version control.
The best approach is to add their names to the `.gitignore` file so git will ignore them.

This is what I had to create:

{% include file="examples/markua-parser/79f7a57/.gitignore" %}

```
$ git add .
$ git commit -m "create Makefile.PL"
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/79f7a57fd459144a0720e99abeae7191a622ee1f)


