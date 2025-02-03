---
title: "Perl::Version vs version confusion"
timestamp: 2015-12-04T16:30:01
tags:
  - Perl::Version
  - version
  - $VERSION
published: true
author: szabgab
archive: true
---


[Version numbers should be boring](http://www.dagolden.com/index.php/369/version-numbers-should-be-boring/)
and modules such as [version](https://metacpan.org/pod/version)
and [Perl::Version](https://metacpan.org/pod/Perl::Version) should be boring too.

Yet they are confusing me.


{% include file="examples/sort_version_confusion.pl" %}

And the output

```
Perl::Version: 1.013
version:       0.9912
----
5.11
v5.11
5.011
5.11
----
v5.11
5.011
5.11
5.11
```

I am not yet sure which module is confused, but I am, for sure.


It seems that `Perl::Version` thinks that `5.11` and `v5.11` are the same
while `version` thinks they are different.

Not only that, but Perl::Version seems to thin `5.11` equals to `5.011`.
I am fairly sure that should not be the case.

{% include file="examples/version_compare_confusion.pl" %}

