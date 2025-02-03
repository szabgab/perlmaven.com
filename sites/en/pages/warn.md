---
title: "Warning when something goes wrong"
timestamp: 2013-07-09T09:01:01
tags:
  - warn
  - STDERR
published: true
books:
  - beginner
author: szabgab
---


When something goes slightly wrong in your script/program/application, it is customary to warn
the user about the issue. In command line script this is normally done by printing
a warning message to the [Standard Error channel](/stdout-stderr-and-redirection).


As explained in the article about the [standard output and error](/stdout-stderr-and-redirection),
in Perl you can do it by printing to `STDERR`

```perl
print STDERR "Slight problem here...\n";
```

There is a better, more standard way though, you could just call
the `warn` function:

```perl
warn "Slight problem here.\n";
```

It is shorter, more expressive and in the above form has the same effect.

In both cases the script, after printing the warning message, will keep running!

It provides more though.  If you leave out the trailing new-line (the `\n` at the end):

```perl
warn "Slight problem here.";
```

then the output will include the name of the file and the line number,
where the `warn` function was called:

```
Slight problem here. at programming.pl line 5.
```

This can be very useful when you have a script that runs a lot of other scripts,
or when you have a bigger application with many modules.
This will make it much easier for you, or for the user of your program,
to track down the source of the problem.

## Catching warnings

There is even more.

Perl introduced a special signal-handle for warnings.
This means you, or someone else, can later add code to the program that
[captures all the warnings](/how-to-capture-and-save-warnings-in-perl).
This is a bit more advanced topic though, but if you are interested go ahead,
check out that page.

## warning

A slight warning here. You might encounter cases when a warning called after
a print statement shows up before the content of the print statement:

This code:

```perl
print "before";
warn "Slight problem here.\n";
print STDERR "More problems.\n";
print "after";
```

generating this output:

```
Slight problem here.
More problems.
beforeafter
```

Where the word "before" appears after both warning messages.

In that case read about [buffering](/stdout-stderr-and-redirection#buffering).

