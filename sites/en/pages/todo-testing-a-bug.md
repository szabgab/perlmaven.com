---
title: "TODO - testing a bug or a future feature"
timestamp: 2016-05-21T00:30:01
tags:
  - Test::More
  - TODO
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


So far we kept running a test script that always failed because the application had a bug. This of course will happen in the real world too.
You get a bug report. In order to verify it, you write a test-case reproducing the situation. This test case will fail.
Many times you can't immediately get the bug fixed. Either because the programmer who needs to fix the bug is not available, or there are
more urgent tasks.

The question what do you do now?


{% youtube id="ildayXLOhR8" file="todo-testing-a-bug" %}

If you leave the test-case in the test-suite you'll keep getting test failures. This is not good
as every time, every person running the test-suite will have to stop thinking "ok, this test case is known to fail". That's both a waste
of time and as the number of such failing test-cases grows you'll slowly accept that "there are failing tests".

At that point the test-suite has lost all its value. You will not notice when one of the test-cases that was successful earlier
starts to fail too.

The other option would be to comment out or even to delete the test case. Deleting would be just crazy, after all you worked hard
to create the test-case. Commenting out could be ok, but there is a much better solution.

You can mark the test-case (or test-cases) as `TODO` tests. They will still be executed, and they will be still reported as
failures by the test-script, but [prove, the harness](/prove-the-harness) will see that these tests were
**expected to fail** and will not consider them as failures. If someone fixes the problem, or creates a situation that might hide
the problem, **prove** will even report that one of the TODO-tests has passed. Allowing you to make further research, and decide
what should happen.

This way tests that check bugs that have not been fixed yet, or features that have not been implemented yet, won't bother you in
the normal, day-to-day routine of running tests, while you can easily get a list of all these TODO tests.


## TODO example

Lets' see how to use this:

This is the module that is being tested, the content of `lib/MyCalc.pm`:
I put it here so you can easily try the example.

```perl
package MyCalc;
use strict;
use warnings;

use base 'Exporter';
our @EXPORT = qw(sum);

sub sum {
    return $_[0] + $_[1];
}

1;
```


This is the test script, the content of `t/test.t`:

```perl
use strict;
use warnings;

use lib 'lib';
use MyCalc;

use Test::More tests => 4;

is(sum(1, 1),    2,  '1+1');
is(sum(2, 2),    4,  '2+2');
is(sum(2, 2, 2), 6,  '2+2+2');
is(sum(-2, 2),   0,  '-2+2');
```

If we run this test script using `perl t/test.t`
we get the following output:

```
1..4
ok 1 - 1+1
ok 2 - 2+2
not ok 3 - 2+2+2
#   Failed test '2+2+2'
#   at t/test.t line 11.
#          got: '4'
#     expected: '6'
ok 4 - -2+2
# Looks like you failed 1 test of 4.
```


If we run it with `prove t/test.t`:

```
t/test.t .. 1/4 
#   Failed test '2+2+2'
#   at t/test.t line 11.
#          got: '4'
#     expected: '6'
# Looks like you failed 1 test of 4.
t/test.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/4 subtests 

Test Summary Report
-------------------
t/test.t (Wstat: 256 Tests: 4 Failed: 1)
  Failed test:  3
  Non-zero exit status: 1
Files=1, Tests=4,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.02 cusr  0.00 csys =  0.07 CPU)
Result: FAIL
```


```perl
use strict;
use warnings;

use lib 'lib';
use MyCals;

use Test::More tests => 4;

is(sum(1, 1),    2,     '1+1');
is(sum(2, 2),    4,     '2+2');
TODO: {
    local $TODO = "fix bug summing more than 2 values #173";
    is(sum(2, 2, 2), 6,  '2+2+2');
}
is(sum(-2, 2),   0,  '-2+2');
```

Running `perl t/test.t` will still report the error, but it will also mark it as `TODO`:

```
1..4
ok 1 - 1+1
ok 2 - 2+2
not ok 3 - 2+2+2 # TODO fix bug summing more than 2 values #173
#   Failed (TODO) test '2+2+2'
#   at t/test.t line 13.
#          got: '4'
#     expected: '6'
ok 4 - -2+2
```

Running `prove t/test.t` will show the following output:

```
t/test.t .. ok   
All tests successful.
Files=1, Tests=4,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.02 cusr  0.00 csys =  0.05 CPU)
Result: PASS
```

As you can see the failing test, that has been marked as a TODO-test, does not interfere with the otherwise
successful test-run.

## TODO explained

Let's take a quick look:

```perl
TODO: {
    local $TODO = "fix bug summing more than 2 values #173";
    is(sum(2, 2, 2), 6,  '2+2+2');
}
```

The test-case, or the test-cases that are currently failing, and that are not expected to be fixed
soon (maybe they were delayed for the next release of the application), are wrapped in a block.
The block gets a name by adding `TODO:` before the block. The first statement in the block
is then giving an explanation why these tests are marked as TODO. This can have some text and if
you have a bug-tracking system, then it could be a good idea to add the number of the bug/ticket
explaining this. That will make it easier for a future reader to associate this test case with the
information in the bug-tracking system. This explanation is assigned to the localized `$TODO`
variable.

We can have more than one `ok`, `is`, etc. calls within a TODO-block, and we can have
more than one TODO-block in a test-script.


## Unexpected success

What if someone fixes the application but forgets to update the tests? What if someone changes the application that
now hides the failure. In other words, what if a test-case wrapped in a TODO-block passes?

Let's assume someone has fixed the sum function of `lib/MyCalc.pm` and ran the test again:
`prove t/test.t`

The output will look like this:

```
t/test.t .. ok   
All tests successful.

Test Summary Report
-------------------
t/test.t (Wstat: 0 Tests: 4 Failed: 0)
  TODO passed:   3
Files=1, Tests=4,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.02 cusr  0.00 csys =  0.05 CPU)
Result: PASS
```

On the one hand, the harness will report success, after all, the tests that were expected to pass have indeed passed,
but it will also report that one of the TODO-tests has passed. (It reports the numbers of the test-cases.)
 
Now you can go and investigate what happened. If the developers have indeed fixed the bug, you can remove the
TODO wrapper and start expecting this test to pass. On the other hand if this was due to the bug being hidden
that means there is probably some other bug in the system. You'd better write a test-case for that bug too.

