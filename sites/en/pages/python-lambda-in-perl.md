---
title: "Python Lambda in Perl creating anonymous functions"
timestamp: 2014-01-08T18:30:01
tags:
  - lambda
  - sub
published: true
author: szabgab
---


Python has a tool called `lambda` that allows to create anonymous functions on the fly.



In the following example the `make_incrementor` function returns a new, anonymous function.

## In Python using lambda

```python
def make_incrementor(n):
    return lambda x: x + n

f3 = make_incrementor(3)
f7 = make_incrementor(7)

print(f3(2))    #  5
print(f7(3))    # 10
print(f3(4))    #  7
print(f7(10))   # 17
```

## In Perl using anonymous functions

```perl
use strict;
use warnings;
use 5.010;

sub make_incrementor {
    my ($n) = @_;
    return sub {
        my ($x) = @_;
        return $x + $n; 
    }
}

my $f3 = make_incrementor(3);
my $f7 = make_incrementor(7);

say $f3->(2);    #  5
say $f7->(3);    # 10
say $f3->(4);    #  7
say $f7->(10);   # 17
```

In this code, the variable `$n` stays alive even after the call to `make_incrementor` ends
as it is referenced from the anonymous function returned by `make_incrementor`.

`$f3` and `$f7` are references to the anonymous functions generated and returned by `make_incrementor`.
If we printed out the content of these variables using `say $f3` we would get something like this: `CODE(0x7fe9738032b8)`
revealing the fact that they are indeed references to executable code.

The way to de-reference them is to write: `$f3->(2)`. 


## Perl without extra local variable

```perl
sub make_incrementor {
    my ($n) = @_;
    return sub { $n + shift }
}
```

This could be use to replace the above implementation of the `make_incrementor`.




