---
title: "Exception handling in Perl: How to deal with fatal errors in external modules"
timestamp: 2017-04-16T13:30:01
tags:
  - eval
  - $@
  - Time::Piece
  - do
published: true
books:
  - advanced
author: szabgab
archive: true
---


Originally the accepted way in Perl to signal an error was to return
[undef](/undef-and-defined-in-perl) and let the users of the function or module
decide what they want to do with it. If they even look at it.

In other languages throwing an exception is the standard way to signal an error.

Some of the Perl modules on CPAN follow the "return undef" path, others will throw an exception.
The question how to deal with that?


## Parse dates

In this example we use the [Time::Piece](https://metacpan.org/pod/Time::Piece) module
to parse strings represent dates. The `strptime` method accept a string representing
a date and a format string using `strptime` formatting instructions. It then tries to parse the
string according to the formatting instructions. In our example the formatting instructions
`"%d %b, %Y"` mean we are expecting to have a number representing the days, followed
by a string representing the month (e.g. 'Nov'), and then a 4-digit number representing the year.

{% include file="examples/time_piece.pl" %}

If we run this code we'll see the following output:

```
$ perl examples/time_piece.pl
Fri Nov  3 00:00:00 1989
Error parsing time at .../Time/Piece.pm line 469.
```

What happened here is that we tried to parse 3 strings, but the 2nd string was incorrectly formatted.
The `strptime` method raised an exception to indicate this failure (probably by calling `die`)
that caused our script to die.

## Catch the exception using eval

While there are other ways to handle exceptions using, for example
[Try::Tiny](https://metacpan.org/pod/Try::Tiny), in this case we look
at the built-in `eval` statement.

If we wrap a piece of code in an `eval` block, the eval will capture any exception that might
happen within that block, and it will assign the error message to the `$@` variable of Perl.

The simple way to do this looks like this:

(please note, there is a `;` after the `eval` block.)

```perl
eval {
     # code that might throw exception
};
if ($@) {
    # report the exception and do something about it
}
```

A more robust way to write this looks like this:

```perl
eval {
     # code that might throw exception
     1;  # always return true to indicate success
}
or do {
    # this block executes if eval did not return true (because of an exception)

    # save the exception and use 'Unknown failure' if the content of $@ was already
    # removed
    my $error = $@ || 'Unknown failure';

    # report the exception and do something about it
};
```

Here too, there is a trailing `;`, but it is only after the `do` block.

## Error handling for Time::Piece

We used the `eval or do` expression we have just seen.
In this solution we have both the creation of `$tp`
and its use inside the `eval` block. That's because if we cannot parse
the date-string then there is no point in trying to us that variable.

{% include file="examples/time_piece_eval.pl" %}


If we run this script we'll get the following:

```
Fri Nov  3 00:00:00 1989
Could not parse 'Nov, 1989' - Error parsing time at .../Time/Piece.pm line 469.
Fri Jan  1 00:00:00 1999
```

This means, that although the second string could not parse and Time::Piece raised
an exception, we captured that exception, reported it and then let the `foreach`
loop go on to the third value that was properly parsed and printed.

## Comments

That's cool, but can you also capture undef somehow in an eval or do block?

---
Nope. If some function returns undef on failure then you need to either check that manually or convert it to an exception with the "f() or die" construct that you probably have seen in the "open ... or die" case.

<hr>
I'm not a fan of functions that return undef rather than just using a bare return, for the reasons explained in Perl::Critic::Policy::Subroutines::ProhibitExplicitReturnUndef  https://metacpan.org/pod/Perl::Critic::Policy::Subroutines::ProhibitExplicitReturnUndef


<hr>

The second structure of catching an error is described as 'more robust'. In what way is it superior to the first method?

---
In my opinion the second approach is more robust in the sense that it's a whole code block that takes care of everything you cared about (execution and exception handling). Whereas the first approach separates the eval and the action upon a detected exception in an independent code block, hence possibly leading to dismember the two things, for example, when doing some maintenance or refactoring. It's really dependent on what you want to handle the execution and the mitigation: separatedly or together.

---
Spot on, Carlaanga. When you separate your eval from your exception handling, as is the case in the first example, and if, as you said, the eval and the exception handler get separated, it's possible for $@ to get "clobbered", which is to say overwritten by another eval block somewhere. That's why I almost always use the "more robust" construction.

<hr>

There are also a number of try-catch implementations in perl.

One that implements all the features you would expect is Nice::Try, such as:

try
{
  # Something worth dying
}
catch( Exception $e )
{
  # catch exception of class Exception
}
catch( $e )
{
  return( "I failed: $e" );
}
finally
{
  # Do some mop up
}

