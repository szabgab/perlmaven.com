---
title: "How does require find the module to be loaded?"
timestamp: 2017-01-22T00:30:11
tags:
  - "@INC"
  - require
  - "-V"
books:
  - advanced
types:
  - screencast
published: true
author: szabgab
---


Now you know [how to create a module in Perl](/modules), but it is not yet clear how did perl find the `Calc.pm`
file in the previous example? After all we only wrote `require Calc;`.


<slidecast file="advanced-perl/libraries-and-modules/require-at-inc"  youtube="ZDLkN2kCx2Y" />


Before going further though two things:

You probably have already used modules in Perl and you have probably used the `use` keyword to load the
modules. Don't worry, everything you see here about `require` also applies to `use` as internally `use`
calls `require`.

You have probably also seen modules with one or more double-colon pairs between names. So not only `Calc`, but
`Math::Calc`, and even `Math::Calc::Clever` are possible names.

When you write `require Calc;` perl will look through the directories listed in the array called `@INC`
for a file called `Calc.pm`.

The content of `@INC` was embedded in perl when perl itself was compiled. Later we'll see how can
we change it to [find module in non-standard locations](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations)
or in a [directory relative to our script](/how-to-add-a-relative-directory-to-inc)

If you'd like to find out what is in `@INC`, you can run `perl -V` on the command line. At the end of the output you will
see the list of directories. For example on OSX I got this:

```
  @INC:
    /Library/Perl/5.18/darwin-thread-multi-2level
    /Library/Perl/5.18
    /Network/Library/Perl/5.18/darwin-thread-multi-2level
    /Network/Library/Perl/5.18
    /Library/Perl/Updates/5.18.2
    /System/Library/Perl/5.18/darwin-thread-multi-2level
    /System/Library/Perl/5.18
    /System/Library/Perl/Extras/5.18/darwin-thread-multi-2level
    /System/Library/Perl/Extras/5.18
    .
```

On MS Windows using [Strawberry Perl](http://strawberryperl.com/) I got this:

```
  @INC:
    C:/strawberry/perl/lib
    C:/strawberry/perl/site/lib
    C:\strawberry\perl\vendor\lib
    .
```

Note, in both cases the `.` indicating the current directory can be found in the list at the last position. This means
if the module is in the current directory, perl will find it. On the other hand, if the module is in the `lib/` subdirectory
then perl won't find it without some extra help.


If you require a module that has a double-colon in its name, for example `Math::Calc` then perl will look for a subdirectory
called `Math` in the directories listed in `@INC`, and within that `Math` subdirectory it will look
for a file called `Calc.pm`.

The first one it finds will be loaded into memory. So there might be several such files in the directories listed in `@INC`,
but perl will find the first one and disregard the rest.

If you `require Math::Calc::Clever;` then perl will look for a subdirectory called `Math` in the directories listed
in `@INC`. Inside the `Math` directory it will look for a directory called `Calc` and in that directory
a file called `Clever.pm`.

If perl cannot find the right file in any of the directories it will throw an exception
[Can't locate ... in @INC](/cant-locate-in-inc).


