---
title: "Perl Critic reports"
timestamp: 2018-12-21T07:30:01
tags:
  - Perl::Critic
published: true
author: szabgab
archive: true
---



## Code before strictures are enabled

Sample script generating this:

{% include file="examples/critic/no_stricture.pl" %}

[TestingAndDebugging::RequireUseStrict](https://metacpan.org/pod/Perl::Critic::Policy::TestingAndDebugging::RequireUseStrict)

Always have <b>use strict</b> at the beginning of your Perl files.

Related articles:
* [Always use strict!](/strict)
* [Always use strict and use warnings in your perl code!](/always-use-strict-and-use-warnings)
* [use strict; and warnings; but no diagnostics](/use-strict-use-warnings-no-diagnostics)


## Bareword file handle opened

{% include file="examples/critic/bareword_file_handle.pl" %}

[InputOutput::ProhibitBarewordFileHandles](https://metacpan.org/pod/Perl::Critic::Policy::InputOutput::ProhibitBarewordFileHandles)

* [Don't Open Files in the old way](/open-files-in-the-old-way)
* [Barewords in Perl](/barewords-in-perl)

## Two-argument "open” used

{% include file="examples/critic/two_argument_open.pl" %}

[InputOutput::ProhibitTwoArgOpen](https://metacpan.org/pod/Perl::Critic::Policy::InputOutput::ProhibitTwoArgOpen)

* [Always use 3-argument open](/always-use-3-argument-open)
* [Don't Open Files in the old way](/open-files-in-the-old-way)

## "return" statement with explicit "undef"

{% include file="examples/critic/return_undef.pl" %}

[Subroutines::ProhibitExplicitReturnUndef](https://metacpan.org/pod/Perl::Critic::Policy::Subroutines::ProhibitExplicitReturnUndef)

* [How to return nothing (or undef) from a function in Perl?](/how-to-return-undef-from-a-function)
* [wantarray - returning list or scalar based on context](/wantarray)

## Nested named subroutine

{% include file="examples/critic/nested_subs.pl" %}

[Subroutines::ProhibitNestedSubs](https://metacpan.org/pod/Perl::Critic::Policy::Subroutines::ProhibitNestedSubs)

## Package declaration must match filename

## Three-argument form of open used .... Three-argument open is not available until perl 5.6.

## Use of "open" is not allowed .....  Use file operation methods of MainObject instead.

## I/O layer ":utf8" used ....  Use ":encoding(UTF-8)" to get strict validation.


