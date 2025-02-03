---
title: "Count the frequency of words in text using Perl"
timestamp: 2013-11-21T12:07:01
tags:
  - hash
  - open
  - /g
  - split
published: true
books:
  - beginner
author: szabgab
---


Counting how many times a given (sub)string appears in a given text is a very common
task where Perl is a perfect fit.

It can be counting the word density on a web page,
the frequency of DNA sequences,
or the number of hits on a web site that came from various IP addresses.



## Impatient?

Here is an example counting the frequency of strings in a text file.
The following script counts the frequency of strings separated by spaces:

{% include file="examples/count_words.pl" %}

## The task

The task basically has 3 parts:
<ol>
<li>Go over the (sub)strings one-by-one.</li>
<li>Store the number of occurrence of each string in a hash.</li>
<li>Generate the report.</li>
</ol>

We won't spend a lot of time on the report part. We assume that each string we want
to count is less than 30 characters long so they will comfortably fit in one
line of the screen together with the number of occurrence.

A hash is a perfect place to store the counters: the keys will be the string we count
and the values will be the number of occurrence.

## Sort the results according to the ASCII table

Given the data in a hash called `%count` we can display the results like this:

```perl
foreach my $word (sort keys %count) {
    printf "%-31s %s\n", $word, $count{$word};
}
```

In this case the strings are sorted according to the ASCII table.

## Sort the results according to frequency

The `sort { $count{$a} <=> $count{$b} }` statement will sort
the strings based on the values in ascending (growing) order. The call to `reverse`
in front of the `sort` will make sure the results are in descending order.

```perl
foreach my $word (reverse sort { $count{$a} <=> $count{$b} } keys %count) {
    printf "%-31s %s\n", $word, $count{$word};
}
```

## Store the number of occurrence of each string

Now that we know how we are going to print the results,
let's assume the words are given in an array.

{% include file="examples/store_number_of_occurances.pl" %}

We iterate over the elements of the array using `foreach`
and increment the counter of the current string. At first the
hash is going to be empty. When we first encounter the string 'hello'
`$count{$str}` will not yet exists. Luckily if we access a hash
element where the key does not exists yet, Perl will return 
[undef](/undef-and-defined-in-perl).

Then we are trying to increment that undef using `++`.
In numerical operations, such as `++` and undef will behave as if
it was a `0`. Though in most cases the operation on 
[undef](/undef-and-defined-in-perl) will
generate a 
[Use of uninitialized value](/use-of-uninitialized-value)
warning, but `++`, the auto-increment operator is an exception.
Perl will silently increment the undef to be 1, it will create the necessary
key in the hash and assign the new value (which is `1`). This is a simple
case of [autovivification](/autovivification).

In subsequent cases, when we encounter the same string, the counter will be just simply
incremented by one.

The result is:

```
Perl                            1
hello                           2
world                           1
```

With this we covered both collecting the data and reporting it.

Now comes the most diverse part of the whole task. How can we go over the strings
if they are not spoon-fed to us in an array?

## Counting words in a string

If we have a string in the memory and we would like to count the words in it
we can get turn the string into an array of strings:

```perl
my $text = "hello world hello Perl";
my @strings = split / /, $text;

foreach my $str (@strings) {
    $count{$str}++;
}
```

and we are back to our previous task.

`split / /, $text` will cut up the content of `text` every
place there was a single space character.

## No need for temporary array

We don't even need that temporary array to hold the strings, we could write:

```perl
my $text = "hello world hello Perl";

foreach my $str (split / /, $text) {
    $count{$str}++;
}
```

## More spaces

If we want to allow for more than one space between the strings we can use
`/\s+/` in the split.

## Strings in a file

If we need to count the strings in a file we first need to read the
content of the file into memory. We could read the whole file and create
a single array of all the words before starting to count, but that would be
extra work for us and if the file is big, like really big, then it won't fit
in the memory of our computer.

It is usually better to process the file line-by-line like in the following
example:

{% include file="examples/strings_in_a_file.pl" %}

## Extracting real words

In the above example we simply split up
each line into substrings where we saw a space.

What if we would like to count the real words?

Well, it is not easy to extract words in any arbitrary 
spoken language so we'll do something much more simple.
We count each stretch of "word-characters", where 
"word-character" means Latin letters (a-zA-Z),
Arabic numbers (0-9) and universal underscore (_). In other
words, whatever `\w` matches.

The only change we have to do is the way we extract the strings
from the line. Instead of a call to `split`:

```perl
    foreach my $str (split /\s+/, $line) {
```

we use a regex matching in list context using the `/g`
global flag:

```perl
    foreach my $str ($line =~ /\w+/g) {
```


Just to clarify, in case the above construct looks strange,
the same can be written in two lines:


```perl
    my @strings = $line =~ /\w+/g;
    foreach my $str (@string) {
```

## Comments

How to generate a output.txt file for the above mentioned code

use strict;
use warnings;

my %count;
my $file = shift or die "Usage: $0 FILE\n";
open my $fh, '<', $file or die "Could not open '$file' $!";
while (my $line = <$fh>) {
chomp $line;
foreach my $str (split /\s+/, $line) {
$count{$str}++;
}
}

foreach my $str (sort keys %count) {
printf "%-31s %s\n", $str, $count{$str};

----

Why not search on this site how to write to a file and then solve it yourself?

<hr>

noob to perl is there a better way for achieving this?

#!usr/bin/perl -w

#takes a sting
#returns a character that is most repeated ignoring case
# if the two character are repeated same max number of times returns in character that is ASCII lower

sub max_alphainhash{

foreach $chare (split (//,lc $_[0])){
$symbols{$chare}++ if ($chare=~ m/[a-z]/)
}

foreach $i ( reverse sort{$symbols{$a} <=> $symbols{$b}|| $b cmp $a } keys %symbols) {
return $i
}
}

print(max_alphainhash ("%,d0090900012930()sdfkkbbajj"));

