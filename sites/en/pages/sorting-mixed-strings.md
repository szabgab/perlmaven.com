---
title: "Sorting mixed strings"
timestamp: 2014-04-09T10:45:56
tags:
  - sort
  - $a
  - $b
  - cmp
  - <=>
  - substr
published: true
books:
  - beginner
author: szabgab
---


[Sorting an array](/sorting-arrays-in-perl) of strings or numbers is easy using the `sort` function,
but what if the values we would like to sort are strings, but we would like to sort based on some number
which is part of the string?

For example what if we have an array containing values such as `foo_11 bar_2 moo_3`. How can we sort this
based on the numbers?


Simply calling `sort` will sort the values as string.
We need to extract the numerical value

```perl
use strict;
use warnings;
use 5.010;

my @x = qw(foo_11 bar_2 moo_3);
say join " ", sort @x;
```

```
bar_2 foo_11 moo_3
```

## Extract numbers using substr

In order to compare the strings using the numbers in the string we need to extract those numbers.
Based on the example above we can assume that the strings consist of **4 characters and then the number**.
In that case we can use [substr](/string-functions-length-lc-uc-index-substr) to extract the numbers:

```perl
use strict;
use warnings;
use 5.010;

my @x = qw(foo_11 bar_2 moo_3);

my @y = sort { substr($a, 4) <=> substr($b, 4)  } @x;

say join " ", @y;
```

The result is correct:

```
bar_2 moo_3 foo_11
```


What if the strings can have any number of characters before and after the number? We might need to use

## Use regular expression to extract numbers

For example what if the strings look like these:

```perl
my @x = qw(foo_11 bar_2_bar text_3);
```

If we run the previous solution, we'll get lots of warnings like this: `Argument "2_bar" isn't numeric in numeric comparison (<=>)`

We can use a regex to extract part of the string, but for this we need to create a LIST-context. Hence in the following expression we had to
put the `($number)` in parentheses.

```perl
use strict;
use warnings;
use 5.010;

my $str = 'bar_2_bar';
my ($number) = $str =~ /(\d+)/;
say $number;
```

printing `2`.

Unfortunately the `<=>`, the spaceship operator will create scalar context on both of its sides.

So how can we extract the value in scalar context?
We can do that using [array slices](/perl-split) on-the-fly:

```perl
my ($number) = $str =~ /(\d+)/;

my $number = ($str =~ /(\d+)/)[0];
```

Putting it all together we'll have:

```perl
use strict;
use warnings;
use 5.010;

my @x = qw(foo_11 bar_2_bar text_3);
say join " ", sort @x;

my @y = sort { ($a =~ /(\d+)/)[0] <=> ($b =~ /(\d+)/)[0] } @x;

say join " ", @y;
```

Resulting in

```
bar_2_bar text_3 foo_11
```

## Missing numbers

As [Octavian Rasnita](http://www.linkedin.com/in/octavianrasnita) pointed out,
if there is no number in one of the strings, we'll get a bunch of 
`Use of uninitialized value in numeric comparison` warnings. We can decide that when there
is no number in a string, we use 0 instead:

```perl
my @y = sort { (($a =~ /(\d+)/)[0] || 0) <=> (($b =~ /(\d+)/)[0] || 0) } @x;
```


## Speed

He also pointed out that the Regex engine is "slow" and thus we can improve the
speed of the expression by using the [Schwartzian transform](/how-to-sort-faster-in-perl).
He pointed out that if the array has at least 5 elements, using the Schwartzian transform is faster. If it has 20 elements is twice as fast as the simple sort.

The solution he gave looks like this:

```perl
my @y = map { $_->[1] }
        sort { $a->[0] <=> $b->[0] }
        map { [ ($_ =~ /(\d+)/)[0] || 0, $_ ] } @x;
```

In general I am against such "premature optimization".
Before applying any such optimization I'd first recommend to finish the application,
and **profile** the code using [Devel::NYTProf](https://metacpan.org/pod/Devel::NYTProf). That will show if this specific
code has any impact on the overall performance of the application. If not, then I'd leave the slower, but more readable one.

In this case however I am not sure if the original version (especially after setting 0 as a default) is more
readable that the one using the Schwartzian transform. That's because the expression to get the value we can use
in the comparison is itself complex. In the original version we have two copies of the expression. In the Schwartzian transform
we only have one copy.

Maybe this version, where we move the complex expression in a subroutine, is even more readable:

```perl
my @y = sort { getnum($a) <=> getnum($b) } @x;

sub getnum {
    my $v = shift;
   return( ($v =~ /(\d+)/)[0] || 0);
}
```


## Hiding the sort in a sub

Another solution Octavian sent to me was using a separate subroutine to hide the implementation details of the sort:

```perl
my @y = sort by_number @x;


sub by_number {
    my ( $anum ) = $a =~ /(\d+)/;
    my ( $bnum ) = $b =~ /(\d+)/;
    ( $anum || 0 ) <=> ( $bnum || 0 );
}
```

The advantage of this is that you can use the same sort in many different places,
while implementing it only once and if the name of the subroutine explains the sort,
then most people won't even need to look at the implementation.
A common trait of subroutines.

## Comments

In the last part, "Hiding the sort in a sub", the by_number subroutine does not receive any parameters. Is that because $a and $b are specifically reserved by Perl for the sort function?

yes, and they are global.


