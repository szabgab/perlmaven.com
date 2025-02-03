---
title: "Prompt, read from STDIN, read from the keyboard in Perl"
timestamp: 2016-05-12T20:31:25
tags:
  - STDIN
  - chomp
  - IO::Prompter
published: true
books:
  - beginner
author: szabgab
---


When [getting started with Perl](/perl-tutorial) one of the first things you need to
know is how to interact with the user on the command line. In other words you need to be able to
handle basic Input Output (I/O).


{% include file="examples/prompt.pl" %}

After including the [safety net](/installing-perl-and-getting-started)
in the form of [use strict; use warnings;](/always-use-strict-and-use-warnings)
we call the `print` function that will display the text after it on the screen.
As we have not included `\n` (the sign representing the newline) in our string the
blinking cursor will be shown on the same line where the text was printed.

When we run the script at this point it will wait for the user to type in some stuff
and press `ENTER`.

Once the user has done this the code will continue to run and he stuff the user typed in,
including the character representing the `ENTER` will be assigned to the `$name`
variable on the left hand side of the `=` assignment operator.

The `my` operator at the beginning of the line declares this variable.
This is the way we tell Perl that would like to use this variable called `$name`.

Once we have the input in `$name` we call the [chomp](/chomp)
function which has the sole purpose of removing the trailing newline (the `ENTER`)
from the given string.

Finally, just to give some feedback, we call print again displaying the content
the user has typed in.


## IO::Prompter

This was a very simple solution using only the core language and providing
a very simple way to prompt for some input. For more complex and robust solution
check out one of the modules on CPAN.
For example [IO::Prompter](/prompt-using-io-prompter).

## Secure input

You can also
[prompt for a password](/how-to-read-a-password-on-the-command-line)
without the user, or someone behind their shoulders, seeing what is being typed.

