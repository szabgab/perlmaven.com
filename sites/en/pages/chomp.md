---
title: "Chomp and $/, the Input Record Separator"
timestamp: 2014-01-27T22:13:10
tags:
  - chomp
  - $/
  - English
  - $INPUT_RECORD_SEPARATOR
  - $RS
published: true
books:
  - beginner
author: szabgab
---


The most common use of the `chomp` function is to remove trailing newlines from strings.
Either when reading from the Standard Input (STDIN), or when reading from a file like this:

```perl
my $input = <STDIN>;
chomp $input;

while (my $row = <$fh>) {
    chomp $row;
    ...
}
```

This is not the whole story though.


When dealing with a file, it can be either [binary or text file](/what-is-a-text-file).
We usually consider files that have "lines" to be text files. When we read such file we usually do it line-by-line.
We know that different operating systems have different meaning of what a new-line is, the most common ones
use either a single `LF - line feed` (hexa 0x0A or decimal 10) character (OSX/Linux/Unix),
or a `CR - carriage return` (hexa 0x0D or decimal 13) followed by a `LF - line feed` (MS Windows).

So when we open a text-file for reading and we call the read-line operator in scalar context: `$line = <$fh>`
Perl will know what to do. Perl will adapt itself to the environment and will know what is the new-line symbol
in the current operating system.

In order to do this, Perl maintains a variable called the <b>Input Record Separator</b>.
In native Perl this is the `$/` variable, but if you use the
[English](https://metacpan.org/pod/English) module
you can use the name `$INPUT_RECORD_SEPARATOR` or `$RS` as well.
This variable contains `LF` (ASCII character 10).


## chomp

The `chomp` function uses the same Input record separator `$/` to determine what to remove
from the end of the string. In normal circumstances the default behavior is to remove the trailing,
os-specific new-line from the parameter of `chomp`. That's what we do in most of the cases.


## Changing the Input record separator

We could actually change the value of `$/`. For example, by assigning the letter <b>Q</b> like this: `$/ = 'Q';`.
Then every call to the read-line operator `$row = <$fh>` will read in all the characters up-to and including the first `Q`.

In that case, calling `chomp` would remove the <b>Q</b> character from the end of the string.

We could also assign longer strings to `$/` and then that would be the input record separator.

Let's try this perl program:

```perl
use strict;
use warnings;
use 5.010;

$/ = 'perl';
open my $fh, '<', 'data.txt' or die;
while (my $row = <$fh>) {
    say $row;
    say '---';
    chomp $row;
    say $row;
    say '==========';
}
```

On this data.txt file:

```
What do you think about perl, and what about
some other language called perl.
Or maybe Java?
```

The output looks like this:

```
What do you think about perl
---
What do you think about
==========
, and what about
some other language called perl
---
, and what about
some other language called
==========
.
Or maybe Java?

---
.
Or maybe Java?

==========
```

We can observe how each call reads up-to and including the word <b>perl</b> and then how `chomp`
removes the string <b>perl</b>.

## chomp removes only one copy of $/

In the following example we have multiple copies of the word <b>perl</b> at the end of the string and we set
the Input Record Separator to be `$/ = 'perl';`.
The first call to `chomp` removed one occurrence of <b>perl</b>. The second call to `chomp` removed
the other occurrence. Calling `chomp` again, when there were no more copies of <b>perl</b> at the end of the string,
did not do any harm.

```perl
use strict;
use warnings;
use 5.010;

my $str = "helloperlperl";

$/ = 'perl';
say $str;        # helloperlperl
chomp $str;
say $str;        # helloperl
chomp $str;
say $str;        # hello
chomp $str;
say $str;        # hello
```


This would be the same behavior if we left the default value (the os-aware new-line) in `$/`.

## chomp on arrays

If we put the read-line operator in [list context](/scalar-and-list-context-in-perl),
for example by assigning it to an array, it will read all the "lines" into that array.
Each line will become an element in the array. Of course we have to put the word "lines" in quotes,
as we already know that separating the content of the file at the new-lines is "only" the default behavior.
By changing the <b>Input Record Separator</b> we can split the file at any substring.

```perl
use strict;
use warnings;
use 5.010;

$/ = 'perl';
open my $fh, '<', 'data.txt' or die;
my @rows = <$fh>;
chomp @rows;
```

Calling `chomp` and passing the whole array to it will result in the removal of the trailing new-line (Input Record Separator)
from every element.

## slurp mode

We use the [slurp](/slurp) mode when we want to read the content of a file into a single scalar variable.
In that case we assign [undef](/undef-and-defined-in-perl) to the Input record separator.

## perldoc

[perldoc perlvar](https://metacpan.org/pod/perlvar) (search for `$INPUT_RECORD_SEPARATOR`),
and [perldoc -f chomp](http://perldoc.perl.org/functions/chomp.html) might have more to say about the topic.

## Comments

This all works well when the file one is opening is an ascii file. I have a situation where the contents of my file contains RUSSIAN letters. using the normal value of $/ with perl when this file is a form of unicode - causes many of the non-ascii valued russian letters to match as 'newlines'. Can you suggest how this is handled when the files are a form of unicode? so that no 'false positive' matches occur with the Russian characters? If it helps, this is how I am opening the file... open(IN, "<:encoding(UTF-8)", $setlist )


