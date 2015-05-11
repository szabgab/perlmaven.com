#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use DateTime::Format::ISO8601;

foreach my $str (
        '1983-10-12',
        '19850103',
        '1984-07-02T03:40:02',
        '1991-W02',
        ) {
    my $dt = DateTime::Format::ISO8601->parse_datetime( $str );
    say "String:   $str";
    say "DateTime: $dt";
    say '';
}

