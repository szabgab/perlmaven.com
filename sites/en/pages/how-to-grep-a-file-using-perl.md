---
title: "How to grep a file using Perl"
timestamp: 2014-12-26T16:00:01
tags:
  - grep
  - regex
published: true
books:
  - beginner
author: szabgab
---


Perl has a [grep](/filtering-values-with-perl-grep) function which is a generalized version of the **grep** command-line
utility available on Unix/Linux systems. That `grep` function can filter values from a list of values or an array based on any kind of condition.

This article is not about the grep function.

This article is about finding certain strings in a file, just as the command-line grep does.


Writing a Perl replacement of the Unix grep command does not have much value, unless you do something
[much better](http://beyondgrep.com/), or if you want to [reimplement the Unix commands in Perl](https://metacpan.org/pod/PerlPowerTools).
Nevertheless it can be a good exercise, and it can be a learning or teaching aid. We'll do this first.

On the other hand, having similar functionality to the Unix `grep` as part of a larger script
might be very useful, and actually it happens quite often. We'll cover that later on.

## A grep-like script

This is mostly to experiment with regular expressions. The command line **grep** generally works like this:
`grep [options] REGEX FILEs`

The following script on the other hand works like this: `perl grep.pl FILEs`

Our `grep.pl` does not accept any options and the REGEX itself needs to be included in the script
replacing the word REGEX. It is much more limited, but it can be a good toy to play with regexes.

The reason I prefer to have the REGEX inside the script and not on the command line is that regexes use all kinds of special characters
that the Unix shell might also think it knows what to do with. Therefore we would need to add quotes around the regex and maybe escape
some of the characters. In general it would require an extra effort.

```perl
use strict;
use warnings;

die "Usage: $0 FILENAMEs\n" if not @ARGV;
foreach my $file (@ARGV) {
    open my $fh, '<:encoding(UTF-8)', $file or die;
    while (my $line = <$fh>) {
        if ($line =~ /REGEX/) {
            print $line;
        }
    }
}
```

Run the above script as `perl grep.pl` and it will tell you you need to pass a filename as a parameter.

In a nutshell, the script will receive the list of filenames provided on the command line,
in the [@ARGV](/argv-in-perl) array. We iterate over this list using [foreach](/perl-arrays).
We open each file using [open](/open-and-read-from-files) making sure we handle UTF-8 files properly.
Then we iterate over the lines using a [while loop](/while-loop). Then comes the interesting part.
For each line located in the `$line` variable, we check if it matches the given regular expression.
If there is a match we print the line. Just as the Unix grep would do.


## How to grep for an exact match of a string in a file using Perl?

If we are looking for a line that has a string exactly what we are looking for then we probably don't need to use
a regex at all. We would probably need to us the [index](/string-functions-length-lc-uc-index-substr) function.

```perl
    if (index $line, 'cat' >= 0) {
        print "This line has a 'cat' in it:\n";
        print $line;
    }
```


## Processing specific rows of a file

Of course just printing out the matching lines is not very interesting. If that's all we need to do,
can just use the existing Unix `grep` command.

It is much more interesting when we need to process certain lines of a file. For example in a log file
of a web server we would like to collect the IP address of of the clients who visited a specific
page. For this we would need to go over the lines of the file, as we do it above, but instead of printing the
line we would break it into parts, extract the IP address and put it in a hash.

We'll see such an example in a separate article.

## Comments

Here is a slightly modified version to emulate the output of a switchless grep

use strict;
use warnings;

if ($#ARGV < 1){die "Usage: $0 string FILENAMEs\n";}
my $exitcode = 1;
my $REGX = shift;
foreach my $file (@ARGV) {
    open my $fh, '<:encoding(UTF-8)', $file or die "$0: $file: No such file\n";
    while (my $line = <$fh>) {
        if ($line =~ /$REGX/) { $exitcode = 0;
                if ($#ARGV > 1){ print $file . ':' . $line;}
                else { print $line;}
        }
    }
}
exit $exitcode;

<hr>

is it true it has to be a file but not Unix pipe? Example: `grep -ri sometext * | pgrep.sh ".{0,80}"`
