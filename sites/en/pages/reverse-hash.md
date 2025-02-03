---
title: "Exchange values and keys of a hash - how to reverse a hash"
timestamp: 2019-12-16T07:30:01
tags:
  - reverse
  - keys
  - push
published: true
books:
  - beginner
author: szabgab
archive: true
---


How to exchange keys with values of a hash without losing any data even if there a are duplicate values in the original hash?


Given a hash

## Using reverse

If in our hash the `values` are unique, that is each value is different,
then we can just pass the hash to he `reverse` function and assign the result to another hash.
We will get a new hash in which the former values will be the key, and the former key will be values:

{% include file="examples/reverse_hash_with_unique_values.pl" %}

The output looks like this, though the actual order of the key-value pairs might change from execution to execution as internally there is no order among the keys.

```perl
$VAR1 = {
          '1112222' => 'Foo',
          '3334444' => 'Bar',
          '5556666' => 'Qux'
        };
```

## Using reverse with duplicate values

What if one or more of the keys have the same value as in the following example?

{% include file="examples/reverse_hash_with_duplicate_values.pl" %}

I ran the script twice and got two different results:

```
$  perl examples/reverse_hash_with_duplicate_values.pl
```

```perl
$VAR1 = {
          '1112222' => 'Foo',
          '3334444' => 'Bar'
        };
```

```perl
$VAR1 = {
          '1112222' => 'Qux',
          '3334444' => 'Bar'
        };
```

The reason is that the `keys` of a hash must be unique. As we reverse the hash we
have two keys (former values) that are identical. As Perl works through all the key-value pairs the last value of each key wins. Which one is the last can change from execution-to-execution.

So not only do we lose data, our code also got a bit of a randomality in it. Likely not what you want.

## Reversing hash with duplicate values manually - special consideration

There can be many solutions to the above depending what your needs are. For example you could add some code that for each duplicate (former) value will select which (former) key to use.

For example: use the smallest (former) key using string-wise comparison

In this case we cannot use the `reverse` function any more. Instead we need to iterate over all the keys of the original hash and make the assignment carefully after the comparison.

{% include file="examples/reverse_hash_smallest_key_wins.pl" %}

The result of the above code will always be this: (well, except of the order of display)

```perl
$VAR1 = {
          '3334444' => 'Bar',
          '1112222' => 'Foo'
        };
```

## Reversing hash with duplicate values manually - keep all the values

Another way of keeping all the former keys is to allow for multiple values for each key.

{% include file="examples/reverse_hash_multiple_values.pl" %}

As we iterate over each (former) key, we create a reference to an array for each (former) value by writing `@{ $owner_of{$value} }` and then we `push` the current `$key` onto it.
As Perl has [autovivification](/autovivification) we don't need special code to create these references, at the first call of `push` for each `$value` the reference will be created.


```perl
$VAR1 = {
          '3334444' => [
                         'Bar'
                       ],
          '1112222' => [
                         'Qux',
                         'Foo'
                       ]
        };
```

But remember the order of values inside those arrays can be different from execution to execution so n another run you might get this:

```perl
$VAR1 = {
          '3334444' => [
                         'Bar'
                       ],
          '1112222' => [
                         'Foo',
                         'Qux'
                       ]
        };
```

To access individual values you'll have to use the 2-dimensional notation:

```perl
print "$owner_of{'1112222'}[1]\n";
```

But you cannot be sure which former key will occupy that position.

You can also iterate over all the former keys of a given value using this snippet:

```perl
for my $val (@{ $owner_of{"1112222"} }) {
    print "$val\n";
}
```

To remedy the problem of unknown ordering of the values in those small arrays you could sort the after the reversing was done. For example like this:

{% include file="examples/reverse_hash_multiple_values_sorted.pl" %}

## Caveat

The above solutions do not take in account cases when the value was [undef](/undef).
You'll have to decide what should happen in those cases.

