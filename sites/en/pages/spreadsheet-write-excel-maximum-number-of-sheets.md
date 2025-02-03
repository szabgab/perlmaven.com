---
title: "Spreadsheet::WriteExcel - Maximum number of sheets"
timestamp: 2006-03-28T20:53:14
tags:
  - Spreadsheet::WriteExcel
published: true
archive: true
---




Posted on 2006-03-28 20:53:14-08 by freshr

Hi, First thx for this very very useful and efficient package.
Since a couple of days I am struggling with a "Too many open files" issue.
I usually create workbook with more than 200 sheets. For a project I am working
on I need to create more than 650 sheets. I succeeded in finding a work-around
for the "Too many open files" problem, but now the generated excel sheets is *empty*.
Reducing the number of sheets to below 250 work fine, that is, the created workbook
is not empty and contains the correct information. But when I try to go beyond that
number the resulting file is always empty. What is strange being that
Spreadsheet-WriteExcel doesn't complain about a limit being reached.
It keeps accepting new sheets being added from 200 to more than 650.

Question: Is there a limitation in the number of sheet in a single workbook ?
I also read that temporary files are created for each sheet before they
get a chance to be stored in the final workbook.

Question: Does Spreadsheet-WriteExcel keeps those temporary files
opened 'til the end, that is, 'til the final workbook is created ?

Question: What may explain that the final workbook be empty when
*no* error is detected by the both Spreadsheet-WriteExcel package
and my Perl program ? Thank you in advance for any hints you may provide.

TIA.

Posted on 2006-03-29 03:00:30-08 by genericman in response to 2053

According to Microsoft Excel, the number of worksheets in a workbook
is "limited only by available memory." Current versions of
Excel cannot use more than 1 GB of memory even if more memory
is available on the system.
(Excel 2007 will use as much memory as the system will give it.)

In my experience, even if you could generate a well-formed workbook with 650 sheets,
it is unlikely that any Excel user would be able to open it without
running into Excel's memory limit.
I'm impressed that you could even get to 200 sheets without a problem, honestly. :)

Jason


Posted on 2006-03-29 08:15:17-08 by freshr in response to 2057

Hi, The number of sheets by itself (if not limited) does not have
a big impact on the size of the workbook, if each sheet does not
contain too much data. Doing more testing with the setting I have,
I can see that the maximum number of sheets that Spreadsheet::WriteExcel
can create go up to 247 sheets, but no more, without the resulting workbook being empty.
The resulting size is less than 3MB.
Really I doubt that Spreadsheet::WriteExcel explicitly limit the number of sheets it can create.
The documentation states the/a solution to the "File with a size of 0 Byte" issue,
is to explicitly close the workbook before exiting. Unfortunately doing this does
not fix the issue when wanting to have more than 247 sheets.

Question: Are there any other work-around for the "File with a size of 0 Byte" issue ?

TIA.

Posted on 2006-03-29 09:06:36-08 by jmcnamara in response to 2053

Re: Maximum number of sheets.

Some background: Spreadsheet::WriteExcel creates a temporary file for each worksheet and workbook.
This helps to greatly reduce the amount of memory required by S::WE and increases the speed substantially.

Question: Is there a limitation in the number of sheet in a single workbook?

Not from Spreadsheet::WriteExcel. However, there is generally a system
limit on the maximum number of open files and this will in turn
impose a limit of the number of temporary files that the module can use.
If a temporary file cannot be created then the module falls back
to storing the data in memory. If you have warnings turned on in your program
then you should see a warning message about this.
(Note: there is also a memory limit in Excel as pointed out by Jason above but that is a separate issue).

Question: Does Spreadsheet-WriteExcel keeps those temporary files opened 'til the end.

Yes. S::WE needs to know the final size of each Worksheet before it can merge them into a workbook.

Question: What may explain that the final workbook be empty when *no*
error is detected by the both Spreadsheet-WriteExcel package and my Perl program?

I'd suspect that you've exceeded S::WE's 7MB limit. Again "-w" or "use warnings"
should tell you if this is happening.
Try using Spreadsheet::WriteExcel::Big instead
(just change the use and new() statements in your program).

John.

Posted on 2006-03-29 12:33:56-08 by freshr in response to 2061

Hi, I already switched to Spreadsheet::WriteExcel::Big since a long time :).
Also I always enable warning using the '-w' switch. Even with warnings on,
S::WE (As you name it :) ) does not generate any warnings.
As I pointed it out in one of my previous post, S::WE keeps accepting
new sheet w/o complaining. Currently I am using version 2.11 of the Spreadsheet::WriteExcel.
So for short, you're saying that If it was a system limit causing this
than S:WE will be generating warning(s).
If that's the current behaviour of S::WE, then I'm lost :) Do you think it is
worth trying the *latest* version of Spreadsheet::WriteExcel ? TIA.

