---
title: "Useless use of hash element in void context"
timestamp: 2018-04-08T08:30:01
tags:
  - warnings
  - B::Deparse
published: true
author: szabgab
archive: true
---


Among the many [warnings of Perl](/always-use-warnings) that might, or might not indicate
a bug, this certainly points to code that was written incorrectly.


If we run this script:

{% include file="examples/hash_with_or.pl" %}

We get: <b>Useless use of hash element in void context</b>

The same is true if we use HASH references:

{% include file="examples/hashref_with_or.pl" %}

The problem was probably created when the author of this code wanted to set
a [default value](/how-to-set-default-values-in-perl). That is
the author wanted to set `$r` to be equal to `$h{a}`, but if that key
did not exist, or if its value was [undef](/undef-and-defined-in-perl)
then she wanted to set `$r` to be `$h{b}`.

Unfortunately the snippet to [set default value](/how-to-set-default-values-in-perl)
uses `||` and not `or`.

The reason for that is that `||` is higher in the precedence table than `=</h> which
is higher than `or`. So the correct code would have been:

```
my $r = ($h{a} or $h{b});
```

or in a more idiomatic way:

```
my $r = $h{a} || $h{b};
```

Probably even better to use the defined-or operator:

```
my $r = $h{a} // $h{b};
```

that was introduced in [Perl 5.10](/what-is-new-in-perl-5.10--say-defined-or-state).

## B::Deparse

If you did not know the above and could not find an article explaining it, you could always
ask Perl to tell you what does it think about a piece of code. For this you can usually use
[B::Deparse](https://metacpan.org/pod/B::Deparse) with the `-p` flag
to add extra parentheses.

In our case this is what we get:

```
perl -MO=Deparse,-p examples/hash_with_or.pl

Useless use of hash element in void context at examples/hash_with_or.pl line 9.
use warnings;
use strict;
(my(%h) = ('a', 1, 'b', 2));
((my $r = $h{'a'}) or $h{'b'});
```

Here you can see that B::Deparse added parentheses around the assignment `(my $r = $h{'a'})`
which means that will be executed first and then there is a dangling extra code: `or $h{'b'}`
that has no impact on anything. That's why Perl warns you about `useless use`.

The correct way to write this would be to write this:

{% include file="examples/hash_with_or_fixed.pl" %}

## Comments

I have been bitten by this, as I tend to default to “or” because it is lower precedence, which often is desired, as in this case:

open FH, $file or die “Cannot open file $file”; 

If you use || instead of “or”, the double pipe resolves first, and so will return true for a non-empty file. But since “or” has a lower precedence than comma, if you use “or”, it will execute as expected.

Note that confusion between “or” and || can be avoided enforcing precedence with parentheses, by writing:

open ( FH, $file ) || die “Cannot open file $file”; 

making parentheses a good standard practice in my book.

I think a thorough discussion of this in the Beginner Perl Maven e-book would be an excellent addition (if it is not already there).


