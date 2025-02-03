---
title: "prove, the harness"
timestamp: 2016-04-07T22:30:01
tags:
  - prove
  - Test::Harness
  - TAP
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


Now that we finally managed to [separate the test data from the test code](/separating-test-data-from-test-code),
nothing stops us from expanding the number of tests. We can hire an expert in the "sum" function, and let her create a file full of test cases.

The problem we encounter is that we are now going to be flooded with lines of success, while what we are mostly interested in,
being the critical people we are, are the few failures. How can focus on the failures?


{% youtube id="aGNB4MTRJHo" file="prove-the-harness" %}

`sum.txt` has the following test cases in it:

```
2 = 1, 1
4 = 2, 2
6 = 2, 2, 2
6  = 3, 3
8  = 4, 4
10 = 5, 5
12 = 6, 6
14 = 7, 7
16 = 8, 8
42 = 19, 23
242 = 119, 123


# negative
-2 = -1, -1
-3 = -2, -1

# edge cases
0  = 1, -1
1  = -0, 1
-1 = 0, -1
-1 = -0, -1

1  = 1, 0
1  = 1, -0
2  = 2, 0
-1 = -1, 0
-1 = -1, -0

0 = 1, -1
0 = 2, -2
0 = 3, -3
0 = 4, -4
0 = 5, -5
0 = 6, -6
0 = 7, -7
0 = 8, -8
0 = 9, -9
0 = 10, -10
0 = 11, -11
0 = 12, -12
0 = 13, -13
0 = 14, -14
0 = 15, -15
0 = 16, -16
0 = 17, -17
0 = 18, -18
0 = 19, -19
0 = 20, -20
0 = 21, -21
0 = 22, -22
0 = 23, -23
```

The `test.pl` script looks like this. Just as we finished in the [earlier article](/separating-test-data-from-test-code):

```perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use MyCalc;

my @cases;
BEGIN {
    my $file = "$FindBin::Bin/sum.txt";
    open my $fh, '<', $file or die "Could not open '$file': $!";

    while (my $line = <$fh>) {
        chomp $line;
        next if $line =~ /^\s*(#.*)?$/;
        my @data = split /\s*[,=]\s*/, $line;
        push @cases, \@data;
    }
}

use Test::Simple tests => scalar @cases;

for my $c (@cases) {
    my ($exp, @params) = @$c;
    my $descr = 'sum(' . join(', ', @params) . ") == $exp";
    ok sum(@params) == $exp, $descr;
}
```

If we now run `perl test.pl` we get a long output:

```
1..45
ok 1 - sum(1, 1 ) == 2
ok 2 - sum(2, 2     ) == 4
not ok 3 - sum(2, 2, 2 ) == 6
#   Failed test 'sum(2, 2, 2 ) == 6'
#   at test.pl line 26.
ok 4 - sum(3, 3) == 6
ok 5 - sum(4, 4) == 8
ok 6 - sum(5, 5) == 10
ok 7 - sum(6, 6) == 12
ok 8 - sum(7, 7) == 14
ok 9 - sum(8, 8) == 16
ok 10 - sum(19, 23) == 42
ok 11 - sum(119, 123 ) == 242
ok 12 - sum(-1, -1) == -2
ok 13 - sum(-2, -1) == -3
ok 14 - sum(1, -1) == 0
ok 15 - sum(-0, 1) == 1
ok 16 - sum(0, -1) == -1
ok 17 - sum(-0, -1) == -1
ok 18 - sum(1, 0) == 1
ok 19 - sum(1, -0) == 1
ok 20 - sum(2, 0) == 2
ok 21 - sum(-1, 0) == -1
ok 22 - sum(-1, -0) == -1
ok 23 - sum(1, -1) == 0
ok 24 - sum(2, -2) == 0
ok 25 - sum(3, -3) == 0
ok 26 - sum(4, -4) == 0
ok 27 - sum(5, -5) == 0
ok 28 - sum(6, -6) == 0
ok 29 - sum(7, -7) == 0
ok 30 - sum(8, -8) == 0
ok 31 - sum(9, -9) == 0
ok 32 - sum(10, -10) == 0
ok 33 - sum(11, -11) == 0
ok 34 - sum(12, -12) == 0
ok 35 - sum(13, -13) == 0
ok 36 - sum(14, -14) == 0
ok 37 - sum(15, -15) == 0
ok 38 - sum(16, -16) == 0
ok 39 - sum(17, -17) == 0
ok 40 - sum(18, -18) == 0
ok 41 - sum(19, -19) == 0
ok 42 - sum(20, -20) == 0
ok 43 - sum(21, -21) == 0
ok 44 - sum(22, -22) == 0
ok 45 - sum(23, -23) == 0
# Looks like you failed 1 test of 45.
```

