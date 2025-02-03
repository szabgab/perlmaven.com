---
title: "How to eliminate a value in the middle of an array in Perl?"
timestamp: 2013-05-09T10:01:01
tags:
  - undef
  - splice
  - array
  - delete
published: true
books:
  - beginner
author: szabgab
---


In response to an earlier article about [undef](/undef-and-defined-in-perl) one of the readers asked me:

How do you eliminate a value in the middle of an array in Perl?

I am not sure if `undef` and eliminating values from an array are related, though I guess, if we see having a value of `undef`
as being "empty", then I can understand the connection. In general though, setting something to be `undef` and deleting something is not the same.


Let's see first how we can set an element of an array to be `undef` and then how we can delete an element from an array.

We start with the following code:

```perl
use Data::Dumper qw(Dumper);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
print Dumper \@dwarfs;
```

When printed using `Data::Dumper` we get the following output:

```
$VAR1 = [
          'Doc',
          'Grumpy',
          'Happy',
          'Sleepy',
          'Sneezy',
          'Dopey',
          'Bashful'
        ];
```

## Set an element to undef

Using the return value of the `undef()` function:

```perl
use Data::Dumper qw(Dumper);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);

$dwarfs[3] = undef;

print Dumper \@dwarfs;
```

This code will set element 3 (the 4th element of the array) to `undef`, but will <b>NOT</b> change the size of
the array:

```
$VAR1 = [
          'Doc',
          'Grumpy',
          'Happy',
          undef,
          'Sneezy',
          'Dopey',
          'Bashful'
        ];
```

Using the `undef()` function directly on an element of an array yields similar results:

```perl
use Data::Dumper qw(Dumper);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);

undef $dwarfs[3];

print Dumper \@dwarfs;
```

So for our purposes `$dwarfs[3] = undef;` and `undef $dwarfs[3];` do the same thing.
They both can set a value to be `undef`.

## Removing an element from the array using splice

The `splice` function can totally eliminate the value from the array:

```perl
use Data::Dumper qw(Dumper);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);

splice @dwarfs, 3, 1;

print Dumper \@dwarfs;
```

```
$VAR1 = [
          'Doc',
          'Grumpy',
          'Happy',
          'Sneezy',
          'Dopey',
          'Bashful'
        ];
```

As you can see, in this case the array became one element shorter as we have <b>removed one of the elements</b> from the middle of the array.

This is how you can <b>delete an element from an array</b>.

For further details check [how to splice arrays in Perl](/splice-to-slice-and-dice-arrays-in-perl).

## Remove duplicate elements

How to [remove duplicate elements from an array](/unique-values-in-an-array-in-perl).


