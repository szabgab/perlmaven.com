---
title: "What should setters return? (Examples with core Perl OOP)"
timestamp: 2016-08-22T21:30:01
tags:
  - setter
published: true
books:
  - advanced
author: szabgab
archive: true
---


In OOP (Object Oriented Programming), `getter` is the generic name for any `method` that will return
the value of one of the `attributes` of the current instance.

`setter` is the generic name of any `method` that will set the value of one of the `attributes`.

It is clear that a `getter` needs to `return` the value of the attribute, but what should a `setter` return?

There are a number of options.


## Setter returns nothing (undef)

One of the possibilities is that the setter will return "nothing". As there is no real "nothing" in Perl, this means the
function needs to return `undef`.

There are two ways to do this either by calling `return undef;` or by calling `return;` without providing anything.
In the "Perl Best Practices" book Damian Conway recommended the latter and thus [Perl::Critic](/search/perlcritic)
has a policy to
[prohibit explicit return undef](https://metacpan.org/pod/Perl::Critic::Policy::Subroutines::ProhibitExplicitReturnUndef), but
in fact both have its advantages and disadvantages.

I won't go in the details here, let's just see the two examples:

### Setter explicitly returns undef</h2>

{% include file="examples/oop/setter/return_undef.pm" %}

### Setter returns nothing (undef or empty list)</h2>

{% include file="examples/oop/setter/return_nothing.pm" %}

When to use this: I think this should be the default way to implement `setters`
with an explicit call to `return` with or without passing `undef`.
This will create the smallest problem if and when you decide to return some other value.

If you don't call `return` at all then the function will return the result of the last statement
which will change as you change the implementation of the code. The problem with leaving out the explicit
call to `return` is that when users of this module
notice that the setter returns a certain value, they will start to rely on it even if the documentation says
the return value is meaningless. Then when you decide to go with one of the explicit return values,
or if you change the implementation that also changes the last statement in the function, the code using
this module will break and they will blame you.

It is better to return nothing (or undef).


## Return the currently assigned value

{% include file="examples/oop/setter/return_current.pm" %}

The idea here is consistency. Both the 'getter' and the 'setter' return the current value of the 'attribute'.

This will allow the "stacking" of the setter call on top of one ore more assignments:
Just as we can stack simple assignments:

```perl
my $name = my $fname = 'Foo';
```

We can also use the call to the 'setter' (which is basically just an assignment) at the end of the statement.

```perl
my $name = my $fname = $obj->name('Foo');
```


## Return the previous value

{% include file="examples/oop/setter/return_previous.pm" %}

Instead of writing code like this:

```perl
my $old = $obj->name;
$obj->name('Foo');
...
$obj->name($old);
```

The users of our class can save one line:

```perl
my $old = $obj->name('Foo');
...
$obj->name($old);
```

There are some examples for similar behavior in core perl.

The `delete` function return the value of the hash key being deleted.
The one-parameter version of the `select` function returns the previously selected filehandle.

## Return the instance object for chained method calls

In this case the setter will return the instance itself.

{% include file="examples/oop/setter/return_instance.pm" %}

This sounds useless, after all we already had the object somehow, probably in a variable, but this
will let the users chaining method calls.

For example some of the methods of [Path::Iterator::Rule](https://metacpan.org/pod/Path::Iterator::Rule)
work like this as showing in the last example of [finding files in a directory tree](/finding-files-in-a-directory-using-perl).

It is also probably confusing as the reader and writer of the code where this is used can only differentiate between getter and setter by the presence or lack of presence of a parameter.
This compounded by the fact the using it as a getter or as a setter will return different things might be confusing and thus might be the source of errors.

In the implementation inside the if-condition we return `$self`, the instance, while outside the if-condition we return `$self->{field}`, the current value of the field.

