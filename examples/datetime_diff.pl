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
my $other = DateTime->new(
    year       => 2011,
    month      => 10,
    day        => 7,
    hour       => 10,
    minute     => 20,
    second     => 40,
    time_zone  => 'America/Los_Angeles',
);

say $dt;
say $other;

my $diff = $other - $dt;
say $diff;


use DateTime::Format::Duration;
my $dfd = DateTime::Format::Duration->new(
        pattern => '%Y years, %m months, %e days, %H hours, %M minutes, %S seconds'
);
say $dfd->format_duration($diff);
 
my $dfd_t = DateTime::Format::Duration->new(
        pattern => '%Y-%m-%d %H:%M:%S'
);
say $dfd_t->format_duration($diff);
 
