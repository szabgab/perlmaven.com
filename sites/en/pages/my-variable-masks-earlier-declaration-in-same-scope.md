---
title: "'my' variable masks earlier declaration in same scope"
timestamp: 2013-04-19T16:46:56
tags:
  - my
  - scope
published: true
books:
  - beginner
author: szabgab
---


This compile-time warning will show up if, by mistake, you tried to declare
the same variable twice within the same scope.

```
"my" variable ... masks earlier declaration in same scope at ... line ...
```

How can this happen, and how does re-declaring variables in every iteration of a loop work?

If I cannot write `my $x` twice in a scope, then how can I empty that variable?


Let's see the differences between the following few cases:

## Plain script

```perl
use strict;
use warnings;

my $x = 'this';
my $z = rand();
my $x = 'that';
print "OK\n";
```

In this case I get the following compile-time warning:

```
"my" variable $x masks earlier declaration in same scope at ... line 7. )
```

You know it is only a warning, because running the script will also print "OK".


## Block in conditional statement

```perl
use strict;
use warnings;

my $z = 1;
if (1) {
    my $x = 'this';
    my $z = rand();
    my $x = 'that';
}
```

This generates the following warning:

```
"my" variable $x masks earlier declaration in same scope at ... line 7.
```

In both of these cases, we declared `$x` twice in the same scope,
which will generate a compile time warning.

In the second example we declare `$z` twice as well, but it did not
generate any warning. That's because the `$z` inside the block
is in a separate [scope](/scope-of-variables-in-perl).

## The scope of a function

Same code, but in a function:

```perl
use strict;
use warnings;

sub f {
    my $x = 'this';
    my $z = rand();
    my $x = 'that';
}
f(1);
f(2);
```

Here too, you get the same compile-time warning (once) for the `$x` variable.
Even though the variable `$z` will 'spring to existence' repeatedly,
once for every call of the function.
This is OK. The `$z` variable does not generate the warning:
Perl can create the same variable twice, it is only you who are not supposed to do it.
At least not within the same scope.

## The scope of a for loop

Same code, but in a loop:

```perl
use strict;
use warnings;

for (1 .. 10) {
    my $x = 'this';
    my $z = rand();
    my $x = 'that';
}
```

This too will generate the above warning for `$x` once(!), but won't generate
any warning for `$z`.

In this code the same thing happens for **every** iteration:
Perl will allocate the memory for `$z` variable for every iteration.

## What does "my" really mean?

The meaning of `my $x` is that you tell Perl, and specifically to `strict`,
that you would like to use a private variable called **$x** in the [current scope](/scope-of-variables-in-perl).
Without this, Perl will look for a declaration in the upper scopes and if
it cannot find a declaration anywhere it will give a compile-time error
[Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name)
Every entry in a block, every call to a function, every iteration in a loop is a new world.

On the other hand, writing `my $x` twice in the same scope just means that you try to tell the same
thing twice to Perl. It is not necessary and usually it means there is a mistake somewhere.

In other words, the warning we got is related to the **compilation** of the code and not the running.
It is related to the declaration of the variable by the developer and not to the memory-allocation
done by Perl during run-time.

## How to empty an existing variable?

So if we cannot write `my $x;` twice in the same scope, then how can we set the variable to be "empty"?

First of all, if a variable is declared inside a scope, that is, inside ant curly braces, then it will automatically
disappear when the execution leaves the [scope](/scope-of-variables-in-perl).

If you just want to "empty" the scalar variable in the current scope, set it to `undef`,
and if it is an [array or a hash](/undef-on-perl-arrays-and-hashes), then empty them by assigning an empty list to them:

```perl
$x = undef;
@a = ();
%h = ();
```

So just to clarify. "my" tells Perl you'd like to use a variable.
When Perl reaches the code where you have "my variable" it allocates memory for the variable and its content.
When Perl reaches the code `$x = undef;`  or  `@x = ();`  or  `undef @x;` it will
remove the content of the already existing variable.


