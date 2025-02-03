---
title: "Multiple expected values - testing dice"
timestamp: 2016-09-07T15:30:01
tags:
  - Test::More
  - cmp_ok
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


In our application there is a function called `dice()` that when called will return a whole number between 1 and 6.
Just as a normal die would do. How can we test this?


{% youtube id="gi6ICYTwkPo" file="multiple-expected-values" %}

As we already know about the [cmp_ok](/testing-timeout-with-cmp-ok) function of Test::More we can quickly write a test script using it:

```perl
use strict;
use warnings;

use MyTools;

use Test::More tests => 2 * 4;

for (1..4) {
    my $value = dice();
    cmp_ok $value, '>=', 1, 'bigger than 1';
    cmp_ok $value, '<=', 6, 'smaller than 6';
}
```

We run the script using `perl -Ilib t/dice_cmp_ok.t` and get the following output:

```perl
1..8
ok 1 - bigger than 1
ok 2 - smaller than 6
ok 3 - bigger than 1
ok 4 - smaller than 6
ok 5 - bigger than 1
ok 6 - smaller than 6
ok 7 - bigger than 1
ok 8 - smaller than 6
```

Everything looks ok. We ship the product.

Then the bug reports start to arrive. People complaining about strange behavior. As if the die was broken.
After long hours of running after the bug we decide to amend the above test script by a call to `diag $value;`
to see the real values returned by the `dice()` function. To our surprise we see values such as 1.5, 2.5, etc.

We can now run and fix the bug in our application, but before we do that, we should also improve our test script.
We need a way to check if `$value` returns one of the values: `1, 2, 3, 4, 5, 6`.

## List::MoreUtils any

We can use the built in [grep](/filtering-values-with-perl-grep) function as follows:

```perl
if (grep { $value == $_ } (1, 2, 3, 4, 5, 6)) {
}
```

