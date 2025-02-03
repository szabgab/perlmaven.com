---
title: "Scalar variables"
timestamp: 2013-04-20T17:45:56
tags:
  - strict
  - my
  - undef
  - say
  - +
  - x
  - .
  - sigil
  - $
  - @
  - %
  - FATAL warnings
types:
  - screencast
published: true
books:
  - beginner
author: szabgab
---


In this part of the [Perl Tutorial](/perl-tutorial), we are going to take a
look at the data structures available in Perl and how we can use them.

In Perl 5 there are basically 3 data structures. <b>Scalars, arrays and hashes</b>. The latter is also
known as dictionaries, look-up tables or associative arrays in other languages.


{% youtube id="4jyGQPGXOK0" file="modern-perl-tutorial-part-02-scalars.ogv" %}

Variables in Perl are always preceded with a sign called a <b>sigil</b>. These signs are `$` for scalars,
`@` for arrays, and `%` for hashes.

A scalar can contain a single value such as a number or a string. It can also contain a
reference to another data structure that we'll address later.

The name of the scalar always starts with a `$` (dollar sign) followed by letters, numbers and underscores.
A variable name can be `$name` or `$long_and_descriptive_name`. It can also be
`$LongAndDescriptiveName` which is often referred-to as the "CamelCase",
but the Perl community usually prefers the all-lower case variables with underscores separating the words in the name.