Posted on 2006-03-29 15:58:33-08 by jmcnamara in response to 2065

Can you run the following program with some upper value that will
exceed the maximum number of open files that your system allows:

```perl
#!/usr/bin/perl -w
use strict;
use Spreadsheet::WriteExcel;
my $workbook = Spreadsheet::WriteExcel->new("multi.xls");
my $worksheet;
for ( 1 .. 1025 ) {
    $worksheet = $workbook->add_worksheet();
    $worksheet->write( 0, 0, "Hi Excel!" );
}
```

Then let me know what the output is. Also, let me know your OS and perl version.

John.

Posted on 2006-03-29 17:09:05-08 by freshr in response to 2068

Hi, First I had to use Spreadsheet::WriteExcel::Big otherwise the script was failing,
That is, above a certain number of sheets, whatever their size one need to use the
Big version of S::WE. I also set the maximum number of iterations to 2048 instead
of '1025'. Unfortunately, S::WE did not complain. It accepted all of our requests,
that is, creating 2048 sheets. The resulting workbook was desperately *empty* :( .
Also no warning was generated. So I decided to find the maximum number of sheets
below which the resulting file is empty. The result being that as soon as you
are above 250 iterations (sheets), the 'multi.xls' become empty.
An absolutely no warning is generated. That is, for 251 sheets to 2048 sheets (and more)
the resulting workbook is empty (no warning). Here are the other information you requested:

OS version: SunOS 5.8 sun4u sparc SUNW,Ultra-5_10 Solaris
Perl version: v5.8.3 built for sun4-solaris-thread-multi HTH.

Posted on 2006-03-30 09:42:10-08 by jmcnamara in response to 2069

I need a little more information. Can you let me know the maximum open file
value on your system returned by `'ulimit -n'`.
Also can you run the following program and post the output. Replace 2000 with something
that is larger than the value of `'ulimit -n'`:

```perl
#!/usr/bin/perl -w
use strict;
use IO::File;
my @tempfiles;
for my $i (1 .. 2000) {
    my $fh = IO::File->new_tmpfile();
    die "Failed to created file number $i.\n"
       unless defined $fh;
    push @tempfiles, $fh;
}
```

Also to ensure that we are comparing like with like can you post the output from the following program.

```perl
#!/usr/bin/perl -w
print "\n Perl version : $]";
print "\n OS name : $^O";
print "\n Module versions: (not all are required)\n";
my @modules = qw( Spreadsheet::WriteExcel Parse::RecDescent File::Temp OLE::Storage_Lite );
for my $module (@modules) {
    my $version;
    eval "require $module";
    if (not $@) {
        $version = $module->VERSION;
        $version = '(unknown)' if not defined $version;
    } else {
        $version = '(not installed)';
    }
    printf "%21s%-24s\t%s\n", "", $module, $version;
}
```

John.

Posted on 2006-03-30 12:04:47-08 by freshr in response to 2077

Hi, The output of $ ulimit -n is 1024 I set it to this value just
make sure I had enough room for reading all of my input files (more than 600).
I'll do the tests you asked and let you know. Really thank you for taking
the time to help me on that issue. -freshr

Posted on 2006-03-30 12:16:20-08 by freshr in response to 2079

Me again, :) The output of `'ulimit -n'` is 1024.
The output of the first of your script (w/ IO::File) is

```
Failed to created file number 254.
```

The output of the second script (w/ S::WE) is

```
Perl version : 5.008003
OS name : solaris Module versions: (not all are required)
Spreadsheet::WriteExcel 2.11
Parse::RecDescent 1.94
File::Temp 0.14
OLE::Storage_Lite 0.14
```

HTH, -freshr

Posted on 2006-03-30 14:06:24-08 by jmcnamara in response to 2081

Failed to created file number 254.

This is the same limit that S::WE is encountering. I don't know why it is
approximately 256 and not 1024 as indicated by ulimit. Perhaps there is a smaller limit per process.

Anyway, the 253 file limit indicated by the above program is also the limit
to the number of worksheets that you can add. If you can increase this
limit then you should be able to add more worksheets.

John.

Posted on 2006-03-30 18:28:40-08 by freshr in response to 2082

Hi, Thank you very much your time. Now it is clear the S::WE is not the culprit.
Just one last question, why then S::WE silently accept requests to add sheets
above the system limit w/o issuing any warning messages ? Is it normal ?

Thanks anyway.

I will try to struggle with IT guys to have limit extended, if possible. Regards, -freshr

Posted on 2006-03-31 09:46:10-08 by jmcnamara in response to 2085

> Just one last question, why then S::WE silently accept requests to add sheets
above the system limit w/o issuing any warning messages?

I don't know why that is. When I ran the test program on a system similar
to yours I got loud warnings from Perl about not being able to load Carp::Heavy
(caused by a lack of available file handles).

John.


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/2053 -->

