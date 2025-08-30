---
title: "How to calculate the balance of bank accounts in a CSV file, using Perl?"
timestamp: 2012-08-04T20:45:56
tags:
  - CSV
  - split
published: true
author: szabgab
---


One of the readers of the [How to read a CSV file using Perl?](/how-to-read-a-csv-file-using-perl) article
has sent me a CSV file and a question:

**How to Calculate and display total balance in each account using hash in perl. Without using parse function?**

Let's see how can we handle such a request?


```
TranID,Date,AcNo,Type,Amount,ChequeNo,DDNo,Bank,Branch
13520,01-01-2011,5131342,Dr,5000,,,,
13524,01-01-2011,5131342,Dr,1000,,416123,SB,Ashoknagar
13538,08-01-2011,5131342,Cr,1620,19101,,,
13548,17-01-2011,5131342,Cr,3500,19102,,,
13519,01-01-2011,5522341,Dr,2000,14514,,SBM,Hampankatte
13523,01-01-2011,5522341,Cr,500,19121,,,
13529,02-01-2011,5522341,Dr,5000,13211,,SB,Ashoknagar
13539,09-01-2011,5522341,Cr,500,19122,,,
13541,10-01-2011,5522341,Cr,2000,19123,,,
```


At first it was not clear where is he stuck or if he made any progress at all.
In order to help him I had to try to figure out both what he wanted to reach and the where he is stuck.

I asked for the code he already wrote, and got this script:

```perl
#!/usr/bin/perl

print "Content-type:text/html\n\n";

my $sum;
my $sum1;
my $sum2;

open(FILEHANDLE, "<banktran.csv") or die "Could not open 'banktran.csv' $!\n";

while (my $line = <FILEHANDLE>) {
  chomp $line;
  my @fields = split "," , $line;

  if ($fields[2] eq 5131342) {
    if ($fields[3] eq Dr) {
      $sum1 += $fields[4];
    } else {
      $sum2 += $fields[4];
    }
    $sum = $sum1-$sum2;
    print "Total Balance of Account Number is Rs.$sum\n";
  }
}

close(FILEHANDLE);
```

Besides some obvious beginner issues I started to understand, that probably he wants to create a separate report for
each account - the third column - **AcNo** is probably the account number.

The amount is in the 5th column under the title **Amount**.

As I can see the 4th column indicates if the type of the transaction. A little search indicates that Dr would be debit
and Cr would be credit, though in the code that seems to be the opposite.

The first sentence in the question seems to indicate that he already understand he needs to use hashes,
instead of the scalar `$sum` variables, but it is yet unclear to him how.

The second sentence, **Without using parse function?** seems to indicate to me that for some reason the reader
cannot use the Text::CSV module that has the parse method. That's unfortunate, as that is the right tool in the
general case of parsing and reading CSV files, but in many corporate settings installing a module from CPAN is
difficult. Especially to someone who is new to Perl.

Assuming the CSV file is simple - no quoted separators, no embedded newlines - we can handle it with a call
to the `split` function.


The code he sent me is reasonable for someone starting to use Perl, let's see how can we improve it
and how can we try to implement what he needed?


## Running the code

Before trying to improve the code, let's see if it runs, and what does it do? The script is saved
as **banktran.pl** and the csv file as **banktran.csv**

**perl banktran.pl**

```
Content-type:text/html

Total Balance of Account Number is Rs.5000
Total Balance of Account Number is Rs.6000
Total Balance of Account Number is Rs.4380
Total Balance of Account Number is Rs.880
```

Now that we see it does something we can make some improvements:

## use strict and use warnings

First of all, I very strongly recommend every Perl script to start with the two statements of the
safety-net. I know that I can waste a lot of valuable time searching for bugs that these
two would catch, so I don't want to be without them.

```perl
use strict;
use warnings;
```

It should come right after the sh-bang. If we add this to the above code and try to run it again we get
the following:

```
Bareword "Dr" not allowed while "strict subs" in use at banktran.pl line 18.
Execution of banktran.pl aborted due to compilation errors.
```

[Bareword not allowed while "strict subs" in use](/barewords-in-perl)
is one of the common warnings described in [Perl Maven tutorial](/perl-tutorial).
We need to put single-quotes `'` around the string **Dr**

Running the script again we get the following:

