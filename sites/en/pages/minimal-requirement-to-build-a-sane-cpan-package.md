---
title: "Minimal requirement to build a sane CPAN package"
timestamp: 2014-01-02T12:30:01
tags:
  - CPAN
  - ExtUtils::MakeMaker
published: true
author: szabgab
---


I started to write an article explaining how to package a Perl module
but it got too long and detailed. Let's start with a simple case and
build the smallest possible but still sane package. Later we can go
in more details and see alternative ways.


Let's say you have a module called `Math::Calc` that you would like to upload to CPAN.
This is the code you have in the Calc.pm file:

```perl
package Math::Calc;
use strict;
use warnings;

sub add {
  return $_[0] + $_[1];
}

1;
```

You need to create a directory, let's say Math-Calc, just to hold
all the parts of the distributions. In that directory put the Calc.pm
file in the lib/Math subdirectory. Also create a Makefile.PL (capital M, P, and L)
and a MANIFEST file in the Math-Calc directory:

like this:

```
Math-Calc/
  lib/Math/Calc.pm
  Makefile.PL
  MANIFEST
```

The <b>MANIFEST</b> file contains a list of files that need to be packaged. In our case this
should be the content:

```
MANIFEST
Makefile.PL
lib/Math/Calc.pm
META.yml
META.json
```

The first 3 entries are the files we really have. The two META files are
going to be automatically
generated when the distribution is created. They contain META information about
your package. On CPAN they are used by various tools to display information
about the module.

The Makefile.PL file should look like this:

```perl
use strict;
use warnings;

use 5.008;

use ExtUtils::MakeMaker;
WriteMakefile
(
  NAME         => 'Math-Calc',
  VERSION_FROM => 'lib/Math/Calc.pm',
);
```

The value of the NAME field will be used as the filename for the distribution.
The version number is taken from the Calc.pm file and for this to work we'll
need to add a `$VERSION` variable to the module. The module will look like this:

```perl
package Math::Calc;
use strict;
use warnings;

our $VERSION = '0.01';

sub add {
  return $_[0] + $_[1];
}

1;
```

## Creating the distribution

In order to create the distribution open a terminal and cd to
the Math-Calc directory and type:


```
perl Makefile.PL
make
make dist
```

This will generate a number of helper files and the end result:

```
Math-Calc-0.01.tar.gz
```

You can upload it to PAUSE or distribute it to your clients.


## Adding tests

While it is not a strict requirement to add and distribute unit-tests with
your code, people are really expecting to see those tests.

So create a subdirectory called 't' in the Math-Calc directory and put in
a file called t/01_basic.t with the following content:

```perl
use strict;
use warnings;

use Test::More tests => 2;

use_ok 'Math::Calc';

is Math::Calc::add(19, 23), 42, 'good answer';
```
 
Update the MANIFEST file to include the t/01_basic.t

Add the BUILD_REQUIRES entry to the Makefile.PL:

```perl
use strict;
use warnings;

use 5.008;

use ExtUtils::MakeMaker;
WriteMakefile
(
  NAME         => 'Math-Calc',
  VERSION_FROM => 'lib/Math/Calc.pm',
  BUILD_REQUIRES => {
    'Test::More' => '0.47'
  },
);
```

That will ensure that the Test::More module we used in the test script
will be installed before the tests are run by the installer.

Also change the VERSION number in Calc.pm to be 0.02 and package the module again:

``` 
perl Makefile.PL
make
make test
make dist
```

This time running the tests before creating the distribution.

You can read more on [How to test a simple Perl Module](/testing-a-simple-perl-module).

## Prerequisites

There are a lot of other improvements one can and should make but let me show you just one thing.
If you change the Math::Calc module to use some other modules, you must include the lists of
prerequisites in the Makefile.PL. Let's say you start using Moose. In that case you need to add
the PREREQ_PM key with key-value pairs. The keys are the module names, the values are the minimum(!)
version numbers.

Like this:

```perl
use strict;
use warnings;

use 5.008;

use ExtUtils::MakeMaker;
WriteMakefile
(
  NAME         => 'Math-Calc',
  VERSION_FROM => 'lib/Math/Calc.pm',
  PREREQ_PM    => {
        'Moose' => '2.00',
  },
  BUILD_REQUIRES => {
    'Test::More' => '0.47'
  },
);
```


## Use PREREQ_PM instead of BUILD_REQUIRES

As David Golden (xdg) pointed it out in the comments, BUILD_REQUIRES
is only available in relatively recent versions of ExtUtils::MakeMaker.
So for now, I'd suggest to put both the run-time and the build-time
prerequisites in the PREREQ_PM hash.

## What's next?

There are a number of other things you should take care of, such as adding a README file, keeping and distributing
a Changes file. Maybe having a MANIFEST.SKIP to handle the MANIFEST file. You should also add copyright and licensing
information to your module. There are also other packaging tools but all this will be part of another post.



