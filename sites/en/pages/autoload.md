---
title: "AUTOLOAD - handling Undefined subroutines"
timestamp: 2015-10-07T23:30:01
tags:
  - AUTOLOAD
published: true
books:
  - advanced
author: szabgab
archive: true
---


Normally, if you call a function that does not exist perl will throw an exception <b>Undefined subroutine ... called</b>,
however, unlike in most of the other languages you can define a default function to be called, instead of throwing
that exception. This can give us all kinds of interesting solutions.

Unlike Java, C and similar languages, Perl cannot know at compile time if a function 
is going to exist when it is called. Well, actually Perl cannot even know which functions
are going to be called in a given piece of code.
Anyway this means that at run time it might happen that a none-existent function is called.
In such cases normally Perl will die.


Let's see a simple, and not very interesting example:

{% include file="examples/greeting.pl" %}

If we run this script, we'll see the following output:

```
Hi
Undefined subroutine &main::welcome called at greeting.pl line 7.
```

We can see here that the statement before calling the `welcome()` function was executed, but
the statement after the function call not. The call to a non-existent function got perl to throw an exception.

## AUTOLOAD in the script

Let's change that script and add a subroutine called `AUTOLOAD` to it.

{% include file="examples/greeting_autoload.pl" %}

Actually the entry could be written either as `sub AUTOLOAD { ... }`, but as a special case, 
we could also leave out the `sub` keyword and write only `AUTOLOAD { ... }`.

In any case, if we run this script now, we are going to see the following output:

```
Hi
main::welcome
$VAR1 = [
          'Foo',
          'Bar'
        ];

Bye
```

Here we can see the output of both `say` statements, the one before and the one after the call to the
`welcome()` function. In between we can see the output of the `AUTOLOAD` function which includes
the content of the `$AUTOLOAD` variable which is the name of the function that was called, and the
content of `@_` which is the list of parameters the user passed to the `welcome` function.
This is exactly the same content as `welcome()` would have seen, if it existed.

The `$AUTOLOAD` variable is a bit strange. We need to declare it or we will get a
[Global symbol "$AUTOLOAD" requires explicit package name](/global-symbol-requires-explicit-package-name) error,
but we need to declare it using `our` and not by using `my` in order to let perl fill it.

Then the content of this variable is the "fully-qualified name" of the function that was called, meaning
that it also includes the [namespace](/packages-modules-and-namespace-in-perl) of the function.
In our case, because the function was supposed to be in the main script we executed, the namespace is `main`.
Hence `$AUTOLOAD` contains `main::welcome`.

In a nutshell:
If during the execution of a script perl encounters a call to a function that does not exist, it
checks if there is a function called `AUTOLOAD`, and executes that function passing the exact
same parameters and setting the variable `$AUTOLOAD` to the fully qualified name of the function.


## AUTOLOAD in object oriented code

To further understand the process. If a method "foo" is called on an object. Perl will first try
to locate the method in the package where the object was blessed into. If not found it will
traverse the inheritance tree of the class to look for the "foo" method. If it still does not
find the method it will check if there is an AUTOLOAD method. It will employ the same algorithm
to locate the first AUTOLOAD as it did with the name of the method. If no AUTOLOAD found in any of the
parent classes only then will perl throw an exception.

The script:

{% include file="examples/greeting_oop.pl" %}

The module that employs `AUTOLOAD` using [classic OOP](/getting-started-with-classic-perl-oop):

{% include file="examples/Greeting.pm" %}

And the output of running `perl greeting_oop.pl`:

```
Hi
Greeting::welcome
$VAR1 = [
          bless( {}, 'Greeting' ),
          'Foo',
          'Bar'
        ];
Bye
```

In this case the variable `$AUTOLOAD` contains `Greeting::welcome`, because the function
that was supposed to be called was caught by the `AUTOLOAD` in the `Greeting` module.
The content of `@_` is slightly different too. The first parameter is the object that was stored
in the `$g` variable in the script, just as it would happen with the `welcome` method
if it was implemented in the `Greeting` class.

In Object Oriented code the `AUTOLOAD` function would probably written like this:

```perl
sub AUTOLOAD {
    my ($self, @params) = @_;
    ...
}
```

assigning the current instant to the variable called `$self`.
## AUTOLOAD use-cases

Instead of [creating subroutines](/creating-subroutines-on-the-fly-using-symbolic-references) when
the script is started, we could employ `AUTOLOAD` to capture the call to these optional functions.
Check if the function that was called is one of the expected function 

When writing an application we can write the skeleton of the algorithm calling various functions. Instead of slowing down
our thinking about the main code, by implementing those functions, we can use  a catch-all `AUTOLOAD`
to print out the names of the functions being called and letting us execute our code.

This can be especially useful in a GUI application where someone creates the GUI and designates event handlers for various
events without implementing them first. Then if we try to demo the application it would crash on every user-action.
Instead of that we can add a catch-all `AUTOLOAD` that will display a pop-up "Not yet implemented", or silently
ignore the user action. Once the demo is done we can start implementing the event handles one-by-one.

## use strict or warnings?

Although we have linked this article from the [Common Warnings and Error messages in Perl](/common-warnings-and-error-messages)
page, and we use both `use strict` and `use warnings` in the examples as it is a 
[recommended best practice in Perl](/always-use-strict-and-use-warnings), 
this error has nothing to do with either of those.


## Comments

If Autoload calls a function in a different package, what namespace is it executed in? I want to avoid repeating a "decode" function in 10 modules by putting it into a common module. Each of the 10 modules has the same variable names, I want the decode function to use the current package variables.

---

Show your code please!

<hr>

How about some discussion regarding the Symbol Table somewhere, Gabor?
I often 'overload' the Autoload method and stick it into the Symbol Table so no subsequent lookups are made for the Autoload method.
The following is a definition of AUTOLOAD and DESTROY where AUTOLOAD is used to handle any get_x() calls regarding the object in question and the Symbol Table for the AUTOLOAD namespace is redirected to the 'private' _accessible() method.

sub new {
my $class = shift;
my ($pre, $match, $post, $result) = splice @_, -4;
bless {
_pre => $pre,
_match => $match,
_post => $post,
_result => $result,
_subpatterns => [@_]
}, ref($class) || $class;
sub _accessible() { exists $_[0]->{$1} }
}

use vars '$AUTOLOAD', '$DESTROY';

sub AUTOLOAD
{
no strict "refs";
my ($self) = @_;

# was it a 'get()' call? is the attribute accessible?
if ($AUTOLOAD =~ /.*::get(_\w+)/ and $self->_accessible($1) )
{
# get locally scoped, scalar copy ($attr_name) of $1
my $attr_name = $1;
# can't use '$self' in 'sub' return call, since
# it's outside the scope of subsequent 'get' calls;
# the first 'get' call would work as expected, but
# subsequent 'get' calls use the changed symbol table's
# anonymous sub-routine
#
# cram the anonymous sub-routine into the symbol
# table, use it after the first call to a 'get_xxx()' method
*$AUTOLOAD = sub { return $_[0]->{$attr_name} };
return $self->{$attr_name};
}
return "Match::AUTOLOAD : Not a 'get' call or attribute doesn't exist.";
}

DESTROY{}


