---
title: "Moo attribute predicate and clearer"
timestamp: 2015-03-20T11:50:00
tags:
  - Moo
  - predicate
  - clearer
published: true
books:
  - moo
author: szabgab
---


How to check if an attribute has a value without directly accessing the internals of the class?
Fetching the value and checking if it is `undef` is not always the right thing. There
are cases when the value can be legitimately be set to `undef`.
You might need a different way to check if the value has ever been set.


Setting the `predicate` key of an attribute to 1, Moo will
create a corresponding `has_` method that will return
[true of false](/boolean-values-in-perl), depending weather the attribute has
any value (including `undef`) or not.

For example if we have an attribute called 'name', then `predicate => 1`
will tell Moo to generated a method called `has_name`. If we had an attribute
with a leading underscore (e.g. `_age`, then the `predicate => 1`
will prefix it with '_has' and generate `_has_age`

## Example

Given the following Person.pm module:

```perl
package Person;
use Moo;
use 5.010;

has name => (is => 'rw', predicate => 1);

1;
```

Let's try the following programming.pl file:

```perl
use strict;
use warnings;
use 5.010;

use Person;

my $anonymous = Person->new;
say $anonymous->has_name ? 'has name' : 'no name';

my $anonym = Person->new( name => undef );
say $anonym->has_name ? 'has name' : 'no name';

my $student = Person->new( name => 'Joe' );
say $student->has_name ? 'has name' : 'no name';
```

Running `perl programming.pl` will give the following output:

```
no name
has name
has name
```

In programming.pl we created 3 Person objects and then used 
`say` and the ternary operator to print if it 'has name'
or 'no name'. As you can see above, only in the first case
did `has_name` return false.

That is, setting the value to `undef` still means it has a value.

## predicate in other word

There might be cases when the `has_` prefix is not a good fit.
Either grammatically, or because you use the `has_` prefix of an attribute
to some other task. For such cases, Moo let's you pick your own word by using that
word as the value in the attribute declaration:

In Person.pm the attribute declaration changes to this:

```perl
has name => (is => 'rw', predicate => 'has_a_real_name');
```

In programming.pl we also have to update the calls to use the new `has_a_real_name` method:

```perl
my $student = Person->new( name => 'Joe' );
say $student->has_a_real_name ? 'has name' : 'no name';
```

Once you set an attribute to any value, even `undef`, you cannot make unset.
Well, except if you use a special tool for it called `clearer`.

## clearer

The `clearer` functionality work really closely together with the predicate.
After calling the clearer method of an attribute, it will seem as if that attribute
was never set to any value.

Setting `clearer => 1;` of an attribute, Moo will create a method with a
`clear_` prefix. For example if the attribute is called `name`, then
the clearer method will be called `clear_name`.

In Person.pm we have this code:

```perl
has name => (is => 'rw', predicate => 1, clearer => 1);
```

In programming.pl we have this:

```perl
my $student = Person->new( name => 'Joe' );
say $student->has_name ? 'has name' : 'no name';

$student->clear_name;
say $student->has_name ? 'has name' : 'no name';
```

Running `perl programming.pl` we get:

```
has name
no name
```

That is, after calling the `clear_name` method, the attribute is gone.

## Interaction with default

We must ask the question how do these interact with the other options available
for attributes. Most notably, what happens if we 'clear' an attribute that has
a default value?

The Person.pm has this content:

```perl
package Person;
use Moo;
use 5.010;

has name => (
    is        => 'rw',
    predicate => 1,
    clearer   => 1,
    default   => 'Foo',
);

1;
```

The programming.pl has this:

```perl
use strict;
use warnings;
use 5.010;

use Person;

my $student = Person->new();
say $student->has_name ? 'has name' : 'no name';
say $student->name;

$student->clear_name;
say $student->has_name ? 'has name' : 'no name';
say defined $student->name ? 'defined name' : 'not defined name';
```

The output is

```
has name
Foo
no name
not defined name
```

The answer then is that you can totally clear an attribute, the default flag
only applies during the construction of the object.

## Interaction with required

The same is true with the `required` flag. That too is only checked during construction.
Using a clearer you can still remove any trace of it ever existed in an object.

Person.pm changes to this:

```perl
has name => (
    is        => 'rw',
    predicate => 1,
    clearer   => 1,
    default   => 'Foo',
    required  => 1,
);
```

programming.pl changes to this as we now have to pass a value to 'name' in the constructor:

```perl
my $student = Person->new( name => 'Joe' );
say $student->has_name ? 'has name' : 'no name';
say $student->name;

$student->clear_name;
say $student->has_name ? 'has name' : 'no name';
say defined $student->name ? 'defined name' : 'not defined name';
```

and the out is this:

```
has name
Joe
no name
not defined name
``` 


