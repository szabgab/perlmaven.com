---
title: "What is the status of the current test script?"
timestamp: 2016-03-21T19:00:01
tags:
  - Test::Builder
  - Test::More
  - is_passing
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


The other day I looked at the tests of the [Expect](https://metacpan.org/pod/Expect) module, and was surprised to see that it
was still using the old-style, home-brewed testing system. Something like the one we used when we introduced
[test automation](/introducing-test-simple). I wanted to convert it to use [Test::More](http://metacpan.org/pod/Test::More),
but in addition to an `ok()` function, this home-made system had unique functionality.

At the end of the script it printed a message something along the lines of "Don't worry if a test fails, this can happen.", but it was only printed
if any of the ok() functions of the test script failed.

I wanted to preserve this functionality.


{% youtube id="limsGlhl-9o" file="what-is-the-status-of-the-current-test-script" %}

In addition, I know there are many people who are not very familiar with Perl yet, who are helpless when
a test fails. It might be an interesting idea to add a message that explains how to report the problem,
and how to install the module even if some of the tests fail. After all, a test failure does not necessarily
mean the module is totally useless.

Let's start with a test script called `status.t` with the following content:

```perl
use strict;
use warnings;
use Test::More tests => 3;

ok 1;
ok 1;
ok 1;
```

It does not test anything, it just prints `ok` 3 times, but it can be useful to experiment with.
The output of `perl status.t` looks like this:

```
1..3
ok 1
ok 2
ok 3
```

Nothing special.

If we change the second call to `ok` and pass a false statement to it (`ok 0;`) the result changes to:

```
1..3
ok 1
not ok 2
#   Failed test at status.t line 6.
ok 3
# Looks like you failed 1 test of 3.
```


## is_passing of Test::Builder

Behind all the `Test::*` infrastructure lies the [Test::Builder](https://metacpan.org/pod/Test::Builder) module.
It does all the counting and reporting that we saw from [Test::Simple](https://metacpan.org/pod/Test::Simple)
and friends. We can also access the `Test::Builder` object during the test run. We only need 3 things:

Load `Test::Builder` with `use`. Call the `new` method. As it is a singleton, it will return the only `Test::Builder` object available in a process.
Then the `is_passing` method will return [true or false](/boolean-values-in-perl). It will return `true`, as long
as one of the `ok()` assertions has not failed.

```perl
use Test::Builder;
my $Test = Test::Builder->new;
diag $Test->is_passing;
```

Adding it to our real code we will get the following:

```perl
use strict;
use warnings;
use Test::More tests => 3;

ok 1;
ok 0;
ok 1;

use Test::Builder;
my $Test = Test::Builder->new;
if (not $Test->is_passing) {
    diag 'Please report test failures to support@...';
    diag 'In the meantime you can install the module disregarding the test results using "cpanm --notest"';
}
```

```
1..3
ok 1
not ok 2
#   Failed test at status.t line 6.
ok 3
# Please report test failures to support@...
# In the meantime you can install the module disregarding the test results using "cpanm --notest"
# Looks like you failed 1 test of 3.
```

Of course if we now change that `ok 0` to `ok 1`, and run the script again we will get only
the success report:

```
1..3
ok 1
ok 2
ok 3
```

## Caveats of is_passing

There are a few issues with `is_passing` though.
If no tests were executed it will report success, but `Test::Harness` would actually report failure.
If all the tests are successful, but the actual number of tests is smaller than the test plan, `is_passing`
will still return true. (Interestingly, if the actual number of tests is bigger than the planned number
then it will notice the problem.)

Let's try some other tools.

## The plan: expected_tests and summary

`Test::Builder` provides a few more methods that we can use. For example there is the `expected_tests` method
that returns the number of tests planned. In our case it will return 3.

In addition there is also the `summary` method that returns an array of true/false values for each `ok()` call
executed so far.

So we can add the following 3 lines to compare the expected number of tests with the
number of successes.

```perl
my $cnt = 0;
for ($Test->summary) { $cnt++ if $_ } 
diag $cnt == $Test->expected_tests ? 'success' : 'failure';
```

In the full script it might look like this:


```perl
use strict;
use warnings;
use Test::More tests => 4;

use Test::Builder;
my $Test = Test::Builder->new;

ok 1;
ok 0;
ok 1;


my $cnt = 0;
for ($Test->summary) { $cnt++ if $_ } 
diag $cnt == $Test->expected_tests ? 'success' : 'failure';
```

Unlike the `is_passing` method, this method will provide the correct answer even if the number of tests executed
does not match the planned number.


## Caveat

Of course none of this will help if for some reason the test script exits early,
or if it never runs because another script bails out. The former could be solved by
putting the code in the `END`-block, the latter, by putting the block in every
test script.

