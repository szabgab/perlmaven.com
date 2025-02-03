---
title: "Reading CSV file as many hash-es"
timestamp: 2020-07-25T07:30:01
tags:
  - CSV
  - Text::CSV
  - column_names
  - getline_hr
  - getline
published: true
author: szabgab
archive: true
---


Given the following [CSV file](/csv) how can we read it line-by-line?

There are two main ways, read each line as an array, or read each line as a hash,
where the keys are taken from the first row of the file.


The sample input file:

{% include file="examples/data/planets.csv" %}

## Read each CSV line as an array

{% include file="examples/read_planets_array.pl" %}

Each row is a reference to an array holding the values of the given row.
Note, the first row is the header.

The dumped output will look like this:

{% include file="examples/read_planets_array.out" %}

## Read each CSV line as a hash

In this case we read in the first line and set it as the list of columns.
Then when we read in the subsequent rows from the CSV file, the method will
return a hash for each row.

{% include file="examples/read_planets_hash.pl" %}

{% include file="examples/read_planets_hash.out" %}


