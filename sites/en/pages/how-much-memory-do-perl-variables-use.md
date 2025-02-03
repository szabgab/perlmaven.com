---
title: "How much memory do Perl variables use?"
timestamp: 2014-01-16T21:50:01
tags:
  - memory
  - Devel::Size
published: true
author: szabgab
---


There are cases when it might be quite important to know how much each variable in Perl uses.
For this [Devel::Size](https://metacpan.org/pod/Devel::Size) module provides two functions.
Both `size` and `total_size` accept a reference to a variable or a data structure.
The difference between them is that in complex data structures (aka. arrays and hashes), `size`
only returns the memory used by the structure, not by the data.


There are a few more caveats pointing out some differences between the memory Perl asked for, what Devel::Size
can report, and what the operating system has actually allocated. If interested, there is a nice explanation
in the [documentation of Devel::Size](https://metacpan.org/pod/Devel::Size)

The following script tries to show some basic values:

{% include file="examples/memory_of_variables.pl" %}

## The environment

These results were generated on 64 bit OSX, running perl 5.18.2 using Devel::Size 0.79.
(BTW I got almost the same results when I ran the script on 5.18.1, except that the
values for CODE-references were 8 bytes smaller.)

## Some observations

The size of code-references look huge. I wonder if those number are correct.

Strangely `bless` does not change the size of the reference. Or at least, it is not reported.

Memory is allocated in 16 byte chunks for strings. Hence the memory used by a 1-character long string is
the same as used by a 15-character long string.

Neither setting the string to the empty string (`$x = '';`),
nor assigning undef to it (`$x = undef;`) reduced the memory usage.
I had to call `undef $x;` for that. Even then it went back only to 40, instead of the original 24.

In arrays, every element uses 8 bytes + memory allocated to the scalar container + the data.

Setting `@y = ();` eliminated the memory allocation of the date
(or at least `total_size` does not show it any more)
Calling `undef @y;` also freed the memory allocated to the structure.

In hashes it's even more complex. I won't attempt to describe it.
The documentation of Devel::Size has some explanation.

## The actual results look like this

```
                          size    total_size
SCALAR                       24    24
ARRAY                        64    64
HASH                        120   120
CODE                       8452  8452

SCALAR                       24    24
SCALAR-1                     56    56
SCALAR-15                    56    56
SCALAR-16                    72    72
SCALAR-31                    72    72
SCALAR-32                    88    88
SCALAR=""                    88    88
SCALAR=undef                 88    88
undef SCALAR                 40    40

ARRAY                        64    64
ARRAY-1                      96   152
ARRAY-15                     96   152
ARRAY-16                     96   168
ARRAY-31                     96   168
ARRAY-32                     96   184
ARRAY-1-1                    96   208
ARRAY-1-1-1-1                96   320
ARRAY-1-1-1-1-1             104   384
ARRAY-1-1-1-1-1-1           112   448
ARRAY-1-1-1-1-1-1-1         128   520
ARRAY = ()                  128   128
undef ARRAY                  64    64

HASH                        120   120
HASH x => undef             179   203
HASH x => "x"               179   235
HASH "x" x 10 => "x" x 20   188   260
HASH 10 * 10 + 10 * 20      864  1584
HASH=()                     184   184
undef HASH                  120   120
blessed HASH                120   120

CODE                       8516  8516
CODE2                      8612  8612
CODE3                      8820  8820
```

## Comments

Hi Gabor,

I am running a script, i am creating a string containing 20 thousand records to be written in xml file in each iteration of loop. Memory consumption is increasing even after using undef variable holding string. Is there any way to release memory after use the variable in each iteration.

---

In general when you assign new data to a varaible the old memory is reused so the problem might be elsewhere. Without seeing your code it is quite impossible to point to the problem.

---

my $start=1;my $end =300000;
($succesMsg) = &fetch_data($start,$end,$total_count,$dbh);
($msg) = &disconnect_db($dbh);

sub fetch_data
{
my $start = shift;
my $end = shift;
my $total_count = shift;
my $dbh = shift;
@Data_arr1 = ();
if($dbh)
{
my $sqlsplit="select * from table where rn between $start and $end";
my $sthsplit = $dbh->prepare($sqlsplit);
if($sthsplit->execute())
{
while (my $hasplit = $sthsplit->fetchrow_hashref)
{
$global_record++;
push(@Data_arr1,$hasplit);
}
($succesMsg) = &splitquery(\@Data_arr1,$total_count,$global_record,$dbh,$start,$end);
}
}
else
{
&print_oracle_error(__FILE__,__LINE__,"Cant connect to database","","$DBI::errstr");
}
}

sub splitquery
{
my $arr_ref=shift;
my $total_count=shift;
my $global_record=shift;
my $dbh = shift;
my $start=shift;
my $end=shift;
my $final_xml = '';
my $final_xml1 = '';
@data_arr = @$arr_ref;

foreach my $ha (@data_arr)
{
$counter++;
$record++;
$fullpath = qq~https://somepath.html~;
$xml = qq~<url><loc>$fullpath</loc>~;
$xml .= qq~<image:image><image:loc>$largeimagePath</image:loc><image:title>$title</image:title></image:image>~;
$xml .= qq~<xhtml:link rel="alternate" media="only screen and (max-width: 640px)" href="url"/></url>\n~;
$final_xml .= $xml;
undef($xml);
if($counter==20000)
{
$j++;
$counter=0;
$final_xml1=qq~\n<urlset xmlns="some path">\n$final_xml</urlset>~;
$file_name="some dynamic filePath";

unless(open (WRITE,">$file_name"))
{
my $log_message = "\nFailed To Open File \n$file_name \nAt LINE: ".__LINE__ ."\nIn FILE:".__FILE__;
exit;
}
print WRITE $final_xml1;
close(WRITE);
undef($final_xml1);
undef($final_xml);
sleep(1);
}
}
undef(@data_arr);
undef($arr_ref);
if($record==300000 && $global_record < $total_count)
{
$start= $global_record+1;
$end = $global_record+300000;
&fetch_data($start,$end,$total_count,$dbh);
}
else
{
#send mail
}

}

---
This code runs for around 20000000 of data, i am fetching 300000 data in one iteration and writing that in xml file. Main issue is with $final_xml variable which is getting appended some text in each iteration.

---

One more thing, i am really very glad with your so fast response.

----


You don't need all those calls to undef and setting arrays to (), It is better to re-declare them using my in every iteration and/or in every call the the function. That will take care of reusing the memory.

It seems splitquery and fetch_date call each other, but it is unclear to me why? Why not only one calls the other?
Isn't that recursion the source of the memory leak?

Also I'd put use strict and use warnings at the top of the code and clean up any errors/warnings. That can help track down issues.
Calling $sthsplit->finish at the end of the fetch_data function might also help in case your version of the Oracle driver has some issues.

---
I had not sent you whole script, in complete script i am using strict and warnings. There are no warnings in code.
Actually i am permitted to fetch only 3,00,000 data in one go so i am using recursion to fetch 3,00,000 data and create 15 xml files using that data, each xml file contains 20,000 records. There are 1,60,00,000 records in table.
$final_xml variable is defined outside of the loop and script is appending text in each iteration till 20,000 records. This variable is not releasing memory due to which script is eating up all the server memory(6 GB) in no time.

---
If you don't paste the whole script then how do you expect me to understand it?
Anyway, if you keep appending to $final_xml then why are you surprised it keeps growing? Maybe you need to write the partial xml out in chuncks or with a SAX XML creator. But then again, do you really want to create a file that is so big? What will be able to read it?
---
Please excuse me for this, I had sent that part of script which is causing memory leakage.
This script is used to create sitemap for a website, We store 20k records in each sitemap(xml) file, google crawlers use this to index.
I keep on appending some string(e.g. URLs, images) to $final_xml variable for 20K records and then i write it to xml file and want to release this memory to be used in same process for next iteration of $final_xml variable to write in another xml file. Thus we are making around 900 xml files. Please let me know if my question is not clear.
---
It is now a bit clearer. I don't see any reason for the recursion here, you could remove that and that might automatically fix the issue. Besides that I don't have any more ideas.

<hr>

I am planning to store 5GB data in array and then start processing . Just wanted to know is there any limitation for storing in the array .
---
AFAIK, just the size of the memory in your computer.

---
Hello, Thanks for replying .There are total 6 files having 500MB , while reading those and storing into an array its getting out of memory . Is there any way to solve this .

---
How much memory does your computer have? How much is free when you start running your program? Which Operating System are you running on?
---
Its a linux 64 bit .. but not sure how much is free while running the program .
---
What is the result of the

free -h

command?
---

its 64 GB and 59 GB is free.
---

Then it should work.

Try loading one file and one it is loaded while the program is still running check how much memory do you have then. That will help you see if a single file can be loaded and how much it really uses. You did not say what format is your file and how do you store the data in memory? Can you paste a snippet of your code?
