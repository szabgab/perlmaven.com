---
title: "List and Array Utilities in Perl"
timestamp: 2017-06-28T22:30:01
tags:
  - List::Util
  - List::MoreUtils
  - List::AllUtils
  - Util::Any
  - List::UtilsBy
  - List::Pairwise
published: true
author: szabgab
archive: true
---


There are many utilities in perl that work on arrays or even on lists of values that have not been assigned
to an array. Some of these are built in the languages. Others come in a standard module, yet even more of
them can be installed from CPAN. Here you'll find a number of these utility functions and pointers where
can you get them from.



## Built-in functions

* [grep](/filtering-values-with-perl-grep) can be used to filter values according to some rule. It usually reduces a longer list to a shorter or even empty list. In scalar context it is used to check if there is any element that fulfills certain condition.
* [map](/transforming-a-perl-array-using-map) can be used to transform values of a list or an array (e.g. double each number).
* [sort](/search/sort) to sort values by any condition.
* [reverse](/reverse) returns the list of values in reverse order
* [pop, push, shift, unshift](/manipulating-perl-arrays) to add and remove elements at either the beginning or the end of an array.
* [splice](/splice-to-slice-and-dice-arrays-in-perl) to add and remove elements anywhere in an array.
* [join](/join) to combine a list of values into a string.


## [List::Util](https://metacpan.org/pod/List::Util)
(checked in version 1.42 of the [Scalar-List-Utils](https://metacpan.org/release/Scalar-List-Utils) distribution.)

* <b>reduce</b> - Generic function to reduce a list of value to a single value according to some rule. Many other function in this module are special cases of `reduce`. (For example `sum(@numbers)` is the same as `reduce { $a + $b } @numbers`)

* <b>first</b> - like grep but will only return the first value matching the conditional in the block. The two expressions below will set the same value, but the `first` is faster as
it stops after it found the first element while `grep` has to go over all the elements before returning the results.

```perl
my $val = first { COND } @list;

my ($val) = grep { COND } @list;
```
  
* <b>max</b> returns the element with the highest numerical value
* <b>maxstr</b> returns the element with the highest "string" value as returned by the `gt` operator.
* <b>min</b> returns the element with the smallest numerical value
* <b>minstr</b> returnes smallest "string" value.
* [any](/filtering-values-with-perl-grep) is like `grep` in scalar context, but in addition it short-circuites making it potentially much faster. It returns [true](/how-to-sort-faster-in-perl) if any of the values in the given list match the supplied condition.
  {% include file="examples/list_util_any.pl" %}
  
* [all](/does-all-really-short-circuit) returns true if all the elements in the given list fulfill the condition. It is faster than grep as it short-circuits on the first failure.
  {% include file="examples/list_util_all.pl" %}
  
* <b>none</b> - is like `not all`. It will return true if none of the element meet the condition. The following example shows 2 sets of 3-3 identical results:
  {% include file="examples/list_util_none.pl" %}
  
* <b>noall</b> - is like `not any`. The following example shows 2 sets of 3-3 identical results:
  {% include file="examples/list_util_none.pl" %}
  

* <b>sum</b> -  `sum(@numbers)` - returns the sum of numbers given. For backwards compatibility, if `@numbes` is empty then `undef` is returned. Use `sum0` instead!
* <b>sum0</b> -  Just like `sum` but this will return `0` if the given list was empty.
  {% include file="examples/list_util_sum.pl" %}
  
* <b>product</b> - multiply the numbers passed to the function. Return 1 if no value was supplied.
  {% include file="examples/list_util_product.pl" %}
  

* <b>shuffle</b> - Returns the values of the input in a random order.

* [pairs](/operation-on-value-pairs-in-perl) - create pairs from a list of values.
* [unpairs](/operation-on-value-pairs-in-perl) - flatten a list of pairs into a single list of values.
* [pairkeys](/operation-on-value-pairs-in-perl) - return a list of the odd elements of the given list
* <a href="/operation-on-value-pairs-in-perl">pairvalues<a> - return a list of the even elements of the given list
* <a href="/operation-on-value-pairs-in-perl">pairgrep<a> - it is like the built-in grep, except that it works on two elements in each iteration
* <a href="/operation-on-value-pairs-in-perl">pairfirst<a> - it is like the pairgrep, except that it returns the first hit
* <a href="/operation-on-value-pairs-in-perl">pairmap<a> - it is like the built-in map, except that it works on two elements in each iteration

## [List::MoreUtils](https://metacpan.org/pod/List::MoreUtils)

(any, all, none, notall)

* one
* apply
* insert_after
* insert_after_string
* pairwise
* mesh
* zip
* uniq
* distinct
* singleton
* 
* after
* before
* part
* each_array
* natatime
* bsearch
* bsearchidx
* bsearch_index
* firstval
* first_value
* onlyval
* only_value,
* lastval
* last_value
* firstres
* first_result
* onlyres
* only_result
* lastres
* last_result
* indexes
* firstidx
* first_index
* onlyidx
* only_index
* lastidx
* last_index
* sort_by - a more readable, and potentially faster  version of the built-in sort function.
* nsort_by - like sort_by, but compares values as numbers. 
* true
* false
* minmax


## [List::AllUtils](https://metacpan.org/pod/List::AllUtils)

Combines List::Util and List::MoreUtils in one bite-sized package.

## [Util::Any](https://metacpan.org/pod/Util::Any)

Makes it easy to built list and array utilities


## [List::UtilsBy](https://metacpan.org/pod/List::UtilsBy)

* sort_by - see List::MoreUtil
* nsort_by - see List::MoreUtil
* rev_sort_by - the same as `reverse sort_by ...`
* rev_nsort_by - the same as `reverse nsort_by ...`
* min_by - the value with the smallest derivative. 
* max_by
* uniq_by
* partition_by
* count_by
* zip_by
* unzip_by
* extract_by
* weighted_shuffle_by
* bundle_by

## [List::Pairwise](https://metacpan.org/pod/List::Pairwise)

This module has a bunch of pair-wise function, but since its release List::Util was exteneded with functions providing the same service.
See the [list of pairwise functions of List::Util](/operation-on-value-pairs-in-perl).

* mapp, map_pairwise
* grepp, grep_pairwise
* firstp, first_pairwise
* lastp, last_pairwise
* pair


