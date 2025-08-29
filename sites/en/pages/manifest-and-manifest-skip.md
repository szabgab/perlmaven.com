---
title: "MANIFEST and MANIFEST.SKIP"
timestamp: 2017-03-21T20:00:11
tags:
  - MANIFEST
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


The MANIFEST files just lists the names of the files that need to be included in a Perl distribution.
When packaging the distribution Perl will use this list to determine what to include. When unpacking the tarball
Perl will check if the files that were unpacked are the exact same files that are listed in the MANIFEST file.
No other file is included and no file is missing.


<slidecast file="advanced-perl/libraries-and-modules/manifest-and-manifest-skip" youtube="QwjNHqcYig8" />

Some people maintain the MAINFEST file manually and keep in it version control.

Others keep a file called MANIFEST.SKIP that basically contains regular expressions describing
which files should be **excluded** from the distribution zip file.

Then just before creating the distribution the author runs a command that will go over all the
directories in the directory tree of the project listing all the files exlucing the onese
matched by one of ther regular expressions in the MANIFEST.SKIP.

The files that are not filtered out are used to compose the content of the MANIFEST file.

In this case the author would keep the MANIFEST.SKIP in the version control system, but
would not keep the MANIFEST file itself in the version control system as it is a generated
file.

The command that creates the MANIFEST file is `make manifest` in case of
[ExtUtils::MakeMaker](/makefile-pl-of-extutils-makemaker) and it
is `perl Build manifes` in case of [Module::Build](/build-pl-of-module-build).

