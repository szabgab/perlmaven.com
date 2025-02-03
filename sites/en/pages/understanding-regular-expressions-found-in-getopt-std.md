---
title: "Understanding Regular Expressions found in Getopt::Std"
timestamp: 2015-04-25T09:00:01
tags:
  - regex
published: true
books:
  - beginner
author: szabgab
archive: true
---


Using regular expressions provides us with enormous power but reading and understanding
complex regular expressions is not an easy task. I noticed, for many people,
it feels much easier to write a regular expression than to read it.

This is probably true regardless of the host language but in Perl
we tend to use regexes much more than in other languages.


In my humble opinion, the ease of understanding regexes is just a question of practice.

If you practice it enough, you will stop seeing them as a set of random characters.

So in a number of writings I'll take regex examples from open source projects and
I'll try to understand and explain them. I don't have a clear path yet. I hope after
seeing and writing about a few examples I'll have a better understanding how to
explain the regexes and the process of understanding them in a coherent way.

Some of the regexes will be simple ones. I am still practicing the explanation too.

## Command line parameters

Looking at [Getopt::Std](https://metacpan.org/pod/Getopt::Std) I saw a line like this:

```perl
while (@ARGV && ($_ = $ARGV[0]) =~ /^-(.)(.*)/) {
```

The regex `/^-(.)(.*)/` is quite simple.
`^` at the beginning of the string there must be a
dash `-`. After that any character matched by `.`
and captured by the parentheses `(.)` into `$1`.
The `(.*)` will capture any leftover characters from the string.

So this regex will match things like "-a", "-abc", or "--xyz" (the (.) will match the 2nd dash), but it won't match "abc".

This is of course not surprising as the purpose of [Getopt::Std](https://metacpan.org/pod/Getopt::Std) is to handle
command line parameters with single leading dash.
(There are more [powerful ways](/advanced-usage-of-getopt-long-accepting-command-line-arguments)
to handle [command line parameters](/how-to-process-command-line-arguments-in-perl), but right now we only care about the regex.)

## Look-ahead assertion

Still in [Getopt::Std](https://metacpan.org/pod/Getopt::Std) I saw these two lines:

```perl
my (@witharg) = ($args =~ /(\S)\s*:/g);
my (@rest) = ($args =~ /([^\s:])(?!\s*:)/g);
```

The first one is very simple. `(\S)` captures a single non-white space character
then `\s*` will eat all white spaces (but does not require any)
and then a colon `:` is required. The whole thing is matched globally
(because of the `/g` at the end, and will return the non-whitespace characters
matched by `(\S)`.

So if `$args = 'a: b  : cde: +: -'`, the @witharg will be `('a', 'b', 'e', '+')`.

Those are the flags that need to come with a value.

I am not sure why does this code accept any non-word character as flag but
maybe that's just my conservative view.

The second regex is a bit more complex. It has two groups. The first one `([^\s:])`
captures a (single) character that is NOT white-space and NOT colon. (so it can be a letter
or another special character). The second group `(?!\s*:)` is a <b>zero-width negative
look-ahead assertion</b>. Disregard the `?!` and you will see it 
tries to match 0 or more white spaces followed by a colon.
The leading `?!` means that this is a zero-width negative look-ahead, which means there is either no colon after the
first group matched or if there is a colon it is separated by at least one non-space character from 
the match of the first group.

So if we try to match with the same string `'a: b  : cde: +: -'`
we'll get the list of the other non-whitespace and non-colon character:
`('c', 'd', '-')`


## Alternate

```perl
$has_pod = 1, last if /^=(pod|head1)/;
```

This code is easy. `^` - at the beginning there is an equal sign `=`
followed by either the word "pod" or the word "head1".

It is not checked if the string is =podcast  or =head123. Both of these will be accepted.

For more example look at the [regex cheat-sheet](/regex-cheat-sheet) and the links from there.
