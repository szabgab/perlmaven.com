---
title: "Moose constructor"
timestamp: 2016-10-21T00:00:11
tags:
  - Moose
  - has
  - rw
  - new
  - constructor
types:
  - screencast
books:
  - moose
published: true
author: szabgab
---


There are many ways to write Object Oriented code in Perl. In this screencast we'll see how to do that using
[Moose](/moose).


<slidecast file="advanced-perl/moose/constructor" youtube="HiZAGluWlVc" />

We start with the most basic example and create a script called <b>person.pl</b> with the following content:

```perl
use strict;
use warnings;
use v5.10;

use Person;

my $teacher = Person->new;
```

Here we load the `Person` module, which declares the `Person` class and then call the `new` constructor of that class to create
and instance, or object that we assign to the `$teacher` variable.

The implementation of the `Person` class using [Moose](/moose) is very simple. We just need to create a file called <b>Person.pm</b>
with the following content:

```perl
package Person;
use Moose;

1;
```

`package Person;` declares the `Person` namespace. Then we load `Moose` and we end the module with the mandatory true value.

With just this code, Moose already provides a constructor for us. We can now run the `person.pl` script.

A word about layout if both files are in the same directory, and if your are in that directory when you run the script then this should just work fine:

```
 dir/
    person.pl
    Person.pm
```

## First attribute

Of course having just a constructor is not very interesting so in the next example we will have an attribute called `name` with
the appropriate setter and getter methods. The `person.pl` script, that uses the new version of the class looks like this:

```perl
use strict;
use warnings;
use v5.10;

use Person;

my $teacher = Person->new;

$teacher->name('Foo');

say $teacher->name;
```

Here, after creating the `Person` object using the `new` constructor, we call the `name` method on the `$teacher` object.
Because we also passed a value to the method, it acts as a `setter` and sets the `name` attribute of the `$teacher` object to be 'Foo'.

On the next line we call the same `name` method, but this time we don't pass any value. In this case the method acts as a `getter`
and returns the previously assigned value. 'Foo' in this case.

This is what we need to write in the `Person.pm` file in order to have the attribute and the getter/setter method:

```perl
package Person;
use Moose;

has 'name' => (is => 'rw');

1;
```

That's it. By adding  `has 'name' => (is => 'rw');` we told Moose this class (and every object created from this class) will have
an attribute called 'name'. This attribute need an accessor which can both `read` and `write` (That's what the 'rw' tells it).
Which means Moose will create a method called `name` that is both a getter (to read) and a setter (to write) the value of the attribute.


## Attributes in the constructor

Not only has Moose created a getter/setter accessor, it also changed the constructor, so we can already pass the value of `name`
when we create the object using `new`. That way, we can create a new instance of the `Person` class and it will already
have the `name` attribute set. See the new version of the `person.pl` script:

```perl
use strict;
use warnings;
use v5.10;

use Person;

my $teacher = Person->new( name => 'Foo' );

say $teacher->name;
```

