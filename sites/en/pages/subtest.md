---
title: "Organizing a test script with subtests"
timestamp: 2016-10-07T17:00:01
tags:
  - subtest
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


As our test script grows we face several issues.

One is that most humans cannot count more than 10. So when the number of test-cases passes that number
we will constantly make mistakes in the number of tests and will soon give up, using a solution such as [no_plan](/test-without-a-plan).



{% youtube id="EOQhaIKbGkc" file="subtest" %}

Even if you are the borg, and you can count more than 10 tests, you will still be fed up with the constant
need to scroll up to the top of your test script to update the test count and then find the place where you were adding the test
which can be anywhere in the script.

There is also the issue of test separation. A test script usually consists of several rounds of the following iteration:

* create the environment
* do something
* check the results
* clean up the environment

If for some reason we don't clean up the environment then the following test-cases might be impacted by the
earlier test-cases. In some cases this is really bad and can either hide an error or fail unnecessarily.
In either case it is not really good.

Using <b>subtests</b> is an easy way to improve the situation regarding all of the above.

## subtest

A <b>subtest</b> looks like this:

```perl
subtest negatives => sub {
    plan tests => 2;

    is sum(-1, -1), -2, '-1, -1';
    is sum(-1, -1, -1), -3, '-1, -1, -1';
};
```

<b>subtest</b> is basically a function that gets two parameters. A test name ('negatives' in the above case),
and an anonymous function (a reference to a subroutine). As we use the fat-comma between the two parameters,
the name of the subtest, if it is a simple string, can be a [bareword](/barewords-in-perl).
Don't forget that this is a statement that happens to end with curly braces, so you have to add a semi-colon `;`
at the end.

Inside the subtest, you can do anything you would do in the main body of the test. In particular each subtest will count as one test
in the script regardless of the number of tests inside, and each subtest has its own internal test counting with its own internal <b>plan</b>.
So in order to keep the test-count up-to-date for the whole test, you only need to  count the number of subtests.
To keep the test count of each subtest correct, you only need to count the tests inside the subtest which will be much easier than for
the whole script. It is likely that each subtest will fit in a single screen.

This solves both the incorrect test-counting and the constant scrolling.


As each subtest is a function it also creates its own scope.
If creating the environment is declaring a variable and assigning a value to it then the "cleaning up the environment"
is letting the variable go out of scope. This is exactly what happens at the end of each subtest.


## Caveat

In the usual circumstances letting a variable go out of scope is enough for destroying its content but there are a few
cases when this does not help.

If the variable was holding a singleton object, that means the object will live on even when the external variable
holding the object goes out of scope. We will get the same instance next time we ask for such an object. (Within a process.)

Certain types of bugs - nasty memory leaks created by circular references - will cause things to stick around even after
we destroy the variable leading to them.  This too can impact our test.

There might be other things in the environment that were created in a subtest and will stay around.
For example shell environment variables, files, databases, in general anything external to Perl.

If we are not careful even Perl internal variables. That's why we usually use `local` to localize any change we
make to these variables. Those change won't survive the end of the subtest.

