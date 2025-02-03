---
title: "qx or backticks - running external command and capturing the output"
timestamp: 2019-05-17T08:30:01
tags:
  - qx
published: true
author: szabgab
archive: true
---


People knowing shell are familiar with the back-ticks ```` that allow us to execute external commands and capture
their output. In Perl you can use the back-ticks or the `qx` operator that does exactly the same, just makes the
code more readable.

In Perl there are several ways to run external programs depending on your needs.
For example you can use [system to run external programs](/running-external-programs-from-perl) without
capturing output. This time we look at the backticks and qx.


## The external program

The external program can be anything and it can be written in any language. To make it clearer however I've prepared a
sample external program in perl:

{% include file="examples/external.pl" %}

If you run this on the command line you get the following on the screen:

{% include file="examples/external.txt" %}

Two lines are printed to STDOUT and one line to STDERR, but on the command line you can't tell them apart. (You could
use <a href="/stdout-stderr-and-redirection>STDOUT and STDERR redirection</a> to what goes where or you could just trust
me for now.

## Backtick `` in scalar context

We can use backtics to run the external program and assign the results to a scalar variable. It would capture everything
printed to STDOUT and put it in the scalar variable as a single string.
(See [SCALAR and LIST context](/scalar-and-list-context-in-perl) if you'd like to know the distinction.)

{% include file="examples/capture_stdout_backtick_scalar.pl" %}

The STDERR will be printed directly to the screen untouched by the backticks. If the STDOUT has multiple lines (as in
our case), they will still form a single multi-line string in the capturing code:

{% include file="examples/capture_stdout_backtick_scalar.txt" %}


## qx in scalar context

Instead of the backticks that are hard to see and hard to search for, we can use the `qx` operator of perl.

At first it looks like a strangely-named function:

{% include file="examples/capture_stdout_qx_scalar.pl" %}

The results are exactly the same:

{% include file="examples/capture_stdout_qx_scalar.txt" %}

However `qx` allows any pair of delimiters so you could use curly braces instead of parentheses
and that would still do the exact same thing:

{% include file="examples/capture_stdout_qx_scalar_curly.pl" %}


## Backtick `` in list context

Instead of assigning to a scalar variable we can also assign the backtick to an array, putting it in LIST context.

(See [SCALAR and LIST context](/scalar-and-list-context-in-perl) if you'd like to know the distinction.)

{% include file="examples/capture_stdout_backtick_array.pl" %}

In this case whatever the external program printed to STDOUT is split into rows and are assigned to the array. Each row
is a separate line in the resulting array. So the number of elements in the array is the number of rows on the STDOUT.

{% include file="examples/capture_stdout_backtick_array.txt" %}

## qx in list context

The same can be done with the `qx` operator.

{% include file="examples/capture_stdout_qx_array.pl" %}

And the output:

{% include file="examples/capture_stdout_qx_array.txt" %}


## Use case

See [How to provide STDIN to an external executable](/how-to-provide-stdin-to-an-external-executable) as a
use-case.

## Blocking

They block the main process and wait till the external program finished so it can collect all the output.

## Capture::Tiny

The Capture::Tiny is an excellen alternative to the <b>qx</b> operator. See the example how to
[capture STDOUT and STDERR of an external program](/capture-stdout-stderr-of-external-program).

## Comments

Not bad on the basics, but I was hoping for a little more detail-- like, if you're building an external command string how do you handle quoting the arguments (I tend to use the CPAN module String::ShellQuote), and when do you need to worry about security issues (untrusted input and untainting), then there are the issues with shell i/o redirection (you can get STDOUT, STDERR, or both together, but then you can't tell which was which), and then there's qx compared to system...

<hr>

how to call a .pl inside a .cgi file? thank you
