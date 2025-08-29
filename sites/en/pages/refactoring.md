---
title: "Refactoring Perl code"
timestamp: 2018-04-20T09:30:01
tags:
  - PPI
published: true
books:
  - refactoring
author: szabgab
archive: true
---


Refactoring is the task of changing code to make it more readable, more maintainable, while not changing it's behavior at all.

The simplest example I usually give is that of changing a variable name to be meaningful.

We all know that naming things is really hard so when we write code and we read in some data we can easily start using meaningless variables. For example `$x`, `$data`, or `$temp`. We might finish our implementation, the code starts doing what we expected it to do, but we still have these meaningless variables.

When a few days or month later we need to come back to make changes we'll be baffled by the meaning of these variables.

It is better to change them to something meaningful to make it easier to read and understand the code.

The process of these changes is called **refactoring**. In this series of articles we are going to see how to do that.


## Tasks

There are many tasks we need to do before and during refactoring. Let's list a few that later will tackle.

* Write unit and integration [tests](/testing).
* Set up Continuous Integration (CI) to run the tests.
* Check and monitor code coverage of your tests.
* Use [Perl::Critic](/perl-critic) to locate areas that need improvement.
* Go over all the .pl and .pm files in a given directory and list all the functions declared in all the files (Limitations of this approach).
* List all the functions that are *not called* in any other file. (What about function called from other projects?)
* Explicit import: Replace the "use Module;" statement by a "use Module qw(func1 func2 func3);" statement in every file listing only the functions that are use in that file.
* Renaming a variable. Making sure we only replace based on scope and not based on text so if we have the same variable name used in two functions, or even just two blocks, we will replace only the selected one of them.
* Rename a function and all the places it is being called.
* Extract subroutine: Take a selected set of lines of code, move them to a newly created function. Place a function call instead of the code we moved. Make sure the variables used in the function are passed in as parameters.

## Tools

Some of the tools that can be used for refactoring Perl code.

* [PPI](http://metacpan.org/pod/PPI)
* [PPIx::EditorTools](http://metacpan.org/pod/PPIx::EditorTools)
* [Perl::Critic](/perl-critic)

## Related Articles

* The [Markua parser series](/markua) and the [Markua in Perl eBook](https://leanpub.com/markua-parser-in-perl5) contains a good description of the process of writing tests, monitoring test coverage and refactoring code. These practices are introduced right from the beginning of the project so it is somewhat different than starting this process on an existing code base, but it can teach you good practices.
* [Benchmark: Refactoring MD5 calculation in Rex](/benchmark-refactoring-md5-calculation-in-rex) is more about checking the speed of the results of a refactoring than the refactoring itself.
* In the [Dancer series](/dancer) we also have an article on [Refactoring Dancer 2 app](/refactoring-dancer2-using-before-hook).
* In the [Testing with Perl](/testing) series we have an article on [Refactoring large test suite](/refactoring-large-test-suite-separating-data-from-code).
* In the [Becoming a co-maintainer of a CPAN-module](/becoming-a-co-maintainer) series we <a href="/refactoring-tests-to-use-test-more"">Refactor the tests to use Test::More</a>.
* In the [Indexing e-mails in an mbox](/indexing-emails-in-an-mbox) series we are [Refactoring the script and add logging](/some-refactoring-and-add-logging-to-mail-boxer).

## Comments

If you use Emacs, you can use a package I wrote: https://github.com/jplindstrom/emacs-lang-refactor-perl (available as a MELPA package).

It only has one refactoring though: extract variable. See the README there for usage and examples.

It can also kinda be used to rename variables, because you can use it to "extract" a variable name into another variable, and then just delete the initial assignment line.

If you use PerlySense, that's already included there, and bound to the key C-o e e v (Edit - Extract Variable).

https://metacpan.org/pod/Devel::PerlySense#Edit/Refactor-Extract-Variable <-- more docs


