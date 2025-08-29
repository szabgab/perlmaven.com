---
title: "Always use strict and use warnings in your perl code!"
timestamp: 2015-03-19T13:00:01
tags:
  - strict
  - warnings
published: true
books:
  - beginner
author: szabgab
archive: true
---


If you have been learning from my [Beginner Perl Maven tutorial](/perl-tutorial)
or in one of my class-room training classes you have already learned this.
Unfortunately there are still a few Perl developers who are not aware of the importance
of `use strict` and `use warnings`.


People who learn Perl on their own, or from co-workers who themselves
have not learned the importance of these statement,
or by copy-pasting from random examples on the Internet
tend to not use either of those.

Even when they use, they might not understand why do they need them.

That's understandable, of course, as in many old tutorials and books
they are mentioned only towards the end. If at all.
In addition tons of code, both within companies and published on the web was written
without these. Even worse, there are some people out there who fight
against the use of these tools because "they reduce freedom".

They indeed do. just as helmets stop you from breaking your head.

The small extra cost or inconvenience of using these tools outweighs the
value they provide.

So here it is.

In any piece of code, you should **always use strict and warnings**.

Turn them off only in very restricted areas and only when you really,
really need the extra power.

(You'd probably not wear a helmet when you go to the hairdresser, would you.)
 
With time you will learn how and when you need to turn them off, but for
most of us, using them always is a good default.

## What are strict and warnings?

They are compiler flags that instruct Perl to behave in a stricter way.

They are there to help you avoid a number of common programming mistakes.

In a separate article you can read about some of the
[common error messages and warnings](/common-warnings-and-error-messages)
you might see.

## use warnings

You might have already seen the `-w` flag on the sh-bang line like this:
`#!/usr/bin/perl -w`.

`use warnings`, is a "new" and improved version of the `-w` flag.
It has a number of advantages 
and I'd recommend converting every perl script from the use of 
`-w` to the use of the <h>warnings`.

I put the "new" in quotation as it has been added to Perl version 5.6
in 2000. So it's not really new, but unfortunately it is still new to many
Perl developers.

The `warnings` pragmata provides us with lots of run-time
warnings that in many cases indicate some kind of a problem or a 
potential problem.

In general it is good to see these warnings but quite likely
you don't want to let end-users see the Perl warnings in their 
applications.
In some cases it might trigger unwanted actions from these users
trying to "fix" the warnings. The warning will certainly erode 
the users confidence in your product.

No one really wants to see all kinds of "error messages" flying around
when using any application.

Therefore some people advice against using the warnings pragma 
in production. They don't want their end-users to see warnings 
coming from Perl. That's understandable, but there are better 
ways to deal with the unwanted side effect of the warnings.

See [how to capture and save warnings](/how-to-capture-and-save-warnings-in-perl).

If a warning is triggered during execution it indicates *some* problem.
Certainly one could eliminate all the warnings by more careful coding.
So I strongly advice always using warnings.

We'll see several ways to deal with the warnings in production code.

Some of the warnings you might see:

* [Use of uninitialized value](/use-of-uninitialized-value)
* [Name "main::x" used only once: possible typo at ...](/name-used-only-once-possible-typo)
* ["my" variable masks earlier declaration in same scope](/my-variable-masks-earlier-declaration-in-same-scope)
* [Argument ... isn't numeric in numeric ...](/argument-isnt-numeric-in-numeric)

## use strict

This pragmata has 3 different features. When used as above 
it turns on all 3 of them. This is the recommended way to use it.

The most visible of the 3 features is the one that 
requires every lexical variable to be declared by the `my` or by the `our`
keywords. (There are a few additional ways but for now this should be enough).
In case you'd want to turn on this feature alone, you can do this by the 
`use strict 'vars';` statement.

If you have this feature turned on, you'll get a 
[Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name)
error in case you violate the requirement.

`use strict 'refs';` generates runtime error if a
[symbolic reference](/symbolic-reference-in-perl)
was encountered. We'll explain in another place
what symbolic references are. When are they useful and how
to use them even if we have use strict enabled at the top
of our Perl file.

`use strict "subs"` disables (at compile time) the
inappropriate use of [barewords](/barewords-in-perl).
generating error such as [Bareword not allowed while "strict subs" in use](/barewords-in-perl).

In practical term it means you need to put your strings within
double or single quotes.

```
"Foo"       # good
'Bar'       # good
Baz         # not good
```

## Avoid warnings

One of the ways to avoid the warnings is to make your code more
bullet proof. Every place where a warning might happen write more
code that will check the specific conditions and set default values
or execute the appropriate code that will avoid warnings.

This of course assumes that you already know where the warnings might occur.
It might be a good practice, but it requires a lot more code and discipline.

Not necessarily the perl way to develop an application.

Certainly not something you can easily do to an existing application.

## splain and diagnostics

If we get warnings from the code that are unclear, we can ask perl to
explain them more in detail by including [use diagnostics;](/use-diagnostics-or-splain)
in the code, or by using the [splain](/use-diagnostics-or-splain) command line tool.

## Fatal warnings

The following call turns all warnings to be exceptions. 
This might not be a good idea in production code, but during development
it forces you and your team to clean up the warnings very quickly.

```perl
use warnings FATAL => 'all';
```

