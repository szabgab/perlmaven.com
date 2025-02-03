---
title: "Perl split - to cut up a string into pieces"
timestamp: 2013-12-15T23:30:01
description: "perl split(/PATTERN/, EXPR, LIMIT) splits the expression into a list of strings every place where the pattern matches."
tags:
  - split
  - $_
  - explode
published: true
author: szabgab
---


PHP has the `explode` function,
Python, Ruby and JavaScript all have `split` methods.

In Perl the function is called `split`.


## Syntax of split

`split REGEX, STRING` will split the STRING at every match of the REGEX.

`split REGEX, STRING, LIMIT` where LIMIT is a positive number. This will split the the STRING at every match of the REGEX, but will stop after it found LIMIT-1 matches.
So the number of elements it returns will be LIMIT or less.

`split REGEX` - If STRING is not given, splitting the content of
[$_, the default variable of Perl](/the-default-variable-of-perl) at every
match of the REGEX.

`split` without any parameter will split the content of `$_` using `/\s+/` as REGEX.

## Simple cases

`split` returns a list of strings:

```perl
use Data::Dumper qw(Dumper);

my $str = "ab cd ef gh ij";
my @words = split / /, $str;
print Dumper \@words;
```

The output is:

```
$VAR1 = [
          'ab',
          'cd',
          'ef',
          'gh',
          'ij'
        ];
```

## Limit the number of parts

`split` can get a 3rd parameter that will limit the number of elements returned:

```perl
use Data::Dumper qw(Dumper);

my $str = "ab cd ef gh ij";
my @words = split / /, $str, 2;
print Dumper \@words;
```

The result:

```
$VAR1 = [
          'ab',
          'cd ef gh ij'
        ];
```


## Assign to scalars

Instead of assigning the result to a single array, we can also assign
it to a list of scalar variables:

```perl
my $str = "root:*:0:0:System Administrator:/var/root:/bin/sh";
my ($username, $password, $uid, $gid, $real_name, $home, $shell) = split /:/, $str;
print "$username\n";
print "$real_name\n";
```

The output is like this:

```
root
System Administrator
```

Another way people often write this is the following:
First they assign the results to and array, and then they copy the specific 
elements of the array:

```perl
my $str = "root:*:0:0:System Administrator:/var/root:/bin/sh";
my @fields = split /:/, $str;
my $username = $fields[0];
my $real_name = $fields[4];
print "$username\n";
print "$real_name\n";
```

This is longer and I think less clear.

A slightly better way is to use an <b>array slice</b>:

```perl
my $str = "root:*:0:0:System Administrator:/var/root:/bin/sh";
my @fields = split /:/, $str;
my ($username, $real_name) = @fields[0, 4];
print "$username\n";
print "$real_name\n";
```

Please note, in the <b>array slice</b> `@fields[0, 4];` we
have a leading `@` and not a leading `$`.


If we are really only interested in the elements 0 and 4, the we could
use array slice on the fly:

## Slice on the fly


```perl
my $str = "root:*:0:0:System Administrator:/var/root:/bin/sh";
my ($username, $real_name) = (split /:/, $str)[0, 4];
print "$username\n";
print "$real_name\n";
```

Here we don't build an array, but as we put the whole expression
in parentheses, we can put an index on them and fetch only elements 0 and 4 from
the temporary (and invisible) array that was created for us:
`(split /:/, $str)[0, 4]`


## Split on more complex regex

The separator of `split` is a regex. So far in the examples we used
the very simple regex `/ /` matching a single space. We can use any regex:
For example if we have strings that look like these:

```
fname    = Foo
lname =    Bar
email=foo@bar.com
```

We want to split where the `=` sign and disregard the spaces around it.
We can use the following line:

```perl
my ($key, $value) = split /\s*=\s*/, $str
```

This will include any white-space character around the `=` sign in
the part that cuts the pieces.


## Split on multiple characters

For example we might have a string built up from
pairs concatenated with `&`. The two parts of
each pair is separated by `=`.

```perl
use Data::Dumper qw(Dumper);

my $str = 'fname=Foo&lname=Bar&email=foo@bar.com';
my @words = split /[=&]/, $str;
print Dumper \@words;
```

```
$VAR1 = [
          'fname',
          'Foo',
          'lname',
          'Bar',
          'email',
          'foo@bar.com'
        ];
```

Of course, if we know these are key-value pairs, then we might want to assign the
result to a hash instead of an array:

```perl
use Data::Dumper qw(Dumper);

my $str = 'fname=Foo&lname=Bar&email=foo@bar.com';
my %user = split /[=&]/, $str;
print Dumper \%user;
```

And the result looks much better:

```
$VAR1 = {
          'fname' => 'Foo',
          'email' => 'foo@bar.com',
          'lname' => 'Bar'
        };
```


