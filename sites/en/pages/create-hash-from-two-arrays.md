---
title: "Create hash from two arrays: keys and values"
timestamp: 2019-05-08T20:30:01
tags:
  - keys
  - values
published: true
author: szabgab
archive: true
---


Given a hash we can easily create a list of all its keys and all its values by using the `keys` and
`values` functions respectively.

How can we do the opposite?

How can we create a hash from an array of the future keys and an array of the future values?


## Simple keys and values

{% include file="examples/hash_from_two_arrays.pl" %}

What you see here is [hash slices in action](/hash-slice).

The results:

{% include file="examples/hash_from_two_arrays.txt" %}

Remember, the keys inside the hash are not in any particular order.

## Values containing a list of array references

A slightly more complex case:

{% include file="examples/hash_from_keys_and_array_refs.pl" %}

And the results:

{% include file="examples/hash_from_keys_and_array_refs.txt" %}
