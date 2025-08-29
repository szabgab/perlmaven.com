---
title: "How to add the license field to the META.yml and META.json files on CPAN?"
timestamp: 2012-12-28T16:45:56
tags:
  - license
  - Perl
  - Perl 5
  - CPAN
  - META
  - ExtUtils::MakeMaker
  - Module::Build
  - Module::Install
  - Dist::Zilla
  - CPAN::Meta::Spec
published: true
books:
  - metacpan
author: szabgab
---


Every distribution on CPAN can include a META.yml and a META.json file.
They should hold the same information, META.json is just the newer format.
So you'll find a lot more distributions with only META.yml and you'll find
a few, probably very old distribution with no META file at all.

The META files can both have a field indicating the **license** of the distribution.

Having the license information in the META files makes it very easy for automated tools
to check if a set of modules have a certain set of licenses.


As the META files are usually generated automatically when the distribution is released
by the author, I am going to show you how you can tell the 4 main packaging systems
to include the license field.

In the examples  I'll use the most common, so called, **Perl** license:

## ExtUtils::MakeMaker

If you are using [ExtUtils::MakeMaker](https://metacpan.org/pod/ExtUtils::MakeMaker) add the following to your Makefile.PL
as parameter in the **WriteMakefile** function:

```perl
'LICENSE'  => 'perl',
```

If you want to make sure older versions of ExtUtils::MakeMaker won't give warnings on
unknown LICENSE field, you can use the following code:

```perl
($ExtUtils::MakeMaker::VERSION >= 6.3002 ? ('LICENSE'  => 'perl', ) : ()),
```

[The version distributed with perl 5.8.8 is 6.30](http://search.cpan.org/src/NWCLARK/perl-5.8.8/lib/ExtUtils/MakeMaker.pm)
thus it does not yet contain this feature. The best if you could upgrade ExtUtils::MakeMaker.

## Module::Build

If you are using [Module::Build](https://metacpan.org/pod/Module::Build), add the following to Build.PL,
in the Module::Build->new call:

```perl
license               => 'perl',
```

## Module::Install

If you are using [Module::Install](https://metacpan.org/pod/Module::Install) add the following to Makefile.PL:

```perl
license        'perl';
```

## Dist::Zilla

If you are using [Dist::Zilla](http://dzil.org/), just add the following entry to the dist.ini file:

```perl
license = Perl_5
```

## META specification

In order to check the current list of valid options for the license field,
check the [CPAN::Meta specification](https://metacpan.org/pod/CPAN::Meta::Spec).

## Copyright and Licensing

According to the [CPAN Licensing Guidelines](http://www.perlfoundation.org/cpan_licensing_guidelines)
of The Perl Foundation, it is **required** to have the license information in the META files.

There are of course other required elements of the licensing. This article only focuses on the entry in the META files.

## List of CPAN modules without license in META files

The [lab](http://cpan.perlmaven.com/#lab) on JavaScript based MetaCPAN front-end has a page
with the [Recent releases without a "license" field in the META files](http://cpan.perlmaven.com/#lab/no-license).

## Comments

Is there a LIST of modules that don't have a license declared?
---
try the link here: https://code-maven.com/#lab

<hr>
I think that EUMM expects that license is an ARRAY these days.



