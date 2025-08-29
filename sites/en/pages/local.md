---
title: "local"
timestamp: 2020-09-23T19:00:01
tags:
  - local
published: true
author: szabgab
archive: true
description: "local to localize global variables when you cannot use my."
show_related: true
---


You rarely need to use **local** to localize global variables, but in some cases you cannot use **my** and then <b>local</b> is needed.

In other words: In almost every case when you want to create variable that is scoped to some block you should use **my**.


Let's see a few examples:

## Slurp mode

{% include file="examples/slurp.pl" %}

In the so-called [slurp mode](/slurp) wer read the entire content of a file into a single scalar variable. In order to do that we need to set
the **$/** to be **undef**. We use <b>local</b> to limit the scope.

## Change the LIST_SEPARATOR

In the rare case when you'd like to change the [character that is inserted between array elements](/list-separator) in string interpolation,
you can change [$" the $LIST_SEPARATOR](list-separator) variable.

{% include file="examples/list_separator.pl" %}

## Local on package variables

{% include file="examples/local.pl" %}

```
x 1
y 1
x 2
y 2
x 2 in show_vars
y 1 in show_vars
x 1
y 1
```

The only difference is when you call a function from inside the block where you **local**-ized or **my**-ed the global variable.

In both cases the variable inside the block hides the variable outside the block, but when we call a function from that block
the behavior changes.
In the case of **my** the change is scoped to the enclosing block
In the case of **our** and **local** the changes is scoped to the enclosing block and to anything called from that block. We inherit the new value.

See also the [official documentation](https://metacpan.org/pod/perlfunc#local-EXPR).
