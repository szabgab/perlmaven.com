---
title: "Why does this code not work? (split, array slice)"
timestamp: 2018-02-20T12:30:01
tags:
  - split
published: true
author: szabgab
archive: true
---


What to do when you try to split a string and get several fields at once but it does not work?

I've received the following two examples in a short intervallum asking <b>Why does this code not work?</b>.


In order to answer the questions I actually need to know what is the expected result, something the person asking this question missed to provide, but luckily in these examples it seemed to be obvious.

I got two snippets and ran both of them:

{% include file="examples/split_on_the_fly.pl" %}

(The HERE marks were in the code when I got it.)

```
$ perl split_on_the_fly.pl
root

```

In this case the author wanted to split the `$str` string and copy the fields
0 and 4. Effectively doing what I called [split on the fly](/perl-split).

{% include file="examples/array_slice_not_working.pl" %}

```
$ perl array_slice_not_working.pl
root

```

In the second example, apparently in an attempt to simplify the code and find the problem
that way, the author has first created an array from the list returned by the
[split](/perl-split) and then tried to use [array slicing](/array-slices).


The solution is in [another article](/why-does-this-code-not-work-solution).

## Comments

my $str = "root:*:0:0:System Administrator:/var/root:/bin/sh";
my @fields = split /:/, $str;

$num="0,4";
my ($username, $real_name) = @fields[split /,/,$num];

print "$username\n";
print "$real_name\n";

This code working....

<hr>

Why would anyone try to use a string to specify the indexes? This works as expected if ones replaces the string with an array of numbers, i.e.:

my @indexes=(0,4);

