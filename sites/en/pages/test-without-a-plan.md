---
title: "Test without a Plan"
timestamp: 2016-03-26T20:30:01
tags:
  - Test::Simple
  - no_plan
  - BEGIN
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


We left the [previous article](/refactoring-large-test-suite-separating-data-from-code)
with a small issue involving lack of [DRY](http://en.wikipedia.org/wiki/Don't_repeat_yourself)-ness.

The slight problem was that we hard-coded the number of tests in the `use Test::Simple tests => 5;` expression.
If we now add a new test-entry to the `@cases` array, we have to remember to update the test plan as well.

Not a big issue, but we as programmers are supposed to avoid any such repetition. So how can we do that?


{% youtube id="WU_K-zx5qNw" file="test-without-a-plan" %}

This was the code from the previous article.

```perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use MyCalc;

my @cases = (
    [2,  1, 1],
    [4,  2, 2],
    [6,  2, 2, 2],
# negative numbers
    [-2, -1, -1],
# edge cases:
    [0,  1, -1],
);

use Test::Simple tests => 5;

for my $c (@cases) {
    my ($exp, @params) = @$c;
    my $descr = 'sum(' . join(', ', @params) . ") == $exp";
    ok sum(@params) == $exp, $descr;
}
```

The obvious solution would be to write:

```perl
use Test::Simple tests => scalar @cases;
```

Unfortunately it would be also incorrect.

If we ran the test script we would get the following output:

```
You said to run 0 tests at test.pl line 18.
BEGIN failed--compilation aborted at test.pl line 18.
```

The problem is that while the declaration `my @cases;` takes place
during the compilation phase of running the perl script, the assignment
to the array will only take place in the run-phase. On the other hand
the whole line `use Test::Simple tests => scalar @cases;` will be
evaluated at the compilation phase. At that time the `@cases` is
already declared but still empty. So we declare that we are going to run 0 tests.

That's not good. Let's look for other solutions.

## no_plan

The expected number of tests is also usually referred to as **the plan**.
[Test::Simple](http://metacpan.org/pod/Test::Simple) actually allows us to run
the tests without any **plan**. We only need to tell it that we have `no_plan`.

Let's try this:

```perl
use Test::Simple 'no_plan';
```

if we run the script we get the following output:

```
ok 1 - sum(1, 1) == 2
ok 2 - sum(2, 2) == 4
not ok 3 - sum(2, 2, 2) == 6
#   Failed test 'sum(2, 2, 2) == 6'
#   at test.pl line 23.
ok 4 - sum(-1, -1) == -2
ok 5 - sum(1, -1) == 0
1..5
# Looks like you failed 1 test of 5.
```

Please note that the line `1..5` has been printed at the end. Effectively Test::Simple says:
"I don't know how many tests you wanted to run, but I saw you ran 5, so that must have been your plan."

It is a bit funny if you think about it.

Please also note that the test (row number 3) that used to fail still fails as earlier. So what happens if someone
comments out that test-case:

```perl
#    [6,  2, 2, 2],
```

and runs the test again:

```
ok 1 - sum(1, 1) == 2
ok 2 - sum(2, 2) == 4
ok 3 - sum(-1, -1) == -2
ok 4 - sum(1, -1) == 0
1..4
```

Everything is fine!

On the one hand it is nice that we don't need to update the test plan manually, on the other hand we won't easily notice
if for some reason only part of the test-cases ran and the test-script exited prematurely.

In a later article we'll also cover `done_testing`, a slightly better tool to solve the problem. Stay tuned for that article.

For now, let's try to solve it in another, robust way.

## use the BEGIN block

If you put a block in your code called `BEGIN`, it has the special feature that the code inside it will be executed, 
immediately after it has been compiled, even before the rest of the script is compiled. So if we have the following code:

```perl
my @cases;
BEGIN {
    @cases = (
        [2,  1, 1],
        [4,  2, 2],
        [6,  2, 2, 2],
    # negative numbers
        [-2, -1, -1],
    # edge cases:
        [0,  1, -1],
    );
}

use Test::Simple tests => scalar @cases;
```

and we run the script, we get this output:

```
1..5
ok 1 - sum(1, 1) == 2
ok 2 - sum(2, 2) == 4
not ok 3 - sum(2, 2, 2) == 6
#   Failed test 'sum(2, 2, 2) == 6'
#   at test.pl line 26.
ok 4 - sum(-1, -1) == -2
ok 5 - sum(1, -1) == 0
# Looks like you failed 1 test of 5.
```

The `1..5` moved to the front, if for some reason our test script will execute fewer than 5 tests, Test::Simple will complain
as explained in the article about [test plans and descriptions](/test-plan-and-test-descriptions).

Unfortunately, this solution will not notice the problem if we comment out the bad test case as we did in the previous example.
This will automatically adjust the plan to the new number of test-cases. Two points here:

1. Avoiding repetition (going with DRY) is not always a good thing.
1. I'll have to show you another case where the advantage of declaring a `plan` is clearer.

For now, let's just point out that we had to declare `my @cases` outside of the `BEGIN` block, otherwise it would have been scoped to
the block and perl would complain with the syntax error: [Global symbol "@cases" requires explicit package name at ...](/global-symbol-requires-explicit-package-name).
for the line where we have `use Test::Simple tests => scalar @cases;`.


