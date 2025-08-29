---
title: "How to sort a hash in Perl?"
timestamp: 2013-08-30T16:30:01
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
books:
  - beginner
author: szabgab
---


This question comes up often, and every time it might hide something interesting behind it.

One of the important features of a hash, or hashmap, or dictionary,
or associative array as some other languages
like to call it, is that it is a set of **unsorted** key-value pairs.

So when someone asks **how to sort a hash?**, the reaction usually is that you **cannot sort a hash**.
The other reaction might be pointing people to tool that can handle a [sorted hash](/sorted-hash-tie-ixhash)
even though that has a significant run-time penalty.

So what do people really mean when they want to **sort a hash?**


## How to sort a hash?

For example let's say we have a hash with the names of the planets in our
[Solar system](http://en.wikipedia.org/wiki/Solar_System) and with their
average distance from the Sun as measured in
[Astronomical units](http://en.wikipedia.org/wiki/Astronomical_unit).

Reading those pages actually revealed that Pluto is not considered a planet on its own
any more, but as a [dwarf planet](http://en.wikipedia.org/wiki/Dwarf_planet)
which is part of the [Kuiper belt](http://en.wikipedia.org/wiki/Kuiper_belt).
There is also [Charon](http://en.wikipedia.org/wiki/Charon_(moon)) which is
sometimes considered to be a moon of Pluto, sometimes as part of a
[binary system](http://en.wikipedia.org/wiki/Binary_system_(astronomy)).
It will be useful for our purposes, so I added it to the hash.

Anyway, we create the hash, fill it with values and the print it out using a `foreach`
loop on the planet names returned by the `keys` function.

{% include file="examples/sort_a_hash.pl" %}

The output looks like this:
```
Jupiter  5.2
Uranus   19.6
Ceres    2.77
Saturn   9.5
Earth    1
Neptune  30
Charon   39
Mars     1.5
Venus    0.7
Mercury  0.4
Pluto    39
```

Not only is it in a seemingly random order, depending on our version of Perl it can
be in different order as well. Even if in older versions of Perl this order seemed to be
stable between runs, starting from 5.18.0, even that is very unlikely.

## Sort the hash in alphabetical order of its keys

When someone wants to **sort a hash**, one possibility is that he wants to sort
the planets in alphabetical order. That's quite easy.

```perl
foreach my $name (sort keys %planets) {
    printf "%-8s %s\n", $name, $planets{$name};
}
```

The output is always going to be:

```
Ceres    2.77
Charon   39
Earth    1
Jupiter  5.2
Mars     1.5
Mercury  0.4
Neptune  30
Pluto    39
Saturn   9.5
Uranus   19.6
Venus    0.7
```

But that's not exactly alphabetical sorting. The default behavior of `sort`
is to sort based on the ASCII table. (Except when `use locale` is in effect,
but we don't want to go there now.)
This means that the default sorting would put all the upper-case letters in front of all
the lower-case letters. If we really want to have alphabetical sorting we can do the following:

```perl
foreach my $name (sort {lc $a cmp lc $b} keys %planets) {
    printf "%-8s %s\n", $name, $planets{$name};
}
```

That's OK, but what if what we want is to **sort the values of the hash**?

## Sort the values of the hash

That's another thing that can be easily misunderstood. If we take that request literally
we will write the following code:

```perl
foreach my $distance (sort values %planets) {
    say $distance;
}
```

gaining the following output:

```
0.4
0.7
1
1.5
19.6
2.77
30
39
39
5.2
9.5
```

That is, we fetch the `values` of the hash, and sort them based on the ASCII table.

Maybe we are kind and notice the values are numbers and 2.77 should not fall between 19.6 and 30,
and sort them according to their numerical value like this:

```perl
foreach my $distance (sort {$a <=> $b} values %planets) {
    say $distance;
}
```

```
0.4
0.7
1
1.5
2.77
5.2
9.5
19.6
30
39
39
```

But ultimately someone will ask us: **OK, but how can I get back the names of the planets from the values?** 
And you can't. For one the mapping of the hash is one-directional: from key to value, but maybe
more importantly, the values are not required to be unique. In our example, both Pluto and Charon
are at the same average distance from the Sun.

What is more likely is that we wanted to **Sort the names of the planets according to their distance form the Sun**.
In more general wording:

## Sort the keys of the hash according to the values 

We almost always want to sort the keys of the hash.
Sometimes based on a property of the keys and sometimes
based on a property of the values in the hash.

```perl
foreach my $name (sort { $planets{$a} <=> $planets{$b} } keys %planets) {
    printf "%-8s %s\n", $name, $planets{$name};
}
```

Here `$a` and `$b`, the place-holder variables of `sort`
will always hold two keys returned by the `keys` function and
we compare the respective values using the `spaceship operator`.

If some of these sorting functions look strange,
please take a look at the article on [sorting arrays and lists](/sorting-arrays-in-perl).
The explanations there might make more sense.

Anyway, the output will be sorted exactly as we wanted:

```
Mercury  0.4
Venus    0.7
Earth    1
Mars     1.5
Ceres    2.77
Jupiter  5.2
Saturn   9.5
Uranus   19.6
Neptune  30
Pluto    39
Charon   39
```

Well, almost exactly. If we run that code repeatedly we will notice
that Pluto and Charon are swapping places. Just in the reality, out there
in the cold of the Kuiper belt.

That's because they have the same value, so our comparison function cannot
decide which is closer to the Sun.

In some cases this is OK, in other cases we will want to make sure keys
that have the same value will be sorted according the ASCII table. For that
case we have the following code:


```perl
foreach my $name (sort { $planets{$a} <=> $planets{$b} or $a cmp $b } keys %planets) {
    printf "%-8s %s\n", $name, $planets{$name};
}
```

With this code Charon will always come before Pluto as they have the same distance from the
Sun, but C comes before P in the ASCII table.

## Comments

how do i randomize a hash (actually do the iteration in random order) on purpose.
Yes, this in default from 5.18 how can i do it on 5.14?

<br>

Is there a way to keep the sorted hash for use after the loop?
---
Probably you can just try to carefully name the key of hash, like 01-key => value, 02-another-key => another-value. Then you can keep the sorted hash.
---
I hope that you both understand that a hash is never sorted. Right? You can keep the array of the keys sorted, but once you created that, the two data structures are disconnected so any change in the keys of the hash won't be reflected in the array.

<br>

Gabor, I refer to this page more than any other Perl Maven article.

Thank you for writing this, it is very clear and informative!

<br>

You can get reverse ordered results in all examples above. Just add 'reverse' keyword in front of sort

---
or just reverse the $a and $b variables in the comparison

<br>

I want to exchange keys with values. without losing any data even if there a are duplicate values in the original hash.
---
Good, and what would you expect to have if there are two keys (e.g. foo and bar) for which we have the same value "hello". What would you want to have in the resulting hash?
---

Gabor's point is definitely the main one, you can't have duplicate keys.
So in a simple reversed hash what would 'hello' map to? 'foo' or 'bar':
But if the original poster wanted something "without losing any data" it might be useful to their application to create a slighty more complicated 'reversed' hash where say 'hello' now maps to an array ref of the original keys, something like:

%original_hash = ( 'foo' => 'hello', 'baz' => 'goodbye', 'bar' => 'hello'); 
%reversed_hash = ( 'hello' : [ 'foo', 'bar' ], 'goodbye' : [ 'baz'] );

might fit their use case, who knows?!


