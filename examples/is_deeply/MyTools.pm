package MyTools;
use strict;
use warnings;
use DateTime;

our $VERSION = '0.01';

use base 'Exporter';
our @EXPORT = qw(fibonacci fibo fetch_data_from_bug_tracking_system);

sub fibo {
    my @f = _fibonacci(@_);
    return $f[-1];
}
sub fibonacci {
    return [ _fibonacci(@_) ];
}

sub _fibonacci {
    my ($n) = @_;
    die "Need to get a number\n" if not defined $n;
    if ($n <= 0) {
        warn "Given number must be > 0";
        return 0;
    }
    return 1 if $n == 1;
    if ($n ==2 ) { 
        return (1, 1);
    }

    # add bug :-)
    if ($n == 5) {
        return (1, 1, 4, 3, 7);
    }

    my @fib = (1, 1);
    for (3..$n) {
        push @fib, $fib[-1]+$fib[-2];
    }
    return @fib;
}

sub fetch_data_from_bug_tracking_system {
    my @sets = (
        {   bugs     => 3,
            errors   => 6,
            failures => 8,
            warnings => 1,
        },
        {   bugs     => 3,
            errors   => 9,
            failures => 8,
            warnings => 1,
        },
        {   bogs     => 3,
            erors    => 9,
            failures => 8,
            warnings => 1,
        },
        {   bugs     => 'many',
            errors   => 6,
            failures => 8,
            warnings => 1,
        },
        {
            bugs => [
                {
                    ts   => time,
                    name => "System bug",
                    severity => 3,
                },
                {
                    ts    => time - int rand(100),
                    name  => "Incorrect severity bug",
                    severity => "extreme",
                },
                {
                    ts    => time - int rand(200),
                    name  => "Missing severity bug",
                },
            ],
        },    
    );
    my $h = $sets[shift];
    return %$h;
}

1;
