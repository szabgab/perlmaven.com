---
title: "Creating subtypes for Moose"
timestamp: 2016-12-19T08:00:11
tags:
  - Moose
  - Moose::Util::TypeConstraints;
  - subtype
types:
  - screencast
published: true
books:
  - moose
author: szabgab
---


As we saw in the previous part we can [use the DateTime class as type constraint](/moose-classes-as-constraints)
in [Moose](/moose).
So we can declare an attribute to be of type DateTime and Moose will enforce this in the setter.

What if you'd like to create your own type


<slidecast file="advanced-perl/moose/creating-subtypes" youtube="R6gSMmowmYg" />


Of course you can create your own class and use that as a type, just as was the cases with DateTime, but in many
cases that's just too much work.
Moose allows you to create your own types in a very easy way.

Let's say you'd like to create a type 'sex' attribute that should be either male or female.
The setter is supposed to accept the letter m (for male) and a letter f (for female).
This is the way we could use it: (**script/person.pl**)

```perl
use strict;
use warnings;
use v5.10;

use Person;
use DateTime;

my $student = Person->new( name => 'Foo' );

$student->sex('m');
say $student->sex;

$student->sex('male');
```

We call the constructor giving the person a name and then using the `sex` method with the **'m'** value.
Then if we call the getter of the same method, it will return 'm' and that will be printed by `say`.

If we call the setter with some other string, for example 'male' as in the example, because we thought that should
work as well, then the setter is supposed to throw an exception.

Indeed we got an exception that looked like this:

```
Attribute (sex) does not pass the type constraint because:
  (male) is not a valid sex.
  Valid values are 'f' and 'm'. at script\person.pl line 13
```


The implementation in `lib/Person.pm` looks like this:
    
```perl
package Person;
use Moose;
use Moose::Util::TypeConstraints;

subtype 'Person::Type::Sex'
  => as 'Str'
  => where { $_ eq 'f' or $_ eq 'm' }
  => message { "($_) is not a valid sex. Valid values are 'f' and 'm'." };

has 'name'     => (is => 'rw');
has 'birthday' => (isa => 'DateTime', is => 'rw');
has 'sex'      => (isa => 'Person::Type::Sex', is => 'rw');

1;
```

We loaded the [Moose::Util::TypeConstraints](https://metacpan.org/pod/Moose::Util::TypeConstraints) module that comes with Moose,
and that provides the necessary functions to create a `subtype`.

A subtype is also a class just like the DateTime class was, but without a the ceremony of creating a separate file and writing lots of code Perl requires.

The `subtype` function works in the following way: The first parameter it gets is the name of the new constrains class.
It can be any name that would be a valid Perl package name, but I'd suggest to have this name within the same namespace as your application is.
Because in this example I am working on a class called `Person`, the type could be inside the `Person::Type::` namespace.

This makes it easier to organize the types, and they won't clash with classes or type constraints in other parts of the project.

The next part, `as 'Str'`,  tells us that the new subtype will be a subtype of the already existing `Str` type. This is right as our new
type will be a string that can only accept the strings 'm' or 'f'.

The next part `where { $_ eq 'f' or $_ eq 'm' }` is the constrain. It is a code snippet wrapped in curly braces. The actual value
that was passed to the setter will be in `$_` and then this code-snippet will be executed. If the block returns `True`,
it will be pass the type-constraint, if the block returns `False`, the value will be rejected.

You can put any code snippet in there.

In the last part of the declaration, we provide a "message". This is the error message that will be included in the exception if the
value checked did not pass the test in the `where` part. Here too, `$_` contains the current value so we can include it in the message:

`message { "($_) is not a valid sex. Valid values are 'f' and 'm'." };`


Once we created this `subtype` we can start using it in the declaration of attributes. So the attribute 'sex' will have a constraint
`isa => 'Person::Type::Sex'`


So as we saw, we can either use an existing class such as the DateTime class or we can create our own subtypes based on existing types and
use those in our Moose-based classes.


## Comments

I know, some people will argue that the attribute and the constraint should have bee called "gender" and not "sex". No problem, we'll be able to
fix this later.

Other people will add that even if we call it "gender" we cannot use only two values. We also need to allow people to say "other".
We'll figure out something in a later episode.


