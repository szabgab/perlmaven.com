---
title: "Exercise: parse hours log file and create time report - video"
timestamp: 2015-08-03T10:20:01
tags:
  - regexes
types:
  - screencast
published: true
books:
  - beginner_video
author: szabgab
---


Exercise



{% youtube id="ICyJWvVAts4" file="beginner-perl/exercise-create-time-report" %}

The log file looks like this:

{% include file="examples/regex/timelog.log" %}

the report should look something like this:

```
09:20-11:00 Introduction
11:00-11:15 Exercises
11:15-11:35 Break ...
```

and

```
Solutions: 95 minutes 9%
Break 65 minutes 6% ...
```


