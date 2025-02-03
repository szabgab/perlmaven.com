---
title: "Test diagnostic messages using diag, note, and explain"
timestamp: 2016-04-21T19:30:01
tags:
  - Test::More
  - diag
  - note
  - explain
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


In addition to the various functions that improved on the `ok()` function, such as [is and isnt](/moving-over-to-test-more),
[Test::More](https://metacpan.org/pod/Test::More) also provides a few functions to help display extra diagnostic messages.


{% youtube id="QBGIsZqolIs" file="diag-note-explain" %}

While we could use simple `print` statements instead of these functions, using these functions will ensure that our diagnostic messages won't
interfere with any future changes in [TAP, the Test Anything Protocol](/tap-test-anything-protocol). So it is worth using them
instead of `print`.

## diag

`diag()` accepts a list of values, and will print it to the Standard Error stream of the test script preceded by a `#` sign to indicate
to the [TAP processor harness](/prove-the-harness) that this is just a comment. Not part of the protocol.

Given this script:

```perl
use strict;
use warnings;

use lib 'lib';
use MyTools;

use Test::More tests => 3;

diag "Add two numbers";
is(sum(1, 1),    2,     '1+1');
is(sum(2, 2),    4,     '2+2');

diag "Add 3 numbers";
is(sum(2, 2, 2), 6,  '2+2+2');
```

The output will look like this:

```
1..3
# Add two numbers
ok 1 - 1+1
ok 2 - 2+2
# Add 3 numbers
not ok 3 - 2+2+2
#   Failed test '2+2+2'
#   at t/33.t line 14.
#          got: '4'
#     expected: '6'
# Looks like you failed 1 test of 3.
```

## note

When running the test script directly `note()` does the same as `diag()`, printing the parameters to STDERR.
The difference occurs when we run the script under harness using `prove`. In that case messages printed using `diag()`
will still show up, while messages printed by `note()` will be hidden.

This is a simple test script with a `diag()`, a `note()`, and a single `ok()` call.
```perl
use strict;
use warnings;
use Test::More tests => 1;


diag "This is from diag";
note "This if from note";
ok 1;
```

`perl test.pl` results in this output, where both diag and note messages can be seen:

```
1..1
# This is from diag
# This if from note
ok 1
```


Running via the harness using `prove test.pl` will generated this output, where
only the diag message will show up.

```
# This is from diag
test.pl .. ok   
All tests successful.
Files=1, Tests=1,  1 wallclock secs ( 0.03 usr  0.00 sys +  0.02 cusr  0.00 csys =  0.05 CPU)
Result: PASS
```


## explain

`explain` comes in handy when we need to print out complex data structures. It is like a smart version of
[Data::Dumper](https://metacpan.org/pod/Data::Dumper). If we give it a simple scalar it will return
the same scalar and if we give it a reference to a data structure, we get a nicely formatted version of that data
structure. Of course we still need to print it using either `diag()`, or `note()`, but it is nice
and compact.

This sample script has 3 variables. First we call `diag()` passing each one of the variables. This produces
readable output only if the variable had scalar content such as a string or a number. Then we call `diag()`
3 times passing what `explain()` returned.

```perl
use strict;
use warnings;

use lib 'lib';
use MyTools;

use Test::More tests => 2;


is(sum(1, 1),    2,     '1+1');
is(sum(2, 2),    4,     '2+2');

my $x = "String data";
my $y = [ 1, 2, 3 ];
my %h = (
    foo => 'bar',
    numbers => [ 42, 17 ],
);

diag $x;
diag $y;
diag \%h;

diag explain $x;
diag explain $y;
diag explain \%h;
```

In the resulting output we can see the usefulness of `explain` to understand what's going on in a test script.

```
1..2
ok 1 - 1+1
ok 2 - 2+2
# String data
# ARRAY(0x7f8151804268)
# HASH(0x7f81520737e8)
# String data
# [
#   1,
#   2,
#   3
# ]
# {
#   'foo' => 'bar',
#   'numbers' => [
#     42,
#     17
#   ]
# }
```


## When to use diag, note, and explain?

If within a test script we have multiple areas that we are testing, it can be a god idea to
use `diag` or `note` to mention this before the section.

If a test will take a long time and will seem to be "stuck", it can be a good idea to warn the user
beforehand.

When debugging a test script it is definitely a good idea to print the content of variables using `diag explain`.

Sometimes the test script will have strange output that looks like a failure or that have windows opening and closing
on the desktop. It would be a good idea to warn the user about these.

If a test case fails, the appropriate `ok` or `is` function will return false. It can be a good idea to print
extra information using the following construct:

```perl
ok $condition, 'name' or diag explain $variable;
```

I can even imaging test cases that will explain how to report bugs if a
[test fails](/what-is-the-status-of-the-current-test-script).


