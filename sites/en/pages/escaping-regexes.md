---
title: "Escaping \ in regex: Unmatched ( in regex; marked by  <-- HERE"
timestamp: 2020-05-30T10:30:01
tags:
  - qr
published: true
author: szabgab
archive: true
show_related: true
---


How can you check if a string contains a backslash `\` or even better it starts with one?

You could use use the [index](/index-function) function to check that, but what if this is only a part of something more
complex that will require the use of regexes?


Because backslash `\` has special meaning in strings and regexes, if we would like to tell Perl that we really mean a
backs-slash, we will have to "escape" it, by using the "escape character" which happens to be back-slash itself.
So we need to write two back-slashes: `\\`.
Becasue we will also want to capture it we also put it in parentheses.

The first solution worked:

{% include file="examples/regex_escaping.pl" %}

## Escape in a variable

Then, in order to make our regex more reusable we wanted to put it in a variable

{% include file="examples/regex_escaping_broken.pl" %}

and suddenly we got and error:

{% include file="examples/regex_escaping_broken.out" %}

In order to fix this we first need to understand what happened. So we printed out the content of `$pat`.
It has `(\)` in it. That helped me understand that by the time $pat arrived in the regex Perl already "ate"
one of the backslashes so now the regex engine see the opening parentheses as a special character,
but not the closing parenthes as it was escaped.

One solution would be to write:

```
my $pat = '(\\\\)';
```

but that can get out of hand very quickly.

## Use qr to quote a regexp like string

A better way is to use `qr` we create $pat so Perl will already convert our expression to a compiled regex.

{% include file="examples/regex_escaping_fixed.pl" %}
