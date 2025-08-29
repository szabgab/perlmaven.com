---
title: "Moo and required attributes"
timestamp: 2015-03-12T10:13:10
tags:
  - Moo
  - required
published: true
books:
  - moo
author: szabgab
---


Earlier we saw how to [create a class with attributes](/oop-with-moo) and how
to set up [type checking](/type-checking-with-moo) in the setters.

In this article you'll see how to set an attribute to be **required**.


Let's start with a simple example:

## required

The Person class has a single read-write attribute called 'name':

This is the `Person.pm` file:

```perl
package Person;
use Moo;

has name => (is => 'rw');

1;
```

In the script where we use the class, we create an object without passing any value to the 'name' attribute.
If we then try to print it we get a [use of uninitialized value](/use-of-uninitialized-value) warning.

This is the `programming.pl`:

{% include file="examples/moo-required/programming.pl" %}

```
Use of uninitialized value in say at programming.pl line 7.

DONE
```

How can we make sure the attribute is always set?

We can set it to be a **required** attribute:

Let's change `Person.pm` to be:

{% include file="examples/moo-required/Person.pm" %}

If we now run `perl programming.pl` we get the following exception:

```
Missing required arguments: name at (eval 13) line 30.
```

This is the error you get from Moo 1.002000

I raised the issue both with the author and on [Perl Monks](http://www.perlmonks.org/?node_id=1039117)
and while my fix was not accepted, it seems there will be some improvement in a later version of Moo.

I checked it again with Moo version 2.000000 and now I got the following error:

```
Missing required arguments: name at (eval 9) line 49.
```

In any case there is a tool that we can use for some temporary improvement:

Add `use Carp::Always;` to either programming.pl or Person.pm and run `perl programming.pl` again, or
run `perl -MCarp::Always programming.pl`.

This time the exception will look like this:

```
Missing required arguments: name at (eval 13) line 30.
    Person::new('Person') called at programming.pl line 7
```

In the second line of the exception we can see the point in our code
where we made the problematic call.

Of course if the code using the Person class is a bit more complex, like in the next examples:

```perl
use strict;
use warnings;
use 5.010;

use Person;

foo();

sub foo  {
   bar();
}

sub bar {
  my $anonymous = Person->new;
  say $anonymous->name;
  say 'DONE';
}
```

then the error message will be bigger as we get the full stack trace from the
beginning of the script:

```
Missing required arguments: name at (eval 13) line 30.
    Person::new('Person') called at programming.pl line 15
    main::bar() called at programming.pl line 10
    main::foo() called at programming.pl line 7
```

We will have a harder time noticing the source of the problem, which is in
the second line of the output.

Calling the constructor with a value for 'name' would work:

```perl
my $anonymous = Person->new(name => 'Foo');
```

generating the expected output:

```
Foo
DONE
```

## Passing undef to the attribute

Of course, one might pass [undef](/undef-and-defined-in-perl) as the value of an attribute,
either by mistake: (The get_name function might return undef in some cases and we forget to check it)

```perl
my $name = get_name();

my $anonymous = Person->new(name => $name);

sub get_name {
   # not yet implemented
}
```

or even on purpose:

```perl
my $anonymous = Person->new(name => undef);
```

In either cases we get the same [use of uninitialized value warning](/use-of-uninitialized-value)
but the code keeps running:

```
Use of uninitialized value in say at programming.pl line 7.

DONE
```

We can avoid this by adding [type checking](/type-checking-with-moo) to our class making sure
the value is always, at least **defined**.

```perl
package Person;
use Moo;

has name => (
     is => 'rw',
     required => 1,
     isa => sub { die 'cannot be undef' if not defined $_[0] },
);
```

If now, someone passed **undef** to the constructor, Moo will generate the
following exception:

```
isa check for "name" failed: cannot be undef at Person.pm line 9.
```

If you included **use Carp::Always;** for better error messages you would get this output,
in which the 4th line from the top is the one revealing the real source of the error (the call to
new).

```
isa check for "name" failed: cannot be undef at (eval 13) line 38.
    Sub::Quote::__ANON__('cannot be undef at Person.pm line 9.\x{a}') called at Person.pm line 9
    Person::__ANON__(undef) called at (eval 13) line 40
    Person::new('Person', 'name', undef) called at programming.pl line 8
```

## The values of required

The `required` field accepts a [boolean value](/boolean-values-in-perl).
By default it is false, but you can set it to any true value.


