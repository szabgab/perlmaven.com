---
title: "ord"
timestamp: 2021-03-17T15:30:01
tags:
  - ord
  - utf8
published: true
author: szabgab
archive: true
show_related: true
---


Returns the numeric value of the first character of EXPR. If EXPR is an empty string, returns 0. If EXPR is omitted, uses [$_](/the-default-variable-of-perl).


## When utf8 is properly set

{% include file="examples/ord_utf8.pl" %}

## When utf8 is not set

{% include file="examples/ord.pl" %}

* [Spanish ñ](https://www.compart.com/en/unicode/U+00F1)
* [Hungarian ű](https://www.compart.com/en/unicode/U+0171)
* [Hebrew Aleph](https://www.compart.com/en/unicode/U+05D0)
* [Hebrew Bet](https://www.compart.com/en/unicode/U+05D1)
* [Arabic 3](https://www.compart.com/en/unicode/U+0663)


See also the [chr](/chr) function as the opposite of <b>ord</b>.
