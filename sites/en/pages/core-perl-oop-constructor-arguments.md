---
title: "Core Perl OOP: Constructor arguments"
timestamp: 2017-04-19T23:00:11
tags:
  - new
types:
  - screencast
published: true
author: szabgab
---


In the case of [Moose](/moose) after we have seen that in the regular script, we could
set the value of an attribute using a 'setter', and we could get the value of an attribute using
a 'getter'.


<slidecast file="advanced-perl/core-perl-oop/constructor-arguments" youtube="60PdxXn_36I" />


{% include file="examples/Moose/person01/script/person.pl" %}


We implemented that in the Person.pm module:

{% include file="examples/Moose/person01/lib/Person.pm" %}

The we also saw that we can set the initial value of the attribute in the constructor already:

{% include file="examples/Moose/person01/script/person2.pl" %}

We can pass key-value pairs in the constructor and the same minimalistic code in Moose already
provides us this feature.

## Constructor arguments in core Perl OOP

This is not the same with core Perl OOP. Here we had to implement the getter/setter by ourselves
and we also have to implement the accepting of parameters in the constructor.

In order to have this in core Perl OOP we created a method to be the getter/setter, but in order
to be able to accept key-value pairs by the constructor we have to make some further changes.

Earlier, in the original [constructor](/core-perl-oop-constructor) we only accepted the name of the class and nothing else
and we used an empty hash reference as `$self`:

{% include file="examples/oop/person00/lib/Person.pm" %}

This was changed so the `new` function, the constructor is now also accepting a set of key-value pairs and assigns them
to the `%args` and then uses the reference to that hash as the base of that object.

{% include file="examples/oop/person01/lib/Person.pm" %}

This provides us the feature that users can pass key-value pairs and they will be used as attributes
in the object being created.

As you might have noticed there is no checking here if the keys the user has passed in the constructor are the really the field-names
we are expecting. Nor is there any constraints on the values passed to the constructor.


