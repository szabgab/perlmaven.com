use 5.010;
use strict;
use warnings;

use Getopt::Long qw(GetOptions);
use Image::Magick;

my $server = 'localhost';
my $verbose;

GetOptions(
    'server:s' => \$server,
    'verbose'  => \$verbose,
) or die;

say "running on $]...";

if ($verbose) {
    say $server;
}

