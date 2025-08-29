---
title: "The ternary operator in Perl"
timestamp: 2014-02-07T14:45:56
tags:
  - "?:"
published: true
books:
  - beginner
author: szabgab
---


The ternary operator is probably the saddest operator in the world. All the other operators have names,
such as addition, unary negation, or binary negation, but this one is only described by its syntax.

As in most languages, this is the only operator with 3 parameters. Most people don't know its real name.
Even though, when it was born, it was called the [conditional operator](http://en.wikipedia.org/wiki/%3F:).


## Unary, binary, ternary operators

A unary operator has 1 operand (-3).

A binary operator has 2 operands (2-3) or (4+5).

A ternary operator has 3 operands.

## The conditional operator

In Perl 5, as in most of the other programming languages, the **conditional operator** has 3 parts separated by `?` and `:`.

The first part, before the `?` is the condition. It is evaluated in boolean context.
If it is [true](/boolean-values-in-perl), the second part, between `?` and `:`
is evaluated and that is the final value of the expression.
Otherwise the third part is evaluated, and that is the value of the whole expression.

In general it looks like this:

```
CONDITION ? EVALUATE_IF_CONDITION_WAS_TRUE : EVALUATE_IF_CONDITION_WAS_FALSE
```

It is basically the same as

```
if (CONDITION) {
    EVALUATE_IF_CONDITION_WAS_TRUE;
} else {
    EVALUATE_IF_CONDITION_WAS_FALSE;
}
```

## Examples

Let's see a few examples:

```perl
use strict;
use warnings;
use 5.010;

my $file = shift;

say $file ? $file : "file not given"; 
```

If `$file` is true (the user passed a filename on the command line), this will print the name of the file.
Otherwise it will print the string "file not given".

```perl
my $x = rand();
my $y = rand();

my $smaller = $x < $y ? $x : $y;
say $smaller
```

In this example we pass the smaller value to `$smaller`.

## Setting a limit

For example our code receives a value from some `get_value()` function, but we want to make sure the
number does not exceed a certain limit:

```perl
my $MAX_LIMIT = 10;

my $value = get_value();
$value = $value <= $MAX_LIMIT ? $value : $MAX_LIMIT;
```

Of course we could write it in a different way as well:

```perl
$value = $MAX_LIMIT if $value > $MAX_LIMIT;
```

## Comments

Hi, Can i use file test operator eg "-e" "-r" "-d" eg if ( -e $filepath) in ternary operators

---

Try it!


