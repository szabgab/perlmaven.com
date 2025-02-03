---
title: "How to create an Excel file with Perl?"
timestamp: 2015-02-03T13:45:56
tags:
  - Excel
  - Excel::Writer::XLSX
  - xls
  - xlsx
published: true
author: szabgab
---



While Excel files are not the best way to communicate between computers,
if the intended audience have human traits, it can be a good way to send reports.

For example, I had a client that used Perl to generate reports from their database.
I'd run huge and long running SQL queries, build a multi-sheet Excel file,
and send it as an email-attachment.

The following example works on Windows, Linux, Unix and probably also on other operating systems
as well, though I have not tried them.


We are going to use the excellent [Excel::Writer::XLSX](https://metacpan.org/pod/Excel::Writer::XLSX)
module written by John McNamara and we are going to see several use-cases, based on the examples supplied with the
package.

Let's start with the most basic file.

{% include file="examples/create_first_excel.pl" %}

Obviously we need to load the module first. The `new` constructor
should get the name of the file we are creating. It is recommended to use the
xlsx extension for files created with this module.

The return value of the `new` call is an object representing the whole
Excel file. It is usually called `$workbook`, though you can name it any
way you like it.

Every Excel file consists of one or more sheets. The data can be found in those sheets.
The next step thus, is to create the first sheet. We do that by calling the
`add_worksheet` method of the `$workbook` object. This both adds the sheet
to the workbook and returns the object representing this sheet. We usually assign it
to a variable called `$worksheet`.

Then we need to call the `write` method to add data to the worksheet. Each call has
2 parameters. The first one is the cell address. As you might recall the rows in Excel
are numbered from 1, and the columns are marked by letters A, B, C...
<b>A1</b> being the top-left corner.


The last thing we need to to is to `close` the workbook. Strictly speaking this is
not necessary as the file will be automatically saved and closed when the script ends or
when the variable representing it goes out of scope, but it can be a nice hint of our intentions
to the maintenance programmer.

Once the file is saved you can open it with Microsoft Excel or any other software that can handle
this format. For example, I don't have Excel installed on my computer so I used the Calc application
of Libre Office.

This is how it looks like:

<img src="/img/excel1.png" alt="Excel example 1" />

## Adding formulas

Having fixed content in the Excel file can be already very useful in a report,
but the real power of Excel is in adding formulas. So we replaced the
two calls to `write` in the previous example with 4 new calls.

The first two will put the values 3 and 4 in the first and second row of column A.
The other two calls add two formulas. The first one is a simple addition,
the second one is a call to the built-in `SUM` function of Excel.

```perl
$worksheet->write( "A1", 3 );
$worksheet->write( "A2", 4 );
$worksheet->write( "A3", "=A1+A2" );
$worksheet->write( "A4", "=SUM(A1:A3)" );
```

The result can be seen here:
<img src="/img/excel2.png" alt="Excel example 2" />

## Adding color using formats

People, especially in management, like to have colors in their reports.
Just as from within Excel, we too can use formats to change how individual
cells look like.

Again we replace the `write` calls in the earlier example by the following code:

```perl
my $error_format = $workbook->add_format(
    color     => 'red',
);
$worksheet->write( "A2", "Status" );
$worksheet->write( "B2", "Broken", $error_format );
```

The first step we do is create a format object.
It is going to be part of the `$workbook`, that represents the
whole file, and it is also returned to a scalar variable. We can use this variable
as the 3rd parameter of the `write` method.


The resulting file will look like this:
<img src="/img/excel3.png" alt="Excel example 3" />

## Address cells using coordinates

While the cell names A1, A2, B1, etc.. used so far might be convenient
in some cases, there are other cases when we would like to be able
to handle the two axis as independent coordinates.

The Excel::Writer::XLSX module allows us to do this using the same
`write` method.

Going back to the first example, we could have written it this way as well:

```perl
$worksheet->write( 0, 0, "Hi Excel!" );
$worksheet->write( 1, 0, "second row" );
$worksheet->write( 2, 3, "(2,3)" );
```

In this case the first parameter is the row number, the second parameter
is the column number and the third is the value to be added.
The 4th would be the format.

The top left corner or A1 is (0,0). A2 is (1,0), B1 is (0, 1) etc.

At first it can be a bit confusing, but there are applications when
it is easier to access the cells using the coordinates.

<img src="/img/excel4.png" alt="Excel example 4" />

## More

There is a lot more we can do with Excel and I am going to show further examples soon.



## Comments

While running code I am getting the error as follows.(creating an Xls sheet code)

Can't locate Excel/Writer/XLSX.pm in @INC (you may need to install the Excel::Writer::XLSX module) (@INC contains: /usr/lib/perl5/5.26/site_perl /usr/share/perl5/site_perl /usr/lib/perl5/5.26/vendor_perl /usr/share/perl5/vendor_perl /usr/lib/perl5/5.26/core_perl /usr/share/perl5/core_perl) at jdoodle.pl line 5.
BEGIN failed--compilation aborted at jdoodle.pl line 5.
Command exited with non-zero status 2

can u please help me in this

----

Hey THANUGULA SRIKANT,

    What is INC?


INC is an array which consits the paths for the moules we mention in our program, basically funtions we use in basic perl program will be present in those directories.

    What is the issue?


This is error will be caused when the perl module [ in your case Excel/Writer/XLSX.pm ] is not avilabel in the directories mentioned.

    How to solve?


If you are the root user,
Download package [in your case Excel/Writer/XLSX.pm] from metacpan [ in your case this is the URL for package ] and install in your system.
If you are not the root user,
step 1 : Download the package
step 2 : untar the file
step 3 : get the full path for the lib directory which will present inside that directory
step 4 : include the path in the perl file.
For example full path for lib directory is

    /home/user/package/lib


Include this line in the perl file.

    use lib "/home/user/package/lib";



