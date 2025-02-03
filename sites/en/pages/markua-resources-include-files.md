---
title: "Markua resources: Include files"
timestamp: 2020-03-06T07:04:01
tags:
  - include
published: true
books:
  - markua
author: szabgab
archive: true
---


The next Markua element we'd like to be able to parse are used to include files. The same format can be used to include text files in various format (e.g. Perl, Python, YAML, etc.) or images. They are all called `resources`.

The format looks like this.

```
![TITLE](PATH_TO_FILE)
```


## Tests case

First I created a test-case. That means a Markua file:

{% include file="examples/markua-parser/6605937/t/input/include.md" %}

and the files that need to be included:

{% include file="examples/markua-parser/6605937/t/input/include/a.pl" %}

{% include file="examples/markua-parser/6605937/t/input/include/b.pl" %}

{% include file="examples/markua-parser/6605937/t/input/include/d.py" %}

Note, I've deliberately included a file (c.pl) that does not exist.

In the expected JSON file  `t/dom/include.json` I only put a pair of empty square brackets:

```
[]
```

I've also updated the `t/01-test.t` adding the name of the test case so instead of

```
my @cases = ('heading1', 'headers', 'paragraphs');
```

we have this:

```
my @cases = ('heading1', 'headers', 'paragraphs', 'include');
```

Running the test

```
$  prove -l
```

I got the following error:

```
t/01-test.t .. 1/9
#   Failed test at t/01-test.t line 18.
#     Structures begin differing at:
#          $got->[0] = HASH(0x7fe2591012b8)
#     $expected->[0] = Does not exist
# Looks like you failed 1 test of 9.
t/01-test.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/9 subtests

Test Summary Report
-------------------
t/01-test.t (Wstat: 256 Tests: 9 Failed: 1)
  Failed test:  8
  Non-zero exit status: 1
Files=1, Tests=9,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.07 cusr  0.02 csys =  0.14 CPU)
Result: FAIL
```

## Improve the test reporting

This does not give much. We expect an empty array and in the result there is at least one reference to a hash.
That's all we know from this error report. What is really in the actually result we don't know.

Let's improve the test reporting. We take line 18, where the error was reported and add:

`or diag explain $result` at the end.

the we run the test again:

```
$  prove -l
```

This time the response is much more verbose:

```
t/01-test.t .. 1/9
#   Failed test at t/01-test.t line 18.
#     Structures begin differing at:
#          $got->[0] = HASH(0x7fb4c01be290)
#     $expected->[0] = Does not exist
# [
#   {
#     'tag' => 'p',
#     'text' => '![first file](include/a.pl)'
#   },
#   {
#     'tag' => 'p',
#     'text' => '![](include/b.pl)'
#   },
#   {
#     'tag' => 'p',
#     'text' => '![third file](include/c.pl)'
#   },
#   {
#     'tag' => 'p',
#     'text' => '![fourth file](include/d.py)'
#   }
# ]
# Looks like you failed 1 test of 9.
t/01-test.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/9 subtests

Test Summary Report
-------------------
t/01-test.t (Wstat: 256 Tests: 9 Failed: 1)
  Failed test:  8
  Non-zero exit status: 1
Files=1, Tests=9,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.07 cusr  0.01 csys =  0.13 CPU)
Result: FAIL
```

We can see that the parser understood each file inclusion line as a paragraph. That's good. Not what I wanted, but we have not implemented the parser part yet.

## Implement the parser

{% include file="examples/markua-parser/6605937/lib/Markua/Parser.pm" %}


## Test the parser

Once you feel that the parser is ready you can run the tests again.

```
$  prove -l
```

The result looks like this:

