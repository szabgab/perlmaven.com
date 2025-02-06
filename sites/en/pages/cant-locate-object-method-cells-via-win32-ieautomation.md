---
title: Can't locate Object method "cells" via Win32::IEAutomation
timestamp: 2010-12-27T22:39:09
tags:
  - Win32::IEAutomation
published: true
archive: true
---



Posted on 2010-12-27 22:39:09.205807-08 by shrutic

Hello, I m using Win32::IEAutomation package from CPAN on Windows platform. I m trying to find out the text on the table using cells function.

```perl
$ie->getTable("id:", "rt_NS");
print "\n$ie";
 my $third_cell = $ie->cells(1);
print "\n$third_cell";
$text = $third_cell->cellText;
print "\ntext=$text";
```

But I m getting above mentioned error. Please let me know which exactly package consists of Cells method which is referred on CPAN IE automation website.

Posted on 2010-12-28 02:15:46.174828-08 by reneeb in response to 13122

"cells" is a method from the Win32::IEAutomation::Table class. Your code should look like

```perl
my $table = $ie-&gt;getTable("id:", "rt_NS");
print "\n$ie";

my $third_cell = $table-&gt;cells(1);
print "\n$third_cell";

$text = $third_cell-&gt;cellText;
print "\ntext=$text";
```

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/13122 -->


