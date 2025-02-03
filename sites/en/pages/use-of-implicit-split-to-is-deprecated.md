---
title: "Use of implicit split to @_ is deprecated ..."
timestamp: 2019-03-31T09:30:01
tags:
  - split
published: true
author: szabgab
archive: true
---


This warning has disappeared in Perl 5.12, but if you still use an older version of Perl you might encounter it.


The basic code looks like this:

```perl
my $x = split /,/, $str;
```

The problem is that `split` always returnes a list of values and if you assign it to a scalar value then
at one point perl used to try to guess what you wanted to do.
It would assign the results of the `split` to the `@_` variable <b>implicitly</b> and then use that
in scalar context.

{% include file="examples/split.t" %}