Even though the code looks exactly the same, it is probably more expressive to
use the `any` function provided by [List::MoreUtils](https://metacpan.org/pod/List::MoreUtils).

```perl
use List::MoreUtils qw(any);

if (any { $value == $_ } (1, 2, 3, 4, 5, 6)) {
}
```

We can use these expressions in our test script as follows:

```perl
use strict;
use warnings;

use MyTools;

use List::MoreUtils qw(any);

use Test::More tests => 4;

for (1..4) {
    my $value = dice();
    ok( (any {$_ eq $value} (1, 2, 3, 4, 5, 6)), 'correct number');
}
```

Running this will result in the following output:

```
1..4
not ok 1 - correct number
#   Failed test 'correct number'
#   at t/dice_any.t line 14.
ok 2 - correct number
not ok 3 - correct number
#   Failed test 'correct number'
#   at t/dice_any.t line 14.
ok 4 - correct number
# Looks like you failed 2 tests of 4.
```

OK, so we can now see that there is some problem, but we cannot yet see the actual results.
We could add back the `diag $value;` as we did earlier, but there is really no point in printing
out the value in every case. Only in case of failure.

## Provide failure diagnostics

All the test-functions provided by Test::More return their truth-value. That is, they will return either
[true or false](/boolean-values-in-perl). We can use this information to improve our test script.
We use the [short-circuiting](/short-circuit) feature of the `or` operator to execute
some code only when a specific test case failed. In that case we call `diag` and print out the received
value.

```perl
use strict;
use warnings;

use MyTools;

use List::MoreUtils qw(any);

use Test::More tests => 4;

for (1..4) {
    my $value = dice();
    ok( (any {$_ eq $value} (1, 2, 3, 4, 5, 6)), 'correct number')
        or diag "Received: $value\n";
}
```

Running this test script will generate the following output:

```
1..4
not ok 1 - correct number
#   Failed test 'correct number'
#   at t/dice_any_diag.t line 16.
# Received: 1.5
ok 2 - correct number
ok 3 - correct number
ok 4 - correct number
# Looks like you failed 1 test of 4.
```

This is much better. Now we can go and fix the `dice()` function and our test will work much better than earlier.
(We are still unlikely to actually encounter one of the problematic cases, so we might prefer to run the above
test 100 times and not only 4 times.)


## The 8-sided dice

What if our marketing team comes to the conclusion that we need to generalize the `dice()` function and let it handle
dice with all kinds of sizes? As developers we'll have to provide a solution for the dice() function itself, but as a tester
we need to be able to test it.

The decision is that calling `dice($N)` with any number will return a random whole number between `1 .. $N`.
Testing this is simple for specific values of `$N`. We just need to copy-paste our previous solution:

```perl
use strict;
use warnings;

use MyTools;

use List::MoreUtils qw(any);

use Test::More tests => 4*2;

for (1..4) {
    my $value = dice(6);
    ok( (any {$_ eq $value} (1, 2, 3, 4, 5, 6)), 'correct number')
        or diag "Received: $value\n";
}

for (1..4) {
    my $value = dice(8);
    ok( (any {$_ eq $value} (1, 2, 3, 4, 5, 6, 7, 8)), 'correct number')
        or diag "Received: $value\n";
}
```

Besides the fact that we now have a lot of duplicated code, when we receive a failed test
we'll have to rely on line numbers to know if this was a 6-sided dice or an 8-sided dice.
It would be much better to print the expectation as well. Given that each list of expected numbers is
between 1 and some $N, we could change our code to say so in words:

```perl
    ok( (any {$_ eq $value} (1, 2, 3, 4, 5, 6)), 'correct number')
        or diag "Received: $value\nExpected number between 1-6\n";
```

That would work, but we would still have a lot of copies of the same code and we have a chance to solve
a much more interesting problem. What if the list of values is not numbers from 1 to some $N, but some
arbitrary list of values? In that case, the information about the expected values should list all the expected values.
In order to make it easier we put the expected values in an array and use it both with the `any` function
and when printing the expected values. We have also replaced the `==` operator with the `eq` operator in the
`any` expression. It does not have an effect on our case of numbers between 1..$N, but it provides a more generic
way to compare scalar values.

```perl
my @expected = (1, 2, 3, 4, 5, 6);

for (1..4) {
    my $value = dice();
    ok( (any {$_ eq $value} @expected), 'correct number')
        or diag "Received: $value\nExpected:\n" .
            join "", map {"         $_\n"} @expected;
}
```

The full code then looks like this:

```perl
use strict;
use warnings;

use MyTools;

use List::MoreUtils qw(any);

use Test::More tests => 4*2;

my @expected = (1, 2, 3, 4, 5, 6);

for (1..4) {
    my $value = dice(6);
    ok( (any {$_ eq $value} @expected), 'correct number')
        or diag "Received: $value\nExpected:\n" .
            join "", map {"         $_\n"} @expected;
}

my @expected = (1, 2, 3, 4, 5, 6, 7, 8);

for (1..4) {
    my $value = dice(8);
    ok( (any {$_ eq $value} @expected), 'correct number')
        or diag "Received: $value\nExpected:\n" .
            join "", map {"         $_\n"} @expected;
}
```

The output from this code looks like this:

```
1..4
not ok 1 - correct number
#   Failed test 'correct number'
#   at t/dice_any_diag.t line 16.
# Received: 1.5
# Expected:
#          1
#          2
#          3
#          4
#          5
#          6
ok 2 - correct number
ok 3 - correct number
ok 4 - correct number
ok 5 - correct number
ok 6 - correct number
not ok 7 - correct number
#   Failed test 'correct number'
#   at t/dice_any_diag.t line 24.
# Received: 3.5
# Expected:
#          1
#          2
#          3
#          4
#          5
#          6
#          7
#          8
ok 8 - correct number
# Looks like you failed 2 test of 8.
```

Next time we'll do some refactoring and wrap the 3 lines of code:

```perl
    ok( (any {$_ eq $value} @expected), 'correct number')
        or diag "Received: $value\nExpected:\n" .
            join "", map {"         $_\n"} @expected;
```

in a generic function.

