---
title: "index"
timestamp: 2020-05-16T19:30:02
tags:
  - index
published: true
author: szabgab
archive: true
---


{% include file="examples/index.pl" %}

It will search for the location of the second string in the first string. Returns `-1` in case the string could not find the second string.
You can also add a 3rd parameter that will tell `index` where to start the serach from.

It is like the [rindex](/rindex) function but starts searching from the left-hand side of the string.
See also the explanation in [String functions: length, lc, uc, index, substr](/string-functions-length-lc-uc-index-substr).

[documentation](https://metacpan.org/pod/perlfunc#index-STR-SUBSTR-POSITION).
