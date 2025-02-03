---
title: "CSV - Comma Separated Values and Perl"
timestamp: 2016-05-28T12:30:01
tags:
  - Text::CSV
published: true
author: szabgab
archive: true
---


[CSV](http://en.wikipedia.org/wiki/Comma-separated_values) (where CSV stand for Comma-separated values) is one of the most
common file formats as it can be used to easily represent table-like data. Similar to what you would put in an Excel file
or in a Relational database where you used SQL.


## CSV file with multi-line fields

In this example we have simple fields separated by comma and we also have a field that contains both a comma and a newline as part of the value.
That field is wrapped in quotes `"` to make it clear it is a single unit.

{% include file="examples/data/multiline.csv" %}

This script expects the path to the CSV file as input and will print the content of each line using `Data::Dumper`.

{% include file="examples/read_and_print_multiline_csv.pl" %}

The output will look like this:

```
$VAR1 = [
          'Tudor',
          'Vidor',
          '10',
          'Hapci'
        ];
$VAR1 = [
          'Szundi',
          'Morgo',
          '7',
          'Szende'
        ];
$VAR1 = [
          'Kuka',
          'Hofeherke,
alma',
          '100',
          'Kiralyno'
        ];
$VAR1 = [
          'Boszorkany',
          'Herceg',
          '9',
          'Meselo'
        ];
```


If you'd like to access the individual elements in each row you can do it with the following syntax:
`$fields->[2];` which would access the 3rd element in the current row (indexing starts from 0).

For more details see the article explaining [how to read a CSV file using Perl](https://perlmaven.com/how-to-read-a-csv-file-using-perl).


## Text::CSV or Text::CSV_XS ?

[Text::CSV](https://metacpan.org/pod/Text::CSV) is a pure-Perl implementation which means you can "install" it by downloading and unzipping the distribution.
[Text::CSV_XS](https://metacpan.org/pod/Text::CSV_XS) implements the CSV parser in C which makes it a lot faster.

Luckily when using Text::CSV it will check if Text::CSV_XS is installed and if it is, the faster one will be used automatically.

So unless you want to force your users to always use Text::CSV_XS, you'd be probably better off using Text::CSV and letting your users decide if they want to "pay the price"?


## Alternative modules

* [Text::CSV](https://metacpan.org/pod/Text::CSV) a pure-Perl implementation
* [Text::CSV_XS](https://metacpan.org/pod/Text::CSV_XS) implement in C which makes it a lot faster
* [DBD::CSV](https://metacpan.org/pod/DBD::CSV) use SQL statements to access the data
* [Spreadsheet::Read](https://metacpan.org/pod/Spreadsheet::Read) a wrapper around Text::CSV and other spreadsheet readers to make your code nicer.

## Related Articles

* [Split CSV file into multiple small CSV files](/split-csv-file-into-multiple-files)
* [Multiple command line counters with plain TSV text file back-end](/multiple-command-line-counters)
* [How to read a CSV file using Perl?](/how-to-read-a-csv-file-using-perl)
* [How to calculate the balance of bank accounts in a CSV file, using Perl?](/how-to-calculate-balance-of-bank-accounts-in-csv-file-using-perl)
* [Calculating bank balance, take two: DBD::CSV](/calculate-bank-balance-take-two-dbd-csv)

* [Process CSV file (screencast)](/beginner-perl-maven-process-csv-file)
* [Process CSV file using Text::CSV_XS (screencast)](/beginner-perl-maven-text-csv-xs)
* [Process CSV file short version (screencast)](/beginner-perl-maven-process-csv-file-short-version)
* [One-liner sum of column in CSV](/beginner-perl-maven-oneliner-sum-of-csv)
* [How to replace a column in a CSV file using Perl](/replace-a-column-in-a-csv-file)
* [How to splice a CSV file in Perl (filter columns of CSV file)](/splice-csv-filter-columns)

