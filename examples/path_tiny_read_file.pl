use strict;
use warnings;
use Path::Tiny qw(path);

my $filename = shift or die "Usage: $0 FILENAME";

my $fh = path($filename)->openr_utf8;
while (my $row = <$fh>) {
    print $row;
}
cloes $fh;

