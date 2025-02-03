---
title: "Fast lookup by name or by date - Array - Hash - Linked List"
timestamp: 2019-03-17T10:30:01
tags:
  - first
  - reduce
  - splice
  - List::Util
published: true
author: szabgab
archive: true
---


We have a lot of data-structures that have a name, a date when each one was created and some payload.
Once in a while we need to find and remove an element. Either by the name of the element or by picking the oldest
one. How can we make this efficient given that we have a lot of these data-structures? (Some 10,000.)


## The data structure

If we hold each data structure in a hash we have something like this:

```perl
{
    name => "some name",
    date => time,
    payload => { },
}
```

The payload itself has Perl objects in them and I think some of them are even open sockets.

We basically have two ways to hold all the elements:

## In array acting as a queue

We can keep them in an array and [push](/manipulating-perl-arrays) any new element to the end. Then the first one is the oldest, we can use [shift](/shift) to remove
it and we don't even need to keep the "date" field. Finding the element by name has a complexity of O(n) as we have to go over
all the elements using [grep](/filtering-values-with-perl-grep) or better yet using  `first` from [List::Util](https://metacpan.org/pod/List::Util).


## In a hash based on name

We can keep them in hash based on the name:
Accessing `$h{$name}` has a complexity of O(1), but then in order to find the oldest we need to keep a timestamp as well in every object and we have to go over all the elements to find the object.
This is O(n).

## Linked list

In a linked list every element is connected to the previous element and the next element as well and there is a link from the outside world to the first element.
(There might be also a link to the last element for easier bookkeeping.) We can implement such a linked list inside a hash. That way we can access any individual element
inside the data structure by looking up its name. As this is a hash operation it takes O(1). We can also easily get to the oldest (first) element as we have a direct
link to it from the outside world. That too is O(1).

It seems this approach can be by far the fastest, but we have to take in account that
* The code is a bit more complex and thus we need to invest extra effort in verifying it.
* Each operation is now slower so depending on the actual pattern of access we might not have any overall speed gain.
* The data now takes up more space in memory as we need the have the links to the previous and next element for each piece of data.

## Implemented as an array

{% include file="examples/fast_lookup/AsArray.pm" %}

The tricky part here is the implementation of `remove_by_name`. We go over the indexes of the array
from 0 to the highest index which is the number of elements minus 1. Then we use the `first` function
of [List::Util](https://metacpan.org/pod/List::Util) which is similar to [grep](/how-to-grep-a-file-using-perl),
but stops after it founds the first matching value.

We then use [splice](/splice-to-slice-and-dice-arrays-in-perl) to remove the element from the array.

## Implemented as an hash

{% include file="examples/fast_lookup/AsHash.pm" %}

In this implementation the tricky part is finding the oldest element for the `remove_oldest` method.
We go over all the data structures, the `values` of the "data" hash and we are looking the element
with the smallest number in the `date` field. For that we use the `reduce` function supplied by
[List::Util](https://metacpan.org/pod/List::Util) with the [ternary operator](/the-ternary-operator-in-perl) inside.

## Implemented as an linked list

{% include file="examples/fast_lookup/AsLinkedList.pm" %}

In this implementation there is a lot more bookkeeping both when we add a new element and when we remove one. The class itself holds the name of the first and last elements in the "_first" and "_last" fields respectively. Each element in the "data" hash also has a field with the name of the previous and next elements in the "_prev" and "_next" fields respectively.

When we add a new elemen and when we remove an old element we need to update these fields to keep all the data structure up to date.

As an improvement we might want to keep a reference to the objects instead of the name of the field, though I am not sure it is really an improvement.



## Tests

I felt that the code is already complex enough to warrant tests.

{% include file="examples/fast_lookup/test.t" %}

## Conclusion - which is the fastest

OK so we have built the 3 solutions, but have not compared the speed yet.
Let me leave that as an exercise for you now.

## Comments

This is an interesting post, addressing a need that I encountered a few years ago. However, I think Gabor has unnecessarity constrained this by stating:

Once in a while we need to find and remove an element. Either by the name of the element or by picking the oldest one.

A useful generalization would be to allow searches on any date/time, or searches over a specified time interval.


