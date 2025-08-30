---
title: "Reverse Polish Calculator in Perl using a stack"
timestamp: 2015-10-23T13:30:01
tags:
  - pop
  - push
published: true
books:
  - beginner
author: szabgab
archive: true
---


When writing arithmetic expressions we are used to write them **infix**:
`3 + 4`. That is, we write the operator between the two operands.

In the so-called [Polish Notation](http://en.wikipedia.org/wiki/Polish_notation)
the operator is written before the operands: `+ 3 4`.

Consequently in the [Reverse Polish Notation](http://en.wikipedia.org/wiki/Reverse_Polish_notation)
the operator comes after the operands: `3 4 +`.

Why is this interesting? You might ask.


In order to compute the expression `3 + 4 * 2` correctly we need to
know the **precedence** rules.
In this case that multiplication should be executed before addition.
This gives 11.

In case of the `8 - 4 - 2` expression, we  need to know the rules of **associativity**,
In this case that negation is left associative, that we have to execute the left-most operation first and only then the right operation.
This gives 2.

If we want to implement this in software or hardware, we need to work hard.

In case of the Reverse Polish Notation (RPN), once you wrote the expression,
it has no ambiguity at all. RPN has no other rule than
"Every operator works on the last two numbers".

The above two expression written in RPN are `3 4 2 * +` and
`8 4 - 2 -` respectively.

It is much easier to implement a Reverse Polish Calculator than and infix calculator.

It is also a very common example when showing how `stacks` work. We too, will
use a stack and the corresponding operations `pop` and `push`.

Let's see a simple implementation of it:

{% include file="examples/rpn.pl" %}

We start the code with the regular boiler-plate code of 
the sh-bang and the safety net.

Then we create the array that we'll use as our stack
and set up a nice infinite loop using `while (1)`.
This is the body of the calculator.

We present a prompt `$ `
get the input from the user `my $in = &lt;STDIN>;`
and remove the trailing new-line with `chomp $in;`.

Then we check what the input was.

This is done every time the user hits ENTER, unless they enter special meta-commands.

If the user pressed 'q' we leave the loop by calling `last` and that will end our script as well.

Pressing 'c' removes the last thing from the stack and throws it away. This works like "Clear" on the calculators.

Then there are 4 if-statements. Each one checks if the input was one of the regular operators.
In each case we retrieve the last two values pushed onto the stack, execute the appropriate operation,
and push the result back to the stack.

The last if-statement checks if the user has entered '=' and, if so, retrieves the last value placed on the
stack and displays it.

Any other value is assumed to be a number that needs to be placed on the stack.
That's what the last call to `push @stack, $in;` does.

You can download the script and run it as `perl rpn.pl`:

```
$ 8
$ 4
$ -
$ 2
$ -
$ =
2
$ 
$ q
```

## Using case / switch / given / when

Perl does not have a `case` or `switch` statement, but
starting from version 5.10 that was released in 2007, it provides the `given` and `when` statements.
This pair provides similar features to the `case` or `switch` statements of other languages, with some differences.
Unfortunately the exact behavior of these statements has changed between releases of Perl and in 5.18 this feature was marked
as "experimental" and started to generate warnings.

Nevertheless, let me include here a solution using the `given` and `when` statements:

{% include file="examples/rpn_given.pl" %}

## Problems

If you try either of these scripts with different input you might quickly notice that there are quite a few issue
because we don't check the input beyond those 5 specific cases. (The 4 operators and the equal sign.)

## Exercise

Several ideas how to improve this:

1. Add option **l** printing the size of the stack (number of elements in it).
1. Add option **h** to display help, listing all the options.
1. Check if the value given is really a number. Only accept numbers, warn if some other value is given.
1. Add option **?** showing the same help as h does.
1. Change the **q** options so it will check if there are any values left on the stack. If there are, tell the user about it and ask if she really wants to Quit?
1. Implement **C** to clear all the stack.
1. Add option **s** printing the whole stack.
1. Add an option **x** for exit that will not ask any questions, just exit the loop.
