---
title: "Split up and flatten CSV file"
timestamp: 2018-05-07T15:30:01
tags:
  - CSV
  - split
  - Text::CSV
published: true
author: szabgab
archive: true
---


Given a CSV file like this:

{% include file="examples/plain.csv" %}

How can you convert it to a file like this:

{% include file="examples/flattened.csv" %}


## Solution with split

Using [split](/how-to-read-a-csv-file-using-perl) is not going to work for every CSV file,but for simple ones, like the input file on our example it can work as well.

{% include file="examples/flatten_csv.pl" %}

Run it this way:

```
perl examples/flatten_csv.pl examples/plain.csv examples/flattened.csv
```


## Solution using Text::CSV

The more generic solution using Text::CSV:

{% include file="examples/flatten_text_csv.pl" %}

## Comments

sub slurp { local (@ARGV,$/)=shift; readline; }

my @_a=slurp($ARGV[0]) =~ m{([^,\n]+)[,\n](?{print "$1\n"})}g;


