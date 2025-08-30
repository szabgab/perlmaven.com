---
title: "Changes and README files in a Perl distribution"
timestamp: 2017-03-17T07:00:11
tags:
  - Changes
  - README
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


The `Changes` and `README` files are two free-form files, though the the `Changes` files
usually have a common form. Recently work has been done to
create a [specification for the Changes file](https://metacpan.org/pod/CPAN::Changes::Spec).


{% youtube id="tlrm0Zm3Lr8" file="advanced-perl/libraries-and-modules/changes-and-readme" %}

Even the name of the Changes file is not standardizd. Some people write `CHANGES`,
others write `Changes`, yet others write `ChangeLog`.

It usualy includes entries for each release with the version number and date of release,
and then a list of major changes. Sometime indicating the bug number that were fixed or
the person who sent in those changes.

```
v0.02 2007.11.23

    Added feature for doing something
    Fixed strange bug causing trouble (#7)


v0.01 2007.10.12

    Releasing first version of Application
```


The README file used to be important before CPAN had a web interface, today it
is quite unclear what should be in it.

brian d foy had an
[article discussing this](http://blogs.perl.org/users/brian_d_foy/2015/01/what-should-be-in-a-cpan-distro-readme.html)


