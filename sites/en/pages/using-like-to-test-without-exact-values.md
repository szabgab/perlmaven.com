---
title: "Using 'like' to test without exact values"
timestamp: 2016-05-27T08:30:01
tags:
  - Test::More
  - like
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


When testing a function, the best is if we can test that the function returns exactly what we expected.
Unfortunately this is not always possible or worth the effort. For example, what if part of the return value
is a timestamp that will be different every time we run the script?
We can [mock the time](/testing-session-mocking-time) to pretend it is some other time 
of the year, but even that might not work out. If we get a newer machine, the process might run faster
and the returned time might not be exactly the same.

So we need to be more flexible with our testing.


{% youtube id="2ENtXv_PaG4" file="using-like-to-test-without-exact-values" %}

## Timestamp

Let's take for example this subroutine:

```perl
sub last_update {
   return "This page was last updated at " . DateTime->now;
}
```

If we call this subroutine it will return `This page was last updated at 2014-09-23T04:43:44`.
But it will return it only once at that exact second. (Wow, was I really awake at 4 am, or is this
giving me the time in London?)

So test code like this won't work well:

```perl
is( last_update(), 'This page was last updated at 2014-09-23T04:43:44', 'last_update' );
```


### Disregard the timestamp

So how can we test if the subroutine returns the correct value?
(For the purpose of this example, I've included the `last_update` function in the test script,
but in normal situations that would be in a real module.)

We can use a regular expression to check if the returned string contains the text we expect and we can
just disregard the time. We can use the `ok()` function to check and report if the match was correct,
but as we have already learned, there are better tools that will be especially interesting if the test
actually fails.

```perl
use strict;
use warnings;

use Test::More tests => 1;
use DateTime;

diag last_update();
ok( last_update() =~ /^This page was last updated at/, 'last_update' );

sub last_update {
   return "This page was last updated at " . DateTime->now;
}
```

### Using like

The `like` function provided by [Test::More](http://metacpan.org/pod/Test::More),
accepts 3 parameters. The actual returned value. A regular expression created using `qr`,
and the optional name of the test. It will apply regex matching between the first two parameters.
It will print **ok** if there is a match and **not ok** with some details when there is no match.
So we can rewrite the above test case as follows:

```perl
like( last_update(), qr/^This page was last updated at/, 'last_update' );
```

You won't see any difference in the results as the regexes match.

However there is another issue here. In this test we have basically disregarded anything that got returned after the
word 'at'. The function might not return a timestamp, or it might return some 4-letter words after the 'at' and
we won't catch it with this test.

The middle-ground between exact value that will never succeed, and matching only the prefix that can succeed even when
the code behind it is broken, is to use a more specific regex:

```perl
like( last_update(),
    qr/^This page was last updated at \d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d$/, 'last_update full match');
```

In this case we only expect a certain format of the timestamp, but we don't care about the specific date.

## Full script

```perl
use strict;
use warnings;

use Test::More tests => 3;
use DateTime;

diag last_update();
ok( last_update() =~
    /^This page was last updated at/, 'last_update =~');

like( last_update(),
    qr/^This page was last updated at/, 'last_update like');

like( last_update(),
    qr/^This page was last updated at \d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d$/, 'last_update full match');


sub last_update {
   return "This page was last updated at " . DateTime->now;
}
```

The output of `perl last_update.t`:

```
1..3
# This page was last updated at 2014-09-23T06:10:48
ok 1 - last_update =~
ok 2 - last_update like
ok 3 - last_update full match
```

## Displaying errors

So what if someone changes the `last_update` function to the following:

```perl
sub last_update {
   return "This page was last updated at " . DateTime->now->ymd;
}
```

If we run the test script again we get:

```
1..3
# This page was last updated at 2014-09-23
ok 1 - last_update =~
ok 2 - last_update like
not ok 3 - last_update full match
#   Failed test 'last_update full match'
#   at last_update.t line 14.
#                   'This page was last updated at 2014-09-23'
#     doesn't match '(?^:^This page was last updated at \d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d$)'
# Looks like you failed 1 test of 3.
```

The first two test-cases have printed `ok` as they have both disregarded the time-stamp.
The 3rd test will fail and print an interesting diagnosis. It will print the actual string we have
passed to `like()` as the first parameter and the regex we were trying to match.


## Conclusion

If you cannot check the exact return value, you don't have to totally disregard part of the result.
You can create a regex and use `like` to check if the return looks similar to what we expected.


