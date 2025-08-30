---
title: "Core Perl OOP: attributes, getter - setter"
timestamp: 2016-08-18T12:00:11
tags:
  - getter
  - setter
  - accessor
  - attribute
types:
  - screencast
published: true
author: szabgab
---



{% youtube id="JPRmQ5QNYaw" file="advanced-perl/core-perl-oop/setter-getter" %}


Now that we have the [constructor](/core-perl-oop-constructor), let's see
how can we create attributes in Core Perl OOP.

Before that, let's take a look at the example in Moose.

{% include file="examples/Moose/person01/script/person.pl" %}

We are calling the constructor here `Person->new` that returns an object we assign to `$teacher`
then we are calling the accessor `$teacher->name('Foo')` using it as a setter by providing it a value
and then using the same accessor as a getter `$teacher->name` (without passing a value) to fetch the current
value of the attribute. Using the same method called `name`

The implementation in Moose was rather simple:

{% include file="examples/Moose/person01/lib/Person.pm" %}


## Core Perl OOP - attributes

In core Perl we need the following:

{% include file="examples/oop/person01/lib/Person.pm" %}

We have the [constructor](/core-perl-oop-constructor) slightly changed.
We'll talk about that again a little bit later.

We also have the implementation of the `accessor` which is also a `getter` and a `setter`.

How does this work?

When we call the `$techer->name('Foo');` perl will notice that `$teacher` is a `blessed reference`
to a hash and that it was bless-ed into the `Person` name-space. If it wasn't a blessed reference,
perl wouldn't know what to do with the arrow and the "name" after that and it would throw an exception:
[Can't call method ... on unblessed reference](/cant-call-method-on-unblessed-reference)

Because it is `bless`-ed and because it is bless-ed into the Person name-space, perl will look for
the "name" function in the `Person` name-space.

Once that function is found, perl will call that function with the parameters we passed to it, but it will also
take the variable we had on the left-hand side of the arrow (`$teacher` in our case) and pass it as the
first argument.

If we look at the implementation of `name` in the Person.pm file, we can see that the "name" function
is expecting two parameters. The first is going to be assigned to the `$self` variable, the second is
going to be assigned to the `$value` variable. The names of the variable are arbitrary, but it is
quite accepted in the Perl community to use the variable `$self` as the first parameter, so that will hold
the "current object" inside the implementation of the class. (This is similar to 'this' or 'self' in some other
programming languages.)

In our example this "name" function is called once as a "setter" when we pass a value to it, and once as a "getter"
when we don't pass any value. Becuase perl passes the object as the first parameter this means that when it is called
as a "setter" we are actually going to get 2 parameters and when it is called as a "getter" we are going to
get one parameter.

The first statement in the "name" subroutine assigns the parameters to some local variables.
In the second statement we check if this time the function should act as a getter or as a setter?
We check the number of parameters. If we got two parameters then this is a setter. In this case
we take the content of `$self`, which as you might recall from the article about the
[constructor](/core-perl-oop-constructor) is just a reference to a hash, and assignt to the 'name'
key the `$value` we have received. 

This shows that the attributes of an object in Perl are just key/value pairs in a hash reference.

If we use the 'name' function as a 'getter', then we don't pass any value to it, which means `$value`
will be `undef`, but more importantly `@_` will only have one element. This we will skip the assignment
and the only thing we do is to return the value of the 'name' key from our hash reference.


## Checking if $value is undef

In some cases instead of checking if the user has passed exactly 2 parameters, people check if the `$value`
is defined or not and based on this they decided if the function behaves as a setter or as a getter.
It is probably inferior to hecking the number of parameters as that means we won't be able to set the
attibute to become `undef`.

## More that 1 parameter?

In this example we have not dealt properly with the case when a users passes more than 1 parameter. If we call
`$teacher->name('Foo', 'Bar')` this will behave quite incorrectly. Perl will automatically pass the
content of `$teacher` which means our code will act as a getter.

Actually we have not decied what should be the correct behavior in this case so I cannot really know if this is
the "correct" behaviour or not. It will certainly be surprising to someone calling this method and not setting
the attibute. A better behaviour might be to throw an exception either using `die` or using
[Carp::croak](https://metacpan.org/pod/Carp).


## What should the setter return?

The 'getter' should return the value of the attribute,  but what should the setter return?
In our case the 'setter' returns the newly assigned value, but there are other options.



