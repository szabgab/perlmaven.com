---
title: "How much memory does my Perl application use?"
timestamp: 2013-12-12T12:45:01
tags:
  - Memory::Usage
  - Linux
published: true
books:
  - cook_book
author: szabgab
---


The other day I got a complain that my Perl script uses too much memory. So I needed a way to check it an monitor it.
I found [Memory::Usage](https://metacpan.org/pod/Memory::Usage) on CPAN.
Although it only work on **Linux** (not even on BSD or Mac OSX), but was quite useful there.


The basic usage of the module looks like this:

```perl
use strict;
use warnings;

use Memory::Usage;

my $mu = Memory::Usage->new();
$mu->record('starting work');

# my real code

$mu->record('after creating variable');

$mu->dump();
```

After creating the `Memory::Usage` object, each call to `record` will
record the current state of the memory usage of the current process. (Based on the process id,
so forked processes will not be measured separately.)

The call to the `dump` method will print out the data recorded.

Each row represents the data collected in one of the `record` calls. At the end of each row
we can see the text passed to the `record` method at each point.
The columns in parentheses show the changes of each measurement compared to the previous
recording.

The first row represent the baseline, after compiling all the script and loading
every modules with a `use` statement.

The second row after "my real code" was executed.

```
  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  18688 ( 18688)   2384 (  2384)   1756 (  1756)   1500 (  1500)    916 (   916) starting work
     0  18688 (     0)   2384 (     0)   1756 (     0)   1500 (     0)    916 (     0) after creating variable
```

We could add more calls to `record` at several stages of the application to see
at which stage we might see a sudden increase in memory usage.

In our basic case all the diffs were 0. Obviously, as we did not have any code between
the two calls to `record`

## Allocate memory

Let's try to run this again, this time we'll create a string between the two calls so
we replace "my real code" with

```perl
my $x = " " x 1024;
```

After running the script, the result is exactly the same as above. The diffs are still 0.
Apparently perl has already allocated some memory for future growth, so creating a
string with 1,024 bytes does not require further memory allocation from the system.

```perl
my $x = " " x 1024;
$x .= $x for 1..6;
say length $x;
```

```
65536
  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  18688 ( 18688)   2384 (  2384)   1756 (  1756)   1500 (  1500)    916 (   916) starting work
     0  18840 (   152)   2512 (   128)   1832 (    76)   1500 (     0)   1068 (   152) after creating variable
```

The above code created a string of 65,536 characters (64K). (That's the first number in the output.)
Then we can see how the various memory measurements changed. Values in the report are in kb.

vsz = **virtual memory size**,
rss = **resident set size**,
shared = **shared memory size**,
code = **text (aka code or exe) size**,
data = **data and stack size**

## Allocate more memory

4 Mb:

```perl
my $x = " " x 1024;
$x .= $x for 1..12;
say length $x;
```

```
4194304
  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  18688 ( 18688)   2384 (  2384)   1756 (  1756)   1500 (  1500)    916 (   916) starting work
     0  22876 (  4188)   6500 (  4116)   1836 (    80)   1500 (     0)   5104 (  4188) after creating variable
```

If we increase the range to be `1..21` that already creates a string with
2,147,483,648 (or 2Gb) characters in it. The result looks like this:

```
2147483648
  time      vsz (    diff)     rss (    diff) shared (  diff)  code (  diff)     data (    diff)
     0    18688 (   18688)    2384 (    2384)   1752 (  1752)  1500 (  1500)      916 (     916) starting work
     2  2115932 ( 2097244) 2099528 ( 2097144)   1836 (    84)  1500 (     0)  2098160 ( 2097244) after creating variable
```

In this example we also see the changes in time. Creating a 2Gb string
took 2 seconds for this script.


## Saving the results

Printing the results on the screen (on STDERR) as `dump` does, can be useful in an interactive
session, but if you'd like to record this information in the background you can use the
`report` method that returns the report as a string. Then you can
save it to a file.

`dump` is implemented as `print STDERR $mu->report();`


If you would like to create even finer-tuned reports, you can call the `state`
method to fetch the individual numbers. For example:

```perl
$mu->dump();
my $s = $mu->state;

use Data::Dumper;
print Dumper $s;
```

Created the following report:

```
  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  22092 ( 22092)   3704 (  3704)   1928 (  1928)   1500 (  1500)   2236 (  2236) starting work
     0  22092 (     0)   3704 (     0)   1928 (     0)   1500 (     0)   2236 (     0) after creating variable
$VAR1 = bless( [
                 [
                   1386844853,
                   'starting work',
                   22092,
                   3704,
                   1928,
                   1500,
                   2236
                 ],
                 [
                   1386844853,
                   'after creating variable',
                   22092,
                   3704,
                   1928,
                   1500,
                   2236
                 ]
               ], 'Memory::Usage' );
```

At the top you can see the report generated by the `dump` method. Below that
you can see the raw data. For further details see
[Memory::Usage](https://metacpan.org/pod/Memory::Usage).

## Test::Memory::Usage

Checking that your code does not use a lot of extra memory is useful, but you won't do it after every change.
If you could add this checking to your automatic tests though...

[Test::Memory::Usage](https://metacpan.org/pod/Test::Memory::Usage) is a wrapper around
[Memory::Usage](https://metacpan.org/pod/Memory::Usage) that you can use to makes
sure your module won't start to use a lot of memory later on. On Linux, at least.



