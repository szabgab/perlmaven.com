---
title: "Number Guessing game"
timestamp: 2013-04-02T10:45:17
tags:
  - rand
  - random
  - int
  - integer
published: true
books:
  - beginner
author: szabgab
---


In this episode of the [Perl tutorial](/perl-tutorial) we are going to
start building a small, but fun game.
This was the first game I wrote when I was in high-school, even before Perl 1.0 was released.


In order to write this game we need to learn about two simple, and unrelated topics:
<b>How to generate random numbers in Perl</b> and
<b>How to get the integer part of a number</b>.

## Integer part of a fractional number

The `int()` function returns the integer part of its parameter:

```perl
use strict;
use warnings;
use 5.010;

my $x = int 3.14;
say $x;          # will print 3

my $z = int 3;
say $z;          # will also print 3.

                 # Even this will print 3.
my $w = int 3.99999;
say $w;

say int -3.14;   # will print -3
```

## Random numbers

A call to the `rand($n)` function of Perl will return a random fractional number
between 0 and $n. It can be 0 but not $n.

If `$n = 42` then a call to the `rand($n)` will return a random number between 0 and 42.
It can be 0 but not 42. For example it can be 11.264624821095826 .

If we don't give any value then `rand()` will default to give values between 0 and 1 including 0
but excluding 1.

Combining `rand` with `int` allows us to generate random whole numbers.

```perl
use strict;
use warnings;
use 5.010;

my $z = int rand 6;
say $z;
```

Will return a number between 0 and 6. It can be 0 but cannot be 6. So it can be
any of the following numbers: 0,1,2,3,4,5.

If we now add 1 to the result then we get any of the numbers 1,2,3,4,5,6 which is the same as throwing a dice.

## Exercise: Number Guessing game

This is the beginning of a game we are going to write. A small but fun game.

Write a script in which using the `rand()` function the computer "thinks" about
a whole number between 1 and 200. The user has to guess the number.

After the user types in his guess the computer tells if this was
bigger or smaller than the number it generated.

At this point there is <b>no</b> need to allow the user to guess several times.
We will get there in a later episode. Of course I won't stop
you from reading about the [while loop](/while-loop)
in Perl, you can read that and let the user guess several times.





