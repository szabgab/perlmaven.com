#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use LWP::Simple qw(get);

my $url = 'http://www.ted.com/talks/tim_berners_lee_the_year_open_data_went_worldwide';

my $html = get $url;

foreach my $script ($html =~ m{<script>(.*?)</script>}gs) {
    say $script;
    say '------';
}
