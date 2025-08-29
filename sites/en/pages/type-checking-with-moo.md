---
title: "Type checking with Moo"
timestamp: 2015-03-02T13:10:01
tags:
  - Moo
  - looks_like_number
  - Scalar::Util
  - MooX::Types::MooseLike
  - MooX::Types::CLike
  - Perl::Critic
books:
  - moo
published: true
author: szabgab
---


People arriving from other programming languages or from using Moose
might be expecting to find a system for types checking, but Moo
being the **Minimal Object Orientation** system of Perl, does
**not** provide any type-checking.

However you can easily add type checking of your own. Let's see how.


## Type restrictions with regex

{% include file="examples/mootype/Person.pm" %}

In the above code, the `Person` class has two attributes. `name`
has no restrictions, but `age` does have one. It is declared using the 
`isa` keyword of Moo. The value of the `isa` key is a reference
to an anonymous function. This function is called every time when someone tries to assign
a value to this attribute via the constructor or the setter of the attribute.

The value to be assigned to the attribute is passed to the function as its first parameter.
In our example we used the rather unpleasant looking `$_[0]` to access this value.
(We could have `shift`-ed it to an internal variable, but in such a short
subroutine, this seems to be the more readable version.
We can use then any code to check if the value matches the expectations and throw an
exception if it does not. In this case we checked if the value consist of one or more digits:
`/^\d+$/` and we threw a very simple, text-based exception using `die`.

Let's see how does that work when we use the module?

{% include file="examples/mootype/student_1.pl" %}

The output of this code will look like this:

```
Foo
22
isa check for "age" failed: 'young' is not an integer! at Person.pm line 8.
```

Calling the constructor worked. Calling the `name` and the `age`
methods worked and the `say` function printed the values. Then calling
`$student->age('young');` threw an exception. The exception contains some
text Moo provided and the text we included in the `die` call.
The last call to `say` was never reached.

Let's see what happens when the incorrect value is already provided in the constructor:

{% include file="examples/mootype/student_2.pl" %}

The exception is thrown right during the call of the constructor:

```
isa check for "age" failed: 'old' is not an integer! at Person.pm line 8.
```

## Where is the problem?

Unfortunately in both cases, the error location was given in the `Person.pm` file.
Indeed that's the place where the exception was thrown, but that's not very
useful for the developer who just happens to use the Person module. After all,
the real source of the problem is in the script that called the constructor
or the setter with incorrect value and not in the Person.pm module.

Veteran Perl developers might immediately remember that the `croak` function of the `Carp` module
is useful in such situations. It is almost the same as `die` except when it reports the location of the error
it will report the place where the current function was called.

So we include:

```perl
use Carp qw(croak);
```

and replace the `die` call by `croak`. The result:

```
isa check for "age" failed: 'old' is not an integer! at (eval 11) line 37.
```

Not exactly what we expected. Apparently Moo wraps the isa-checking code in
a [string-eval](/string-eval) of its own.

Let's try the `confess` function of `Carp` then. That too
is similar to `die` but it provides the full stack-trace from point
where it was called up to your main script.

We put this in the code:

```perl
use Carp qw(confess);
```

And replaced the call to `croak` by a call to `confess`. The result:


```
isa check for "age" failed: 'old' is not an integer! at Person.pm line 11.
    Person::__ANON__('old') called at (eval 11) line 37
    Person::new('Person', 'name', 'Foo', 'age', 'old') called at t.pl line 6
```

Here we can see that the problem was noticed in line 11 of the Person.pm file, but
it was called in line 6 of the t.pl file (my example script).

This is probably a better way to throw the exception than either of the above 2.

Just for the record let's see the Person.pm file now:

```perl
package Person;
use Moo;

use Carp qw(confess);

has name => (is => 'rw');
has age  => (
    is  => 'rw',
    isa => sub {
       confess "'$_[0]' is not an integer!"
          if $_[0] !~ /^\d+$/;
    },
);

1;
```

## Other ways to check if value is a number

In the previous example we used a regular expression to check if the assigned value
contains one or more digits. There are other cases when you'd like to check if the
value "is a number"? Perl does not have an is_number function, but there is a function
called `looks_like_number` in the `Scalar::Util` module. It basically
checks if the given value can be
[automatically converted to a number](/automatic-value-conversion-or-casting-in-perl)
without any warning. So we can write:

```perl
use Scalar::Util qw(looks_like_number);
```

to load the module and import the function, and rewrite the isa-checking:

```perl
    isa => sub {
       confess "'$_[0]' is not a number!"
          unless looks_like_number $_[0];
    },
```

## Pre-defined types

While Moo itself does not have types defined, there are several extension that provide
type definitions. For example [MooX::Types::CLike](https://metacpan.org/pod/MooX::Types::CLike)
provides types a C programmer might be familiar with and
[MooX::Types::MooseLike](https://metacpan.org/pod/MooX::Types::MooseLike)
imitates the types of [MooseX::Types](https://metacpan.org/pod/MooseX::Types).

It can be used to create your own type definitions, but it already comes with several types listed in
[MooX::Types::MooseLike::Base](https://metacpan.org/pod/MooX::Types::MooseLike::Base).

You can use the types it provides without any extra work.

Just load the types using `use MooX::Types::MooseLike::Base qw(:all);` and then you can
use the types as the values of the `isa` field. For example we used `Int` in the following example:

```perl
package Person;
use Moo;

use MooX::Types::MooseLike::Base qw(:all);

has name => (is => 'rw');
has age  => (
    is  => 'rw',
    isa => Int,
);

1;
```

The resulting error look like this:

```
isa check for "age" failed: old is not an integer! at (eval 13) line 37.
   Person::new('Person', 'name', 'Foo', 'age', 'old') called at t.pl line 6
```

Apparently this module already provides a stack trace but excludes the line
where the exception was thrown.

That's the basics of adding type checking to

## A little warning

Beware though. As the actual objects created by Moo are just blessed references
to hashes, any user will have direct access to the attributes.
Moo cannot enforce the type restrictions if someone directly accesses the internals of the object.
Of course no one will do that, right?
See the bad example:


```perl
use strict;
use warnings;
use 5.010;

use Person;
my $student = Person->new( name => 'Foo', age => '20' );
say $student->age;
$student->{age} = 'young';     # BAD BAD BAD!
say $student->age;
```

The output then:

```
20
young
```

This is basically a limitation of Perl. There is a solution to this using, so called
inside-out objects, but they have a complexity price and they usually not worth the hassle.

## Perl::Critic

A better approach is to use the regular objects and use [Perl::Critic](https://metacpan.org/pod/Perl::Critic) to
locate code that breaks the encapsulation. Install [Perl::Critic::Nits](https://metacpan.org/pod/Perl::Critic::Nits)
and check your code for violation of
[Perl::Critic::Policy::ValuesAndExpressions::ProhibitAccessOfPrivateData](https://metacpan.org/pod/Perl::Critic::Policy::ValuesAndExpressions::ProhibitAccessOfPrivateData)

If you have them in your code you will get reports like this:

```
Private Member Data shouldn't be accessed directly at line 8, column 1.
Accessing an objects data directly breaks encapsulation and should be avoided.  Example: $object->{ some_key }.  (Severity: 5)
```

You can then use the strategy to [improve your Perl code](/perl-critic-one-policy) one policy at a time.


## Comments

Could you please remove any references to `Moose` and `MooX::Types::MooseLike::Base`, just use `Types::Standard`, part of the `Type::Tiny` suite, which is more universal etc.

<hr>

Hi Gabor,
I greatly appreciate these articles. Thank you for making these available.
For the last section of using perlcritic on this page, is it possible to add how we use perlcritic?
I did install Perl::Critic and Perl::Critic::Nits and was trying to use "perl -c code.pl" and wondering why I don't see the warning :-)
Then I visited "improve your Perl code" link and realized what I was doing wrong.


