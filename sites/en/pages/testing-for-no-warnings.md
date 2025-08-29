---
title: "Testing for no warnings in Perl"
timestamp: 2018-09-10T09:30:01
tags:
  - Test::Warn
  - Test::FailWarnings
  - Test::NoWarnings
published: true
author: szabgab
archive: true
---


Just as it is important to make sure a given code that is [expected to warn, indeed warns](/test-for-warnings-in-a-perl-module),
it is also important to make sure other parts of the code don't warn.

Especially if you follow my advice and [always use warnings](/always-use-warnings).

There are several solution for this.


As described in [test for expected warnings](/test-for-expected-warnings) we can use the
`warning_is` function provided by [Test::Warn](https://metacpan.org/pod/Test::Warn)
to check if a piece of code, for a specific input, will emit the expected waring.

In addition, once we made the rest of our code **warning-free**, we will want to make sure that no
warnings start to appear. It is especially important as [new warnings are added to Perl](/always-use-warnings)
and thus when you upgrade the version of perl under an application it can start emitting these new warnings.

For example the [Possible precedence issue with control flow operator](possible-precedence-issue-with-control-flow-operator)
warning was added in Perl version 5.20.

Let's see this code:

{% include file="examples/warn/lib/MyModule.pm" %}

I know this is a slightly contrived example, but one we can easily control and thus easily show the issue.
Here we have a module with two functions. The `add` function is very simple. If we did not check that we
have enough parameters we would get the dreaded [Use of uninitialized value in addition](/use-of-uninitialized-value) warning.

In order to avoid that, we first check if we have enough arguments. Emit our own warning if the number of parameters is smaller than 2
and then call `return`. We also check if the user has supplied too many parameters and emit a similar warning in that case.

I know this is a bit of a mouthful for this function, but let's pretend this is a more important function.

We also have another totally lame function that would emit a warning if our version of Perl is higher than 5.022 which is commonly known as 5.22.

We write a test file that first tests the `add` function with two parameters. Then tests whether the `add` function emits
the proper warning when we supply too few or too many parameters. We also have a test case that checks the return value of the `other`
function.

{% include file="examples/warn/t/test_warnings.t" %}

Running the tests we get:

```
$ prove -l t/test_warnings.t

t/test_warnings.t .. ok
All tests successful.
Files=1, Tests=4,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.03 cusr  0.00 csys =  0.08 CPU)
Result: PASS
```

Everything looks fine.

What happens when we upgrade our version of Perl and run the tests again?

This is the output:

```
$ prove -l t/test_warnings.t

t/test_warnings.t .. 1/4 Some new warning at .../lib/MyModule.pm line 18.
t/test_warnings.t .. ok
All tests successful.
Files=1, Tests=4,  0 wallclock secs ( 0.04 usr  0.00 sys +  0.04 cusr  0.00 csys =  0.08 CPU)
Result: PASS
```

The tests still pass, but now we have a warning. That's not healthy. If users see this they will assume something
is broken in your code (and they might be even right). If this goes into a log file it might suddenly start growing
very fast filling your disk and causing all kinds of other problems.

Even worse, if this is a **deprecation warning** that a certain feature is going to be removed from the next version of
Perl then you definitely want to know about it and fix your code before the next upgrade.

Unfortunately as the warning does not make the tests fail, we have a very good chance of not noticing it.

(Side note:, One of the reasons I used my own warning based on the version number is that in this case I did not really had
to run my code with two different versions of perl to see the above issue. I just changed the condition of the warning
from "greater than 5.022" to "greater than or equal to 5.022". I know it is cheating, but made it easier to demonstrate
the warning and allows you to try it easily with any version of Perl.) 

So how can we make sure the warning will generate a test failure?

There are at least two solutions for this:

## Test::NoWarnings

[Test::NoWarnings](https://metacpan.org/pod/Test::NoWarnings) is useful if we have a fixed `plan`.

We add another test that will fail if there is any unexpected warning in our code.
That is, if we catch the warning with one of the functions of [Test::Warn](https://metacpan.org/pod/Test::Warn) as we did in our test
those are ok, but if there is a warning that was not handled by one of those functions, then our additional
test will fail.

{% include file="examples/warn/t/test_nowarnings.t" %}

We only had to add `use Test::NoWarnings` to our test file and to increase the number of tests by 1.
We don't need to write any `ok` or similar function.
Instead of writing the new total number of tests (5 in this case) I usually write `+1` (or `4+1` in this case).
That helps me later to remember that there is an extra, invisible test-case.

If there is no extra, unexpected warning everything is fine:

```
$ prove -l t/test_nowarnings.t

t/test_nowarnings.t .. ok
All tests successful.
Files=1, Tests=5,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.04 cusr  0.00 csys =  0.09 CPU)
Result: PASS
```


However if we "upgrade Perl" and run it again, we'll get a nasty error message with a full stack-trace:

```
$ prove -l t/test_nowarnings.t

t/test_nowarnings.t .. 1/5
#   Failed test 'no warnings'
#   at .../perl-5.22.0_WITH_THREADS/lib/site_perl/5.22.0/Test/NoWarnings.pm line 45.
# There were 1 warning(s)
#   Previous test 0 ''
#   Some new warning at .../lib/MyModule.pm line 18.
#  at .../lib/MyModule.pm line 18.
#   MyModule::other() called at t/test_nowarnings.t line 38
#   main::__ANON__() called at .../perl-5.22.0_WITH_THREADS/lib/5.22.0/Test/Builder.pm line 261
#   Test::Builder::__ANON__() called at .../perl-5.22.0_WITH_THREADS/lib/5.22.0/Test/Builder.pm line 266
#   eval {...} called at .../perl-5.22.0_WITH_THREADS/lib/5.22.0/Test/Builder.pm line 266
#   Test::Builder::subtest(Test::Builder=HASH(0x7fd00d844e20), "other", CODE(0x7fd00d8ed378)) called at .../perl-5.22.0_WITH_THREADS/lib/5.22.0/Test/More.pm line 771
#   Test::More::subtest("other", CODE(0x7fd00d8ed378)) called at t/test_nowarnings.t line 40
#
# Looks like you failed 1 test of 5.
t/test_nowarnings.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/5 subtests

Test Summary Report
-------------------
t/test_nowarnings.t (Wstat: 256 Tests: 5 Failed: 1)
  Failed test:  5
  Non-zero exit status: 1
Files=1, Tests=5,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.05 cusr  0.00 csys =  0.10 CPU)
Result: FAIL
```

We can go and dig out the problem.

We can see the text of the warning close to the top of the report (Some new warning).

## Test::FailWarnings

[Test::FailWarnings](https://metacpan.org/pod/Test::FailWarnings) is useful if instead
of some up-front `test plan` we use the `done_testing` function at the end of our test-file.

In this case we only need to add the `use Test::FailWarnings;` at the top of our test-file as there is
no `plan` to be updated:

{% include file="examples/warn/t/test_failwarnings.t" %}

If we run this code on an older version of Perl everything passes as expected:

```
$ prove -l t/test_failwarnings.t

t/test_failwarnings.t .. ok
All tests successful.
Files=1, Tests=4,  0 wallclock secs ( 0.04 usr  0.00 sys +  0.04 cusr  0.00 csys =  0.08 CPU)
Result: PASS
```

If we run on a newer version of Perl (or if we doctor our original module to fake the problem) then we
get the following test failure:

```
$ prove -l t/test_failwarnings.t

t/test_failwarnings.t .. 1/?
    #   Failed test 'Test::FailWarnings should catch no warnings'
    #   at .../lib/MyModule.pm line 18.
    # Warning was 'Some new warning at .../lib/MyModule.pm line 18.'
    # Looks like you planned 1 test but ran 2.
    # Looks like you failed 1 test of 2 run.

#   Failed test 'other'
#   at t/test_failwarnings.t line 38.
# Looks like you failed 1 test of 4.
t/test_failwarnings.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/4 subtests

Test Summary Report
-------------------
t/test_failwarnings.t (Wstat: 256 Tests: 4 Failed: 1)
  Failed test:  4
  Non-zero exit status: 1
Files=1, Tests=4,  0 wallclock secs ( 0.03 usr  0.01 sys +  0.04 cusr  0.00 csys =  0.08 CPU)
Result: FAIL
```


## Conclusion

Feel free to use either of these solutions. I personally still prefer the use of plans, but the `done_testing`
also has its place and the `Warn::FailWarnings` module has nicer reports.

## Comments

Another advanced warning usage is custom categories definition. Then you could enable a fine-grained exception system based on your requirements and make warn statements FATAL in your test suites.
https://perldoc.perl.org/warnings#Reporting-Warnings-from-a-Module
