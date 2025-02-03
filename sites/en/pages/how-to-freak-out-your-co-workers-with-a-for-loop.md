---
title: "How to freak-out your co-workers with a for loop?"
timestamp: 2014-01-17T19:30:01
tags:
  - for
published: true
author: szabgab
---


Think twice before you do something like this in production code!

And then don't do it!


## Calculating the Fibonacci series

Here is one strange way to print the values of the Fibonacci series:

```perl
use strict;
use warnings;
use 5.010;

my @fibo = (1, 1);
for my $f (@fibo) {
     say $f;
     push @fibo, $fibo[-1]+$fibo[-2];
}
```

We run with a for-loop on the array `@fibo`, and at every iteration we also extend it.

If you run this, you will get an infinite number of the Fibonacci series, or your computer runs out of memory.
Whatever comes first.

If you want to try it, write this:

```perl
use strict;
use warnings;
use 5.010;

my @fibo = (1, 1);
for my $f (@fibo) {
     say $f;
     push @fibo, $fibo[-1]+$fibo[-2];

     last if $f > 50;
}

say "@fibo";
```

This way it will stop when the current number passes 50:

```
1
1
2
3
5
8
13
21
34
55
1 1 2 3 5 8 13 21 34 55 89 144
```

## Removing elements from the list while looping over it

This is much more fun to pull on a co-worker:

```perl
use strict;
use warnings;
use 5.010;

my @numbers = (1, 2, 3, 4);
for my $n (@numbers) {
    say $n;
    if ($n == 2) {
        splice @numbers, 1, 1;
    }
}

say "@numbers";
```

```
1
2
4
1 3 4
```


