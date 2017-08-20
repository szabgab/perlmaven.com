use strict;
use warnings;
use Path::Tiny;

my $str = "text to prepend\n";
my $filename = shift or die "Usage: $0 FILENAME\n";

my $content = path($filename)->slurp_utf8;;
path($filename)->spew_utf8($str, $content);
