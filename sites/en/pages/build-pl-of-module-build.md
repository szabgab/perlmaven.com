---
title: "Build.PL of Module::Build"
timestamp: 2017-03-15T07:00:11
tags:
  - Modules::Build
  - Build.PL
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


These days I'd suggest you to use [ExtUtils::MakeMaker](/makefile-pl-of-extutils-makemaker)
or [Dist::Zilla](http://metacpan.org/pod/Dist::Zilla),
but if you encounter a module that only has a <b>Build.PL</b>, you will need to understand what is that.

Let's see how `Build.PL` looks like.

You'd normally use `Build.PL` if you wanted to use [Module::Build](https://metacpan.org/pod/Module::Build).
The reason might be that you would like to have everything in Perl without depending on an external `make` command.

You probbaly don't have any non-perl dependencies either.


<slidecast file="advanced-perl/libraries-and-modules/build-pl-of-module-build" youtube="Up-WkcmC2Qw" />

`Build.PL` starts the same way as any other Perl script with `use strict;` and `use warnings;`.

Then we load `Module::Build` itself and declare the minmal version of perl to be used for this script.
It is usually recommended to put this requirement early, so if someone is trying to install this module on
a perl which is too old, the person will get a clear error message at the beginning of the process.


Then we call the constructor of the Module::Build module. Assign the result to a variable we called `$builder`
here and then call the `create_build_script` method of the object. That will create a file called `Build/hl>
that will test and install the module.


The constructor of Module::Build get a number of parameters:

`module_name` is just the name of the distribution.

`license` is a code identifying the license of this distribution.

`dist_author` is the name and e-mail of the person who wrote the module.

`dist_abstract` is a one-line explanation of the module doesn.


As Module::Build has been added to core Perl only in the last couple of years, some people might
not have it installed. In order to make life easier for them, Module::Build can create a Makefile.PL
based on its paramaters. The `create_makefile_pl` parameter controls if we want it
to generate a Makefile.PL and if yes, which type.

`script_files` allows us to install additional perl scripts.

Module::Build can create a README file from the documentaion of the main module.
The `create_readme` will tell it to do so.

`requires` is the list of prerequisites with the minimum version of each module.

`build_requires` lists the modules that are needed for the installation, but not during
the use of the module.

{% include file="examples/Build.PL" %}

