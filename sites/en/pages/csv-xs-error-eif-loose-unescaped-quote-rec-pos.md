---
title: "CSV_XS ERROR: 2034 - EIF - Loose unescaped quote @ rec 5 pos 194"
timestamp: 2019-01-30T20:30:01
tags:
  - CSV
published: true
author: szabgab
archive: true
---


What if you get an error like in the title while reading a perfectly good looking CSV file?



Someone sent me this CSV file:

{% include file="examples/data/input_file_actual_data.csv" %}

and a 100 lines long script asking why does he get the above error.

I've never encountered the above error, so the first thing I did was creating a minimal script that
only reads the CSV file to see if that exhibits the problem:

{% include file="examples/minimal_csv_reader.pl" %}

It did, though the error I got was slightly different. I got:

**CSV_PP ERROR: 2034 - EIF - Loose unescaped quote @ rec 5 pos 194**


It seems the difference is that the other person had Text::CSV_XS installed and I did not, so
in my case Text::CSV was using the PP (Pure Perl) backend.

I was still baffled. I opened the CSV file went to line 5 position 194 and there was a quote character `"`.
At first I though it might not be an ASCII character, just one that looks similar, but using a small script that prints
the `ord` of the characters I eliminated that possibility.

That's when it stroke me, [CSV files](/csv) can have their values within quotes and then they can even have
newlines inside the field. However in this case the quote character was not the first character of a field. It did not
come immediately after a field-separator (which is comma in this case).

So either we need to change the CSV file and escape the quote characters. By default the escape character is a double
quote character, so we have to duplicate them, but this will only work if the whole field is insied double quotes:


{% include file="examples/data/input_file_changed_data.csv" %}


Probably the better route is to tell the CSV reader that the double-quote `"` is not the escape character.
We do that by explicitly saying what is the quote character:


{% include file="examples/minimal_csv_reader_fixed.pl" %}

A single-quote `'` in this case.

