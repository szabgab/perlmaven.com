use strict;
use warnings;
use File::Slurper 'read_text';

my $filename = shift or die "Usage: $0 FILENAME";

my $content = read_text($file);
print $content;
