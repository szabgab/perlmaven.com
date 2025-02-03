---
title: "Carp::Always to find the source of the problem"
timestamp: 2021-02-18T11:30:01
tags:
  - Carp::Always
published: true
author: szabgab
archive: true
description: "warn and die tell us where a problem was noticed. carp and croak tell us where they were created."
show_related: true
---


In Perl <b>warn</b> and <b>die</b> tell us where a problem was noticed. <b>carp</b> and <b>croak</b> tell us where they were created.

[Carp::Always](https://metacpan.org/pod/Carp::Always) can help bridge the gap.


Recently my CI system of the Perl Maven web site reported the following error:

```
Can't decode ill-formed UTF-8 octet sequence <FF> at /usr/local/lib/perl5/site_perl/5.30.3/Path/Tiny.pm line 1801.
# Tests were run but no plan was declared and done_testing() was not seen.
# Looks like your test exited with 25 just after 263.
t/00-basic.t ..........
Dubious, test returned 25 (wstat 6400, 0x1900)
All 263 subtests passed
t/01-pages.t .......... ok
t/10-test-examples.t .. ok

Test Summary Report
-------------------
t/00-basic.t        (Wstat: 6400 Tests: 263 Failed: 0)
  Non-zero exit status: 25
  Parse errors: No plan found in TAP output
Files=3, Tests=1941,  0 wallclock secs ( 0.13 usr  0.02 sys +  0.57 cusr  0.10 csys =  0.82 CPU)
Result: FAIL
Error: Process completed with exit code 1.
```

OK, so there is some problem that cause [Path::Tiny](https://metacpan.org/pod/Path::Tiny) to die
and it happened in the t/00-basic.t file, but which call was it?
Where was the function that died called?

## use Carp::Always;

I have added the following to t/00-basic.t, my own test script (and to the list of dependencies as well), and pushed out the changes:

```
use Carp::Always;
```

The result (slightly shortened to make it clearer):

```
Can't decode ill-formed UTF-8 octet sequence <FF> at /usr/local/lib/perl5/site_perl/5.30.3/Path/Tiny.pm line 1801.
    Path::Tiny::slurp(undef, undef) called at t/00-basic.t line 31
# Tests were run but no plan was declared and done_testing() was not seen.
t/00-basic.t ..........
# Looks like your test exited with 25 just after 263.
```


OK, so now I know it is on line 31 of the test script. I can now figure out what happened there.

Now I "only" need to fix the bug.

