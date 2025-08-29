---
title: "Package variables and Lexical variables in Perl"
timestamp: 2014-02-11T09:55:01
tags:
  - my
  - state
  - our
  - use vars
  - package
published: true
books:
  - advanced
author: szabgab
---


In Perl there are 3 types of variables differing mostly in the their scoping.

* Lexical variables
* Static or state variables
* Package variables



## Lexical variables

These are the variables used in the vast majority of cases.

A variable declared using the `my` keyword is a **lexical variable**.
It lives from the place where it was declared using the `my` keyword
till the end of the current block. (Pair of curly braces.) This is the `scope`
of the variable.

If it is declared outside of any block, it lives till the end of the file. Its scope
is the whole file starting from the point of declaration.

```perl
my $x;
my @y;
my %z;
```


## Static or state variables

Version [5.10 introduced](/what-is-new-in-perl-5.10--say-defined-or-state) a new keyword called `state`.
Using this keyword will declare a lexical variable, just as `my` does, but it
the variable will be initialized only once.
It is really only interesting in subroutines that are called more than once.
There they behave like [static variables](/static-and-state-variables-in-perl) in some other languages.

```perl
sub f {
   state $x = 0;
   state @z;
   state %h;
}
```

`state` cannot be used in [list context](/scalar-and-list-context-in-perl)
which poses some limitation, but in most case a bit of workaround can solve the problem.
Like in [this example](/static-and-state-variables-in-perl).


## Package variable

These are the oldest type of variables in Perl. They are still used in some cases, even though in most cases you
should just use lexical variables.

In old times, if we started to use a variable without declaring it with the `my` or `state` keywords,
we automatically got a variable in the current namespace.
Thus we could write:

```perl
$x = 42;
print "$x\n";  # 42
```

Please note, we don't `use strict;` in these examples. Even though you should [always use strict](/strict).
We'll fix this in a bit.

The default namespace in every perl script is called "main" and you can always access variables using their full name
including the namespace:

```perl
$x = 42;
print "$x\n";        # 42
print "$main::x\n";  # 42
```

The `package` keyword is used to switch namespaces:

```perl
$x = 42;
print "$x\n";        # 42

print "$main::x\n";  # 42

package Foo;
print "Foo: $x\n";   # Foo:
```

Please note, once we switched to the "Foo" namespace, the `$x` name refers to the variable in the Foo namespace.
It does not have any value yet.

```perl
$x = 42;
print "$x\n";        # 42

print "$main::x\n";  # 42

package Foo;
print "Foo: $x\n";   # Foo:
$x = 23;
print "Foo: $x\n";   # Foo 23;
```

Do we really have two $x-es? Can we reach the $x in the main namespace while we are in the Foo namespace?

```perl
$x = 42;
print "$x\n";              # 42

print "$main::x\n";        # 42

package Foo;
print "Foo: $x\n";         # Foo:
$x = 23;
print "Foo: $x\n";         # Foo 23
print "main: $main::x\n";  # main: 42
print "Foo: $Foo::x\n";    # Foo: 23

package main;

print "main: $main::x\n";  # main: 42
print "Foo: $Foo::x\n";    # Foo: 23
print "$x\n";              # 42
```

We even switched back to the `main` namespace (using `package main;`) and
if you look closely, you can see that while we were already in the main package we could reach 
to the $x of the Foo package using `$Foo::x` but if we accessed `$x` without the full
package name, we reach the one in the main namespace.

Every package (or namespace) can hold variables with the same name.

## use strict - and use explicit package name

As I mentioned, the above code did not `use strict;`. That's because it would require us 
to declare the variables using `my</h> as [explained here](/global-symbol-requires-explicit-package-name).

Actually, if we put `use strict;` at the beginning of the above code, and  we'll get
[Global symbol "$x" requires explicit package name ...](/global-symbol-requires-explicit-package-name).

Try this:

```perl
use strict;

$x = 42;
print "$x\n";
```

Now we might already understand what does that error message really mean. We don't **have to** declare the variables using `my`.
We could use the explicit package name like this:

```perl
use strict;

$main::x = 42;
print "$main::x\n";
```

This will already work and we are using the same package-variable as we did earlier.

We could even access the variable in the `Foo` namespace:

```perl
use strict;

$main::x = 42;
print "$main::x\n";   # 42

$Foo::x = 23;
print "$Foo::x\n";    # 23
print "$main::x\n";   # 42
```

Of course this is going to be really  tiring after a while. Especially if we want to access a package variable
in the current package, we don't want to write down the name of the package again and again:

```perl
use strict;
package VeryLongName;
$VeryLongName::x = 23;
print "VeryLongName: $VeryLongName::x\n";
```

This works, but we don't like to type so much.

## use vars

The problem is that `use strict` is complaining that there is a variable `$x` which is not declared with `my`
and that it does not know about it. So we need a way to tell `strict` that it is ok. We know about the `$x` variable
and we want to use it, but we want it to be a package variable. We don't want to declare it using `my` and we don't want to
always prefix it with the package name.

With `use vars ('$x')` we can achieve that:

```perl
use strict;

package VeryLongName;
use vars ('$x');
$x = 23;
print "VeryLongName: $x\n";
```

This works, but the documentation of `vars` tells us that
**the functionality provided by this pragma has been superseded by "our" declarations**.

So how does `our` work?

## our

```perl
use strict;

package VeryLongName;
our $x = 23;
print "VeryLongName: $x\n";
```


## Caveat

The `our` declaration itself is lexically scoped, meaning it is limited by the file or by enclosing
curly braces. In the next example we don't have curly braces and thus the declaration `our $x = 23;`
will be intact even after switching namespaces. This can lead to very unpleasant situations.
My recommendation is to avoid using `our` (you almost always need to use `my` anyway)
and to put every package in its own file.

```perl
use strict;

package VeryLongName;
our $x = 23;
print "VeryLongName: $x\n"; # VeryLongName: 23

package main;
print "$x\n";  # 23
```

## Comments

Gabor - I'm having problems accessing a hash in the beginning of a program within a subroutine.
my %TK={'title'=>'does not work'};
sub dosomething
{
print join(', ', (keys %TK));
}
only works when I change my to our.
Any other solutions?

---
In this example you never call dosomething. Show a full example please.
---

You're assigning anonymous hash to %TK. Change curly brackets to ordinary parenthesis:

my %TK=('title'=>'does not work');

Or consequently try to use references.


