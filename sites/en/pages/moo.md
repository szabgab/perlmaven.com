---
title: "Moo - Minimalist Object Orientation for Perl"
timestamp: 2013-07-01T18:13:10
tags:
  - Moo
books:
  - moo
published: true
author: szabgab
show_related: false
---


A series of articles about [Moo](http://metacpan.org/pod/Moo), the Minimalist Object Orientation system of Perl.

Moo is the little brother of [Moose, the all magnificent object oriented framework of Perl](/moose).
Moo is smaller and faster than Moose and it pure-Perl (no XS dependencies). It can provide a solution for people
who would like to get away from the "manual blessing", but don't want to "pay" for all the features of Moose.


* [OOP with Moo](/oop-with-moo) a screencast and text explaining the basics of Moo, creating a class with a single attribute that can be either read-only (immutable) or read-write (mutable) attribute. Creating an instance (object).
* [Type checking with Moo](/type-checking-with-moo). While Moo does not have a type-system it allows you to set-up type checking in the setters of the attributes.
* [MooX::late](/moose-like-type-system-for-moo) provides another type-system, similar to what Moose has.
* Attributes:

* [Required attributes](/moo-and-required-attributes)
* [Moo attributes with default values](/moo-attributes-with-default-values)
* [Moo with array reference as attributes - with or without default values](/moo-with-array-refernce-as-attribute)
* [Moo with hash reference as attributes - with or without default values](/moo-with-hash-refernce-as-attribute)
* [Moo attribute predicate and clearer](/moo-attribute-predicate-and-clearer)


* [Public and Private Methods](/moo-with-public-and-private-methods)
* [Methods, Functions and Subroutines in Perl and what is $self ?](/methods-functions-and-subroutines-in-perl)
* [Inheritance and Method Modifiers](/inheritance-and-method-modifiers-in-moo)
* [Replacing an attribute by a method](/replacing-an-attribute-with-a-method) - modifying the constructor (BUILDARGS)
* [Writing Command line scripts and accepting command line parameters using Moo](/command-line-scripts-with-moo)
* [Singleton](/singleton-moo)

## Planned articles
* The destructor of a Moo-based class
* Roles
* Extending Moo
