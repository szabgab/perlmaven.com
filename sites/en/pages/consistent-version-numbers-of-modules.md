---
title: "Enforce the same version numbers in all the Perl modules in a distribution"
timestamp: 2016-03-03T23:30:01
tags:
  - Test::VERSION
  - $VERSION
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


We already had issues with [decreasing version numbers](/fixing-the-release-adding-version-numbers),
but there is actually more to it. There are many distributions on CPAN that have many modules in them without their own version number.
As PAUSE and the CPAN tools rely on module-level version numbers, these modules with undefined version numbers make some trouble.

It might not be a huge issue, but I'd rather make sure each module in the distribution has a verison number.

Then another issue arises. How do I make sure that that module gets a new version number when that specific module within the distribution has changed?


I won't remember to update the numbers before every release, unless it is automated or if I am forced to. My solution to this problem
is to enforce that every module in a distribution must have a version number and they must have the same version number.
This will help me as the author (or maintainer) and it will help if one of the modules is found somewhere. The version number
will tell where it came from.

## Unified $VERSION format

Before enforcing the same version number, I wanted to do something else. I wanted to make sure all the modules use the same format
for setting the version number. I had to replace

```perl
$Pod::Tree::VERSION = '1.23';
```

by

```perl
our $VERSION = '1.23';
```

in some of the modules.

Probably not something critical, but then there is no reason for them to look different.

[commit](https://github.com/szabgab/Pod-Tree/commit/e0006fb0a8fde59aa90dbf257d1ee5d0957da25b)

## Use Test::Version to enforce consistent version numbers

[Test::Version](https://metacpan.org/pod/Test::Version) helps to check if version numbers in modules are sane.
It can also check if the version numbers are the same.

I've added the following code as `t/94-version.t`:

```perl
use strict;
use warnings;
use Test::More;

## no critic
eval q{use Test::Version 1.003001 qw( version_all_ok ), {
        is_strict   => 1,
        has_version => 1,
        consistent  => 1,
    };
};
plan skip_all => "Test::Version 1.003001 required for testing version numbers"
    if $@;
version_all_ok();
done_testing;
```

I also had to add it to the `MANIFEST` file, and in order for Travis-CI to run the tests I've changed `.travis.yml`
to include the following:

```
before_install:
  - cpanm --notest Perl::Tidy
  - cpanm --notest Test::Code::TidyAll
  - cpanm --notest Test::Perl::Critic
  - cpanm --notest Test::Version
```


[commit](https://github.com/szabgab/Pod-Tree/commit/8504ba61bb4edc35d93bf15c3da239c25f2b532e)

