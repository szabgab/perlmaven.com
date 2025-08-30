---
title: "Makefile.PL of ExtUtils::MakeMaker"
timestamp: 2017-03-09T08:00:11
tags:
  - ExtUtils::MakeMaker
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


Let's see what do you need to do if you'd like to use [ExtUtils::MakeMaker](https://metacpan.org/pod/ExtUtils::MakeMaker)
to package your module?


{% youtube id="7IKvWbd5_MA" file="advanced-perl/libraries-and-modules/makefile-pl-of-extutils-makemaker" %}

You need to create a file called `Makefile.PL`, then you might want to tell what is the minimal version
of perl this Makefile.PL should run on by adding `use 5.008;` if you want to require 5.8 as a minimum.

Then we load [ExtUtils::MakeMaker](https://metacpan.org/pod/ExtUtils::MakeMaker) and call the
`WriteMakefile` function provided by that module. It gets a set of key-value pairs as parameters.

The first one we see is the name of the application (`NAME`). Then we tell it where to take
the version number from, so the version number of the whole distribution is now taken from one of
the modules in the distribution. Usually the main module.

`PREREQ_PM` is a key for a set of key-value pairs indicating the preprequisites of this distributions.
The keys in this internal hash are the names of the required modules, the values are the required minimal version
of each module. Putting a 0 as the version number means that we require that module but, we don't care
which version. Even modules that are standard, that should come with the default installation of perl
should be added here.


If there are modules that are only needed during installation, for example the [Test::More](http://metacpan.org/pod/Test::More)
is used for the unit-testing of the module, but is not needed for the actual use of the module.
Such build-time dependencies should be listed under the `BUILD_REQUIRES` key.


If there are some script that you would like to be installed, you can list them under the `EXE_FILES` key.

There are plenty of other properties that can be set in the Makefile.PL, for further information look at the documentation
of [ExtUtils::MakeMaker](https://metacpan.org/pod/ExtUtils::MakeMaker).

{% include file="examples/Makefile.PL" %}

See also [How to convince Meta CPAN to show a link to the version control system of a distribution?](/how-to-add-link-to-version-control-system-of-a-cpan-distributions) and [How to add the license field to the META.yml and META.json files on CPAN?](/how-to-add-the-license-field-to-meta-files-on-cpan)

