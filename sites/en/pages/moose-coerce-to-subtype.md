---
title: "Moose: coerce value to a subtype"
timestamp: 2016-12-27T13:00:11
tags:
  - Moose
  - Moose::Util::TypeConstraints
  - coerce
types:
  - screencast
books:
  - moose
published: true
author: szabgab
---


In the previous part we [created a subtype](/moose-creating-subtypes) that accepted either the
letter 'm' or the letter 'f' for male and female respectively.

What if we would like to accept the word 'male' and 'female' as well but still we don't want to accept any other word and
we still want the values to be kept as 'm' and 'f' respectively?

For this in [Moose](/moose) we can use coercion.


<slidecast file="advanced-perl/moose/coerce-to-subtype" youtube="z_w2ObbFfWY" />

See the <b>script/person.pl</b> file for how we would like to use the class:

```perl
use strict;
use warnings;
use v5.10;

use Person;
use DateTime;

my $student = Person->new( name => 'Foo' );

$student->sex('m');        # should be accepted as 'm'
say $student->sex;

$student->sex('female');   # should be accepted as 'f'
say $student->sex;

$student->sex('other');    # should not be accepted
```

This is the implementation in `lib/Person.pm`:

```perl
package Person;
use Moose;
use Moose::Util::TypeConstraints;

subtype 'Person::Type::Sex'
    => as 'Str'
    => where { $_ eq 'f' or $_ eq 'm' }
    => message { "The sex you provided ($_) is not valid. " .
        "Valid values are 'f' and 'm'." };

coerce 'Person::Type::Sex'
    => from 'Str'
    => via { lc substr($_, 0, 1) };

has 'name'     => (is => 'rw');
has 'birthday' => (isa => 'DateTime', is => 'rw');
has 'sex'      => (isa => 'Person::Type::Sex', is => 'rw', coerce => 1);

1;
```

Everything is the same as in the [previous example](/moose-creating-subtypes), but here we also have
this extra code:

```perl
coerce 'Person::Type::Sex'
    => from 'Str'
    => via { lc substr($_, 0, 1) };
```

and at the definition of the 'sex' attribute we added `coerce => 1` to enable coercion.

The coercion is related to a specific type, that's the first parameter the `coerce` function receives.
Then we declare what kind of values can we try to coerce, in this case `from 'Str'` means this rule can handle
any value that is a string. The last part in our declaration is new code snippet. This is what actually converts
the value provided by the user to some other value.
In our case this is quite simple: `via { lc substr($_, 0, 1) };` will take the first character of the string and convert
it into a lower-case character. Note, this part does not care what was the value the user pass as long as it was a string.
It will just convert (coerce) the string to the lower case version of its first character and then the `subtype`
declaration we saw earlier will apply its constraint `where { $_ eq 'f' or $_ eq 'm' }`.

This means the user can pass any string, 'f', 'F', 'Female', they will all be converted to lower-case 'f'.
If the user passes 'm', 'M', 'male', or even other words starting with the letter 'm' such as 'mule' will all be
converted to 'm' and will be accepted as male.




