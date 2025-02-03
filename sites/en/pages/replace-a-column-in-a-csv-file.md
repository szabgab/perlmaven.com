---
title: "How to replace a column in a CSV file using Perl"
timestamp: 2021-01-26T11:30:01
tags:
  - CSV
  - Text::CSV
  - split
published: true
author: szabgab
archive: true
---


Given a CSV file, how can we replace the values in one of the columns?

For example given this file:

{% include file="examples/test_cases.csv" %}

how can we replace the 4th column to contain the value 'CIF' in every line?


Our expected result looks like this:

{% include file="examples/test_cases_cis.csv" %}


## Using Text::CSV

The best tool to read and write CSV files in perl is the [Text::CSV](https://metacpan.org/pod/Text::CSV) module.
It is a pure-perl implementation that is very easy to install.

{% include file="examples/replace_column_in_csv_file.pl" %}

First we expect 2 filenames on the command line and assign them to two scalar variables `$infile` is expected to be the name of the current CSV file. `$outfile` is expected to be the name of the newly created file.

Then we check if the second parameter was passed to us and if the name in the first parameter is an existing file? Using the `-e` operator.

Then we open both files. The first one for reading. The second one for writing.

In the `while` loop we read the content of the CSV file line-by-line and split them assigning the values to the `$fields` variable as a reference to an array.

`$fields->[3] = 'CIF';` is the expression that replaces the 4th element (index starts from 0) in a reference to an array.

Then we print out the content of the `$fields` (reference to an) array and follow it with a new-line.

Finally, after the `while`-loop, we close both filehandles.

That's it.


## Using Text::CSV_XS

[Text::CSV_XS](https://metacpan.org/pod/Text::CSV_XS) is another module that can read and write CSV files.
It is written in C and it is much faster which can be important if you have a lot of large CSV files.

Installing it is a bit more difficult that installing Text::CSV, but using it is the same. Actually you don't
even need to change anything in the above code. Text::CSV will recognize if Text::CSV_XS is also installed and
will use that as its back-end if it is there.

## Using split and join

If the CSV file does not have any special feature (e.g. no quotes around fields, no embedded newline in any field) then
we can even use the internal `split` and `join` functions of Perl as explained in [this example](/how-to-read-a-csv-file-using-perl). Just remember, this will only work in the simple cases.

{% include file="examples/replace_column_in_csv_file_split.pl" %}

