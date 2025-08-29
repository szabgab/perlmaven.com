---
title: "String-eval in Perl"
timestamp: 2017-11-05T08:30:01
tags:
  - eval
published: true
books:
  - beginner
author: szabgab
archive: true
---


The `eval` keyword in Perl has two very different meanings depending on the syntax around it.
If it is followed by a block as in

```perl
eval {
   ...
}
```

then it is plain exception handling, which is usually called `try` in other languages.
That is the "nice eval".

In this article we are going to discuss the `evil eval`. The one where the `eval`
keywords is followed by a string as in this expression:

```perl
eval "...";
```


## String eval

The common term used for this expression is  **string-eval**, though some people call it
**evil eval**.

It is extremely powerful, and with that great power comes a great risk.

In a nutshell string-eval allows us to compile and execute arbitrary code loaded while our
program is already running.

It can be quite useful in postponing loading of modules. It can help us if we would like
to load a module whose name is constructed while the program is running.
It can also open up our system to major attacks.

## Compile- and run-time

Normally all the code in your Perl file is first compiled by Perl resulting in an internal
data structure that describes what needs to be executed.
Once the compilation has finished the interpreter part of Perl takes over and executes (interprets)
the already compiled code.

String-eval allows use to pause the execution (or run-time) phase, ask the compiler to compile
some more code, then execute that code, and then go back where the main code was paused
and keep running from there.

## Calculator with eval

This is a simple implementation of the [calculator exercise](http://code-maven.com/exercise-calculator)
a very simple use of the string-eval.

{% include file="examples/eval/calc.pl" %}

The user is expected to input two numbers followed by an operator (+-*/)
and then the script calculates the results.

It calculates the result by creating a small perl expression including the two numbers
and the operator between them and the `eval`-ing it.

While this is just a simple expression, this illustrates the point. Perl can take
any arbitrary Perl snippet, even if it is itself a 10,000-line long program,
compile it and run it even if that snippet was not available when the program
started to run.

## Delayed loading of module

One of the most valuable use-case of the string-eval is delaying the loading
of modules. Take for example the case of a large application such as
[an IDE written in Perl](http://padre.perlide.org/).
It has tons of features but any user will only use a subset of the features.
If we load everything every time a user launches the IDE, it will waste a lot of
memory for unused features and it will take a long time to load.

Instead of that, with some additional code, we can delay the loading of most of
the code and only load the module implementing a feature when it is really needed.

Another case is when you write an application that needs to run on multiple
operating systems. You might have a module called App::Win32 that implements
the Windows specific code, an App::Linux for the Linux specific code and
App::OSX to run on Apple OSX.

In this case you might not be able to load all the modules, heck, you might not
be able to install the modules except on the designated operating systems.

For that case you can write code like this:

{% include file="examples/eval/load_on_os.pl" %}

## Evil eval

So why did I call it `evil eval`?

What if the user who provide the input to the calculator above, instead of
typing in 2 numbers and an operator, types in the following:

`system 'rm -rf /'`

The perl script will happily `eval` it, meaning it will try to
remove all the files from your hard disk and if you have other disk mounted
then from there too. Not something you'll like.

With very strong input validation you can of course avoid such problems,
but if there is a bug in the input validation ....

## Conclusion

String-eval is very powerful and its use should be minimal and should
be preceded by strong input validation.

## Alternative

[Module::Runtime](https://metacpan.org/pod/Module::Runtime) is a safer alternative for
delayed loading of modules that does not use string-eval.

