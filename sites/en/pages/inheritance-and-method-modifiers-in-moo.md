---
title: "Inheritance and Method Modifiers in Moo"
timestamp: 2015-04-03T11:13:10
tags:
  - Moo
  - method
  - $self
  - before
  - after
  - around
books:
  - moo
published: true
author: szabgab
---


A key concept in object oriented programming is inheritance - how a class can extend another class
by adding a few new attributes and methods. Maybe even more importantly, how can a subclass
override a method of the parent class?


Let's use the classic example of 2-dimensional and 3-dimensional points and 2D circle.

A simple 2D point has two attributes: x and y.
A 3D point has x, y and also z.
A circle has x, y, and r for radius.

In addition to representing the coordinates, we would also like to be able to move
the point.

## Create the base class

The `Point.pm` file, representing the 2D point, looks like this:

```perl
package Point;
use Moo;

has x => (is => 'rw');
has y => (is => 'rw');

sub move_by {
    my ($self, $dx, $dy) = @_;

    $self->x( $self->x + $dx );
    $self->y( $self->y + $dy );

    return;
}

1;
```

The script `point.pl` looks like this:

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

When running `perl point.pl` the result is, as expected:

```
2
3
5
7
```

## Inheritance

Let's first create the Circle.pm file:

```perl
package Circle;
use Moo;

extends 'Point';

has r => (is => 'rw');

sub area {
    my ($self) = @_;
    return $self->r * $self->r * 3.14;
}

1;
```

The `extends` keyword of Moo is used to declare inheritance. Now 'Circle' is a <b>subclass</b> of 'Point'.

We also added an extra attribute and a a new `area` method that is specific to circles.

Now we can create a new script called circle.pl to see how it works:

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Circle;
my $c = Circle->new(x => 4, y => 5, r => 3);
say $c->x;
say $c->y;
say $c->r;
say $c->area;

$c->move_by(1,2);
say $c->x;
say $c->y;
say $c->r;
say $c->area;
```

```
4
5
3
28.26
5
7
3
28.26
```

As you can see we could call both the `move_by` and the `area` methods
on the object created from the Circle class. It inherited both the arguments x, y, and the method move_by.

What happens here is that when we call `$c->move_by`, Perl will see that `$c` belongs to the 'Circle' class
and thus it will look for the `move_by` function in Circle.pm. It cannot find it so it will look further up
in the inheritance hierarchy. In our case, this means in the 'Point' class which is implemented in the 'Point.pm' file.
There Perl finds the `move_by` function and calls it passing `$c` as the first argument.

On the other hand when we called the `$c->area` method, it could immediately find it in the Circle.pm file
and there was no need to look for it in Point.pm where id does not even exist.

## Overriding methods

In our other example we would like to create a 3D Point. The Point3D.pm looks like this:

```perl
package Point3D;
use Moo;

extends 'Point';

has z => (is => 'rw');

1;
```

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Point3D;
my $p = Point3D->new(x => 2, y => 3, z => 4);
say $p->x;
say $p->y;
say $p->z;

$p->move_by(5, 6, 7);
say $p->x;
say $p->y;
say $p->z;
```

Output:
```
2
3
4
7
9
4
```

Note, the z coordinate did not change.

If pass a 3rd parameter to the move_by method, the one we have implemented in the Point.pm file will just
disregard this last parameter.

We could add the following code to Point3D.pm:

```perl
sub move_by {
    my ($self, $dx, $dy, $dz) = @_;

    $self->x( $self->x + $dx );
    $self->y( $self->y + $dy );
    $self->z( $self->z + $dz );

    return;
}
```

Running the above script again, the output will be:

```
2
3
4
7
9
11
```

That would do the job. When we call `$p->move_by` on the object created by the Point3D class,
Perl will find the `move_by` function on the Point3D.pm file. Call it and stop. It will never
execute the `move_by` function found in the Point.pm file.

This can be a solution, but then we duplicated code (the changing of x and y) and worse than that,
took over responsibilities from the original Point class. This is usually not a good idea.
The Point3D class should only change the z attribute and it should somehow call the `move_by`
method of the parent class. (In our case 'Point'.)

If we did not use Moo, we would probably call the `SUPER` method, but Moo provides several,
so-called, method modifiers: `before`, `after`, and `around`.

## Method modifier: before

```perl
before move_by => sub {
    my ($self, $dx, $dy, $dz) = @_;

    $self->z( $self->z + $dz );

    return;
};
```

This means we want Moo to execute the above anonymous function before traversing the hierarchy of parent classes
to call the `move_by` method there.

Using this code, instead of the declaration of a new `move_by` method will provide the same end-result,
but now part of the job is handled by the `move_by` method of the Point class.

If you'd like to see what happens do the following experiment:

in the Point.pm file replace the move_by function by this version of code:

```perl
sub move_by {
    my ($self, $dx, $dy) = @_;

use Data::Dumper;
print 'Point ' . Dumper \@_;

    $self->x( $self->x + $dx );
    $self->y( $self->y + $dy );

    return;
}
```

In the Point3D.pm file have this code:

```perl
before move_by => sub {
    my ($self, $dx, $dy, $dz) = @_;

use Data::Dumper;
print 'Point3D ' . Dumper \@_;

    $self->z( $self->z + $dz );

    return;
};
```

Then run our script again.

The output will look like this:

```
2
3
4
Point3D $VAR1 = [
          bless( {
                   'y' => 3,
                   'x' => 2,
                   'z' => 4
                 }, 'Point3D' ),
          5,
          6,
          7
        ];
Point $VAR1 = [
          bless( {
                   'y' => 3,
                   'x' => 2,
                   'z' => 11
                 }, 'Point3D' ),
          5,
          6,
          7
        ];
7
9
11
```

Here you can see that both subroutines were executed and both received the same 4 parameter. The first parameter is the representation
of the object itself (we'll talk about that elsewhere) and then the 3 parameters.

Regarding order the code in the <b>before method modifier</b> was executed before the subroutine in the parent. That's where the name 'before' come from.


## Method modifier: after

Similar to the 'before modifier' Moo also provides and <b>after method modifier</b>:

```perl
after move_by => sub {
    my ($self, $dx, $dy, $dz) = @_;

    $self->z( $self->z + $dz );

    return;
};
```

It works the same way except that is is executed after the same subroutine in the parent class.


## Method modifier: around

The <b>around</b> modifier works differently. It is called by Moo <b>instead</b> of traversing the parent classes, and it
your job to initiate the call of the same method in the parent classes.

The anonymous subroutine in the <b>around modifier</b> will get an additional parameter, even before the object,
with a reference to the method in the parent class. That's what we capture in the `$orig` variable in the example.

Then you can write whatever code you'd like. At one point in the middle of your code, you <b>can</b>, but are not required to(!),
call the method in the `$orig` variable. We have this `$self->$orig($dx, $dy)`.

```perl
around move_by => sub {
    my ($orig, $self, $dx, $dy, $dz) = @_;

    $self->z( $self->z + $dz );
    $self->$orig($dx, $dy);

    return;
};
```

This is the only one of the 3 method modifiers, that gives you the opportunity to decide what parameters you pass to the method in the parent class.

## Conclusion

Moo allows for inheritance using the `extends` keyword. It allow the total replacement of methods,
and it also provides you 3 different method modifiers to handle cases when you'd like to reuse the methods
in the parent class.





