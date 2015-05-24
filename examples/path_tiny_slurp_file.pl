use strict;
use warnings;
use Path::Tiny qw(path);

my $filename = shift or die "Usage: $0 FILENAME";

my $content = path($filename)->slurp_utf8;
print $content;
