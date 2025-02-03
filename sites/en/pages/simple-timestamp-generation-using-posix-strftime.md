---
title: "Simple timestamp generation using POSIX strftime in Perl"
timestamp: 2014-11-21T16:10:01
tags:
  - POSIX
  - strftime
published: true
books:
  - beginner
author: szabgab
---


Very often I need to add a timestamp to some log file, or create a file based on a the current date.
There are plenty of really good modules on CPAN to handle dates and times, that can help creating these
timestamps, but this time I am going to use the `strftime` function of the standard
[POSIX](https://metacpan.org/pod/POSIX) module.


The basic usage of strftime, as also explained in the [documentation](https://metacpan.org/pod/POSIX) looks like this:

```perl
strftime(format, sec, min, hour, mday, mon, year,
         wday = -1, yday = -1, isdst = -1)
```

Where the "format" can use various placeholder such as "%d"  from this list `aAbBcdHIjmMpSUwWxXyYZ%`, but unfortunately it
is not explained in the documentation what each of these mean. 

The `sec`, `min`, etc values are the seconds, minutes, etc. values of the time that we would like to use.

These numbers can come from any place, but they are actually corresponding to the values returned by either the
`localtime` or the `gmtime` functions in [LIST context](/scalar-and-list-context-in-perl).

A simple example would be:

```perl
use warnings;
use 5.010;

use POSIX qw(strftime);

say strftime '%Y-%m-%d', gmtime(); # 2014-11-09
```

This creates (and the `say` prints) a string based on the years, month and days as it is in Greenwich
at the time of running the script.

If you are creating logfiles, or basically any other timestamp, it is probably much better to use the YYYY-MM-DD format
instead of the British DD/MM/YYYY or the American MM/DD/YYYY. Neither of those can be easily sorted and because both
exists they are extremely confusing. The YYYY-MM-DD is how Hungarians write it and therefore it is much better.
(Remember other [Hungarian Notations](http://en.wikipedia.org/wiki/Hungarian_notation), right?).
It also happens to correspond to the [ISO standard](http://xkcd.com/1179/).

Another very useful format looks like this:

```perl
say strftime '%Y-%m-%d-%H-%M-%S', gmtime(); # 2014-11-09-15-31-13
```

This is the `YYYY-MM-DD-HH-MM-SS` (though I know the duplicating of MM in this example is a bit confusing so you might want
to think about it as `YYYY-mm-dd-HH-MM-SS` that will correspond to both the format and the letters used to create that format.

In a nutshell, it is Year, Month, Day, Hour, Minute, Second with 0 padding where necessary.

It is very useful to create timestamps even though probably less useful as filename. (Do you really want a new file every second?)

Oh and if you hope that this will be unique, then don't do it. With any luck after an hour of no file generation there will be two at the exact
same second and then all the "uniqueness" is gone.

Of course when you are creating a file you don't necessarily need to use dashes to separate the parts. This would be great as well:

```perl
say strftime '%Y%m%d', gmtime(); # 20141109
```


## Individual placeholder

In the following script you'll see examples for the various placeholder that can be used in the format string.
I've tried to group them according to the level of usefulness,. At least what I see of the level of usefulness.

In this example I also used a fixed timestamp which then was converted to the appropriate array using the `gmtime`
function. This was only necessary so the the values I show will really correspond to the same time and one
that will show the values in an interesting way. (0 padded where necessary.)

```perl
use strict;
use warnings;
use 5.010;

use POSIX qw(strftime);

my $time = 1415520307;

my @time = gmtime($time);


# Very useful:

say strftime '%Y', @time; #  2014
say strftime '%m', @time; #    11
say strftime '%d', @time; #    09
say strftime '%H', @time; #    08
say strftime '%M', @time; #    05
say strftime '%S', @time; #    07

# Sometimes useful:

say strftime '%j', @time; #   313
say strftime '%U', @time; #    45
say strftime '%W', @time; #    44
say strftime '%w', @time; #     0

say strftime '%%', @time; #     %
say strftime '%c', @time; #     Sun Nov  9 08:05:07 2014


# IMHO not very useful because they depend on the current locale.

say strftime '%I', @time; #  08
say strftime '%p', @time; #  AM
say strftime '%X', @time; #  08:05:07
say strftime '%x', @time; #  11/09/2014
say strftime '%y', @time; #  14
say strftime '%Z', @time; #  IST (I have no idea why)
say strftime '%A', @time; #  Sunday
say strftime '%b', @time; #  Nov
say strftime '%B', @time; #  November
```

## Very useful

```
      Explanation                                                     Example
%Y    Year        YYYY                                                 2014
%m    Month       mm                                                     11
%d    Day         dd                                                     09
%H    Hour        HH                                                     08
%M    Min         MM                                                     05
%S    Seconds     SS                                                     07
```


## Sometimes useful

```
     Explanation                                                      Example

%j   Day of the year as a zero-padded decimal number.                  313
     On January 1 this will be 001

%U   Week number of the year as a zero padded decimal number.           45
     (Sunday as the first day of the week)
     All days in a new year preceding the first Sunday
     are considered to be in week 0

%W   Week number of the year as a decimal number.                       44
     (Monday as the first day of the week)
     All days in a new year preceding the first Monday
     are considered to be in week 0.

%w   Weekday as a decimal number, where 0 is Sunday and 6 is Saturday.   0

%%   Literal %                                                           %

%c   Locale’s appropriate date and time representation.                 Sun Nov  9 08:05:07 2014
     I think this is what gmtime() would return in scalar context.
```


## IMHO not very useful because they depend on the current locale.

```
     Explanation                                                        Example

%I   Hour (12-hour clock)                                               08
%p   Locale’s equivalent of either AM or PM.                            AM
%X   Locale’s appropriate time representation.                          08:05:07
%x   Locale’s appropriate date representation.                          11/09/2014
%y   Year without century as a zero-padded decimal number.              14
%Z   Time zone name                                                     IST (I have no idea why)
%A   Weekday as locale’s full name.                                     Sunday
%b   Month as locale’s abbreviated name.                                Nov
%B   Month as locale’s full name.                                       November
```


See also [strftime in Python](http://strftime.org/) that I used as the source of some of
the explanations.

## Comments

%z is useful. +0100 is often handy.

<hr>

It's POSIX -- the placeholder values are supplies by your operating system. I agree that the perldoc could be useful and echo these, but on at least FreeBSD, "man strftime" lists all the supported values for that platform.

<hr>

In Python's strftime, if you want a decimal hour (e.g. "2" instead of "02") you can use "%-I" instead of "%I" ... Is there any equivalent approach in this Perl strftime function?

