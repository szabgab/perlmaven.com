---
title: "Binary search in Perl array"
timestamp: 2021-08-08T10:00:01
tags:
  - sort
published: true
author: szabgab
archive: true
---


Binary search is one of the basic algorithms of computer sciences. It goes like this:

Given a sorted(!) array of strings and a single string, what is the fastest way to find the location of the string?


As we would like to look at the algorithms and the complexity of algorithms, we will avoid using the built in
[index](/how-to-get-index-of-element-in-array) function and the
[first_index](/how-to-get-index-of-element-in-array) of List::MoreUtils.

## Linear search

We can go over element by element, comparing each element to the string we are looking for. The `linear_search` function
is simple to implement. Given N elements in the array, it will take on average N/2 iterations and in the worst case, when the value we are looking for is the last element, it will take N iterations.

{% include file="examples/linear_search_in_array.pl" %}

## Binary search

The **binary_search** function is a log more complex, but in the worst case it will take `log2(N)` iterations.
Just two compare the two

<pre>
  N    log2(N)
    1     0     (we know the answer instantly)
    2     1     (1 iteration)
   10     3.3
  100     6.6
 1000     9.9
10000    13.3
</pre>

As you can see as N growth the difference is dramatic.

{% include file="examples/binary_search_in_array.pl" %}

## How does the binary search work?

We maintain two variables `$min` and `$max` that hold two indices of the array. We assume the value we are looking
for can be found between the two. At first we set `$min` to 0 and `$max` to the [largest index of the array](/scalar-and-list-context-in-perl). We call this the window of search. Surely if the element can be found it is somewhere there.

Then at every iteration we calculate the index of the element exactly half way between the current minimum and maximum.
(We se `int` to round the result of the division as we would like to get a whole number as index.)
We comare the value at the selected index.

If is smaller than the value we are looking for then the real location must be above it, in the upper part of the window. We move the `$min` slightly above the selected element.

If is bigger than the value we are looking for then the real location must be below it, in the lower part of the window. We move the `$max` slightly below the selected element.

In either case we made the window smaller.

If the current value is neither smaller nor bigger than the value we are looking for then we found the location and return the middle value which is the index we were looking for.

If the window becomes empty (the $min is bigger than the $max) then we can conclude the element we were looking for is not in the array.

I've left in a commented `say` statement in case you'd like to see the values a search tries.

