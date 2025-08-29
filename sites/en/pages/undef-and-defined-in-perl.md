---
title: "undef, the initial value and the defined function of Perl"
timestamp: 2013-01-31T08:45:56
tags:
  - undef
  - defined
published: true
books:
  - beginner
author: szabgab
---


In some languages there is a special way to say "this field does not have a value".
In **SQL**, **PHP** and <b>Java</b> this would be `NULL`. In <b>Python</b> it is `None`.
In **Ruby** it is called `Nil`.

In Perl the value is called `undef`.

Let's see some details.


## Where do you get undef from?

When you declare a scalar variable without assigning a value to it, the content will be the well defined `undef` value.

```perl
my $x;
```

Some functions return `undef` to indicate failure.
Others might return undef if they have nothing valuable to return.

```perl
my $x = do_something();
```

You can use the `undef()` function to reset a variable to `undef`:

```perl
# some code
undef $x;
```

You can even use the return value of the `undef()` function to set a variable to `undef`:

```perl
$x = undef;
```

The parentheses after the function name are optional and thus I left them out in the example.

As you can see there are a number of ways to get **undef** in a scalar variable.
The question is then, what happens if you use such variable?

Before that though, let's see something else:

## How to check if a value or variable is undef?

The `defined()` function will return [true](/boolean-values-in-perl) if
the given value is **not undef**. It will return [false](/boolean-values-in-perl)
if the given value is **undef**.

You can use it this way:

```perl
use strict;
use warnings;
use 5.010;

my $x;

# some code here that might set $x

if (defined $x) {
    say '$x is defined';
} else {
    say '$x is undef';
}
```


## What is the real value of undef?

While **undef** indicates the absence of a value, it is still not unusable.
Perl provides two usable default values instead of undef.

If you use a variable that is undef in a numerical operation, it pretends to be 0.

If you use it in a string operation, it pretends to be the empty string.

See the following example:

```perl
use strict;
use warnings;
use 5.010;

my $x;
say $x + 4, ;  # 4
say 'Foo' . $x . 'Bar' ;  # FooBar

$x++;
say $x; # 1
```

In the above example the variable $x - which is undef by default - acts as 0 in the addition (+).
It acts as the empty string in the concatenation (.) and again as 0 in the auto-increment (++).

It won't be flawless though. If you have asked for the warnings to be enabled with the `use warnings`
statement ([which is always recommended](/installing-perl-and-getting-started))
then you will get two [use of uninitialized value](/use-of-uninitialized-value)
warnings for the first two operations, but not for the auto-increment:

```
Use of uninitialized value $x in addition (+) at ... line 6.
Use of uninitialized value $x in concatenation (.) or string at ... line 7.
```

I think you don't get for the auto-increment as perl is forgiving. Later we'll see that this
is quite convenient in places where you'd like to count things.

You can, of course avoid the warnings by initializing the variable to the correct initial value
(0 or the empty string, depending on what it should be), or by turning warnings off selectively.
We'll discuss that in a separate article.
