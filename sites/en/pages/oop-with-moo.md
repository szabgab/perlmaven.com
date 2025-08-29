---
title: "OOP with Moo"
timestamp: 2013-04-13T18:33:01
tags:
  - OOP
  - Moo
books:
  - moo
types:
  - screencast
published: true
---


There are several ways to write Object Oriented Perl. You can manually bless references, you can use one of the constructor and accessor generator modules,
or you can use one of the modules from the [Moose](/moose) family. [Moo](/moo) is the Minimalist Object Orientation with Moose compatibility. In this screencast you'll learn
the basics. (3:19 min)


{% youtube id="aRkSb1AUS-0" file="oop_with_moo_1280x720" %}

<div id="text">
We are going to see how to create a class using [Moo](https://metacpan.org/pod/Moo).
the Minimal Object Oriented system of Perl. In order to show this example, we need two files.
One of them is a script called `school.pl` which has standard Perl preamble
at the beginning and loads the `Person` module.

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Person;
```

The other one is the actual `Person` module in the **Person.pm** file
that has at the beginning the namespace declaration `package Person;` and the
true value `1;` at the end.

```perl
package Person;

1;
```

It does not have `use strict;` and `use warnings;`
because we are going to `use Moo;`.
and use Moo already declares that `use strict;` and `use warnings;`
are in effect in this file.

The main thing that Moo does here, is that it provides a constructor:

```perl
package Person;
use Moo;

1;
```

Now we can go back to the script and create an object. Let's say this is a student
and it gets the result of the constructor: <h>my $student = Person->new;`.
`use Moo;` in the module already added the constructor.

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Person;
my $student = Person->new;
```

Now we have this `$student` object, but it does not have any attributes.
Let's go back to the class and tell it that a person has a name, and that name
is going to be read only. `has name => (is => 'ro');`

Once we added this line of code:

```perl
package Person;
use Moo;

has name => (is => 'ro');

1;
```

we can go back to our script and in the constructor we can pass the
**name** attribute and a value 'Foo'. 
`my $student = Person->new(name => 'Foo');`
Not only that, but we can also use the name accessor to fetch this value
and print it out using **say**: `say $student->name;`.

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Person;
my $student = Person->new(name => 'Foo');
say $student->name;
```

That's it. Now we can go to the command line and run the school script
`perl school.pl` and it will print out **Foo**, the name of the
person.

What happens if we want to change the name? We try to set the value of
**name** to 'Bar': `$student->name('Bar');` and then, just so
we will see it, we will print it out again: `say $student->name;`.

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Person;
my $student = Person->new(name => 'Foo');
say $student->name;
$student->name('Bar');
say $student->name;
```

Now if we run the code `perl school.pl` it will print out **Foo**,
but then it will throw an exception.

```
Foo
Usage: Person::name(self) at school.pl line 9.
```

Moo threw an exception and it told us that this method only accepts one value
which is the **self**. We don't want to go into the details, but basically
when you call a method such as the `$student->name('Bar');` method on an object,
Perl automatically passes the object as the first parameter. So in this call we had
two parameters: the object itself and the 'Bar' value. That's where the error message
came from.

In reality, the exception is because in the declaration, in the Person module, we said
that this attribute is read-only: `ro`. If we change that to be both readable
and writable `rw` like this: `has name => (is => 'rw');`, save the file,
go back to the console and run the script again: `perl school.pl` it will print out:

```
Foo
Bar
```

because now we can actually change that attribute.

</div>
