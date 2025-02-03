---
title: "Test2 capture warnings"
timestamp: 2019-04-19T13:30:01
tags:
  - Test2
  - Test2::Plugin::NoWarnings
published: true
author: szabgab
archive: true
---


When you write tests you might have test cases that pass, but at the same time your code might generate warnings.
Some of these warnings might be harmless, but others might indicated some problem. Either in the application under test
or in the tests themselves.

In addition if someone looks at the output and sees warnings, the person will be rightly worried that there might
be issues with the code.

If nothing else, warnings can fill the log files of a web server causing denial of service.

The problem is that a warning does not stop the tests and so new warnings might not be noticed in a CI system.


Of course there are tools to overcome this issue.

You can ask your Test2 based tests to fail if there are any unexpected warnings during the test run.

All you need to do is install and import the
[Test2::Plugin::NoWarnings](https://metacpan.org/pod/Test2::Plugin::NoWarnings) module.

Let's see an example:

The layout of the files:

```
.
├── lib
│   └── App.pm
└── t
    ├── 01-test.t
    ├── 02-test.t
    └── 03-test.t
```

The application under test:

{% include file="examples/test2-nowarnings/lib/App.pm" %}


## Test case with warning

{% include file="examples/test2-nowarnings/t/01-test.t" %}

```
$ prove -l t/01-test.t
```

```
t/01-test.t .. Use of uninitialized value $y in addition (+) at .../lib/App.pm line 8.
t/01-test.t .. ok
All tests successful.
Files=1, Tests=1,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.07 cusr  0.00 csys =  0.09 CPU)
Result: PASS
```

Tests are successful, but there is a warning.

## Add Test2::Plugin::NoWarnings to capture warnings

{% include file="examples/test2-nowarnings/t/02-test.t" %}

```
$ prove -l t/02-test.t
```

The results:

```
t/02-test.t .. 1/? Use of uninitialized value $y in addition (+) at .../lib/App.pm line 8.
# Seeded srand with seed '20190419' from local date.
t/02-test.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/2 subtests

Test Summary Report
-------------------
t/02-test.t (Wstat: 256 Tests: 2 Failed: 1)
  Failed test:  1
  Non-zero exit status: 1
Files=1, Tests=2,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.07 cusr  0.00 csys =  0.09 CPU)
Result: FAIL
```

If we only import the module without the `echo` parameter it will hide the warning. I think it is much better to
show it as it makes it easier to find the source of the problem. Actually it would be even better if we knew in which
test-case was the warning generated.

## Fixing the warning

In the last example we fixed the test. It does not generate warnings any more and everything is fine with
Test2::Plugin::NoWarnings in the code.


{% include file="examples/test2-nowarnings/t/03-test.t" %}

```
$ prove -l t/03-test.t
```

```
t/03-test.t .. ok
All tests successful.
Files=1, Tests=1,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.07 cusr  0.00 csys =  0.09 CPU)
Result: PASS
```

