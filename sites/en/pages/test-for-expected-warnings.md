---
title: "Test for expected warnings"
timestamp: 2016-10-12T19:30:01
tags:
  - Test::Warn
types:
  - screencast
published: true
books:
  - testing
author: szabgab
archive: true
---


There are many modules with functions that would give a warning in certain situations. This can be a deprecation warning,
when the function is left in to provide backward compatability, but you actually want to remove it in the future.

Or, it can be warning of improper input values if for some reason you do not want to throw an exception.

In either case, the warning must stay there as changes are made to the code-base. That warning is now part of API of the module
and as such we should write a test that will make sure the warning isn't removed by accident or by someone who
likes to eliminate warnings....


{% youtube id="U_aLg4YzeqQ" file="test-for-expected-warnings" %}

Let's see a simple example. Let's say the `fibonacci` function exported by the `MyTools` module will warn if
the user passes a negative number:

Our test script saved as `t/fibonacci_negative.t` looks like this:

```perl
use strict;
use warnings;

use Test::More tests => 1;

use MyTools;

my $result = fibonacci(-1);
is($result, 0, 'fibonacci on -1 returns 0');
```

If we run it using:

```
$ prove -l t/fibonacci_negative.t
```

We get the following output:

```
1..1
Given number must be > 0 at lib/MyTools.pm line 19.
ok 1 - fibonacci on -1 returns 0
```

As checked by the `is` function, the returned values were correct, but the warning was printed on the output of the script.

It is bad because an observer will notice the warning and start complaining that the test found some problems, and it is bad
because if the code in the module changes and the warning stops appearing no one will notice.

We need to capture the warning and check if the captured value is the expected string.

We could capture the warning ourself using `SIG{__WARN__}`, but just as we built a testing module
based on [Test::Builder](http://metacpan.org/pod/Test::Builder), there is also a testing module called [Test::Warn](http://metacpan.org/pod/Test::Warn)
that provides exactly this service.

```perl
use strict;
use warnings;

use Test::More tests => 2;
use Test::Warn;

use MyTools;


my $result;
warning_is {$result = fibonacci(-1)} "Given number must be > 0",
    'warning when called with -1';
is($result, 0, 'fibonacci on -1 returns 0');
```

After importing the [Test::Warn](https://metacpan.org/pod/Test::Warn) module it provides a number of testing functions
with a slightly strange syntax.

The functions are:

`warning_is` checks if the given piece of code generates exactly one warning and compares
the text of the warning exactly.

`warnings_are` expects a list of warnings and succeeds if the actual warnings came in the exact same order and had the exact same text.

`warning_like` expects one warning, but instead of comparing for equality it checks if the warning matches a given regular expression.

They are just like the `is` and `like` functions of [Test::More](https://metacpan.org/pod/Test::More), but of course,
they also capture a warning.

There are a few others, but I think these can give you the idea.

Now for the syntax:

Each one of these receives a block in curly braces `{}`, that is the code-block that will be executed, and then immediately
after it, without even a separating comma `,` we put the expected value(s). In case of `warning_is` this is a single string.
In case of `warnings_are`, this is a reference to an array of strings. In case of `warning_like` this is a regular
expression created using `qr`.

After that, separated by a comma, we can add the optional "name" parameter of this test unit.

As we would still also like to compare the value returned by the fibonacci function to some expected value, we need to assign it
to a variable, but because the `fibonacci` call is now in a block, we need to declare that variable outside of the block,
in order to still have access to it after the `warning_is` function has finished. That's why we declare `$result` before the
`warning_is` call.

Running the test script now `prove -l t/fibonacci_negative.t` will yield the following output:

```
1..2
ok 1 - warning when called with -1
ok 2 - fibonacci on -1 returns 0
```

