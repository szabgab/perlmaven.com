---
title: "each - iterate over Perl hash elements pair-by-pair"
timestamp: 2018-01-02T11:30:01
tags:
  - each
published: true
author: szabgab
archive: true
---


In most of the cases when we iterate over the [elements of a hash](/perl-hashes)
we use the [keys](/search/keys) function. At least that's my preferred method.

However, sometimes, epecially when the hash is big, we migh prefer to use the `each` function.


The use of `each` looks like this:

{% include file="examples/each.pl" %}

On each iteration it fetches one of the key-value pairs and in this example we assign them to `$k`
and `$v` respectively.

There result is

```
abc  => 23
def  => 19
```

The actual order among the pairs is unpredictable.
If you run the above code several times you will see the order changes.

## Each without a loop

While the most common use of `each` is in a loop, we can also use it stand-alone.
In this example we call `each` outside of a loop:

{% include file="examples/loopless_each.pl" %}

Looking at the output you can see that the first two calls were successful and we got the two pairs of data.
The 3rd call to `each`, however, comes after the content of the hash was exhausted and thus the 3rd call
returns [undef](/undef-and-defined-in-perl) to both key and value.

The fourth call to `each` starts iterating over the pairs again.

```
One
abc  => 23
Two
def  => 19
Three
Use of uninitialized value $k3 in concatenation (.) or string at examples/loopless_each.pl line 17.
Use of uninitialized value $v3 in concatenation (.) or string at examples/loopless_each.pl line 17.
  =>
Four
abc  => 23
```

## Use of each() on hash after insertion without resetting hash iterator results in undefined behavior

{% include file="examples/each_disaster.pl" %}

Unlike when we use `keys`, when we use `each` we <b>must not</b> change the hash in any way.
In the above code we adde a new key-value pair while we were iterating over the hash. I ran the above code several
times and each time I ran it I got a different output:

```
abc  => 23
Use of each() on hash after insertion without resetting hash iterator results in undefined behavior,
  Perl interpreter: ..
answer  => 42
def  => 19
```

```
abc  => 23
Use of each() on hash after insertion without resetting hash iterator results in undefined behavior,
  Perl interpreter: ..
```

```
abc  => 23
Use of each() on hash after insertion without resetting hash iterator results in undefined behavior,
  Perl interpreter: ..
abc  => 23
answer  => 42
def  => 19
```


So you should never change a hash while iterating over it using `each`.

## Comments

Note that running "keys", "values" or simply iterating the hash in any way resets the internal iterator:

perl -MData::Dumper -wE '%h = (a => 12, b => 14); while (($k, $v) = each %h) { print "$k => $v\n"; warn Dumper \%h;}'

The above code loops infinitely.


<hr>

The one exception to the "do not change" rule is that you can safely delete the *current* element while iterating with each.

And you can always change any (existing) value.

<hr>

Would be good to show using void-context keys to reset the iterator where necessary, e.g.


while (my ($k, $v) = each %h) {
        say "$k  => $v";
        last;
}

say 'Play it again, Sam';
keys %h;
while (my ($k, $v) = each %h) {
        say "$k  => $v";
}


