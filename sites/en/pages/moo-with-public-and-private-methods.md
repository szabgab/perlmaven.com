---
title: "Public and Private Methods in Moo-based Object Oriented Perl"
timestamp: 2015-03-24T09:40:10
tags:
  - Moo
  - method
  - $self
published: true
books:
  - moo
author: szabgab
---


A class with only attributes can be already useful, but having methods other than getters and setters
will make the life of the objects more interesting.


## Class with methods

When we [created a class](/oop-with-moo), Moo automatically added methods to get and set the values of a single attribute.
In that example we already saw that a method is called using the arrow notation: `$student->name;`.

Let's see now how we can create our own methods. In the first example we have class called `Point` representing
a single 2-dimensional point. It has two attributes: x and y. It also has an extra method called `coordinates`
that will return a string that looks like this: `[x, y]`, where x and y will be replaced by the respective numerical values.

We will use the object and its method like in the following script:

```perl
use strict;
use warnings;
use 5.010;

use Point;
my $p = Point->new(x => 3, y => 4);
say $p->x;
say $p->y;

say $p->coordinates;
```

Running this script will provide the following output:

```
3
4
[3, 4]
```

Now, let's see the implementation itself in Point.pm:

```perl
package Point;
use Moo;

has x => (is => 'rw');
has y => (is => 'rw');

sub coordinates {
   my ($self) = @_;

   return sprintf "[%s, %s]", $self->x, $self->y;
}

1;
```

The attributes are not new. We saw them in [the first article](/oop-with-moo).
However, in this example we also have a method called `coordinates`. If you look at it, you
won't see any obvious difference between a `method` and a plain `subroutine` in Perl.
Indeed, there is almost no difference. The main reason we call them `methods` is to have
a vocabulary similar to what people arriving from programming languages use.

A `method` in a Moo-based class is just a `subroutine` with a few minor differences.

We call the method with the arrow notation `$p->coordinates`.

Even though we did not pass any parameter to this method call, Perl will automatically take the object,
(`$p` in this case), and pass it as the first argument of the method.
That's what is going to be the first element of the `@_` array and that
will arrive in the `$self` variable inside the function.

While `$self` is not a reserved variable or a special word in Perl,
it is quite customary to use this name to hold the current object inside a class.

(In other languages this variable might be called `this`.
In some languages the variable springs to existence without any special code. In Perl the object always arrives
as the first parameter of the method calls.)

## Another simple method

This one would return the distance of the point from the [0,0] coordinates.
I think there is nothing special in this example, but I wanted to show another simple case.

```perl
sub distance_from_o {
   my ($self) = @_;

   my $sqr = $self->x ** 2 + $self->y ** 2;
   return $sqr ** 0.5
}
```

## Change more than one attributes at once

In another example we would like to add a method to move the point from one coordinate
to another. This involves updating both x and y at the same time.

Running this script:

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Point;
my $p = Point->new(x => 2, y => 3);
say $p->x;
say $p->y;

$p->move_by(3, 4);
say $p->x;
say $p->y;
```

We get the following output:

```
2
3
5
7
```

This is the method we added to the Point.pm file:

```perl
sub move_by {
    my ($self, $dx, $dy) = @_;

    my $x_temp = $self->x;
    $x_temp += $dx;
    $self->x( $x_temp );

    $self->y( $self->y + $dy );

    return;
}
```

In this method we get two parameters `$dx` and `$dy`, besides the object itself which is copied to `$self`.
These hold the distance we move x and y respectively. For x I wrote the code step-by-step. First we use `$self`, the current
object to get the current value of the x attribute and assign it to a temporary variable called `$x_temp`.
Then we increment `$x_temp` by the "move", and finally we put the new value from `$x_temp` in the x attribute.
`$self->x( $x_temp );`.

In the case of the y attribute, I already left out the use of the temporary variable which was only there to (hopefully) make it
clearer what we have been doing.


## Public and Private methods

Just as there is no privacy for attributes, in the Object Oriented system of Perl there are no private methods either.

Nevertheless, as people want to have the feeling of privacy the tradition says that any method that starts with and underscore `_`
should be considered private. There is nothing in Perl that would enforce this privacy, but it is a good proximation.
After all you usually have access to the source code of any class anyway, so you could copy the class, make some changes and use your
own version.

The final call to `return` is not really required here, but I like to add it to make sure the caller won't receive any
accidental value till I might decide what should be returned.

This was a slightly more complex case, where we wanted to change two attributes at once, hence we created a separate method.

## What is $self ?

For further explanations see what is the difference between
[methods, functions, subroutines and what is $self anyway?](/methods-functions-and-subroutines-in-perl)


