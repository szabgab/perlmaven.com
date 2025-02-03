---
title: "Implementing 'is_any' to test multiple expected values"
timestamp: 2016-09-13T07:30:01
tags:
  - Test::More
  - is_any
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


Previously we wrote a script to test the `dice()` function of our new start-up company. We made some nice
progress, but we found that we have almost exactly the same code several times in our script. We would like
to eliminate the duplication by moving the code in a subroutine called `is_any`.

`is_any` will receive 3 parameters: The first is the actual result of the function under test, the second is a reference
to an array listing all the acceptable values. The third is the optional name of the test.


{% youtube id="3U-H9Q5Jrac" file="is-any-to-test-multiple-expected-values" %}

Our original code looked like this:

```perl
my @expected = (1, 2, 3, 4, 5, 6, 7, 8);

for (1..4) {
    my $value = dice(8);
    ok( (any {$_ eq $value} @expected), 'correct number')
        or diag "Received: $value\nExpected:\n" .
            join "", map {"         $_\n"} @expected;
}
```


```perl
my @expected = (1, 2, 3, 4, 5, 6, 7, 8);

for (1..4) {
    my $value = dice(8);
    is_any($value, \@expected, 'correct number');
}

sub is_any {
    my ($actual, $expected, $name) = @_;
    $name ||= '';

    ok( (any {$_ eq $actual} @$expected), $name)
        or diag "Received: $actual\nExpected:\n" .
            join "", map {"         $_\n"} @$expected;
}
```

All we did is to move the 3 lines starting with the call to `ok` to a new function.
Renamed the variables a bit and used the new `is_any` function instead of the code
we had in the loop.

The full example looks like this:

```perl
use strict;
use warnings;

use MyTools;

use List::MoreUtils qw(any);

use Test::More tests => 8;


for (1..4) {
    my $n = 6;
    my @expected = (1..$n);
    my $value = dice($n);
    is_any($value, \@expected, 'correct number');
}


for (1..4) {
    my $n = 4;
    my @expected = (1..$n);
    my $value = dice($n);
    is_any($value, \@expected, 'correct number');
}


sub is_any {
    my ($actual, $expected, $name) = @_;
    $name ||= '';

    ok( (any {$_ eq $actual} @$expected), $name)
        or diag "Received: $actual\nExpected:\n" .
            join "", map {"         $_\n"} @$expected;
}
```

It looks nicer even though we wrote quite some extra code by having a temporary variable called
`$value` and another one called `@expected` in each loop.
Running this script will give an output that looks like this:

```
1..8
not ok 1 - correct number
#   Failed test 'correct number'
#   at t/dice_is_any.t line 33.
# Received: 5.5
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
not ok 6 - correct number
#   Failed test 'correct number'
#   at t/dice_is_any.t line 33.
# Received: 1.5
# Expected:
#          1
#          2
#          3
#          4
ok 7 - correct number
ok 8 - correct number
# Looks like you failed 2 tests of 8.
```

It looks quite similar to what we had earlier, except for the random numbers in the results,
but there is also an issue that we might first overlook.

## Where did this test fail?

In both failures the line number reported was 33. It is clear that one of the failures was about the 6-sided die,
while the other was about the 4-sided die, but they both reported the line number where the `ok` function was called.
Inside the `is_any` subroutine. This is not very useful.

If you are familiar with how some perl code can find out about its own call-stack using the `caller` function
then you won't be surprised that with the system behind the ok/is/like/is_deeply/etc. functions there is some code deep down
that knows exactly how far up in the call-stack was the actual function called. It even allows us to change this.
That allows us to tell the reporting function to go one step, one call-frame, further as we want to report the line
where the `is_any` function was called.

All we have to do is increment the value of the `$Test::Builder::Level` variable by one. We could use the `++`
autoincrement operator, but then the change would affect every place where we might call ok/is/like/etc...
We would like to limit it to the block containing the `is_any` functions, hence we localize it using the `local`
keyword: `local $Test::Builder::Level = $Test::Builder::Level + 1;`

```perl
sub is_any {
    my ($actual, $expected, $name) = @_;
    $name ||= '';

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    ok( (any {$_ eq $actual} @$expected), $name)
        or diag "Received: $actual\nExpected:\n" .
            join "", map {"         $_\n"} @$expected;
}
```

Running the test again, it will report the failures in the correct place where the `is_any` was called.


