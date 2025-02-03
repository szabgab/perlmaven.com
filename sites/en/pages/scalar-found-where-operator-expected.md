---
title: "Scalar found where operator expected"
timestamp: 2013-02-15T01:05:06
tags:
  - syntax error
  - scalar found
  - operator expected
published: true
books:
  - beginner
author: szabgab
---


This is a really common error message I see. One that seems to be a bit difficult to understand.

The thing is, people think about <b>numerical operators</b> and <b>string operators</b>,
but they don't think about the comma `,` as an operator. For them the terminology of
the error message is a bit confusing.

Let's see a couple of examples:


## Missing comma

The code looks like this:

```perl
use strict;
use warnings;

print 42 "\n";
my $name = "Foo";
```

and the error message is

```
String found where operator expected at ex.pl line 4, near "42 "\n""
      (Missing operator before  "\n"?)
syntax error at ex.pl line 4, near "42 "\n""
Execution of ex.pl aborted due to compilation errors.
```

It clearly states the location of the problem, but as I see many people will rush
back to their editor trying to fix the issue even before reading the error message.
They make a change hoping that will fix the problem and then they get
another error message.

In this case the problem was that we have forgotten to add a comma `,` after the number 42.
The correct line would be  `print 42, "\n";`.


## String found where operator expected

In this code we have left out a concatenation operator `.`, and we got the same error message:

```perl
use strict;
use warnings;

my $name = "Foo"  "Bar";
```

```
String found where operator expected at ex.pl line 4, near ""Foo"  "Bar""
      (Missing operator before   "Bar"?)
syntax error at ex.pl line 54, near ""Foo"  "Bar""
Execution of ex.pl aborted due to compilation errors.
```

The intended code looks like this: `my $name = "Foo" . "Bar";`.

## Number found where operator expected

```perl
use strict;
use warnings;

my $x = 23;
my $z =  $x 19;
```

Generates this error message:

```
Number found where operator expected at ex.pl line 5, near "$x 19"
  (Missing operator before 19?)
syntax error at ex.pl line 5, near "$x 19"
Execution of ex.pl aborted due to compilation errors.
```

This code is probably missing an addition `+`, or multiplication `*` operator,
though that could be a repetition operator `x` as well.

## Syntax error while comma is missing

A missing comma is not always recognized as a missing operator.
For example this code:

```perl
use strict;
use warnings;

my %h = (
  foo => 23
  bar => 19
);
```

generates the following error message: <b>syntax error at ... line ..., near "bar"</b>
without any further details.

Adding a comma after the number 23 will fix the code:

```perl
my %h = (
  foo => 23,
  bar => 19
);
```

I even prefer to add a comma after every pair in a hash (so in this case, after the number 19 too):

```perl
my %h = (
  foo => 23,
  bar => 19,
);
```

This habit helps me to avoid this kind of syntax error most of the cases.


## Scalar found where operator expected at

```perl
use strict;
use warnings;

my $x = 23;
my $y = 19;

my $z =  $x $y;
```

```
Scalar found where operator expected at ... line 7, near "$x $y"
    (Missing operator before $y?)
syntax error at ... line 7, near "$x $y"
Execution of ... aborted due to compilation errors.
```

Again, there can be a numerical or a string operator between $x and $y.

## Array found where operator expected

```perl
use strict;
use warnings;

my @x = (23);
my $z =  3 @x;
```

## What other cases do you encounter often?

Do you have other interesting cases where we get this type of syntax error?


