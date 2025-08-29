---
title: "Comparing complex data-structures using is_deeply"
timestamp: 2016-07-23T09:30:01
tags:
  - Test::More
  - is_deeply
published: true
types:
  - screencast
books:
  - testing
author: szabgab
---


So far we compared single scalar values to some expected value. What if your function returns an array, a hash, or a multi-dimensional
data structure consisting of lots of arrays and hashes? How can you compare that to some expected data structure?

[Test::More](https://metacpan.org/pod/Test::More) provides the `is_deeply` function for this.


{% youtube id="E1Peox8ZxFM" file="comparing-complex-data-structures-with-is-deeply" %}

We have a file called `MyTools.pm` (In order to let you try the example, the source code of this module is at the end of the article.).
And that module has two public functions. Given a number $N, `fibo($N)` will return the Nth number in the
[Fibonacci series](http://en.wikipedia.org/wiki/Fibonacci_number), and the function `fibonacci($N)` will return
an array reference of the first N elements in the series.

As the series is expected to be 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, ... we can test the `fibo` function easily.

We have the following code in `fib.t` in the same directory where `MyTools.pm` is found:

{% include file="examples/is_deeply/fib.t" %}

Then running `prove fib.t` will print:

```
fib.t .. 1/5
#   Failed test 'fib 5'
#   at fib.t line 12.
#          got: '7'
#     expected: '5'
# Looks like you failed 1 test of 5.
fib.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/5 subtests

Test Summary Report
-------------------
fib.t (Wstat: 256 Tests: 5 Failed: 1)
  Failed test:  5
  Non-zero exit status: 1
Files=1, Tests=5,  0 wallclock secs ( 0.04 usr  0.00 sys +  0.12 cusr  0.01 csys =  0.17 CPU)
Result: FAIL
```

I added a bug to the function on purpose so we can see how failures are reported.

This was the easy case as we had to compare only scalar values.


## is_deeply

Testing the `fibonacci()` function is the more interesting thing. It returns an ARRAY-reference.
That's the actual-value. The expected-value is also an array reference (in square brackets!) and
we use the `is_deeply` function to compare them.

{% include file="examples/is_deeply/fibonacci.t" %}

Running `prove fibonacci.t` will give the following result:

```
fibonacci.t .. 1/5 
#   Failed test 'fibonacci 5'
#   at fibonacci.t line 12.
#     Structures begin differing at:
#          $got->[2] = '4'
#     $expected->[2] = '2'
# Looks like you failed 1 test of 5.
fibonacci.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/5 subtests 

Test Summary Report
-------------------
fibonacci.t (Wstat: 256 Tests: 5 Failed: 1)
  Failed test:  5
  Non-zero exit status: 1
Files=1, Tests=5,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.12 cusr  0.01 csys =  0.16 CPU)
Result: FAIL
```

Here we can see that the test in line 12 called 'fibonacci 5' has failed. The 3rd element (index 2) of the received
array reference was the first value that differed from the corresponding value in the expected array reference.
`is_deeply` does not tell you if the rest of the array looked the same or not, but that's usually not that important
and failures, after the first one, might be the cascading effect of failures. It's usually better to focus on the first error
and then run the test again.

## is_deeply on a hash

In the previous example we saw how to test array references using `is_deeply`. Another interesting example
would be to see how it works when we expect a hash, or a hash reference.
MyTools has an additional function called `fetch_data_from_bug_tracking_system` that will return
a hash reference based on the number we pass to it. We have a variable called `%expected` with, well the expected data
structure, and we use `is_deeply` to compare the results.

`bugs.t` looks like this:

{% include file="examples/is_deeply/bugs.t" %}

Running `prove bugs.t` prints this result:

```
bugs.t .. 1/3 
#   Failed test 'Query 1'
#   at bugs.t line 20.
#     Structures begin differing at:
#          $got->{errors} = '9'
#     $expected->{errors} = '6'

#   Failed test 'Query 2'
#   at bugs.t line 23.
#     Structures begin differing at:
#          $got->{bugs} = Does not exist
#     $expected->{bugs} = '3'
# Looks like you failed 2 tests of 3.
bugs.t .. Dubious, test returned 2 (wstat 512, 0x200)
Failed 2/3 subtests 

Test Summary Report
-------------------
bugs.t (Wstat: 512 Tests: 3 Failed: 2)
  Failed tests:  2-3
  Non-zero exit status: 2
Files=1, Tests=3,  1 wallclock secs ( 0.03 usr  0.00 sys +  0.12 cusr  0.01 csys =  0.16 CPU)
Result: FAIL
```

The first case passed. In the second case the value of key `errors` was incorrect.
(We expected 6 but we got 9).
In the third case the actual result was missing one of the keys. We expected to have a key called
`bugs` but we did not have it in the actual result.

## Limitations of is_deeply

While it is a very good tool, `is_deeply` has a number of limitations. It requires the whole data structure to match
exactly. There is no place for any flexibility. For example what if one of the values is a time-stamp that we 
would like to disregard or what if we would like to match it with a regular expression?
What if there is an array reference where all we care about is that each element matches some regular expression,
but we don't even care how many elements are there. For example in the case of the `fetch_data_from_bug_tracking_system`
function, instead of expecting exact numbers, we might want to expect only the specific keys and "any numerical value".
There is another module called [Test::Deep](https://metacpan.org/pod/Test::Deep) that provides the solution.


## MyTools.pm

In order to make it easier for you to see the above code running, I have included the content of **MyTools.pm**:

{% include file="examples/is_deeply/MyTools.pm" %}

