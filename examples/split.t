use strict;
use warnings;

use Test::More;

plan tests => 1;
my @warnings;
BEGIN {
    $SIG{__WARN__} = sub { push @warnings, @_; };
}

my $str = "a,b,c";

# split /,/, $str;
# Useless use of split in void context

sub f {
    my @expected;
    my $x = split /,/, $str;
    if ($] < 5.012000) {
        push @expected, 'Use of implicit split to @_ is deprecated';
        is substr($warnings[0], 0, length($expected[0])), $expected[0], 'implicit warning';
    } else {
        is_deeply \@warnings, \@expected;
    }

    my $first_count = (length($x) ? scalar split(":", $x) : 0);
}

f();

