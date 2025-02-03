---
title: "Test plan and test descriptions"
timestamp: 2015-11-11T16:30:01
tags:
  - Test::Simple
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


In the first steps we saw how a naive test script can lead us to the [use of Test::Simple](/introducing-test-simple).
This time we'll go on.


{% youtube id="uMtNpVAA1Fs" file="test-plan-and-test-descriptions" %}

Just to remind you, we have a file called `lib/MyCalc.pm` that we would like to test.
(See the code in [this article](/introducing-test-simple).)

The first thing we'll do is to remove the parentheses around the parameters of `ok()`.
Now that we are using a function imported before the first call to it, we don't need the parentheses any more.

```perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use MyCalc;

use Test::Simple tests => 3;

ok sum(1, 1) ==  2;
ok sum(2, 2) == 4;
ok sum(2, 2, 2) == 6;
```



In the last example we used Test::Simple and saw what the output looks like when one of the tests fails.

Let's comment out the failing test, and adjust the expected number of tests to see how it would look if everything
was ok. So `test.pl` now looks like this:

```perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use MyCalc;

use Test::Simple tests => 2;

ok sum(1, 1) ==  2 ;
ok sum(2, 2) == 4 ;
#ok sum(2, 2, 2) == 6 ;
```

Running `perl test.pl` will result in:

```
1..2
ok 1
ok 2
```

Nice and clean.

## Why do we need the test plan?

Why do we really need to explicitly say how many tests we are going to run? After all Test::Simple counts
the tests itself.

Now imagine you have have test suite with hundreds of tests. One of those fails. In order to fix the application you
will have to run the test script several times. The whole test script, even when focusing on the single failure.
In order to avoid that you might comment out all the later tests. You fix the failure, commit the changes to version control,
and then you get distracted by your manager. It can easily happen that the test file will remain there with the majority
of the test cases commented out.

In another case you might have a loop that should test 20 cases, but for some reason the loop exits after 2 successful iterations.

All the executed test cases are successful. When someone looks at the report she will see no indication that the majority of
the test cases were never executed.

On the other hand if we kept the planned test count at the original number (3 in our case), then even if all the test cases we ran
(2 in our case) were successful, we would get an indication that there is some problem.

Let's change the test plan back to 3 and run the test.pl script again. The output now looks like this:

```
1..3
ok 1
ok 2
# Looks like you planned 3 tests but ran 2.
```

There is a clear indication that something went wrong.

Just to show it, let's go back to the test script and change the test plan to 1 and run `perl test.pl` again.
The result is very similar:

```
1..1
ok 1
ok 2
# Looks like you planned 1 test but ran 2.
```

Running more tests than expected also generates this extra message. That's a good thing as this surplus of executed
tests might also indicate some issue. Probably with the test itself.


## Test names

In addition to the counting, and the reporting of a mismatch in the number of tests, the `ok()` function of
[Test::Simple](https://metacpan.org/pod/Test::Simple) also provides another feature. It accepts
a second parameter which is the name or title of the test case. It is usually a description of the specific case.
In most cases it can be some text, but our case is so simple we will just indicate the call we are testing.

The new test.pl file looks like this:

```perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use MyCalc;

use Test::Simple tests => 1;

ok sum(1, 1) == 2,    'sum(1, 1) = 2';
ok sum(2, 2) == 4,    'sum(2, 2) = 4';
ok sum(2, 2, 2) == 6, 'sum(2, 2, 2) = 6';
```

and the result of `perl test.pl` look like this:

```
1..1
ok 1 - sum(1, 1) = 2
ok 2 - sum(2, 2) = 4
not ok 3 - sum(2, 2, 2) = 6
#   Failed test 'sum(2, 2, 2) = 6'
#   at test.pl line 12.
# Looks like you planned 1 test but ran 3.
# Looks like you failed 1 test of 3 run.
```

It is now much easier to see which test fails.

As an exercise, please try to enlarge the test suite to have a lot more test cases.

