---
title: "History in the Perl debugger, make the up arrow work"
timestamp: 2020-05-16T22:30:01
tags:
  - Term::ReadLine::Gnu
  - Term::ReadLine
  - ReadLine
  - debugger
  - -d
published: true
author: szabgab
archive: true
---


Perl comes with a built-in debugger that can be invoked by passing the `-d` flag to perl.

The default [Term::ReadLine](https://metacpan.org/pod/Term::ReadLine) that comes with
Perl does not provide history (pressing the up arrow) in the debugger.

You need to install [Term::ReadLine::Gnu](https://metacpan.org/pod/Term::ReadLine::Gnu) for that.


Probably the best way to install a Perl module is to use [cpanm](/cpanm).

```
cpanm Term::ReadLine::Gnu
```

If the above does not work check [how to install Term::ReadLine::Gnu](/install-term-readline-gnu).
