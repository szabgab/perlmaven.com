---
title: "Sorted hash in Perl using Tie::IxHash"
timestamp: 2018-01-31T12:30:01
tags:
  - Tie::IxHash
  - tie
published: true
author: szabgab
archive: true
---


Though you [cannot sort a hash](/how-to-sort-a-hash-in-perl), but using the
[tie](/search/tie) keyword and the
[Tie::IxHash](https://metacpan.org/pod/Tie::IxHash) module we can create a hash
that keeps the keys ordered.

It is rarely used as it has a run-time penalty that usually is not worth the features,
but if you really need this kind of behavior and if you are ready to pay the price, then go ahead.
Use it.


A regular hash would look and work like this:

{% include file="examples/regular_hash.pl" %}

If we run this we get:

```
third
another
fourth
first
second
```

If we run the script again, we get the same words, but likely in different order. That's
because hashes are Perl are not ordered.

## tie and Tie::IxHash

There is, however a mechanism in Perl by which we can overload the behavior of any data structure,
including a hash. The mechanism is invoked using the `tie` function. With this function
we can map a hash to a module that implements the interfaces of a regular hash.

With this we can provide a hash-like interface to any behavior.

The [Tie::IxHash](https://metacpan.org/pod/Tie::IxHash) module implements the necessary methods
to act like a hash, but behind the scenes it keeps the data both in a hash and in an array at the same time.
This allows for the hash-like behavior (getting the value of a key in constant time and adding a new element
in constant time), but it also keeps the order of the keys.

Here is our little example:

{% include file="examples/sorted_hash.pl" %}

After creating the empty hash we use the following expression to connect the hash to the Tie::IxHash module:

`my $t = tie %people, 'Tie::IxHash';`

We can optionally assign the result to a scalar variable. This will allow us to access some extra features.

Once we have the hash tied to Tie::IxHash, we can use it as if was a regular hash. We can add and remove elements
and we can iterate over its keys.

The big difference is that no matter how many times we run this script, the first for-loop will always print
the keys in the exact same order as that were added o the hash:

```
first
second
third
fourth
another
```

## Sorting the hash

As we have also stored the object returned by the `tie` function we can use the methods of
the Object Oriented interface of [Tie::IXHash](https://metacpan.org/pod/Tie::IxHash)

Specifically we use the `SortByKey` method and the `Reorder` method.

The former (`SortByKey`) will sort the hash according to its key and then keep it sorted.
The latter (`Reorder`) can sort the hash in any way and then keep it sorted.

In both case Perl will sort the internal array of keys and that's how it provide the "sorted hash".

## Reorder

This method accepts a list of strings. These will be stored as the "order of the keys"
which also means that if we don't provide all the existing keys of the hash, then the elements missing from the list
will be also removed from the hash.

So we fetch all the `Keys` of the hash as a list. Sort them and then inject them back into the hash.

## SortByKey

SortByKey is the same as this expression: `$t->Reorder( sort $t->Keys );`


## Caveat

Let me remind you, that using Tie::IxHash incurs a significant run-time penalty and might not worth the
convenience.

