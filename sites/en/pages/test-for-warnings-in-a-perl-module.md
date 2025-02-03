---
title: "Test for warnings in a Perl Module"
timestamp: 2012-07-03T10:10:10
tags:
  - warnings
  - __WARN__
  - Test::Warn
published: true
books:
  - testing
author: szabgab
---


There are cases when you write a Perl module that - as part of its API -
issues warnings in certain cases.

It would be nice if we could make sure these warnings won't disappear
when someone changes the code later trying to fix some bug or add some feature.

Probably the easiest way to do this, is to write a test case that checks
if you get the warning at the right time.


For example your module has a function parsing a log file.
What happens when one of the rows is broken?
Will your function throw an exception?
Will it disregard the incorrect line and silently continue?
Will it give a warning and continue?

Maybe there is a function which is deprecated,
and which should give a warning when it is invoked but
then still work properly. At least till it gets removed.

You would like to make sure the warning remains there
and it is not removed or hidden by mistake or by
someone who did not know the warning is part of the API.

How can you test your code to make sure it gives a
warning at the right time?

## The warning signal __WARN__

In Perl, every call to <b>warn</b> emits an internal signal. You can set up your test code to
[capture and save any warnings](/how-to-capture-and-save-warnings-in-perl)
using <b>$SIG{__WARN__}</b> and then examine if the warning was the right one.

Something like this:

```perl
{
  my @warnings;
  local $SIG{__WARN__} = sub {
     push @warnings, @_;
  };
  process_log();
  is scalar(@warnings), 1, 'exactly one warning';
  like $warnings[0], qr{Invalid row}, 'warning of invalid row';
}
```

What if we would like to test this for several different cases?
Will we have to copy part of this code again and again?
Will we create our own function to do this?

## Test::Warn

Luckily Janek Schleicher has already done that when he created
the [Test::Warn](http://metacpan.org/module/Test::Warn) module which is currently maintained
by [Alexandr Ciornii](http://chorny.net/).

You can use the convenience functions provided by this module and
you don't need to reinvent this wheel.

Using this module, the above code would be reduced to

```perl
warning_like { process_log() } qr{Invalid row}, 'warning of invalid row';
```

Note, there is a block around the function call and there is no comma
between the block and the expected regular expression.