```
Content-type:text/html

Use of uninitialized value $sum2 in subtraction (-) at banktran.pl line 23, <FILEHANDLE> line 2.
Total Balance of Account Number is Rs.5000
Use of uninitialized value $sum2 in subtraction (-) at banktran.pl line 23, <FILEHANDLE> line 3.
Total Balance of Account Number is Rs.6000
Total Balance of Account Number is Rs.4380
Total Balance of Account Number is Rs.880
```


The [Use of uninitialized value](/use-of-uninitialized-value) warning
is another common warning in Perl. It means the `$sum2` was undef in line 23.

```perl
$sum = $sum1-$sum2;
```

We should probably initialize the variables to 0. It is not always necessary, but it can lead
to cleaner code. The resulting code so far looks like this:

```perl
#!/usr/bin/perl
use strict;
use warnings;

print "Content-type:text/html\n\n";

my $sum  = 0;
my $sum1 = 0;
my $sum2 = 0;

open(FILEHANDLE, "<banktran.csv") or die "Could not open 'banktran.csv' $!\n";

while (my $line = <FILEHANDLE>) {
  chomp $line;
  my @fields = split "," , $line;

  if ($fields[2] eq 5131342) {
    if ($fields[3] eq 'Dr') {
      $sum1 += $fields[4];
    } else {
      $sum2 += $fields[4];
    }
    $sum = $sum1-$sum2;
    print "Total Balance of Account Number is Rs.$sum\n";
  }
}

close(FILEHANDLE);
```

## Using open the "modern" way

I put the word "modern" in quotes because this is available since 2000 so it is not really
new, but still many people learn the old style first.

There is an article why one
[should not open files in the old way in Perl](/open-files-in-the-old-way),
I won't repeat it here, I'll just fix the code:

```perl
#!/usr/bin/perl
use strict;
use warnings;

print "Content-type:text/html\n\n";

my $sum  = 0;
my $sum1 = 0;
my $sum2 = 0;

my $filename = 'banktran.csv';
open(my $FILEHANDLE, '<', $filename) or die "Could not open '$filename' $!\n";

while (my $line = <$FILEHANDLE>) {
  chomp $line;
  my @fields = split "," , $line;

  if ($fields[2] eq 5131342) {
    if ($fields[3] eq 'Dr') {
      $sum1 += $fields[4];
    } else {
      $sum2 += $fields[4];
    }
    $sum = $sum1-$sum2;
    print "Total Balance of Account Number is Rs.$sum\n";
  }
}

close($FILEHANDLE);
```

As you can see the I changed `FILEHANDLE` to be the lexical scalar `$FILEHANDLE`,
using 3 parameters in the `open` function and also put the name of the file in a variable.

This last step is important for two reasons:

1. It will make it easier to pass the name of the file as a parameter, if we need it.`
1. We won't fall in the trap of changing the name in the `open()` call, and leaving the old name in the `die()` call and getting confused by the error message.

## Better variable names

The fact that we are using and array called `@fields` and indexes in that array
makes it unclear what kind of values are in those field.

Quickly, can you remember what is in $fields[2]? I cannot. So instead of using the @fields array
we could use variables with better names and write:

```perl
my ($id, $date, $account, $type, $amount, $cheque, $dd, $bank, $branch)
    = split "," , $line;
