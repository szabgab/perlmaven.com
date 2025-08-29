---
title: "Consider everything not recognizable as a paragraph in Markua"
timestamp: 2020-02-29T22:03:01
tags:
  - p
  - paragraph
published: true
books:
  - markua
author: szabgab
archive: true
---


Free text paragraphs seem to be the default mode in Markua. I am still wondering if there could be errors while parsing
a Markua file, or if we don't recognize something as a special tag, then it should be considered as a paragraph.

We are not there yet, but for example including a file looks like this:

```
![title](path/to/file.pl)
```

What if we have line like this:

```
![title](path/to/file.pl
```

That is, the closing parentheses is missing. Should we report this as a parsing error or consider this as a paragraph?

For now, I think, everything that is not exactly recognizable as some Markua code will be considered a paragraph.

So let's implement this now.


## Test case

I started by creating a test case. First the Markua file:

{% include file="examples/markua-parser/074f0d8/t/input/paragraphs.md" %}

(Oh, only after writing the article did I notice that the text in the input actually explains it incorrectly. Lines with content that come one after the other become the **same** paragraph instead of separate paragraphs.)

Then the expected DOM file in JSON format:

{% include file="examples/markua-parser/074f0d8/t/dom/paragraphs.json" %}

I've added the name of this test-case to the `@cases` array in the test script to have

```
my @cases = ('heading1', 'headers', 'paragraphs');
```

I won't go into the embarrassing details, but my first attempt implementing the code for this test case was not successful and the tests failed:

```
$  prove -l
```

```
t/01-test.t .. 1/7
#   Failed test 'Errors of paragraphs'
#   at t/01-test.t line 19.
#     Structures begin differing at:
#          $got->[0] = HASH(0x7fa13fa28168)
#     $expected->[0] = Does not exist
# Looks like you failed 1 test of 7.
t/01-test.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/7 subtests

Test Summary Report
-------------------
t/01-test.t (Wstat: 256 Tests: 7 Failed: 1)
  Failed test:  7
  Non-zero exit status: 1
Files=1, Tests=7,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.06 cusr  0.01 csys =  0.12 CPU)
Result: FAIL
```

As we can find out from the above output `Failed test 'Errors of paragraphs'` so the debated
section in the code, that one that is supposed to report if we cannot parse a section, the one that I thought
should never actually work, that's the part that collected some errors. So in my first implementation
some of the paragraphs were not parsed properly. But which ones?

## Better error reporting

In an earlier case, I've added a line to aid my debugging by printing out the content of the error array:

```
diag explain $errors;
```

Then, once I fixed the issue, I commented it out so we won't get the meaningless empty square brackets `[]` in the output.
I could enable it again, find the bug and disable it again, but I wanted a more permanent solution. So I changed the test code to look like this:

```
is_deeply $errors, [], "Errors of $case" or diag explain $errors;
```

The `is_deeply` function of Test::More, just as every other test-function, will return [true or false](/boolean-values-in-perl) depending on whether it was successful or not. So we can use the logical `or` operator and get the `diag explain $errors` part execute only if the test fails. Using (or abusing) the [short circuit in boolean expressions](/short-circuit)

That's perfect. We get the details when the test fails, but it remains silence when the test case is successful.

Here is how the test file looks now:

{% include file="examples/markua-parser/074f0d8/t/01-test.t" %}

Then I ran the tests again. This time I got the content of the `$errors` array reference.

```
$  prove -l
```

```
t/01-test.t .. 1/7
#   Failed test 'Errors of paragraphs'
#   at t/01-test.t line 19.
#     Structures begin differing at:
#          $got->[0] = HASH(0x7fb2b7211bb0)
#     $expected->[0] = Does not exist
# [
#   {
#     'line' => 'A line that will become a paragraph.
# ',
#     'row' => 1
#   },
#   {
#     'line' => 'After an empty row another line.
# ',
#     'row' => 3
#   },
#   {
#     'line' => 'And immediately after it another one. The two will become a separate paragraph.
# ',
#     'row' => 4
#   },
#   {
#     'line' => '    Even if there are 4 spaces at the beginning of the line. It is still the same paragraph.
# ',
#     'row' => 5
#   },
#   {
#     'line' => 'After several empty rows, another paragraph.
# ',
#     'row' => 9
#   }
# ]
# Looks like you failed 1 test of 7.
t/01-test.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/7 subtests

Test Summary Report
-------------------
t/01-test.t (Wstat: 256 Tests: 7 Failed: 1)
  Failed test:  7
  Non-zero exit status: 1
Files=1, Tests=7,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.07 cusr  0.02 csys =  0.14 CPU)
Result: FAIL
```

Basically every row in the input file was recognized as an error.
The strange thing is that the `$result` was as expected. So we did report every paragraph as expected, but
they were still reported as errors as well. Which should mean "We did not know how to parse these lines".

This is a common error, at least when I am the coder :) so it was rather easy to find.

The `next;` statement was missing from the code handling the not-empty rows. (line 36 in the module)
After I've added that `next` statement, all tests passed:

```
$  prove -l
```

```
t/01-test.t .. ok
All tests successful.
Files=1, Tests=7,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.07 cusr  0.01 csys =  0.11 CPU)
Result: PASS
```

At this point I could check in my changes:

```
$ git add .
$ git commit -m "parse paragraphs as well"
$ git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/074f0d87ca8e0ab0577104cf4bd0a24bf01f9c51)

## Explaining the implementation

{% include file="examples/markua-parser/074f0d8/lib/Markua/Parser.pm" %}

Every line that has some visible characters (matching `\S` is saved as part of the current paragraph.

Every time we encounter an empty row (at least empty to the casual viewer, meaning any character in it is white-space)
we need to end the current tag. Even if it is the default paragraph. In addition when we reach the end of the document
even without an empty row as the last line, we still would like to save that last paragraph.

So we put all the code that saves the current tag in a function called `save_tag`. In that function we also
reset the attribute called `tag` as this is the end of a tag in the document.


## Increased test coverage

A few minutes after I pushed out the changes to GitHub I received an e-mail from Coveralls:

![](/img/markua-parser-coveralls-coverage-increased-mail.png)

Apparently I've added more lines that were tested and thus the percentage of the code that is covered by tests increased.
The detailed report can be seen [here](https://coveralls.io/builds/15862795/source?filename=lib/Markua/Parser.pm).


