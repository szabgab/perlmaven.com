---
title: "Regex capturing variables $1, $2, $3, $4, $5, $6, ..."
timestamp: 2021-03-17T17:50:01
tags:
  - $1
  - $2
  - $3
  - $4
  - $5
  - $6
  - $7
  - $8
  - $9
published: true
author: szabgab
archive: true
description: "When using capturing parentheses in regualar expressins in Perl, the captures strings are available in the variables $1, $2, etc."
show_related: true
---


When using capturing parentheses in regualar expressins in Perl, the captures strings are available in the variables $1, $2, etc. counting
the opening parenthese from left to right.


In the first example you can see two distinct pairs of parentheses.
In the second example there is a third pair of parentheses around the whole regex which becomes `$1` because it has the left-most opening parens.

{% include file="examples/regex_capture.pl" %}

## Substitution

Capturing can also be used in the replacement part of a substitution:

{% include file="examples/regex_substitute.pl" %}

