---
title: "How to sort faster in Perl? (using the Schwartzian transform)"
timestamp: 2012-12-11T11:45:57
tags:
  - map
  - sort
  - Schwartzian
published: true
author: szabgab
---



Sorting a list of files by ASCII ordering of their name works very fast. Even
if the list is long.

On the other hand, if you need to sort them based on the size of the files,
it can be much slower.


## Sorting files according to name

This simplified code example creates a list of xml files and then sorts them according to the alphabetical order of
their names. It is fast.

```perl

#!/usr/bin/perl
use strict;
use warnings;

my @files = glob "*.xml";

my @sorted_files = sort @files;
```

## Sorting files by length of name

```perl
my @sorted_length = sort { length($a) <=> length($b) } @files;
```

For 3000 files, this was 3 times slower than sorting by ASCII name, but was still quite fast.

## Sorting files by file size

When I tried to sort the 3000 files based on their size, it took 80 times(!) the time sorting the names based on ASCII.

```perl
my @sort_size = sort { -s $a <=> -s $b } @files;
```

This, of course, is not surprising. In the first case, perl only had to compare values.
In the second case perl had to compute the length of the strings before comparing them.
In the 3rd case, for every comparison, it had to go to the hard disk and fetch the size of both files.

Accessing the disk is a lot slower than accessing memory which explains the slowdown.

The question, **can we improve it?**.

The problem of accessing the disk is amplified by how sort works.

There are various sorting algorithms
in the world ([Quicksort](http://en.wikipedia.org/wiki/Quicksort),
[Bubblesort](http://en.wikipedia.org/wiki/Bubblesort),
[Mergesort](http://en.wikipedia.org/wiki/Mergesort), etc.)
Depending on the input, some of these can be faster, some a bit slower. Perl used to have
Quicksort, then it was switched to Mergesort. Today, if you really want, you can decide which one to
use via the [sort](http://perldoc.perl.org/sort.html) pragma.

Regardless what you choose, on average, you will have at least N*log(N) comparisons. Which means for
N = 1000 files perl will need to access the disk 2 * 1000 * 3 = 6000 times. (Twice for every comparisons.)
For every file perl fetches the size of the file 6 times! It is a total waste of energy.

We can't avoid accessing the disk for the files sizes, and we cannot reduce the number of comparisons,
but we can reduce the number of times the disk is accessed.

## Pre-fetching the size

We are going to fetch all the file sizes up-front, store them in memory,
and then run the sort on data that can be found in the memory already.

```perl
my @unsorted_pairs = map  { [$_, -s $_] } @files;
my @sorted_pairs   = sort { $a->[1] <=> $b->[1] } @unsorted_pairs;
my @quickly_sorted_files = map  { $_->[0] } @sorted_pairs;
```

This might look a bit more complicated than what you'd write, but bear with me.
It will be used in a more simple way.

There are 3 steps here. In the first step we go over the list of files and for each file
we create an ARRAY reference. In the array reference we have two elements. The first one is
the name of the file, the second one is the size of the file. This will access the disk once
for every file.

In the second step, we sort the array of the small array references. When comparing two of those
small array references we fetch the element [1] of each one of them, and compare those values.
The result is another array of small array references.

In the third step we throw away the sizes and build a list of the filenames only.
What we originally wanted.


## Schwartzian transform

For the above code we used 2 temporary array, that are not really necessary.
We could create a single statement that will do all the work. For this we
need to reverse the order of the statements as "data flows from right to left"
in Perl, but if we put each statement on its own line, and if we leave enough
space around the curly braces, we can have a readable piece of code.

```perl
my @quickly_sorted_files =
    map  { $_->[0] }
    sort { $a->[1] <=> $b->[1] }
    map  { [$_, -s $_] }
    @files;
```

This is called the [Schwartzian transform](http://en.wikipedia.org/wiki/Schwartzian_transform)
named after [Randal L. Schwartz](http://en.wikipedia.org/wiki/Randal_L._Schwartz).

When seen in code, it can be easily recognized by the map-sort-map construct.

It can be used for sorting anything, but it is especially useful when the
computation of the values to be compared is relatively heavy.

```perl
my @sorted =
    map  { $_->[0] }
    sort { $a->[1] <=> $b->[1] }
    map  { [$_, f($_)] }
    @unsorted;
```


Using this algorithm for sorting the 3000 xml files the sorting became "only" 10 times slower than the
ASCII sort which means it is about 8 times faster than the code we had at the beginning.


## Conclusion

Effectively we gain speed and pay by higher memory usage and code complexity.
For small arrays it is not worth it, and for large arrays it is only worth if
this change has a real impact on your program.

If the whole sorting takes up 1 second from a script that runs for 10 minutes,
then probably it is not worth the investment. On the other hand if the sorting
is a larger part of the total run-time, you should probably use the Schwartzian
transformation.

In order to find out which is the case, use <a href="https://metacpan.org/pod/Devel::NYTProf">Devel::NYTProf to
profile</a> your code.

(Thanks to [Smylers](http://twitter.com/Smylers2) for reviewing the article.)
