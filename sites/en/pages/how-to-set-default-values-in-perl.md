---
title: "How to set default values in Perl"
timestamp: 2014-12-17T09:30:01
tags:
  - //
  - //=
  - ||
  - ||=
published: true
author: szabgab
---



Often there are cases your Perl application has some default values that can be overridden
by a value in a configuration file or on the command line. The same can be the case
for individual functions in perl that accept arguments. In case the arguments
are not provided, the function will use its default values.

Let's see how to set default values.


## Scalars

The common way to set a default value is using the `//`
(the defined or operator that was [introduced in perl 5.10](/what-is-new-in-perl-5.10--say-defined-or-state)):

```perl
sub f {
    my $count = shift // $SOME_DEFAULT;
}
```

In another way it would be:

```perl
sub f {
    my ($count, $other_param) = @_;
    $count //= $SOME_DEFAULT;
}
```

Similarly when accepting values from the command line one would write:

```perl
my $filename = shift // 'default_file';
```


## Perl older than 5.10

If you have to make sure your code runs on perl versions lower than 5.10 you can use the following code:

```perl
sub f {
    my $count = shift;
    $count = $SOME_DEFAULT if not defined $count;
}
```

or use the [ternary operator](/the-ternary-operator-in-perl):

```perl
sub f {
    my ($count, $param) = @_;
    $count = defined $count ? $count : $SOME_DEFAULT;
}
```

In some places you'll see people using `||`, the regular or operator, to set default values as in the following example:

```perl
sub f {
    my $count = shift || $SOME_DEFAULT;
}
```

This works too, in most of the cases but if an empty string, or the number 0 are valid parameters of the function this
will be incorrect. This will override those, otherwise valid values with the value in `$SOME_DEFAULT`
That's because both the empty string and the number 0 are evaluated to [false](/boolean-values-in-perl).

## Arrays

I don't think I have seen code where individual element of an array were set as defaults, and I don't think there is a nice
way to do that besides treating them as individual scalar values. It is also not often that you would pass an array with "hole"
in it. It is much more common to pass an array reference, and in that case, if the user has not passed anything there, then
it might be interesting to set it to a default value.

But that case is just a special case of the default scalar values as discussed above except that `$SOME_DEFAULT` will
be a reference to an array. Possibly an empty array:

```perl
f('Foo', ['Bar', 'Baz']);

sub f {
   my ($name, $friends) = @_;
   $friends //= [];
}
```


## Hashes

It much more often that we can see a function accepting key-value pairs that are assigned to a hash, or a reference to a hash.
In some cases you'd want to set certain default values to some of the keys.

```perl
use strict;
use warnings;
use Data::Dumper qw(Dumper);

f(cmd => 'send', to => 'near-by-address');
f(cmd => 'copy');

sub f {
    my %default = (
        from  => 'local-machine',
        to    => 'remote-machine',
    );

    my %params = (%default, @_);

    print Dumper \%params;
}
```

In this script we created a hash called `%default` with some key-value pairs in it. Then we assigned to the
`%params` the mix of `(%default, @_)`.  The result looks like this:

```
$VAR1 = {
          'cmd' => 'send',
          'to' => 'near-by-address',
          'from' => 'local-machine'
        };
$VAR1 = {
          'cmd' => 'copy',
          'from' => 'local-machine',
          'to' => 'remote-machine'
        };
```

In the first call we supplied values for both the 'cmd' and the 'to' fields. In that case the `%params` hash got the values
of 'cmd' and 'to' from the calling of the function, while the value if 'from' is the one that was in the `%default` hash.

In the second call we only supplied value for the 'cmd' key and thus the result was that `%params` got the values of both
'to' and 'from '  from the `%default` hash.

The reason this work is because when we put the `%default` array in parentheses, perl flattened the content so in effect this is what we had
at the first call:

```
   my %params = (
        from  => 'local-machine',
        to    => 'remote-machine',
        cmd   => 'send',
        to    => 'near-by-address'
   );
```

Note, we effectively supplied the 'to' key twice. Whenever we do that the last value supplied overrides any previous value so the effect was
this assignment:

```
   my %params = (
        from  => 'local-machine',
        cmd   => 'send',
        to    => 'near-by-address'
   );
```

