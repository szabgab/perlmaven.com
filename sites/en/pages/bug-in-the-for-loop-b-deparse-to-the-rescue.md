---
title: "Bug in the for-loop of Perl? - B::Deparse to the rescue"
timestamp: 2014-02-27T12:01:01
tags:
  - B::Deparse
  - for
  - foreach
published: true
author: szabgab
---


The other day I got an email asking for my help. The reader had a short Perl snippet traversing two arrays.
One using the C-style `for-loop`, the other using Perl-style `foreach-loop`.

They acted differently.

A beginner would stare at it for a long time and not understand the problem. As he is not trusting
Perl yet, he might jump to the conclusion that there is a bug in Perl, or maybe that the
behavior of `for` has changed.

A seasoned Perl programmer would see the problem immediately. And he would be wrong.

Here is how you can find out what is the problem:


## The code

```perl
#!/usr/bin/perl

use strict;
use warnings;

my %hash = (
    'chr1' => [
        ['start','end','cat'],
        ['raj','end','cat']
    ],
    'chr2' => [
        ['start','end','cat'],
        ['start','end','cat']
    ]
);

print "Using C-ish for-loop syntax version\n";

foreach my $key (keys %hash) {
    my $j;
    my $i;
    print "$key: ";
    for ($i=0, $i < 2, ++$i ) {
        for ($j=0, $j<3, ++$j) {
             print "$hash{$key}[$i][$j]  ";
        }
    }
    print "\n";
}

print "\n\nUsing Perl-ish for-loop syntax version\n";

foreach my $key (keys %hash) {
    print "$key: ";
    for my $i (0..1) {
       for my $j (0..2) {
           print "$hash{$key}[$i][$j]  ";
       }
    }
    print "\n";
}
```

The output:

```
Using C-ish for-loop syntax version
chr1: end  end  end  end  end  end  end  end  end  
chr2: end  end  end  end  end  end  end  end  end  


Using Perl-ish for-loop syntax version
chr1: start  end  cat  raj  end  cat  
chr2: start  end  cat  start  end  cat 
```

When I got the script, first thing I checked if there is [use strict;](/strict)
`use warnings;`. There were. Great!

The indentation also looked good. So what can cause he different behavior?

For a second I thought about maybe `keys` returning the values in different order in the two calls,
but that probably should not happen, and even if that was the case, the result should not be this.

Interestingly the author of this code used `foreach` for the outer loops and `for` in the
4 inner loops. Twice he was using it in C-style, twice he was using it Perl-style. I am not sure
if he was aware that `for` and `foreach` are synonyms, and Perl knows which one to used
based on the syntax.

Anyway, I still did not know what is the problem, but there was one small thing bothering me. The declaration of
`$i` and `$j` are outside of the `for` loop in the first case. let's fix that and have
the following as the first loop:

```perl
foreach my $key (keys %hash) {
    print "$key: ";
    for (my $i=0, $i < 2, ++$i ) {
        for (my $j=0, $j<3, ++$j) {
             print "$hash{$key}[$i][$j]  ";
        }
    }
    print "\n";
}
```

Running the script now gave me this error:

```
$ perl for-each.pl 
Global symbol "$i" requires explicit package name at for-each.pl line 21.
Global symbol "$i" requires explicit package name at for-each.pl line 21.
Global symbol "$j" requires explicit package name at for-each.pl line 22.
Global symbol "$j" requires explicit package name at for-each.pl line 22.
Execution of for-each.pl aborted due to compilation errors.
```

What the ??? How did this happen?

I was quite frustrated by this time. You see I just woke up. Have not eaten anything yet.

Clearly Perl and I have a misunderstanding here.

So I wondered what does Perl think about this code.

## B::Deparse - the magic wand

That's where I brought in the magic wand, aka. [B::Deparse](https://metacpan.org/pod/B::Deparse).
It can tell me what Perl thinks I wrote.


So I ran the original script using B::Deparse:
`$ perl -MO=Deparse for-each.pl`


```perl
use warnings;
use strict;
my(%hash) = ('chr1', [['start', 'end', 'cat'], ['raj', 'end', 'cat']], 'chr2', [['start', 'end', 'cat'], ['start', 'end', 'cat']]);
print "Using C-ish for-loop syntax version\n";
foreach my $key (keys %hash) {
    my $i;
    my $j;
    print "${key}: ";
    foreach $_ ($i = 0, $i < 2, ++$i) {
        foreach $_ ($j = 0, $j < 3, ++$j) {
            print "$hash{$key}[$i][$j]  ";
        }
    }
    print "\n";
}
print "\n\nUsing Perl-ish for-loop syntax version\n";
foreach my $key (keys %hash) {
    print "${key}: ";
    foreach my $i (0 .. 1) {
        foreach my $j (0 .. 2) {
            print "$hash{$key}[$i][$j]  ";
        }
    }
    print "\n";
}
```

It replaced all for occurrences of `for` by `foreach`. That's strange. I would have expected it
to show the c-style for loops with the `for` keyword. Not only that, but if we take a closer look at
the first internal loop. It says  `foreach $_ ($i = 0, $i < 2, ++$i)`.
Why is it iterating over the `$_` the [default variable](/the-default-variable-of-perl)?

That's bad. I thought we are iterating over `$i`. And we are using `$i` in the expression
printing the value of the `%hash`.

That's when the light came on. Perl thinks we had a Perl-style `foreach` loop there while we wanted a C-style
`for` loop.

The way Perl can differentiate between the two loops is that the Perl-style `foreach` loop has a list of values
in the parentheses, while the [C-style for loop](/for-loop-in-perl) has 3 parts separated by `;`.

We had - by mistake - `,` (comma) separating the 3 parts of the `for` loop instead of `;`
(semicolon), and so Perl thought we meant a `foreach` loop iterating over the values
`$i=0`, `$i < 2`, and `++$i` instead of the C-style for loop.

A silly mistake, that causes this strange problem because of the duality of the for-loop in Perl.

## The fixed version

The correct way to write those internal for-loops are as follows. Including the move of `my`
inside the for expression.

```perl
foreach my $key (keys %hash) {
    print "$key: ";
    for (my $i=0; $i < 2; ++$i ) {
        for (my $j=0; $j<3; ++$j) {
             print "$hash{$key}[$i][$j]  ";
        }
    }
    print "\n";
}
```

## Conclusion

There are cases when we have disagreement with Perl. 
[B::Deparse](https://metacpan.org/pod/B::Deparse) can help us understand what
Perl though of our code.

