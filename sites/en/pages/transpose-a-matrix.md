---
title: "Transpose a Matrix (Arrays or Arrays)"
timestamp: 2019-05-09T22:30:01
tags:
  - array
published: true
author: szabgab
archive: true
---


While Perl arrays can only be one-dimensionals, each value can be a reference to another array and then it could look
like as if it was a 2 or more dimansional array.

If each element of an array is a reference to another array, and if each one of the internal arrays has the same number
of elements then it will look like a matrix.

A matrix can be transposed. (Replace the rows by arrays.)


{% include file="examples/transpose_matrix.pl" %}

The result looks like this, printing the before and after versions.

{% include file="examples/transpose_matrix.txt" %}

