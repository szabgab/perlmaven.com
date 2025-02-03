---
title: "Splice to slice and dice arrays in Perl"
timestamp: 2013-02-08T00:05:56
tags:
  - splice
  - array
published: true
books:
  - advanced
author: szabgab
---


After learning about [pop, push, shift, and unshift](/manipulating-perl-arrays),
students sometimes ask me how to remove an element from the middle of an array.

I usually don't have time to explain it. There are other things to teach
them, that seem to be more important than `splice()` in the limited
time we have, but usually I at least point them in the right direction.

This time it is much easier as you, the reader, can decide if you'd like to
invest the extra time.


## How to remove an element from the middle of an array in Perl?

```perl
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
splice @dwarfs, 3, 2;
print "@dwarfs";    # Doc Grumpy Happy Dopey Bashful
```

As you can see the 4th and 5th elements of the array were removed.
That's because the second parameter of <b>splice</b> is the offset
of the first element to be removed, and the third parameter is the
number of elements to be removed.

## How to insert an element in the middle of an array in Perl?

```perl
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
splice @dwarfs, 3, 0, 'SnowWhite';
print "@dwarfs";
# Doc Grumpy Happy SnowWhite Sleepy Sneezy Dopey Bashful
```

In this case we used `splice` to insert an element.
Normally the second parameter (the offset) defines where
to start the removal of elements, but in this case the
third parameter - the number of elements - was 0 so `splice`
has not removed any elements. Instead, the offset is used as the
position to insert something new:
the value passed as the 4th parameter to `splice`.

That's how SnowWhite ended up among the seven dwarfs.

## How to insert a list of values in an array in Perl?

Inserting one element is actually just a special case of inserting several
elements.

```perl
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
splice @dwarfs, 3, 0, 'SnowWhite', 'Humbert';
print "@dwarfs";

# Doc Grumpy Happy SnowWhite Humbert Sleepy Sneezy Dopey Bashful
```

In this case after the 3rd parameter we have several values (2 in this case).
They get all inserted in the array.

## How to insert an array in the middle of another array in Perl?

The same would have happen if we passed an array as the 4th parameter:

```perl
my @others = qw(SnowWhite Humbert);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
splice @dwarfs, 3, 0, @others;
print "@dwarfs";
```


## Replace part of an array with some other values

You can also add and remove elements in a single command:

```perl
my @others = qw(SnowWhite Humbert);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
splice @dwarfs, 2, 4, @others;
print "@dwarfs\n";

# Doc Grumpy SnowWhite Humbert Bashful
```

In this case we removed four of the dwarfs and replaced them by two
full-sized people: SnowWhite and Humbert the Huntsman.

## splice

Splice is the ultimate function to change arrays in Perl.
You can remove any section of the array and replace it with any other list of values.
The number of elements removed and added can be different, and either of those can be 0 as well.

The general syntax the function has the following parameters,
though all the parts (well, except of the array itself) are optional:

```perl
splice ARRAY, OFFSET, LENGTH, LIST
```

The OFFSET and LENGTH define the section in the ARRAY that will be removed.
They are both integers. The LIST is a list of values that will be inserted
in place of the section that was removed. If the LIST is not provided,
or empty, then splice will only remove items but not insert any.

## Return values

In <b>LIST context</b> splice returns the elements removed from the array.

```perl
my @others = qw(SnowWhite Humbert);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
my @who = splice @dwarfs, 3, 2, @others;
print "@who\n";

# Sleepy Sneezy
```

In <b>SCALAR context</b>, it returns the last element removed, or undef
if no elements were removed.

```perl
my @others = qw(SnowWhite Humbert);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
my $who = splice @dwarfs, 3, 2, @others;
print "$who\n";

# Sneezy
```

## Negative parameters

Both the offset and the length can be negative numbers. In each case it means "count from the end of the array".

```perl
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
my @who = splice @dwarfs, 3, -1;
print "@who";

# Sleepy Sneezy Dopey
```

This means, leave 3 intact and then remove (and return) all the elements till 1 before the end.

```perl
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
my @who = splice @dwarfs, -3, 1;
print "@who";

# Sneezy
```

This means: "Count 3 from the end and remove (and return) 1 element starting from there.

## Conclusion

Hopefully some of this will help you better understand how `splice` operates on Perl arrays.


## Comments

do you know how to used splice in csv file. i try to delete certain array in csv, but i can't save in that csv file.

Use Text::CSV for that. See examples here:  https://perlmaven.com/search/Text%3A%3ACSV

<hr>

This may be kind of esoteric, but I noticed something interesting about using SPLICE in a foreach loop where you are trying to remove identical elements that are back to back. You'll remove the first one but the adjacent one will not be removed since the adjacent element occupies the current array index but the foreach loop moves to the next index.

So, you need to do something like this to fix the problem:


use strict;
use List::MoreUtils qw(first_index);

my $match_string="def";
my $matched_index;

my @names=("abc","def","def","hij","klm");

my $array_index=0;
my $max_index=$#names;

while ($array_index<=$max_index) {
  if ($names[$array_index] eq $match_string) {
      print "Matched: " . $names[$array_index] . "\n";
      $matched_index=first_index {$_ eq $match_string} @names;
      print "At index: " . $matched_index . "\n";
      splice @names,$matched_index,1;
      $max_index=$#names;
      print "max index now: " . $max_index . "\n";
  }
  else {
    $array_index++;
  }
}


foreach my $name (@names) {
  print $name . "\n";
}


