---
title: "Introducing test automation with Test::Simple"
timestamp: 2015-10-18T09:30:01
tags:
  - Test::Simple
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


Let's start by understanding the concept of automated unit tests. 


{% youtube id="NTQ7W1kCu74" file="introducing-test-simple" %}

Let's say we have a very simple file called `lib/MyCalc.pm` with the following content:

```perl
package MyCalc;
use strict;
use warnings;

use base 'Exporter';
our @EXPORT = qw(sum);

sub sum {
    return $_[0] + $_[1];
}

1;
```

How can we test if the `sum` function works properly?

## First test script

We can start by writing a script that will call the function, and pass certain input to it. We can print the return values
and observe them.

So we create a file called `test.pl` with the following content:

```perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use MyCalc;

print sum(1, 1), "\n";
print sum(2, 2), "\n";
print sum(2, 2, 2), "\n";
```

The directory layout looks like this:

```
root/
   lib/MyCalc.pm
   test.pl
```

The `$Bin` variable imported from the [FindBin](https://metacpan.org/pod/FindBin) module always contains the
directory of the currently executing perl script. `use lib "$Bin/lib";` ensures that the next line, `use MyCalc;`
will find the MyCalc.pm file in the `lib` subdirectory.

Then we have 3 examples calling the `sum` function and printing the result.

We can run our test script by typing in `perl test.pl` and the output is:

```
2
4
4
```

It does not take a lot of thinking to understand that the result of the 3rd call is incorrect, but it is very easy to actually overlook it.
That's how our brain works. Even in such a small example, the majority of people will not notice the problem. If this was some more complex
task, some elaborate business logic, then we can't expect our programmers or testers to actually know the expected results.
We would need to bring in a domain expert (or a manager) to provide us with input values and expected output values.

To make it easier for them we can change our code to also print the expected value next to the actual value:

## Print expected value

```perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use MyCalc;

print sum(1, 1),    " 2\n";
print sum(2, 2),    " 4\n";
print sum(2, 2, 2), " 6\n";
```

The output now looks like this:

```
2 2
4 4
4 6
```

## Let the computer compare

This is an improvement as now we don't need the expert any more, but it still needs a lot of attention to manually compare
the actual result with the expected result. Let's change our tests script to do that for us, and instead of the values,
print only `ok` on success and `not ok` on failure.

```perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use MyCalc;

if (sum(1, 1) ==  2) {
    print "ok\n";
} else {
    print "not ok\n";
}

if (sum(2, 2) == 4) {
    print "ok\n";
} else {
    print "not ok\n";
}

if (sum(2, 2, 2) == 6) {
    print "ok\n";
} else {
    print "not ok\n";
}
```

And the output:

```
ok
ok
not ok
```

## Refactoring and creating the ok() function

You might have noticed we had a lot of repetition in the above code. We could do much better.
Let's create a function called `ok()` that will receive a
[True or False](/boolean-values-in-perl) value and will print `ok` or `not ok` accordingly.

```perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use MyCalc;

ok(sum(1, 1) ==  2);
ok(sum(2, 2) == 4);
ok(sum(2, 2, 2) == 6);


sub ok {
    my ($true) = @_;
    if ($true) {
        print "ok\n";
    } else {
        print "not ok\n";
    }
}
```

The output is still the same:

```
ok
ok
not ok
```

## use Test::Simple

All that is fine, and this `ok()` really doesn't to much, but other people have already implemented it
and their `ok()` function is actually more powerful and it is part of a huge ecosystem for testing.
So let's replace our home-made `ok()` function by the one supplied by [Test::Simple](https://metacpan.org/pod/Test::Simple).

```perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";
use MyCalc;

use Test::Simple tests => 3;

ok(sum(1, 1) ==  2);
ok(sum(2, 2) == 4);
ok(sum(2, 2, 2) == 6);
```

The change was simple,  and the output of running `perl test.pl` is a bit more
verbose than what we had earlier. It looks like this:

```
1..3
ok 1
ok 2
not ok 3
#   Failed test at test.pl line 12.
# Looks like you failed 1 test of 3.
```

Test::Simple required us to state how many times we are going to call the `ok()` function,
that's the `tests => 3` in the use-statement.
In return it provided us with a counter and at the end it even reported that one out of three tests have failed.

We'll look at these features later on.

