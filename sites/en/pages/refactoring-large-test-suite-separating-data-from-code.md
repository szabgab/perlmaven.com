---
title: "Refactoring large test suite - separating data from code"
timestamp: 2016-03-11T12:30:01
tags:
  - Test::Simple
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


If you follow through the request at the end of the [previous](/test-plan-and-test-descriptions) part,
you now have a test script with lots of tests. You might have noticed and got fed up with the repetition in that code.

Let's try to simplify that by separating the test data from the test code.


{% youtube id="RFHH3chwuuQ" file="refactoring-large-test-suite-separating-data-from-code" %}

## Enlarged test script

I know it has not been enlarged by a lot, just enough to feel that all those lines have a lot of similarity.

```perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use MyCalc;

use Test::Simple tests => 5;

ok sum(1, 1) == 2,    'sum(1, 1) = 2';
ok sum(2, 2) == 4,    'sum(2, 2) = 4';
ok sum(2, 2, 2) == 6, 'sum(2, 2, 2) = 6';

# negative numbers
ok sum(-1, -1)  == -2, 'sum(-1, -1) = -2';

# edge cases:
ok sum(1, -1)   == 0,  'sum(1, -1) = 0';
```


## Move test data to an array

We move all the test data to an array called `@cases`.
Each element of the array is itself a reference to an array. In these internal arrays,
the first value is always the expected result, and all the other values are the input to the `sum` function.
Then we have a loop going over the internal array references one-by-one. In each iteration we dereference the
array-ref and copy the values from it to `$exp`, the expected value, and <h>@params`, the parameters to
be passed to `sum`.

```perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use MyCalc;

my @cases = (
    [2,  1, 1],
    [4,  2, 2],
    [6,  2, 2, 2],
# negative numbers
    [-2, -1, -1],
# edge cases:
    [0,  1, -1],
);

use Test::Simple tests => 5;

for my $c (@cases) {
    my ($exp, @params) = @$c;
    ok sum(@params) == $exp
}
```

If we run `perl test.pl` we'll get the following:

```
1..5
ok 1
ok 2
not ok 3
#   Failed test at test.pl line 22.
ok 4
ok 5
# Looks like you failed 1 test of 5.
```

That looks almost ok, except that we have lost the test descriptions.
We could put those in the `@case` array as well, but because
in this case all the test descriptions are uniform, we can even generate them on the fly:


```perl
    my $descr = 'sum(' . join(', ', @params) . ") == $exp";
    ok sum(@params) == $exp, $descr;
```

The full `test.pl` now looks like this:

```perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use MyCalc;

my @cases = (
    [2,  1, 1],
    [4,  2, 2],
    [6,  2, 2, 2],
# negative numbers
    [-2, -1, -1],
# edge cases:
    [0,  1, -1],
);

use Test::Simple tests => 5;

for my $c (@cases) {
    my ($exp, @params) = @$c;
    my $descr = 'sum(' . join(', ', @params) . ") == $exp";
    ok sum(@params) == $exp, $descr;
}
```

This is  much cleaner than we had earlier, and the data (the content of `@cases`) is almost
totally separate from the code that executes it.
There is a little issue, though, that might bother you as a programmer
if you like [DRY](http://en.wikipedia.org/wiki/Don't_repeat_yourself).
Do you know what it is?


