---
title: "Packages, modules, distributions, and namespaces in Perl"
timestamp: 2014-02-17T21:50:01
tags:
  - package
published: true
books:
  - advanced
author: szabgab
---


Seasoned Perl developers freely use words such as `package`, `module`, `distribution`, `symbol-table`,
`release`, and `namespace`.
Sometimes interchangeably.
Sometimes slightly blurring the differences between the words.
This can easily create confusion. Especially among people who have less than 10 years experience with Perl.

Let's try to clear that confusion.


Quick explanation:

* **release** usually refers to a zipped file (tar.gz or zip) file uploaded to CPAN (via PAUSE) for example: Some-Thing-1.01.ta.gz
* **distribution** sometimes refers to the same thing as a **release**, in other cases it can refer to all the Some-Thing releases, regardless of their version number.
* **namespace** is a container of identifiers (variables, functions). A namespace would be Some::Thing.
* **symbol-table** is the place where the identifier of a namespace are stored. Basically we can think of a **symbol-table** as being equivalent to <b>namespace</b>.
* **package** is a keyword of Perl that switches to a new namespace. Sometimes people refer to a particular **release** or a <b>distribution</b> as being a <b>package</b>,
       but that only happens because when we zip up several files of a **release** we often think about the English word **package**.
* **module** is the name of a package (namespace) that is kept in a file derived from its name. (a package/namespace called Some::Thing kept in a file called Some/Thing.pm is called a module.
      Unfortunately when we say "module" we often refer to a whole distribution.

## Details

Every piece of Perl code is in a namespace. When we run a simple script like this:

```perl
use warnings;

$x = 2;
$
```

We will get a warning [Name "main::x" used only once: possible typo at ... line ...](/name-used-only-once-possible-typo).

The `main` in that warning is the namespace of the current script and thus the current variables. It is there implicitly.
We did not need to write anything and we were already in the `main` namespace.

Of course we know we should [always use strict](/strict), and so we add it to the code:

```perl
use strict;
use warnings;

$x = 2;
```

Now we get the following error: [Global symbol "$x" requires explicit package name at ... line ...](/global-symbol-requires-explicit-package-name).
Here the error mentioned the word `package`. This error usually indicates that we forgot to declare the variable with `my`, but the actual
error message indicates something else. For historical reasons, the error points out another way to use a variable: by providing the name of the package
(the namespace) it resides in.

This works:

```perl
use strict;
use warnings;

$main::x = 42;
print "$main::x\n";  # 42
```


```perl
use strict;
use warnings;

my $x = 23;
$main::x = 42;

print "$main::x\n";  # 42
print "$x\n";        # 23
```

This is very confusing. There are now two variables that seem to be called `$x`, but they are actually
two different variables. `$main:x` is a [package variable](/package-variables-and-lexical-variables-in-perl)
and `$x` is a [lexical variable](/package-variables-and-lexical-variables-in-perl).

In most cases we will use lexical variables declared with `my` and use namespaces only to separate functions.

## Switching namespace using the package keyword - functions

```perl
use strict;
use warnings;
use 5.010;

sub hi {
    return "main";
}

package Foo;

sub hi {
    return "Foo";
}

say main::hi();   # main
say Foo::hi();    # Foo
say hi();         # Foo

package main;

say main::hi();   # main
say Foo::hi();    # Foo
say hi();         # main
```

In this code we used the `package` keyword to switch from the default `main` namespace to the `Foo` namespace.
We declared the `hi()` function in both namespaces. Each function returns the name of its own namespace.

Then we called them x x 3 times. When the full names were provided the output was consistent with the full name of the function:
`main::hi()` always returns "main", and `Foo::hi()` always returns "Foo". When called `hi()` without the
namespace prefix, it called the function that was local to the current namespace. The first time we called `hi()` we were
in the "Foo" namespace and so it returned "Foo". Then we switched back to the "main" namespace using `package main;` and
then the call to `hi()` returned "main".

## Namespace (package) and modules

While we can use the `package` keyword as many times as we want in a single file, thus creating lots of namespaces
it usually creates confusion. It is not a recommended practice. (Only use it in special cases.)

There is even a [Perl::Critic](https://metacpan.org/pod/Perl::Critic) policy called
[Modules::ProhibitMultiplePackages](https://metacpan.org/pod/Perl::Critic::Policy::Modules::ProhibitMultiplePackages)
that can help us catch such cases. Use the following:

```
$ perlcritic --single-policy Modules::ProhibitMultiplePackages script.pl 
Multiple "package" declarations at line 19, column 1.  Limit to one per file.  (Severity: 4)
```

Read more on how to check for [one policy violation at a time](/perl-critic-one-policy).

We could move the code of the **Foo** namespace to a file called foo.pl and load it using `require`, but it is very old-school
and we will have to give the path to the file.
It is much better to put the code of the **Foo** namespace into a file called `Foo.pm`.

The main script then will look like this:

```perl
use strict;
use warnings;
use 5.010;

sub hi {
    return "main";
}

use Foo;

say main::hi();   # main
say Foo::hi();    # Foo
say hi();         # main
```

Foo.pm will look like this:

```perl
package Foo;
use strict;
use warnings;
use 5.010;

sub hi {
    return "Foo";
}

say main::hi();   # main
say Foo::hi();    # Foo
say hi();         # Foo

1;
```

Please note, we added a `use Foo;` statement to the main script (after the sub hi declaration),
we added the usual use-statement to the top of the Foo.pm, and we also added `1;` at the end of the Foo.pm file.

The Foo.pm file defining the Foo `namespace` using the `package` keyword is called a `module`.

## Caveat

In order for the `use Foo;` statement to find the Foo.pm file we have to make sure it is in one of the directories
in `@INC`. The simplest thing is to put Foo.pm in the `current working directory`, the same directory
where we are when we run the script. Otherwise we will get
an [Can't locate Foo.pm in @INC (you may need to install the Foo module) (@INC contains: ...](/cant-locate-in-inc)
error and we'll need to
[change @INC](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations).

In this slightly contrived example the `use Foo;` statement needs to come after the `sub hi` declaration in
the main script as the call to `main::hi()` inside Foo.pm will be executed when the file is loaded.
If we had the `use` statement before the `sub hi` statement we would get a run-time exception:

```
Undefined subroutine &main::hi called at Foo.pm line 10.
Compilation failed in require at script.pl line 5.
BEGIN failed--compilation aborted at script.pl line 5.
```

