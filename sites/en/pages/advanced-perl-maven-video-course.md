---
title: "Advanced Perl Maven video course"
timestamp: 2012-07-17T00:03:01
description: "Advanced level, online video training course for people who would like to improve their Perl programming skills"
types:
  - video
published: true
books:
  - advanced
archive: false
---


This <b>Advanced Perl training course</b>
will allow you to create modules, classes. To write
Object Oriented code in the modern way, using <b>Moose</b>,
and by using only core Perl, manually blessing references.

It is based on many years of experience teaching Perl,
blended with the modern features of Perl and CPAN.

Taking this course will help you maintain existing code and
it will teach you how to use modern Perl tools to write new,
<b>nice and maintainable Perl code</b>.

## Table of Content

Some of the episodes are already available, some are going to be published later on.
Some require registrations to the [Perl Maven Pro](/pro) others can be freely accessed by anyone.
Some include screencasts, others contain just text.

## Libraries and Modules, Packages and Namespaces

<ol>
  <li>[Introduction to the Advanced Perl Maven course](/introduction-to-advanced-perl-course)</li>
  <li>[Perl 4 libraries](/perl4-libraries)</li>
  <li>[The problem with Perl 4-style libraries](/the-problem-with-libraries)</li>
  <li>[Namespaces or packages](/namespaces-and-packages)</li>
  <li>[Modules](/modules)</li>
  <li>[How does require find the module to be loaded?](/require-at-inc)</li>
  <li>[What is the difference between require and use? What does import do?](/use-require-import)</li>
  <li>[Exporting and importing functions easily](/import)</li>
  <li>[Restrict the import by listing the functions to be imported](/restrict-the-import)</li>
  <li>[Import on demand](/on-demand-import)</li>
  <li>[Behind the scenes](/behind-the-scenes)</li>
  <li>[Tools to package Perl scripts, modules, and application](/tools-to-package-modules)</li>
  <li>[Distribution directory layout](/distribution-directory-layout)</li>
  <li>[Makefile.PL of ExtUtils::MakeMaker](/makefile-pl-of-extutils-makemaker)</li>
  <li>[Makefile.PL of Module::Install](/makefile-pl-of-module-install)</li>
  <li>[Build.PL of Module::Build](/build-pl-of-module-build)</li>
  <li>[Changes and README](/changes-and-readme)</li>
  <li>[MANIFEST and MANIFEST.SKIP](/manifest-and-manifest-skip)</li>
  <li>[Packaging a script and a module](/file-and-module)</li>
  <li>[Packaging with Makefile.PL](/packaging-with-makefile-pl)</li>
  <li>[Packaging with Build.PL](/packaging-with-build-pl)</li>
  <li>[test-file](/test-file)</li>

  <li>@INC and the namespace hierarchy</li>
  <li>[How to create a Perl Module for code reuse?](/how-to-create-a-perl-module-for-code-reuse)</li>
  <li>Exporting functions automatically</li>
  <li>Packaging modules for distribution</li>
  <li>Writing Unit Tests for Perl Modules</li>
  <li>Exception handling with eval block</li>
  <li>Exception handling with Try::Tiny</li>
  <li>Warnings and errors from the users POV with Carp</li>
  <li>Throwing exceptions with die and with Exception::Class</li>
</ol>


## Using existing modules
<ol>
  <li>Using standard modules</li>
  <li>Installing modules from CPAN</li>
  <li>Using CPAN modules</li>
</ol>

## References
<ol>
<li>Introduction to References</li>
  <li>[Passing two arrays to a function](/passing-two-arrays-to-a-function)</li>
  <li>[Array references](/array-references-in-perl)</li>
  <li>Handling multi-dimensional, complex data structures</li>
  <li>Manipulating Complex Data Structures</li>
  <li>Reference counting</li>
  <li>Debugging data structures</li>
  <li>Anonymous arrays and hashes</li>
  <li>Subroutine references</li>
  <li>Dispatch tables</li>
  <li>Handling memory leak</li>
  <li>Deep copy of data structures</li>
  <li>[Static and state variables](/static-and-state-variables-in-perl)</li>
  <li>Closures</li>
  <li>Creating a caching system</li>
  <li>Signal handling</li>
  <li>Handling warnings in the code</li>
  <li>[Filtering with grep in Perl](/filtering-values-with-perl-grep)</li>
  <li>[Transforming a perl array using the map function](/transforming-a-perl-array-using-map)</li>
  <li>Array and hash slices</li>
  <li>Creating context sensitive functions using wantarray.</li>
  <li>Improving speed by using the Schwartzian transformation</li>
  <li>Anonymous functions</li>
  <li>Memoization</li>
  <li>Data serialization</li>
  <li>Practical use of function references</li>
</ol>

## Packaging modules for distribution
<ol>
  <li>The directory hierarchy of a CPAN module</li>
  <li>Writing Unit Tests for Perl Modules</li>
  <li>ExtUtils::MakeMaker</li>
  <li>Module::Build</li>
  <li>Module::Install</li>
  <li>Dist::Zilla</li>
</ol>


## Object Oriented Programming in Perl using raw classes

See the [Classic Object Oriented Perl](/oop) page.

## Object Oriented using Moo

See the [Moo page](/moo)

## Object Oriented using Moose

See the [Moose page](/moose)

## Some other advanced topics

<ol>
  <li>Throwing exceptions in Perl</li>
  <li>Catching exceptions in Perl</li>
  <li>[Always use strict and warnings](/always-use-strict-and-use-warnings)</li>
  <!-- <li>[Variable declaration in Perl](/variable-declaration-in-perl)</li> -->
  <!-- <li>[Symbolic references in Perl](/symbolic-reference-in-perl)</li> -->
  <!-- <li>[Barewords in Perl](/barewords-in-perl)</li> -->
  <li>[How to handle warnings in an application?](/how-to-capture-and-save-warnings-in-perl)</li>
  <!-- <li>[Unknown warnings category](/unknown-warnings-category) -->
  <li>[splain and use diagnostics](/use-diagnostics-or-splain)</li>
  <li>Fatal warnings</li>
  <li>Array and hash slices</li>
  <li>[splice](/splice-to-slice-and-dice-arrays-in-perl)</li>
  <li>[AUTOLOAD](/autoload)</li>
  <li>[BEGIN](/begin)</li>
  <li>[END](/end)</li>
  <li>[How to sort faster in Perl - Schwartzian transformation](/how-to-sort-faster-in-perl)</li>
  <li>use autodie</li>
  <li>[Perl::Critic](/search/Perl::Critic)</li>
  <li>[Avoid unwanted bitwise operators using Perl::Critic](/avoid-unwanted-bitwise-operators)</li>
  <li>Perl::Tidy</li>
  <li>Saved variable: local</li>
  <li>Who is calling? caller</li>
  <li>Logging with Log::Dispatch</li>
  <li>Time and date with DateTime</li>
  <li>Signals and the kill function</li>
  <li>[default scalar variable of Perl](/the-default-variable-of-perl)</li>
</ol>



## What do people say?

```
Just watched the Advanced Perl Maven - Online video course by @szabgab.
Fantastic value, great course. ++.
```

[Mark Smith](http://twitter.com/#!/marksmith)

```
@szabgab oh cool thanks! im recommending it to my boss too so
he can better appreciate the work i do :)

@szabgab hah! im also getting it for myself too.. need to fill in the
blanks in my perl knowledge. thanks for making your tutorials available
@szabgab just got all 3 courses! btw i found you through youtube when
i was looking for help using perl Dancer and found your blog tutorial.
```

[Captain Fwiffo](http://twitter.com/#!/captain_fwiffo)


