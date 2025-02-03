---
title: "Test::Builder object"
timestamp: 2016-09-30T08:30:01
tags:
  - Test::Builder
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


As we saw earlier, [Test::Builder](https://metacpan.org/pod/Test::Builder) is the backbone of the testing framework of Perl.
`Test::Simple` and `Test::More` are built on top of this module and there are hundreds of other modules in the `Test::*` namespace on CPAN
that use this same back-end. All those modules provide extra testing functionality.

Though actually there are a few modules in the `Test::*` namespace that are not "testing modules" in the same way as the ones we are
talking about here, but the majority can be loaded in any test script and the majority provide extra testing functions.

Just as we have created [is_any](/is-any-to-test-multiple-expected-values), others have created lots of other such functions and modules.


{% youtube id="P5MrMboOsnI" file="test-builder-object" %}

There are effectively hundreds of these modules and we'll take a look at quite a few of them. For now though, I'd like to say a few words
about `Test::Builder` and hopefully eliminate a confusion that I lived with for quite some time.

During the execution of a test script there is only one `Test::Builder` object. It is a singleton.
It can be retreived in at least 3 ways, and different examples (even by the same person) might use more than one of them:

This script shows you the 3 common ways people use it and show it in their examples:


```perl
use strict;
use warnings;

use Test::More tests => 1;
use Test::Builder;
use Test::Builder::Module;

my $TMb = Test::More->builder;
diag $TMb;

my $TBM = Test::Builder::Module->builder;
diag $TBM;

my $TBn = Test::Builder->new;
diag $TBn;

ok 1;
```

In this script I just printed the actual object retreived in all the 3 ways. The result looks like this:

```
1..1
# Test::Builder=HASH(0x7ff234044ab8)
# Test::Builder=HASH(0x7ff234044ab8)
# Test::Builder=HASH(0x7ff234044ab8)
ok 1
```

This shows that the 3 method return the exact same object.

## ps

If you find examples using other ways to retreive the current `Test::Builder` object, please share it with me.
It would be nice to include them in this list.


