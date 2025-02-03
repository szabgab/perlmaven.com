---
title: "Reading from a file in scalar and list context"
timestamp: 2015-01-29T17:12:56
tags:
  - scalar
published: true
author: szabgab
---


I have previously written about [scalar and list context in Perl](/scalar-and-list-context-in-perl), how
[localtime behaves in scalar and list context](/the-year-19100) and what an array returns in scalar context.

This time we'll look at `<$fh>`, the readline operator of Perl in scalar and list context.


In this article you'll see how the readline operator works in scalar and list context, but if you need
to read in the whole content of a file into a scalar variable or into an array, you might be better off
[using Path::Tiny](/use-path-tiny-to-read-and-write-file). It will make your code look
nicer.

## readline in SCALAR context

This is the standard example we have already seen several times starting when we
[opened a file and read the lines](/open-and-read-from-files), but let me show it here again:

```perl
use strict;
use warnings;
 
my $filename = 'data.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";
 
while (my $row = <$fh>) {
  chomp $row;
  print "$row\n";
}
```

The relevant part is that we read from the `$fh` filehandle into a scalar variable: `my $row = <$fh>`.
We have already learned that in this case Perl will read one line from the file, up to and including the first new-line
it encounters. Then next time we execute the same expression it will start reading from the next character, meaning
the beginning of the next line.

Compare that with the following example


## readline in LIST context

```perl
use strict;
use warnings;
 
my $filename = 'data.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";
 
my @rows = <$fh>;
chomp @rows;
foreach my $row (@rows) {
  print "$row\n";
}
```

In this case, after opening the file we read from the `$fh` filehandle into an array variable: `my @rows = <$fh>;`.
In this case Perl will read in the content of the whole file in one step. Each row in the  file will be one of the elements of
the array. So if the file had 37 rows, then this array will have 37 elements. The first element (index 0) will contain what was
on the first line in the file. The 8th element (index 7) will contain what was on the 8th line. etc.

Each element in the array will include the newline that was at the end of the row. We can get rid of all those newlines in just one statement:
`chomp @rows;` will remove the trailing newline from all of the elements of the array.

Then, instead of using a [while-loop](/while-loop) we use a foreach loop to iterate over the elements of the array.



## Which one is better?

In almost all the cases we would use the first approach, reading the file line-by-line. If we read the whole file into an array this means
we use as much memory as the size of the file. If this is a big file (a few GB-s) then this would probably not work. On the other hand
when we read the file line-by-line as in the first case, we only need to hold in the memory one line at a time.

Nevertheless, there can be cases when it is much easier to process a file when all of it is in memory. For example if we need to
find something that might depend on something later in the file. If you use this approach, please remember to check
the size of the file with the `-s` operator.



## Slurp mode

Finally there is a third case which is interesting in certain situations especially when you
are trying to find a string that might start on one line and end on a later line.
In that case it can be very useful to have the content of the whole file loaded
into a single scalar variable. This what the Perl developers call [slurp mode](/slurp).
In the referred article you can see examples how to read a file in slurp using core
perl and how to do that using [Path::Tiny](/use-path-tiny-to-read-and-write-file).

