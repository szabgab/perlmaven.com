---
title: "Perl Regex superpowers - execute code in substitution - what are /e and /ee ?"
timestamp: 2018-08-13T07:30:01
tags:
  - e
  - ee
published: true
author: szabgab
archive: true
---


You are probably familiar with the power of regexes and substitution in Perl,
but there are many rarely needed, but incredible features you might not know yet.

A simple example of something you are probably familiar with looks like this:

{% include file="examples/regex/subst.pl" %}

Here we capture two digits in the original string and swap them.

That's nice, but what if we would like to replace the two digits by their sum?


## Try calculation in substitution

Let's try this:

{% include file="examples/regex/subst_calc.pl" %}

The result is not the sum of the digits, but the digits themselves with
a `+` sign between them. Of course this is not surprising, after all
the second part of a substitution behaves like a normal
[string in double quotes](/quoted-interpolated-and-escaped-strings-in-perl)
where we have interpolation, but no code execution.

That's where the `e` modifier of the regexes/substitutions comes into play.

`e as in eval`

{% include file="examples/regex/subst_calc_e.pl" %}

Here there result is `abc 6 def`.

Instead of using the substitution string as a plain string, in this case perl
called [string eval](/string-eval) on the string and the result of that `eval`
call was used as the replacement string.

As you can read in that other article [string eval](/string-eval) can be dangerous as it can execute
arbitrary perl code, but if we make sure the input can only be a very restricted set of values then it is secure as well.

Here is a rather dangerous version:

{% include file="examples/regex/subst_unlink_e.pl" %}

This one will extract the name of a file from the given string and then call [unlink](/search/unlink) on it that will remove the file.
The result in the `$str` variable will be the return value of the `unlink` function which is 1 on success and 0 on failure.

## ee as in eval the eval

If the `/e` modifier was not crazy enough, Perl allows us to double it to have the `/ee` modifier.
It calls `eval` on the string on the substitution part and then calls `eval` again on the results.

I tried to put together an examples here: Given some text that we somehow places in the `$text` variable,
(maybe we read it in from a file), we would like to replace each occurrence off STRING_DIGITS by the result of
the function with the same name.

So the string "xy_1" would be replaced by 11 as that's the number returned by the function.

In this solution we have a substitution that matches the strings that look like the functions we are looking for,
creates the functions in the first eval, and calls the functions in the second eval provided by `/ee`.
We added `g` at the end to do this globally.

Here are the 3 version of the substitution with `/ee`

{% include file="examples/regex/subst_func_ee.pl" %}

with `/e`:

{% include file="examples/regex/subst_func_e.pl" %}

without any `eval`:

{% include file="examples/regex/subst_func.pl" %}

## Another example for /ee

{% include file="examples/regex/subst_str.pl" %}

{% include file="examples/regex/subst_str_e.pl" %}

{% include file="examples/regex/subst_str_ee.pl" %}

## Examples on CPAN

You might find better or crazier examples for `/ee` via the
[grep.cpan.me](http://grep.cpan.me/?q=%2Fee([gi%20])) site.

## Another sample article

In the article [increasing numbers in a text file](/increase-numbers-in-a-file)
you can see another use-cases of `/ee`.

