---
title: "Random numbers in forked processes"
timestamp: 2014-02-21T10:00:01
tags:
  - fork
  - rand
  - srand
  - Parallel::ForkManager
published: true
author: szabgab
---


If you'd like to get random floating-point numbers in Perl you can use the `rand()` function. It returns a value between 0 and 1.
0 inclusive and 1 exclusive. I think mathematicians would write it this way: `[0, 1)`

```
perl -E 'say rand'
0.933151337857456
```

Actually you can also write `rand(6)` that will return a floating-point number between 0 and 6. (`[0, 6)`)

```
$ perl -E 'say rand(6)'
2.20041864735506
```

What happens when we use [fork()](/fork) or
[Parallel::ForkManager](https://metacpan.org/pod/Parallel::ForkManager) to create child processes?


## Quick solution

Call `srand();` in the child process, immediately after forking.

## Fork and rand

If we create a small script that will fork n=3 times and call `rand()` in each child process
we can see it nicely prints out 3 random numbers: (tried in 5.18.2)

{% include file="examples/rand_in_fork.pl" %}

```
Child 12943 generated  0.0551759396485103
Child 12944 generated  0.0385383724506063
Child 12945 generated  0.804002655510889
```

What happens if we change the code slightly enabling that line that was commented out earlier?

```
Parent 12956 generated 0.873379828947694
Child  12957 generated 0.962009316167922
Child  12958 generated 0.962009316167922
Child  12959 generated 0.962009316167922
```

Now the parent generates a random number before the forks happen, but then the 3 child process return the
same random number.

## Calling srand

The problem is that actually rand() returns a pre-defined series of numbers. The reason they look random to us
is because every time we run our script, it will start from a different location in the series.

The thing that controls the starting point is the `srand()` function. Try the following:

```
$ perl -E 'srand(42); say rand()'
0.744525000061007

$ perl -E 'srand(42); say rand()'
0.744525000061007

$ perl -E 'srand(42); say rand()'
0.744525000061007

$ perl -E 'srand(42); say rand()'
0.744525000061007
```

Every run of the script gives you the same "random" number.

If on every call we call `srand` with a different number, `rand()` will also return
us a different "random" number.

```
$ perl -E 'srand(1); say rand()'
0.0416303447718782

$ perl -E 'srand(2); say rand()'
0.912432653437467

$ perl -E 'srand(3); say rand()'
0.783234962103055

$ perl -E 'srand(4); say rand()'
0.654037270768644
```


## Calling srand with a random number

That's good, but how can we generate a random input to `srand()`.
We can't really, but we can get something much better. We can pass it the current time,
maybe combined with the current process id (provided in `$$`).


```
$ perl -E 'srand(time+$$); say rand()'
0.642138507058011

$ perl -E 'srand(time+$$); say rand()'
0.512940815723599

$ perl -E 'srand(time+$$); say rand()'
0.383743124389188

$ perl -E 'srand(time+$$); say rand()'
0.866952359051542
```

## The problem explained

Perl calls `srand()` on your behalf when you first call `rand()`
that's how in a normal script the numbers seem to be random, and they are different
in every run of the script.
In our first example we called `rand()` first time in the child process and
thus each process called `srand()` for us. The numbers were random.

In the second example we called `rand()` in the parent process already and the
child processes did not call it again. So they all followed the random series
from the same point. That's why they returned the same "random" numbers.

The solution is to call `srand()` or `srand(time+$$)` in the child process
immediately after forking.

```perl
use strict;
use warnings;
use 5.010;

say "Parent $$ generated " . rand();
my $n = 3;
for (1 .. $n) {
    my $pid = fork();
    if (not $pid) {
       srand();
       say "Child  $$ generated " . rand();
       exit;
    }
}

for (1 .. $n) {
   wait();
}
```

The result is:

```
Parent 13050 generated 0.873155701746331
Child  13052 generated 0.73201028381391
Child  13053 generated 0.61498113216749
Child  13051 generated 0.877628553033905
```

## Warning

Let me just repeat here what the documentation of `rand` also says:

<b>"rand()" is not cryptographically secure.  You should not rely on it in security-sensitive situations.</b>

## Comments

Is seeding srand with time+$$: the best option? As time is in seconds (and therefore potentially different by 1 for child processes) and process number is often going to be sequential for child processes, you are possibly going to occasionally get child processes seeded with the same number.