Most likely, this will be longer than what fits on our screen. The only thing that we are really interested in, the part about the failure is not in our view
any more. The only indication about the failure will be the last line, and then we need to scroll up to find the actual problem.
Even with 45 test cases it is already disturbing, what if there were 10,000 test cases?


## The Harness

The Harness, as provided by the [Test::Harness](https://metacpan.org/pod/Test::Harness) will run the test-script on our behalf. It will capture
the output of the script, analyze it, and print a summary of the test results.

We can write a small script we call `harness.pl` with the following content:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use Test::Harness qw(runtests);

runtests @ARGV;
```

and then we can run our script using the harness with the following command:

```
$ perl harness.pl test.pl
```

The test script is a parameter of the harness script.

The output looks like this:

```
test.pl .. 1/45
#   Failed test 'sum(2, 2, 2 ) == 6'
#   at test.pl line 26.
# Looks like you failed 1 test of 45.
test.pl .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/45 subtests

Test Summary Report
-------------------
test.pl (Wstat: 256 Tests: 45 Failed: 1)
  Failed test:  3
  Non-zero exit status: 1
Files=1, Tests=45,  0 wallclock secs ( 0.03 usr  0.01 sys +  0.05 cusr  0.01 csys =  0.10 CPU)
Result: FAIL
Failed 1/1 test programs. 1/45 subtests failed.
```

While it is more information than we had earlier, it is also shorter. It hides all the success output and only shows the failures.
It also provides a summary, telling us that the `test.pl` script has failed test number 3.
There is some additional information about the time it took to run the test, but that's not relevant to us now.

The important thing is that we can now focus on the failure.


## prove

While we could keep using the `harness.pl` written above, perl, or more specifically
the [Test::Harness](https://metacpan.org/pod/Test::Harness) module, comes with a command called
[prove](https://metacpan.org/pod/distribution/Test-Harness/bin/prove). It is the ultimate tool to run
our tests.

Running `prove test.pl` will generate the same output as `harness.pl` did, except that part of it
will be probably red, indicating the failure. `prove` also has a number of command-line options.
We'll discuss those later.


## Everything is ok with prove

Now that we saw that using `prove` for running our tests will let us focus on the, hopefully few, errors,
let's see what happens if all the test-cases were successful.
For this we have a test script that contains 4 test cases which are all successful.

`prove s.pl`

```
s.pl .. ok
All tests successful.
Files=1, Tests=4,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.03 cusr  0.00 csys =  0.05 CPU)
Result: PASS
```

The result is really compact, and if you run it on on a console, it will also have some green parts indicating success.

## prove when plan is broken

Another issue we saw earlier is when all of our tests are successful, but when we actually run fewer tests than we planned for.
For this we have another test script prepared:

```
$ prove few.pl
```

```
few.pl .. 1/5 # Looks like you planned 5 tests but ran 4.
few.pl .. Dubious, test returned 255 (wstat 65280, 0xff00)
Failed 1/5 subtests

Test Summary Report
-------------------
few.pl (Wstat: 65280 Tests: 4 Failed: 0)
  Non-zero exit status: 255
  Parse errors: Bad plan.  You planned 5 tests but ran 4.
Files=1, Tests=4,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.03 cusr  0.00 csys =  0.06 CPU)
Result: FAIL
```

The upper part of the report shows the last line of the original output, the line that indicates
the plan was not met. Although no test-case failed, prove, the harness reports the whole test script
as a failure. That's exactly what we want in this case.

## prove without a plan

In case we run a test script that does not have a "plan", such as the examples in 
[test without a plan](/test-without-a-plan) in case of success
we'll get a report like this:

```
no_plan.pl .. ok   
All tests successful.
Files=1, Tests=4,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.03 cusr  0.00 csys =  0.06 CPU)
Result: PASS
```

In case of one of the tests fails, we'll get a report like this:

```
no_plan.pl .. 1/? 
#   Failed test 'sum(2, 2, 2) == 6'
#   at no_plan.pl line 22.
# Looks like you failed 1 test of 4.
no_plan.pl .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/4 subtests 

Test Summary Report
-------------------
no_plan.pl (Wstat: 256 Tests: 4 Failed: 1)
  Failed test:  2
  Non-zero exit status: 1
Files=1, Tests=4,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.03 cusr  0.00 csys =  0.06 CPU)
```


## TAP - Test Anything Protocol

The output generated by the test script is called TAP, the 
[Test Anything Protocol](/tap-test-anything-protocol).


