---
title: "How to improve my Perl program?"
timestamp: 2013-11-26T07:30:01
tags:
  - open
  - Perl::Critic
  - Perl::Tidy
published: true
books:
  - beginner
author: szabgab
---


Once in a while people send me sample code with some problems to fix.
Besides fixing the problems I often find myself recommending a few
things they can do to quickly improve their Perl code.


## Layout - especially indentation

Having a clean layout of the code makes it a lot
more readable. It can also help reveal the source of bugs.
For example a loop that does not have good indentation will
make it unclear where do specific parts belong.

To which `foreach` loop does the `next` statement belong here?

```perl
foreach my $x (@array1) {
foreach my $y (@array2} { }
if (cond) {
next;
}
}
```

This version is much more readable:

```perl
foreach my $x (@array1) {
    foreach my $y (@array2} {
    }
    if (cond) {
        next;
    }
}
```

While not perfect, [Perl::Tidy](https://metacpan.org/pod/Perl::Tidy)
comes with a command line tool called `perltidy` that can create
a better layout for your program.

## Descriptive variable names

What is in `@array1` in above example? We know it is an array as it has
`@` at the beginning. It does not help a lot that it is also called array1.
Please try to give names to the variables that describe their content.
The actual names will very much depend on the context of the problem but variables such
as `@users` and `@server_names` might be much better.

The same goes for the loop variables. Instead of `$x` and `$y` there could be
longer, and more descriptive names.


## Don't use $a and $b

[Don't use $a and $b](/dont-use-a-and-b-variables)

As a special case, `$a` and `$b` are special variables used by the
[sort](/sorting-arrays-in-perl) function.
Don't use them anywhere else. Not even for short one-off
examples! They are just confusing and as they don't require declaration with `my`
they can really mess with the mind of beginners.

(Why does Perl complain about $x not being declared but not about $a...?).

## Eliminate $_

Having `$_` the topic variable in Perl is awesome, but in general the idea
is that you should not write it down. The whole point of a
[default variable](/the-default-variable-of-perl)
is that you don't have to type it in.

`$_` should almost never be seen in code.

Major exceptions are
[map](/transforming-a-perl-array-using-map),
[grep](/filtering-values-with-perl-grep)
and similar functions,
where unfortunately you can't avoid it.

Anywhere else, if you have to type in `$_`, probably it is time to
create your own variable with its **descriptive name**.

## Always use strict and use warnings

Always [use strict](/strict) and
[use warnings](/installing-perl-and-getting-started).

They are your safety net!

## Lexical filehandle and 3 argument open

Very old school:

```perl
open FH, $filename or die;
```

Newer school:

```perl
open my $fh, '<', $filename or die;
```

Even newer school:

```perl
open my $fh, '<:encoding(UTF-8)', $filename or die;
```

Cool school:

```perl
use Path::Tiny qw(path);
my $fh = path($filename)->openr_utf8;
```

There are other cool ways to use [Path::Tiny](https://metacpan.org/pod/Path::Tiny),
but even if for some reason you cannot use Path::Tiny, you can certainly
use the one with lexical variable (my $fh) and with 3 parameters.

In any case, please
[don't open files in the old way](/open-files-in-the-old-way).

## Direct object notation

This is less of a problem, but it is my pet peeve: 

When creating an object from a class write this way (direct object notation):

```perl
Module->new(param, param);
```

instead of the indirect object notation:

```perl
new Module(param, param);
```

Even if the documentation of the module shows the second way.

In most cases they are equivalent, but in every script/application/project/company
it is better to write in one way, and then, please, pick the former.


## Use Perl::Critic

[Perl::Critic](http://metacpan.org/pod/Perl::Critic) is awesome, and I
know the guy who wrote it! It comes with a command line tool called
**perlcritic** that gets a filename a input and gives you a list
of things you can improve. It is configurable but the default
(which is the gentle level 5) is a very good start.

Just run `perlcritic myscript.pl` or `perlcritic lib/My/Module.pm`
and you'll have plenty to improve.

## Object Oriented Programming

If your code is written with OOP, using bless, or one
of the accessor generators, it might improve your code
to move to use [Moo](/moo) or [Moose](/moose).



