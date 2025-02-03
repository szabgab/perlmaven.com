---
title: "join"
timestamp: 2013-02-04T12:45:56
tags:
  - join
published: true
books:
  - beginner
author: szabgab
---


I guess there is not much to say about the `join` function except that
it is the counterpart of the `split` function.


This function can take several elements of a list or an array and join them together into a string.

```perl
use strict;
use warnings;
use v5.10;

my @names = ('Foo', 'Bar', 'Moo');
my $str = join ':', @names;
say $str;                       # Foo:Bar:Moo

my $data = join "-", $str, "names";
say $data;                      # Foo:Bar:Moo-names


$str = join '', @names, 'Baz';
say $str;                       # FooBarMooBaz
```

The first parameter of the <b>join</b> function is the "connector",
the string that will be connecting all the other parameters.
The rest of the parameters of join will be flattened to a
list and the elements will be glued together with the given "connector".

This "connector" can be any string, even the empty string.

## Comments

Addition: you can also feed 'join' a list, as is shown here: https://perlmaven.com/sorting-mixed-strings

Thanks this is what i was looking for!
