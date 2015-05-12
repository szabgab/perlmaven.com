use strict;
use warnings;
use 5.010;

my @in = ('a', 'd');

use File::Temp qw(tempdir);
my $dir = tempdir( CLEANUP => 1 );
my $infile = "$dir/in.txt";
open my $fh, '>', $infile or die;
say $fh $_ for @in;
close $fh;

my $output = qx{perl exe.pl < $infile};
say '-----------';
say $output;

