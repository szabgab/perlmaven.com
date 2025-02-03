---
title: "How to sort a hash of hashes by value?"
timestamp: 2014-09-11T16:30:01
tags:
  - hash
  - keys
  - values
  - sort
  - cmp
  - <=>
  - $a
  - $b
published: true
author: szabgab
---


Before attempting to sort a hash of hashes by values, one should make sure to be familiar with the
question: [How to sort a hash in Perl?](/how-to-sort-a-hash-in-perl)


## The problem

Given the following reference to a hash of hashes, how can we sort them based on the value of <b>Position</b>?

```
my $data = {
  'Gaur 3' => {
        'Max' => '85',
        'Type' => 'text',
        'Position' => '10',
        'IsAdditional' => 'Y',
        'Required' => 'Y',
        'Mandatory' => 'Y',
        'Min' => '40'
  },
  'Gaur 2' => {
        'Max' => '90',
        'Type' => 'text',
        'Position' => '11',
        'IsAdditional' => 'Y',
        'Required' => 'Y',
        'Mandatory' => 'Y',
        'Min' => '60'
  },
  'Gaur 1' => {
        'Max' => '80',
        'Type' => 'text',
        'Position' => '10',
        'IsAdditional' => 'Y',
        'Required' => 'Y',
        'Mandatory' => 'Y',
        'Min' => '40'
   },
};
```

Of course, we cannot really sort the hash, but we can sort the keys. As `$data` is a reference to a hash,
first we need to de-reference it by putting a `%` in front of it. calling `keys` on this 
construct will return the list of keys in a random order.

```perl
my @keys = keys %$data;
foreach my $k (@keys) {
    say $k;
}
```

Result might look like this, but it can be in a different order on other runs:

```
Gaur 1
Gaur 3
Gaur 2
```


`$a` and `$b` are the standard place-holders of `sort`. For
each comparison they will hold two keys from the list.
In order to compare the <b>Position</b> value of two elements we need to access them
using `$a` and `$b` and compare the numerical(!) values using the
spaceship-operator (`<=>`).

```perl
my @positioned = sort { $data->{$a}{Position} <=> $data->{$b}{Position} }  keys %$data;

foreach my $k (@positioned) {
    say $k;
}
```

The result is:

```
Gaur 3
Gaur 1
Gaur 2
```

This would be nice, but unfortunately this result is not going to be the same always.
After all the <b>Position</b> values of 'Gaur 1' and 'Gaur 3' are both the same number (10),
so the space-ship operator cannot really decide between the two.

## Secondary sorting

If we would like to make sure the result of sort is more predictable, we will need to
sort based on two (or even more) values.

For example we can sort the hash first by the <b>Position</b> value, and among the entries with the
same Position value we can sort by the value of the <b>Max</b> field.
In order to do this we will use the following expression:

```perl
my @maxed = sort {
    $data->{$a}{Position} <=> $data->{$b}{Position}
    or
    $data->{$a}{Max} <=> $data->{$b}{Max}
    }  keys %$data;

foreach my $k (@maxed) {
    say $k;
}
```

And the result is:

```
Gaur 1
Gaur 3
Gaur 2
```

Of course if, we encounter two entries where both the <b>Position</b> and the <b>Max</b> fields have the exact same value,
then even this sort won't provide the same results on every call.

## Comments

Hi, I have created several Hash
$PV_2{$JOB}=$PV_2;
$PV_3{$JOB}=$PV_3;
$PV_4{$JOB}=$PV_4;
$PV_5{$JOB}=$PV_5;
and I know the key name I would like to retrieve the data for in this case PV_5
$PV="\$PV_5";
$geoff=$PV{$JOB};
but how do I get this statement to work as $PV is not resolved to $PV_5

---
It seems $PV_2{$JOB}=$PV_2; that you have both a $PV_2 scalar and a %PV_2 hash here. That's not a good idea for start.
It is also unclear to me why do you have escaping on the $ sign in $PV="\$PV_5"; The key probably does not contain $, it is in the variable $PV_5, right?

This does not seem to be the whole code, could you share a bit more that also shows the "use strict" part and the declaration of the variables.
