---
title: "Command line counter with plain text file back-end"
timestamp: 2015-03-28T15:41:02
tags:
  - ++
  - open
published: true
books:
  - counter
author: szabgab
archive: true
---


As part of the [big counter example project](https://code-maven.com/counter), this example runs on the command line and uses a plain text file as **back-end database**.
It is probably the most basic version of all the [counter examples](https://code-maven.com/counter), that provides a single counter.


## Front-end

The front end is the command line. We just run the script as `perl counter.pl`.

## Back-end

In this example the "database" is going to be a simple file called 'counter.txt' with only a number in it. The most recent value of the counter.

## Code

{% include file="examples/counter.pl" %}

After the initial statements to enable [strict and warnings](/always-use-strict-and-use-warnings), we have declared a variable called `$file` that holds the name of the 'database' file we are going to use to store the latest value of the counter. This could be declared as a [constant or read-only variable](/constants-and-read-only-variables-in-perl), but I did not bother.

During the execution of the script we will hold the value of the counter in the variable we cunningly called `$counter`. We declare it up-front and assign a default value of 0 to it.

Next we should be reading in the previous value of the counter. However, before we run the script for the first file, the file holding the number does not exist.  Hence we need to do two things.

<ol>
  <li>When we declare `$counter` using the `my` keyword we also initialize it to the default value of 0.
     This way, even if the counter.txt file does not exist yet we can pretend that the previous value 0.</li>
  <li>Then, before we attempt to open the 'counter.txt' file for reading, we check if it already exists using the `-e` operator.</li>
</ol>

Because at the first run the file does not exist, let's skip this code now and let's go straight to the part after the closing curly brace (`}`).

```perl
$count++;
print "$count\n";

open my $fh, '>', $file or die "Could not open '$file' for writing. $!";
print $fh $count;
close $fh;
```

Using `++` the auto-increment operator of Perl, we increment the value of `$count` (which started out as 0 during the first execution). Then we print it out to the screen.

In the 3 lines after that, we open the 'counter.txt' file for [writing](/writing-to-files-with-perl). In the first run this will create the file,
in subsequent runs this will clean up the file to have no content. Then we use the `print` statement to write the new content of `$count` into the now empty file.
Finally, just to be nice, we close the file handle using the `close` function.

On the second and later executions of the script, the 'counter.txt' file will already exist. Thus the `if (-e $file)` will return true, and we enter the block:

```perl
if (-e $file) {
    open my $fh, '<', $file or die "Could not open '$file' for reading. $!";
    $count = <$fh>;
    close $fh;
}

```

In this block we try to [open the file for reading](/open-and-read-from-files) using the `open` function and [throw an exception](/die) by calling the `die` function if we still cannot open the file. This should happen only in the most extreme situation and therefore it is ok to take drastic steps. If the `open` was successful, `$fh`, the newly declared variable will have the file handle in it. We can then use the `&lt;$fh&gt;` operator to read one line (the only one it has) from the file and finally we `close` the file.

## No need to initialize the counter


Actually when we declared the `$counter` variable it was not really necessary to also assign 0 to it. It looks better for people coming from other programming languages, but in Perl even if we left it [undef](/undef-and-defined-in-perl) the script would work perfectly well.

That's because when using the ++ [auto increment](/numerical-operators) operator on a variable that has `undef` in it, that `undef` will act as if it was actually 0. It is probably the simplest form of [autovivification](/autovivification) in Perl. So we could have written

```
my $counter;
```

## Comments

Good, quick increment method. Thanks! Quick question, and follow up...

What "newly declared variable $hl" to which you refer? Is that a typo for the $file(.txt name), or the $fh (file-handler), or for the newly declared $count variable, or is there something I'm missing here?

My situation is that I want a quick cycle-counter to determine how often I do a very slow operation on a bigger CSV database.

I have been trying everything I can to count the number of (fairly long, 1000-characters-in-100-fields) lines (records) in a fairly long (250,000-line) .CSV file very quickly so I can purge the oldest lines that exceed my pre-set line limit (established by an .INI variable I can adjust). BUT since there is no "fast" way of counting the number of lines in that huge file every time the script needs to reply to a URL request, I've decided it's better to set a "purge-frequency" variable expressing (in number of cycles) how often to actually count the total number of .CSV file-lines and initiate a purge of the overage -- say, once every 10,000 cycles, since 10k records (lines) more-or-less doesn't make a difference out of 250,000.

THUS, and now I finally reach the point here, sorry -- I need a quick little counter that increments a single integer in a single field in a simple text file, JUST LIKE you are showing here. And this I can do every cycle very quickly (I think...about to test it, LOL), and easily compare the counter tally to the INI cycle-frequency variable to see if it's time to check total lines in the big .CSV file (and if over, purge the excess, by splice removal of the oldest, i.e., first, records). The purge isn't the slow part -- the counting total lines in that file is the slow part, by any method I can find under the sun.

Am I correct in assuming that if I use your above on a very modern, multi-processor/core/thread CentOS NVMe-RAID machine that this -- your process above, of opening and incrementing a count in a 1-field TSV file -- should be virtually instantaneous for me? Any recommended changes you would make if it's going into a script that is part of a content-server? (Other than that we don't need to print to screen... )

Thanks for a good explanation. I often read your stuff, and you lay it out pretty well to be understandable.

<hr>


