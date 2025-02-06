---
title: "Which Perl modules are loaded in memory?"
timestamp: 2014-10-07T08:30:01
tags:
  - "%INC"
  - "@INC"
published: true
author: szabgab
---


In extreme cases you might need to tinker with what Perl has loaded in memory.

In less extrme cases, you might wonder, why changing a module, even rendering it
syntactically incorrect does not have any impact on your script. Is it even loading
that copy of the module?


Perl provides a variable called `%INC`, it is slightly related to `@INC` but not to be confused with it.
`%INC` contains information about modules that have been loaded into memory by the currently running process.

The most simple way to see it, is by using Data::Dumper with the following one-liner:

<htl>perl -MData::Dumper -e 'print Dumper \%INC'`.

(On Windows, you will want to use double-quotes instead of single-quotes around the expression.)

```
$VAR1 = {
  'strict.pm' => '/opt/perl-5.20.1/lib/5.20.1/strict.pm',
  'overload.pm' => '/opt/perl-5.20.1/lib/5.20.1/overload.pm',
  'Carp.pm' => '/opt/perl-5.20.1/lib/5.20.1/Carp.pm',
  'constant.pm' => '/opt/perl-5.20.1/lib/5.20.1/constant.pm',
  'warnings/register.pm' => '/opt/perl-5.20.1/lib/5.20.1/warnings/register.pm',
  'XSLoader.pm' => '/opt/perl-5.20.1/lib/5.20.1/XSLoader.pm',
  'warnings.pm' => '/opt/perl-5.20.1/lib/5.20.1/warnings.pm',
  'bytes.pm' => '/opt/perl-5.20.1/lib/5.20.1/bytes.pm',
  'Exporter.pm' => '/opt/perl-5.20.1/lib/5.20.1/Exporter.pm',
  'overloading.pm' => '/opt/perl-5.20.1/lib/5.20.1/overloading.pm',
  'Data/Dumper.pm' => '/opt/perl-5.20.1/lib/5.20.1/darwin-thread-multi-2level/Data/Dumper.pm',
  'vars.pm' => '/opt/perl-5.20.1/lib/5.20.1/vars.pm'
};
```

The keys are the module names mapped to the file names that are searched for in `@INC`, the values
are the full pathes to the files that were actually loaded.

You might wonder, which one of these modules are loaded by perl by default. For that we need to go back one
step and print `%INC` without loading Data::Dumper.

In `perl -e 'print join "\n", %INC; print "\n"'` we join together all the keys and values of `%INC`
with newlines. But it prints nothing. That is, <b>perl itself does not load any module.</b>

We can then try to load some of the pragma:

```
$ perl -e 'use strict; print join "\n", %INC; print "\n"'
strict.pm
/opt/perl-5.20.1/lib/5.20.1/strict.pm
```

```
$ perl -e 'use warnings; print join "\n", %INC; print "\n"'
warnings.pm
/opt/perl-5.20.1/lib/5.20.1/warnings.pm
```

Each one loads itself and nothing else.

Interesting side note: providing the `-E` flag instead of the `-e` flag
will automatically load the [feature](https://metacpan.org/pod/feature) pragma.
This might not be surprising if you have seen that `-E` enables all optional features.
(See in [perlrun](https://metacpan.org/pod/distribution/perl/pod/perlrun.pod).)

```
$ perl -E 'print join "\n", %INC; print "\n"'
feature.pm
/opt/perl-5.20.1/lib/5.20.1/feature.pm
```

For some nicer layout, and without loading Data::Dumper, you might want to try the following code:

For example to see what [Moo](/moo) loads:

```
perl -e 'use Moo; printf qq{%30s %s\n}, $_, $INC{$_} for sort keys %INC;'
```

(Windows user will want to replace the single-quotes by double-quotes.)

The output looks like this:

```
                       Carp.pm /opt/perl-5.20.1/lib/5.20.1/Carp.pm
                     Config.pm /opt/perl-5.20.1/lib/5.20.1/darwin-thread-multi-2level/Config.pm
    Devel/GlobalDestruction.pm /opt/perl-5.20.1/lib/site_perl/5.20.1/Devel/GlobalDestruction.pm
                   Exporter.pm /opt/perl-5.20.1/lib/5.20.1/Exporter.pm
                Import/Into.pm /opt/perl-5.20.1/lib/site_perl/5.20.1/Import/Into.pm
                  List/Util.pm /opt/perl-5.20.1/lib/5.20.1/darwin-thread-multi-2level/List/Util.pm
             Module/Runtime.pm /opt/perl-5.20.1/lib/site_perl/5.20.1/Module/Runtime.pm
                        Moo.pm /opt/perl-5.20.1/lib/site_perl/5.20.1/Moo.pm
   Moo/HandleMoose/_TypeMap.pm /opt/perl-5.20.1/lib/site_perl/5.20.1/Moo/HandleMoose/_TypeMap.pm
                 Moo/Object.pm /opt/perl-5.20.1/lib/site_perl/5.20.1/Moo/Object.pm
                 Moo/_Utils.pm /opt/perl-5.20.1/lib/site_perl/5.20.1/Moo/_Utils.pm
                   Moo/_mro.pm /opt/perl-5.20.1/lib/site_perl/5.20.1/Moo/_mro.pm
             Moo/sification.pm /opt/perl-5.20.1/lib/site_perl/5.20.1/Moo/sification.pm
                Scalar/Util.pm /opt/perl-5.20.1/lib/5.20.1/darwin-thread-multi-2level/Scalar/Util.pm
   Sub/Exporter/Progressive.pm /opt/perl-5.20.1/lib/site_perl/5.20.1/Sub/Exporter/Progressive.pm
                   Sub/Name.pm /opt/perl-5.20.1/lib/site_perl/5.20.1/darwin-thread-multi-2level/Sub/Name.pm
                   XSLoader.pm /opt/perl-5.20.1/lib/5.20.1/XSLoader.pm
                       base.pm /opt/perl-5.20.1/lib/5.20.1/base.pm
                   constant.pm /opt/perl-5.20.1/lib/5.20.1/constant.pm
                       main.pm -e
                        mro.pm /opt/perl-5.20.1/lib/5.20.1/darwin-thread-multi-2level/mro.pm
                     strict.pm /opt/perl-5.20.1/lib/5.20.1/strict.pm
                 strictures.pm /opt/perl-5.20.1/lib/site_perl/5.20.1/strictures.pm
                       vars.pm /opt/perl-5.20.1/lib/5.20.1/vars.pm
                   warnings.pm /opt/perl-5.20.1/lib/5.20.1/warnings.pm
          warnings/register.pm /opt/perl-5.20.1/lib/5.20.1/warnings/register.pm
```

This can make it easy to see if a module that you have changed has been loaded, and from which location in the filesystem. Maybe `@INC`
is not set up correctly and you are using the installed version of the module instead of the development version?
In that case you might want to see [how to add a relative directory to @INC](/how-to-add-a-relative-directory-to-inc)
or [how to change @INC to find modules in non-standard locations](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations).


## Comments

Great Content Gabor, you have no idea how many times you have saved me a lot of time at work, these are great tips!

