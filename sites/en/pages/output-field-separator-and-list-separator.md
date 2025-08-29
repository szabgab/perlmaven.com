---
title: $, the output field separator, and $" the list separator of Perl
timestamp: 2014-02-13T09:30:01
tags:
  - $LIST_SEPARATOR
  - $"
  - $OUTPUT_FIELD_SEPARATOR
  - $OFS
  - $
published: true
author: szabgab
---


Perl has a number of "magic" variables. Some are really useful, some are there mostly for historical reasons.
This time we are going to look at two: `$,` also known as **output field separator**, and
`$"` also known as **list separator**.


Assuming this at the beginning of our file:

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

my @names = qw(Foo Bar Que);
```

## $, the Output field separator

When printing a list of values or an array, Perl automatically prints the content of `$,`,
which is `undef` by default, between every two values.

So `say 'A', 'B', 'C';` will print `ABC`

and `say @names;` will print `FooBarQue`

One can change `$,` to any string

```perl
$, = '--';
say 'A', 'B', 'C';  # A--B--C
say @names;         # Foo--Bar--Que
```

but it is really not advised! Especially because `$,` is global to
the whole process so if we change it in one location, it changes to the
rest of the code. Even in other modules. (Unless we localize it using
the `local</l> statement.)

Using `join` is much clearer and has the same result:

```perl
say join '--', 'A', 'B', 'C';
say join '--', @names;
```

In really serious cases, I'd probably create a function, rather than change `$,`:

```perl
sub mysay {
    say join '--', @_, 
}

mysay 'A', 'B', 'C';
mysay @names;
```

It is much more readable.

The way to remember the variable is that it "replaces commas in a print statement".

If using the [English](https://metacpan.org/pod/English) module, `$,` is also
called `$OUTPUT_FIELD_SEPARATOR` or  `$OFS`.

## $" the list separator

Similarly, when we embed an array in a double-quoted string, the expression will return
the values of the array separated by the content of `$"`, which by default is a single space.

`say "@names";` will print `Foo Bar Que`.

Here too we can change the content of `$"`:

```perl
$" = '-+-';
say "@names";     # Foo-+-Bar-+-Que
```

or we could use `join` instead:

```perl
say join '-+-', @names;     # Foo-+-Bar-+-Que
```

or create a function:

```perl
sub mysay {
    say join '-+-', @_, 
}

mysay @names;    # Foo-+-Bar-+-Que
```

When using the English module, the variable `$"` is also called `$LIST_SEPARATOR`.

But, let me repeat, I would not recommend changing it.

## Finding the violators using Perl::Critic

So if I don't recommend using it, how can I make sure neither my code, nor the code of my fellow co-workers
change this variable? 

[Perl::Critic](https://metacpan.org/pod/Perl::Critic) has a policy called
[Variables::ProhibitPunctuationVars](https://metacpan.org/pod/Perl::Critic::Policy::Variables::ProhibitPunctuationVars)
that will catch the use of these variables in your code. You can try to find them using
`perlcritic --single-policy Variables::ProhibitPunctuationVars script.pl` that will give you a report like this:
**Magic punctuation variable $, used at line 9, column 1.  See page 79 of PBP.  (Severity: 2)**

You could also set up an automated test using [Test::Perl::Critic](https://metacpan.org/pod/Test::Perl::Critic).

See how you could [improve your code](/how-to-improve-my-perl-program) using Perl::Critic [one policy at a time](/perl-critic-one-policy).

## Localizing $" and $,

While I still not recommend you to change the variables, but if you really have to, or you find a piece of code that does it and you
want to make sure the change does not have a global impact you can localize the change:


```perl
say "@names";           # Foo Bar Que
{
    local $" = '-+-';   # Foo-+-Bar-+-Que
    say "@names";
}
say "@names";           # Foo Bar Que
```


