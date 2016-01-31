#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use LWP::Simple qw(get);
use JSON qw(decode_json);
use Data::Dumper qw(Dumper);
use Encode qw(encode);

my $url = 'http://www.ted.com/talks/tim_berners_lee_the_year_open_data_went_worldwide';

my $html = get $url;

foreach my $script ($html =~ m{<script>(.*?)</script>}gs) {
	my ($json) = $script =~ /^q\("talkPage\.init",(\{"talks".*)\)/s;
    next if not $json;
    my $data = decode_json encode('utf8', $json);
	print Dumper $data;
}

