---
title: "Split CSV file into multiple small CSV files"
timestamp: 2014-05-09T09:30:01
tags:
  - Text::CSV
  - Text::CSV_XS
  - CSV
published: true
author: szabgab
---


Given a large CSV file, how can we split it into smaller pieces?

There are many ways to split the file. We are going to see two here: Horizontally or vertically.
Horizontally would mean that every N lines go into a separate files, but each line remains intact.

Vertically would mean that every few columns go into a separate file.


## Splitting horizontally

If we can assume that the CSV file does not contain any embedded newlines, and if are running on a Linux
machine, then we don't even need Perl. We can just use the `split` command of Linux.

If we are on Windows, we could write a simple script to read the original file and every N lines save it in a new file.

Unfortunately these solutions won't work correctly for a file like the following, where at least one of the fields has an embedded newline.

```
Tudor;Vidor;10;Hapci
Szundi;Morgo;7;Szende
Kuka;"Hofeherke;
alma";100;Kiralyno
Boszorkany;Herceg;9;Meselo
```

(Also in this example the fields are separated using semi-colon `;`, instead of comma, but that's just for the extra fun.)

This solution will work:

```perl
use strict;
use warnings;

use Text::CSV;
my $file = 'csv_with_newline.csv';

my $size = 3;

my $file_counter = 0;
my $line_counter = 0;

my $out;

my $csv = Text::CSV->new ({ binary => 1, auto_diag => 1, sep_char => ';' });
open my $in, "<:encoding(utf8)", $file or die "$file: $!";
while (my $row = $csv->getline($in)) {
    $line_counter++;
    if ($out and $line_counter > $size) {
        close $out;
        undef $out;
        $line_counter = 0;
    }
    if (not $out) {
        $file_counter++;
        my $outfile = "output$file_counter.csv";
        open $out, ">:encoding(utf8)", $outfile or die "$outfile: $!";
    }
    $csv->print($out, $row);
    print $out "\n";
}
close $in;
close $out;

```

Here we read the CSV file by using the `getline` method of [Text::CSV](http://metacpan.org/pod/Text::CSV).
This will read a "logical" line as it understands the internal structure of CSV files.
We use our own scalar variable called `$line_counter` to count the logical lines read. This helps us decide when do 
we need to close the current output file  (if it is open and we crossed the planned size) `if ($out and $line_counter > $size)`.

The variable `$file_counter` is used to number the output files.

In a more generic solution, we'd probably get the name of the input file, the size, and the format of the output files as command line parameters,
but in this example we can use hard-coded values.

If you are not yet familiar with Text::CSV, there is another article that shows [how to read a CSV file](/how-to-read-a-csv-file-using-perl) 
with some more explanation. In a nutshell `$row` always containing a reference to an ARRAY and each element in that array is a field from the current line in the
CSV file.

## Splitting vertically

```perl
use strict;
use warnings;

use Text::CSV;
my $file = 'csv_with_newline.csv';

my $size = 3;

my @files;

my $csv = Text::CSV->new ({ binary => 1, auto_diag => 1, sep_char => ';' });
open my $in, "<:encoding(utf8)", $file or die "$file: $!";
while (my $row = $csv->getline($in)) {
    if (not @files) {
        my $file_counter = int @$row / $size; 
        $file_counter++ if @$row % $size;
        for my $i (1 .. $file_counter) {
            my $outfile = "output$i.csv";
            open my $out, ">:encoding(utf8)", $outfile or die "$outfile: $!";
            push @files, $out;
        }
    }

    my @fields = @$row;
    foreach my $i (0 .. $#files) {
        my $from = $i*$size;
        my $to   = $i*$size+$size-1;

        $to      = $to <= $#fields ? $to : $#fields;
        my @data = @fields[$from .. $to];

        $csv->print($files[$i], \@data);
        print {$files[$i]} "\n";
    }
}
close $in;
close $_ for @files;
```

The resulting files look like these two:

```
Tudor;Vidor;10
Szundi;Morgo;7
Kuka;"Hofeherke; 
alma";100
Boszorkany;Herceg;9
```

```
Hapci
Szende
Kiralyno
Meselo
```

In the code above, we assume all the lines have the same number of fields. After reading the first line,
when `@files` is still empty (`if (not @files) {` is true), we open all the necessary output files and put the file-handles in
the `@files` array. The number of files necessary is calculated in `$file_counter`.
It is either the total number of columns divided by the number of columns in each file, or one more, if
there are some left-over columns. (If modulo is not 0.)

For more convenience we copy the content of the current `$row` to the `@fields` array, then for each file we calculate
the range of the fields that go into that file (`$from`, `$to`), and use the range operator to fetch the values
of the specific columns: `my @data = @fields[$from .. $to];`.

In the print statement we had to wrap `$files[$i]` in curly braces, in order to ensure perl will see the whole
expression as the filehandle.

## Alternative code

In the above code, we used a couple of temporary variables, such as `@fields` and `@data`.
This is probably good as it makes the code more readable, but let's see alternative expressions that do the same:

This code:

```perl
        $to      = $to <= $#fields ? $to : $#fields;
        my @data = @fields[$from .. $to];
```

can be replaced by this code:

```perl
        $to      = $to <= $#$row ? $to : $#$row;
        my @data = @$row[$from .. $to];
```

eliminating the need for the `@fields` array. I'd probably not write this
as this involved expressions such as `$#$row` and `@$row[$from .. $to];`,
but I am showing it here so when you do encounter such expressions, you have a better
chance to deal with them.

If you know that `$#$row` is the same as `$#{$row}` then it might be easier to
see why this does the same as the original code.

In order to eliminate the need for the `@data` array we can replace this code:

```perl
        my @data = @$row[$from .. $to];
        $csv->print($files[$i], \@data);
```

with this line:

```perl
        $csv->print($files[$i], [ @$row[$from .. $to] ]);
```

I'd probably avoid this too.

