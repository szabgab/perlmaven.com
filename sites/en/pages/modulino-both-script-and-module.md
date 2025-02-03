---
title: "Modulino: both script and module in Perl"
timestamp: 2017-12-13T08:30:01
tags:
  - use
  - caller
published: true
author: szabgab
archive: true
---


In the Python world it is quite straight forward to make files work either as executables or as modules.
In Perl it is a bit strange, but doable.

brian d foy has written a number of [articles about Modulinos](https://www.masteringperl.org/category/chapters/modulinos/),
but in nutshell a Modulino is a Perl file that can act both as an executable (a script that you would invoke directly)
or as a module (Something you load into memory and expect to execute code only when you call one of its functions or
methods).


The way to implement this in Perl is to put every executable code inside function and leave only the following statement in the main body of your code:

```perl
main() if not caller();
```

assuming you have a function called `main` that implements the behavior you'd want to see when the file is
executed as a stand-alone script.

Here is an example to demonstrate the concept:

{% include file="examples/modulino.pm" %}

If we run it as a script we will have the following output:

```
$ perl modulino.pm
Hello from main() of modulino.pl
```

If we load it as a module, it will generate no output:

```
$ perl -Mmodulino -e1
```

that's because it will not execute the `main()` function.

However, we can use its functions:

```
$ perl -Mmodulino -e"main()"
Hello from main() of modulino.pl
```

We can also use it inside another script:

{% include file="examples/modulino_user.pl" %}

```
$ perl modulino_user.pl
Hello from main() of modulino.pl
```

## What is this caller ?

To quote from its documentation:

<q>The caller function of Perl returns the context of the current pure perl subroutine call.
In scalar context, returns the caller's package name if there is a caller 
(that is, if we're in a subroutine or "eval" or "require") and the undefined value otherwise.</q>

In other words, when we execute the file directly `caller` returns `undef`, but when
we load it with a `use` statement (which is just a wrapper around `require`) then
it will have some value other than undef. Something [true](/boolean-values-in-perl).

The `caller` function has other uses as well, but for our purposes this is what we need to know about it.

## Modulino with print

In case you'd like to look at another example to see how this works check out this one:

{% include file="examples/modulino_with_print.pm" %}

Here we have an extra print-statement in the main body of the file.

When executing directly we see both lines:

```
$ perl modulino_with_print.pm
Hello from the body of modulino.pl
Hello from main() of modulino.pl
```

When loaded as a module, only the one in the body of the file is executed.

```
$ perl -Mmodulino_with_print  -e1
Hello from the body of modulino.pl
```

BTW, that's one of the reasons it is not recommended to put any code outside of functions. Especially not in modules.

## Modulino in a package

To show yet another case, here we can see that we can use the same trick in a namespace as well:

{% include file="examples/MyModulino.pm" %}

In this case we have our code inside a [package](/search/package).
This is how the output looks like if we try to run it directly:

```
$ perl MyModulino.pm

Hello from main() of modulino.pl
```

We can create a script using the module:

{% include file="examples/use_my_modulino.pl" %}

And this is its output if we run the script:

```
$ perl use_my_modulino.pl

before
Hello from main() of modulino.pl
after
```

If we did not call `MyModulino::hi();` we would only see the "before" and "after" lines.

## Comments

Hi Gabor,
Really appriciate the effort that you r putting to people learn Perl. Awesome :)
Suggestion:
I think this kind of hacks should not be taught as it will create a very difficult read code. We dont want to mimic other programming languages like python which has that capability and I think they did it wrong. Lets teach modern Perl and best practices.

<hr>
Gabor,
What would a use be, for creating a file that could be run as a script and a module. What would the benefit be of creating such a file.

---
One benefit is testability. A module is easier to write unit tests against than an executable script.

<hr>
Neat trick! Thank you for giving me a ton of ideas for my old scripts.

An even more compact way to write it would be

package My::Modulino;

use strict;
use warnings;

sub main {
print "from main\n";
}

main unless caller;
1;

# This way, it will be obvious at the bottom of the file that it is a module that can be called.

---
more compact than that would be
package My::Modulino;

use strict;
use warnings;

sub main {
print "from main\n";
}

caller() ? 1 : main; # or 'caller() or main'

<hr>

worth noting, modulino pattern doesn't work when you PAR Pack your script, you would need to use a line like "main() unless caller() && caller() ne 'PAR'" instead of "main() unless caller()" if you anticipate your script (as a script, not a module) will be packed with PAR

