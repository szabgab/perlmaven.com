---
title: "Moose testing type constraint"
timestamp: 2016-11-23T08:21:11
tags:
  - Moose
  - has
  - rw
  - new
  - constructor
types:
  - screencast
books:
  - moose
published: true
author: szabgab
---


In the [previous episode](/moose-type-constraint) of the [Moose tutorial](/moose) we saw how to
declare a type-constraint, and what happens if we call a setter with a value that does not pass this type-checking.

This time we'll write formal tests for these cases. Especially interesting how to test that the class indeed throws the
exception when it receives values that don't pass the type-checking.

At first it might be a bit strange that we test if there was an exception, but this exception is part of
the API of the module. We want to make sure that even if the implementation of the module changes,
it will still throw an exception.


{% youtube id="Ja60YykI-1w" file="advanced-perl/moose/test-type-constraint" %}


Here is the new test script:

```perl
use strict;
use warnings;
use v5.10;

use Test::More tests => 6;
use Test::Exception;

use Person;

my $p = Person->new;
isa_ok($p, 'Person');

is($p->name('Foo'), 'Foo', 'setter');
is($p->name, 'Foo', 'getter');

is($p->year(2000), 2000);
is($p->year, 2000);

my $def_err  = qr{Attribute \(year\) does not pass the type constraint because:};
my $home_err = qr{Validation failed for 'Int' with value 23 years ago};

throws_ok { $p->year('23 years ago') } qr{$def_err $home_err}, 'exception';
```

First we added a call the setter and getter of the new attribute with good values,
to make sure they work:

```perl
is($p->year(2000), 2000);
is($p->year, 2000);
```

Then, in order to test the exception, we used a new module called [Test::Exception](https://metacpan.org/pod/Test::Exception)
that fits nicely in the [Test::More](https://metacpan.org/pod/Test::More) world as described the in [testing](/testing)
series. This module provides us with some extra testing functions such as `throws_ok` that behave similarly to the `ok()`
functions of Test::More such as the `is` function or the `isa_ok` function.

`throws_ok` gets 3 parameters. The first one is a block. This is the block that's going to be executed.
The second one is a regular expression quoted with `qr` that should match the exception that was thrown in the block.
The third one is just the name of the test like in the `is()` function.
(Something I missed in the tests checking the setter and getter with good values.)

Please, pay attention, there is no comma `,` after the block received by `throws_ok`.

If we now run `prove -l t` then we can see that everything is fine:

```
$ prove -l t

t/01-name.t .. ok   
All tests successful.
Files=1, Tests=6,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.34 cusr  0.05 csys =  0.44 CPU)
Result: PASS
```


If we run it in verbose mode:

```
$ prove -lv t/

ok 1 - An object of class 'Person' isa 'Person'
ok 2 - setter
ok 3 - getter
ok 4
ok 5
ok 6 - exception
ok
All tests successful.
Files=1, Tests=6,  0 wallclock secs ( 0.03 usr  0.01 sys +  0.32 cusr  0.03 csys =  0.39 CPU)
Result: PASS
```

we can see that **exception** is the name of the test, and the previous two tests have no
names, because I've forgotten to add them to the tests.

We don't see the actual exception, because it was "eaten" by the `throws_ok` function
and was checked against the regular expression.

So from now on, if someone changes the code and it stops throwing an exception, or it starts throwing
a different exception the test will fail and you'll have to decide if the change was made correctly,
and then update the test to reflect the new expectation, or if that was by mistake and we
have to fix the code.
