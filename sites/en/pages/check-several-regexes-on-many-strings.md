---
title: "Check several regexes on many strings"
timestamp: 2014-09-02T13:50:01
tags:
  - regex
  - qr
  - DATA
  - __DATA__
  - last
  - next
  - LABEL:
  - List::MoreUtils
  - all
types:
  - screencast
published: true
author: szabgab
---


Once in a while I have to go through lines of a file that match 2, and sometimes even more regexes.

If there only two regexes: A and B, one might be tempted to combine the two something like this:

```perl
/A.*B|B.*A/
```

but that just create a regex that is much more complex that necessary and one that is also probably much slower.

The solution could be as simple as writing

```perl
while (my $line = <$fh>) {
    if ($line =~ /A/ and $line =~ /B/) {
        print $line;
    }
}
```

But what happens if there are more than one regexes?


{% youtube id="5NzC66Lv1gg" file="check-several-regexes-on-many-strings" %}

What if we have 5-10 regexes and we would like to filter the rows that match <b>all of them</b>?

First of all, we need to store these regexes somehow. Probably the best approach is to store them in an array
as already compiled regex objects. That's what the `qr` operator will do for us.

```perl
my @regex = (qr/A/, qr/B/, qr/C/, qr/D/, qr/E/);
```

Once we have an array of regexes, we need to compare every line in the file with every regex. We could do it either way:
We could go over each regex and for each regex go over every line, but that would mean we have to read in the file N times
where N is the number of regexes. As IO is much slower than any operation in memory, it is probably better to do it the other
way around: Iterate over the lines of the file, and for every line go over all the regexes.

```perl
while (my $line = <DATA>) {
    foreach my $r (@regexes) {
        if ($line =~ $r) {
        }
    }
}

__DATA__
Lorem Ipsum is simply dummy text of the printing and typesetting industry.
Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,
when an unknown printer took a galley of type and scrambled it to make a type
specimen book. It has survived not only five centuries, but also the leap
into electronic typesetting, remaining essentially unchanged. It was
popularized in the 1960s with the release of Letraset sheets containing Lorem
Ipsum passages, and more recently with desktop publishing software
like Aldus PageMaker including versions of Lorem Ipsum.
```

We also use the `DATA` built-in file-handle which allows us to treat the <b>end of the script after the __DATA__ mark</b> as a file and read it line-by line.
There we put a few lines of text copied from [Lorep ipsum](http://www.lipsum.com/) web site. (In the coming examples, I'll skip the part after the __DATA__
mark, but in order to run the script, please add it back.)

The question remains, how can we indicate that <b>every</b> regex has matched?

## Count the matching regexes

One way is to count the matching regexes and then compare the result to the total number of regexes. If they are equal,
then the line should be printed:

```perl
use strict;
use warnings;
use 5.010;

my @regexes = (qr/Lorem/, qr/Ipsum/, qr/a/);

while (my $line = <DATA>) {
    my $matched = 0;
    foreach my $r (@regexes) {
        if ($line =~ $r) {
            $matched++;
        }
    }
    if ($matched == scalar @regexes) {
        print $line;
    }
}

__DATA__
```

Running this script will print:

```
Lorem Ipsum is simply dummy text of the printing and typesetting industry.
Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,
like Aldus PageMaker including versions of Lorem Ipsum.
```

The 3 lines that match all 3 regexes.

This solution works, but there are other solutions that are more compact and faster.

## Short-circuit with flag

We could short-circuit checking the regexes. After all there is no reason to go over all
the regexes if we have already found one that does not match. If there is one that does not
match, we already know the final answer will be no. For this to work, instead of counting the
matches, we will leave the internal loop early using the `last` keyword if a regex fails.
In this case we will need a way to indicated we left the loop early. For example we could have
a flag called `$failed` that will be turned on when one of the regexes fail.

```perl
use strict;
use warnings;
use 5.010;

my @regexes = (qr/Lorem/, qr/Ipsum/, qr/a/);

while (my $line = <DATA>) {
    my $failed = 0;
    foreach my $r (@regexes) {
        if ($line !~ $r) {
            $failed = 1;
            last;
        }
    }
    if (not $failed) {
        print $line;
    }
}

__DATA__
```

The result is the same as earlier.

It looks quite obvious that this version will run faster than the previous one, especially if there are many regexes,
but we might want to measure it using Benchmark. (Actually, in a real-life situation, if the lines are really read from
an external file, then the speed improvement might not be measurable as the I/O-operation reading from the file might be
a a factor of two bigger than any speed improvement. On the other hand, if the data comes from the memory, as in our example,
then we will probably see the speed improvement.)

This second solution is then faster, but it has the same length of code. Besides, that `$failed` flag just feels a bit
cumbersome. We could improve this script by using a <b>label</b> on the outer loop.

## Short-circuit with label

We put the `LINE:` label in-front of the outer loop. This allows us to call `next LINE` in the inner-loop
and thereby skipping all the code till the outer loop. Including the `print` statement. This we we don't need to manually
keep track of the `$failed` status of the current line. If one of the regexes fail on the current line, we go to the "next LINE".
If we have exhausted all the regexes and have not skipped to the "next LINE" yet, it means all the regexes have matched.

```perl
use strict;
use warnings;
use 5.010;

my @regexes = (qr/Lorem/, qr/Ipsum/, qr/a/);

LINE:
while (my $line = <DATA>) {
    foreach my $r (@regexes) {
        if ($line !~ $r) {
            next LINE;
        }
    }
    print $line;
}

__DATA__
```

This solution should be similar to the previous one speed-wise, but it is shorter and more readable.

Actually, we might even use the statement-modifier syntax and write:


```perl
    next LINE if $line !~ $r;
```

instead of

```perl
    if ($line !~ $r) {
        next LINE;
    }
```

making the code even shorter and probably more readable.

This is the point where less experienced Perl programmers might say: "Hoho, slowly with that knife!". If most of the people are
not experienced Perl developers, and if you don't want them to learn such syntax, then you might want to stick to the 3-line long,
but more well-known syntax.


## all from List::MoreUtils

The above code is still a bit too long and a bit too complex. Instead of that label-thingy, we could employ one of the
special functions from [List::MoreUtils](https://metacpan.org/pod/List::MoreUtils). Specifically the
`all` function. It will iterate over a list of value. In each iteration it will put the current value in 
`$_` and execute the given block. The `all` function will return [true](/boolean-values-in-perl)
if `all` the executions returned true. If at least one fails, it will return false. Exactly what we need.

```perl
use strict;
use warnings;
use 5.010;

use List::MoreUtils qw(all);
my @regexes = (qr/Lorem/, qr/Ipsum/, qr/a/);

while (my $line = <DATA>) {
    if (all { $line =~ $_ } @regexes) {
        print $line;
    }
}

__DATA__
```

This solution is shorter, and for people who know how to read this kind of syntax it is also more readable.
The only questions that remain are: How fast is it? Is all short-circuiting?

The answer to the second question is yes, <b>all, is short-circuiting</b>, but if you want to answer the speed-question
you'll have to measure it yourself.

