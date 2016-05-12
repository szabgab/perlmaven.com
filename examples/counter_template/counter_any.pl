use strict;
use warnings;

use Path::Tiny qw(path);

my $inc = $ARGV[0] || 1;

my $data = path('counter.txt')->slurp_utf8;
my @pieces = split /(\d+)/, $data;
foreach my $p (@pieces) {
    if ($p =~ /\d/) {
        $p += $inc;
        print "$p\n";
    }
}
path('counter.txt')->spew_utf8( @pieces );

