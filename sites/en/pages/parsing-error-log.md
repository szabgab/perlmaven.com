---
title: "Help with perl (parsing error log)"
timestamp: 2013-01-01T11:45:56
tags:
  - parsing
published: true
author: szabgab
---



Today is 1st January 2013. It is customary to make big decisions, to plan out the whole year,
and then to desperately fail in implementing the "New Year's Resolution".

Instead of doing that, let's spend this day with the real purpose of this site. Helping people with Perl.

A few days ago I got an e-mail asking for help. Let me quote this for you, without any personal information.


## The request

I'm trying to learn how to use perl to process various types of files.
I can do it with Pascal, C or VBA but don't know how to do it
effectively with perl yet. The following lines represent lines from an
error file:

```
================================================================
SOURCE LINE   00347
&N 77_F1_SOE_FREE
              ^
NOT A VALID NAME

SOURCE LINE   00390
&N SCAN_TIME_S
              ^
NOT A VALID NAME

SOURCE LINE   00433
&N XMIT_FAIL_TD
              ^
NOT A VALID NAME
==========     ERRORS  ON  ENTITY    77CF1007      ===========

SOURCE LINE   00482
ASSOCDSP = ""
             ^
MISSING QUOTE

SOURCE LINE   00483
$CDETAIL = ""
             ^
MISSING QUOTE

SOURCE LINE   00488
PRIMMOD = -
          ^
NOT A VALID NAME

SOURCE LINE   00489
PLCADDR = 33003
^
NAMED ITEM DOESN'T EXIST

SOURCE LINE   00490
PVHCAR   = LINEAR
^        ^ ^
NAMED ITEM DOESN'T EXIST
NAMED ITEM DOESN'T EXIST
NAMED ITEM DOESN'T EXIST

SOURCE LINE   00515
CCSRC = 0
^
NAMED ITEM DOESN'T EXIST
"MODNUM   "
MISSING DATA
"PVSRCOPT "
INVALID ENTRY
"$AUXUNIT "
INVALID ENTRY
==========     ERRORS  ON  ENTITY    77CF1008      ===========

SOURCE LINE   00525
ASSOCDSP = ""
             ^
MISSING QUOTE

SOURCE LINE   00526
$CDETAIL = ""
             ^
MISSING QUOTE

SOURCE LINE   00531
PRIMMOD = -
          ^
NOT A VALID NAME

SOURCE LINE   00532
PLCADDR = 33004
^
NAMED ITEM DOESN'T EXIST

SOURCE LINE   00533
PVHCAR   = LINEAR
^        ^ ^
NAMED ITEM DOESN'T EXIST
NAMED ITEM DOESN'T EXIST
NAMED ITEM DOESN'T EXIST

SOURCE LINE   00558
CCSRC = 0
^
NAMED ITEM DOESN'T EXIST
"MODNUM   "
MISSING DATA
"PVSRCOPT "
INVALID ENTRY
"$AUXUNIT "
INVALID ENTRY

========================================================
```

The first line shows which line in the original file is in error.
The second line which starts with &N shows which record (key field)
contains the error.
The third line tells what kind of error it is.

How would you process this file in perl?

Thanks,
Foo

## Is there a parser on CPAN?

