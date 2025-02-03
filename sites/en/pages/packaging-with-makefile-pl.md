---
title: "Packaging with Makefile.PL"
timestamp: 2017-03-30T09:10:11
tags:
  - Makefile.PL
  - make
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


If you have a `Makefile.PL`, either because you are using [ExtUtils::MakeMaker](/makefile-pl-of-extutils-makemaker),
or because you are using [Module::Install](/makefile-pl-of-module-install) you do the following to created the distribution:


<slidecast file="advanced-perl/libraries-and-modules/packaging-with-makefile-pl" youtube="efUveYthyHw" />

Firs of all you run:
```
perl Makefile.PL
```

this will check if all the dependencies are installed and if all the files listed in the `MANIFEST` file
were included. Then it will generate the `Makefile` itself without any extension.


Then we run

```
make
```

part of the "C toolchain". If the module is partially based on C os XS, this will compile the necessary code.
Then it will copy all the necessary Perl files to the `blib/`  directory.  (blib stands for build lib).

Then we run

```
make test
```

this will run all the unit- and other automated tests.

Then here comes the command that will create the [MANIFEST](/manifest-and-manifest-skip) file from
all the files in the development directory excluding the files that have a matching entry in `MANIFEST.SKIP` file.
This command is only needed if you maintain the `MANIFEST.SKIP`. If you maintain the `MANIFEST` file
manually then you would not run this command.

```
make manifest
```


Then

```
make dist
```

will take all the files listed in the `MANIFEST` file, copy them to a special directoy
with the name and the version number of the distribution and then create a tarball (a .tar.gz file)
from that directory.

This is the file you'd upload to [PAUSE](http://pause.perl.org/) if you wanted to distribute
it via [CPAN](http://www.cpan.org/), or that's the file you'd distribution
in your in-house CPAN repository, or just send it to your clients and users.


## Installing the module

When installing the module the first 3 steps are the same:

```
Perl Makefile.PL
make
make test
```

but then instead of the other 2 steps you'd just run

```
make install
```

that would install the module in the right place.


On MS Windows, instead of `make` you'd probably have either `dmake` or `nmake` depending the toolchain you have.

## Comments

I tried the command "make" on my WIN10 device , but it shows "'make' is not recognized as an internal or external command".
Do you know how to fix this ?

As Gabor noted on another article in this series:

On MS Windows, instead of make you'd probably have either dmake or nmake depending the toolchain you have.


