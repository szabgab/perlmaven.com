---
title: "Perl tutorial"
timestamp: 2013-07-16T10:00:04
description: "Free Perl Tutorial for people who need to maintain existing Perl code, for people who use Perl for small scripts, and for Perl application development."
published: true
books:
  - beginner
author: szabgab
archive: false
show_related: false
---

## About this Tutorial and eBook

The Perl Maven tutorial will teach you the basics of the Perl programming language.
You'll be able to write simple scripts, analyze log files and read and write CSV files.
Just to name a few common tasks.

You'll learn how to use CPAN and several specific CPAN modules.

It will be a good foundation for you to build on.

If you are interested in getting updated when new parts are published,
please [subscribe to the newsletter](/register).

There is also an [e-book](https://leanpub.com/perl-maven/) version of the material available for purchase.
In addition to the tutorial, the eBook also includes some material that is only available [pro](/pro) subscribers.

## Supporters

[Financial supporters of the Perl Tutorial](/perl-tutorial-supporters)

## Extended eBook

An extended version of the Perl Tutorial is available as an [eBook](https://leanpub.com/perl-maven/).
It contains all the materials from the free tutorial and a number of additional articles that are only available
to the [Pro](/pro) subscribers.

## Brand new or Legacy?

In every tutorial and in every book there is a tension between teaching the most modern techniques
or teach how the legacy code works.

The most recent techniques will only be available to people who can use the most recent version of Perl.
They are probably only relevant to new projects. People who need to use older versions of Perl or
who cannot install modern CPAN modules will just get frustrated seeing all the nice stuff, but not able
to use it.

The old techniques on the other hand will allow you to maintain existing applications and will allow you to write new
applications on both old and new versions of Perl. The drawback here is that in many cases you might need to write
more code, sometimes a lot more code, than you would if you used a recent version of Perl and recent CPAN modules.

This tutorial, and this eBook tries to provide a solution to this dilemma by providing both. Telling you about
the alternative options and giving advice which one to use in which situation.

## Video series

There is a free [video course](/beginner-perl-maven-video-course) that includes over 210 screencasts,
a total of more than 5 hours of video. In addition to presenting the material it also provides explanations
to the solutions of all the exercise.

There is also a free [advanced Perl course](/advanced-perl-maven-video-course).

## Free on-line Beginner Perl Maven tutorial

In this tutorial you are going to learn how to use the Perl 5 programming language to **get your job done**.

You will learn both general language features, and extensions or libraries or as the
Perl programmers call them **modules**. We will see both standard modules, that come with
perl and 3rd-party modules, that we install from **CPAN**.

When it is possible I'll try to teach things in a very task oriented way.
I'll draw up tasks and then we'll learn the necessary tools to solve them.
Where possible I'll also direct you to some exercises you can do to practice what you have learned.


**Introduction**

1. [Install Perl, print Hello World, Safety net (use strict, use warnings)](/installing-perl-and-getting-started)
1. [#!/usr/bin/perl - the hash-bang line](/hashbang)
1. [Editors, IDEs, development environment for Perl](/perl-editor)
1. [Getting Help](/help)
1. [Perl on the command line](/perl-on-the-command-line)
1. [Core Perl documentation, CPAN module documentation](/core-perl-documentation-cpan-module-documentation)
1. [POD - Plain Old Documentation](/pod-plain-old-documentation-of-perl)
1. [Debugging Perl scripts](/debugging-perl-scripts)


**Scalars**

1. [Common warnings and error messages](/common-warnings-and-error-messages)
1. [Prompt, read from STDIN, read from the keyboard](/read-from-stdin)
1. [Automatic string to number conversion](/automatic-value-conversion-or-casting-in-perl)
1. [Conditional statements: if](/if)
1. [Boolean (true and false) values in Perl](/boolean-values-in-perl)
1. [Numerical operators](/numerical-operators)
1. [String operators](/string-operators)
1. [undef, the initial value and the defined function](/undef-and-defined-in-perl)
1. [Strings in Perl: quoted, interpolated and escaped](/quoted-interpolated-and-escaped-strings-in-perl)
1. [Here documents](/here-documents)
1. [Scalar variables](/scalar-variables)
1. [Comparing scalars](/comparing-scalars-in-perl)
1. [String functions: length, lc, uc, index, substr](/string-functions-length-lc-uc-index-substr)
1. [Number Guessing game (rand, int)](/number-guessing-game)
1. [Perl while loop](/while-loop)
1. [Scope of variables in Perl](/scope-of-variables-in-perl)
1. [Boolean Short circuit](/short-circuit)


**Files**

1. [exit](/how-to-exit-from-perl-script)
1. [Standard Output, Standard Error and command line redirection](/stdout-stderr-and-redirection)
1. [warn](/warn)
1. [die](/die)
1. [Writing to files](/writing-to-files-with-perl)
1. [Appending to files](/appending-to-files)
1. [Open and read from files using Perl](/open-and-read-from-files)
1. [Don't open files in the old way](/open-files-in-the-old-way)
1. [Binary mode - reading and writing binary files](/reading-and-writing-binary-files)
1. [eof, end of file in Perl](/end-of-file-in-perl)
1. [tell](/tell)
1. [seek](/seek)
1. truncate
1. [Slurp mode](/slurp)


**Lists and Arrays**

1. Perl foreach loop
1. [The for loop in Perl](/for-loop-in-perl)
1. Lists in Perl
1. Using Modules
1. [Arrays in Perl](/perl-arrays)
1. [Process command line parameters @ARGV](/argv-in-perl)
1. [Process command line parameters using Getopt::Long](/how-to-process-command-line-arguments-in-perl)
1. [Advanced usage of Getopt::Long for accepting command line arguments](/advanced-usage-of-getopt-long-accepting-command-line-arguments)
1. [split](/perl-split)
1. [How to read and process a CSV file? (split, Text::CSV_XS)](/how-to-read-a-csv-file-using-perl)
1. [join](/join)
1. [The year of 19100 (time, localtime, gmtime)](/the-year-19100) and introducing context
1. [Context sensitivity in Perl](/scalar-and-list-context-in-perl)
1. [Reading from a file in scalar and list context](/reading-from-a-file-in-scalar-and-list-context)
1. [STDIN in scalar and list context](/stdin-in-scalar-and-list-context)
1. [Sorting arrays in Perl](/sorting-arrays-in-perl)
1. [Sorting mixed strings](/sorting-mixed-strings)
1. [Unique values in an array in Perl](/unique-values-in-an-array-in-perl)
1. [Manipulating Perl arrays: shift, unshift, push, pop](/manipulating-perl-arrays)
1. [Stack](/reverse-polish-calculator-in-perl)
1. [Queue](/using-a-queue-in-perl)
1. [reverse](/reverse)
1. [The ternary operator](/the-ternary-operator-in-perl)
1. [Loop controls: next and last](/loop-controls-next-last)
1. [min, max, sum using List::Util](/min-max-sum-using-list-util)
1. [qw - quote word](/qw-quote-word)


**Subroutines**

1. [Subroutines and Functions in Perl](/subroutines-and-functions-in-perl)
1. [Passing multiple parameters to a function](/passing-multiple-parameters-to-a-function)
1. [Variable number of parameters](/variable-number-of-parameters)
1. [Returning a list, returning an array](/returning-a-list-from-a-subroutine)
1. [Recursive subroutines](/recursive-subroutines)


**Hashes**

1. [Perl Hashes (dictionary, associative array, look-up table)](/perl-hashes)
1. [Creating hash from an array](/creating-hash-from-an-array)
1. [Perl hash in scalar and list context](/perl-hash-in-scalar-and-list-context)
1. [exists](/exists) hash element
1. [delete](/delete) hash elements
1. [Sorting a hash](/how-to-sort-a-hash-in-perl)
1. [Count word frequency in a text file](/count-words-in-text-using-perl)


**Regular Expressions**

1. [Introduction to Regular Expressions in Perl](/introduction-to-regexes-in-perl)
1. [Regex: character classes](/regex-character-classes)
1. [Regex: special character classes](/regex-special-character-classes)
1. [Regex: quantifiers](/regex-quantifiers)
1. Regex: Greedy and non-greedy match
1. Regex: Grouping and capturing
1. Regex: Anchors
1. Regex options and modifiers
1. Substitutions (search and replace)
1. [trim - remove leading and trailing spaces](/trim)
1. [Perl 5 Regex Cheat sheet](/regex-cheat-sheet)


**Shell related functionality**

1. [Perl -X operators](/file-test-operators)
1. Perl pipes
1. Unix commands: chmod, chown, cd, mkdir, rmdir, ln, ls
1. Unix commands: [pwd - current working directory](/current-working-directory)
1. Running external programs [using system](/running-external-programs-from-perl)
1. [Capturning the output of an external program using qx or backticks](/qx)
1. Capturing output asynchronously
1. Capturing both STDOUT and STDERR
1. Unix commands: rm, mv, cp: [How to remove, copy or rename a file with Perl](/how-to-remove-copy-or-rename-a-file-with-perl)
1. Windows/DOS commands: del, ren, dir
1. File globbing (Wildcards)
1. [Directory handles](/reading-the-content-of-a-directory)
1. Traversing directory tree [manually with recursion](/recursive-subroutines)
1. Traversing directory tree [manually using a queue](/traversing-the-filesystem-using-a-queue) and using find.


**CPAN**

1. [Download and install Perl (Strawberry Perl or manual compilation)](/download-and-install-perl)
1. Download and install Perl using Perlbrew
1. Locating and evaluating CPAN modules
1. [Downloading and installing Perl Modules from CPAN](/how-to-install-a-perl-module-from-cpan)
1. [How to change @INC to find Perl modules in non-standard locations?](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations)
1. [How to change @INC to a relative directory](/how-to-add-a-relative-directory-to-inc)
1. local::lib


**Examples for using Perl**

1. [How to replace a string in a file with Perl? (slurp)](/how-to-replace-a-string-in-a-file-with-perl)
1. [Reading Excel files using Perl](/read-an-excel-file-in-perl)
1. [Creating Excel files using Perl](/create-an-excel-file-with-perl)
1. [Sending e-mail using Perl](/sending-html-email-using-email-stuffer)
1. [CGI scripts with Perl](/perl-cgi-script-with-apache2)
1. Parsing XML files
1. [Reading and writing JSON files](/json)
1. [Database access using Perl (DBI, DBD::SQLite, MySQL, PostgreSQL, ODBC)](/simple-database-access-using-perl-dbi-and-sql)
1. [Accessing LDAP using Perl](/reading-from-ldap-in-perl-using-net-ldap)


**Common warnings and error messages**

1. [Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name) ...
1. .. also explained in [Variable declaration in Perl](/variable-declaration-in-perl)
1. [Use of uninitialized value](/use-of-uninitialized-value)
1. [Bareword not allowed while "strict subs" in use](/barewords-in-perl)
1. [Name "main::x" used only once: possible typo at ...](/name-used-only-once-possible-typo)
1. [Unknown warnings category](/unknown-warnings-category)
1. [Can't use string (...) as a HASH ref while "strict refs" in use at ...](/cant-use-string-as-a-hash-ref-while-strict-refs-in-use) ...
1. ... explained in [Symbolic references in Perl](/symbolic-reference-in-perl)
1. [Can't locate ... in @INC](/cant-locate-in-inc)
1. [Scalar found where operator expected](/scalar-found-where-operator-expected)
1. ["my" variable masks earlier declaration in same scope](/my-variable-masks-earlier-declaration-in-same-scope)
1. [Can't call method ... on unblessed reference](/cant-call-method-on-unblessed-reference)
1. [Argument ... isn't numeric in numeric ...](/argument-isnt-numeric-in-numeric)
1. [Can't locate object method "..." via package "1" (perhaps you forgot to load "1"?)](/cant-locate-object-method-via-package-1)
1. [Odd number of elements in hash assignment](/creating-hash-from-an-array)
1. [Possible attempt to separate words with commas](/qw-quote-word)
1. [Undefined subroutine ... called](/autoload)
1. [Useless use of hash element in void context](/useless-use-of-hash-element-in-void-context)
1. [Useless use of private variable in void context](/useless-use-of-private-variable-in-void-context)
1. [readline() on closed filehandle](/readline-on-closed-filehandle)
1. [Possible precedence issue with control flow operator](/possible-precedence-issue-with-control-flow-operator)
1. [Scalar value better written as ...](/scalar-value-better-written-as)
1. [substr outside of string at ...](/substr-outside-of-string)
1. [Have exceeded the maximum number of attempts (1000) to open temp file/dir](/have-exceeded-the-maximum-number-of-attempts)
1. [Deep recursion on subroutine](/deep-recursion-on-subroutine)
1. [Use of implicit split to @_ is deprecated ...](/use-of-implicit-split-to-is-deprecated)


**Extra articles**

1. [Multi dimensional arrays](/multi-dimensional-arrays-in-perl)
1. [Multi dimensional hashes](/multi-dimensional-hashes)
1. [Minimal requirement to build a sane CPAN package](/minimal-requirement-to-build-a-sane-cpan-package)
1. [Statement modifiers: reversed if statements](/statement-modifiers)
1. [autovivification](/autovivification)
1. [Formatted printing in Perl](/printf) using printf and sprintf


**From other books**

1. [Splice to slice and dice arrays in Perl](/splice-to-slice-and-dice-arrays-in-perl)
1. [How to improve your Perl code](/how-to-improve-my-perl-program)


**Object Oriented Perl with Moose or Moo**

There is a whole series of articles on writing Object Oriented code, using the
light-weight [Moo](/moo) OOP framework or the full-blown [Moose](/moose) OOP framework.

---

There is a corresponding [video courses](/beginner-perl-maven-video-course) and the whole tutorial
is available as [eBook](https://leanpub.com/perl-maven/).

