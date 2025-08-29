---
title: "Open and read from text files"
timestamp: 2013-01-06T10:45:56
tags:
  - open
  - <$fh>
  - read
  - <
  - encoding
  - UTF-8
  - die
  - open or die
  - STDIN
published: true
books:
  - beginner
author: szabgab
---


In this part of the [Perl tutorial](/perl-tutorial) we are going to see **how to read from a file in Perl**.

At this time, we are focusing on [text files](/what-is-a-text-file).


In this article we see how to do this with core perl, but there are more modern and nicer ways to do this
[using Path::Tiny to read files](/use-path-tiny-to-read-and-write-file).

There are two common ways to open a file depending on how would you like
to handle error cases.

## Exception

Case 1: Throw an exception if you cannot open the file:

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

## Warn or keep silent

Case 2: Give a warning if you cannot open the file, but keep running:

```perl
use strict;
use warnings;

my $filename = 'data.txt';
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    print "$row\n";
  }
} else {
  warn "Could not open file '$filename' $!";
}
```

## Explanation

Let's see them explained:

First, using a text editor, create a file called 'data.txt' and add a few lines to it:

```
First row
Second row
Third row
```

Opening the file for reading is quite similar to how we
[opened it for writing](/writing-to-files-with-perl),
but instead of the "greater-than" (`>`) sign, we are using
the "less-than" (`<`) sign.

This time we also set the encoding to be UTF-8. In most of the code out there
you will see only the "less-than" sign.

```perl
use strict;
use warnings;

my $filename = 'data.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

my $row = <$fh>;
print "$row\n";
print "done\n";
```

Once we have the filehandle we can read from it using the same
readline operator that was used for
[reading from the keyboard (STDIN)](/installing-perl-and-getting-started).
This will read the first line of the file.
Then we print out the content of $row and print "done" just
to make it clear we reached the end of our example.

If you run the above script you will see it prints

```
First row

done
```

Why is there an empty row before the "done" you might ask.

That's because the readline operator read all the line,
including the trailing newline. When we used `print()` to print it out,
we added a second newline.

As with the case of reading from STDIN, here too, we usually don't
need that trailing newline so we will use `chomp()` to remove it.

## Reading more than one line

Once we know how to read one line we can go ahead and put
the readline call in the condition of a `while` loop.

```perl
use strict;
use warnings;

my $filename = $0;
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

while (my $row = <$fh>) {
  chomp $row;
  print "$row\n";
}
print "done\n";
```

Every time we reach the condition of the `while` loop, first it will
execute `my $row = <$fh>`, the part that will read the next line from the file.
If that line has anything in it, that will evaluate to true.
Even empty lines have a newline at the end, so when we read them, the
`$row` variable will contain a `\n` that will evaluate to true in
boolean context.

After we read the last line, in the next iteration the readline operator (`<$fh>`) will
return undef which is false. The while-loop will terminate.

<h3>An edge-case</h3>

There is an edge-case though when the very last line has a single 0 in it, without a trailing newline.
The above code would evaluate that line to false and the loop would not be executed. Fortunately,
Perl is actually cheating here. In this very specific case (reading a line from a file within a while-loop),
perl will actually act as if you wrote `while (defined my $row = <$fh>) {` and so even such lines
will execute properly.


## open without die

The above way of handling files is used in Perl scripts when you absolutely
have to have the file opened or there is no point in running your code.
For example when the whole job of your script is to parse that file.

What if this is an optional configuration file? If you can read it
you change some settings, if you cannot read you just use the defaults.

In that case the second solution might be a better way to
write your code.

```perl
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    print "$row\n";
  }
} else {
  warn "Could not open file '$filename' $!";
}
```

In this case we check the return value of `open`.
If it is true we go ahead and read the content of the file.

If it failed we give a warning using the built-in `warn`
function but don't throw an exception. We don't even need to
include the `else` part:

```perl
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    print "$row\n";
  }
}
```


## Comments

Does opening $filename within if condition automatically close the file after reading ?
If not, How can I close this file ?

No, you must close the file yourself with the close() function. In the examples above it would be close($fh).

That's not exactly true.

"The filehandle will be closed when its reference count reaches zero. If it is a lexically scoped variable declared with my, that usually means the end of the enclosing scope."
Copied from here:  https://perldoc.perl.org/functions/open

<hr>

So reading with <> is reading line-by-line.
This is great for files, but I'm interested in pipes.
How to read all the available data from pipe, without waiting for \n or EOF to come?

use read https://perlmaven.com/search/read
