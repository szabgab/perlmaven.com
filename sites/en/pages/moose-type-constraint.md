---
title: "Moose type constraints"
timestamp: 2016-11-20T13:26:11
tags:
  - Moose
  - Int
  - isa
books:
  - moose
types:
  - screencast
published: true
author: szabgab
---


Perl does not care much about the type of the values, whether the are integers, floating point numbers, strings, or whatever other specialized types,
but [Moose](/moose) can provide such type-checking in its setters.


{% youtube id="oDIEsHcK3d4" file="advanced-perl/moose/type-constraint" %}

In this example  we a script called `script/person.pl` that looks like this:

```perl
use strict;
use warnings;
use v5.10;

use Person;

my $student = Person->new( name => 'Foo' );

$student->year(1988);

say $student->year;

$student->year('23 years ago');
```

After calling the constructor and setting the **name** attribute of the object we call a new setter called **year** that will set
the year of birth of the given person. In the next statement we use the appropriate getter to retrieve the value we set and then we call
the setter again, but this time we pass a string '23 years ago' to it. If we don't have any constraints on the value that `year`
would accept then this will work, and the value of the **year** attribute is set to be '23 year ago', but let's see what do we
really have in the `lib/Person.pm` file:

```perl
package Person;
use Moose;

has 'name' => (is => 'rw');
has 'year' => (isa => 'Int', is => 'rw');

1;
```

Similar to the declaration of the 'name' attribute, we also declare the 'year' attribute. It is also defined using `is => 'rw'`
that tells Moose to make the accessor both a getter and a setter, but it also has an additional definition:
`isa => 'Int'`.  This tells Moose that the 'year' attribute must be an Integer and the setter will check if the value
passed by the calling code fits in that type constraint.

So when we run the above script: `perl -Ilib scrtip/person.pl` the first few calls will work, but the last one will
throw an exception as the string '23 years ago' violated the type constraint. We will see the following output
on the screen:

```
Attribute (year) does not pass the type constraint because:
   Validation failed for 'Int' with value "23 years ago"
       at accessor Person::year (defined at lib/Person.pm line 5) line 4
   Person::year('Person=HASH(0x19a4120)', '23 years ago')
       called at script/person.pl line 13
```

Modules created without Moose will usually not have this feature, or if they do, that was added by writing
lots of additional code for type-checking. In Moose we can have this by a simple declaration.

