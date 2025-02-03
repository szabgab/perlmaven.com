---
title: "Use of uninitialized value"
timestamp: 2012-09-05T21:45:56
tags:
  - undef
  - uninitialized value
  - $|
  - warnings
  - buffering
published: true
books:
  - beginner
author: szabgab
---


This is one of the most common warning you will encounter while running Perl code.

It is a warning, it won't stop your script from running and it is only generated if
warnings were turned on. Which is recommended.

The most common way to turn on warnings is by including a `use warnings;` statement
at the beginning of your script or module.


The older way is adding a `-w` flag on the sh-bang line. Usually looks like this
as the first line of your script:

`#!/usr/bin/perl -w`

There are certain differences, but as `use warnings` is available for 12 years now,
there is no reason to avoid it. In other words:

Always `use warnings;`!


Let's go back to the actual warning I wanted to explain.

## A quick explanation

```
Use of uninitialized value $x in say at perl_warning_1.pl line 6.
```

This means the variable `$x` has no value (its value is the special value `undef`).
Either it never got a value, or at some point `undef` was assigned to it.

You should look for the places where the variable got the last assignment,
or you should try to understand why that piece of code has never been executed.

## A simple example

The following example will generate such warning.

```perl
use warnings;
use strict;
use 5.010;

my $x;
say $x;
```

Perl is very nice, tells us which file generated the warning and on which line.

## Only a warning

As I mentioned this is only a warning. If the script has more statements after that
`say` statement, they will be executed:

```perl
use warnings;
use strict;
use 5.010;

my $x;
say $x;
$x = 42;
say $x;
```

This will print

```
Use of uninitialized value $x in say at perl_warning_1.pl line 6.

42
```

## Confusing output order

Beware though, if your code has print statements before the line
generating the warning, like in this example:

```perl
use warnings;
use strict;
use 5.010;

print 'OK';
my $x;
say $x;
$x = 42;
say $x;
```

the result might be confusing.

```
Use of uninitialized value $x in say at perl_warning_1.pl line 7.
OK
42
```

Here, 'OK', the result of the `print` is seen <b>after</b>
the warning, even though it was called <b>before</b> the
code that generated the warning.

This strangeness is the result of `IO buffering`.
By default Perl buffers STDOUT, the standard output channel,
while it does not buffer STDERR, the standard error channel.

So while the word 'OK' is waiting for the buffer to be flushed,
the warning message already arrives to the screen.

## Turning off buffering

In order to avoid this you can turn off the buffering of STDOUT.

This is done by the following code: `$| = 1;`
at the beginning of the script.


```perl
use warnings;
use strict;
use 5.010;

$| = 1;

print 'OK';
my $x;
say $x;
$x = 42;
say $x;
```

```
OKUse of uninitialized value $x in say at perl_warning_1.pl line 7.
42
```

(The warning is on the same line as the <b>OK</b> because we have not printed a newline
`\n` after the OK.)

## The unwanted scope

```perl
use warnings;
use strict;
use 5.010;

my $x;
my $y = 1;

if ($y) {
  my $x = 42;
}
say $x;
```

This code too produces `Use of uninitialized value $x in say at perl_warning_1.pl line 11.`

I have managed to make this mistake several times. Not paying attention I used `my $x`
inside the `if` block, which meant I have created another $x variable,
assigned 42 to it just to let it go out of the scope at the end of the block.
(The $y = 1 is just a placeholder for some real code and some real condition.
It is there only to make this example a bit more realistic.)

There are of course cases when I need to declare a variable inside an if block, but not always.
When I do that by mistake it is painful to find the bug.



## Comments

Using Padre to code Perl, when I try to execute, in this statement
$yeara = $year + 1900;
I got this error:
Global symbol "$yeara" requires explicit package name at ....
Please, tell me where may I get the info about that in order to fix it,
(other error messages too)
thanks in advance


https://perlmaven.com/common-warnings-and-error-messages


<hr>

When I am calling perl script thorugh jenkins Execute shell I am getting error"Use of uninitialized value in string eq " but from the same jenkins server(linux backen) when I am running that perl it runs fine .

Is there anything else in that warning you get? Such as name of the variable or the line of code that generated this warning? What is the version of perl on that server?


