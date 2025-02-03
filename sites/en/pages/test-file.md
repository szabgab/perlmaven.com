---
title: "A test file in Perl"
timestamp: 2017-04-08T08:00:11
tags:
  - test
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


Every package that you distribute via CPAN or internally should come with a bunch of tests.
There should be a directory called `t/` and within that directory there should be files
with `.t` extension.


<slidecast file="advanced-perl/libraries-and-modules/test-file" youtube="x6hWi89ZOtk" />

In earlier times there use to be a file called `test.pl` in the root of the distribution,
so i you encounter such file then you'd probably know this is an old-style distribution.
(Before 2002 or so.)

The `.t` files are regular Perl scripts, but their output is formatted as
[TAP, the Test Anything Protocol](/tap-test-anything-protocol).

A test script is really simple, it is just using your module and makes sure it works as expected.
That given specific input it provides the expected output.

A basic test script looks like this:

```perl
use strict;
use warnings;

use Test::More;

plan tests => 3;

use_ok('App');

ok(App::add(1, 1) == 2, "1+1 = 2");

is(App::add(2, 3),  5, "2+3 = 5");
```

After the usual `use strict; use warnings;` we load the [Test::More](https://metacpan.org/pod/Test::More) module.

The we declare our "plan" telling the system we are going to have 3 unit-tests, or 3 assertions.

I usually cal them "test units" becasue they are not necessarily "unit tests". Thy might test the interaction of
several subsystem. Stillthey would have some input and then we can check if the output matches th expected values.

In this script we have 3 cases.

The first one `use_ok('App');` is checking if the module can be loaded with a `use` statement.
Actually I think the use of `use_ok` is now discouraged. We should just load the module with regular `use App;`.
If something is wrong it will throw an exception anyway.

Then we call the `add` function of the `App` module and check if the result is indeed 2.

A better way to comparing real and expected values is by using the `is` function provided by Test::More.
That, in addition to checking if the real value is the same as the exected value, will also provide a detailed
report in case the result does not match.

