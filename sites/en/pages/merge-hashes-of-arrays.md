---
title: "Merge hashes of arrays"
timestamp: 2019-05-16T22:30:01
tags:
  - uniq
  - dump
  - Data::Dump
  - List::MoreUtils
published: true
author: szabgab
archive: true
---


Given two (or more) hashes, where each value is a reference to an array how can we merge them?

Two solutions.




## Merge including duplicate values

In the first one we just merge the arrays. Duplicate values remain.

{% include file="examples/merge_hashes_of_arrays.pl" %}


{% include file="examples/merge_hashes_of_arrays.txt" %}

## Merge excluding value duplication - ensuring values are unique

In the second we only keep distinct values withine each array.

{% include file="examples/merge_hashes_of_arrays_uniq.pl" %}

As you can see if one of the original arrays had a duplicate value (Jack in semester one had two 1-s)
those will be also subject for the unification.

{% include file="examples/merge_hashes_of_arrays_uniq.txt" %}

