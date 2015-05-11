#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use DateTime;
my $dt = DateTime->now;

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

say $dt;
say $dt->ymd;
say $dt->ymd('_');
say $dt->hms;
say $dt->epoch;

say $dt->year;
say $dt->month;
say $dt->day;


say $dt->strftime( '%Y-%m-%d-%H-%M-%S' );

