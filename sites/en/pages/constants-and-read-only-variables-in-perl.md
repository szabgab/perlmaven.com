---
title: "Constants and read-only variables in Perl"
timestamp: 2013-09-14T18:30:01
tags:
  - constant
  - Readonly
  - Readonly::XS
published: true
books:
  - beginner
author: szabgab
---


Often in programs we would like to have symbols that represent a constant value.
Symbols that we can set to a specific values once, and be sure they never change.
As with many other problems, there are several ways to solve this in Perl, but
in most cases enforcement of "constantness" is not necessary.

In most cases we can just adhere to the established consensus, that <b>variables with
all upper-case names should be treated as constants</b>.


Later we'll see a couple of solutions that actually enforce the "constantness"
of the variables, but for most purposes, having a variable in upper case is enough.

## Treat upper-case variables as constants

We declare and set the values just as we'd do with any other variable in Perl: 

```perl
use strict;
use warnings;
use 5.010; 

my $SPEED_OF_LIGHT = 299_792_458; # m/s
my %DATA = (
   Mercury => [0.4,     0.055   ],
   Venus   => [0.7,     0.815   ],
   Earth   => [1,       1       ],
   Mars    => [1.5,     0.107   ],
   Ceres   => [2.77,    0.00015 ],
   Jupiter => [5.2,   318       ],
   Saturn  => [9.5,    95       ],
   Uranus  => [19.6,   14       ],
   Neptune => [30,     17       ],
   Pluto   => [39,   0.00218    ],
   Charon  => [39,   0.000254   ],
);
my @PLANETS = sort keys %DATA;
```

