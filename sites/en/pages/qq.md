---
title: "qq"
timestamp: 2021-02-23T19:15:01
tags:
  - qq
published: true
author: szabgab
archive: true
show_related: true
---


**qq** behaves just like double quotes **"** do, they interpolate variables, but they make it easy to include double-quotes in a string without the need to escape them.


Immediately after the **qq** you put some opening character and then the string lasts till the ending pair of that character.
I usually use some form of a pair of characters (opening and closing curly braces or parentheses), but you can also use other characters as well.

Yes, even when you use **#</h> it works, but IMHO that's hard to read.

{% include file="examples/qq.pl" %}

The above examples all print the same string:

```
The name of this programming language is "Perl".
```
