---
title: "How to calculate factorial in Perl - n!"
timestamp: 2015-04-02T16:30:01
tags:
  - List::Util
  - reduce
published: true
author: szabgab
archive: true
---


I was working on some examples when I had to calculate `factorial`.  (`n!` in math)


The solution without any modules:

{% include file="examples/factorial.pl" %}

The solution when using the `reduce` function of the
standard [List::Util](https://metacpan.org/pod/List::Util) module:

{% include file="examples/factorial_with_reduce.pl" %}

`reduce` will take the first two values of the list on the right hand side, assign them to
`$a` and `$b` respectively, execute the block.

Then it will take the result, assign it to `$a` and take the next element from the list,
assign it to `$b` and execute the block. This step will be repeated till the end of the list.

This code has two versions. The first one is more simple, but does not handle 0! properly.
The second works well for 0! as well.

