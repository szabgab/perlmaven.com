---
title: "What does die do?"
timestamp: 2013-07-16T09:50:10
tags:
  - die
published: true
books:
  - beginner
author: szabgab
---


When you want to signal that something went slightly wrong, you call the [warn](/warn) function.

When you want to signal that something went terribly wrong, and you want to throw in the towel, you call `die`.


People reading Perl code are quite familiar with the `die`.
One of the know expression is the `open or die` style code to [open a file](/open-and-read-from-files).

A call to `die` will print out the given string to the [standard error (STDERR)](/stdout-stderr-and-redirection)
and then quit the program.

It has the same extra feature as [warn](/warn) has, that if the string you passed to it does **not** end with
a newline `\n`, perl automatically includes the name of the file and the line number where the `die` was called.

This can help later finding the source of the problem.


## Throwing exceptions

While in simple scripts it usually does not matter, die actually throws an exception.
In simple scripts you probably won't have any special code to catch these exceptions.
In those cases you basically use `die` instead of calling [warn](/warn)
and then [>exit](/how-to-exit-from-perl-script).


In bigger applications, when you start writing modules, you will probably already want
to really throw exceptions, and then capture them using `eval`. We'll deal with
that in another article.

## Collecting die calls

In a slightly more advanced way, Perl provides a signal handle for die, just
as it does for `warn`. The big difference is that the signal handler that
collects the die call does not stop your script from dieing. It is only interesting
in the cases where you already catch the exception (e.g. using `eval`)
and you are interested in finding cases when someone caught an exception,
but did not handle it well.
For those cases see the article about [capturing die calls](/how-to-capture-and-save-warnings-in-perl).


