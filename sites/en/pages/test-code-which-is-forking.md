---
title: "Test code which is using fork"
timestamp: 2021-04-09T12:30:01
tags:
  - fork
  - Test::More
published: true
author: szabgab
archive: true
show_related: true
---


There are cases when you have some code using <b>fork</b> the question arises how to test them.

Here is a simple example:


The application that is forking:

{% include file="examples/test-fork/MyApp.pm" %}

The code to use it:

{% include file="examples/test-fork/use_my_app.pl" %}

Run it as

```
perl -I. use_my_app.pl
```

To turn on debug printing run it like this:

```
DEBUG=1 perl -I. use_my_app.pl
```

Here is a test script:

{% include file="examples/test-fork/test.t" %}

Run it as:

```
prove -I. test.t
```

