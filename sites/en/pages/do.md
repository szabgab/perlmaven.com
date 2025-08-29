---
title: "do"
timestamp: 2020-12-13T10:30:01
tags:
  - do
  - $@
  - $!
published: true
author: szabgab
archive: true
show_related: true
---


**do $filename** will read the content of the file and the it will try to execute it insides the current process.

I use it sometimes when there is a command line program I'd like to test, but one that needs finer interaction
than one could do if it was executed as an external Perl program. For example if I need to set some variables, or
mock some part of the program.

Just as **eval** using **do** will also capture errors it encounters. It is important to understand how we can
see those errors.

Here is how **do** reports problems.


Basically after calling **do $filename;**we need to check bot **$!** and <b>$@</b> and verify that both are empty
as either one of them can contain an error.

Let me show 3 scripts, the first one has no problems:

{% include file="examples/do/code_works.pl" %}

This one has a compile-time error because of a missing **my** declaration.

{% include file="examples/do/compile_time_error.pl" %}

This one is trying to load a module that does not exist:

{% include file="examples/do/code_wrong_use.pl" %}

The next one can run, but it has a run-time exception:

{% include file="examples/do/code_exception.pl" %}

## Test script to check the cases

The following is a test script that check the **$!** and the <$@** in the various previous cases and also
in a case where the **do $filename;** points to a file that does not exist.

{% include file="examples/do/test_with_do.t" %}

You can see that in all of the cases - expect the one with the working code - either **$!** or **$@** and sometimes both had some content.

## Documentation

See also the [documentation](https://metacpan.org/pod/distribution/perl/pod/perlfunc.pod#do-BLOCK) of the **do** function.
