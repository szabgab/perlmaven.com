---
title: "The easiest way to find the highest hash value without looping through all of them (max)"
timestamp: 2016-01-29T14:01:01
tags:
  - sort
  - max
  - List::Util
  - List::UtilsBy
  - max_by
published: true
author: szabgab
archive: true
---


Given a hash 

```perl
my %height = (
    foo => 170,
    bar => 181,
    moo => 175,
);
```

How can I find out the highest value without looping them over using `for`, `foreach`, or `each`?


## Loop

In order to find the highest values some piece of code must go over all the values and compare them, but you don't have to do it
yourself. You don't have to write a `for loop` yourself, but to be clear, each one of the following solutions will go over
all the hash. You can't avoid that because Perl, as other languages, don't maintain a "highest value".

## max

The [List::Util](https://metacpan.org/pod/List::Util) module has a function called `max` that will return
the maximum value of a given list. The `values` function of perl will return all the values of a hash, in our case, it will
return the numbers in the hash.

So this code, will return and then print the highest value.

```perl
use List::Util qw(max);
my $highest = max values %height;

print "$highest\n";
```


## Getting the key of the highest value

What if you need to return the key of the highest value? In our case, you'd expect **bar** to be returned.
In that case we cannot use the `max` function of List::Util, because that just looks at the values given to
so we have two choices.

Write our manual solution of use the `max_by` function of [List::UtilsBy](https://metacpan.org/pod/List::UtilsBy).

## max_by of List::UtilsBy

```perl
use List::UtilsBy qw(max_by);

my $highest = max_by { $height{$_} } keys %height;

print "$highest\n";
print "$height{ $highest }\n";
```

Alternatively, as poined out by jameswmoth, you could use the `reduce` function that comes with
[List::Util](https://metacpan.org/pod/List::Util):

```perl
use List::Util qw(reduce);

my $highest = List::Util::reduce { $height{$b} > $height{$a} ? $b : $a } keys %height;

print "$highest\n";
print "$height{ $highest }\n";
```

The built-in `keys` function of perl returns the list of keys from the given hash.
The `max_by` function allows us to define an expression using `$_` as the place-holder for the "current value"
that will generate the "values to be compared" from the "values to be ordered".
In our case the "values to be ordered" are the keys of the hash (the names),
while the "values to be compared" are the numbers (the values of the hash).

## Manually using sort

In you don't want to use that module, you can always sort the keys using
[spaceship operator](/sorting-arrays-in-perl) (`&lt;=&gt;`) and then fetch the value of the
highest index using `-1` as the index. But how?

```perl
my @heights = sort { $height{$a} <=> $height{$b} } keys %height;

my $highest = $heights[-1];

print "$highest\n";
print "$height{ $highest }\n";
```

Just as in the previous solution we fetch the keys of the hash - we need to sort them based on the corresponding values.
Then we use the `sort` function of perl that allows us to designate a "sort function" using `$a` and `$b`
as place-holders for the "current two values". In this sort function, instead of comparing the the two values directly,
we use them as the keys of the hash, fetch the respective values from the hash and compare those using the spaceship operator.

Finally we use the `-1` index that will fetch the last element of the already sorted array. That holds the key of the highest value.

## Manually

Finally, if you really like to write a lot of code, you can implement your own max function specialized for hashes:

```perl
sub max {
    my (%data) = @_;

    my $max;
    while (my ($key, $value) = each %data) {
        if (not defined $max) {
            $max = $key;
            next;
        }
        if ($data{$max} < $value) {
            $max = $key;
        }
    }
    return $max;
}

my $highest = max(%height);

print "$highest\n";
print "$height{ $highest }\n";
```

Here we iterate over the hash using the `each` function that on every iteration
will return key-value pair from the hash.

`$max` starts out as `undef` and thus if it is still `not defined` we can just assign the
`$key` to it and go to the `next` iteration.

Otherwise, if the value corresponding to the current `$max` key is
smaller than the `$value` of the current `$key`
then we set the new `$max` to be the current `$key`.

Finally, once we exhausted the whole hash, we can `return $max`.

## Comments

my $highest=(sort {$b <=> $a} keys %height)[0]; # Give it to me in just one line!!

