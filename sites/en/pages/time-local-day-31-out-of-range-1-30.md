---
title: "Time::Local - Day '31' out of range 1..30"
timestamp: 2006-08-31T14:51:30
tags:
  - Time::Local
published: true
archive: true
---



Posted on 2006-08-31 14:51:30-07 by realmelancon

Hello, I have a simple function that converts date, time in epoch format,
and it fails when I use 31 as day. See excerpt:

```perl
#!/usr/bin/perl
#--------------------------------------------------------------------------
use Time::Local;

print "\n\n".time2sec("2006/10/31","11:00:01");
print "\n";
exit;

sub time2sec {
   #------------- converts date+time to second ------
   # e.g. time2sec("2006/03/10","11:00:01");
   ($date, $time) = @_;
   $year = substr($date,0,4);
   $mon = substr($date,5,2);
   $mday = substr($date,8,2);
   $hours = substr($time,0,2);
   $min = substr($time,3,2);
   $sec = substr($time,6,2);
   $STIME="";
   if ($mon > 0) {
      $STIME = timelocal($sec, $min, $hours, $mday, $mon, $year);
   }
   return $STIME;
}
```

FYI, I have installed latest Time-Local-1.13.tar.gz and I still get the same error.
If I use 30 as day it works... But all months with 31 days fail.
Message is: `Day '31' out of range 1..30`
Any help would be appreciated. Thanks.

Real Melancon.

Posted on 2006-09-18 21:36:11-07 by methylal in response to 2881

Looking at the module:

You will see that Months are set in an array:

```perl
my @MonthDays = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
```


Therefore, when it tries to pull the number of days for the month you passed to it,
it's searching it's index from 0 to 11.
So when you pass in your Month as 10 (October), it's searching the array
and thinking only 30 days are avilable and failing when you specify 31
since you are technically 'out of range'.

Three solutions:

1) Subtract 1 from your month before passing it into the Time::timelocal method

2) Just open up your Local.pm file and in the subroutine (timegm), look for the following:

```perl
my $md = $MonthDays[$month];
```

and subtract 1 from $month... so:

```perl
my $md = $MonthDays[$month-1];
```

3) Use DateTime::Precise instead.

--meth

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/2881 -->

