---
title: "Comparing scalars in Perl"
timestamp: 2013-05-01T12:45:56
tags:
  - eq
  - ne
  - lt
  - gt
  - le
  - ge
  - "=="
  - "!="
  - "<"
  - ">"
  - "<="
  - ">="
types:
  - screencast
published: true
books:
  - beginner
author: szabgab
---


In the previous part of the [Perl tutorial](/perl-tutorial)
we introduced [scalars](/scalar-variables) and we saw how numbers
and strings are converted to each other on-the-fly. We even had
glimpse on a conditional <b>if</b> statement but we have not seen how
to compare two scalars. That's what this part is about.


{% youtube id="KXFn0rnBPrc" file="modern-perl-tutorial-part-03-comparing-scalar" %}

An alternative screencast [comparing values in Perl](/beginner-perl-maven-compare-values)

Given two variables $x and $y how can we compare them?
Are 1, 1.0 and 1.00 equal? What about "1.00" ?
What is bigger "foo" or "bar"?

## Two sets of comparison operators

Perl has two sets of comparison operators. As we saw with the
binary operators of addition (+), concatenation (.) and repetition (x),
here too, the operator is what defines how the operands behave and
how they are compared.

The two sets of operators are as follows:

{% include file="examples/operators.txt" %}

The operators on the left will compare the values as numbers while
the operators on the right (the middle column) will compare the
values based on the ASCII table or based on the current locale.

Let's see some examples:

```perl
use strict;
use warnings;
use 5.010;

if ( 12.0 == 12 ) {
  say "TRUE";
} else {
  say "FALSE";
}
```

In this simple case Perl will print TRUE as the `==` operator compares the two
numbers and Perl does not care if the number is written as an integer or as a
floating point number.

A more interesting situation will be comparing

```
"12.0" == 12
```

which is also TRUE as the `==` operator of Perl converts the string to a number.

{% include file="examples/operators_example.txt" %}

This might be surprising for some people at first but if you think about it, the
way Perl compares the two strings is character by character. So it compares "1" to "3"
and as they are different and "1" is before "3" in the ASCII table Perl decides at
this point that 12 as a string is smaller than 3 as a string.

You have to make sure you compare things as you really want them!

```
"foo"  == "bar" will be TRUE
```

It will also give you two warnings if(!) you enabled warnings by `use warnings`.
The reason for the warning is that you are using two strings as numbers in the numerical ==
comparison and that's what generates the warnings. As mentioned in the previous part
Perl will look at the left hand side of each string and convert them to the numbers it
sees there. As both strings start with a letter they will be both converted to 0.
0 == 0 so that's why we get true.

OTOH:

```
"foo"  eq "bar"  FALSE
```

So you have to make sure you compare values as you want them to be compared!

The same happens when you compare

```
"foo"  == "" will be TRUE
```

and

```
"foo"  eq "" will be FALSE
```


This table might be handy to see the results:

{% include file="examples/comparision.txt" %}

Finally an example where people can fall in a trap is when you get some input from the
user and after carefully chomping off the newline from the end you try to check if the
given string is empty.

{% include file="examples/incorrect_use_of_equal.pl" %}

If you run this script and type in "abc" you will get that it is TRUE,
as if Perl thought "abc" is the same as the empty string

## Comments

what if I want to Print value in between, example ,

cat /proc/partitions | tail -n+3 | grep sd. | perl -lane 'if ($F[2] > 900000000) { print "/dev/".$F[3] }' | sort === here it will print all above 900000000 blocks disks

but what signs will be there if I want to print blocks between value 900000000 and 4007018584 ?


