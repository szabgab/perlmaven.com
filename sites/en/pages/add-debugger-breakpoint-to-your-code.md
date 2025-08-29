---
title: "Add (conditional) debugger breakpoints to your code"
timestamp: 2019-05-06T13:30:01
tags:
  - -d
  - $DB::single
published: true
author: szabgab
archive: true
---


In most programming language and most programming environments when you would like to debug some code, you can use an
external tool, a debugger, to try to locate problems in your code. This debugger is usually part of an IDE.

With Perl you could use the "build-in" debugger that comes with Perl via the `-d` flag. See for
example [how to debug Perl scripts](/beginner-perl-maven-debugging)

These external debuggers, including the one that comes with perl allow you to set **breakpoints** in the code
where the execution will stop so you can look around the code and the values of the variables.

Perl allows you to save these breakpoints in your code using the `$DB::single` variable.


## Inserting conditional breakpoint in a complex application

This isn't a really good example because Fibonacci is too simple a case, but imagine that you have a complex and
long running application that you'd like to debug.

If you insert the following statement in your code, then when your code is executed using th e built in debugger,
it will automatically stop right after executing that assignment.

```
$DB::single = 1;
```

Actually you can do even more interesting thing, you can make that assignment conditional, for example like this:

```
$DB::single = 1 if $n == 6;
```

That will allow to stop the execution of a function only on certain parameters, or the execution of a loop when
you have had a certain number of iterations.


In a simple Fibonacci function it could look like this.

{% include file="examples/fibonacci_with_breakpoint.pl" %}

You can run this code with any paraamter and that special assignment will have no effect.

```
perl fibonacci_with_breakpoint.pl 3
2

perl fibonacci_with_breakpoint.pl 7
13
```


## Use the debugger


```
perl -d fibonacci_with_breakpoint.pl 3
```

{% include file="examples/fibonacci_with_breakpoint_1.txt" %}

You type in **c** at this prompt to tell the debugger to "continue" to the first breakpoint.

As the condition of the breakpoint setting is never met the code will run till the end printing the result
and then another prompt:

{% include file="examples/fibonacci_with_breakpoint_2.txt" %}

Here you can type **q** to quit the debugger.


In the second attempt we run the code with a larger input number:

```
perl -d fibonacci_with_breakpoint.pl 7
```


We get the first out put and the prompt:

{% include file="examples/fibonacci_with_breakpoint_1.txt" %}

If we type **c** here it will continue to run till it encounters the conditional breakpoint and show this:

{% include file="examples/fibonacci_with_breakpoint_3.txt" %}

At this point we can start using all the other commands of the debugger to look around and explore the situation.


BTW if you are curious what is that `no warnings` statement, it tells perl
to avoid printing the [Name "DB::single" used only once: possible typo at](/name-used-only-once-possible-typo) warning.

See the full list of [warnings](https://metacpan.org/pod/warnings).


See also [how to debug compile-time code](/debugging-compile-time-code).


