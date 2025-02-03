---
title: "How to extract a column using HTML::TableExtract"
timestamp: 2007-05-14T19:59:57
tags:
  - HTML::TableExtract
published: true
archive: true
---



Posted on 2007-05-14 19:59:57-07 by raprice

I am an intermediate perl user and have not been able to find
any documentation on how to extract a column from a table using
HTML::TableExtract. I am trying to extract historical financial
statement data from www.marketwatch.com. The link to the url is here: Marketwatch.com.
I essentially want to transpose the table at depth=1, count=1 after extracting
it so that each year is a row and each variable is a column.
The following simple program downloads the data using
WWW::Mechanize and extracts the table with HTML::TableExtract
and prints the output of each row.

```perl
#!/usr/bin/perl

use HTML::TableExtract;
use WWW::Mechanize;
use strict;

my $marketwatch = WWW::Mechanize->new( autocheck => 1 );
$marketwatch->get("http://www.marketwatch.com/tools/quotes/financials.asp?symb=ABSD&sid=0&report=2&freq=0");

chomp(my $html = $marketwatch->content);

my $table = HTML::TableExtract->new(keep_html=>0, depth => 1, count => 1, br_translate => 0 );
$table->parse($html);

foreach my $row ($table->rows) {
    print join("\t", @$row), "\n";
}
```

I am not able to figure out how to use the columns method.
My intuition makes me think it should be something like the following
(but my intuition is wrong):

```perl
foreach my $column ($table->columns) {
    print join("\t", @$column), "\n";
}
```

The error message I get says:

```
Can't locate object method "columns" via package "HTML::TableExtract".
```

The documentation doesn't shed much light (for me anyway).
I can see in the code of the module that the columns method
belongs to HTML::TableExtract::Table, but I can't figure out how to use it.
I appreciate any help.

Posted on 2007-05-15 14:50:06-07 by raprice in response to 5130

I got the following feedback in another forum and thought
I would post the response for posterity. The code works for extracting columns.
It looks like you need to call method columns from a
HTML::TableExtract::Table object and not a HTML::TableExtract object.
Maybe something like this could get you started:

```perl
my $table = HTML::TableExtract->new(keep_html=>0, depth => 1, count => 1, br_translate => 0 );
$table->parse($html);

my $t = $table->table(1,1);

foreach my $col ($t->columns) {
    print join("\t", @$col), "\n";
}
```

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/5130 -->


