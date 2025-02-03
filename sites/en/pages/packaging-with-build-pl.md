---
title: "Packaging with Build.PL"
timestamp: 2017-04-05T20:20:11
tags:
  - Build.PL
  - Build
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


If you use [Build.PL with Module::Build](/build-pl-of-module-build) then creating the
distribution file has the following steps:


<slidecast file="advanced-perl/libraries-and-modules/packaging-with-build-pl" youtube="yy9aypG3IiM" />

```
perl Build.PL
```

will check if the dependencies are there (similar to `perl Makefile.PL` in the case of
[Makefile.PL](/packaging-with-makefile-pl)) and create a file called `Build`
without any extension which is just another Perl script.

Then we run

```
perl Build
```

that will rearrange directories, create the `blib/` directory and copy files there.

The we run

```
perl Build test
```

that will run all the unit- and other automation tests checking if the distribution is ready.

Then comes the time when you might want to create your `MANIFEST` file.
If you maintain `MANIFEST.SKIP` then at this point you need to run

```
perl Build manifest
```

that will take all the files in the current directory tree, exclude the onse that
match one of the regexes in `MANIFEST.SKIP` and include the list of the others
in the `MANIFEST` file.

Once you have the up-to-date `MANIFEST` file we can run

```
perl Build dist
```

to create the zip file.

This is the file you'd distribute either via CPAN or directly to your clients.


## Installing a distribution

If you want to install one of these distributions, you would run

```
perl Build.PL
perl Build
perl Build test
```

just as during the creationg of the distribution, but then you'd run

```
perl Build install
```

to install the files.





