#!/usr/bin/perl
use strict;
use warnings;

die "Usage: $0 FILENAMEs\n" if not @ARGV;

while (my $row = <>) {
    next if $row !~ /^\d+:/;
    # 0:00:00.800,0:00:05.500
    if ($row !~ /^\d+:\d\d:\d\d\.\d\d\d,\d+:\d\d:\d\d\.\d\d\d$/) {
        warn "timestamp in row $. in $ARGV is incorrectly formatted\n";
    }
}

