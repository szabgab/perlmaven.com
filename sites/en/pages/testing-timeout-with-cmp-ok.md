---
title: "Testing timeout with cmp_ok"
timestamp: 2016-06-06T22:30:01
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


As mentioned earlier in the [testing series](/testing), the `is()` function provided by
[Test::More](https://metacpan.org/pod/Test::More) compares the values using the string `eq` operator which is correct in 99% of the cases.
If you'd like to compare the values with the numerical `==` operator you can do it using the `cmp_ok`
which is also provided by [Test::More](https://metacpan.org/pod/Test::More).

More than that, with `cmp_ok` you can compare the two values with any operator, so you can check if the actual value is,
let's say, smaller than an expected value.

For example when measuring timeout, we cannot expect the result to be exact to the millisecond.


The `cmp_ok` function can get 3 or 4 parameters. `cmp_ok $actual, OPERATOR, $expected, TITLE`.
The TITLE is optional as in most of the other functions provided by Test::More. The OPERATOR can be any of the
binary operators. e.g. `==` or `gt`.  `$actual` is the actual value and `$expected`
something we compare it to.

{% youtube id="zZ6XmbTjINs" file="testing-timeout-with-cmp-ok" %}

Let's say we have a function called `wait_for_input_with_timeout` that accepts a number, the number of
seconds to wait for input before timing out. How can we test that this timeout really works?
We cannot really expect the system to wait exactly the given amount of seconds. After all there are all kinds of other things
going on in the computer. What we can expect is that it will time out at the given amount of seconds +/- some margin.

Then, based on the actual business-case, the margin will change. Our expectation for time-accuracy is quite different when
we click on the 'like'-button on a web-page, than when we wait for feedback from our airplane navigation system.

In order to show how to test this I created a function called `wait_for_input_with_timeout` which will wait
for a random number of seconds. Somewhere around the number passed to the function.

```perl
sub wait_for_input_with_timeout {
    sleep rand shift()+2;
}
```


In the test script we can then call the function and measure the elapsed time.

```perl
my $start = time;
wait_for_input_with_timeout(3);
my $end = time;

print $end-$start, "\n";
```

We can then use the `cmp_ok` function of [Test::More](http://metacpan.org/pod/Test::More) twice(!) to compare
the elapsed time to the minimum and maximum elapsed time we accept:


```perl
#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 2;

my $start = time;
wait_for_input_with_timeout(3);
my $end = time;

cmp_ok $end - $start, ">=", 2, "process was waiting at least 2 secs";
cmp_ok $end - $start, "<=", 3, "process was waiting at most 3 secs";

sub wait_for_input_with_timeout {
    sleep rand shift()+2;
}
```

That is, we expect the elapsed time to be up to 3 seconds (the number we passed to the function), and at least 2 seconds.

Running the script sometimes will print:

```
1..2
ok 1 - process was waiting at least 2 secs
ok 2 - process was waiting at most 3 secs
```

And sometimes, when the actual timeout is out of the accepted range:

```
1..2
not ok 1 - process was waiting at least 2 secs
#   Failed test 'process was waiting at least 2 secs'
#   at examples/intro/cmp_ok.t line 11.
#     '0'
#         >=
#     '2'
ok 2 - process was waiting at most 3 secs
# Looks like you failed 1 test of 2.
```

Using `cmp_ok` we can compare two values with any operator we like.


