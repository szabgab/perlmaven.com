---
title: "Perl::Critic example - lint for Perl"
timestamp: 2015-12-02T10:40:01
tags:
  - Perl::critic
  - perlcritic
  - lint
published: true
author: szabgab
archive: true
---


[Perl::Critic](https://metacpan.org/pod/Perl::Critic) is a
[lint](http://en.wikipedia.org/wiki/Lint_(software))-like
tool for Perl. It uses static analysis (it does not run your code) and
provides a list of places where the code violates one of the policy rules.

Originally based on the book
[Perl Best Practices](http://shop.oreilly.com/product/9780596001735.do) written
by [Damian Conway](http://damian.conway.org/), the module is extendable and customizable.
You, or your team can set up your own standard, and use Perl::Critic to enforce it.


The [Perl::Critic](https://metacpan.org/pod/Perl::Critic) module
comes with a command line tool called **perlcritic**, but you
can also integrate the use of Perl::Critic in your unit-tests via
the [Test::Perl::Critic](http://metacpan.org/pod/Test::Perl::Critic)
wrapper.

As an example, let's see the results of the default, the most gentle level of criticism
of a script I saw recently. Let's also add some commentary.

## Code before strictures are enabled

```
$ perlcritic example.pl
Bareword file handle opened at line 1, column 1.  See pages 202,204 of PBP.  (Severity: 5)
Two-argument "open" used at line 1, column 1.  See page 207 of PBP.  (Severity: 5)
Code before strictures are enabled at line 1, column 1.  See page 429 of PBP.  (Severity: 5)
```

This report was given for the following code:

```perl
open FH, $filename or die;
```

Let's start with the third entry. It complains about that fact that there is no `use strict;`.
As I recommend, one should [always use strict!](/strict)

So I changed the code and ran `perlcritic again.

```perl
use strict;
open FH, $filename or die;
```

## Bareword file handle and Two-argument "open"

This time the output was this:

```
Bareword file handle opened at line 2, column 1.  See pages 202,204 of PBP.  (Severity: 5)
Two-argument "open" used at line 2, column 1.  See page 207 of PBP.  (Severity: 5)
```

A [bareword](/barewords-in-perl) is a series of characters (like the FH in the above code snippet) without
quotes around them, or without a sigil in-front of them. They can be used in some places, but in file-handles they are not recommended any more.

The recommendation is to [always use lexical variables for file-handles and always use 3-parameter open](/open-files-in-the-old-way).

Based on the recommendation on [how to improve perl script](/how-to-improve-my-perl-program) I've updated the script to
have this code:

```perl
use strict;
open my $fh, '<:encoding(UTF-8)', $filename or die;
```

That was the **gentle** level of Perl::Critic. Let's make it a bit more **stern**
by running `perlcritic --stern example.pl`:

## Exclude specific policy violations

This is the output I got:

```
Code not contained in explicit package at line 1, column 1.  Violates encapsulation.  (Severity: 4)
Close filehandles as soon as possible after opening them at line 2, column 1.  See page 209 of PBP.  (Severity: 4)
Module does not end with "1;" at line 2, column 1.  Must end with a recognizable true value.  (Severity: 4)
Code before warnings are enabled at line 2, column 1.  See page 431 of PBP.  (Severity: 4)
```

Out of these 4 violations two relate to the fact that we write a script and not a module. We don't really want to care about
those and so we would like to turn those off. There are a number of ways to do that, one of them is to provide the
names of the rules on the command line with the `--exclude` flag.

In order to find out the names we need to exclude we can run `perlcritic --stern --verbose 8 examples.pl` that will
display the following output:

```
[Modules::RequireExplicitPackage] Code not contained in explicit package at line 1, column 1.  (Severity: 4)
[InputOutput::RequireBriefOpen] Close filehandles as soon as possible after opening them at line 2, column 1.  (Severity: 4)
[Modules::RequireEndWithOne] Module does not end with "1;" at line 2, column 1.  (Severity: 4)
[TestingAndDebugging::RequireUseWarnings] Code before warnings are enabled at line 2, column 1.  (Severity: 4)
```

From that we create the following command:

`perlcritic --stern --exclude RequireExplicitPackage --exclude RequireEndWithOne  example.pl`

will print this:

```
Close filehandles as soon as possible after opening them at line 2, column 1.  See page 209 of PBP.  (Severity: 4)
Code before warnings are enabled at line 2, column 1.  See page 431 of PBP.  (Severity: 4)
```


## Close filehandles as soon as possible after opening them

tells use that we should call `close $fh` soon after calling `open`.

## Code before warnings are enabled

tells us to add `use warnings;` at the beginning of the code just as it is explained in
the article that asks you to 
[always use warnings](/always-use-strict-and-use-warnings)


## More levels of perlcritic

The `perlcritic` command line tool actually has 5 levels of severity. So far we tried level 5 and 4
corresponding to the words "gentle" and "stern". The other 3 levels are "harsh", "cruel", and "brutal"
creating a growing level of pain. You can try them and see what kind of violations they report on your code.


