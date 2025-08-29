---
title: "Filtering values using Perl grep"
timestamp: 2012-09-02T18:45:56
description: "Perl grep { CONDITION } LIST a generalization of the Unix grep function to filter values of a list with any condition"
tags:
  - grep
  - filter
  - any
  - List::MoreUtils
  - <>
  - glob
published: true
books:
  - advanced
author: szabgab
---


The internal **grep** function of Perl is a **filter**. You give it a list of values
and a condition, and it returns a sublist of values that yield true for the given
condition.
It is a generalization of the grep or egrep commands we know from UNIX and Linux,
but you don't need to know these commands in order to understand the grep of Perl.


The `grep` function takes two arguments. A block and a list of values.

For every element of the list, the value is assigned to `$_`, the
[default scalar variable of Perl](/the-default-variable-of-perl),
and then the block is executed. If the return value of the block is `false`, the value
is discarded. If the block returned `true` the value from the list is kept as one
of the return values.

Pay attention, there is no comma between the block and the second parameter!

Let's see a few examples for grep:

## Filter out small numbers

```perl
my @numbers = qw(8 2 5 3 1 7);
my @big_numbers = grep { $_ > 4 } @numbers;
print "@big_numbers\n";      # (8, 5, 7)
```

This grep passes the values that are greater than 4,
filtering out all the values that are not greater than 4.


## Filter out the new files

```perl
my @files = glob "*.log";
my @old_files = grep { -M $_ > 365 } @files;
print join "\n", @old_files;
```

`glob "*.log"` will return all the files with a .log extension in the current directory.

`-M $path_to_file` returns the number of days passed since the file was last modified.

This example filters out the files that have been modified within the last year,
and only let's through files that are at least one year old.

## Is this element in the array?

Another interesting use of `grep` is to check if an element can be found in an array.
For example, you have a list of names and you would like to know if the given name is in the list?

```perl
use strict;
use warnings;

my @names = qw(Foo Bar Baz);
my $visitor = <STDIN>;
chomp $visitor;
if (grep { $visitor eq $_ } @names) {
   print "Visitor $visitor is in the guest list\n";
} else {
   print "Visitor $visitor is NOT in the guest list\n";
}
```

In this case the grep function was placed in
[SCALAR context](/scalar-and-list-context-in-perl).
In SCALAR context `grep` will return the number of elements that went through the filter.
As we are checking if the `$visitor` equals to the current element this grep
will return the number of times that happens.

If that's 0, the expression will evaluate to false, if it is any positive number then it will evaluate to true.

This solution works, but because it depends on the context it might be unclear to some people.
Let's see another solution using the `any` function of the
[List::MoreUtils](https://metacpan.org/pod/List::MoreUtils) module.

## Do any of the elements match?

The `any` function has the same syntax as `grep`, accepting a block and a list of values,
but it only returns true or false. True, if the block gives true
for any of the values. False if none of them match.
It also short circuits so on large lists this can be a lot faster.

```perl
use List::MoreUtils qw(any);
if (any { $visitor eq $_ } @names) {
   print "Visitor $visitor is in the guest list\n";
} else {
   print "Visitor $visitor is NOT in the guest list\n";
}
```


## UNIX grep and Linux grep?

Just to make the explanation round:

I mentioned that the build in `grep` function of Perl is a generalization of the UNIX
grep command.

The **UNIX grep** filters the lines of a file based on a regular expression.

**Perl's grep** can filter any list of value based on any condition.

This Perl code implements a basic version of the UNIX grep:

```perl
my $regex = shift;
print grep { $_ =~ /$regex/ } <>;
```

The first line gets the first argument from the command line which should be a
regular expression. The rest of the command line arguments should be filenames.

The diamond operator `&lt;&gt` fetches all the rows from all the
files on the command line.
The grep filters them according to the regular expression. The ones that pass
the filtering are printed.

## grep on Windows

Windows does not come with a grep utility but you can install
one or you can use the same Perl script as above.

## Comments

Gabor (can I call you Gabor ... or Mr. Szabo?) - Thanks for this article. I wanted to see if a string started with one of many possible words in an array - which I could not find anywhere around the web.

So I came up with this ...

my @result=grep { $my_string =~ /^($_)/ } @words;

which I adapted from your line ...

if (grep { $visitor eq $_ } @names)

If the result is true, then it contains the one or more matches from the array which match at the start of the string! And because I am not looping over the list of words to match against $my_string ... I suspect that it is faster.

Thanks!

---

A grep is a loop. You solution seems fine with a few caveats. You don't need the () around $_, but you'd better put a \Q in front of if so /^\Q$_/ otherwise if there is any regex metacharacter in your @words (e.g. on of the words is "a.c" then the . will be use as "any character" so it would also match things like "abc". Read also about quotemeta.

<hr>

Thank you for this.

<hr>

how can i grep numbers from log file and parse it to excel and how can i select only updated files from multiple files in perl

<hr>

how can i grep updated files in perl

<hr>

sub uniq {
my %seen;
grep !$seen{$_}++, @_;
}
what it do and explain it. please

---
Hi ravi, I think I can explain it.

my %seen

# 1) Here it create an empty hash array named "%seen"

grep !$seen{$_}++, @_;

2) Get all arguments of "sub uniq" in default array "@_"

3)Go over iteration and create each element ($_) and make that element as key and value as 1 (++ does that). So that hash will look like %seen = ( "first_element" => 1, "second_element" => 1, .......... )

4) grep !$seen{$_}++ ===> This will check if the next element is already in that hash, if present it will increment the value like ("first_element" => 2, ) else it add add new key like ("third_element" => 2), So you will get only unique list

5) Now you have to return the filtered keys as an array


