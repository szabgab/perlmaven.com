---
title: "undef - defined - true -false"
timestamp: 2021-03-23T08:30:01
tags:
  - false
  - true
  - undef
  - defined
published: true
author: szabgab
archive: true
description: "defined checks if a variable is undef or not, this is different from being true or false."
show_related: true
---


The [defined](/defined) function checks if a variable is [undef](/undef) or not.
This is different from being evaluated to [true](/true) or [false](/false).


See also the explanation about [boolean values](/boolean-values-in-perl) in Perl.

```
          defined?      if ()

undef        no          no
0            yes         no
0.00         yes         no
''           yes         no
my @arr;     N/A         no
my %h;       N/A         no
1            yes         yes
'0'          yes         no
'00'         yes         yes
```


