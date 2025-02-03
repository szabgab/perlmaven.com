---
title: "Read dates from Excel file using Perl"
timestamp: 2022-11-23T05:30:01
tags:
  - Excel
published: true
author: szabgab
archive: true
---


There are several modules on CPAN that help your [read an Excel file](/read-an-excel-file-in-perl).
In this article we'll look at handling dates that are in Excel files.


We have an Excel file called [dates.xls](/files/dates.xls) that if you open you will see this:

![](/img/dates.png)

The file itself was created using Open Office running on Mac OSX, so it might not be 100% the format a real MS Excel
would create, but I hope this won't change the results. In any case, a lot can depend on the exact version of Excel file
format, so you might need to tweak the code to fit your files.


## Requirements Installation

If you run the code and get an error that starts like this:

```
Can't locate Spreadsheet/Read.pm in @INC (you may need to install the Spreadsheet::Read module) (@INC contains:
```

then you need to install [Spreadsheet::Read](https://metacpan.org/pod/Spreadsheet::Read).


If you get an error like this:

```
Parser for XLS is not installed at
```

then you also need to install [Spreadsheet-ParseXLSX](https://metacpan.org/release/Spreadsheet-ParseXLSX)
though [Spreadsheet-ParseExcel](https://metacpan.org/release/Spreadsheet-ParseExcel) might be enough.
It depends on the version of your Excel file.

## Spreadsheet::Read

In the first example we use  Spreadsheet::Read that makes the code reading the values very simple:

{% include file="examples/read_excel_dates.pl" %}

The output when using this script with the above Excel file:

```
A1: 05/14/48
A2: 05/14/1948
A3: Friday, May 14, 1948
A4: 14.05.1948
```

## Spreadsheet::ParseExcel

In the second example we used Spreadsheet::ParseExcel for a more detailed reading.

{% include file="examples/parse_excel_dates.pl" %}

The output when using this script with the above Excel file:

```
A1: 05/14/48
A2: 05/14/1948
A3: Friday, May 14, 1948
A4: 14.05.1948

A1: 17667
A2: 17667
A3: 17667
A4: 14.05.1948

--- Use the date from a cell ---
1899-12-30
1948-05-14
```

See also [dealing with dates as data in Excel](https://practicaldatamanagement.wordpress.com/2014/07/02/dealing-with-dates-as-data-in-excel/)

