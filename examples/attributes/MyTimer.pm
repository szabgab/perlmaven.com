package MyTimer;
use strict;
use warnings;
use 5.010;
use Time::HiRes qw(time);

use Attribute::Handlers;

sub Timer :ATTR(CODE) {
    my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenumber) = @_;
    my $new = sub {
        my $start = time;
        my @results = $referent->(@_);
        my $end = time;
        say "Elapsed time: " . ($end-$start);
        return @results;
    };

    no warnings qw(redefine);
    *$symbol = $new;
}

1;
