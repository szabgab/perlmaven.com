---
title: "Binary search in a file"
timestamp: 2022-09-19T16:30:01
tags:
  - files
published: false
author: szabgab
archive: true
---


If you have a file that contains some sorted information, e.g. a list of words, and you are trying to look up a given word, using in-memory array and [Binary search in a Perl array](/binary-search-in-perl-array) is probably the first thing I would try to do.

However, if the file is big, if it is bigger than the available free memory of the computer, then this is not possible. We need another solution.

Reading the words one-by-one sequentially would be a solution as the memory requirement of that is the size of a single word (or a single line if we are talking about something longer than words).
However, reading them sequentially might be a waste. Especially if the lines are already sorted.


We already saw in the [binary search in arrays](/binary-search-in-perl-array) that sequential search has a complexity of `O(n)`
and binary search has a complexity of `O(log2(n))`. On large files it can have a huge impact.

At 10,000 items, the linear version does 10,000 iterations while the binary search does 14 iterations.

At 10,000 items even if the fixed cost of every binary iteration is 100 times bigger than the fixed cost of a single linear iteration, we are still better off with the binary search.

How could we implement a binary search without reading the whole file into memory?

## Planets

For the example I am using a very small file listing some of the planets in the Solar system:

{% include file="examples/data/planets.txt" %}

For a larger text file you might want to search for "list of english words in plain text files".

## Solution 0: In-memory search

For small files the best solution might be to read the whole file into memory into an array
and then use the [binary search on the array](/binary-search-in-perl-array).

{% include file="examples/read_file_into_array.pl" %}

```
$ perl examples/read_file_into_array.pl Pluto examples/data/planets.txt
Pluto found at 7
```

and

```
$ perl examples/read_file_into_array.pl "Brodo Asogi" examples/data/planets.txt
Brodo Asogi not found
```

## Solution 1: Linear search in file

{% include file="examples/linear_search_in_file.pl" %}

```
$ perl examples/linear_search_in_file.pl Pluto examples/data/planets.txt
Pluto found in row 8
```

```
$ perl examples/linear_search_in_file.pl "Brodo Asogi" examples/data/planets.txt
Brodo Asogi not found
```

The results are off-by one. This is due to the fact that in arrays the first element has index 0.
So element with index 7 in an array is the 8th element in the original list.
Which number is the more correct one will depend on the situation.
I'll leave that as an exercise to you, the reader.

## Solution 2: Binary search in a file

{% include file="examples/binary_search_in_file.pl" %}

Here we maintain a range of bytes using the variables `$min` and `$max`.
On every iteration we go to the byte that's half way between the min and max places.
As this might be in the a line we read to the end of the current line.

Then we check if we are not at the $max, if we are then we should go to $min and start reading from there.

Then we read the current line, chomp it, and compare it to the string we are looking for.

Then either we change the $min or the $max to make the sections smaller.


## Testing the solutions

I wanted to make sure the solutions work and if later I find improvements I can easily verify that
the changes to the code don't change the results. So I wrote a few tests:

{% include file="examples/test_binary_search.t" %}

Run them as:

```
prove examples/test_binary_search.t
```


