---
title: "Common DateTime operations"
timestamp: 2015-11-07T12:30:01
tags:
  - DateTime
  - DateTime::Format::ISO8601
  - DateTime::Format::Strptime
  - DateTime::Duration
  - DateTime::Format::Duration
published: true
author: szabgab
archive: true
---


There are lots of ways to handle dates and time in Perl. Probably the most correct way is by using the
[DateTime](https://metacpan.org/pod/DateTime) module.



For every operation first we have to load [DateTime](https://metacpan.org/pod/DateTime) into memory:

```perl
use DateTime;
```

## Create a timestamp

We can create a DateTime object representing the current date and time by calling the `now` constructor.

```perl
my $dt = DateTime->now;
```

Alternatively we could create a DataTime object by supplying (part of) the date and time:

For example the date only:

```perl
$dt = DateTime->new(
    year       => 1987,
    month      => 12,
    day        => 18,
);
```

The rest of the data (hours, minutes, seconds) will be assumed to be 0.

We can also supply all the details. Even including the timezone.

```perl
$dt = DateTime->new(
    year       => 1987,
    month      => 12,
    day        => 18,
    hour       => 16,
    minute     => 12,
    second     => 47,
    nanosecond => 500000000,
    time_zone  => 'America/Los_Angeles',
);
```

Valid TimeZone values are the modules available in the [DateTime-TimeZone](https://metacpan.org/release/DateTime-TimeZone) distribution.

## Display Date and Time

Once we have a DateTime object, we can also display the content:

We can print the DateTime object and it will stringify to a rather clear format:  (we are using the most recently created DateTime object).

```perl
say $dt;                  #  1987-12-18T16:12:47
```

The `ymd` method will print year-month-day, but we can also supply a separator character. For example `_`:

```perl
say $dt->ymd;             # 1987-12-18
say $dt->ymd('_');        # 1987_12_18
```

`hms` returns the hour:minute:second

```perl
say $dt->hms;             # 16:12:47
```

The `epoch` returns the number of seconds (of the given date) since the "epoch" which is 1970.01.01 00:00:00. This is the same kind
of number a simple call to the built-in `time` function would return.

```perl
say $dt->epoch;           # 566871167
```

There are also individual function to return the various parts of the date:

```perl
say $dt->year;            # 1987
say $dt->month;           # 12
say $dt->day;             # 18
```

If that's still not enough, you can use the `strftime` method and provide a format string.
The possible place-holders are the same as for the strftime function provided by [POSIX](https://metacpan.org/pod/POSIX)
that you could see in the article [creating simple timestamp](/simple-timestamp-generation-using-posix-strftime).

```perl
say $dt->strftime( '%Y-%m-%d-%H-%M-%S' ); # 1987-12-18-16-12-47
```

### Full example

{% include file="examples/datetime_create.pl" %}

## Parsing date and time - Converting a string to DateTime object

In many situations we are reading a file that has timestamps in it and we need to convert them to
DateTime objects. The DateTime module itself does not provide any parser, but there are a number of
extension that do.

A few commonly used modules:

### [DateTime::Format::ISO8601](https://metacpan.org/pod/DateTime::Format::ISO8601)

Look at the sample script:

{% include file="examples/datetime_parse_iso8601.pl" %}

And the output showing the original string and the DateTime representation of it:

```
String:   1983-10-12
DateTime: 1983-10-12T00:00:00

String:   19850103
DateTime: 1985-01-03T00:00:00

String:   1984-07-02T03:40:02
DateTime: 1984-07-02T03:40:02

String:   1991-W02
DateTime: 1991-01-07T00:00:00
```

The last one seems to indicate the first day of the second week of 1991, but I am not sure. I noticed also that parsing "1991-W01"
[throws an exception](https://rt.cpan.org/Ticket/Display.html?id=104346).


### [DateTime::Format::Strptime](https://metacpan.org/pod/DateTime::Format::Strptime)

This module seems to be more powerful and more flexible. It allows you to defined a pattern based
using the place-holders of [strftime](/simple-timestamp-generation-using-posix-strftime) from
the POSIX module (see the list on that page) and then uses that to parse the given string.

There can be all kinds of fancy patters that can even match string such as "July" or "September". See the examples:

{% include file="examples/datetime_parse_strptime.pl" %}

And the output:

```
String:   1984-07-02T03:40:02
DateTime: 0001-01-01T03:40:02

String:   1984/07-02 03:40::02
DateTime: 1984-07-02T03:40:02

String:   July 02 1984
DateTime: 1984-07-02T00:00:00
```

### Additional formatting modules

There are many other parsing modules, but these seem to be used the most often:

[DateTime::Format::MySQL](https://metacpan.org/pod/DateTime::Format::MySQL),
[DateTime::Format::DateParse](https://metacpan.org/pod/DateTime::Format::DateParse),
and [DateTime::Format::HTTP](https://metacpan.org/pod/DateTime::Format::HTTP)


## Add and Subtract from a date

In order to calculates dates relative to a given date we can use [DateTime::Duration](https://metacpan.org/pod/DateTime::Duration) objects.
After loading the module into memory we can create DateTime::Duration objects and use them to add to DateTime object or to subtract from them.

{% include file="examples/datetime_arithmetic.pl" %}

The output of the above code is:

```
1987-12-18T16:12:47
1987-12-17T16:12:47
1987-12-19T16:12:47
1986-12-18T16:12:47
```

## The difference between two dates

Lastly, let's see how can we calculate the difference between two timestamps.
First we need to create two DateTime objects. This can be done by any of the previous ways.
Then we can use `-` subtraction between the two:

```perl
my $dt = DateTime->new(...);
my $other = DateTime->new(...);

my $diff = $other - $dt;
say $diff;
```

Printing the difference will result in something like this:

```
DateTime::Duration=HASH(0x7fbe33a1c0e0)
```

That's not very interesting, but we can then use the [DateTime::Format::Duration](https://metacpan.org/pod/DateTime::Format::Duration)
module to format our code using [strftime](/simple-timestamp-generation-using-posix-strftime) place-holders:

{% include file="examples/datetime_diff.pl" %}

Generating the following output:

```
1987-12-18T16:12:47
2011-10-07T10:20:40
DateTime::Duration=HASH(0x7fb64a82d580)
0 years, 285 months, 19 days, 00 hours, 1087 minutes, 52 seconds
0-285-19 00:1087:52
```

## Comments

Hi, that helpd me a lot!!

But why are the hours not counted?

<hr>

0 years, 285 months?
0 hours, 1087 minutes?
I feel that the fomat_duration method needs a little work.

<hr>

doesn't work for me, i always get this error:
Can't call method "clone" without a package or object reference at C:/Dwimperl/p
erl/site/lib/DateTime/Duration.pm line 310.

---

For example
DateTime->new()->subtract(months => 6)

<hr>

Informative! Thank you.
I play around with RPi and Arduino quite a bit and thus use time stamps often. Messing around with various modules from CPAN has led to a bit of frustration for me. I have been trying to settle on one which meets all my needs, has a relatively straight forward (simple) usage and runs on the Raspberry Pi (without taking it to its knees). This might be the one... I have used it in the past, but not for a while now. Will give it a shot again... Thanks for the clear examples.

<hr>

Commenting on Scarlet Manuka's post:

In DateTime::Format::Duration->new(
pattern => '%Y years, %m months, %e days, %H hours, %M minutes, %S seconds'
one needs to add normalize => 1 to get the minutes etc. right


