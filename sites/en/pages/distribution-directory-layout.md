---
title: "Distribution directory layout"
timestamp: 2016-03-25T07:30:11
tags:
  - Makefile.PL
  - Build.PL
  - dist.ini
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


If you are trying to package some code in Perl, first you need to create a directory structure.


<slidecast file="advanced-perl/distribution-directory-layout" youtube="CTVOjanKuSo" />

```
  dir/

     Makefile.PL
     Build.PL

     dist.ini


     README
     CHANGES
     MANIFEST
     MANIFEST.SKIP
     META.yml
     META.json

     lib/
        Application/Name.pm
        Application/Name/...
     script/
        application.pl

     t/
     xt/

     sample/

     share/
     templates/
     views/
```

The directory has a Makefile.PL, a Build.PL, or a dist.ini describing how to package the module.

`Makefile.PL` is used by [ExtUtils::MakeMaker](http://metacpan.org/pod/ExtUtils::MakeMaker) and by 
[Module::Install](http://metacpan.org/pod/Module::Install)


`Build.PL` is used by [Module::Build](http://metacpan.org/pod/Module::Build) which can optionally
generate a `Makefile.PL`.


`dist.ini` is used by [Dist::Zilla](http://metacpan.org/pod/Dist::Zilla) which then creates
a `Makefile.PL` to be added to the distribution.


The `README` if just a description of what your distribution might do.

The `CHANGES` file includes the description of the changes between releases.

`MANIFEST` is the list of files that need to be included in the distribution. It is used for packaging and also
to check if all the files were included in the distribution. In the directory tree there can be all kinds 
of temporary files that you don't want to include in the distribution. So you won't list them in the MANIFEST.

This file can be maintained manually or, alternatively, you can keep a file called `MANIFEST.SKIP` that lists
the files that **should not** be included. Then during the packaging, you can generate the `MANIFEST`
file based on what you have in the directory skipping the ones mentioned in the `MANIFEST.SKIP`.
The advantage of using `MANIFEST.SKIP` is that it can include wildcards that will match a full set of files.


`META.yml` and `META.json` contain the same meta-information about the distribution in YAML and JSON format
respectively. The information includes the dependencies, the information about the author, version numbers, etc.
They are generated during the packaging process.

The modules go into the `lib/` directory.

If there are scripts distributed they are usually placed in the `script/` subdirectory.

The unit-test files are located in the `t/` directory and have `.t` extension.

`xt/` can hold additional test scripts that should be executed only by the author/maintainer of this distribution,
but not by the people who install it.


There can also be a directory called `sample/` or `examples/` or `eg/` to hold examples scripts.

There can be addition directories such as `share/`, `templates/`, `views/`, `public/` depending
on the application you are writing and distributing.

Form all these files, at the end only the content of the `lib/` directory and the `script/` directory
will be installed. In addition you can tell Perl to install some of the extra files if they are need for your
application.

