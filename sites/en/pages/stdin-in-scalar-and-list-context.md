---
title: "STDIN in scalar and list context"
timestamp: 2015-03-18T09:45:56
tags:
  - STDIN
  - <STDIN>
  - scalar
published: true
books:
  - beginner
author: szabgab
---


We have learned about [scalar and list context in Perl](/scalar-and-list-context-in-perl), and we have seen
how [localtime behaves in scalar and list context](/the-year-19100). We also saw what an array returns
 in scalar context.
We also saw how to [read from a file in SCALAR and LIST context](/reading-from-a-file-in-scalar-and-list-context).

This time we'll look at reading from STDIN using `&lt;STDIN>` in scalar and list context.



## STDIN in scalar context

This is what we have have been doing right from the
[beginning](/installing-perl-and-getting-started) of the [Perl Tutorial](/perl-tutorial).

```perl
use strict;
use warnings;

print "Please type in your name: ";
my $name = <STDIN>;
chomp $name;
print "Hello $name, how are you?\n";
```

The relevant part is that we read from STDIN and assign to a scalar variable `$name`.

If we run this script, it will print "Please type in your name: " and then it will wait till we press **ENTER**.
Then it will take everything we type, including the ENTER at the end, and assign it to the `$name` variable.
`chomp` will eliminate the trailing newlines.


## STDIN in list context

If we assign the `&lt;STDIN>` readline operator to an array it means we put the readline operator in LIST context.
Let's see this example:

```perl
use strict;
use warnings;
 
print "Please type in the names of the programming languages you know: ";
my @names = <STDIN>;

chomp @names;
print "Hello, I see you know " . scalar(@names) . "\n";
```

This script prints some text too and then waits for your input. Pressing ENTER after you typed in some text
will leave Perl waiting for the next line. In order to tell Perl that you have finished typing, you need to press
ENTER (to get to the next empty line) and then send an `EOF` a.k.a. `End of File` signal.
This depends on the Operating system. On Linux/Unix system pressing `Ctrl-D`
(also written as ^D sometimes) will send this signal.
On MS Windows you have to type `Ctrl-Z` (sometimes written as ^Z) and then also press `ENTER`.

In both cases you have to send the signal on a new line, that is, after pressing ENTER.

Once you send that signal, Perl will assign everything you typed to the `@names` array.
Every line you typed in, every string that you finished by pressing ENTER
will be in a separate element of the array. So, if you type in:

```
Please type in the names of the programming languages you know:
JavaENTER
PerlENTER
PythonENTER
^D
```

The array will have 3 elements like these:

```perl
@names = (
   "Java\n",
   "Perl\n",
   "Python\n",
);
```

Then we apply `chomp` to all of them at once removing all the trailing newlines and getting:

```perl
@names = (
   "Java",
   "Perl",
   "Python",
);
```

On the last line we print out the [number of elements in the array](/length-of-an-array).


## Usage?

You almost always need to read from STDIN in scalar context,
that is, to assign the result to a scalar variable:

```perl
$input = <STDIN>;
```


