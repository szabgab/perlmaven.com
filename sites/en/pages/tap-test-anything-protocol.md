---
title: "TAP - Test Anything Protocol"
timestamp: 2013-12-17T07:30:01
tags:
  - TAP
  - Test::Harness
  - TAP::Formatter::HTML
  - Smolder
published: true
books:
  - testing
author: szabgab
---


The basic assumption behind TAP - the Test Anything Protocol - is that
it is useful to separate the test execution and raw data
generation from the test management and reporting.

When using TAP you have a test script or program or whatever
you would like to call it, that exercises your application
and prints the results to the screen (called a <b>TAP producer</b>).

You also have another tool that can parse this output
(called a <b>TAP parser or harness</b>) and generate nice or at least
useful reports.

The format of TAP is programming language agnostic.


## TAP output examples

A successful one looks like this

```
1..3
ok 1 - stderr is empty
ok 2
ok 3 - foo was added
```

A failed run looks like this:

```
1..3
ok 1 - stderr is empty
not ok 2
#   Failed test at t/add_foo_to_db line 49.
# In row 0
# Expected: A1=569.1
# Received: A1=-1.23872428244378e-263
ok 3 - foo was added
# Looks like you failed 1 test of 3.
```

## TAP details

The output basically consists of three parts.
A header where you declare the planned number of test units:

```
1..42
```

Then for each test unit (also called assertion in some languages)
you print

```
ok N - name of unit
```

if the assertion was successful or

```
not ok N - name of unit
```

if it failed.

N is a counter that in our case should go from 1 to 42 as
declared in the header and "name of unit" is some
arbitrary, and optional, text to describe the unit.

Sprinkled throughout this output there can be comments staring
with a # sign.

```
# comments
```

These lines are used both as comments and as a way
to provide details in case of a failure.

The third part of the output is generated only when there
was failure, or something that looks like a failure.
It is a short summary that is similar to the comments but
it gives a summary of what happened. Something like this:

```
# Looks like you failed 2 test of 42.
```

So far this was a simplified description on how TAP looks like.

## Why is this separation good ?

For this to work we need two entities. `TAP producers` that
can generate TAP output and `TAP consumers` that can read
this output and provide nice reports. Actually we might need
three parts as we also need a tool called a harness to run the
test scripts. In most current implementations the consumer
and the harness are in one tool.

The point is that nothing in the above said anything about
the language the TAP producer was written in, nor does it say
anything about the language of the TAP parser. They can be
in any language. In fact there are TAP producers implemented
in several languages including Perl, Python, PHP, Javascript,
C and even PgSQL with some more listed on
[testanything.org](http://testanything.org/)

## TAP Producers

This will be especially important for applications where several
technologies or programming languages are involved.

If you think about a web application it will require HTML, CSS,
Javascript, SQL or NoSQL and at least one high-level server side language
such as Perl, Python, Ruby or PHP. In some cases even more.

If you think about some networking device, the
self-tests of the device running on the device can also
generate TAP.

Other systems will have other complexities.

Actually producing TAP output is not too difficult as you only need
to print some simple strings. Nevertheless it is nice to wrap it in
some testing library so others can reuse it.

## TAP Consumers

The default TAP consumer in Perl called
[Test::Harness](https://metacpan.org/pod/Test::Harness) is actually
a combination of both a harness tool, that can run the test scripts,
and a parser that can analyze the TAP output and generate
a textual report.

In our case this summary is actually longer than the TAP output
and looks like this:

```
t/add_foo_to_db....1/3
#   Failed test at t/add_foo_to_db line 49.
# In row 0
# Expected: A1=569.1
# Received: A1=-1.23872428244378e-263
# Looks like you failed 1 test of 3.
t/add_foo_to_db.... Dubious, test returned 1 (wstat 256, 0x100)
  Failed 1/3 subtests

Test Summary Report
-------------------
t/add_foo_to_db (Wstat: 256 Tests: 3 Failed: 1)
  Failed test:  2
  Non-zero exit status: 1
Files=1, Tests=3,  0 wallclock secs
( 0.01 usr  0.00 sys +  0.11 cusr  0.00 csys =  0.12 CPU)
Result: FAIL
```

In a real situation though, you would have tens or hundreds of
test scripts each with tens or hundreds of assertions. In such
case the TAP output would be thousands of lines long while the
summary created by the harness does not get much longer.

[Test::Harness](https://metacpan.org/pod/Test::Harness)
has a command-line tool called
`prove` that allows us to run tests easily.

The nice thing about <b>prove</b> is that you can actually separate the
two steps as well. You can run run <b>prove</b> with the -a option
and archive your TAP output for later use. That is, <b>prove</b> is
now only used to run the tests, it does not actually
parse the output.

You can take the output, archive it for later processing.
Send it over the network to store it in a remote database
and/or generate other types of reports, more pleasing to the eyes.
Especially to the eyes of management.

## TAP as HTML

So you could use [TAP::Formatter::HTML](https://metacpan.org/pod/TAP::Formatter::HTML) by Steve Purkis to generate reports like
[this one](http://www.spurkis.org/TAP-Formatter-HTML/test-output.html)

## Smolder

You can also use [Smolder](https://metacpan.org/pod/Smolder) by Michael Peters
to collect your TAP output and provide historical reports.

As TAP becomes even more widespread, TAP parsers will be
written in other languages as well, not only in Perl.

