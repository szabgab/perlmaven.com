---
title: "Testing a simple Perl module"
timestamp: 2013-12-25T17:30:01
tags:
  - testing
  - TAP
  - Test::Simple
published: true
books:
  - testing
author: szabgab
---


Let's assume you have just started to write a new module in Perl,
and you would like to go with the flow and start by writing some
automated tests.

In order to make it simple I use the good old math example.


It is probably a good idea for any project to follow the
<b>best practices</b> of the Perl community, and create the layout
of the project as most of the CPAN modules are structured.
This means you will have all the files of the project,
the modules, the tests and all other auxiliary files in a
single directory structure.

Within that structure the modules are going to be in the `lib/`
subdirectory, and the test scripts will be in the `t/` subdirectory.
The tests are simple perl scripts but with a `.t` extension.

```
root/
  lib/Math.pm
  t/01_compute.t
```

We created the first version of our `Math.pm` module, and placed it
in `lib/Math.pm`.

## The module

The lib/Math.pm file looks like this:

```perl
package Math;
use strict;
use warnings;
use 5.010;

use base 'Exporter';
our @EXPORT_OK = qw(compute);

sub compute {
  my ($operator, $x, $y) = @_;

  if ($operator eq '+') {
      return $x + $y;
  } elsif ($operator eq '-') {
      return $x - $y;
  } elsif ($operator eq '*') {
      return $x - $y;
  }
}

1;
```

I won't go into details now but you can use it like this:

```perl
use 5.010;
use Math qw(compute);
say compute('+', 2, 3);    # will print 5
```


## The Test

The test script needs to call the `compute()` function and check if the resulting
value is the same as we expected. To follow the conventions we create a file in
the `t/` directory with a `.t` extension:

`t/01_compute.t` contains the following:

```perl
use strict;
use warnings;
use 5.010;

use Test::Simple tests => 2;

use Math qw(compute);

ok( compute('+', 2, 3) == 5 );
ok( compute('-', 5, 2) == 3 );
```


## Run the test script

Once we have this we can run the script by typing

```
perl t/01_compute.t
```

while being in the root directory of the project.

If we are lucky we get an error message that looks like this:

```
1..2
Can't locate Math.pm in @INC (@INC contains:
  /etc/perl /usr/local/lib/perl/5.12.4 /usr/local/share/perl/5.12.4
  /usr/lib/perl5 /usr/share/perl5 /usr/lib/perl/5.12 /usr/share/perl/5.12
  /usr/local/lib/site_perl .) at t/01_compute.t line 7.
BEGIN failed--compilation aborted at t/01_compute.t line 7.
# Looks like your test exited with 2 before it could output anything.
```

This happens because the perl script cannot find the `Math.pm` in any
of its standard directories and it does not know it should look inside
the `lib/` directory.

I wrote "if we are lucky" because that's the better case. The unlucky case
is if we already have a previous version of this module installed.
In that case perl will pick up that version of `Math.pm`, and not the one
we are currently writing. This can lead to all kind of unpleasant feelings
when you spend hours trying to figure out why changing `lib/Math.pm` does
not impact the execution of the test script.

Trust me, it happens to all of us.

In order to ensure your perl finds the correct version of your module
you need to tell it where to look for the module. The usual way to do this
is to supply the path via the `-I` command-line parameter,
as [explained elsewhere](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations).

```
perl -Ilib t/01_compute.t
```

the output will look like this:

```
1..2
ok 1
ok 2
```

## Use prove

An even better way to run your test script is with the `prove` command.
You also have to tell it to use the modules currently under development
but it is simpler. You only have to provide the `-l` flag as it already
knows the modules should be in the `lib/` subdirectory.

```
prove -l t/01_compute.t
```

The output is a little different than before:

```
t/01_compute.t .. ok
All tests successful.
Files=1, Tests=2,  0 wallclock secs
  ( 0.04 usr  0.00 sys +  0.02 cusr  0.00 csys =  0.06 CPU)
Result: PASS
```

## Explanation

Now let's see some explanation. I won't explain the content of `Math.pm`,
that's not in the focus of this article. I look at the test script and the output.

The interesting parts of the test are the following:

```perl
use Test::Simple tests => 2;

ok( compute('+', 2, 3) == 5 );
ok( compute('-', 5, 2) == 3 );
```

First, we load the [Test::Simple](https://metacpan.org/pod/Test::Simple) module,
that is the most simple structured way in Perl to write tests,
and we tell it how many test units we are going to have.
That is, how many times we are going to
call the `ok()` function that came with [Test::Simple](https://metacpan.org/pod/Test::Simple).

This is the call that generates the `1..2` in the output stream.

We declare this so [Test::Simple](https://metacpan.org/pod/Test::Simple) will be able to notice
if we have not executed the same number of test units as
we planned.

The `ok()` function is a very simple one. It gets a single scalar
value and prints "`ok`" if the value was true,
or prints "`not ok`", if the value was false.
It also counts how many times it was called
and prints this number at the end. That's how we get the output:

```
1..2
ok 1
ok 2
```

The code inside the `ok()` call, for example this:

```perl
compute('+', 2, 3) == 5
```

is just calling the `compute()` function and compares the
result to the expected value. This will be true if they
are equal and false if they are not.

## TAP

The output generated when we ran the script directly using perl
is called [TAP, the Test Anything Protocol](/tap-test-anything-protocol).

When we used `prove()`, it ran the test script,
collected and parsed the TAP output and generated a report about it.

This looks less interesting now, but if you had several
tests scripts with hundreds of test it would be a lot
better to see the report generated by prove than the raw TAP
output.

## Comments

Thanks for the tutorial, and everything.
Nice if you could add
ok( compute('*', 5, 2) == 10 );
Since, your code above defines it as
elsif ($operator eq '*') {
return $x - $y;
}


