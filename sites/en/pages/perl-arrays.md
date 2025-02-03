---
title: "Perl Arrays"
timestamp: 2013-03-23T20:45:02
description: "perl array denoted with @ - creating, checking size, iterating over the elements, accessing elements"
tags:
  - @
  - array
  - arrays
  - length
  - size
  - foreach
  - Data::Dumper
  - scalar
  - push
  - pop
  - shift
  - $#
published: true
books:
  - beginner
author: szabgab
---


In this episode of the [Perl Tutorial](/perl-tutorial) we are going to learn about <b>arrays in Perl</b>.
This is an overview of how arrays work in Perl. We'll see more detailed explanations later.

Variable names of arrays in Perl start with the at mark: `@`.

Due to our insistence on using `strict` you have to declare these variables using the `my` keyword
before the first usage.


Remember, all the examples below assume your file starts with

```perl
use strict;
use warnings;
use 5.010;
```

Declare an array:

```perl
my @names;
```

Declare and assign values:

```perl
my @names = ("Foo", "Bar", "Baz");
```


## Debugging of an array

```perl
use Data::Dumper qw(Dumper);

my @names = ("Foo", "Bar", "Baz");
say Dumper \@names;
```

The output is:

```
$VAR1 = [
        'Foo',
        'Bar',
        'Baz'
      ];
```

## foreach loop and perl arrays

```perl
my @names = ("Foo", "Bar", "Baz");
foreach my $n (@names) {
  say $n;
}
```

will print:

```
Foo
Bar
Baz
```

## Accessing an element of an array

```perl
my @names = ("Foo", "Bar", "Baz");
say $names[0];
```

Note, when accessing a single element of an array the leading sigil changes from `@` to `$`.
This might cause confusion to some people, but if you think about it, it is quite obvious why.

`@` marks plural and `$` marks singular. When accessing a single element
of an array it behaves just as a regular scalar variable.

## Indexing array

The indexes of an array start from 0. The largest index is always in the variable called
`$#name_of_the_array`. So

```perl
my @names = ("Foo", "Bar", "Baz");
say $#names;
```

Will print 2 because the indexes are 0,1 and 2.

## Length or size of an array

In Perl there is no special function to fetch the size of an array, but there
are several ways to obtain that value. For one, the size of the array is one more
than the largest index. In the above case `$#names+1` is the <b>size</b> or
<b>length</b> of the array.

In addition the `scalar` function can be used to to obtain the size of an array:

```perl
my @names = ("Foo", "Bar", "Baz");
say scalar @names;
```

Will print 3.

The scalar function is sort of a casting function that - among other things - converts an
array to a scalar. Due to an arbitrary, but clever decision this conversion yields the size
of the array.

## Loop on the indexes of an array

There are cases when looping over the values of an array is not enough.
We might need both the value and the index of that value.
In that case we need to loop over the indexes, and obtain the values using the
indexes:

```perl
my @names = ("Foo", "Bar", "Baz");
foreach my $i (0 .. $#names) {
  say "$i - $names[$i]";
}
```

prints:

```
0 - Foo
1 - Bar
2 - Baz
```

## Push on Perl array

`push` appends a new value to the end of the array, extending it:

```perl
my @names = ("Foo", "Bar", "Baz");
push @names, 'Moo';

say Dumper \@names;
```

The result is:

```
$VAR1 = [
        'Foo',
        'Bar',
        'Baz',
        'Moo'
      ];
```


## Pop from Perl array

`pop` fetches the last element from the array:

```perl
my @names = ("Foo", "Bar", "Baz");
my $last_value = pop @names;
say "Last: $last_value";
say Dumper \@names;
```

The result is:

```
Last: Baz
$VAR1 = [
        'Foo',
        'Bar',
      ];
```

## shift the Perl array

`shift` will return the left most element
of an array and move all the other elements to the left.

```perl
my @names = ("Foo", "Bar", "Baz");

my $first_value = shift @names;
say "First: $first_value";
say Dumper \@names;
```

The result is:

```
First: Foo
$VAR1 = [
        'Bar',
        'Baz',
      ];
```

## Comments

Great arrays tutorial, but i still feel lack of unshift operation- i use it to reverse an array, like while debugging, to access latest caller($i) element as first of @stack array

my @stack;
for ($i=0;;$i++) {
my ($pack, $fn, $ln, $subr) = caller($i);
last unless ($pack);
unshift (@stack,[$pack, $fn, $ln, $subr]);
}


