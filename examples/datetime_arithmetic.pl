#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use DateTime;
use DateTime::Duration;

my $dt = DateTime->new(
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

my $day_before = $dt - DateTime::Duration->new( days => 1 );
say $day_before;

my $day_after = $dt + DateTime::Duration->new( days => 1 );
say $day_after;

my $year_before = $dt - DateTime::Duration->new( years => 1 );
say $year_before;

