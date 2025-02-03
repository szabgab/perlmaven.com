---
title: "The diamond operator <> of Perl"
timestamp: 2015-09-11T09:34:04
tags:
  - <>
  - cat
  - grep
  - $_
  - eof
  - continue
published: true
author: szabgab
---


In some code you might see an operator that looks like this `&lt;&gt;`. At first you might be confused what
`less-than greater-than` mean together, or you might notice that it looks similar to the
[readline operator](/open-and-read-from-files), just without the filehandle in it.

This operator is called the <b>Diamond operator</b>.


## Diamond Operator

The Diamond operator is almost exclusively used in a while-loop.
It allows us to iterate over the rows in all the files given on the command line.

So this script

{% include file="examples/diamond_cat.pl" %}

if we run it as 

```
perl diamond_cat.pl FILE1 FILE2 FILE3
```

it will print the content of all 3 files line-by-line.

Just as the Unix `cat` command would do.


## Diamond operator explained

When perl reaches the `&lt;&gt;` the first time it looks at the content of [@ARGV](/argv-in-perl)
that, by default, contains the values passed on the command line. (Though we can actually change the content of
`@ARGV` while our script runs.)

It [shifts](/manipulating-perl-arrays) the first element to the `$ARGV` scalar variable,
opens the file that has its name in `$ARGV` and reads in the first line.

Subsequent encounters with `&lt;&gt;` will read in subsequent lines of the same file.

After the last line was read in from the current file, the next encounter with the diamond operator will
repeat the above operation starting by shifting the first value from `@ARGV` to `$ARGV`.

If there are no more entries in the `@ARGV` array, the diamond operator will return
[undef](/undef-and-defined-in-perl) and the `while` loop will exit.

If during the looping, one of the values in `@ARGV` is not an existing file, the
opening of that file will fail. A warning will be printed to
[STDERR, the standard error](/stdout-stderr-and-redirection) channel,
and the diamond operator will `shift` out the next element of the array.

As a special case, if at the time of the first encounter with `&lt;&gt;`, the `@ARGV` array
is empty (because we have not supplied anything on the command line, or because we have already emptied it),
then the diamond operator will fall back to act as `&lt;STDIN&gt;`, reading from the standard input.


## Diamond operator - grep-ish

The following example is a simple version of the Unix/Linux `grep` command:

{% include file="examples/diamond_grep.pl" %}

It iterates over the lines of the files given on the command line and prints out the ones that match
our regex. In this case I used an explicit variable `$line` where the diamond assigned the current line,
and I used the same variable in the regex and in the printing.

## Diamond - using $_, the default variable

We can make the above example even more compact by remembering that certain operation in Perl
will use [$_, the default variable of Perl](/the-default-variable-of-perl),
if no explicit variable is given.

{% include file="examples/diamond.pl" %}

In this example every time the Diamond Operator reads in a line, it assigns it to `$_`.
Then the regex matching will apply to `$_`, and finally, if there was a match, the
`print` function will print out the content of `$_`.

## Filename and line counter

It is nice to be able to iterate over the lines of multiple files at once, but often, during the iterations
we would like to know the name of the current file and the current line number. The next one is an almost good solution:

As mentioned earlier `$ARGV` contains the name of the file currently opened by the Diamond Operator.
In addition there is a variable `$.` (aka. `$INPUT_LINE_NUMBER` or `NR`) that contains the current line
number.

{% include file="examples/diamond_cat_full.pl" %}

It is an almost correct solution, but due to the way `$.` and the Diamond operator work,
the `$.` won't be reset after a file was exhausted and thus the counter will not show the line
number in the second file, but the total lines read so far. See the 
[documentation of $.](https://metacpan.org/pod/perlvar#pod17) and the
[solution using eof](https://metacpan.org/pod/perlfunc#eof).

{% include file="examples/diamond_cat_full.txt" %}

## Filename an fixed line counter

{% include file="examples/diamond_cat_full_close.pl" %}

Resulting in:

{% include file="examples/diamond_cat_full_close.txt" %}

