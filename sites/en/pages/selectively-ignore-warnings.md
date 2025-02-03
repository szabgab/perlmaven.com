---
title: "Selectively ignore warnings (turn them off with no warnings)"
timestamp: 2023-08-16T07:30:01
tags:
  - warnings
  - uninitialized
published: true
author: szabgab
archive: true
show_related: true
---


I recommend [always turning warnings on](/always-use-warnings) from the beginning of each Perl file.

However sometime we might want to avoid some warnings. We can selectively turn off warnings inside lexical scopes, that is, till the end of the current pair of curly braces.


## With warnings

The following script generates a number of warnings.

{% include file="examples/with_warnings.pl" %}

This is the output:

```
"my" variable $x masks earlier declaration in same scope at examples/with_warnings.pl line 24.
5
Use of uninitialized value $y in addition (+) at examples/with_warnings.pl line 25.
3
Use of uninitialized value $r in addition (+) at examples/with_warnings.pl line 11.
Use of uninitialized value $q in addition (+) at examples/with_warnings.pl line 11.
0
```

## no warnings

We can turn off all the warnings by writing ```no warnings;</code> or we can turn on specific types of warnings by
explicitly listing them. Like this: ```no warnings 'uninitialized';</code>.

The next file is exactly the same as the above, but we turned off warnings inside a functions.

{% include file="examples/with_no_warnings.pl" %}

This is the output:

```
"my" variable $x masks earlier declaration in same scope at examples/with_no_warnings.pl line 25.
5
3
Use of uninitialized value $r in addition (+) at examples/with_no_warnings.pl line 11.
Use of uninitialized value $q in addition (+) at examples/with_no_warnings.pl line 11.
0
```

You can observe that the only warning that was hidden was the one warning about uninitialized values inside the functions.
The "redeclare" warning that was triggered by the code inside the function remained, and the warnings that were generated
by the code outside the function also remained.

The `no warnings` pragmata was in effect from the point we wrote it till the end of the enclosing block, the enclosing pair of curly braces.

## Conclusion

There is a [list of warning types](https://metacpan.org/pod/warnings) that you can turn on and off as you need
and we also have plenty of other articles about [warnings](/search/warnings).

For example we have many examples with [Common Warnings and Error messages in Perl](/common-warnings-and-error-messages).
