---
title: "Moving over to Test::More"
timestamp: 2016-04-16T08:30:01
tags:
  - Test::Simple
  - Test::More
  - ok
  - is
  - isnt
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


What we saw in the earlier articles and screencasts was an introduction to testing with Perl. We made some nice progress but we kept using
[Test::Simple](https://metacpan.org/pod/Test::Simple) which only provides a single `ok()` function with some additional features.

When a test case succeeds we get a nice `ok N` printed, but the problem is that even when a test case fails we only get a simple `not ok`
with the title of the test case, if we set one, and the line number. We could get so much more information. That's where
[Test::More](https://metacpan.org/pod/Test::More), and later a lot of other testing modules come in.

They allow us to be much more explicit in our testing functions and to get much more detailed error messages than just <b>not ok</b>.


{% youtube id="2HHhostZ0cE" file="moving-over-to-test-more" %}

## Where to get Test::More ?

Let's start by the simple fact that [Test::More](https://metacpan.org/pod/Test::More) lives in the same distribution that
contains [Test::Simple](https://metacpan.org/pod/Test::Simple) and that distribution is itself called
[Test-Simple](https://metacpan.org/release/Test-Simple). Then of course you'll probably be happy to hear that they are also
part of every standard Perl distribution, so by virtue of having perl, you should also have both of these modules.
(Unless your vendor decided to strip them out.)

Of course the version that is on CPAN is probably newer than the version in your perl distribution, so if you'd like to upgrade
it you can do it with the usual tools.

Now let's switch from Test::Simple to Test::More.

## Test::More is a drop-in replacement of Test::Simple

The good news is that Test::More is a simple superset of Test::Simple, so you can edit your test scripts, replace ::Simple by ::More and everything
will work (or fail) exactly the same way as it did before. Test::More also provides the same `ok()` function as Test::Simple does.

You can try the following test script:

```perl
use strict;
use warnings;

use lib 'lib';
use MyTools;

use Test::More tests => 3;
# Test::More instead of Test::Simple

ok( sum(1, 1)    == 2,  '1+1');
ok( sum(2, 2)    == 4,  '2+2');
ok( sum(2, 2, 2) == 6,  '2+2+2');
```

Running this script provides the following output:

```
1..3
ok 1 - 1+1
ok 2 - 2+2
not ok 3 - 2+2+2
#   Failed test '2+2+2'
#   at t/31.t line 12.
# Looks like you failed 1 test of 3.
```

We can see that the test where we add `2+2+2` fails, but we cannot see what we were really expecting nor what we actually received.
I know, most of us have a fairly good idea what should we expect from 2+2+2, but what if this was a more complex example and not even related to math?

That's where Test::More shines.

## is

The `is()` function provided by Test::More accepts 3 parameters:
* The actual result`
* The expected result`
* The name of the test case`

It compares the actual result with the expected result using `eq`. If they are equal, it prints `ok`.
If they are different, it prints `not ok`, and then it goes on to print the actual result and the expected result.
Let's see the above test script rewritten with `is()`:


```perl
use strict;
use warnings;

use lib 'lib';
use MyTools;

use Test::More tests => 3;

is( sum(1, 1),    2,     '1+1'   );
is( sum(2, 2),    4,     '2+2'   );
is( sum(2, 2, 2), 6,     '2+2+2' );
```

And the output from the script:

```
1..3
ok 1 - 1+1
ok 2 - 2+2
not ok 3 - 2+2+2
#   Failed test '2+2+2'
#   at t/32.t line 11.
#          got: '4'
#     expected: '6'
# Looks like you failed 1 test of 3.
```

This will make it much easier for an observer to understand the actual problem behind this test failure.

One minor thing that you might be put-off by is the fact that `is()` always uses `eq`.
The reason is that in almost every case, even when comparing numbers, the `eq()` will behave the same
as `==`. In the rare cases when you really need the numerical comparison of `==` you can use
the `cmp_ok` function that will be explained later.


## isnt

There is a negated version of the `is()` function called `isnt()`. It has the same syntax, but
it will compare the two values using `ne`. There isn't a lot of use of this, it is quite rare when 
all the expectations you can have is that something is not equal to some pre-defined value, but actually there is
one that might be useful.

Sometimes all you want is to make sure a variable is not equal to [undef](/undef-and-defined-in-perl).
See this sample test code:

```perl
use strict;
use warnings;

use Test::More tests => 2;

my $x;
isnt($x, undef);

$x = 1;
isnt($x, undef);
```

Running this script we'll get the following output:

```
1..2
not ok 1
#   Failed test at t/isnt_undef.t line 7.
#          got: undef
#     expected: anything else
ok 2
# Looks like you failed 1 test of 2.
```

The first test case fails because we expected a variable not to be `undef`, but it was.


