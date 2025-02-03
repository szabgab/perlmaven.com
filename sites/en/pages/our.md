---
title: "our"
timestamp: 2021-02-23T20:50:01
tags:
  - our
published: true
author: szabgab
archive: true
show_related: true
---


In Perl the <b>our</b> keyword is used to declare one or more package variables. More exactly it creates lexical alias to a packaga variable, but for our practical
purposes <b>our</b> means we are allowed to use the package variable without giving the fully qualified name and without violating the rules
of [use strict](/strict).

With that out of the way, in most cases, you'd want to declare variables in a lexical scope using the [my](/my) keyword.


## With our

{% include file="examples/our.pl" %}

This works printing "Jane" in both cases.

## Without our

{% include file="examples/without_our.pl" %}

we get the following compilation error:

```
Variable "$name" is not imported at examples/without_our.pl line 9.
Global symbol "$name" requires explicit package name (did you forget to declare "my $name"?) at examples/without_our.pl line 9.
Execution of examples/without_our.pl aborted due to compilation errors.
```

## Only our

{% include file="examples/just_our.pl" %}


## Fully qualified name

The "Fully qualified name" is when the name of a variable is preceded by the name of a <b>package</b>.
The name of the default package in a script is called <b>main</b>.

## Variables in the main package

In this example we have a package in its own file and it uses the fully-qualified name of a variable in the main script which is the <b>main</b> package to access
a variable declared using <b>our</b>.

{% include file="examples/variables_in_main.pl" %}
{% include file="examples/CreatorOfPerl.pm" %}

```
perl -I examples examples/variables_in_main.pl
```

## Other articles related to our

Check out other articles covering the [our](/search/our) keyword. For examples [scope of variables in Perl](/scope-of-variables-in-perl),
and [variable declaration in Perl](/variable-declaration-in-perl).

Also check out the difference between <a href="/package-variables-and-lexical-variables-in-perl">Package variables declared with <b>our</b> and Lexical variables declared with <b>my</b> in Perl</a>.

[use strict](/strict) will force you and your co-workers do declare every variable. It is a good thing. [Always use strict and use warnings in your perl code!](/always-use-strict-and-use-warnings).

Check other articles about [strict](/search/strict).

[perldoc](https://metacpan.org/pod/perlfunc#our-VARLIST)


