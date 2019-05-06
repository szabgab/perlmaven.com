use 5.010;
use strict;
use warnings;
no warnings 'once';

my $num = shift or die "Usage: $0 N\n";
say fibonacci($num);

sub fibonacci {
    my ($n) = @_;

    $DB::single = 1 if $n == 6;

    return 1 if $n == 1 or $n == 2;
    return fibonacci($n-1) + fibonacci($n-2);
}

