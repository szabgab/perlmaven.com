---
title: "Perl One-liner: countdown on the command line:"
timestamp: 2021-04-10T10:30:01
tags:
  - Perl
  - $|
published: true
author: szabgab
archive: true
show_related: true
---


This one-line written in Perl will show a coundown on the command line: Try it.


<img src="static/img/countdown.gif" alt="countdown">

```
perl -e '$|=1; print "hi\n"; $sec = 180; while ($sec--) { printf "Starting in %3s seconds\r", $sec; sleep 1 }'
```

Explanation:

* -e tells perl to execute the string following it as perl code
* [$| = 1;](/output-autoflush) tells perl to avoid buffering STDOUT, that is to make every print arrive to the screen immediately
* <b>print "hi\n";</b> there only to be nice
* <b>$sec = 180;</b> sets the timer in seconds.
* The key however is that we print <b>\r</b> carrige return at the each of each print instead of <b>\n</b> newline. Thus each print overwrites the output of the previous one creating the effect of only the counter number changing.

<img src="static/img/countdown_wide.gif" alt="wide screen countdown">

