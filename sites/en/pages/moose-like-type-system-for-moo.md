---
title: "Moose-like type checking system for Moo"
timestamp: 2015-05-05T08:00:01
tags:
  - Moo
  - MooX::late
books:
  - moo
published: true
author: szabgab
---


Unlike its bigger brother, Moo does not come with a built-in type system.
Instead, it allows us to add [home-made subroutines](/type-checking-with-moo)
to each attribute that will check the type when we call the constructor or a setter.

MooX::late is a an extension for Moo, that provides several features available in
[Moose](/moose), but not in [Moo](/moo).

For example, it allows us to set type-constraints in a declarative way
using [Types::Standard](http://metacpan.org/module/Types::Standard)
as the back-end.

Let's see a bit more details how does that work:


## No constraint

Let's start by an example without any constraint.

The `Person.pm` file contains the following code:

```perl
package Person;
use 5.010;
use Moo;

has name => (is => 'rw');

1;
```

The `person.pl` file in the same directory contains the following:

```perl
use strict;
use warnings;
use 5.010;

use Person;
my $student = Person->new(name => 'Foo');
say $student->name;
```

If we run `perl person.pl` it will print `Foo`.
There is nothing special about this.

## Introducing type constraints

The person will have a height as well, and we would like to make sure
the hight is always set as an integer number. (We just need to
decide if we measure in cm or inches.)

Add this to `Person.pm`

```perl
use MooX::late;

has height => (is => 'rw', isa => 'Int');
```

And change the script `person.pl` to this:

```perl
use Person;
my $student = Person->new(name => 'Foo', height => 180);
say $student->name;
say $student->height;
```

Running the script will print out the name and height as expected.
Still nothing interesting. So let's change the script now and try
this code:

```perl
my $student = Person->new(name => 'Foo', height => 'tall');
```

Running `perl person.pl` will generate an exception:

`Value "tall" did not pass type constraint "Int" (in $self->{"height"}) at (eval 230) line 39.`

It is clear what is the problem, but unfortunately it does not say in which file
and in which line of that file did we provide the incorrect value.

Besides `Int`, there are a number of other types supplied by
[Types::Standard](http://metacpan.org/module/Types::Standard).

## Use class-name as constraint

Besides the predefined types, we can also use the name of any class as a
type-constraint. For example we might want to have a `birthdate`
that is a [DateTime](http://metacpan.org/module/DateTime) object.
We can change the `Person.pm` file to have

```perl
has birthdate => (is => 'ro', isa => 'DateTime');
```

Then if we change our script and write

```perl
my $student = Person->new(name => 'Foo', birthdate => '1987-12-18');
```

We will get an exception:

`value "1987-12-18" did not pass type constraint (not isa DateTime) (in $self->{"birthdate"}) at`

Again, the error message describes the problem well, but does not say where should we look to fix it.
If we change the script to the following:

```
use DateTime;
my $student = Person->new(
    name => 'Foo',
    birthdate => DateTime->new(year => 1987, month => 12, day => 18),
);
say $student->name;
say $student->birthdate;
```

It will work and we will get the following output:

```
Foo
1987-12-18T00:00:00
```

The stringified value of DateTime object contains the hours, minutes and seconds as well, 
that we have not set so they default to 0.
We can get DateTime to print only the Year/Month/Day part or in short `ymd`:

```perl
say $student->birthdate->ymd; # 1987-12-18'
```

Will print `1987-12-18`.

## Our class as a type constraint

Any class-name can be used as type constraint. The class can come in the form of a CPAN module,
or it can be one we created for our project. A class can even use itself as one of the constraints.
For example, each Person has a mother, who is also a Person. We change the `Person.pm` file
to have the following:

```perl
has mother => (is => 'rw', isa => 'Person');
```

and the `person.pl` script to have this:

```perl
my $student = Person->new(name => 'Foo', mother => 'Bar');
```

Running the script will give an exception:
`value "Bar" did not pass type constraint (not isa Person) (in $self->{"mother"})`
That's because we were expecting an object of type "Person" and not just a string.
Let's try that by changing our script:

```perl
my $visitor = Person->new(name => 'Bar');
my $student = Person->new(name => 'Foo', mother => $visitor);
say $student->name;
say $student->mother->name;
```

First we create the object representing the mother, who is visiting her child,
hence the variable is called `$visitor`, then we pass this new object to
the constructor.

The output is what you might have expected:

```
Foo
Bar
```

