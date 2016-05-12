use strict;
use warnings;

use Path::Tiny qw(path);

my $inc = $ARGV[0] || 1;

my $data = path('counter.txt')->slurp_utf8;
$data =~ s/(\d+)/ $1 + $inc /ge;
foreach my $p ($data =~ /(\d+)/g) {
    print "$p\n";
}
path('counter.txt')->spew_utf8($data);

