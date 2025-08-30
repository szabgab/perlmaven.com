---
title: "Exercise: split HTTP GET request - video"
timestamp: 2015-07-30T10:02:24
tags:
  - regexes
  - m
types:
  - screencast
published: true
books:
  - beginner_video
author: szabgab
---


Exercise: split http


{% youtube id="2SIu_TffPVc" file="beginner-perl/exercise-split-http" %}

Given a string that looks like this:

```
my $str = 'fname=Foo&lname=Bar&email=foo@bar.com';
```

Create a hash where the keys are fname, lname, email or if the string looks like this:

```
my $str = 'title=Stargates&year=2005&chapter=03&bitrate=128';
```

then create a hash where the keys are title, year, chapter, bitrate Use a single statement (with split) to achieve this.

