#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use DateTime::Format::Strptime;

{
    my $strp = DateTime::Format::Strptime->new(
        pattern   => '%T',
    );
    my $str = '1984-07-02T03:40:02';
    my $dt = $strp->parse_datetime( $str );
    say "String:   $str";
    say "DateTime: $dt";
    say '';
}

{
    my $strp = DateTime::Format::Strptime->new(
        pattern  => '%Y/%m-%d %H:%M::%S',
    );
    my $str = '1984/07-02 03:40::02';
    my $dt = $strp->parse_datetime( $str );
    say "String:   $str";
    say "DateTime: $dt";
    say '';
}

{
    my $strp = DateTime::Format::Strptime->new(
        pattern  => '%B %d %Y',
    );
    my $str = 'July 02 1984';
    my $dt = $strp->parse_datetime( $str );
    say "String:   $str";
    say "DateTime: $dt";
    say '';
}

