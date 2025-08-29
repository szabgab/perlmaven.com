---
title: "Debugging Perl scripts"
timestamp: 2013-03-07T19:45:57
tags:
  - -d
  - Data::Dumper
  - print
  - debug
  - debugging
  - $VAR1
  - $VAR2
published: true
books:
  - beginner
author: szabgab
---


When I studied computer sciences in the university, we learned a lot on how to write programs,
but as far as I remember no one told us about debugging. We heard about the nice world of creating
new things, but no one told us that most of the time we'll have to spend trying to understand other
people's code.

It turns out that while we mostly cherish writing the program, we spend
a lot more time trying to understand what we (or others) wrote, and why does
it misbehave, than the time we spent writing it in the first time.


## What is debugging?

Before running the program everything was in a known good state.

After running the program something is in an unexpected, and bad state.

The task is to find out at what point went something wrong and to correct it.

## What is programming and what is a bug?

Basically, programming is changing the world a bit by moving around data in variables.

In every step of the program we change some data in a variable in the program, or something in the "real world".
(For example on the disk or on the screen.)

When you write a program you think through each step: what value should be moved to which variable.

A bug is a case when you thought you put value X in some variable while in reality value Y went in.

At one point, usually at the end of the program, you can see this as the program printed an incorrect value.

During the execution of the program it can manifest in the appearance of a warning or in abnormal termination of the program.

## How to debug?

The most straight forward way to debug a program is to run it, and at every step to check if all the variables
hold the expected values. You can do that either **using a debugger** or you can embed **print statements** in the
program and examine the output later.

Perl comes with a very powerful command-line debugger. While I recommend learning it,
it can be a bit intimidating at first. I prepared a video where I show the
[basic commands of the built-in debugger of Perl](/using-the-built-in-debugger-of-perl).

IDEs, such as [Komodo](http://www.activestate.com/),
[Eclipse](http://eclipse.org/) and
[Padre, the Perl IDE](http://padre.perlide.org/) come
with a graphical debugger. At some point I'll prepare a video for some of those as well.

## Print statements

Many people are using the age-old strategy of adding print statements to the code.

In a language where the compilation and building can take a lot of time print statements
are considered a bad way to debug code.
Not so in Perl, where even large application compile and start running within a few seconds.

When adding print statements one should take care of adding delimiters around the values. That will catch the
case when there are leading or trailing spaces in the value that cause the problem.
Those are hard to notice without a delimiter:

Scalar values can be printed like this:

{% include file="examples/debugging_print.pl" %}

Here the less than and greater than signs are there only to make it easier for the reader
to see the exact content of the variable:

{% include file="examples/debugging_print.txt" %}

If the above is printed you can quickly notice that there is a trailing newline at the end of the $file_name
variable. Probably you forgot to call **chomp**.

## Complex data structures

We have not learned even scalars yet, but let me jump ahead here and show how you would
print out the content of the more complex data structures. If you are reading this
as part of the Perl tutorial then you probably want to skip to the next entry and come back later.
This won't mean too much to you now.

Otherwise, keep reading.

For complex data structures (references, arrays and hashes) you can use the `Data::Dumper`

{% include file="examples/data_dumper.pl" %}

These will print something like this, which helps understand the content of the variables,
but shows only a generic variable name such as `$VAR1` and `$VAR2`.

{% include file="examples/data_dumper_out.pl" %}

I'd recommend adding some more code and printing the name of the variable like this:

```perl
print '@an_array: ' . Dumper \@an_array;
```

to gain:

```
@an_array: $VAR1 = [
        'a',
        'b',
        'c'
      ];
```

or with Data::Dumper like this:

{% include file="examples/data_dumper_dump_snippet.pl" %}

getting

{% include file="examples/data_dumper_out2.pl" %}

There are nicer ways to print data structures but at this point `Data::Dumper`
is good enough for our needs and it is available in every perl installation.
We'll discuss other methods later on.