```
t/01-test.t .. 1/9
#   Failed test at t/01-test.t line 18.
#     Structures begin differing at:
#          $got->[0] = HASH(0x7f9d430ed248)
#     $expected->[0] = Does not exist
# [
#   {
#     'tag' => 'code',
#     'text' => 'use strict;
# use warnings;
# use 5.010;
#
# say "Hello World!";
# ',
#     'title' => 'first file'
#   },
#   {
#     'tag' => 'code',
#     'text' => 'print "Hello";
# print " ";
# print "World!";
# print "\\n";
#
# ',
#     'title' => ''
#   },
#   {
#     'tag' => 'code',
#     'text' => '
# if __name__ == \'__main__\':
#     print("Hello World from Python")
# ',
#     'title' => 'fourth file'
#   }
# ]

#   Failed test 'Errors of include'
#   at t/01-test.t line 19.
#     Structures begin differing at:
#          $got->[0] = HASH(0x7f9d430f2928)
#     $expected->[0] = Does not exist
# [
#   {
#     'error' => 'Could not read included file \'include/c.pl\'',
#     'line' => '![third file](include/c.pl)
# ',
#     'row' => 6
#   }
# ]
# Looks like you failed 2 tests of 9.
t/01-test.t .. Dubious, test returned 2 (wstat 512, 0x200)
Failed 2/9 subtests

Test Summary Report
-------------------
t/01-test.t (Wstat: 512 Tests: 9 Failed: 2)
  Failed tests:  8-9
  Non-zero exit status: 2
Files=1, Tests=9,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.07 cusr  0.01 csys =  0.13 CPU)
Result: FAIL
```

I am not surprised. After all in the expected results file we still only have an empty array `[]`
so even though the generated data structure that we can see in the error report looks what I wanted,
th test fails.

In addition the `Errors of include` also failed as there too we expected an empty array meaning no error, but we received one error report. Something we should expect for the part where we try to include a file that does not exist.

For the expected DOM we take the actual result, save it in the correct format in the `t/dom/include.json` file like this:

{% include file="examples/markua-parser/6605937/t/dom/include.json" %}

Then we run the tests again:

```
$  prove -l
```

The result is much better. Now only the `'Errors of include'` failed:

```
t/01-test.t .. 1/9
#   Failed test 'Errors of include'
use strict;
#   at t/01-test.t line 24.
#     Structures begin differing at:
#          $got->[0] = HASH(0x7feebe06c940)
#     $expected->[0] = Does not exist
# [
#   {
#     'error' => 'Could not read included file \'include/c.pl\'',
#     'line' => '![third file](include/c.pl)
# ',
use strict;
#     'row' => 6
#   }
# ]
# Looks like you failed 1 test of 9.
t/01-test.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/9 subtests

Test Summary Report
-------------------
t/01-test.t (Wstat: 256 Tests: 9 Failed: 1)
  Failed test:  9
  Non-zero exit status: 1
Files=1, Tests=9,  0 wallclock secs ( 0.03 usr  0.01 sys +  0.08 cusr  0.02 csys =  0.14 CPU)
Result: FAIL
```

## Flexible expected errors

So far in every case we expected that the list of errors is going to be empty. This is the first case when we would like to have an error message emitted by the parser.

As error messages are also returned in a structured format, we can do the same with them as we did with the DOM. We can create a JSON file where we put the expected errors and then compare that with the actual results.

I've created a directory called `t/errors` and in there created a file corresponding to our test case called `include.json`. I put the code from the above test-run and got this file:

{% include file="examples/markua-parser/6605937/t/errors/include.json" %}

I've also modified lines 19-24 in the test script. The new `$expected_errors` starts with a reference to an empty array
but if the error-file related to the current cases exists, then we read in that and use that as `$expected_errors`.

{% include file="examples/markua-parser/6605937/t/01-test.t" %}

## Tests pass successfully

At this point we can run the tests again:

```
$  prove -l
```

... and see that they all pass:

```
t/01-test.t .. ok
All tests successful.
Files=1, Tests=9,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.07 cusr  0.02 csys =  0.14 CPU)
Result: PASS
```

Meaning that both our new feature works and all the previous features still work.

## Commit the changes

```
git add .
git commit -m "implement first version of resource parsing"
git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/6605937fce85337d0b9aa7853611ea0edfe1ec68)

## Test coverage increase

A few seconds after I pushed out the changes to GitHub I received an e-mail from [Coveralls](https://coveralls.io/):

`coverage increased (+0.7%) to 97.674% for commit: implement first version of resource parsing`

It is really nice to finish a change with an increased test coverage.


