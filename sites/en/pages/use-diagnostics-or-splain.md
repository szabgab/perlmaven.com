---
title: "use diagnostic; or use splain"
timestamp: 2014-04-01T23:55:01
tags:
  - diagnostics
  - splain
published: true
books:
  - beginner
author: szabgab
---


If you get a [warning or error from Perl](/common-warnings-and-error-messages) that you don't understand you have several choices:

* Ask for [help](/help) in one of the channels mentioned [here](/help)
* Check out the alternative, and hopefully [beginner friendly explanations](/common-warnings-and-error-messages) on the Perl Maven site.
* Turn on **diagnostics** or use **splain**.


Beyond the short error message or warning you get from perl, you can also ask perl to provide you a long
explanation. You can do this either by adding `use diagnostics;` to your code (recommended only during development),
or by saving the error message in a file and then using `splain`.

## Illegal division by zero

Let's use a trivial example:

```perl
$x = 0;
print 1 / $x;
```

If we have the above code (though you should [always use strict and warnings too](/strict)) in a file called `x.pl`
and we run it using `perl x.pl` we get the error:

```
Illegal division by zero at x.pl line 2.
```

I know. This error is probably obvious to most people familiar with basic math and when you encounter such error, the main issue is
probably how did 0 end up in [denominator](http://en.wikipedia.org/wiki/Denominator), in our case in `$x`?

Nevertheless it is a good example to show how to get more detailed explanation:

## use diagnostics

Add `use diagnostics` to the code:

```perl
use diagnostics;

$x = 0;
print 1 / $x;
```

run as `perl x.pl`

The output looks like this:

```
Illegal division by zero at x.pl line 4 (#1)
    (F) You tried to divide a number by 0.  Either something was wrong in
    your logic, or you need to put a conditional in to guard against
    meaningless input.

Uncaught exception from user code:
    Illegal division by zero at x.pl line 4.
```


## splain

Splain is a command-line tool that comes with the standard installation of Perl.

We run the original script (without adding `use diagnostics` but we redirect the standard error to a file:

```
perl x.pl 2> x.err
```

The we run:

```
splain x.err
```

It will print

```
Illegal division by zero at x.pl line 2 (#1)
    (F) You tried to divide a number by 0.  Either something was wrong in
    your logic, or you need to put a conditional in to guard against
    meaningless input.
```


## splain in a pipe

The more adventurous Linux/Unix user can also pipe the error message through splain without saving it in a file using

```
perl x.pl 2>&1 | splain
```


