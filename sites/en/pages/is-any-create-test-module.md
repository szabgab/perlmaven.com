---
title: "Creating a testing module"
timestamp: 2016-09-25T08:30:01
tags:
  - Test::More
  - is_any
  - any
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


In the previous screencast we [created the is_any test function](/is-any-to-test-multiple-expected-values).
This time we are going to move it to a separate module to be useful in other test scripts and to other test developers as well.


{% youtube id="p5hYAkDkc1g" file="is-any-create-test-module" %}

We can now reuse the `is_any` function in this test script, but what if we would like to use it in several scripts?
What if we would like to allow other people in our organization to use it? And what if we want to share it via CPAN
so everyone using Perl will benefit from it?

In either case we need to create a module that provides this function. If we also want to share it publicly,
we will need to create a distribution, but in any case first we need to create a module. We will use it like this:

```perl
use Test::More tests => 8;
use Test::Any qw(is_any);
```

And then in that test-script we can freely use the `is_any` function.

As our first step, we create a standard-looking file called `Test/Any.pm` and move the
`is_any` function there:

```perl
package Test::Any;
use strict;
use warnings;

our $VERSION = '0.01';

use Exporter qw(import);
our @EXPORT_OK = qw(is_any);

use List::MoreUtils qw(any);

sub is_any {
    my ($actual, $expected, $name) = @_;
    $name ||= '';

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    ok( (any {$_ eq $actual} @$expected), $name)
        or diag "Received: $actual\nExpected:\n" .
            join "", map {"         $_\n"} @$expected;
}

1;
```

We declared the `$VERSION` variable, just because it is good practice, and we also had to export the `is_any` function.
For this we load the [Exporter](https://metacpan.org/pod/Exporter) module and import the `import` function from it.
(I know, it is a bit strange, I'll explain it in a separate article.)

Then, we also need to declare which functions are we ready to export. We do this by listing them in the `@EXPORT_OK` variable
declared using `our`.

That's it.

Except that we have a problem. In our code we call the `is` function and the `like` function and they are provided by
`Test::More`. We should also load the `Test::More` module, but that's not really proper. That module should be only loaded
by actual test scripts that will also set a plan.

Instead, what we need to do is reach to the engine behind `Test::More`, and behind the plethora of `Test::*` modules on CPAN that provides
this functionality. Namely, we need to use [Test::Builder::Module](https://metacpan.org/pod/Test::Builder::Module).

After loading that module we can call `my $Test = Test::Builder::Module->builder;` which will return the object that describes
the currently running test. As this module is a singleton, there is alwas going to be only one such object in every process.

This is the object that supplies the `ok` method and the `diag` method that are behind the respective functions of
`Test::More`. Our code changes to the following:

```perl
package Test::Any;
use strict;
use warnings;

our $VERSION = '0.01';

use Exporter qw(import);
our @EXPORT_OK = qw(is_any);

use List::MoreUtils qw(any);

use Test::Builder::Module;


my $Test = Test::Builder::Module->builder;


sub is_any {
    my ($actual, $expected, $name) = @_;
    $name ||= '';

    $Test->ok( (any {$_ eq $actual} @$expected), $name) 
        or $Test->diag("Received: $actual\nExpected:\n" 
             . join "", map {"         $_\n"} @$expected);
}

1;
```

Please note, we don't need to adjust the `Level` variable any more. That's because now our `is_any` function is at the same level
as the ok/is/like/etc... functions exported by `Test::More`. We created a function equivalent to the functions of `Test::More` and of
`Test::*` modules.

We just need to be able to distribute this and the user needs to be able to load it via a `use` statement.

