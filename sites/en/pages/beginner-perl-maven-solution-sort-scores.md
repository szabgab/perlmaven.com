---
title: "Solution: sort scores - video"
timestamp: 2015-07-09T18:02:34
tags:
  - "%"
types:
  - screencast
published: true
books:
  - beginner_video
author: szabgab
---


Solution: of the [sort scores](/beginner-perl-maven-exercise-sort-scores) exercise.


{% youtube id="nOVVS2qfwPQ" file="beginner-perl/solution-sort-scores" %}

{% include file="examples/hashes/score_data.pl" %}

We run it as `perl score_data.pl score_data.txt`.

{% include file="examples/hashes/score_data.txt" %}

The code starts with the usual [hash-bang](/hashbang) line followed by
[use strict; and use warnings;](/always-use-strict-and-use-warnings).

Then we get the name of the data file [from the command line using shift](/argv-in-perl).

Then we [open the file for reading](/open-and-read-from-files).o

Then we declare a hash called `%score_of` in which we are going to hold the name-value pairs
from the data file.

We go over the file line-by-line using a while loop. [chomp off the newline](/chomp) from the end of the line
and the [split](/perl-split) at the comma (`,`).


