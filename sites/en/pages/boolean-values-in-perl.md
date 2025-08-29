---
title: "Boolean values in Perl"
timestamp: 2012-11-15T11:45:56
tags:
  - undef
  - true
  - false
  - boolean
published: true
books:
  - beginner
author: szabgab
---


Perl does not have a special boolean type and yet,
in the documentation of Perl you can often see that a function returns a "Boolean" value.
Sometimes the documentation says the function returns true or returns false.

So what's the truth?



Perl does not have specific boolean type, but every scalar value - if checked using **if**
will be either true or false. So you can write

```perl
if ($x eq "foo") {
}
```

and you can also write

```perl
if ($x) {
}
```

the former will check if the content of the **$x** variable is the same as the "foo"
string while the latter will check if $x itself is true or not.

## What values are true and false in Perl?

It is quite easy. Let me quote the documentation:

<pre>
The number 0, the strings '0' and '', the empty list "()", and "undef"
are all false in a boolean context. All other values are true.
Negation of a true value by "!" or "not" returns a special false
value. When evaluated as a string it is treated as '', but as a number, it is treated as 0.

From perlsyn under "Truth and Falsehood".
</pre>

So the following scalar values are considered false:

* undef - the undefined value
* 0  the number 0, even if you write it as 000  or 0.0
* ''   the empty string.
* '0'  the string that contains a single 0 digit.

All other scalar values, including the following are true:

* 1 any non-0 number
* ' '   the string with a space in it
* '00'   two or more 0 characters in a string
* "0\n"  a 0 followed by a newline
* 'true'
* 'false'   yes, even the string 'false' evaluates to true.

I think this is because [Larry Wall](http://www.wall.org/~larry/),
creator of Perl, has a general positive world-view.
He probably thinks there are very few bad and false things in the world.
Most of the things are true.

## Comments

I know of no language that would not be made better with the inclusion of true and false constants as a literal part of the language. I suppose the Lisp family skips out on this since it already has them. Nice reminder of how things work in Perl. Now how about NULL? ;)

<hr>

The way that Perl defines 'false' to be any number of different values is very dangerous. Many Perl functions like defined() return undef, not zero, for 'false'. Attempting to use the return value as an array index then fails. I don't understand why Perl boolean functions would ever return undef instead of zero.

---

defined() returns 0 or 1, not undef.

Suppose you query a database, and the query errors. This is not the same as returning zero rows. A distinction between the two is very useful.

I can't think of a situation where you would want to use an undef as a numerical 0 array offset. But if you did you could simply write:

$my_array[$offest//0]

example:

my @my_array = (2,3,4);
my $offest = undef;
$my_array[$offest//0] = 1;
print "$_\n" for ( @my_array);

prints

1
3
4

---

In my version of perl defined returns an empty string or 1. Try this out:

perl -e 'use strict; use warnings; my ($a, $b)=(undef, 37); my ($c, $d)=(defined $a, defined $b); print(defined $_ ? "[$_]\n" : "undef\n") for ($a, $b, $c, $d)'
undef
[37]
[]
[1]


