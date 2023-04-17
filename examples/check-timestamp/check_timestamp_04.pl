#!/usr/bin/perl
use strict;
use warnings;

die "Usage: $0 FILENAMEs\n" if not @ARGV;

my $last_end = '';

while (my $row = <>) {
    next if $row !~ /^\d+:/;
    # 0:00:00.800,0:00:05.500
    if ($row =~ /^(\d+:\d\d:\d\d\.\d\d\d),(\d+:\d\d:\d\d\.\d\d\d)$/) {
        my ($start, $end) = ($1, $2);
        if ($last_end) {
            if ($last_end ne $start) {
                warn "Mismatch in timestamps at row $. in $ARGV : previous end: '$last_end' current start: '$start'\n";
            }
        }
        $last_end = $end;
    } else {
        warn "timestamp in row $. in $ARGV is incorrectly formatted\n";
    }
} continue {
    close ARGV if eof;
}


