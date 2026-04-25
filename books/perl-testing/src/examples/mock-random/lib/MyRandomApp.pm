package MyRandomApp;
use strict;
use warnings;

use Exporter qw(import);
our @EXPORT_OK = qw(dice);

sub dice {
    my ($n) = @_;
    my $rnd = rand();
    # print "dice: $rnd\n";
    return 1 + int($rnd * $n);
}

1;

