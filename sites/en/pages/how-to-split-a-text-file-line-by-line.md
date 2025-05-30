---
title: "How to split a text file line by line in Perl"
timestamp: 2015-10-21T07:30:01
tags:
  - split
  - open
published: true
author: szabgab
archive: true
---


A commonly asked question is "how to split a text file line by line".


## Read line by line

Normally you would read the file line by line, so the code is:

```perl
open my $in, "<:encoding(utf8)", $file or die "$file: $!";
while (my $line = <$in>) {
    chomp $line;
    # ...
}
close $in;
```

## Read all the lines at once

Alternatively you might want to read the whole file into memory at once
and hold it in an array where each line is a separate element:

```perl
open my $in, "<:encoding(utf8)", $file or die "$file: $!";
my @lines = <$in>;
close $in;

chomp @lines;
for my $line (@lines) {
    # ...
}
```

The latter has the disadvantage that it can only handle files that will fit into the memory of the computer,
but sometime it is mor convenient to have all the file in memory at once.


## split

Finally, if you really want to use the [split](https://perlmaven.com/perl-split) function, you could read the
whole file into memory using <a hrf="https://perlmaven.com/slurp">slurp</a> and then split it along the newlines,
though I don't know when would this have any advantage over the other methods.

```perl
my @lines = read_lines('some_file.txt');

sub read_lines {
    my ($file) = @_;

    open my $in, "<:encoding(utf8)", $file or die "$file: $!";
    local $/ = undef;
    my $content = <$in>;
    close $in;
    return split /\n/, $content;
}
```

## Comments

i want to split
a,b,c
d,e,f
g,h,i
as
a
b
c
d
e
f
g
h
i

please help how to do it.
---
What is this. A string? A file? What is the input? What is the expected output? What have you tried so far?

---

a,b,c
d,e,f
g,h,i

are data in a file.

i want another file which gives output as

a
b
c
d
e
f
g
h
i

----

So what code did you write already?

----
system("sed -n '3,220p' IOSS_DUT_with_BISS_NoC.v > tmp.txt");
my $out = "output_rtl.txt";
open(OUT, ">> $out") or die $!;
my $in ="tmp.txt";
open(IN, "<" ,$in) or die $!;
@line = <in>;
my $len = @line;
for(my $i=0;$i<$len;$i++){
#@flow =
#($var1,$var2,$line[$i]) = split(/\s+/,$line[$i]);
#if($line[$i] =~ m/output/){
# $line[$i] =~ s/output.*'\s/\s.*/g;

@field = split(/,\s/, "$line[$i]");
#@field2 = split(/\s+/,"@field");
print OUT "\n@field";
}

assume format of data in files as mentioned above.

I am new to perl so please help with the sample data i provided earlier.
i need that code which execute the dummy query i posted first.

----
In the Perl Tutorial https://perlmaven.com/perl-tutorial read "Open and read from files using Perl" and Writing to files

and also splitThese will probably help you.
----

Have you managed it? Here is a solution for you: https://perlmaven.com/flatten-csv-file

<hr>

I want to split a student file into fields: Name, Country, course, Student, ID,
local,English,en,3232
local,French,md,76454
International,English,ch,124151
local,English,en,124135
International,Chinese,lit,23747

how do I split this than loop through if an argument is given "./search.pl -l English file.txt" where -l is the option that does the procedure scans the file, checks to identify lang breaks them up and display

English
local: 2
International: 1

if I put "./search.pl -l Chinese file.txt "

Chinese
local: 0
International: 1

---
I would not call that splitting as you create a totally different forma. Try to rephrase your question, that will help you to think about it. Then show what have you written so far.

<hr>

I want create a file of tab-seperated values ,including a line that has the names of each column of values
example
input:
First Last Score
Jack Flintstone 330
Barney Jerry 195

output:
First : Jack
Last : Flintstone
Score : 330
First : Barney
Last : Jerry
Score : 195
---
Good for you, and what is the problem? When you say "input" is this another file? What did you write so far?


<hr>


