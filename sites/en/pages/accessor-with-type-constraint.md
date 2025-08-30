---
title: "Accessor with type constraint"
timestamp: 2018-07-14T16:00:11
tags:
  - die
  - croak
types:
  - screencast
published: true
author: szabgab
---


In this part we are adding a new attribute with an accessor that checks if the value given is
in the correct type.


{% youtube id="V1m9Y-PU6F4" file="advanced-perl/core-perl-oop/accessor-with-type-constraint" %}

The next thing we did in the example with [Moose](/moose) earlier, we created another attribute which has some type.
We used it this way.

{% include file="examples/Moose/person02/script/person.pl" %}

We had an attribute called "year" that would accept a number (an integer representing a year) such as `1988`,
but would not accept a string such as `'23 years ago'`.

The implementation was very simple. We just declared that we have an attribute called "year" and we used the "isa"
keyword to tell Moose that this should only accept `Integers`.

{% include file="examples/Moose/person02/lib/Person.pm" %}

We would get a detailed exception if we passed a value that was not an `Int`.

{% include file="examples/Moose/person02/err.txt" %}


## Attribute constraint in Core Perl OOP

So how can we implement the same thing using Object Oriented Programming using Core Perl only?

{% include file="examples/oop/person02/lib/Person.pm" %}

The [constructor](/core-perl-oop-constructor-arguments) (the `new` function) has not changed.

We have included an additional subroutine called `year` to handle the `year` attribute.
This is almost exactly the same as the earlier getter/setter called `name`, except that this one has a
conditional call to `die` and that the name of the subroutine that corresponds to the name of the attribute
is now 'year' instead of 'name'.


If we did not want to add the extra "die" call, we could have just copy-pasted the previous accessor and replace
the word 'name' by the word 'year' in 3 places.


Because we wanted to have some validation in the second accessor, we also had to add a call to 'die';
I've added a copy of the error message we saw in the Moose case which is quite long. If you really write core Perl OOP,
you'd probably write much shorter error messages.

Moreover, as far I know, most of the people who write OOP code using core Perl only, would leave out this simple error checking,
but I wanted the error message to look exactly the same as the one Moose provides.

We call `die` only if the regex at the end of the statement does not match.
I am not sure if the regex `/^\d+$/` checks exactly the same as Moose checks with the `Int` declaration,
but I wanted to have some generic example.  (Actually, most likely it is closer to this `/^[+-]?\d+$/`.)


## Use Carp::croak

After recording the video I thought that instead of calling `die` we would probably be better off calling
`Carp::croak` as that would indicate the failure being at the point where the setter was called and not
inside the setter.



