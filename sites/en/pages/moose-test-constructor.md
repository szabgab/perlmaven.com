---
title: "Moose: Testing the constructor"
timestamp: 2016-10-29T15:00:11
tags:
  - Moose
types:
  - screencast
books:
  - moose
published: true
author: szabgab
---


Before going on using more of [Moose](/moose), let's see how can we test what we have so far.
After all writing tests is a nice way to show that our code works properly, and it is a nice and easy way to make sure
that even after we made further development, the other parts of the application still work.

Let's start by testing the constructor we created in the [previous episode](/moose-constructor).


<slidecast file="advanced-perl/moose/test-constructor" youtube="GnFTUi6Obt0" />

## Code layout

Actually, before we do that I need to make a slight correction.
In the [previous article](/moose-constructor) I mentioned the code layout to be like this:

```
 dir/
    person.pl
    Person.pm
```

This worked and made it simple to run the script, but in most cases the directory layout of a project is more nuanced.

Normally the modules are located inside the **lib/** directory of the project and the scripts live in
another subdirectory which is usually called **script/** or **bin/** as in this example:

```
 dir/
    script/
      person.pl
    lib/
      Person.pm
```

In that case, if our working directory is still the root of the project then we can run the script with the following command:

`perl -Ilib script/person.pl`

We had to supply the `-I` parameter to include the **lib/** directory in
[@INC](/how-to-add-a-relative-directory-to-inc), the module search path of Perl.


## Adding a test

The test scripts are located in the `t/` directory next to the `scirpt/` and `lib/` directories
and the have a `.t` extension:

```
 dir/
    script/
      person.pl
    lib/
      Person.pm
    t/
      01-name.t
```

Because by default the test script are executed in abc order, having a leading number makes it easy to
put basic tests first and more complex tests later using bigger numbers.

the `t/01-name.t` script looks like this:

```perl
use strict;
use warnings;
use v5.10;

use Test::More tests => 1;

use Person;

my $p = Person->new;
isa_ok($p, 'Person');
```

A test script is just a simple Perl script with slightly different way of working. They start with the usual
statements of `use strict;` and `use warnings`. We also add `use v5.10;` because we
are already used to that.

Then we load the [Test::More](https://metacpan.org/pod/Test::More) module and
using `tests => 1;` we declare how many unit-test we are going to run.
See the whole [testing series](/testing) for more details.

In the screencast I had two tests. The first one was

```perl
use_ok('Person');
```

which attempted to load the module and test if it was successful. This style of testing is
not recommended any more so I left it out from the example in article.

The next test was checking if the constructor created an instance of the **Person** class.
So we called the `new` constructor and then use the `isa_ok` function provided
by Test::More to check if the variable `$p` contains an object which is a Person-object.

We can run the test using **perl**:

```
perl -Ilib t/01-name.t
```

resulting in this output:

```
1..1
ok 1 - An object of class 'Person' isa 'Person'
```

or better yet we can use **prove**

```
prove -l t/
```

resulting in this output:

```
t/01-name.t .. ok   
All tests successful.
Files=1, Tests=1,  0 wallclock secs ( 0.03 usr  0.01 sys +  0.22 cusr  0.01 csys =  0.27 CPU)
Result: PASS
```

For **perl** we had to pass `-Ilib` to include the `lib/` directory in the `@INC`.
For **prove** it is enough to pass a single lower-case `-l` that will do the same.

In a large application we probably would not test low-level things such as the constructor being able to create
an object, as I could rely on the maturity of the Moose project.
