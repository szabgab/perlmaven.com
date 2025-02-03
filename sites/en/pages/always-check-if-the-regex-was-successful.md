---
title: "Always check if the regex was successful"
timestamp: 2020-08-30T20:30:01
tags:
  - $1
  - =~
  - regex
published: true
author: szabgab
archive: true
description: "The regular expression capturing variables, $1, $2, $3, ... don't get reset on every regex so before we use them we should verify that the most recent regex matched and we are not using stale data."
show_related: true
---


If you are using regular expression to extract pieces from a string, you should always check if the regex matched
before using the $1, $2, etc. variables that hold the captured substrings.

Otherwise you risk using the results of an older match.


## First bad example

{% include file="examples/regex_in_loop.pl" %}


In this example we use a regex, but we don't check if it was successful or not. We just assume it was and
use the content of $1. The result:

```
abcde
a
12345
a
```

This was a very simplified example, and thus running it made it easy to see the problem. For both input strings,
the result was the same, matched by the first string.


## Show when was it matching


{% include file="examples/regex_in_loop_showing_match.pl" %}

In this example I only wanted to show you that the first string matches, the second string does not. The result:

```
abcde
match
a
12345
a
```


## Correct way to write it

{% include file="examples/regex_in_loop_corrected.pl" %}

Finally we moved the use of $1 inside the condition, and used it only when there was a match.

```
abcde
match
a
12345
```

## Final words

There are other ways to avoid the problem shown at the beginning, but this might be the most straight forward one.


