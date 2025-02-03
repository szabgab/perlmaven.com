---
title: "Have exceeded the maximum number of attempts (1000) to open temp file/dir"
timestamp: 2017-11-22T09:30:01
tags:
  - random
  - fork
published: true
author: szabgab
archive: true
---


I have a Perl program that createse lots of forks (18 in parallel and about 2000 during its total lifetime).
I've noticed the following exception:

<pre>
Error in tempdir() using /tmp/XXXXXXXXXX: Have exceeded the maximum number of attempts (1000) to open temp file/dir at
</pre>


The following short script can reproduced the problem:

{% include file="examples/fork_and_tempdir.pl" %}

The higher the fork-count (in `$f`) and the higher the repeat-count in `$n` the more time we encounter the error.

The problem apparently is that the "random" temporary directory (or temporary files) is just going over a list
of pseudo-random numbers starting from the current `srand`. If the randomly created directory or filename already
exists then it will try the next one, but only up to 1,000 attempts. After that it throws an exception.

In our example we called `rand()` in our main code which calls `srand` the first time it is used in a process.
After that each fork continued to use the same random sequence.
If we remove the call to `rand()` then we don't get the exception any more.

The reason is that in that case the `rand()` is only called in the already forked processess (by tempdir) and thus each
forked process will set its own `srand()`.

This might be a "solution", but if for any reason we later add some code to the main part of the application that calls
`rand` then we get back to this problem.

The real solution is to call `srand()` explicitly in each one of the child processes. We have a commented out
line doing just that.

We have actually already encountered this problem in a different setting and described in 
[random numbers in forked processes](/random-numbers-in-forked-processes).

