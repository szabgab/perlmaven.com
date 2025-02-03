---
title: "How to read a CSV file using Perl?"
timestamp: 2012-07-28T12:45:56
tags:
  - CSV
  - split
  - Text::CSV
  - Text::CSV_XS
published: true
books:
  - beginner
author: szabgab
---


Reading and processing text files is one of the common tasks done by Perl. For example, often you encounter
a [CSV file](http://en.wikipedia.org/wiki/Comma-separated_values) (where CSV stand for Comma-separated values)
and you need to extract some information from there. Here is an example with three solutions.

Good, Better, Best.

The first is a reasonable solution for simple CSV files, that does not require anything beyond Perl.

The second fixes some problems caused by a slightly more complex CSV files.
The third is probably the best solution. The price is that these solutions depend on a
module from CPAN.

Pick the one that matches your needs.


I got a CSV file that looked like this:

{% include file="examples/data/simple.csv" %}

This is a CSV file. In each row there are fields separated with comma.

Of course the separator can be any character as long as it is the same in the whole file.
Most common separators are comma (CSV) and TAB (TSV) but people often use semi-colon or pipe | as well.

Anyway, the task was to summarize the number in the 3rd column.

## The algorithm

The process should go like this:

<ol>
<li>Read in the file line by line.</li>
<li>For each line, extract the 3rd column.</li>
<li>Add the value to a central variable where we accumulate the sum.</li>
</ol>

We have already learned earlier how to read a file line by line so
we only need to know how to process each row and how to extract the
3rd column.

I cannot use `substr()` easily as the location of the 3rd field is changing.
What is fixed is that it is between the 2nd and the 3rd comma.

I could use `index()` 3 times on each row to locate the 2nd and the 3rd comma,
and then use `substr()` but Perl has a much easier way for this.

## Using split

`split()` usually gets two parameters. The first is a knife, the second is the string that
needs to be cut in pieces.

The knife is actually a regular expression but for now we can stick to simple strings there.

If I have a string such as `$str = "Tudor:Vidor:10:Hapci"` I can call
`@fields = split(":"  ,   $str);`. The array `@fields` will be filled
with 4 values: "Tudor", "Vidor", "10" and "Hapci". If I `print $fields[2]`
I'll see 10 on the screen as the indexing of the array starts from 0.

In our case the field separator character is a comma `,` and not a colon
`:` so our call to split will look like this:
`@fields = split("," , $str);` though we won't write the parentheses.


We can write our script like this:

{% include file="examples/read_simple_csv.pl" %}

If you save this as csv.pl then you will be able to run it as
`perl csv.pl data.csv` providing the input csv file on the command line.

## Comma in the field

Every time you get a CSV file you can use this script to add up the values in the 3rd column.
Unfortunately at some point you get warnings while running your script.

`Argument " alma"" isn't numeric in addition (+) at csv.pl line 16, <$data> line 3.`

You open the CSV file and it looks like this:

{% include file="examples/data/quoted.csv" %}

As you can see the 2nd field in the 3rd row has a comma in the value so the people who wrote the file
put the whole field in quotes: `"Hofeherke, alma"`. This is totally normal within the "standard"
of CSV, but our script cannot properly handle the situation. `split()` does not care about the
quotes, nor does it understand anything about CSV. It just cuts where it finds the separator character.

We need a more robust solution to read CSV files.

## Text::CSV

Luckily we can find a module on CPAN called [Text::CSV](https://metacpan.org/pod/Text::CSV) that is a full CSV reader and writer.

This module is written using Object Oriented Programming (OOP) principals.
Even if you don't know what OOP is, you don't have to worry. We won't really learn OOP at this point,
we'll just use the module. We learn a little more syntax and a few expression, just so,
that people who are familiar with object oriented programming
can connect to their knowledge.

Here is the code:

{% include file="examples/read_quoted_csv.pl" %}

`Text::CSV` is a 3rd-party extension to Perl. It provides a set of new functionality,
namely reading, parsing and writing CSV files.

Perl programmers call these 3rd-party extension modules, though people coming from
other languages might be more familiar with words such as library or extension.

At this point I assume you already have the module installed on your computer. We discuss separately
how to install it.

First we need to load the module using `use Text::CSV;`. We don't need to say what to import
as this module does not export anything anyway. It works in an object oriented way: you need to create
and instance and use that instance.

The module itself, Text::CSV is the class and you can create an instance, also called object, by
calling the constructor. In Perl there is no strict rule how to name the constructor
but nevertheless most people use the name "new". The way to call the constructor on the class is using
the arrow `->`.

This call creates an object setting the separator character to be comma (,).
An object is just a scalar value.

Actually comma being the separator character is the default, but it seems it is clearer if I set it explicitly.

`my $csv = Text::CSV->new({ sep_char => ',' });`

Most of the other code is the same, but instead of the 2 lines of split and adding to $sum,
now we have more lines that need explanation.

The Text::CSV module does not have a split function. In order to split the code you need to call the
"parse function" - or, if we want to use the OOP phrase - the "parse method". Again we use the arrow (->)
notation for this.

`$csv->parse($line)`

This call will try to parse the current line and will split it up to pieces. It will
not return the pieces. It will return true or false depending on its success or failure
to parse the string. One common case when it would fail is if there is only a single quotation
character. eg.: `Kuka,"Hofeherke, alma,100,Kiralyno`

If it fails we fall in the `else` part, print a warning, and go to the next line.

If it succeeds we call the `fields` method that will return the pieces
of the previously chopped up string. Then we can fetch the 3rd element (index 2) which
should be the required number.

## Multi-line fields

There can be further "problems" with the CSV file. For example some fields might contain embedded newlines.

{% include file="examples/data/multiline.csv" %}

The way we currently handle the CSV file cannot solve this problem but the [Text::CSV](https://metacpan.org/pod/Text::CSV)
module provides a way to solve that too.

This example is based on a comment by H.Merijn Brand, the maintainer of the
[Text::CSV_XS](https://metacpan.org/pod/Text::CSV_XS) module:

{% include file="examples/read_multiline_csv.pl" %}

This changes the whole way we handle the file. Instead of reading manually line-by-line,
we ask the Text::CSV module to read, what it considers a line. This will let it handle
fields with embedded newlines. We also turned on a couple of other flags in the module
and when we opened the file we made sure it can handle UTF-8 characters correctly.

In addition, in this example the `getline` method returns a reference to an array
- something we have not learned at this point yet - so when fetching the 3rd element (index 2)
we need to dereference it and use the arrow syntax to fetch the value: `$fields->[2]`.

Lastly, after we finished the loop we still need to check if we reached the end-of-file (eof)?
getline will return false both when it reached the end of file and if it encounters an error.
So we check if we reached the end of the file. If not, then we print the error message.

## Hofeherke

BTW, in case you were wondering, the values in the CSV file are the names of the
[7 dwarfs](http://hu.wikipedia.org/wiki/H%C3%B3feh%C3%A9rke_%C3%A9s_a_h%C3%A9t_t%C3%B6rpe_%28film,_1937%29).

In Hungarian.

## comments

Hello
I have *.mc file and need to convert to it .csv file by using mc2csv command, so please tell how to do this

<hr>
Another approach is DBI:
https://search.cpan.org/~hmbrand/DBD-CSV-0.49/lib/DBD/CSV.pm

<hr>

I think that in the first example without the module of CSV you are not extracting the 3rd column, what you are doing in adding the values of the 3rd column. Ej. 10+7+100+9 = 126
<hr>

can you please share how do we download a csv file in perl using headers like these


header('X-Sendfile' => $file);
header('Content-type' => "application/octet-stream;");
header('Content-Disposition' => "attachment; filename=\"".encode_utf8($filename)."\";");
debug('halting for xsend');
halt('xsend');

<hr>
How can i read the variables in csv file as a variables wise and how to write into a txt file as variables wise

<hr>
Text::CSV seems to ignore the last line of files not ending with a newline. How can this be avoided?

