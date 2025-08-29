---
title: "Perl 4 libraries"
timestamp: 2017-01-03T07:00:11
tags:
  - require
books:
  - advanced
types:
  - screencast
published: true
author: szabgab
---


We are going to talk about Perl libraries and modules.

This episode explains how Perl libraries work. Something from the age of Perl 4.


<slidecast file="advanced-perl/libraries-and-modules/perl4-libraries" youtube="ehcarfOHgEg" />

## Lack of code reuse

As you write more and more Perl, you will have more and more scripts and in some scripts you
will have the same functions doing the same thing. You got there by copying the function that you wrote for
one script, but needed in the other. If you keep going in that direction you'll have lots of code, and a large part
of that code-base will be snippets, and whole functions copied from one place to another.

The main problem is that if you need to make a change in a function, either because of some new requirement
or because you found a bug, you'll have to go through all of your scripts and locate the copies of that function,
and fix the issue in those places too. It will be very unpleasant, and soon you'll miss some of the
scripts and the same bug you fixed in one script will appear a few weeks later in another script.

The problem is the lack of code-reuse.

In Perl 4 the solution to this was to create libraries.

First we are going to see how to use libraries. Not because it is a recommended way of working, but because
there are still many places out there that use it and it would be important for you to understand what's
going on, and maybe even to change the code to use more modern techniques.


In this example we have two files. Both have the .pl extension.

**library.pl** is the file that contains the common functions and variables.

```perl
$base = 10;

sub add {
    validate_parameters(@_);

    my $total = 0;
    $total += $_ for (@_);
    return $total;
}

sub multiply {
}

sub validate_parameters {
    die 'Not all of them are numbers'
        if  grep {/\D/} @_;
    return 1;
}

1;
```

**perl4_app.pl** is the "application", or the "script" that we will run. It uses the functions from the above file.

```perl
#!/usr/bin/perl

require "examples/modules/library.pl";

print add(19, 23);
print "\n";
print "$base\n";
```


The script (**perl4_app.pl**) starts with the [sh-bang](/hashbang) line. It does not have `use strict;` nor does it
have `use warnings;`. Remember, this is Perl 4-style coding. These [safety nets](/installing-perl-and-getting-started)
were not available till later on in Perl 5.

Then we load the library with the `require` statement providing full (or relative) path to the library file.

Then we can use the functions that were declared in the library and we could even access the variables that were created in the library.

Creating the library was easy. It was just a regular Perl script with the .pl extension that used to stand for "perl library".
In that file we don't have `use strict;` or `use warnings;` either.

We don't even have the sh-bang in this file, because this is not a file you'd run directly.

We have values assigned to global variables (not declared with `my`) and subroutines defined. The `multiply` function
has been defined but without any content just to remind us that there are other functions besides the `add` function.
There is also the `validate_parameters` which is only used by the `add` function and is probably should never be called
by a user of this library. This is an internal function.

The file ends with `1;` which is just a [true](/boolean-values-in-perl) value. Every Perl library and module needs
to end with a true value.

If you forget to add the `1;` at the end of such a file and you run the `perl4_app.pl` script, you'll get an error that
looks like this:

```
library.pl did not return a true value
```


