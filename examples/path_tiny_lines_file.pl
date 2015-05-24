use strict;
use warnings;
use Path::Tiny qw(path);

my $filename = shift or die "Usage: $0 FILENAME";

my @content = path($filename)->lines_utf8;
foreach my $row (@content) {
    print $row;
}
