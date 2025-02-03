---
title: "Methods, Functions and Subroutines in Perl and what is $self ?"
timestamp: 2015-03-31T07:13:10
tags:
  - $self
published: true
books:
  - moo
author: szabgab
---


We know that in Perl the names [Function and Subroutine](/subroutines-and-functions-in-perl) are interchangeable.
But what is really the difference between a function and a method?


On the surface there are no differences. They are both declared using the `sub` keyword.
The differences are mainly in the way they are used.

A method is always called using the arrow notation.
Either on the object: `$p->do_something($value)`
or on a class: `Class::Name->new`.

A function is always called directly: Either with its fully qualified name: `Module::Name::func_something($param)`  or,
if the functions is part of the current name-space, then with the short name: `func_something($param)`.

If a method cannot be found in the class of the object on which it was called, Perl will go to the parent class and look
for a method with the same name there. It will do it recursively using its built-in method resolution algorithm.
It will only give up (or call AUTOLOAD) if the method could not be found at all.
On the other hand, Perl will only look for a function in a single place, (and then AUTOLOAD, if it is available).

A method will always get the current object (or class name) as the first parameter of its call.
A function will never get the object. (Well, unless you manually pass it as a parameter.)
Therefore a method normally acts on an instance (object), and sometimes it acts on the whole class (and then we call it class-method).
A function on the other hand, <b>never</b> acts on an object. Though it might act on the class.

## Examples - an object-method

A regular or object-method:

Methods always get the current object as the first parameter, therefore we need a way to assign that to a variable that is easily recognizable.
That's what `$self` is. When we declare a method (a subroutine that is expected to be used as `$p->do_something($value)`,
we assign the first parameter received in `@_` to `$self`. That will contain the current object.
Using the name `$self` is a mere tradition, but one that makes it easier to the reader to recognize which variable holds the current object.
(There are actually some people who use `$me` instead, but I think that is just confusing.)

```perl
sub a_method {
  my ($self, $param) = @_;
  ...
}
```

It is called by the user as:

```perl
$p->a_method($value);
```

Behind the scenes, perl will run

```perl
a_method($p, $value);
```


## Examples - an class-method

A class-method looks exactly like an object-method. The only difference is in the usage and that perl
passes the class-name upon which method was called as the first parameter. (After all no specific object is related to this call.)

Because the first parameter received is not an object, it might be better not to use `$self` as the variable name holding it.
Using `$class` as the variable name will make this clearer:

```perl
sub a_class_method {
  my ($class, $param) = @_;
  ...
}
```

It is usually used as:

```perl
Some::Class::Name->a_class_method($value);
```

For which perl will actually call

```perl
a_class_method('Some::Class::Name', $value);
```

There are some cases, when the code needs to be even more flexible when there is something like this:

```perl
my $module = 'Some::Class::Name';  # or some other module name
...
$module->a_class_method($value);
```

This will make the code a lot more flexible, but of course it should be only used when that kind of flexibility is needed.

## Examples - a plain function

A function has not special parameter passing:

```perl
sub a_function {
  my ($param) = @_;
  ...
}
```

And it is used as

```perl
a_function($value);
```

and perl will execute the same:

```perl
a_function($value);
```


Methods are only used in Object Oriented Perl code.

Functions are rarely used in Object Oriented Programming.

## Where is this relevant?

To the untrained eyes it might seem that Perl has a number of different Object Orientation system.
such as [Moose](/moose), [Moo](/moo), blessed references and a few more.
In fact they are all the same underneath and thus the above applies to all of them.


## Comments

How to avoid the user using an object-method as a plain function?
For example, we write a object-method receiving one parameter (apart from it self, $self), but when it used as plain function it will be confused, since in the sub block we are deal with the second parameter. Or, how to write a subrutine that can be used as both object-method and plain function. Or, how to distinguish which way the caller is using our subrutine.

---
IMHO the best thing you can do is check if the first parameter is the appropriate blessed reference or not. See "ref" in perl and "blessed" in Scalar::Util.
