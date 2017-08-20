use strict;
use warnings;

my $str = "text to prepend\n";
my $filename = shift or die "Usage: $0 FILENAME\n";

open my $in,  '<:encoding(utf8)', $filename or die "Could not open '$filename' for reading";
local $/ = undef;  # turn on "slurp mode"
my $content = <$in>;
close $in;

open my $out, '>:encoding(utf8)', $filename or die "Could not open '$filename' for writing";
print $out $str;
print $out $content;

