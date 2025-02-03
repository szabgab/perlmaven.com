---
title: "Subroutines and functions in Perl"
timestamp: 2013-04-13T22:34:56
tags:
  - sub
  - return
  - subroutine
  - function
  - @_
  - $_[0]
published: true
books:
  - beginner
author: szabgab
---


The simplest way for reusing code is building subroutines.

They allow executing the same code in several places in your application,
and they allow it to be executed with different parameters.


In some languages there is a distinction between functions and subroutines.
In Perl there is only one thing. It is created with the `sub` keyword,
and it always returns a value. Perl programmers often use the two words
<b>function</b> and <b>subroutine</b> interchangeably.

## Simple function

For example, let's say you'd like to prompt the user
and ask a question:

{% include file="examples/simple_question.pl" %}

In the first part of the code we called the `ask_question` function twice,
and also called the `get_answer` function twice. In the second part of the code,
after the #####, we have the declaration of three subroutines.

The first one is very simple. It only prints a hard coded string to he screen,
and then returns nothing.

The second combines the read-line operator and `chomp` into a single function call.
It will wait for some input, and upon pressing ENTER it will return the string you
typed in without the trailing newline.

The third one is again very simple, but it is never called in the code and thus it
is never executed. That's an important point for people not familiar with
functions and subroutines. Their code - regardless of their location in the
file - only gets executed when they are "<b>called</b>" using their name.
Just as we called the other two functions.


In each case, well except of the last one, we called the `return` function of
Perl to return a value. In fact the function would return some value even if we did not
explicitly added a call to `return`, but it is strongly recommended to always call
`return`. Even if we don't have anything special to return such as in the case of
the `ask_question()` function.

## prompt

It would be probably much more interesting to combine the two functions so you could write:

{% include file="examples/a_prompt.pl" %}

Of course in each situations you might want the `prompt()` function to display some unique text.
So probably you'd want to be able to set the text of the prompt where you call the `prompt()`
function. Something like this:

{% include file="examples/prompt_with_text.pl" %}

In this example we called the prompt() function twice.
In each case we passed a string that is the text of the
question we are asking. It was printed. The response collected
by the sub and returned to the caller.

The new thing in this example is the way we passed the parameter.
Even more interesting how the subroutine accepted it.

When you call a subroutine you can pass any number of arguments to that subroutine,
and the values will be placed in the internal `@_` variable. This variable
belongs to the current subroutine. Each subroutine has its own `@_`.
You could access its elements just as you do with any other array `$_[0]`
being the first element, but that's not very nice.

It is usually better to copy the values of `@_` using a list assignment
to internal variables. That is what we did in the above example
with `my ($text) = @_;`.

A common error here is leaving out the parentheses in the assignment.

```perl
sub prompt {
   my $text = @_;    # BAD! this is not what you want!!!
   ...
}
```

This will place the array in SCALAR context and in that context it will
return the number of elements. So you'll get a number in the $text variable.
If this whole context business isn't clear, you can read more about
[SCALAR and LIST context](/scalar-and-list-context-in-perl)
and get back to here later.

## Prototypes

Certain languages allow or even require you to create "prototypes" before creating
the actual subroutine.

No prototypes are needed in Perl.

Actually, there is something called prototypes available in Perl,
but they don't do what you might expect, and I don't recommend their usage.
Certainly not for beginners.
There are very few cases when those prototypes in Perl are useful.

## Parameters or signature

In Perl 5 you don't need or can declare the <b>signature</b> of a function.

That is, you cannot declare the list of expected parameters. This also means
that you won't get any parameter checking from the language.
There are several modules on CPAN that help creating something that resembles signature.
You are welcome to experiment with those.

```perl
sub do_something() {    # BAD !
}
```

You should not write parentheses after the name of the subroutine when
declaring it! Though you can use the parentheses when calling a function:

## Parentheses

Using parenthesis `()` after the function name when you are calling
a function is optional if the subroutine has been already defined,
and if it is clear what you mean.
So if you load a module via a `use` statement, and it imports a
function, you can use that in your code without parentheses.

OTOH if you put your function definitions at the end of the script -
and I recommend you to do that - then you need to put parentheses
when you are calling the function.

## Return values

Perl functions always return a value.

Either explicitly by calling `return`, or implicitly the
result of the last statement will be returned.
It is recommended to always use explicit call to `return`.

There is even [Perl::Critic](http://perlcritic.com/) policy that will
check your code and point out every function that does not have an explicit return call
at the end of the function declaration.

If there is nothing to return just call `return;` without any argument.
That will ensure that you really return nothing, and not the result of the
last statement.This will eliminate some surprises for the users of this function.

## Comments

Why not use parenthesis in a subroutine definition?

<hr>

Your example

sub prompt {
my ($text) = @_;
...

does not work when I feed prompt two strings: prompt("First","Name"). It does not print the expected prompt.

This does work (no idea if it has disadvantages, I came here for a reason ...):

sub prompt2{
my @text = @_; #we could simply use @_ here
print join " ",@text;


