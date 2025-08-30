---
title: "Class as type constraint"
timestamp: 2018-07-22T06:00:11
tags:
  - Scalar::Util
  - blessed
  - isa
  - UNIVERSAL
types:
  - screencast
published: true
author: szabgab
---


In this example we are going to use a regular Perl class as a type constraint.
In the Moose version of the series we used a DateTime object as a type constraint.
[Classes as constraints in Moose](/moose-classes-as-constraints)

Implementing it in core Perl is quite similar to the previous cases. For example
when we had [accessor with type constraint](/accessor-with-type-constraint).


{% youtube id="LeILpUZHx5c" file="advanced-perl/core-perl-oop/class-as-type-constraint" %}

{% include file="examples/oop/person03/lib/Person.pm" %}

In the `birthday` setter/getter we add a `die ... if not ...` construct.

First we check if the given parameter is a `blessed` reference, that is if it is
an instance of anything.
Then we check if it **is a** instance of DateTime using the
appropriately named `isa` method from the [UNIVERSAL](https://metacpan.org/pod/UNIVERSAL)
package.
We need to have this 2-step checking as the `isa` method calling would throw an exception if the
variable `$value` did not contain an object.

The `blessed` function comes from the [Scalar::Util](https://metacpan.org/pod/Scalar::Util) module.

## Script
Sample script to use the module:

{% include file="examples/oop/person03/script/person.pl" %}


## Test

Test to verify the module and the birthday setter:

{% include file="examples/oop/person03/t/01-name.t" %}

## Comments

The constructor offers a backdoor past the constraint:
Person->new(birthday => 42);

This brings up a question I wish I had a mentor to ask about. I often see classes defined as above where an uninitialized object is allowed and code will use setters to gradually build up the object. It's a style I think suboptimal but I am the junior developer here so I try to keep quiet about it usually.

What if one had a coding style that demanded that a class's constructor fully populate an object's attributes and used constraints where that's helpful. It would have the nice property that you never have an object created that's either empty or initialized with bad data. You would detect the bad parameter variable in your ctor and refuse to return your object when it's not valid. Are there drawbacks to that policy?

Even when I did C++, where I worked there would be do nothing constructors and objects that transition from uninitialized through semi-initialized to fully initialized. This gives up the nice property of a ctor that it can establish class invariants from the point it returns onwards to destruction. But perhaps there are practical reasons for wanting empty objects of a given type.

---

You are right about the backdoor. This code should be improved.
In Perl you can't stop someone from creating a broken instance, (as they can themselves bless any reference into any class), but it sound reasonable to require that use passes all the attributes that are really needed for the object to have any meaning.


