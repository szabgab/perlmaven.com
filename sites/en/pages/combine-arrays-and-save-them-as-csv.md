---
title: "How to combine arrays to a multi-dimensional array and save them to CSV file"
timestamp: 2020-09-05T08:30:01
tags:
  - Text::CSV
published: true
author: szabgab
archive: true
description: "Given two or more arrays of the same length, how can we merge them into a single multi-dimensional array. How could we save their content into a CSV file?"
show_related: true
---


One of the readers of the Perl Maven site asked the following question:

I have three arrays of extracted information, of more than 100 lines each array, like this:

```
@xe; # Event Id
@ye; #IP
@ze; #Description
```

How can I store them in a new one with 3 columns by n rows, to export it that way either in .txt or .csv format


Let me try to answer.

## Original data

I'll use shorter examples, but the solution is the same. I assume we have something like this:

{% include file="examples/combine_arrays_original.pl" %}

I assume the code already has [use strict and use warnings](/always-use-strict-and-use-warnings) enabled. I also assumed the description
array, that sounds like free text, might contain commas. Just to make our life a bit harder.

## Better variable names

First thing I would do is change the variable names to make them more meaningful. That will help make the code more readable.
It also allows me to remove the comments, as now the variable names contain all the information we had in the comments.

{% include file="examples/combine_arrays_variable_names.pl" %}

## Combine arrays, stack them vertically

This is probably not what the original person asked, but this is certainly one of the ways to combine the 3 arrays.

We create a new array called `@rows` that contains [references](/array-references-in-perl) to each one of the original arrays.

{% include file="examples/combine_arrays_vertically.pl" %}

We use the [Text::CSV](https://metacpan.org/pod/Text::CSV) to ensure we save the data properly. It automatically puts quotes around the values that
have commas in them.

The resulting file looks like this:

{% include file="examples/vertical_arrays.csv" %}

## Combine arrays, stack them horizontally

Merging the arrays in the other direction requires us to iterate over the arrays.
Here I assumed all the arrays have the same length.

We iterate over all the indexes from 0 to the largest index which is the size of the array minus one.
For each index we create a [reference to an array](/array-references-in-perl) (hence the square brackets),
and push that at the end of the `@rows` array.

{% include file="examples/combine_arrays_horizontally.pl" %}

The result is here:

{% include file="examples/horizontal_arrays.csv" %}

## Combine arrays, stack them horizontally - one-by one

This direction allows us to combine the values on the fly, without creating an extra array.

{% include file="examples/combine_arrays_horizontally_one_by_one.pl" %}

In certain situations this might be a better solution, though looking at it now I am not convinced. The previous one had a nice separation of concerns:

We had a separate part where we combined the arrays to single array and a separate where we wrote the resulting two-dimensional array to a CSV file.
In this example these two operations are mixed together.

The advantage of this second solution is that it uses less memory. It is only valuable if the arrays are huge and barely fit in memory.

## Horizontal or vertical?

I hope I managed to use the directions horizontal and vertical the way you see them. In any case, don't worry about those names. Use whatever describes
the action the best in your opinion.




