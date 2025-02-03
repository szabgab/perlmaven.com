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

In this tutorial you are going to learn how to use the Perl 5 programming language to <b>get your job done</b>.

You will learn both general language features, and extensions or libraries or as the
Perl programmers call them <b>modules</b>. We will see both standard modules, that come with
perl and 3rd-party modules, that we install from <b>CPAN</b>.

When it is possible I'll try to teach things in a very task oriented way.
I'll draw up tasks and then we'll learn the necessary tools to solve them.
Where possible I'll also direct you to some exercises you can do to practice what you have learned.


<b>Introduction</b>
<ol>
    <li>[Install Perl, print Hello World, Safety net (use strict, use warnings)](/installing-perl-and-getting-started)</li>
    <li>[#!/usr/bin/perl - the hash-bang line](/hashbang)</li>
    <li>[Editors, IDEs, development environment for Perl](/perl-editor)</li>
    <li>[Getting Help](/help)</li>
    <li>[Perl on the command line](/perl-on-the-command-line)</li>
    <li>[Core Perl documentation, CPAN module documentation](/core-perl-documentation-cpan-module-documentation)</li>
    <li>[POD - Plain Old Documentation](/pod-plain-old-documentation-of-perl)</li>
    <li>[Debugging Perl scripts](/debugging-perl-scripts)</li>
</ol>

<b>Scalars</b>
<ol>
    <li>[Common warnings and error messages](/common-warnings-and-error-messages)</li>
    <li>[Prompt, read from STDIN, read from the keyboard](/read-from-stdin)</li>
    <li>[Automatic string to number conversion](/automatic-value-conversion-or-casting-in-perl)</li>
    <li>[Conditional statements: if](/if)</li>
    <li>[Boolean (true and false) values in Perl](/boolean-values-in-perl)</li>
    <li>[Numerical operators](/numerical-operators)</li>
    <li>[String operators](/string-operators)</li>
    <li>[undef, the initial value and the defined function](/undef-and-defined-in-perl)</li>
    <li>[Strings in Perl: quoted, interpolated and escaped](/quoted-interpolated-and-escaped-strings-in-perl)</li>
    <li>[Here documents](/here-documents)</li>
    <li>[Scalar variables](/scalar-variables)</li>
    <li>[Comparing scalars](/comparing-scalars-in-perl)</li>
    <li>[String functions: length, lc, uc, index, substr](/string-functions-length-lc-uc-index-substr)</li>
    <li>[Number Guessing game (rand, int)](/number-guessing-game)</li>
    <li>[Perl while loop](/while-loop)</li>
    <li>[Scope of variables in Perl](/scope-of-variables-in-perl)</li>
    <li>[Boolean Short circuit](/short-circuit)</li>
</ol>

<b>Files</b>
<ol>
    <li>[exit](/how-to-exit-from-perl-script)</li>
    <li>[Standard Output, Standard Error and command line redirection](/stdout-stderr-and-redirection)</li>
    <li>[warn](/warn)</li>
    <li>[die](/die)</li>
    <li>[Writing to files](/writing-to-files-with-perl)</li>
    <li>[Appending to files](/appending-to-files)</li>
    <li>[Open and read from files using Perl](/open-and-read-from-files)</li>
    <li>[Don't open files in the old way](/open-files-in-the-old-way)</li>
    <li>[Binary mode - reading and writing binary files](/reading-and-writing-binary-files)</li>
    <li>[eof, end of file in Perl](/end-of-file-in-perl)</li>
    <li>[tell](/tell)</li>
    <li>[seek](/seek)</li>
    <li>truncate</li>
    <li>[Slurp mode](/slurp)</li>
</ol>

<b>Lists and Arrays</b>
<ol>
    <li>Perl foreach loop</li>
    <li>[The for loop in Perl](/for-loop-in-perl)</li>
    <li>Lists in Perl</li>
    <li>Using Modules</li>
    <li>[Arrays in Perl](/perl-arrays)</li>
    <li>[Process command line parameters @ARGV](/argv-in-perl)</li>
    <li>[Process command line parameters using Getopt::Long](/how-to-process-command-line-arguments-in-perl)</li>
    <li>[Advanced usage of Getopt::Long for accepting command line arguments](/advanced-usage-of-getopt-long-accepting-command-line-arguments)</li>
    <li>[split](/perl-split)</li>
    <li>[How to read and process a CSV file? (split, Text::CSV_XS)](/how-to-read-a-csv-file-using-perl)</li>
    <li>[join](/join)</li>
    <li>[The year of 19100 (time, localtime, gmtime)](/the-year-19100) and introducing context</li>
    <li>[Context sensitivity in Perl](/scalar-and-list-context-in-perl)</li>
    <li>[Reading from a file in scalar and list context](/reading-from-a-file-in-scalar-and-list-context)</li>
    <li>[STDIN in scalar and list context](/stdin-in-scalar-and-list-context)</li>
    <li>[Sorting arrays in Perl](/sorting-arrays-in-perl)</li>
    <li>[Sorting mixed strings](/sorting-mixed-strings)</li>
    <li>[Unique values in an array in Perl](/unique-values-in-an-array-in-perl)</li>
    <li>[Manipulating Perl arrays: shift, unshift, push, pop](/manipulating-perl-arrays)</li>
    <li>[Stack](/reverse-polish-calculator-in-perl)</li>
    <li>[Queue](/using-a-queue-in-perl)</li>
    <li>[reverse](/reverse)</li>
    <li>[The ternary operator](/the-ternary-operator-in-perl)</li>
    <li>[Loop controls: next and last](/loop-controls-next-last)</li>
    <li>[min, max, sum using List::Util](/min-max-sum-using-list-util)</li>
    <li>[qw - quote word](/qw-quote-word)</li>
</ol>

<b>Subroutines</b>
<ol>
    <li>[Subroutines and Functions in Perl](/subroutines-and-functions-in-perl)</li>
    <li>[Passing multiple parameters to a function](/passing-multiple-parameters-to-a-function)</li>
    <li>[Variable number of parameters](/variable-number-of-parameters)</li>
    <li>[Returning a list, returning an array](/returning-a-list-from-a-subroutine)</li>
    <li>[Recursive subroutines](/recursive-subroutines)</li>
</ol>

<b>Hashes</b>
<ol>
    <li>[Perl Hashes (dictionary, associative array, look-up table)](/perl-hashes)</li>
    <li>[Creating hash from an array](/creating-hash-from-an-array)</li>
    <li>[Perl hash in scalar and list context](/perl-hash-in-scalar-and-list-context)</li>
    <li>[exists](/exists) hash element</li>
    <li>[delete](/delete) hash elements</li>
    <li>[Sorting a hash](/how-to-sort-a-hash-in-perl)</li>
    <li>[Count word frequency in a text file](/count-words-in-text-using-perl)</li>
</ol>

<b>Regular Expressions</b>
<ol>
    <li>[Introduction to Regular Expressions in Perl](/introduction-to-regexes-in-perl)</li>
    <li>[Regex: character classes](/regex-character-classes)</li>
    <li>[Regex: special character classes](/regex-special-character-classes)</li>
    <li>[Regex: quantifiers](/regex-quantifiers)</li>
    <li>Regex: Greedy and non-greedy match</li>
    <li>Regex: Grouping and capturing</li>
    <li>Regex: Anchors</li>
    <li>Regex options and modifiers</li>
    <li>Substitutions (search and replace)</li>
    <li>[trim - remove leading and trailing spaces](/trim)</li>
    <li>[Perl 5 Regex Cheat sheet](/regex-cheat-sheet)</li>
</ol>

<b>Shell related functionality</b>
<ol>
    <li>[Perl -X operators](/file-test-operators)</li>
    <li>Perl pipes</li>
    <li>Unix commands: chmod, chown, cd, mkdir, rmdir, ln, ls</li>
    <li>Unix commands: [pwd - current working directory](/current-working-directory)</li>
    <li>Running external programs [using system](/running-external-programs-from-perl)</li>
    <li>[Capturning the output of an external program using qx or backticks](/qx)</li>
    <li>Capturing output asynchronously</li>
    <li>Capturing both STDOUT and STDERR</li>
    <li>Unix commands: rm, mv, cp: [How to remove, copy or rename a file with Perl](/how-to-remove-copy-or-rename-a-file-with-perl)</li>
    <li>Windows/DOS commands: del, ren, dir</li>
    <li>File globbing (Wildcards)</li>
    <li>[Directory handles](/reading-the-content-of-a-directory)</li>
    <li>Traversing directory tree [manually with recursion](/recursive-subroutines)</li>
    <li>Traversing directory tree [manually using a queue](/traversing-the-filesystem-using-a-queue) and using find.</li>
</ol>

<b>CPAN</b>
<ol>
    <li>[Download and install Perl (Strawberry Perl or manual compilation)](/download-and-install-perl)</li>
    <li>Download and install Perl using Perlbrew</li>
    <li>Locating and evaluating CPAN modules</li>
    <li>[Downloading and installing Perl Modules from CPAN](/how-to-install-a-perl-module-from-cpan)</li>
    <li>[How to change @INC to find Perl modules in non-standard locations?](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations)</li>
    <li>[How to change @INC to a relative directory](/how-to-add-a-relative-directory-to-inc)</li>
    <li>local::lib</li>
</ol>

<b>Examples for using Perl</b>
<ol>
    <li>[How to replace a string in a file with Perl? (slurp)](/how-to-replace-a-string-in-a-file-with-perl)</li>
    <li>[Reading Excel files using Perl](/read-an-excel-file-in-perl)</li>
    <li>[Creating Excel files using Perl](/create-an-excel-file-with-perl)</li>
    <li>[Sending e-mail using Perl](/sending-html-email-using-email-stuffer)</li>
    <li>[CGI scripts with Perl](/perl-cgi-script-with-apache2)</li>
    <li>Parsing XML files</li>
    <li>[Reading and writing JSON files](/json)</li>
    <li>[Database access using Perl (DBI, DBD::SQLite, MySQL, PostgreSQL, ODBC)](/simple-database-access-using-perl-dbi-and-sql)</li>
    <li>[Accessing LDAP using Perl](/reading-from-ldap-in-perl-using-net-ldap)</li>
</ol>

<b>Common warnings and error messages</b>
<ol>
    <li>[Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name) ...</li>
    <li>.. also explained in [Variable declaration in Perl](/variable-declaration-in-perl)</li>
    <li>[Use of uninitialized value](/use-of-uninitialized-value)</li>
    <li>[Bareword not allowed while "strict subs" in use](/barewords-in-perl)</li>
    <li>[Name "main::x" used only once: possible typo at ...](/name-used-only-once-possible-typo)</li>
    <li>[Unknown warnings category](/unknown-warnings-category)</li>
    <li>[Can't use string (...) as a HASH ref while "strict refs" in use at ...](/cant-use-string-as-a-hash-ref-while-strict-refs-in-use) ...</li>
    <li>... explained in [Symbolic references in Perl](/symbolic-reference-in-perl)</li>
    <li>[Can't locate ... in @INC](/cant-locate-in-inc)</li>
    <li>[Scalar found where operator expected](/scalar-found-where-operator-expected)</li>
    <li>["my" variable masks earlier declaration in same scope](/my-variable-masks-earlier-declaration-in-same-scope)</li>
    <li>[Can't call method ... on unblessed reference](/cant-call-method-on-unblessed-reference)</li>
    <li>[Argument ... isn't numeric in numeric ...](/argument-isnt-numeric-in-numeric)</li>
    <li>[Can't locate object method "..." via package "1" (perhaps you forgot to load "1"?)](/cant-locate-object-method-via-package-1)</li>
    <li>[Odd number of elements in hash assignment](/creating-hash-from-an-array)</li>
    <li>[Possible attempt to separate words with commas](/qw-quote-word)</li>
    <li>[Undefined subroutine ... called](/autoload)</li>
    <li>[Useless use of hash element in void context](/useless-use-of-hash-element-in-void-context)</li>
    <li>[Useless use of private variable in void context](/useless-use-of-private-variable-in-void-context)</li>
    <li>[readline() on closed filehandle](/readline-on-closed-filehandle)</li>
    <li>[Possible precedence issue with control flow operator](/possible-precedence-issue-with-control-flow-operator)</li>
    <li>[Scalar value better written as ...](/scalar-value-better-written-as)</li>
    <li>[substr outside of string at ...](/substr-outside-of-string)</li>
    <li>[Have exceeded the maximum number of attempts (1000) to open temp file/dir](/have-exceeded-the-maximum-number-of-attempts)</li>
    <li>[Deep recursion on subroutine](/deep-recursion-on-subroutine)</li>
    <li>[Use of implicit split to @_ is deprecated ...](/use-of-implicit-split-to-is-deprecated)</li>
</ol>

<b>Extra articles</b>
<ol>
    <li>[Multi dimensional arrays](/multi-dimensional-arrays-in-perl)</li>
    <li>[Multi dimensional hashes](/multi-dimensional-hashes)</li>
    <li>[Minimal requirement to build a sane CPAN package](/minimal-requirement-to-build-a-sane-cpan-package)</li>
    <li>[Statement modifiers: reversed if statements](/statement-modifiers)</li>
    <li>[autovivification](/autovivification)</li>
    <li>[Formatted printing in Perl](/printf) using printf and sprintf</li>
</ol>

<b>From other books</b>
<ol>
    <li>[Splice to slice and dice arrays in Perl](/splice-to-slice-and-dice-arrays-in-perl)</li>
    <li>[How to improve your Perl code](/how-to-improve-my-perl-program)</li>
</ol>

<b>Object Oriented Perl with Moose or Moo</b>

There is a whole series of articles on writing Object Oriented code, using the
light-weight [Moo](/moo) OOP framework or the full-blown [Moose](/moose) OOP framework.

<hr>

There is a corresponding [video courses](/beginner-perl-maven-video-course) and the whole tutorial
is available as [eBook](https://leanpub.com/perl-maven/).

