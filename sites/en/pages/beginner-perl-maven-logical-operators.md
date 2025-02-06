---
title: "Logical Operators in Perl - video"
timestamp: 2015-03-07T09:01:55
tags:
  - and
  - or
  - not
  - xor
  - "&&"
  - "||"
  - "//"
  - "!"
types:
  - screencast
published: true
books:
  - beginner_video
author: szabgab
---


Logical Operators


<slidecast file="beginner-perl/logical-operators" youtube="fuk9gedIlWI" />

In Perl there are two sets of logical operators.
One set is the words `and`, `or`, `not`, and `xor`.
The other set signs: the double ampersand (`&amp;&amp;`), the double pipe (`||`), the exclamation mark (`!`),
and [starting from perl 5.10](/what-is-new-in-perl-5.10--say-defined-or-state) the defined or (`//`).

You can either either of these and the meaning is the same so `and` is the same as `&amp;&amp;` except that the precedence of these
operators are different.

Normally you'd write an expression like this:

```
if (COND and COND) {
}
```

In this case it does not really matter if you use `and` or if you write `&amp;&amp;`. Usually people coming from other
languages where they only had the signs will keep using them until the point when they start realizing that writing the words make their
code more readable.

Other examples would look like these:

```
if (COND or COND) {
}

if (not COND) {
}
```

The important thing is not to mix them, so in one expression you should either use words or you should use the signs only.
That's because mixing them can have unexpected effects due to the difference in precedence.

This difference is important in some cases.

For example when we would like to [set default values to a scalar](/how-to-set-default-values-in-perl) it is important
to use `||` or `//`.

In the case of <a href="/beginner-perl-maven-shift">shift or die` it is important to use the word `or`.
The expression will not work if we replaced it with `||`.

In the case of [open or die](/open-and-read-from-files) you could use `||`, but that would require additional parentheses.
I recommend always using `or` in that case too.

