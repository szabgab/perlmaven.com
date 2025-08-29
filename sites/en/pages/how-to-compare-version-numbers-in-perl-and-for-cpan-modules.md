---
title: "How to compare version numbers in Perl and for CPAN modules"
timestamp: 2017-08-09T09:00:01
tags:
  - Perl::Version
  - version
  - $VERSION
published: true
author: szabgab
archive: true
---


Version numbers are very flexible in Perl and unfortunately people have been abusing this freedom.
even though [Version numbers should be boring](http://www.dagolden.com/index.php/369/version-numbers-should-be-boring/).


A couple of examples for version numbers:

```
5.010
v5.10
5.010.002

1.10
1.10_02

1.10_TEST
```


You might also know that `5.010` is the same as `v5.10` which creates a great deal of confusion to
people who are not aware of this.

There are at least two modules that handle version numbers: [version](https://metacpan.org/pod/version)
and [Perl::Version](https://metacpan.org/pod/Perl::Version), but it seems only the
[former works properly](/perl-version-number-confusion).

So I recomment the **version** module.

It [operator overloading](https://metacpan.org/pod/overload) to allow us to use the various numerical
comparision operators such as `&gt;`, `&lt;` and even the spaceship operators `&lt;=&gt;`
to sort a bunch of version numbers.

{% include file="examples/version_example.pl" %}

It seems to be working properly as the following cases show:

{% include file="examples/version.pl" %}

You can also sort version numbers:

{% include file="examples/sort_versions.pl" %}

## Invalid version format

The module will not properly parse the last example:

```
say version->parse('1.23_TEST');
```

Will generate an excpetion  saying **Invalid version format (misplaced underscore) at ...**

## Comments

Hello Gabor,
I'm sorting versions in my perl script and using the latest v5.10.1 but seeing the following error pop up " contains invalid data; ignoring: ", is this because of the perl version?

---

What is in the string you are parsing that gives you this error message?

---

I'm a newbie at perl in the learning process and i'm trying to sort the versions i'm passing from the @versions array and it gives the error.

---
Please show the actual source code, from this I cannot guess.

