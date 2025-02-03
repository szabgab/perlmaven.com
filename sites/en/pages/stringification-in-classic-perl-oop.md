---
title: "Stringification in classic Perl OOP"
timestamp: 2014-02-05T14:30:01
tags:
  - overload
  - ref
  - blessed
  - Scalar::Util
published: true
books:
  - advanced
author: szabgab
---


In the previous article we saw [how to create a class](/constructor-and-accessors-in-classic-perl-oop) using bless, but when we printed the instance object we got
`My::Date=HASH(0x7f807c13c700)`. This can be useful as it tells us we are dealing with a My::Date object, but on the
other hand it could print something more interesting. For example it could print a nice representation of the attributes:
`Date(2013, 1, 27)`


## Stringification

means that we take an object and create a string format. It happens when the object is placed in
[string context](/what-are-string-and-numeric-contexts). For example when it is printed.

## Operator overloading

In order to change the behavior of the My::Date class when an object of that type is placed in string context,
we need to "overload" the stringification operator. It can be done using the [overload](https://metacpan.org/pod/overload) module.

This is what needs to be added to the Date.pm file in the [previous example](/constructor-and-accessors-in-classic-perl-oop).

```perl
use overload
    '""' => 'stringify';

sub stringify {
    my ($self) = @_;
    return sprintf 'Date(%s, %s, %s)', $self->year, $self->month, $self->day;
}
```

The `stringify` subroutine, that can actually have any name, implements the actual stringification.
In some modules the author call it `to_string` or `to_str`, the actual name only matters because
the method can also be used on its own. A user could write:

```perl
my $d = My::Date->new(year => 2013, month => 1, day => 27);
say $d->stringify;
```

This will print `Date(2013, 1, 27)`.

The first two lines in the above code, loads the [overload](https://metacpan.org/pod/overload) module
and tells it that when the object is in string context, call the stringify method. When "use"-ing the overload
module we pass a set of key-value pairs. In this case the key is `""` (two double-quotes) and the value
is the name of the method that implements it.

The more interesting usage of this is when we just simply print `$d`:

```perl
my $d = My::Date->new(year => 2013, month => 1, day => 27);
say $d;
```

In this case too, perl will call the `stringify` method of the `My::Date` class,
and will print the value returned by that function.

## Which name-space does the object belong to?

Now that we change what a single object returns, we seem to have lost the previous information.
To which class does this object belong to?

No problem, the `ref` function can tell us this information:

```perl
say ref $d;
```

will print `My::Date`.

Alternatively, one can use the `blessed` function of [Scalar::Util](https://metacpan.org/pod/Scalar::Util)

```perl
use Scalar::Util qw(blessed);
say blessed $d;
```

The advantage of the `blessed` function is that it will return [undef](/undef-and-defined-in-perl) if
the values is not blessed, while `ref` can return values such as `HASH`, `ARRAY` etc. So if there
is a scalar variable that you want to know if it is blessed or not, it is simpler to write

```perl
if (defined blessed $var) {
}
```

that to compare the result of `ref` to all the known types of references.


## Full example

```perl
package My::Date;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    return bless \%args, $class;
}

sub year {
    my ($self, $value) = @_;
    if (@_ == 2) {
        $self->{year} = $value;
    }
    return $self->{year};
}

sub month {
    if (@_ == 2) {
        $_[0]->{month} = $_[1];
    }
    return $_[0]->{month};
}

sub day {
    return $_[0]->{day} = @_ == 2 ? $_[1] : $_[0]->{day};
}



use overload 
    '""' => \&stringify;


sub stringify {
    my ($self) = @_;
    return sprintf 'Date(%s, %s, %s)', $self->year, $self->month, $self->day;
}

1;

```

```perl
use strict;
use warnings;
use 5.010;

use FindBin;
use File::Spec;
use lib File::Spec->catdir($FindBin::Bin, '..', 'lib');
use My::Date;

my $d = My::Date->new(year => 2013, month => 1, day => 27);
say $d->stringify;
say $d;

say ref $d;

use Scalar::Util qw(blessed);
say blessed $d;
```


