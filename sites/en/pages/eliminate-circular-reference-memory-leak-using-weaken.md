---
title: "Eliminate circular reference memory-leak using weaken"
timestamp: 2013-12-13T15:30:01
tags:
  - Scalar::Util
  - weaken
  - Memory::Usage
published: true
author: szabgab
---


The data structures of Perl are very flexible which means it is easy to
create circular reference.
Unfortunately when these data structures go out of scope the
reference-counting garbage collector of Perl won't clean up the mess.

Unless we explicitly weaken one of the links.


## Example with memory leak

An easy example that creates a circular reference is the following:

```perl
sub create_pair {
    my %x;
    my %y;
    $x{other} = \%y;
    $y{other} = \%x;

    return;
}
```

Each hash has a value referring to the other hash. When the function
finishes and the variables `%x` and `%y` go out of scope,
they won't be destroyed and removed from memory as each one still
has a reference leading to it.

Yet the main body of code cannot reach them any more.

## Solution: weaken one of the references

For the impatient type here is how to avoid it:

```perl
use Scalar::Util qw(weaken);

sub create_pair {
    my %x;
    my %y;
    $x{other} = \%y;
    $y{other} = \%x;
    weaken $y{other};

    return;
}
```

## Prove it!

OK, so we know how to eliminate the problem, but does this really work?
Was there even a memory leak?

We'll use [Memory::Usage](https://metacpan.org/pod/Memory::Usage)
module we already saw when we checked
the [memory usage of a Perl script](/how-much-memory-does-the-perl-application-use).

Here is the test script:

```perl
use strict;
use warnings;
use 5.010;

use Memory::Usage;
#use Scalar::Util qw(weaken);

my $mu = Memory::Usage->new();
$mu->record('before');

create_pair() for 1..10000;

$mu->record('after');

$mu->dump();

sub create_pair {
    my %x;
    my %y;
    $x{other} = \%y;
    $y{other} = \%x;
    #weaken $y{other};

    return;
}
```

That is. We `record` the memory usage before and after running the function 10,000 times.
(There are two commented out lines in the code. That's the solution.)

The result is:

```
  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  21040 ( 21040)   2712 (  2712)   1860 (  1860)   1500 (  1500)   1180 (  1180) before
     0  24604 (  3564)   6136 (  3424)   1920 (    60)   1500 (     0)   4744 (  3564) after
```

If you read the [other article](/how-much-memory-does-the-perl-application-use)
then you already know, the diff column
indicates the change in memory consumption, and when it grows too much, that's not a good sign.

Of course your application might not call the problematic function 10,000 times, and you
might be ok with an extra 15% memory usage for a short-lived script, but for bigger
applications, especially ones that need to run for a long time, you'll try to
eliminate every memory leak.

BTW I checked, and I already saw the symptoms after 380 calls.


## Check the weakened version

Now if we remove the `#` characters, enable the `weaken` function call,
and run the script again the result is:

```
  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  21040 ( 21040)   2708 (  2708)   1860 (  1860)   1500 (  1500)   1180 (  1180) before
     0  21040 (     0)   2708 (     0)   1860 (     0)   1500 (     0)   1180 (     0) after
```

No increase in memory usage even after 10,000 iterations.

(Just a reminder: unfortunately Memory::Usage only works on Linux.)

## How to use this?

We don't yet have a tool to easily find the cause of a memory-leak, but we have
`Memory::Usage` that we can use to try to locate the area of code where
the memory usage suddenly jumps.

Then, if we try to see if there are data structures with circular reference
and weather those are causing the excessive memory usage.







