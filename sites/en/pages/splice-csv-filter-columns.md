---
title: "How to splice a CSV file in Perl (filter columns of CSV file)"
timestamp: 2018-01-26T10:30:01
tags:
  - Text::CSV
  - splice
published: true
author: szabgab
archive: true
---


[splice](/splice-to-slice-and-dice-arrays-in-perl) is the super-tool in Perl
to extract elements from an array or to replace some elements.

You cannot apply it directly to CSV file but we know we can use the [Text::CSV](/search/Text%3A%3ACSV)
module to read and write arbitrary CSV files. We can use that to read in a CSV file line-by-line
and as each line is represented as an array we can use `splice` on the array.

Effectively working on the columns of the CSV file.


Given this CSV file

{% include file="examples/data/multiline.csv" %}

we would like to create another file that features the 1st, 2nd, and 4th column.

Here is our solution:

{% include file="examples/splice_csv_file.pl" %}

At first we create an instance of [Text::CSV](https://metacpan.org/pod/Text::CSV), the de-facto
standard CSV-parser of Perl.

We open both the original file for [reading](/open-and-read-from-files), and the output file for
[writing](/writing-to-files-with-perl).

Then we use the `getline` method of the CSV parser to read the logical lines of the CSV file.
We need to do this instead of reading ourselves, because some fiels in the CSV file might contain
embeddd newline, just as in our example we have <b>"Hofeherke,\nalma"</b>.

For each logical row, `getline` will return a [reference to an array](/array-references-in-perl)
that holds the fields of the current line. Dereferencing it by writing `@$row` allows us to use
`splice` on the array.

Then we use the `combine` method of the CSV parser that puts together the fields and adds
the quotes where necessary. It returns a [boolean](/boolean-values-in-perl) value
indicating the success or failur of combining the fields. (Though I am not sure what can ogo wrong here.)

The `string` method returns the actual CSV string representing the current line.
We can print it to the output file followed by a new-line.

The resulting file is this:

{% include file="examples/data/multiline_spliced.csv" %}

## Other CSV related articles

[CSV in Perl](/csv)