## Split on empty string

Splitting on the empty string, or empty regex, if you wish is basically saying
"split at every place where you find an empty string". Between every two characters
there is an empty string so splitting on an empty string will return the original
string cut up to individual characters:

```perl
use Data::Dumper qw(Dumper);

my $str = "Hello World";
my @chars = split //, $str;

print Dumper \@chars;
```

```
$VAR1 = [
          'H',
          'e',
          'l',
          'l',
          'o',
          ' ',
          'W',
          'o',
          'r',
          'l',
          'd'
        ];
```

## Including trailing empty fields

By default ```split</code> will exclude any fields at the end of the string that are empty. However you can pass a 3rd parameter to be <b>-1</b>.
If the 3rd parameter is a positive number it limits the number of fields returned. When it is <b>-1</b>, it instructs <b>split</b> to include
all the fields. Even the trailing empty fields.

{% include file="examples/split_empty_trailing.pl" %}


```
$VAR1 = [
          '',
          'a',
          'b',
          'c'
        ];

$VAR1 = [
          '',
          'a',
          'b',
          'c'
        ];

$VAR1 = [
          '',
          'a',
          'b',
          'c'
        ];

$VAR1 = [
          '',
          'a',
          'b',
          'c',
          '',
          ''
        ];
```


## Beware of regex special characters

A common pitfall with split, especially if you use a string as the separator (`split STRING, STRING`) as in `split ';', $line;`
is that even if you pass the first parameters as a string it still behaves as a regex. So for example

```
split '|', $line;
```

is the same as

```
split /|/, $line;
```

and both will split the string character by character. The right way to split on a pipe `|` character is to escape
the special regex character:

```
split /\|/, $line;
```

## Other examples

Though in the general case `split` is not the right tool for this job,
it can be employed for [reading simple CSV files](/how-to-read-a-csv-file-using-perl). Check that article for much better ways to read a CSV or TSV file.

It is also a critical part of the example showing
[how to count words in a text file](/count-words-in-text-using-perl).

Another special case helps to [retain the separator or parts of it](/split-retaining-the-separator).

## Comments

if i want to divide 256 bits string in two 128 bits strings then ?

<hr>

Minor frustration on my part - I was trying to split on the vertical bar (parsing some data output from sql). I completely blanked on it being interpreted as a regex OR, and so

split /|/ 

was splitting on empty string. So, of course I needed to escape it!

split /\|/ 

Good point. I've added your example to the article! Thanks.

<hr>

I have one problem to solve with perl and I cannot find the way here. Anyway I have to split one file into number of different files and to give name to them. example of the single uniprot file:

AC P24567
DC XXXXX
SP H. sapiens..
//
AC P24567
DC XXXXX
SP E.colo..
//
Each entry is seperated by //, what I want is to split this file at each // at to give each file name according to its AC name (P24567, etc..). Can You give me some kind of hint where can I search for this kind of command.

Best

<hr>

how to split a string with "." (dot ) base seperation ?

escape it with a backslash: /\./

<hr>

hi , thankz for your post, i have a little questions , i try to split a a page txt , inside of them i have this text
2020.07.28 00:00; 1214
2020.07.21 00:00; 879
2020.07.14 00:00; 879
2020.07.07 00:00; 804

i try to do that with this code

use strict;
use warnings;
use autodie;
use Data::Dumper qw(Dumper);

my $file = 'C:\Users\pc\Documents\de.txt';
open my $fh, '<', $file or die;
$/ = undef;
my $data = <$fh>;

my @result = split(/\;\s*/, $data);
#my @result = split(/\;\s*\w*/,$data);

my ($username, $real_name) = @result[1, 0];
print "$username\n";

but with this code split first -- 2020.07.28 00:00 and second 1214 2020.07.21 00:00

you have some idea for resolve it ?

thanzk

---

You probably want to split each line on it own, right? Then
1) don't set $/=undef; as this will become "slurp mode" reading the whole file into $data.
2) read the file line-by and split each line on its own
3) You might want to use Text::CSV for this.

All the above have blog posts on this site

---
but if i read line by line is very slow then slurp mode

---

Have you measured it? How big is that file and how often do you read it that you notice any difference?

---
have minimum 3000 line and after extract data must do some calculation and rewrite other file , therfore i want use a best way for performance (if possible of course)
thankz again

---

Then please just do the easy way and then if it is too slow, you can try to see how to improve. (It won't be too slow.)

---
but i just do it a script , the easy why for me is do a little correction i suppose at regexp , not rewrite all but ok thankz again

---

a programmer had a problem, he invented regular expressions to solve it ............ now he have two problems,after that :D for resolve a problem i must use this expression [\;\n]+ thankz again for help probably i test also a read line by line

----

You are now trying to solve the problem you created when you decided that you need to slurp in the file.

<hr>

