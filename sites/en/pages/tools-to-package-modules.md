---
title: "Tools to package Perl scripts, modules, and applications"
timestamp: 2017-03-04T21:30:11
tags:
  - ExtUtils::MakeMaker
  - Module::Build
  - Module::Install
  - Dist::Zilla
  - PAR
  - PAR::Packer
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


It does not matter if you have written a simple script, a module, or an application, it is recommended
to use the tools that are already available to package and distribute CPAN modules.
Even if your code is proprietary and you only would like to distribute it within your company.


<slidecast file="advanced-perl/libraries-and-modules/tools-to-package-modules" youtube="jw_kNnxYMjo" />

There are basically 4 tools to package Perl modules:

* [ExtUtils::MakeMaker](/makefile-pl-of-extutils-makemaker) on [CPAN](http://metacpan.org/pod/ExtUtils::MakeMaker)
* [Module::Install](/makefile-pl-of-module-install) on [CPAN](http://metacpan.org/pod/Module::Install)
* [Module::Build](/build-pl-of-module-build) on [CPAN](http://metacpan.org/pod/Module::Build)
* [Dist::Zilla](http://metacpan.org/pod/Dist::Zilla)

There can package a module including several files, unit-tests, and various additional file into a single
`.tar.gz` distribution. Once you have such tarball anyone can use the standard tools to install
this distribution, just as if this was a CPAN distribution. Even if this was in a private CPAN
repository or if it was received on its own.


Sometimes you'd like to create an executable that does not even require the user to install Perl up-front.
[PAR](http://metacpan.org/pod/PAR), or more specifically [PAR::Packer](http://metacpan.org/pod/PAR::Packer)
will create an executable for your current platform and architecture. This executable can be distributed and
ran without installing any prerequisites.

