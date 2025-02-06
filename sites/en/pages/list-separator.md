---
title: $" $LIST_SEPARATOR
timestamp: 2020-09-23T19:30:01
tags:
  - $LIST_SEPARATOR
published: true
author: szabgab
archive: true
description: The $" variable, also called the $LIST_SEPARATOR indicates what goes between array elements when they are intepolated in a string.
show_related: true
---


The $" variable, also called the $LIST_SEPARATOR indicates what goes between array elements when they are intepolated in a string.



{% include file="examples/list_separator.pl" %}

By default it contains a single space, but you can replace it by any othere string. Including the empty string.

Unless you'd like to to impact the whole code-base it is recommended to wrap the assignment in a block (with curly braces)
and use [local](/local) to localize the change. (You cannot use <b>my</b> on this variable.)

Mnemonic: works in double-quoted context.

See also the [official documentation](https://metacpan.org/pod/perlvar#LIST_SEPARATOR).
