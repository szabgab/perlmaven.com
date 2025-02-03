---
title: "Collecting errors while parsing Markua in Perl 5 - disregarding empty rows"
timestamp: 2019-12-19T22:01:01
tags:
  - error
published: true
books:
  - markua
author: szabgab
archive: true
---


So far we have only focused on a very limited set of valid Markua tags. As we make progress we'll need to be able to report rows in an input file that we could not recognize. So let's add that error collecting code now. It will make our parsing tighter as it will mean that for every line in the input file we'll have to know exactly what it means.

We can already foresee some trouble with our current examples as we have not handled the empty rows at all.


In this case I could not figure out how to do TDD. That is, I don't really know what to expect from the tests. So first I added the code as I felt right. and got the following code:

{% include file="examples/markua-parser/74d23bf_pre/lib/Markua/Parser.pm" %}

In the test file I made the following changes:

The `parse_file` method now returns 2 array references, so we need to accept them both.
In the first line of the next snippet the second variable will contain the errors.

Then I've also added a 3rd line that check of the errors list is empty. In this case I've also added
a 3rd parameter to the `is_deeply` call that describes the test-case.

```perl
    my ($result, $errors) = $m->parse_file("t/input/$case.md");
    is_deeply $result, decode_json( path("t/dom/$case.json")->slurp_utf8 );
    is_deeply $errors, [], "Errors of $case";
```

I've also updated the `plan` as now for every test-case we'll have two `is_deeply` checks
so the number of reported test cases is twice the number elements in the `@cases` array.
(Plus 1, checking the creation of the object.)

```perl
plan tests => 1 + 2 * scalar @cases;
```

Once I have both the application code and the test code in place I ran the tests:

```
$ prove -l
```

And got a failure:

```
t/01-test.t .. 1/5
#   Failed test 'Errors of headers'
#   at t/01-test.t line 19.
#     Structures begin differing at:
#          $got->[0] = HASH(0x7fccf207a590)
#     $expected->[0] = Does not exist
# Looks like you failed 1 test of 5.
t/01-test.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/5 subtests

Test Summary Report
-------------------
t/01-test.t (Wstat: 256 Tests: 5 Failed: 1)
  Failed test:  5
  Non-zero exit status: 1
Files=1, Tests=5,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.07 cusr  0.01 csys =  0.13 CPU)
Result: FAIL
```

This report only tells us that there was an error and that when we parsed the "headers" test-case there were errors returned.
We don't know what.
So I've also included a line after the second `is_deeply` call to display the content of the `$errors` reference to an array.

```perl
diag explain $errors;
```


```
$ prove -l
```

This is the result:


```
t/01-test.t .. 1/5 # []

#   Failed test 'Errors of headers'
#   at t/01-test.t line 19.
#     Structures begin differing at:
#          $got->[0] = HASH(0x7fcc4c116670)
#     $expected->[0] = Does not exist
# [
#   {
#     'line' => '
# ',
#     'row' => 2
#   },
#   {
#     'line' => '
# ',
#     'row' => 4
#   },
#   {
#     'line' => '
# ',
#     'row' => 6
#   },
#   {
#     'line' => '
# ',
#     'row' => 8
#   },
#   {
#     'line' => '
# ',
#     'row' => 10
#   },
#   {
#     'line' => '
# ',
#     'row' => 12
#   }
# ]
# Looks like you failed 1 test of 5.
t/01-test.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/5 subtests

Test Summary Report
-------------------
t/01-test.t (Wstat: 256 Tests: 5 Failed: 1)
  Failed test:  5
  Non-zero exit status: 1
Files=1, Tests=5,  1 wallclock secs ( 0.04 usr  0.01 sys +  0.07 cusr  0.02 csys =  0.14 CPU)
Result: FAIL
```

At the top you can see an empty pair of square brackets: `[]`. This is the content of the `$errors`
array ref for the first test case. Then we see a much bigger array reference showing that a bunch of rows had empty lines in them
and we have reported them as errors.

So I've added a bit more code to the Parser.pm file that will disregard the empty lines:

```perl
if ($line =~ /^\s*$/) {
    next;
}
```

and got this file:

{% include file="examples/markua-parser/74d23bf/lib/Markua/Parser.pm" %}

Running the tests again:

```
$ prove -l
```

We get this output:

```
t/01-test.t .. 1/5 # []
# []
t/01-test.t .. ok
All tests successful.
Files=1, Tests=5,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.07 cusr  0.01 csys =  0.13 CPU)
Result: PASS
```

Now we have two pairs of empty square-brackets. `[]`. We can comment out `diag` lines as we don't need them now.

```
$ git add .
$ git commit -m"collect errors, parse every line in the input file"
$ git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/74d23bf0077661f2667893378afbbe62e4eef9e3)

So now we know that we process each line and if anything falls through the cracks those lines will be reported.