As we are always using <b>strict</b>, we always have to first declare our variables using <b>my</b>.
(Later you will also learn about <b>our</b> and some other ways, but for now let's stick to the <b>my</b> declaration.)
We can either assign a value immediately like in this example:

```perl
use strict;
use warnings;
use 5.010;

my $name = "Foo";
say $name;
```

or we can declare the variable first and assign only later:

```perl
use strict;
use warnings;
use 5.010;

my $name;

$name = "Foo";
say $name;
```

We prefer the former if the logic of the code allows it.

If we declared a variable, but have not assigned a value yet then it has a
value called [undef](/undef-and-defined-in-perl) which is similar to <b>NULL</b> in databases,
but which has slightly different behavior.

We can check if a variable is `undef` or not using the `defined` function:

```perl
use strict;
use warnings;
use 5.010;

my $name;

if (defined $name) {
  say 'defined';
} else {
  say 'NOT defined';
}

$name = "Foo";

if (defined $name) {
  say 'defined';
} else {
  say 'NOT defined';
}

say $name;
```

We can set a scalar variable to be `undef` by assigning `undef` to it:

```perl
$name = undef;
```

The scalar variables can hold either numbers or strings. So I can write:

```perl
use strict;
use warnings;
use 5.010;

my $x = "hi";
say $x;

$x = 42;
say $x;
```

and it will just work.

How does that work together with operators and operator overloading in Perl?

In general Perl works in the opposite way than other languages. Instead of the operands telling
the operator how to behave, the operator tells the operands how they should behave.

So if I have two variables that have numbers in them then the operator decides if they
really behave like numbers or if they behave like strings:

```perl
use strict;
use warnings;
use 5.010;

my $z = 2;
say $z;             # 2
my $y = 4;
say $y;             # 4

say $z + $y;        # 6
say $z . $y;        # 24
say $z x $y;        # 2222
```

`+`, the numerical addition operator, adds two numbers, so both `$y` and `$z` act like numbers.

`.`, concatenates two strings, so both `$y` and `$z` act like strings. (In other languages you might call this the string addition.)

`x`, the repetition operator, repeats the string on the left hand side as many times as the number on the right hand side,
so in this case `$z` acts as a string, and `$y` acts as a number.

The results would be the same if they were both created as strings:

```perl
use strict;
use warnings;
use 5.010;

my $z = "2";
say $z;             # 2
my $y = "4";
say $y;             # 4

say $z + $y;        # 6
say $z . $y;        # 24
say $z x $y;        # 2222
```

Even if one of them was created as a number, and the other one as a string:

```perl
use strict;
use warnings;
use 5.010;

my $z = 7;
say $z;             # 7
my $y = "4";
say $y;             # 4

say $z + $y;        # 11
say $z . $y;        # 74
say $z x $y;        # 7777
```

Perl automatically converts numbers to strings and strings to numbers
as required by the operator.

We call numerical and string <b>contexts</b>.

The above cases were easy. When converting a number to a string it is just as if
you put quotes around it. When converting a string to a number there are simple
cases as we saw, when all the string consists of just digits. The same would happen
if there was a decimal dot in the string, such as in `"3.14"`.
The question is: What if the string contained characters that are not part of any number? e.g `"3.14 is pi"`.
How would that behave in a numerical operation (aka. numerical context)?

Even that is simple, but it might need some explanation.

```perl
use strict;
use warnings;
use 5.010;

my $z = 2;
say $z;             # 2
my $y = "3.14 is pi";
say $y;             # 3.14 is pi

say $z + $y;        # 5.14
say $z . $y;        # 23.14 is pi
say $z x $y;        # 222
```

When a string is in numerical context Perl looks at the left side of the string,
and tries to convert it to number. As long as it makes sense, that part becomes the
numerical value of the variable. In numerical context (`+`) the string
`"3.14 is pi"` is regarded as the number `3.14`.

In a way it is completely arbitrary, but that's how it behaves so we live with that.

The above code will also generate a warning on the standard error channel (`STDERR`):

```
Argument "3.14 is pi" isn't numeric in addition(+) at example.pl line 10.
```

assuming you used <b>use warnings</b> which is highly recommended.
Using it will help you notice when something is not exactly as expected.
Hopefully the result of `$x + $y` is now clear.

## Background

To be sure, Perl did not convert `$y` to 3.14. It just used the numerical
value for the addition.
This probably explains the result of `$z . $y` as well.
In that case Perl is using the original string value.

You might wonder why `$z x $y` shows 222 while we had 3.14 on the right hand side,
but apparently perl can only repeat a string along whole numbers... In the operation
perl silently rounds the number on the right hand side. (If you are really into
deep thinking, you can recognize that the "number" context mentioned earlier has actually
several sub-contexts, one of them is "integer" context. In most cases perl does what
would seem "the right thing" for most people who are not programmers.)

Not only that, but we don't even see the warning of the
"partial string to number" conversion that we saw in the case of `+`.

This is not because of the difference in the operator. If we comment out the addition
we will see the warning on this operation. The reason for the lack of a second warning
is that when perl generated the numerical value of the string `"3.14 is pi"` it
also stored it in a hidden pocket of the `$y` variable. So effectively `$y`
now holds both a string value and a number value, and will use the right one in any
new operation avoiding the conversion.

There are three more things I'd like to address. One is the behavior of a variable with
`undef` in it, the other one is <b>fatal warnings</b> and the third one is avoiding
the automatic "string to number conversion".

## undef

If in a variable I have `undef` which most people would refer to as "nothing", it can still be used.
In numerical context it will act as 0 in string context it will act as the empty string:

```perl
use strict;
use warnings;
use 5.010;

my $z = 3;
say $z;        # 3
my $y;

say $z + $y;   # 3
say $z . $y;   # 3

if (defined $y) {
  say "defined";
} else {
  say "NOT";          # NOT
}
```

With two warnings:

```
Use of uninitialized value $y in addition (+) at example.pl line 9.

Use of uninitialized value $y in concatenation (.) or string at example.pl line 10.
```

As you can see the variable is still `undef` at the end and thus the conditional
will print "NOT".


## Fatal warnings

The other thing is that some people prefer that the application will throw a
hard exception instead of the soft warning. If that's your thing, you could change the beginning of the script and write

```perl
use warnings FATAL =&gt; "all";
```

Having that in the code, the script will print the number 3, and then throw an exception:

```
Use of uninitialized value $y in addition (+) at example.pl line 9.
```

This is the same message as was the first warning, but this time the script stops running.
(Unless, of course the exception is caught, but we'll talk about that another time.)

## Avoiding the automatic string to number conversion

If you would like to avoid the automatic conversion of strings when there is no exact conversion,
you could check if the string looks like a number when you receive it from the outside world.

For this we are going to load the module [Scalar::Util](https://metacpan.org/pod/Scalar::Util),
and use the subroutine `looks_like_number` it supplies.

{% include file="examples/fatal_warning.pl" %}


## operator overloading

Finally, you could actually have operator overloading in which case
the operands would tell what the operators should do, but let's
leave that as an advanced topic.


