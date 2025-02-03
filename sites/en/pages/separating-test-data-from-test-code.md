---
title: "Separating test data from test code"
timestamp: 2016-03-29T20:30:01
tags:
  - Test::Simple
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


In the earlier articles we have invested quite some energy in moving all the data from within the test code
to a [separate array](/refactoring-large-test-suite-separating-data-from-code) and then
we dealt with the [issue of counting](/test-without-a-plan).

In this article we will go further and move the data into a separate file.


{% youtube id="DxYrs6Ur1aY" file="separating-test-data-from-test-code" %}

We can create an arbitrary format like this:

```
2 = 1, 1
4 = 2, 2
6 = 2, 2, 2
6 = 3, 3

# negative

-2 = -1, -1

# edge cases
0 = 1, -1
```

In this format we put the parameters sent to the `sum()` function to the right of the `=` sign, and put the expected value
to the left. Then we also need to update our test script to read the test cases from this file:

```perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use MyCalc;

my @cases;
BEGIN {
    my $file = "$FindBin::Bin/sum.txt";
    open my $fh, '<', $file or die "Could not open '$file': $!";

    while (my $line = <$fh>) {
        chomp $line;
        next if $line =~ /^\s*(#.*)?$/;
        my @data = split /\s*[,=]\s*/, $line;
        push @cases, \@data;
    }
}

use Test::Simple tests => scalar @cases;

for my $c (@cases) {
    my ($exp, @params) = @$c;
    my $descr = 'sum(' . join(', ', @params) . ") == $exp";
    ok sum(@params) == $exp, $descr;
}
```

The only part we changed here is the part inside the `BEGIN` block where we read in,
and parse the content of the <b>sum.txt</b> file, and then create the `@cases` array
in the same format as we used to have when we had the data in the script.


## Fit - Framework for Integrated Test

This brings us to the idea of [Fit](http://fit.c2.com/) (also on [Wikipedia](http://en.wikipedia.org/wiki/Framework_for_integrated_test)).
It has various implementations, but I think the idea is more important than any of the implementations.

The idea is that there are people who are "domain experts", in our case people who know what the "sum function" should return,
and there are programmers who can interact with the application under test (AUT). Unless we are writing low level unit-tests,
these two group of people don't necessarily overlap.

If we can separate the data (input and expected output) we need for the test from the code that actually interacts with the
application, then we can improve our environment a lot. The domain experts can provide input in some format
comfortable for them. It could even be an spreadsheet using Excel or Open Office.

The programmers can then focus on writing the code to exercise the input data and compare the results to the expected output.

## Exercise

Your exercise is now to enlarge the test-suite, to add more test cases to the sum.txt file.