Each planet in the [Solar System](http://en.wikipedia.org/wiki/Solar_System)
has two values. The first is their average distance from the Sun and the second is their mass,
relative to the Earth.

Once the values are initially set, they should NOT be changed.

Nothing enforces it, besides a secret agreement among Perl programmers and Astronomers.

```perl
say join ', ', @PLANETS;
say $SPEED_OF_LIGHT;
$SPEED_OF_LIGHT = 300_000_000;
say "The speed of light is now $SPEED_OF_LIGHT";
```

We can use these "constants" in the same way as we would use any variable.
We could even change the values, but it is not recommended.

Besides its simplicity, one of the nice things in this solution is that we can
actually compute the values of these constants during run time, as
we did with the `@PLANETS` array.

In many cases this is enough and the cost of creating <b>"real"</b> constants
is unnecessary.

Nevertheless, let's see two other solutions:

## The Readonly module

The [Readonly](https://metacpan.org/pod/Readonly) module from CPAN
allow us to designate some of our "variables" to be read-only. Effectively turning
them into constants.

```perl
use strict;
use warnings;
use 5.010; 

use Readonly;

Readonly my $SPEED_OF_LIGHT => 299_792_458; # m/s
Readonly my %DATA => (
   Mercury => [0.4,     0.055   ],
   Venus   => [0.7,     0.815   ],
   Earth   => [1,       1       ],
   Mars    => [1.5,     0.107   ],
   Ceres   => [2.77,    0.00015 ],
   Jupiter => [5.2,   318       ],
   Saturn  => [9.5,    95       ],
   Uranus  => [19.6,   14       ],
   Neptune => [30,     17       ],
   Pluto   => [39,   0.00218    ],
   Charon  => [39,   0.000254   ],
);
Readonly my @PLANETS => sort keys %DATA;
```

The declaration of the read-only variables (our constants) is very similar
to what happens with regular variables, except that we precede each declaration
with the `Readonly` keyword, and instead of assignment `=`, we separate
the name of the variable and their values by a fat-arrow: `=>`.

While the names of the read-only variables can be in any case, it is recommended
to only use UPPER-CASE names, to make it easy for the reader of the code to recognize
them, even without looking at the declaration.

Readonly allows us to create constants during the run-time as we have done above
with the `@PLANETS` array.

```perl
say join ', ', @PLANETS;
say "The speed of light is $SPEED_OF_LIGHT";
$SPEED_OF_LIGHT = 300_000_000;
say "The speed of light is now $SPEED_OF_LIGHT";
```

If we run the above code, we'll get an exception that says:
`Modification of a read-only value attempted at ...`
at the line where we tried to assign the new value to
the `$SPEED_OF_LIGHT`.

The same would have happened if we attempted to change one of the
internal values such as either of these:

```perl
$DATA{Sun} = 'big';
$DATA{Mercury}[0] = 1;
```

The biggest drawback of Readonly, is its relatively slow performance.

## Readonly::XS

There is also the [Readonly::XS](https://metacpan.org/pod/Readonly::XS)
module that can be installed. One does not need to make any changes to their code,
once the `use Readonly;` statement notices that `Readonly::XS` is
also installed, the latter will be used to provide a speed improvement.

## The constant pragma

Perl comes with the [constant](http://perldoc.perl.org/constant.html)
pragma that can create constants.

The constants themselves can only hold scalars or references to complex data structure
(arrays and hashes). The names of the constants do not have any sigils in front of them.
The names can be any case, but even in the documentation of
[constant](http://perldoc.perl.org/constant.html) all the examples use
upper case, and it is probably better to stick to that style for clarity.

```perl
use strict;
use warnings;
use 5.010; 

use constant SPEED_OF_LIGHT => 299_792_458; # m/s
use constant DATA => {
   Mercury => [0.4,     0.055   ],
   Venus   => [0.7,     0.815   ],
   Earth   => [1,       1       ],
   Mars    => [1.5,     0.107   ],
   Ceres   => [2.77,    0.00015 ],
   Jupiter => [5.2,   318       ],
   Saturn  => [9.5,    95       ],
   Uranus  => [19.6,   14       ],
   Neptune => [30,     17       ],
   Pluto   => [39,   0.00218    ],
   Charon  => [39,   0.000254   ],
};
use constant PLANETS => [ sort keys %{ DATA() } ];
```

Creating a constant with a scalar value, such as the `SPEED_OF_LIGHT` is easy.
We just need to use the `constant` pragma.
We cannot create a constant hash, but we can create a constant reference to an
anonymous hash. The difficulty comes when we would like to use it as a real hash.
We need to dereference it using the `%{ }` construct, but in order to
make it work we have to put a pair of parentheses after the name `DATA`.

This might look strange, but the reason is that the `constant` actually
creates functions with the given names, that return the fixed values. In
the above case `use constant DATA ...` created a function called `DATA()`.

We don't have to always use the parentheses. For example we can write:

```perl
say SPEED_OF_LIGHT;
```

and that will work. On the other hand the following code will print
`The speed of light is now SPEED_OF_LIGHT`.
Because these constants don't have sigils, they cannot interpolate in a string.

```perl
say "The speed of light is now SPEED_OF_LIGHT";
```

If we try to modify the constant:

```perl
SPEED_OF_LIGHT = 300_000_000;
```

we get an exception: `Can't modify constant item in scalar assignment at ...`.
but we can re-declare them:

```perl
use constant SPEED_OF_LIGHT => 300_000_000; # m/s
say SPEED_OF_LIGHT;
```

that will print 300000000.
It will give a warning
`Constant subroutine main::SPEED_OF_LIGHT redefined` only if we have
`use warnings;` enabled.

So the `constant` pragma does not fully protect us from changing the
"constant".
 
Note, fetching the values from a constant that holds a reference to an array
also requires the parentheses again, and the de-referencing construct:

```perl
say join ', ', @{ PLANETS() };
```

## Other ways to create constants

If the above is not enough, Neil Bowers wrote a review
comparing [21 different ways to define constants](http://neilb.org/reviews/constants.html).

## Conclusion

You can probably get away with regular upper-case variables, but
if you'd really like to make the variables immutable, use the
`Readonly` module.


## Comments

The documentation for Readonly says that performance has been significantly improved when using Perl 5.8+ to the point of not recommending Readonly::XS. Cf.

https://search.cpan.org/dist/Readonly/lib/Readonly.pm#Cons

https://search.cpan.org/dist/Readonly/lib/Readonly.pm#Internals
