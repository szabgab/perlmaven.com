---
title: "Find the first element in an array in Perl that satisfies a condition"
timestamp: 2020-11-30T15:30:01
tags:
  - first
  - grep
  - List::Util
published: true
author: szabgab
archive: true
description: "Finding the first element of an array that matches some arbitrary condition without going over all the array."
show_related: true
---


When you need to find the first element in an array that satisfies some condition, the first solution that might come to mind is to loop
over all the elements using **for** and check them one by one. This would yield a working code, but there are nicer solution.

BTw if you are interested I've also written a solution to
[find the first matching element of a list in Python](https://code-maven.com/python-find-first-element-in-list-matching-condition).
It might be interesting to compare.


The condition is simple, the first animal that is longer than 5 characters.

## First matching element using a for loop

{% include file="examples/first_loop.pl" %}

In this solution we stop the iteration using the **last** statement when we found the first match.

## First matching element using grep

People who are more experienced with Perl, might use the [grep](/filtering-values-with-perl-grep) function.

{% include file="examples/first_grep.pl" %}

It is much more compact, but it will not stop the operation on the first value and it will return the list of all the
matching values. We use a pair of parentheses around a scalar variable on the left-hand-side of the assignment to
store the first element from the returned list. So the solution is correct, but it is wasteful, especially if the original array
is long and if the cost of each check is large. (Not in our case, but I trust you can imagine a longer array with more animals
and a more complex condition.)

## First element using the first function

The [List::Util](https://metacpan.org/pod/List::Util) module provides a function called **first** that solves this problem.
The syntax is exactly the same as with the **grep** function, but it will stop checking the condition after encountering the first
element that meets the condition.

{% include file="examples/first.pl" %}

## Compare grep and first

You might not trust me or the documentation that the **first** function stops as soon as possible, so
I made some changes, moved the condition to a separate function that would also print each time it is called.

{% include file="examples/first_log.pl" %}

The result:

```
length of snake
length of camel
length of etruscan shrew
length of ant
length of hippopotamus
length of giraffe
etruscan shrew
---------
length of snake
length of camel
length of etruscan shrew
etruscan shrew
```

As you can see yourself, the solution using **grep** printed all the values from the array.
The solution using **first** only printed up till the first matching element.

## Etruscan shrew

In case you were wondering the [Etruscan shrew](https://en.wikipedia.org/wiki/Etruscan_shrew)
is the smallest mammal by mass.

<img src="/img/220px-Suncus_etruscus.jpg" alt="Etruscan shrew">

There is a shorter mammal, but this looks better.

