---
title: "Automatic string to number conversion or casting in Perl"
timestamp: 2013-01-10T10:45:56
tags:
  - is_number
  - looks_like_number
  - Scalar::Util
  - casting
  - type conversion
published: true
books:
  - beginner
author: szabgab
---


Imagine you prepare the shopping list, write on it

```
"2 loaves of bread"
```

and hand it over to your significant other who promptly
throws and invalid type conversion error in your face.
After all "2" is a string there, not a number.

That would be frustrating, wouldn't it?


See also the screencast about [string to number conversion in Perl](/beginner-perl-maven-string-number-conversion).

## Type conversion in Perl

In most of the programming languages the type of the operands define how an operator behaves.
That is, <i>adding</i> two numbers does numerical addition, while <i>adding</i> two strings together concatenates them.
This feature is called operator overloading.

Perl, mostly works in the opposite way.

In Perl, the operator is the one that defines how the operands are used.

This means if you are using a numerical operation (e.g. addition) then both values
are automatically converted to numbers. If you are using a string operation
(e.g. concatenation) then both values are automatically converted to strings.

C programmers would probably call these conversions **casting** but this word is
not used in the Perl world. Probably because the whole thing is automatic.

Perl does not care if you write something as number or as string.
It converts between the two automatically based on the context.

The `number =&gt; string` conversion is easy.
It is just a matter of imaging as if "" appeared around the number value.

The `string =&gt; number` conversion might leave you thinking a bit.
If the string looks like a number to perl, then it is easy.
The numerical value is just the same thing. Without the quotes.

If there is any character that stops perl from fully converting the string to a
number, then perl will use as much as it can on the left hand side of the string for the
numerical value and disregard the rest.

Let me show a couple of examples:

```
Original   As string   As number

  42         "42"        42
  0.3        "0.3"       0.3
 "42"        "42"        42
 "0.3"       "0.3"       0.3

 "4z"        "4z"        4        (*)
 "4z3"       "4z3"       4        (*)
 "0.3y9"     "0.3y9"     0.3      (*)
 "xyz"       "xyz"       0        (*)
 ""          ""          0        (*)
 "23\n"      "23\n"      23
```

In all the cases where the string to number conversion is not perfect,
except the last one, perl will issue a warning. Well, assuming you turned
on `use warnings` as recommended.

## Example

Now that you saw that table let's see it in code:

```perl
use strict;
use warnings;

my $x = "4T";
my $y = 3;

```

Concatenation converts both values to strings:

```perl
print $x . $y;    # 4T3
```

Numerical addition converts both values to numbers:

```perl
print $x + $y;  # 7
                # Argument "4T" isn't numeric in addition (+) at ...
```

## Argument isn't numeric

That's [the warning](/argument-isnt-numeric-in-numeric) you get when perl is trying to convert
a string to a number and the conversion isn't perfect.

There are a number of other common warnings and errors in Perl.
For example [Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name)
and [Use of uninitialized value](/use-of-uninitialized-value).

## How to avoid the warning?

It is nice that perl will warn you (if asked to) when the type conversion was not perfect, but isn't there a function
like **is_number** that will check if the given string is really a number?

Yes and no.

Perl does not have an **is_number** function as that would be some kind of commitment that the Perl developers
know what is a number. Unfortunately the rest of the world cannot agree on this point exactly. There are systems
where ".2" is accepted as a number, but other systems where that is not accepted.
Even more common that "2." is not accepted, but there are system where that is a perfectly acceptable number.

There are even places where 0xAB is considered a number. A Hexadecimal number.

So there is no **is_number** function, but there is a less committing function called **looks_like_number**.

That's exactly what you think it is. It will check if the given string looks like a number for perl.

It is provided by the [Scalar::Util](http://perldoc.perl.org/Scalar/Util.html) module
and you can use it like this:

{% include file="examples/type_conversion.pl" %}

Don't forget the milk too!

## Comments

What about keeping strings from becoming numbers? like preventing 0018 from becoming 18?

---
If a string like "0018" is only used in string-operations, (e.g. concatenation) then it will not be converted to a number.

<hr>

Also, leading whitespace is ignored - that is ' 42' will convert to numeric 42 (without a warning, even!). (Which is good news when using right-aligned numbers produced by sprintf.)

I don't know whether the concept of whitespace is locale-aware or not; if it's using the regular expression engine internally (i.e., doing the equivalent of s/^\s+//), then it probably is. My tests worked with space, tab, carriage return, and line feed.


