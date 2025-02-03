---
title: "q"
timestamp: 2021-02-23T19:20:01
tags:
  - q
published: true
author: szabgab
archive: true
show_related: true
---


<b>q</b> behaves just like single quotes <b>'</b> do, but they make it easy to include other single-quotes in a string without the need to escape them.


Immediately after the <b>q</b> you put some opening character and then the string lasts till the ending pair of that character.
I usually use some form of a pair of characters (opening and closing curly braces or parentheses), but you can also use other characters as well.

{% include file="examples/q.pl" %}

The above examples all print the same string:

```
We have a variable name called '$name'.
```
