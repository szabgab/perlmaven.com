---
title: "Forget your plan, just call done_testing"
timestamp: 2016-08-31T07:30:01
tags:
  - done_testing
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


I am not a fan of it, as I really like when my script knows how many tests it is going to run,
but sometimes it is really difficult to know up-front. It might depend on the number of
files in a directory. We might be able to compute the number at the beginning of our test-script,
but in some cases this might be too difficult.

In that case we can [test without a plan](/test-without-a-plan)
or we can call `done_testing`.


{% youtube id="dL2NVB07MpA" file="done-testing" %}

```perl
use strict;
use warnings;

use lib 'lib';
use MyTools;

use Test::More;

my $x = sum(1, 1);
is $x, 2,  '1+1';

my $y = sum(2, 2);
is $y, 4,  '2+2';

done_testing;
```

The output of such test-script is quite similar to the case when we used [no_plan](/test-without-a-plan).

```
ok 1 - 1+1
ok 2 - 2+2
1..2
```

The difference is that in this case we explicitly need to tell the testing environment that we have finished all the
tests. This means if we `exit()` early, even the line immediately before `done_testing()`
we won't get the plan printed at the end, instead we'll have a comment:

```
$ perl test.t
```

```
ok 1 - 1+1
ok 2 - 2+2
# Tests were run but no plan was declared and done_testing() was not seen.
```

If we use the [harness](/prove-the-harness) our test will be
reported as failed:

```
$ prove test.t
```

```
t/test.t .. 1/? # Tests were run but no plan was declared and done_testing() was not seen.
t/test.t .. Dubious, test returned 254 (wstat 65024, 0xfe00)
All 2 subtests passed 

Test Summary Report
-------------------
t/test.t (Wstat: 65024 Tests: 2 Failed: 0)
  Non-zero exit status: 254
  Parse errors: No plan found in TAP output
Files=1, Tests=2,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.11 cusr  0.01 csys =  0.17 CPU)
Result: FAIL
```


We will still disregard cases when a loop that was supposed to run 1000 times, testing 1000 things,
ran only 3 times, but it is a step up from `no_plan`.

Please don't overuse it.

