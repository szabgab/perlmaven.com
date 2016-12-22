use 5.010;
use strict;
use warnings;

use File::Temp qw(tempdir);
my $dir = tempdir( CLEANUP => 1 );

my $filename = "$dir/blabla.txt";

sleep 1;

open my $fh, '>', $filename or die;
print $fh "Hello World";
close $fh;

say -M $filename;
