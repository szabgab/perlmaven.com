---
title: "Moose: testing the setter and getter"
timestamp: 2016-11-11T23:00:11
tags:
  - Moose
types:
  - screencast
published: true
books:
  - moose
author: szabgab
---


In this part of the [Moose tutorial](/moose) we keep writing tests. This time for the accessors created for the attribute
we declared in the earlier example.


{% youtube id="y2O7qF7U9gs" file="advanced-perl/moose/test-setter-getter" %}

In order to test the setter and getter methods we enlarge the test script we had earlier.

```perl
use strict;
use warnings;
use v5.10;

use Test::More tests => 5;

use Person;

my $p = Person->new;
isa_ok($p, 'Person');

is($p->name('Foo'), 'Foo', 'setter');
is($p->name, 'Foo', 'getter');

my $o = Person->new( name => 'Bar' );
isa_ok($o, 'Person');
is($o->name, 'Bar');
```

In the line `is($p->name('Foo'), 'Foo', 'setter');` we call the setter and then we expect it to return the value we've just set.
The `is` function of Test::More receives 3 parameters: The actual value returned by the setter. The expected value ('Foo'), and the
name of the test which can be any string.

Testing the getter is similar.  `is($p->name, 'Foo', 'getter');` We call the getter and pass its return value to be the
first parameter of the `is` function. The second parameter is the expected value ('Foo'), and the third parameter is just the
name of this test.

Then, as we saw earlier, we can pass the attribute to the constructor already. So we are going to test that too.
So this time we call the constructor and pass a parameter to it. `my $o = Person->new( name => 'Bar' );`
Then we check if the returned value is really an instance of the **Person** class. Then, calling the getter
`is($o->name, 'Bar');` we check if the value was indeed set by the constructor.

In this example I've even forgot to add the third parameter that would be the description of the test.

we can run the tests now by typing in `prove -l t` and we get the following output:

```
t/01-name.t .. ok   
All tests successful.
Files=1, Tests=5,  1 wallclock secs ( 0.03 usr  0.01 sys +  0.27 cusr  0.04 csys =  0.35 CPU)
Result: PASS
```

## Verbose test running

If I want to see all the details of the test run, I can include the `-v` option on the command line and run
`prove -vl t`.
The output will look like this:

```

ok 1 - An object of class 'Person' isa 'Person'
ok 2 - setter
ok 3 - getter
ok 4 - An object of class 'Person' isa 'Person'
ok 5
ok
All tests successful.
Files=1, Tests=5,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.25 cusr  0.02 csys =  0.32 CPU)
Result: PASS
```

We can see the 5 test-cases.  As you can see each one of them has a name (after the -), except the last one,
where I left out the name. You can also see that `isa_ok` does not need an extra parameter
as it automatically generates one from the second parameter.

