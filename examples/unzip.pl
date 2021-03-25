use strict;
use warnings;
use 5.010;

use Archive::Any;

my $filename = shift or die "Usage: $0 path_to.zip\n";

my $archive = Archive::Any->new($filename);
if (not $archive) {
    say 'Not unzipped';
    exit;
}
if ($archive->is_naughty) {
    die 'Naughty';
}
for my $file ($archive->files) {
    say $file;
}

$archive->extract;

