---
title: "min, max, sum in Perl using List::Util"
timestamp: 2019-04-12T18:40:01
tags:
  - min
  - minstr
  - max
  - maxstr
  - sum
  - sum0
  - product
  - List::Util
published: true
author: szabgab
archive: true
---


The [List::Util](https://metacpan.org/pod/List::Util) module provides a number of simple 
and some more complex functions that can be used on lists, anything that returns a list anything that can
be seen as a list.

For example these can be used on arrays as they "return their content" in [list context](m/scalar-and-list-context-in-perl).


## min

If given a list of numbers to it, it will return the smallest number:

{% include file="examples/min.pl" %}

If one of the arguments is a string that cannot be fully converted to a number automatically and if you have [use warnings on as you should](/always-use-warnings), then you'll see the following warnings: `Argument ... isn't numeric in subroutine entry at ...`

## minstr

There is a corresponding function called `minstr` that will accept strings and sort them according to the ASCII order,
though I guess it will work with Unicode as well if that's what you are feeding it.

{% include file="examples/minstr.pl" %}

It can also accept numbers as parameters and will treat them as strings.
The result might surprise you, if you are not familiar with the automatic number to string conversion of Perl,
and that the string "11" is ahead of the string "2" because the comparison works character-by-character and
in this case the first character of "11" is ahead of the first (and only) character of "2" in the ASCII table.

{% include file="examples/minstr_numbers.pl" %}

After all internally it uses the `lt` operator.

## max

Similar to `min` just returns the biggest number.

## maxstr

Similar to `minstr`, returns the biggest string in ASCII order.

## sum

The `sum` function adds up the provided numbers and returns their sum. If one or more of the values provided is a string that cannot be fully converted to a number it will generate a warning like this: `Argument ... isn't numeric in subroutine entry at ...`. If the parameters of `sum` are empty the function returns [undef](/undef). This is unfortunate as it should be 0, but in order to provide backwards compatibility, if the provided list is empty then undef is returned.

{% include file="examples/sum.pl" %}

## sum0

In order to fix the above issue, that `sum()` return `undef`, in version 1.26 of the module, in 2012, a new function called `sum0` was introduced that behaves exactly like the `sum` function, but returns 0 if no values was supplied.

{% include file="examples/sum0.pl" %}

## product

The `product` function multiplies its parameters. As this function is newer it was not constrained with backward compatibility issues so if the provided list is empty, the returned value will be 1.

{% include file="examples/product.pl" %}


## Other functions of List::Util

The module has a number of other functions that were used in various other articles:

## first

`first` returns the first element from a list that satisfies the given condition. For examples on how to use it an why is it good check out the articles [Fast lookup by name or by date - Array - Hash - Linked List](/fast-lookup-by-name-or-by-date) and [Search for hash in an array of hashes](/search-for-hash-in-array-of-hashes).

## any

The `any` function will return [true](/boolean-values-in-perl) if any of the given values satisfies the given condition. It is shown in the article [Filtering values using Perl grep](/filtering-values-with-perl-grep) as a better solution.

It is also used in the example showing how to [create a testing module](/is-any-create-test-module) and how to [implement 'is_any' to test multiple expected values](/is-any-to-test-multiple-expected-values).

## all

The `all` function will return [true](/boolean-values-in-perl) if all the supplied values satisfy the given condition. It can be seen in the article <a href="/check-several-regexes-on-many-strings"">Check several regexes on many strings</a>.

## reduce

The `reduce` function might be familiar to you from the [MapReduce](https://en.wikipedia.org/wiki/MapReduce) programming model that was lauded around "BigData". It makes it provides a way to summarize data in an easy way. [Implementing factorial in Perl - n!](/factorial-in-perl) is a good and simple example. It is also used in the [Fast lookup by name or by date - Array - Hash - Linked List](/fast-lookup-by-name-or-by-date) article.
