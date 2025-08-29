---
title: "Namespaces and packages in Perl"
timestamp: 2017-01-11T12:00:11
tags:
  - package
  - "::"
types:
  - screencast
published: true
author: szabgab
---


Previously we saw [the problems with Perl 4 libraries](/the-problem-with-libraries). Let's now
see a better solution using Perl 5 namespaces.


<slidecast file="advanced-perl/libraries-and-modules/namespaces" youtube="VdtJqpD2ARA" />

Other language also use namespaces. In Perl 5, in order to switch to another namespace we use the
`package` keyword. (For some more clarification on what namespaces, packages, modules etc. are,
look at [this article](/packages-modules-and-namespace-in-perl).)

We use switch to a new namespace by writing `package` followed by the name of the new namespace.
`Calc` in our example below. Namespaces usually start with a capital letter follower by lower-case letter,
though this is more of a convention than a hard requirement of Perl.

In this script we already have `use strict;` and `use warnings;` because we entered the new milleneum.

Then we have `package Calc;` this means that from this point on, the code we write is in the Calc namespace
until we call `package` again with some other namespace. We load `use strict;` and `use warnings`
again, even though we don't really need them here, but we are planning to move the code of the package into another
file and there we will already want them to be part of the code. Then we add functions. (OK, in this example there
is only a single function that happens to be called `add`, but don't let this minor issue confuse you. You can put
any number of functions inside the namespace.)

The we return to the main package by writing `package main;`.

This is something we have not talked about yet because there was no need for it, but when you start writing a perl
script it is already inside a namespace called `main`. In most of the cases we don't have to do anything with
it, but now it is handy so we can switch back to the namespace of the main script. The name itself is probably a left-over
from the C programming language where you have to declare a function called main in order to have anything running.

Note, it is called `main` with lower-case letters.

So after the `package main;` statement we are back in the main namespace. If we now tried to call the `add`
function `add(3, 4)`, we would get an exception and the script would die with 
**Undefined subroutine &main::add called  at namespaces.pl line 20.**.

That's because we don't have an `add` function in the main namespace. Instead of that we have to write the
fully qualified name of the function, including the namespace as a prefix separated by double-colon:
`Calc::add(3, 4)`

**namespaces.pl**:

```perl
#!/usr/bin/perl
use strict;
use warnings;

package Calc;
use strict;
use warnings;

sub add {
    my $total = 0;
    $total += $_ for (@_);
    return $total;
}


package main;

print Calc::add(3, 4), "\n";
```

That's how you use `package` and that's how you create namespaces in Perl 5.

## Comments

I don't understand what "namespace" means in Perl. I would expect names in one package to be distinct from names in another Why does Perl warn that the declaration of $debug in package main masks the declaration of $debug in package Test?


use v5.16;
use strict;
use warnings;

package Test;
my $debug = 5;
print("$debug\n");

package main;
my $debug = 10;
print("$debug\n");

---

Hi, the reason you get warning is because the variables defined using keyword my do not belong to the "symbol table" of that package. So even when you define them under differnt package, perl does not treat them as belonging to differnt namespace. Replace the my with our keyword, and now it really belongs to different namespace and perl won't complain :-)

use v5.16;
use strict;
use warnings;

package Test;
our $debug = 5;
print("$debug\n");

package main;
our $debug = 10;
print("$debug\n");
