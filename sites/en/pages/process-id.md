---
title: "$$, $PROCESS_ID, $PID- The process number of the current script / program / executable."
timestamp: 2021-02-23T18:30:01
tags:
  - $$
  - $PROCESS_ID
  - $PID
published: true
author: szabgab
archive: true
show_related: true
---


The process number of the current script / program / executable. Natively Perl provieds the **$$** variable, but if you load the [English](/english) module
you can also use the **$PROCESS_ID** or the **$PID** variable names for the same thing.


See also [Forking, Process ID, Parent Process ID, init](/forking-pid-ppid)

{% include file="examples/process_id.pl" %}

```
1228561
1228561
1228561
```

[perldoc](https://metacpan.org/pod/perlvar#$PROCESS_ID)

