---
title: "How to check if string is empty or has only spaces in it using Perl?"
timestamp: 2013-11-16T07:30:01
tags:
  - space
  - \s
published: true
author: szabgab
---


To check if string is empty use `eq`. To check if it has only spaces
or only white space in it, use a regex.



## Is the string empty?

```perl
if ($str eq '') {
    print "String is empty.";
}
```

That would work, but if `use warnings;` is in effect, as it should be,
then you might get a [Use of uninitialized value](/use-of-uninitialized-value) warnings if `$str` is [undef](/undef-and-defined-in-perl). So it might
be better to check this too, before any other comparison:

```perl
if (not defined $str) {
    print "String is so empty, it is not even defined.";
}
```

and to do the other comparisons only if `$str` is defined.


## Has the string only spaces in it?

```perl
if ($str =~ /^ *$/) {
    print "String contains 0 or more spaces and nothing else.";
}
```

## Has the string only white-spaces in it?

```perl
if ($str =~ /^\s*$/) {
    print "String contains 0 or more white-space character and nothing else.";
}
```

A white-space character can be a space, a tab, and a few other characters that
normally we cannot see. The `>^` at the beginning of the regex means
"match at the beginning of the string".
The `$` at the end of the regex means "match at the end of the string".

`*` in the regex is a quantifier. It means match 0 or more times the thing
that is on its left hand side. In the previous regex there was a space in on the left hand side
of the `*`. In the second regex we have `\s` in front of the
`*`

\s matches any on of the following 5 characters:

* space
* tab (`\t`)
* carriage-return (`\r`)
* newline (`\n`)
* form-feed (`\f</hl)


