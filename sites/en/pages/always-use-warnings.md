---
title: "Always use warnings in your Perl code!"
timestamp: 2017-02-24T22:30:01
tags:
  - warnings
published: true
author: szabgab
archive: true
---


For many years, I have recommended to [always use strict and warnings](/always-use-strict-and-use-warnings) in any Perl
code. In my [Perl Tutorial](/perl-tutorial) it is in the first article and when I teach Perl it is at the very beginning.

The recommendation to [always use strict](/strict) is universally accepted by the Perl community,
but the `use warnings` is still debated by some people.

Here you will find a collections of cases where `use warnings` would catch a bug in your code. Some of them thanks to
the members of [Perl Programmers on Facebook](https://www.facebook.com/groups/perlprogrammers/permalink/1447468815285902/)
and the [Perl group on LinkedIN](https://www.linkedin.com/groups/106254).

It is of course, not enough to turn on warnings. One also needs to monitor the code to make sure no warnings are printed
and there are warnings, one must investigate and fix the code that generated the warning message.


## undefined values or unassigned variables

This is probably the most common warning you will see in your code once you enable `use warnings`.
In most of the cases it is harmless and just indicates a very clever default of Perl. ([undef](/undef-and-defined-in-perl)
acting as empty string or as 0 depending of the type of the operation it participates in.)
That's one of the reasons people might turn off warnings or never turn on in the first place. Tons of useless warnings.

However there are cases where behind this warning a real bug lurks. For example in this code:

{% include file="examples/visible_undef.pl" %}

If we run it as it is we get the following:

```
Dear ,
We are happy to let you know you won the 1,000,000 USD...
```

You might think this is a bit embarrassing, but not big deal.
What about this?

{% include file="examples/access_control.pl" %}

If we run this passing an incorrect secret code we get denied:

```
$ perl access_control.pl incorrect_secret
Access denied
```

However if we don't send in anything it will happily grant us access:

```
$ perl access_control.pl
Accessing account information...
```

If we turn on `use warnings;` it will still allow access, but at least now we'll know about it:

```
$ perl access_control.pl
Use of uninitialized value $user_code in string eq at access_control.pl line 7.
Use of uninitialized value $code_from_db in string eq at access_control.pl line 7.
Accessing account information...
```

If we make our warnings into **fatal errors** by adding the following line

```perl
use warnings FATAL => 'all';
```

we will avoid that problem. This will be the output:

```
$ perl access_control.pl
Use of uninitialized value $user_code in string eq at access_control.pl line 7.
```

### Typo in hash key

Another case of this would be the following code snippet:

{% include file="examples/incorrect_hash_key.pl" %}

Here we assign to the hash-key "color", but then subsequently try to access the key "colour".
The above code will be silent about the problem. If we enable `use warnings` we get:

```
Use of uninitialized value in print at incorrect_hash_key.pl line 10.
```

See more explanation about [use of uninitialized value](/use-of-uninitialized-value).

## Useless use ... in void context

There is a fairly standard idiom to [set default values in Perl](/how-to-set-default-values-in-perl). It is

```
my $var = $x || $default;
```

or

```
my $var = $x // $default;
```

However in this code the author used `or` instead of `||`:

{% include file="examples/set_default.pl" %}

If we run this code, it will silently ignore the `$default_code`.

If we enable `use warnings` then we get the following warning:

```
Useless use of private variable in void context at set_default.pl line 11.
```

### Useless use of a constant

Another case which is silent:

{% include file="examples/assign_or.pl" %}

but would produce the following warning if `use warnings;` was enabled:

```
Useless use of a constant ("default") in void context at assign_or.pl line 6.
```


A related case might be this one:

{% include file="examples/set_default_by_function.pl" %}

If we run this code, we will see 
```
running default_code
```
on the terminal, indicating that the `default_code` function was called,
but strangely the content of `$code` is still not visible.

If we enable `use warnings` we will get:

```
running default_code 
Use of uninitialized value $code in print at set_default_by_function.pl line 7.
```

That means the variable `$code` has not been set to the default value.

What happens here is that first the assignment happens and after that, if the assigned value was
[false](/boolean-values-in-perl), Perl still calls the `default_code`
function and then discards the returned value.

This problem could be easily overlooked without `use warnings`.

## Subroutine ... redefined

In this example we have accidentally used the same function name twice.

{% include file="examples/subsub.pl" %}

In real code these would probably be hundreds of lines apart, or one or both would be loaded
from an external module it is easy to overlook the problem.

Without `use warnings` this will print out 5 for both calls.

With `use warnings` enabled it will print:

```
Subroutine sum redefined at subsub.pl line 15.
5
5
```

## Bitwise by mistake

A common typo might be to write `&amp;` instead of `&amp;&amp;` in an
if-statement:

{% include file="examples/bitwise_by_mistake.pl" %}

The result of this code is:

```
In range
Out of range
```

If we turn on `use warnings` we get:

```
Possible precedence problem on bitwise & operator at bitwise_by_mistake.pl line 10.
In range
Out of range
```

Just a reminder, if you just wrote the code, tested, saw the problem and fixed it then you might
feel the `use warnings` is not necessary, but what if you write this code and forget to
test an edge-case that happens to trigger this? Then you will only find out about the bug when your
customer encounters it.

My recommendation is to (almost) always use `and` instead of `&amp;&amp;`, but this does not
help if you have a 1,000,000 lines ancient code-base.

## "my" variable masks earlier declaration

After learning that you [must always use strict](/strict) you started to declare all of your variables.
Sometimes even twice like in this case:

{% include file="examples/mymy.pl" %}

The story behind this is that you had the first `my $x` in the code and the last `print $x` in
a long subroutine and then you, or someone else who does not know the code comes in and in the middle of the code needs to use a temporary
variable. `$x` sounds good. It even works, but now, suddenly our "temporary" variable has an impact on the other parts of the code.

If we had `use warnings;` enabled, we would get:

```
"my" variable $x masks earlier declaration in same scope at mymy.pl line 8.
19
19
```

and that would make us think a bit more about this.

## Array element or slice

I am not sure if this can be a real bug, but it certainly can increase the confusion of
a maintenance programmer:

{% include file="examples/array_element.pl" %}

If we run this code `use warnings` enabled we get the following warning:

```
Scalar value @n[0] better written as $n[0] at examples/array_element.pl line 6.
23
```

Without that we will silently tell everyone we don't know what is the difference between
and array element and a slice.

## Possible precedence issue with control flow operator

Another case when we tried to return a default value, but instead of that
we returned the original value:

{% include file="examples/prec.pl" %}

Running this code will print

```
23
0
```

After we enable `use warnings` we get 

```
Possible precedence issue with control flow operator at examples/prec.pl line 14.
23
0
```

## Assignment in if statement

Another typo when we put a single `=` sign in a `if statement` as in this example.

{% include file="examples/assignment_in_if.pl" %}

Running this code will print "True". Which is clearly false.

Turning on `warnings` will show the follwing warning:

```
Found = in conditional, should be == at examples/assignment_in_if.pl line 6.
```

## Missing argument in sprintf

The beautiful example was supplied by Peter Jaquiery:

{% include file="examples/sprintf.pl" %}

Running this code will print

```
51.72
```

Turning warnings on will generate:

```
Useless use of sprintf in void context at examples/sprintf.pl line 6.
Missing argument in sprintf at examples/sprintf.pl line 6.
51.72
```

The real problem is that the closing parenthese `)` of `sprintf`
is in the wrong place. The fix looks like this:

{% include file="examples/sprintf_fixed.pl" %}

and the result is

```
51.7
```


## War stories by Breno G. de Oliveira

Let me quote the story **Garu** has written in response to my inquiry about the usefulness of `use warnings`.

<quote>
This client **had** warnings enabled but simply ignored them, because "it was working".
It was a high traffic site and the log issued pages and pages of warnings per second - completely useless.
So I took it as a mission to clear out all warnings.
We uncovered TONS of small bugs like undefined variables being interpolated into strings (that were shown to the customers), and even code that wasn't doing anything at all (void context).
After a few days the logs had almost no warnings and it was super easy to catch issues in production as they happened.

This other client had an issue with sub X not working properly. We updated it but it made no difference. We added debug statements, nothing. It was as if it wasn't being called. use warnings. "Subroutine X redefined at". (interestingly, the client thought they had warnings enabled because of a module that imported strict/warnings, but that module was factored out and the code lost those pragmas).

I have never really tested this, but my perception is that by far the biggest benefit I got from warnings is catching typos in hash keys, like `$user->{naems}` when you meant 'names'.
</quote>


## A warning about warnings

As brian d foy pointed out on [Redit](https://www.reddit.com/r/perl/comments/5w047y/always_use_warnings_in_your_perl_code/), one should be careful when upgrading Perl. New warnings are being added and if one does not monitor the log file of a web server these new warnings can easily eat up the diskspace and cause serious problems.

I would definietly recommend always monitoring the log files and even getting alerts when there is a warning and investing the time into finding their sources and fixig them.

The risk of upgrade problems can be largely avoided by a set of automated tests that check for warnings.
(e.g. with [Test::NoWarnings](https://metacpan.org/pod/Test::NoWarnings) or [Test::FailWarnings](https://metacpan.org/pod/Test::FailWarnings))
Does not really matter if they are unit, integration, or acceptance tests.

Mithaldu suggests the use of [strictures](https://metacpan.org/pod/strictures), but I've never used it. Check it out.




## Conclusion

I'd recommend to **always** `use warnings` in your perl code.

Possibly even `use warnings FATAL => 'all';` though this might be better
fit during development and testing.


## Comments

I know I'll be branded a heretic by a number of far-more-knowledgeable-than-I perl gurus, but I have "use warnings FATAL => 'all';" in my production code. With proper testing, very few warnings escape into the wild, but the few that do result in a crash that I must deal with instead of papering over. And they've managed to stop the execution before an unhandled situation caused even worse damage than an abort. Even though I've gotten support calls at 3AM to deal with it, far too often had they continued despite a warning, things would have turned out badly. Instead of an hour or two dealing with the issue and then resuming, it would have been six+ hours of reverting the system just to rerun things with a fix.

Better to blow a bit of my night than to blow an entire weekend.

(After a few years, I did manage to get it to the point where this didn't happen anymore, but not by removing the FATAL aspect of warnings - by handling the situations properly, even if that meant "no warnings ..." in small blocks.)

----

At the last placed I worked we did this in production code. One major agurment in favor, was that if they were fatal only in development environments, then we have a situation where development environments behave differently than production ones, and this is something we generally tried to avoid.

---
And especially with the product Mark and I were working on, it was entirely likely that customers running production code could run into situations we hadn't anticipated in our development and testing.


<hr>

Aside from code cleanup and ensuring that unutilized values and core functions missing items, the bugs that warnings catches tend to be minor/trivial/non-consequential. Additionally a huge number of modules which are commonly used won't comply in all cases with use warnings resulting in erroneous warnings for errors which aren't really errors.

I can see using warnings as a way to ensure clean code *style* from the stand point of variable allocation, sigils, but I've never found it useful for general day to day programming and debugging.

---

That sounds like you are very good programmer who does not make mistakes. Congratulations. Most of us are not that good.

----


no, this doesn't have anything to do with being a good or bad programmer, It just has to do with the verbosity of non-fatal (and in most cases) non-effect error logging, and in some cases can cause additional problems for other tools monitoring the script (suddenly the script starts spewing out trivial warnings about unused variables, this breaks something, and now things are broken because of a warning which has zero effect on code stability performance or reliability.


----


Except that in many cases, the warning does NOT have zero effect. Read the post again: most, if not all, of these warnings prevent serious errors in the software.

I, for one, would rather have my software throw an exception and crash if it reaches a conditional and I haven't anticipated what I want to happen if the value I'm testing is undefined.

Of course, it might be that your software don't do anything important to begin with, so it's more important to you that it run without producing warnings when it encounters bugs than it is for it to produce consistent and CORRECT output. In my job, on the other hand, I want my software to crash with an error rather than silently produce incorrect results.

<hr>

Absolutely. Warnings are, if anything, *more* important than strict.

And where possible, make them FATAL.

<hr>


