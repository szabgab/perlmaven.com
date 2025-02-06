---
title: "Understanding dates using regular expressions"
timestamp: 2012-09-11T12:45:56
tags:
  - regex
  - regular expression
  - "?"
  - m
  - "\\"
  - "/"
  - next
published: true
author: szabgab
---


We have a file that has lots of lines like this, and we would you read and understand the data.
Part of this understanding is creating a data structure to represent the date.

```
2012-07-04T15:23:45   29.13 37.42 ....
```


The lines actually have a lot more data, but at least for now, we are only interested in the
first part representing the date. We would like to take it apart to have variables
`$year`, `$month`, `$day`, `$hour`, `minute`, and `$second`

## Going over the file

Before starting to deal with the dates, first let's see how do we go over the file.

```perl
use strict;
use warnings;
use autodie;
use 5.010;

my $file = shift or die "Usage: $0 FILE\n";
open my $fh, '<', $file;
while (my $line = <$fh>) {
  print $line;
}
```

After 4 lines of boiler-plate code, we get the name of the file containing the dates from the command line.
If no file was provided we call `die` and let the user know we expect the name of the file.

Save the above script as date.pl and try running <b>perl date.pl</b>.
You will get <b>Usage: dates.pl FILE</b>.

Then we `open` the file without adding the well known `or die ...` part. We don't add it as
we used the `autodie` pragma.

Run <b>perl date.pl blabla</b>

You will get <b>Can't open 'blabla' for reading: 'No such file or directory' at dates.pl line 7</b>

Finally, we have a `while` loop that will read in the lines of the file one-by-one,
put the line in the `$line` variable and execute the block. In the above case it just prints the
line to the screen. From now on we will deal with the code that's inside the block.

If you are wondering why do I use a variable called `$line` and not
[$_, the default variable of Perl](/the-default-variable-of-perl), then please read that explanation.

## Matching the date

We can use a regex to match this date. Usually I'd start from left to right trying to match.
The code will look like

```perl
  $line =~ //
```

```
2012-07-04T15:00:00
```

We know that the date starts at the beginning of each line so we can start our regex with `^`.
Then we have four digits. Each digit is captured using `\d` so we have.

```perl
  $line =~ /^\d\d\d\d/
```

Let's see how can we capture this and display. For this we put part of the regex in parentheses.
This is the part that is supposed to match the year and assign the whole whole expression
to a list of scalar variables. (Well, in this case that's a list of one variable)

The parentheses will capture the match and let the expression return the value.

```perl
  my ($year) = $line =~ /^(\d\d\d\d)/;
  print "$year\n";
```

## Handling invalid input

As I ran this on my input I noticed several warnings:

```
Use of uninitialized value $year in concatenation (.) or string at dates.pl line 10, <$_[...]> line 4
```
There is a whole article explaining what does [Use of uninitialized value](/use-of-uninitialized-value)
mean. For us it means that in some lines the assignment did not work. Apparently the file has some invalid lines.
In any input this can be expected, so our code should be able to at least report the problem.

```perl
  my ($year) = $line =~ /^(\d\d\d\d)/;
  if (defined $year) {
    print "$year\n";
  } else {
    warn "Invalid line '$line'\n";
  }
```

This is almost good, but if your file has invalid lines, you will also notice that there is a new-line just before the
closing quote in the warning. That's because we have not eliminated the newline from the `$line`.
We should probably call `chomp $line` at least before calling warn, but possibly right after reading the line
from the file.


## Extending the regex

For now we set the invalid lines aside, you can even comment out the call to `warn` so it won't mess up the
output while we try to deal with the regular input.

Now, that we have the year, we should extend the regex to capture the month and day:

Right after the year, there is a dash and then two digits, another dash and another 2 digits:

```perl
  my ($year, $month, $day) = $line =~ /^(\d\d\d\d)-(\d\d)-(\d\d)/;
  print "$year  $month  $day\n";
```


```perl
  my ($year, $month, $day, $hour, $min, $sec) = $line =~ /^(\d\d\d\d)-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d)/;
  print "$year  $month  $day - $hour  $min  $sec\n";
```

This concludes the parsing of the dates we were expecting. Let's check the invalid rows now.

First we see a line like this:

```
2012-7-04T15:23:45   29.13 37.42 ....
```

Here the month is not 0-padded. It only has one digit.

Depending on the situation, we either want to accept these dates,
or we want to alert someone for having incorrect input. Or we would like to do both.

Let's focus on fixing these dates.
We would like to allow for the month field to be either one digit or two digits.
That's easy, the `?` character can tell the entity on its left to be optional.
To match or to be skipped. So `\d\d` would require 2 digits while `\d?\d`
will require only one digit.


```perl
  my ($year, $month, $day, $hour, $min, $sec) = $line =~ /^(\d\d\d\d)-(\d?\d)-(\d\d)T(\d\d):(\d\d):(\d\d)/;
```

the same problem can happen with the days, hours, minutes and seconds as well, so let's make the first
digit optional in every case except the year:

```perl
  my ($year, $month, $day, $hour, $min, $sec) = $line =~ /^(\d\d\d\d)-(\d?\d)-(\d?\d)T(\d?\d):(\d?\d):(\d?\d)/;
```

That will solve the problem for some of the input, but as we ran our script we notice another format:

```
04/07/2012 15.10.00
```

As the order of the values isn't the same as in the previous file, we cannot use the same assignment.
Even if we could, I'd probably write a separate regex.

This time the string starts with 2 digits, though if we can already assume the leading 0 is missing and then
it is followed by a slash and then another 2 digits:

```perl
$line =~ /^(\d?\d)\/(\d?\d)\/(\d\d\d\d) (\d\d)\.(\d\d)\.(\d\d)/;
```

As you can see we had to add a back-slash `\` in front of the slash `/` to <b>escape</b> it
so perl won't think that's the end of the regex. A more readable way is to change the delimiters of the regex
by putting the letter `m` in front of it:

```perl
$line =~ m{^(\d?\d)/(\d?\d)/(\d\d\d\d) (\d\d)\.(\d\d)\.(\d\d)};
```

We don't have much choice, but we have to put the back-slash in-front of the `.` to make sure it only matches
dots and not every character as it usually does.

There is an addition minor issue, that we have no idea what is the order of the values?
Is that month-day-year or day-month-year? In order to answer this question we can go over all the values.
If we see any number bigger than 12 in one of the fields, we will assume that is the field that has the days in all the rows.
In our case it turned out to be month-day-year and the hour-min-sec.


The full script looks like this:


```perl
use strict;
use warnings;
use autodie;
use 5.010;

my $file = shift or die "Usage: $0 FILE\n";
open my $fh, '<', $file;
while (my $line = <$fh>) {
  chomp $line;
  my ($year, $month, $day, $hour, $min, $sec) = $line =~ /^(\d\d\d\d)-(\d?\d)-(\d?\d)T(\d?\d):(\d?\d):(\d?\d)/;
  if (not defined $year) {
    ($month, $day, $year, $hour, $min, $sec) = $line =~ m{^(\d?\d)/(\d?\d)/(\d\d\d\d) (\d\d)\.(\d\d)\.(\d\d)};
    if (not defined $year) {
      warn "Invalid line '$line'\n";
      next;
    }
  }
  print "$year  $month  $day - $hour  $min  $sec\n";
}
```


As you can see we already included the call to `chomp` off the newline and changed the order of execution a bit.
First we try to use one of the regexes. If it does not match and thus does not assign a value ti `$year`
we try the second regex.

If that still does not work then we complain and call `next` to go to the next iteration processing the next
line.

If everything was fine we print the date with spaces between the values.


