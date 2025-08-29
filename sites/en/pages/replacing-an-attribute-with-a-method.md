---
title: "Replacing an accessor by a method (using BUILDARGS)"
timestamp: 2015-04-10T22:50:00
tags:
  - BUILDARGS
books:
  - moo
published: true
author: szabgab
---


Back when we learned about [type checking with Moo](/type-checking-with-moo) we had an example where
a Person had an age attribute. Unfortunately as time passes, the person represented by that object had a birthday
since then and so the age attribute does not reflect the correct number any more.

Probably it was not a good idea in the first place that we used **age** as an attribute as it basically changes every second.
Even if we only have birthdays once a year.

It would have been much better to have an attribute "birthdate" as that's something fixed.

But now it is already done. Our class is in use by lots of people around the world. We cannot just remove
the "age" attribute and add the "birthdate" attribute.

How can we fix this without breaking all the code out there?


Just to clarify, this is not a rare mistake. As we are always in a rush to release
the new version of our module/application whatever we always make such mistakes.
Even if not specifically with "age".

## The origin

So we have this code in the Person.pm file:

```perl
package Person;
use Moo;

has age => (is => 'rw');
has name => (is => 'rw');

1;
```

and we have the following code using it:

```perl
use strict;
use warnings;
use 5.010;

use Person;

my $teacher = Person->new(name => 'Foo');
$teacher->age(20);
say $teacher->name;
say $teacher->age;

my $student = Person->new(age => 18, name => 'Bar');
say $student->age;
say $student->name;
```

Nothing special here.

## Replace the attribute by a method

The age attribute was exposed to the outside world (people using the class) in two
places. One of them was the constructor where we could pass a value to the
age attribute, and the other one was the `->age` accessor.

In the first attempt we will make sure the accessor still works.

We will introduce a new attribute called `birthdate` which will be just a timestamp
returned by the `time()` function of perl,
and we will remove the `age` attribute.
We also add a new [method](/methods-functions-and-subroutines-in-perl)
called `age` that will have two ways of operation.

If called with a number as the age of the person in years, the value will be converted
to the internal representation  (which is the current time less the year in seconds) and
stored it in the `birthdate` attribute.

If called without a parameter, then it will calculate the current age (in whole numbers)
as the difference between the current time and the `birthdate`.

Here is the new version of Person.pm:

```perl
package Person;
use Moo;

has birthdate => (is => 'rw');
has name => (is => 'rw');

my $YEAR = 60*60*24*365;

sub age {
    my ($self, $age) = @_;

    if ($age) {
        $self->birthdate( time - $age * $YEAR );
    }

    return int( (time - $self->birthdate) / $YEAR );
}

1;
```

In order to simplify the example I used the variable `$YEAR` that holds an approximate number of seconds in a year.
This is good enough for our current example, though in a real application we would probably use a DateTime object there.

Let's see how well this works:

```perl
use strict;
use warnings;
use 5.010;

use Person;

my $teacher = Person->new(name => 'Foo');
$teacher->age(20);
say $teacher->name;
say $teacher->age;
```

prints

```
Foo
20
```

which is what we expected.

We can even extend our code with a little experiment:

```perl
my $teacher2 = Person->new(name => 'FooBar');
$teacher2->age(19.99999999);
say $teacher2->name;
say $teacher2->age;
sleep 5;
say $teacher2->age;
```

We set the age to be just before the age of 20, we wait and see how the returned age
(that we wanted to be a whole number) changes from 19 to 20:

```
FooBar
19
20
```

Last, but not least, we try to pass `age` in the constructor:

```perl
my $student = Person->new(age => 18, name => 'Bar');
say $student->name;
say $student->age;
```

The output shows that the age attribute was swallowed by Moo and thus we get
a warning:

```
Bar
Use of uninitialized value in subtraction (-) at Person.pm line 16.
```

## Fixing the constructor

In order to fix the constructor we are going to use the `BUILDARGS` method of Moo.

If you implement this method in your class, Moo will call it before calling the constructor.
It will get all the parameters the constructor gets (the name of the class and all the arguments
you passed to the `->new` call), and the method should return a reference to a hash
holding the (probably updated) parameters of the constructor.

When we call `Person->new(name => 'Bar', age => 18)`, perl would call the `new` method
with the following arguments: `'Person', name => 'Bar', age => 18`, which is just the same
a `'Person', 'name', 'Bar', 'age', 18`.
(If in doubt, see the explanation about the [fat-arrow](/perl-hashes).)

Moo already provides the `new` constructor, hence we don't have to call it.
Moo also check is we have implemented a method called `BUILDARGS`. If we have such function
in our module, then, before calling the `new` method, Moo will call this method.
So in our case `$class` will be 'Person' and `%args` will contain two key-value pairs:

```perl
   'name' => 'Bar',
   'age' => 18
```

We remove the `age` and replace it with a `birthdate` key and with the appropriate value.
Then we return the reference to this hash.

Moo will grab that hash-reference and call `new` passing the name of the class ('Person') and the
new set of arguments that can be found in this hash reference.

Thus we could replace the 'age' argument passed in by the user, by the 'birthdate' argument.

```perl
sub BUILDARGS {
    my ($class, %args) = @_;

    my $age = delete $args{age};
    if ($age) {
        $args{birthdate} = time - $age * $YEAR;
    }
    return \%args;
}
```

If you want to see it for yourself, add the following code to the Person.pm file:

```perl
sub BUILDARGS {
    my ($class, %args) = @_;

    use Data::Dumper;
    print "Class: $class\n";
    warn Dumper \%args;

    my $age = delete $args{age};
    if ($age) {
        $args{birthdate} = time - $age * $YEAR;
    }
    return \%args;
}
```

and run the following script:

```perl
use strict;
use warnings;
use 5.010;

use Person;

my $teacher = Person->new(name => 'Foo');
my $student = Person->new(age => 18, name => 'Bar');
```

The output will look like this:

```
Class: Person
$VAR1 = {
          'name' => 'Foo'
        };
Class: Person
$VAR1 = {
          'name' => 'Bar',
          'age' => 18
        };
```

You can see the name of the class was 'Person' in both cases and the
data received in %args matches what we passed to the `new` call.


## Put it together and test it

The whole Person.pm file:

```perl
package Person;
use Moo;

has birthdate => (is => 'rw');
has name => (is => 'rw');

my $YEAR = 60*60*24*365;

sub BUILDARGS {
    my ($class, %args) = @_;
    my $age = delete $args{age};
    if ($age) {
        $args{birthdate} = time - $age * $YEAR;
    }
    return \%args;
}

sub age {
    my ($self, $age) = @_;

    if ($age) {
        $self->birthdate( time - $age * $YEAR );
    }

    return int( (time - $self->birthdate) / $YEAR );
}

1;
```

The script:

```perl
use strict;
use warnings;
use 5.010;

use Person;

my $teacher = Person->new(name => 'Foo');
$teacher->age(20);
say $teacher->name;
say $teacher->age;

my $student = Person->new(age => 18, name => 'Bar');
say $student->name;
say $student->age;
```

The output:

```
Foo
20
Bar
18
```

## Conclusion

So we changed the internal representation of **age** replacing the **age** attribute by a <b>birthdate</b> attribute.
The users of our class don't need to change anything as the retained the old API.

We could now decide to deprecate the old API but keep it around for a while to let our users adjust their code,
or we can decide to keep it around forever.


