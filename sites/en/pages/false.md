---
title: "false"
timestamp: 2021-03-23T08:00:01
tags:
  - false
published: true
author: szabgab
archive: true
description: "There is no special value that means false in Perl. There are certain values that evaluate to false in boolean context."
show_related: true
---


There is no special [boolean values](/boolean-values-in-perl) in Perl that would mean <b>false</b> or <b>true</b>.
There are certain values that evaluate to false or [true](/true) in boolean context.


The values that evaluate to false in boolean context in Perl are [undef](/undef), the number 0 (also when written as 0.00),
the empty string, the empty array, the empty hash. In general anything that is considered to be empty.
Everything else evaluates to <b>true</b>.

```
undef
0
0.00
''
'0'
my @arr;
my %h;
```

{% include file="examples/boolean.pl" %}

The output will be:

```
undef is false
empty array is false
empty hash is false
0 is false
0 is false
 is false
0 is false
00 is true
0
 is true
ARRAY(0x55e25f1ce470) is true
HASH(0x55e25f1f1080) is true
true is true
false is true
```

(When printing "0\n" the "is true" part was printed on the next row because of the newline we print.)


## Boolean context

Boolean context means an <b>if statement</b>, and <b>unless</b> statement. The conditional of a <b>while</b> loop,
a ternary operator, etc.


## undef and being defined


Being "[defined](/defined)" or being "[undef](/undef)" have different meaning in Perl.

