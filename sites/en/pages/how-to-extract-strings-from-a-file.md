---
title: "How to extract strings from a file"
timestamp: 2013-06-15T11:30:01
tags:
  - \s
  - ?:
  - (
  - /g
  - ^
  - $
  - regex
published: true
author: szabgab
---


Recently one of the Perl Maven readers asked this:

How would you search a binary file for all strings containing a few
characters, then a dash and then a few more characters?

FT-10500 would be an example.


A couple of notes:

It was unclear to me why "binary file". I asked back and got
a clarification that it is in the end a text file.

Another issue that was unclear, what are the "characters" that can be
before and after the dash, and how would you know where do those characters start
and where do they end? Would $%-%^ be an acceptable sting?  What about $A-3$ ?
I asked this too, but I have not got answer yet, so I'll make some assumptions.
Specifically I'll assume that we accepts letters before the dash and numbers after
and that the string cannot have any other non-space character before the letters
or after the digits.

Let's create an example file and save as data.txt

```
$%-%^ $A-3$
$X-3 this is not good
X-3$ neither is this good
FT-10500 garbage A-301 more
XABCT-10304 garbage BD-42
line without any string
just a single dash: - nothing around
only before A-  only after -3 and nothing more.
```

In this file I expect to match the following strings: FT-10500, A-301, XABCT-10304, BD-42

The task is relatively standard:

Go over the file line-by-line and extract the required strings.

## Go over a file line-by-line

The first part of the code is the "standard" code that will open the file,
read the lines one-by-one in a `while loop`, `chomp`
the newline from the end of the line and then do the important task for each line.

```perl
use strict;
use warnings;
use 5.012;

my $file = 'data.txt';
open my $fh, '<', $file or die "Could not open '$file' $!\n";

while (my $line = <$fh>) {
   chomp $line;
   ...
}
```

(The 3 dots `...` is an actual Perl operator called yada-yada and it will throw an `Unimplemented` exception.)

So what comes in that place?

## Extracting data from a single string

Before inserting it in the while loop, let's try this on a single string:

```perl
my $line = 'A-1 $B-2 C-3 D-4$ E-5';
my @strings = $line =~ /[A-Za-z]+-\d+/g;
foreach my $s (@strings) {
  say "'$s'";
}
```

We expect to match the following 3 strings: 'A-1', 'C-3', and 'E-5'.

In the regex `[A-Za-z]+-\d+` we have the following:
`[A-Za-z]+` match one or more letters, `-` then a dash, `\d+` then one or more digits.
The `g` after the regex means <b>global</b> matching, so it will look for more than one possible matches.
This is interesting either in a substitute or in a match in a [list context](/scalar-and-list-context-in-perl).
The assignment to the `@strings` array creates the required list context. This means the regex will return
the list of the actual matches.

In our case the output will look like this:

```
'A-1'
'B-2'
'C-3'
'D-4'
'E-5'
```

That's not exactly what I wanted as this code also included parts of the "$B-2" and "D-4$" strings while we did not want those.

(The quotes were added to the `say` statement so we will see if there is an accidental leading or trailing space
in the match. It cannot really happen in this specific case, but I prefer to add these all the time.)


Let's try to make sure only white-space can be before or after the expected string by adding `\s`
at the beginning and the end of the regex:

```perl
my @strings = $line =~ /\s[A-Za-z]+-\d+\s/g;
```

The result is disappointing:

```
' C-3 '
```

It only matches one string and it includes white spaces around it. The reason is that now we require to have
a white space in front the matching string and there is not white space before the leading 'A'.

(BTW now you can see why adding the single-quotes around the printed values is useful as you can see the captured
white spaces.)

So let's say say that before the actual string we want either a white-space `\s` or that it will be the
beginning of the string `^`. We wrap them in a pair of parentheses and make this an alternation: `(^|\s)`.
After the actual string we want either a white-space or to be the end of the string `$`, again separated
with alternation `|` and wrapped in parentheses:

```perl
my @strings = $line =~ /(^|\s)[A-Za-z]+-\d+(\s|$)/g;
```

and the result?

```
''
' '
' '
' '
' '
''
```

That looks strange. The reason is that when there are <b>capturing parentheses</b> in the regex and you use the regex
in list context to get the matches returned, then instead of returning the actual matches, perl returns the strings
that were matched by the parentheses. So let's change them to <b>non-capturing parentheses</b> by including `?:`
at the beginning of the sub-expression:

```perl
my @strings = $line =~ /(?:^|\s)[A-Za-z]+-\d+(?:\s|$)/g;
```

And the result is:

```
'A-1 '
' C-3 '
' E-5'
```

Much better. We have now the correct strings, albeit with some leading and trailing spaces.

Those are there as now the regex returns the full matches that include the white-spaces as well.

We could now [remove the leading and trailing white-spaces](/trim) using a substitution `s/^\s+|\s+$//g`,
but we can also improve our regex.

Now we can use to our advantage what made the previous failure and wrap the interesting part of our regex in
a pair of parentheses. This will let the regex return exactly the part we are interested in:

```perl
my @strings = $line =~ /(?:^|\s)([A-Za-z]+-\d+)(?:\s|$)/g;
```

The result is:

```
'A-1'
'C-3'
'E-5'
```

Perfect.

## The solution

Now we can combine the "looping over the lines" part with the "fetch the string from one line" part and get the following solution:

```perl
use strict;
use warnings;
use 5.012;

my $file = 'data.txt';
open my $fh, '<', $file or die "Could not open '$file' $!\n";

while (my $line = <$fh>) {
   chomp $line;
   my @strings = $line =~ /(?:^|\s)([A-Za-z]+-\d+)(?:\s|$)/g;
   foreach my $s (@strings) {
     say "'$s'";
   }
}
```

The result then:

```
'FT-10500'
'A-301'
'XABCT-10304'
'BD-42'
```

just what we expected.


