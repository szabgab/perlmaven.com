---
title: "Process the 6 headers of Markua"
timestamp: 2019-12-07T09:30:01
tags:
  - regex
  - #
  - ##
  - ###
  - ####
  - #####
  - ######
  - prove
published: true
author: szabgab
archive: true
---


On of our first steps was to implement the [parsing of the main header syntax of Markua](/start-writing-the-markua-parser) which is a single `#` on the beginning of a line followed by a single space, followed by some text.

An easy step is to extend the code to be able to parse all [6 levels of headers](https://leanpub.com/markua/read#headings) that have 1-6 `#` at the beginning of the line.


## Prepare the test case

Because we are disciplined TDD (Test Driven Development) practitioners the first thing we do is create the tests.

For this I've created a Markua file with all 6 headers.

{% include file="examples/markua-parser/c580d63/t/input/headers.md" %}

and I've also created the JSON file that is the DOM expected to be created by the parser.

{% include file="examples/markua-parser/c580d63/t/dom/headers.json" %}

Then I've added the some code to the test file to process the new file and to compare it with the expected data structure.

I had to change the "plan" from 2 to 3 and add the following code to the end of the file.

```perl
$result = $m->parse_file('t/input/headers.md');
is_deeply $result, decode_json( path('t/dom/headers.json')->slurp_utf8 );
```

This is the same code as we had before just the names of the files had to be changed to match the new
test case and we don't need to declare `$result` again using `my`.

The full file looks like this:

{% include file="examples/markua-parser/c580d63/t/01-test.t" %}

I don't really like this code repetition, so later on we'll going to refactor the code, but this is the simples
change now to implement the test, so this is what I did.

Then on the command line we can run the tests:

```
$ prove -l
```

Not surprisingly they fail. They fail because we have not implemented the actual code yet.
This is the output I got from running the tests:

```
t/01-test.t .. 1/3
#   Failed test at t/01-test.t line 18.
#     Structures begin differing at:
#          $got->[1] = Does not exist
#     $expected->[1] = HASH(0x7f82fe213078)
# Looks like you failed 1 test of 3.
t/01-test.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/3 subtests

Test Summary Report
-------------------
t/01-test.t (Wstat: 256 Tests: 3 Failed: 1)
  Failed test:  3
  Non-zero exit status: 1
Files=1, Tests=3,  0 wallclock secs ( 0.04 usr  0.02 sys +  0.06 cusr  0.02 csys =  0.14 CPU)
Result: FAIL
```

## The implementation

{% include file="examples/markua-parser/c580d63/lib/Markua/Parser.pm" %}

In the parser I could have also copy-pasted the code to handle all 6 cases, but I felt that to be way to more complex
than changing the regex and the code appropriately. So the new version of the [regex](/regex) is a bit
more complex than [previously](/start-writing-the-markua-parser).

`/^(#{1,6}) (\S.*)/`

The `{1,6}` tells the regex to catch as many `#` characters as possible between 1 and 6. The parentheses
wrapping this part of the regex will capture the string and save it in `$1`. Because now we have two pair of parentheses
the second pair will save its content in `$2` (It was `$1` in the earlier version.)

In the anonymous hash the name of the tag is then generated from the letter `h` and the `length` of the captured string. The number of `#` characters. The text is now whatever the second pair of parentheses capture.

Running the tests again:

```
$  prove -l
```

The result is now success:

```
t/01-test.t .. ok
All tests successful.
Files=1, Tests=3,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.06 cusr  0.02 csys =  0.13 CPU)
Result: PASS
```

So we know both test cases pass. Both the single h1 header, we had earlier and the 6-headers version.

```
$ git  add .
$ git commit -m "process all 6 header levels of Markua"
$ git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/c580d63fb415bb80a68b7d3b87a8b7f338d21c31)

## Error handling? Incorrect Markua syntax?

We don't have any error handling yet, nor do we deal with incorrect Markua text.
Moreover I don't even know what should happen in those cases.

* What if there are 7 `#` characters or more?
* What if there are 2 spaces after the `#`. How should those string be parsed?
* Should the Markua parser accept a 3rd level header immediately after a 1st level header?

We'll have to deal with all that later on.

