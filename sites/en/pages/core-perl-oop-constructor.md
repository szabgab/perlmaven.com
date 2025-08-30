---
title: "Core Perl OOP: Constructor"
timestamp: 2016-08-14T23:00:11
tags:
  - package
  - bless
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


In this chapter we are going to see how write object oriented Perl code with core Perl.
Without any additional modules. Manually blessing a hash reference.


{% youtube id="Hhmks2-JhBs" file="advanced-perl/core-perl-oop/constructor" %}

In the previous chapter we have seen how to use [Moose](/moose) to
create object oriented code in Perl. In this chapter we are going to implement similar functionality,
but without the use of any object oriented system from CPAN.

While in most new applications I'd probably recommend you either use [Moose](/moose) or [Moo](/moo),
there are plenty of places that make it hard to install CPAN modules and thus you cannot use those systems.
In addition there are plenty of systems with old Perl applications that have to be maintained.
So you'd better understand how this works.

Before looking at the implementation of the class, let's see a script that will use it.

## Moose Constructor

We would like this script to work, even if the `Person.pm` file
uses core-perl to create the class.

{% include file="examples/Moose/person00/script/person.pl" %}

In the script we load the module and call the `new` constructor to create
an instance.


This was the implementation using Moose:

{% include file="examples/Moose/person00/lib/Person.pm" %}


## Core Perl constructor

The implementation using core Perl looks like this:

{% include file="examples/oop/person00/lib/Person.pm" %}

The [package](/packages-modules-and-namespace-in-perl) declaration is the same
and then we [use strict and warnings](/always-use-strict-and-use-warnings),
something we left out in the version using [Moose](/moose) as Moose was implicitly
applying them.

We also add the trailing `1;` as we have to do with every module.

We then need to implement our own constructor called `new`.

`new` is not a fixed keyword in Perl, we could call our constructor any name we wanted,
but the accepted name of the constructor it `new` and thus we'd better stick to it.

The way Perl works is that when we call the constructor (`Person->new`) that is when we have some word,
and arrow and then the name of a function, perl will pass the name (in our case `"Person"`) as
a string in the first position of the parameter list moving all the other parameters one to the right.

Let's see a few examples: On the left hand side is what we write, on the right hand side what happens:

<pre>
Person->new;                         new("Person");
My::Class->new;                      new("My::Class");

My::Class->new('Foo', 'Bar', 42);    new('My::Class', 'Foo', 'Bar', 42);
</pre>

So in our case the first parameter in `@_` will be `'Person'` and we assign it to the variable `$class`.
You might think we don't need to copy the first value in the `@_` as this is exactly the same as in the word in the `package`
statement at the top of our file, but that won't be true once we start to use class-inheritance, one of the key reasons to use Object Oriented
code in the first places. So don't do that. Always use the first parameter in the constructor as the name of the instance we are
about to create.

Then we create an anonymous hash `{}` and assign it to `$self`.

An object in Perl, both when using core Perl for OOP and also when using [Moose](/moose) is basically a reference to
a hash. But not just any reference, it is a `blessed` reference.

(Side note: we could actually create objects based on other data-structures as well, but that usually does not give us any advantage
and in most cases people use hash references as the basis of their objects.)

Once we created the reference to a hash and assigned it to a variable called `$self` we call the `bless` function
with two parameters. The first the the reference to the hash that will become the instance, the second is the class.
The `bless` function basically connects the hash to the class so later when we call methods on this object
perl will know in which name-space to look for the appropriate function.

In some cases some people use `bless` with only a single argument, which connects the hash reference to the current package
name, but this again is incorrect when inheritance is involved. Don't do that. Always use the two-parameter version of `bless`.

Then we call `return` and return the newly created object (instance) to the caller.

This is what we had to implement because we did not use Moose.

If we now look at the test script from the Moose example which is the same in this case,
then we can run it as `prove -l` (while in the examples/oop/person00 directory) and
everything will pass.

{% include file="examples/oop/person00/t/01-name.t" %}

BTW we used the variable name `$self` to represent the object being created.
This is not a requirement but it was not by chance either. It is the usually accepted way in perl code to
hold the "current object" inside the code of the class in a variable called `$self`.
In case you are familiar with other programming languages they usually call it either "self" or "this".



## Question

How about the following?

```
my $class = ref $class || $class;
```

That would allow people to call the constructor on instances which in turn will confuse the readers.

