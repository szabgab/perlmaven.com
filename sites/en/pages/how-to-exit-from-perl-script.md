---
title: "How to exit from a Perl script?"
timestamp: 2013-06-21T15:30:01
tags:
  - exit
  - $?
  - >>
published: true
books:
  - beginner
author: szabgab
---


If you followed the [Perl Tutorial](/perl-tutorial) so far every script finished when
the execution reached the last line of code in your file.

There are however cases when you'd like to stop the execution earlier.

For example, you ask the users how old they are, and if they are under 13 you stop the script.


{% include file="examples/exit_on_condition.pl" %}

Just a plain call to `exit`.

## The exit code

If you have used the Unix/Linux shell, then you might know each program
when exits provides an exit code that can be found in the `$?` variable.
You can provide this exit value from a perl script as well by passing a number to
the `exit()` call.


```perl
use strict;
use warnings;
use 5.010;

exit 42;
```

For example here we set the exit code to 42. (The default is 0.)

## Success or failure?

In Perl usually 0 or [undef](/undef-and-defined-in-perl) mean failure,
and some other [true value](/boolean-values-in-perl) means success.

In the Unix/Linux shell world, 0 means success and other numbers mean failure.
Usually each application has its own set of values indicating different error conditions.


## Checking the exit code on Linux

On a Unix/Linux box you would run the script using `perl script.pl` and then
you can examine the exit code using `echo $?`.


## Examining exit code in Perl

If you happen to execute one perl script from another, for example
using the [system](/running-external-programs-from-perl) function, 
Perl has the same variable `$?` containing the exit code of the "other program".

If you have the above code saved as script.pl and you have another "executor.pl" like this:

{% include file="examples/examine_exit_code.pl" %}

The output will be:

```
10752
10752
42
```

The call to `system` will return the exit code and it will be also saved in the `$?`
variable of Perl. The important thing to note is, that this value contains 2 bytes and the actual
exit code is in the upper byte. So in order to get back the 42 as above we have to right-shift the
bits using the `&gt;&gt;` bitwise operator with 8 bits. That's what we see in the
last line of the above example.

## Comments

Thanks for the explanation Gabor, really clear

---

Hi,

"In Perl usually 0 or undef mean failure, and some other true value means success".
Q: Are you referring "return' command value here or this is applicable for both exit and return codes. exit 0 in perl is a failure?

---
return. After you exit you are not in perl any more.
