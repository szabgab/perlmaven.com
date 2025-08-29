---
title: "The problem with Perl 4 style libraries"
timestamp: 2017-01-06T08:00:11
tags:
  - -w
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


Now that we have seen how to use [Perl 4 libraries](/perl4-libraries), let's see what are the problems with them?

Although they are still in use, they belong to  much earlier era. Before Perl 5 came out in 1995.


<slidecast file="advanced-perl/libraries-and-modules/the-problem-with-libraries" youtube="UZeEzD5459c" />

All of nothing:
The library (`library.pl`) we had in [Perl 4 libraries](/perl4-libraries) had 3 functions in
it and a global variable (`$base`). If we `import` the file as we have done in the `perl4_app.pl`
file then we will have all the functions and variables of the library in our script.

The problem is that if you have more than one libraries used in the same script and some of the function names are
declared in both. For example there is an `add` function of the library dealing with math and a totally different
`add` function in a library dealing with inventory. If you write a script that requires both libraries
then both would import the `add` function and they would override each other. More specifically the second one
loaded (using require) would override the first one. Which means the load order of the requires will matter, which
will probably drive crazy someone who is trying to understand why the script acts strangely.

This potential of collision just increases with the number of additional libraries used.

And perl does not even warn you about this, of course, because this is Perl 4 style coding without `use warnings`.
(Although we could turn on warnings by adding `-w` to the sh-bang line:

```
#!/usr/bin/perl -w
```

Even more problematic is that now all the internal functions (`validate_parameters` in our case),
and all the internal global variables (`$base` in our case) will be available and global
in the script as well.

So in order to stay clear from interfering with the internals of the library, you need to actually
know about the `$base` variable and you need to avoid it in your code.

It's even worse when the library is updated. Especially if the library writer is not aware of all the script
using it then they can introduce a new function or a new variable that will start to collide with something
in one of the scripts using that module.


## Early Conclusion

While Perl libraries were useful, and they are still much better than copy-paste, their time is over.
So we'll learn how to convert them to something more modern.

## Prefix everything

One of the solutions to the problem of collision is to use prefixes. Prefix every function and every global
variable name in the library with some specific word unique to that library. For example a library
with functions related to math could be prefixed with `_math_` or `calc_` as in the example.

**calc_perfix_lib.pl**:

```perl
$calc_base = 10;

sub calc_add {
    calc_validate_parameters(@_);

    my $total = 0;
    $total += $_ for (@_);
    return $total;
}

sub calc_multiply {
}

sub calc_validate_parameters {
    die 'Not all of them are numbers'
        if  grep {/\D/} @_;
    return 1;
}

1;
```

This reduces the potential for collision in the scripts using this module, but the inconvenience of this solution
is that now we need to use these prefixes everywhere, including inside the library. That requires more typing
and code which is probably less readable.

Besides, Perl 5 has a perfectly nice solution for this using namespaces (usually also referred to as modules).
We are going to talk about those in the next episode.