I don't know what kind of format is this, but I assume Foo knows.
So the first thing I'd do is try to check if there is already a
[module on CPAN](http://metacpan.org/),
that can parse such files.

If that fails, only then would I start to think how to parse it myself.


## Trying to understand the problem

After a few days of delay, while I had to fix some other things, I read the e-mail
and started to wonder what is the real objective here? Besides learning Perl.

What does Foo want to extract from this file?

I sent an e-mail reply waiting for clarifications, but let's see what can
we do with this.

I think the === lines at the top and bottom were only added to separate the real data
from the rest of the e-mail. I saved the data, the parts between those two lines
in a file called error.log. I'll process that file from now on.

<h3>Entities</h3>

As I can see there are entities in this file separated with lines like this:

==========     ERRORS  ON  ENTITY    77CF1008      ===========

The first part does not have such heading, I wonder if that was only left out from the
snippet I got, or if there can really be an entity without such header. Or, if this
is not even a header.

Without further input I'll assume these are entity names and there can be a general entity without
a name.

## Blocks

As described in the e-mail, the first line shows the line number, the next line, starting with &N shows the record,
and the third line is the actual error. If I look at this example I can see the 3 lines, but I have to
note the error text is on the 4th line. The 3rd line holds a caret, probably indicating a location in the line.

```
SOURCE LINE   00347
&N 77_F1_SOE_FREE
              ^
NOT A VALID NAME
```

That would be fine, but I see other blocks as well.
For example in this block, there is no &N on the second line, and there are 3 rows with error messages.
(and 3 carets on the 3rd line).

```
SOURCE LINE   00490
PVHCAR   = LINEAR
^        ^ ^
NAMED ITEM DOESN'T EXIST
NAMED ITEM DOESN'T EXIST
NAMED ITEM DOESN'T EXIST
```

In order to make it easier to write about this, I'll call a set of lines a **block** if they start with the
expression "SOURCE LINE" and finish when the next block starts. Actually, a block can also end by the
header of a new entity or by the end of the file. So we'll need to handle these special cases.

## What can be extracted?

I can think of various things that can be extracted from such file:

How many (error) blocks were in each entity and in total?

Which error messages appeared and how frequently?

## Processing the file - first step

Usually in Perl we read files line-by-line. Especially as we don't know how big the files are. Maybe the file
is bigger than the available memory in the computer? We cannot assume to be able to read the whole file
into memory. So we read line-by-line.

The problem is, that in this case, we need to process a block that holds information from several lines as one unit.
Furthermore we only notice that the block has finished when a new block starts or when a new entity starts
or when the file ends.

So we better keep all the information from a block in memory.

We also keep the statics we collect in memory. Usually a hash can be very useful for this.

We start with the usual boiler-plate code.

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;
```

Then we add the code that gets the name of the error file from the command line.
If the file is not given, we throw an exception and ask the user to supply a filename.

```perl
my $filename = shift or die "Usage: $0 error.log\n";
```

Then we open the file and use a while-loop to read it line-by-line and
remove the trailing newlines using **chomp**.
For now we just print out the current line using the **say** function.

We wrap the whole thing in a subroutine called process, to make the
code more reusable.

```perl
process($filename);

sub process {
    my ($file) = @_;

    open my $fh, '<', $file or die "Could not open '$file' $!";
    while (my $line = <$fh>) {
        chomp $line;
        say $line;
    }
}
```

We can already put together this part of the script, so you can try it:

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

my $filename = shift or die "Usage: $0 error.log\n";

process($filename);

sub process {
    my ($file) = @_;

    open my $fh, '<', $file or die "Could not open '$file' $!";
    while (my $line = <$fh>) {
        chomp $line;
        say $line;
    }
}
```

## Parsing and recognizing lines

Now we need to focus on recognizing the different special lines.
For this we'll use **regular expressions**.

<h3>Entity headers</h3>

We need to recognize if we are at an entity header line.
Let's replace the `say $line;` with the following code.

```perl
    if ($line =~ /^=+ \s+ ERRORS \s+ ON \s+ ENTITY  \s+  (\w+) \s+ =+$/x) {
        $entity = $1;
        say $entity;
        say $line;
        next;
    }
```

Here we added the **x** character at the end of the **regex** so we can use
the extended syntax. This means we can have spaces in the regex to improve readability.

The part between the two slashes **/** is the regex. The caret **^**
at the beginning, and the dollar sign **$** at the end ensure that we describe the whole string.

`=+` matches one or more equal signs.

`\s+` matches one or more white-space characters.

`(\w+)` matches one or more word characters (letters, numbers and underscore). The parentheses will
capture this string and put it in the special variable `$1`.

We also save the current entity in a global variable.

<h3>Block headers</h3>

```perl
    if ($line =~ /^SOURCE \s+ LINE \s+ (\d+)$/x) {
        $block = $1;
        say $block;
        say $line;
        next;
    }
```

Similar to the case of the section heads, except that `\d` will only match digits.

<h3>Record names</h3>

Record names are marked with a leading &N.

```perl
    if ($line =~ /^&N \s+(\w+)$/x) {
        $record = $1;
        say $record;
        say $line;
        next;
    }
```

<h3>Lines to discard</h3>

We'll probably want to discard any empty lines, and all the lines that only have carets in them.
We call `next` to read the next line from the file.

```perl
    if ($line =~ /^[ ^]*$/) {
        say $line;
        next;
    }
```


We assume that every remaining line describes an error. We save them in an array.

```perl
    push @errors, $line;
```

So far this is what we have:
```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

my $filename = shift or die "Usage: $0 error.log\n";
process($filename);

my $entity;
my $block;
my $record;
my @errors;

sub process {
    my ($file) = @_;


    open my $fh, '<', $file or die "Could not open '$file' $!";
    while (my $line = <$fh>) {
        chomp $line;
        #say $line;
        if ($line =~ /^=+ \s+ ERRORS \s+ ON \s+ ENTITY  \s+  (\w+) \s+ =+$/x) {
            $entity = $1;
            #say $line;
            next;
        }
        if ($line =~ /^SOURCE \s+ LINE \s+ (\d+)$/x) {
            $block = $1;
            #say $line;
            next;
        }
        if ($line =~ /^&N \s+(\w+)$/x) {
            $record = $1;
            #say $line;
            next;
        }
        if ($line =~ /^[ ^]*$/) {
            #say $line;
            next;
        }
        push @errors, $line;
    }

    return;
}
```


## Processing a block

When a block ends we need to process the collected information and  clean up the global variables
so that we won't have values collected in on one block show up in another block.
For this we create a new subroutine called process_block. We will need to call it in 3 places
as described above.

Inside the subroutine, the first thing we do is checking whether we have already collected information
for a block. This way we won't need to write special cases in the code processing the lines.

Then we fill two hashes for counting the number of blocks per entry and for counting the
number of cases for each error. The second does not need any special treatment, but the first
has a special case. As we discussed, there might be blocks before the first entity declaration.
In those cases the $entity variable will be `undef` that would trigger the
warning [use of uninitialized value](/use-of-uninitialized-value).

For this to work well, we either need count those blocks in a separate variable, or we need to
use a special default entry name. I chose the latter and assigned '_DEFAULT_' to the $entry
variable at its declaration.

In the last part, we remove the values from the global variables.

```perl
sub process_block {
    return if not $block;

    $block_count{$entity}++;
    foreach my $err (@errors) {
        $error_messages{$err}++;
    }

    $block = undef;
    $record = undef;
    @errors = ();

    return;
}
```


## Reporting

The last part of code is the reporting. After the process() function finishes, we have two hashes filled with values.
We can go through the keys of each hash, [sort](/sorting-arrays-in-perl)
them according to the values and then print the content.

```perl
say "\nNumber of blocks in each Entity";
foreach my $bl (reverse sort { $block_count{$a} <=> $block_count{$b} } keys %block_count) {
    printf("%-15s %s\n", $bl, $block_count{$bl});
}
say "\nFrequency of errors";
foreach my $msg (reverse sort { $error_messages{$a} <=> $error_messages{$b} } keys %error_messages) {
    printf("%-25s %s\n", $msg, $error_messages{$msg});
}
```

## The whole script

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

my $filename = shift or die "Usage: $0 error.log\n";

my $entity = '_DEFAULT_';
my $block;
my $record;
my @errors;

my %error_messages;
my %block_count;

process($filename);
say "\nNumber of blocks in each Entity";
foreach my $bl (reverse sort { $block_count{$a} <=> $block_count{$b} } keys %block_count) {
    printf("%-15s %s\n", $bl, $block_count{$bl});
}
say "\nFrequency of errors";
foreach my $msg (reverse sort { $error_messages{$a} <=> $error_messages{$b} } keys %error_messages) {
    printf("%-25s %s\n", $msg, $error_messages{$msg});
}

sub process {
    my ($file) = @_;


    open my $fh, '<', $file or die "Could not open '$file' $!";
    while (my $line = <$fh>) {
        chomp $line;
        #say $line;
        if ($line =~ /^=+ \s+ ERRORS \s+ ON \s+ ENTITY  \s+  (\w+) \s+ =+$/x) {
            process_block();

            $entity = $1;
            #say $line;
            next;
        }
        if ($line =~ /^SOURCE \s+ LINE \s+ (\d+)$/x) {
            process_block();
            $block = $1;
            #say $line;
            next;
        }
        if ($line =~ /^&N \s+(\w+)$/x) {
            $record = $1;
            #say $line;
            next;
        }
        if ($line =~ /^[ ^]*$/) {
            #say $line;
            next;
        }
        push @errors, $line;
    }
    process_block();

    return;
}

sub process_block {
    return if not $block;

    $block_count{$entity}++;
    foreach my $err (@errors) {
        $error_messages{$err}++;
    }

    $block = undef;
    $record = undef;
    @errors = ();

    return;
}
```


## The output

```
Number of blocks in each Entity
77CF1008        6
77CF1007        6
_DEFAULT_       3

Frequency of errors
NAMED ITEM DOESN'T EXIST  10
NOT A VALID NAME          5
INVALID ENTRY             4
MISSING QUOTE             4
PRIMMOD = -               2
"$AUXUNIT "               2
PVHCAR   = LINEAR         2
MISSING DATA              2
CCSRC = 0                 2
"PVSRCOPT "               2
"MODNUM   "               2
ASSOCDSP = ""             2
$CDETAIL = ""             2
PLCADDR = 33003           1
PLCADDR = 33004           1
```


## Further work

I am sure further processing could be done on the values.
For example, some of the strings are in quotes. We could remove the quotes.
There seem to be certain key-value pairs in the error code. Those could be
split apart.



