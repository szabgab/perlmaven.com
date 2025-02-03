---
title: "trim - removing leading and trailing white spaces with Perl"
timestamp: 2013-04-12T10:01:01
tags:
  - trim
  - ltrim
  - rtrim
published: true
books:
  - beginner
author: szabgab
---


In some other languages there are functions called <b>ltrim</b> and <b>rtrim</b> to remove
spaces and tabs from the beginning and from the end of a string respectively. Sometimes
they even have a function called <b>trim</b> to remove white-spaces from both ends of a string.

There are no such functions in Perl (though I am sure there are plenty of CPAN modules implementing
these functions) as a simple substitution regex can solve this.

Actually it is so simple that it is one of the great subjects of [bike-shedding](https://en.wikipedia.org/wiki/Parkinson%27s_law_of_triviality)


## left trim

<b>ltrim</b>  or <b>lstrip</b> removes white spaces from the left side of a string:

```perl
$str =~ s/^\s+//;
```

From the beginning of the string `^` take 1 or more white spaces (`\s+`), and replace them with an empty string.


## right trim

<b>rtrim</b> or <b>rstrip</b> removes white spaces from the right side of a string:

```perl
$str =~ s/\s+$//;
```

Take 1 or more white spaces (`\s+`) till the end of the string (`$`), and replace them with an empty string.

## trim both ends

<b>trim</b> remove white space from both ends of a string:

```perl
$str =~ s/^\s+|\s+$//g;
```

The above two regexes were united with an an alternation mark `|` and we added a `/g` at the end to
execute the substitution <b>globally</b> (repeated times).

## Hiding in function

If you really don't want to see those constructs in your code you can add these functions to your code:

```perl
sub ltrim { my $s = shift; $s =~ s/^\s+//;       return $s };
sub rtrim { my $s = shift; $s =~ s/\s+$//;       return $s };
sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };
```

and use them like this:

```perl
my $z = " abc ";
printf "<%s>\n", trim($z);   # <abc>
printf "<%s>\n", ltrim($z);  # <abc >
printf "<%s>\n", rtrim($z);  # < abc>
```


## String::Util

If you really, really don't want to copy that, you can alway install a module.

For example [String::Util](https://metacpan.org/pod/String::Util) provides
a function called `trim` that you can use like this:

```perl
use String::Util qw(trim);

my $z = " abc ";
printf "<%s>\n", trim( $z );              # <abc>
printf "<%s>\n", trim( $z, right => 0 );  # <abc >
printf "<%s>\n", trim( $z, left  => 0 );   # < abc>
```

By default it trims on both sides and you have to turn off trimming.
I think, having your own `ltrim` and `rtrim` will be clearer.

## Text::Trim

Another module, one that provides all the 3 function is [Text::Trim](https://metacpan.org/pod/Text::Trim),
but it take the Perl-ish writing a step further, and maybe to slightly dangerous places.


If you call it and use the return value in a print statement or assign it to a variable,
it will return the trimmed version of the string and will keep the original intact.

```perl
use Text::Trim qw(trim);

my $z = " abc ";
printf "<%s>\n", trim($z);  # <abc>
printf "<%s>\n", $z;       # < abc >
```

On the other hand, if you call it in VOID context, that is when you don't use
the return value at all, the trim function will change its parameter, in a way
similar to the behavior of [chomp](/chomp).

```perl
use Text::Trim qw(trim);

my $z = " abc ";
trim $z;
printf "<%s>\n", $z;       # <abc>
```

## Comments

Suppose I have a row of:
A, 1,2,3,4
how can i get rid of A and create new array with only numeric values?


Is that an array? A string? Learn about regexes Learn about CSV.

my $str = 'A, 1,2,3,4';
my @digits = $str =~ /\d/g;


