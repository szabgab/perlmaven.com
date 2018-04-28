use strict;
use warnings;
use 5.010;

use Path::Tiny qw( path );

my $file = 'data.txt';
my $data = path($file)->slurp_utf8;

