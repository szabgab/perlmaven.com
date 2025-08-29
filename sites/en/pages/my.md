---
title: "my"
timestamp: 2021-02-23T20:30:01
tags:
  - my
published: true
author: szabgab
archive: true
show_related: true
---


In Perl the **my** keyword is used to declare one or more lexical variables. That is variables that are scoped to the enclosing block of curly braces.
There are also package variables in Perl that are declared using the [our](/our) keyword.


{% include file="examples/my.pl" %}

Check out other articles covering the [my](/search/my) keyword. For examples [scope of variables in Perl](/scope-of-variables-in-perl),
and [variable declaration in Perl](/variable-declaration-in-perl).


Also check out the difference between <a href="/package-variables-and-lexical-variables-in-perl">Package variables declared with **our** and Lexical variables declared with **my** in Perl</a>.

[use strict](/strict) will force you and your co-workers do declare every variable. It is a good thing. [Always use strict and use warnings in your perl code!](/always-use-strict-and-use-warnings).

Check other articles about [strict](/search/strict).

[perldoc](https://metacpan.org/pod/perlfunc#my-VARLIST)
