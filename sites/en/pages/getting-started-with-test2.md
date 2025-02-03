---
title: "Getting started testing Perl module with Test2"
timestamp: 2019-04-19T12:30:01
tags:
  - Test2
  - Test2::V0
  - ok
  - is
  - prove
published: true
author: szabgab
archive: true
---


[Test2](https://metacpan.org/pod/Test2) is a relatively new framework for testing Perl code.

Let's see how to get started with it, or more specifically with
[Test2::V0](https://metacpan.org/pod/Test2::V0).


Before you can use it you need to install it on your computer. Look for one of the articles
explaining [how to install Perl Modules](/archive).

```
cpanm Test2
```


## Project directory structure

Our files use the following directory structure. This is the standard layout for Perl code.
At least code that reaches CPAN.

```
├── lib
│   └── App.pm
└── t
    ├── 01-test.t
    ├── 02-test.t
    └── 03-test.t
```


The application under test is very simple:

{% include file="examples/test2-first/lib/App.pm" %}

If you look closely you might notice a bug in the code. That's on purpose, so we can easily show
failing tests.

Anyway the first test we write looks like this:

{% include file="examples/test2-first/t/01-test.t" %}

The heart of the test is calling the function of the application under test and comparing it to the expected
value.
The `ok` function provided by the Test2::V0 module accepts a boolean value and displays `ok` or
`not ok` according to the truth value of the expression.


`done_testing` indicates that we successfully reached the end of our tests. This helps us avoid an
early exit from the test script that might hide many failing tests.

We can run the tests using the `prove` command:

```
$ prove -l t/01-test.t
```

The output will look like this:

```
t/01-test.t ..
t/01-test.t .. ok
All tests successful.
Files=1, Tests=1,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.06 cusr  0.01 csys =  0.09 CPU)
Result: PASS
```


## Showing errors

The observer might notice that the above success was a happy (or not so happy?) coincidence.
With almost any other pair of input values the test would fail.

Let's see what happens when we add another test case. (I've created a separate test file so you can see it
in full.

{% include file="examples/test2-first/t/02-test.t" %}

Let's run it:

```
$ prove -l t/02-test.t
```

The result looks like this:

```
t/02-test.t .. 1/?
# Failed test at t/02-test.t line 5.
# Seeded srand with seed '20190419' from local date.
t/02-test.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/2 subtests

Test Summary Report
-------------------
t/02-test.t (Wstat: 256 Tests: 2 Failed: 1)
  Failed test:  2
  Non-zero exit status: 1
Files=1, Tests=2,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.07 cusr  0.00 csys =  0.09 CPU)
Result: FAIL
```

We can see that something has failed. We can even see the number of the failed test is 2,
but we can do better than that.


## Test failure with details

Instead of using the `ok` function that accepts a boolean we used the `is`
function provided by Test2::V0. It accepts two values. We pass to it the the real result of
an operation followed by expected value.

{% include file="examples/test2-first/t/03-test.t" %}

Let's run it:

```
prove -l t/03-test.t
```

The result looks like this:

```
t/03-test.t .. 1/?
# Failed test at t/03-test.t line 5.
# +-----+----+-------+
# | GOT | OP | CHECK |
# +-----+----+-------+
# | 12  | eq | 7     |
# +-----+----+-------+
# Seeded srand with seed '20190419' from local date.
t/03-test.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/2 subtests

Test Summary Report
-------------------
t/03-test.t (Wstat: 256 Tests: 2 Failed: 1)
  Failed test:  2
  Non-zero exit status: 1
Files=1, Tests=2,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.07 cusr  0.00 csys =  0.09 CPU)
Result: FAIL
```

Not only can you see the failure, it also tells us what was the received value (GOT) and
what was the expected value (CHECK). It also tells us that the operator used to compare the two
values was `eq`. While it is not ideal for numbers, it is good in most cases
even when we are comparing numbers.


In any case this is pretty nice.

## About Test2

For more information see also the [Test2-Suite](http://test-more.github.io/Test2-Suite/) by Chad 'Exodist' Granum.


## Comments

Even better would be to make use of the optional parameter to `is()` (and `ok()`), namey the description of the test, e.g.

    is( App::add(3, 4), 7 , "add(3, 4) = 3+4 = 7");


