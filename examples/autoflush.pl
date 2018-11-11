use 5.010;
use strict;
use warnings;

my $filename = 'data.txt';

open my $fh, '>', $filename or die;
$fh->autoflush;

print $fh "Hello World\n";
say -s $filename; # 12

print $fh "Hello Back\n";
say -s $filename; # 23