```

This turned the above line a bit longer but will make the rest of the code more readable.
This also makes us creates some unnecessary variables.

[Advanced Perl developers](/advanced-perl-maven-e-book) could make it nicer by using an array slice:

```perl
my ($account, $type, $amount) = (split "," , $line)[2, 3, 4];
```

The loop will look like this:

```perl
while (my $line = <$FILEHANDLE>) {
  chomp $line;
  my ($account, $type, $amount) = (split "," , $line)[2, 3, 4];

  if ($account eq 5131342) {
    if ($type eq 'Dr') {
      $sum1 += $amount;
    } else {
      $sum2 += $amount;
    }
    $sum = $sum1-$sum2;
    print "Total Balance of Account Number is Rs.$sum\n";
  }
}
```

## Eliminate temporary variables

As I can see the `$sum1` and `$sum2` variables are used only to hold
the values that either need to be added to the $sum or deducted from it. We don't really need them.
We could add to `$sum`, or deduct from it inside the condition:

```perl
  if ($account eq 5131342) {
    if ($type eq 'Dr') {
      $sum += $amount;
    } else {
      $sum -= $amount;
    }
```

Let's see and try the full code again, before the big operation.

```perl
#!/usr/bin/perl
use strict;
use warnings;

print "Content-type:text/html\n\n";

my $sum  = 0;

my $filename = 'banktran.csv';
open(my $FILEHANDLE, '<', $filename) or die "Could not open '$filename' $!\n";

while (my $line = <$FILEHANDLE>) {
  chomp $line;
  my ($account, $type, $amount) = (split "," , $line)[2, 3, 4];

  if ($account eq 5131342) {
    if ($type eq 'Dr') {
      $sum += $amount;
    } else {
      $sum -= $amount;
    }
    print "Total Balance of Account Number is Rs.$sum\n";
  }
}

close($FILEHANDLE);
```

## Show the total for all the accounts

Right now, only one specific account (id = 5131342) is summarized and it is done in a scalar variable.
Instead of this we would like to summarize all the accounts. The easiest way is to use a hash.
The account ids will be the keys and the sum will be the value.

```perl
#!/usr/bin/perl
use strict;
use warnings;

print "Content-type:text/html\n\n";

my %sum;

my $filename = 'banktran.csv';
open(my $FILEHANDLE, '<', $filename) or die "Could not open '$filename' $!\n";

while (my $line = <$FILEHANDLE>) {
  chomp $line;
  my ($account, $type, $amount) = (split "," , $line)[2, 3, 4];

  if ($type eq 'Dr') {
    $sum{$account} += $amount;
  } else {
    $sum{$account} -= $amount;
  }
  print "Total Balance of Account Number $account is Rs.$sum{$account}\n";
}

close($FILEHANDLE);
```

In this code we don't need the `if ($account eq 5131342)` condition any more.
We can access the hash key directly, using the `$account` number as the key.

After running the script the result looks like this:

```
Content-type:text/html

Argument "Amount" isn't numeric in subtraction (-) at banktran.pl line 19, <$FILEHANDLE> line 1.
Total Balance of Account Number AcNo is Rs.0
Total Balance of Account Number 5131342 is Rs.5000
Total Balance of Account Number 5131342 is Rs.6000
Total Balance of Account Number 5131342 is Rs.4380
Total Balance of Account Number 5131342 is Rs.880
Total Balance of Account Number 5522341 is Rs.2000
Total Balance of Account Number 5522341 is Rs.1500
Total Balance of Account Number 5522341 is Rs.6500
Total Balance of Account Number 5522341 is Rs.6000
Total Balance of Account Number 5522341 is Rs.4000
```

The warning we get is due to the first line in the CSV file. Earlier we did not have
to care about it as we only dealt with rows where the account id was matching the selected
number, but now we have to skip that line. It's easy, just read the first row before the
`while` loop, and throw it away.


```perl
<$FILEHANDLE>;
while (my $line = <$FILEHANDLE>) {
```

## Total only at the end?

This could be the final version, but it is unclear to me if we really need to display the Balance after every row,
or only at the end. So let's make another change that will display the results only at the end.

We remove the `print` call from the `while` loop and add another loop at the end, going over all the
accounts and displaying the account status:


```perl
foreach my $account (sort keys %sum) {
  print "Total Balance of Account Number $account is Rs.$sum{$account}\n";
}
```

The full code
```perl
#!/usr/bin/perl
use strict;
use warnings;

print "Content-type:text/html\n\n";

my %sum;

my $filename = 'banktran.csv';
open(my $FILEHANDLE, '<', $filename) or die "Could not open '$filename' $!\n";

<$FILEHANDLE>;
while (my $line = <$FILEHANDLE>) {
  chomp $line;
  my ($account, $type, $amount) = (split "," , $line)[2, 3, 4];

  if ($type eq 'Dr') {
    $sum{$account} += $amount;
  } else {
    $sum{$account} -= $amount;
  }
}

close($FILEHANDLE);

foreach my $account (sort keys %sum) {
  print "Total Balance of Account Number $account is Rs.$sum{$account}\n";
}
```

There is only one little thing that still bothers me. Why do we print Content-type
at the beginning of the code? Is this supposed to run as a CGI script?

If no, then we could remove that line.

If this is a CGI script then we should probably print real HTML out. At least we should
print pre tags around the report.



