---
title: "An extra space can ruin your day"
timestamp: 2016-02-18T22:30:01
tags:
  - B::Deparse
  - =!
published: true
author: szabgab
archive: true
---


The other day I got request for help finding out why a certain script prints lot of
[Use of uninitialized value](/use-of-uninitialized-value) warnings.

For the untrained eyes the warnings were really strange.


The original script that generated the warnings is this:

{% include file="examples/maze.pl" %}

It generates tons of this triplet:

```
Use of uninitialized value $_ in pattern match (m//) at maze.pl line 21.
Use of uninitialized value $1 in hash element at maze.pl line 22.
Use of uninitialized value within %full in concatenation (.) or string at maze.pl line 22.
```

That looks really strange, especially that `$_` is not even used in this script.
At least not intentionally. Can you spot the problem?

## Simplified example

{% include file="examples/maze_extract.pl" %}

This will generate the following 4 warnings:

```
Use of uninitialized value $_ in pattern match (m//) at maze_extract.pl line 6.
Use of uninitialized value $1 in print at b.pl line 7.
Use of uninitialized value $_ in pattern match (m//) at maze_extract.pl line 6.
Use of uninitialized value $1 in print at b.pl line 7.
```

Did this make it easier to spot the problem?

## B::Deparse

Let's see what does [B::Deparse](https://metacpan.org/pod/B::Deparse) think.

I ran `perl -MO=Deparse,-p maze_extract.pl and got the following output:

{% include file="examples/maze_extract_deparsed.pl" %}

This might help noticing that Perl first applies the `~` operator to `/(\d+)/`
and then uses `=` to assign the result to `$text`.

WHAT ??

## = ~

The problem is that the regex operator was not written correctly. It should be `=~`
without any spaces between the two characters, but because there was a space, Perl understood
that we wanted to use the `~`
the [Bitwise operator](https://metacpan.org/pod/distribution/perl/pod/perlop.pod#Bitwise-String-Operators)
on the **result** of `/(\d+)/` applied to the content of [$_](/the-default-variable-of-perl),
the default variable of Perl.

The thing that my be less well known is that if we have a regex expression such as
`/(\d+)/` which is not preceded by the `=~` regex operator, then it
is applied to the content of `$_`. This is a nice default when used properly,
but it can be surprising when it is used by mistake as in this case.

So we had the warning about `$_` being uninitialized because it was really
[undefined](/undef-and-defined-in-perl). Actually we were lucky that it
was undefined, otherwise we might get a match on some string that is totally
unrelated to our intention. It is usually much better to get a warning or an error,
than to get get an incorrect value without any notification.

Then the problem keeps growing. After the regex was executed, we apply the
`~` bitwise operator to its return value and then the `=`
will act as an assignment operator and thus the result of `~` is
assigned to the `$txt` variable replacing its original content.
Then the `if` checks if this value is [some true value](/boolean-values-in-perl).
It usually is, so we enter the block of the `if` statement where we'll get further
warnings.
`$1` is undefined because there was no match at all and thus we get a warning when we
are trying to use it and then in the original example this triggers a 3rd type of warning.

## The solution

The solution is to write `=~` without any space between the two characters.

## The danger of silence

Just to show a contrived example in which we set `$_` to some unrelated string:

{% include file="examples/maze_extract_silent.pl" %}

If we run this code, it will print "4242" and won't show any warnings.

If this happens to us we'll really scratch our head, especially because the assignment
to `$_` might happen at some code far away from our function, or might even
happen implicitly, without us ever mentioning `$_`.

In this case we might not even notice the problem, after all we don't get any warning,
until much later as we receive incorrect results.

## Conclusion

Space matters.
